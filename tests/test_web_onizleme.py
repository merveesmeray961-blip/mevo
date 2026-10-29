"""Web önizleme betiği: pubspec düzenlemesi ve geçici kopya (Flutter çalıştırılmaz)."""

import importlib.util
from pathlib import Path

import pytest

KOK = Path(__file__).resolve().parents[1]
_ozellik = importlib.util.spec_from_file_location("web_onizleme", KOK / "docs/devir/araclar/web_onizleme.py")
web_onizleme = importlib.util.module_from_spec(_ozellik)
_ozellik.loader.exec_module(web_onizleme)

PUBSPEC = (KOK / "app/pubspec.yaml").read_text(encoding="utf-8")


@pytest.mark.parametrize("urun", ["smmm", "ymm"])
def test_pubspec_secilen_paketi_bayraksiz_ekler(urun):
    yeni = web_onizleme.pubspec_duzenle(PUBSPEC, urun)
    diger = "ymm" if urun == "smmm" else "smmm"
    girdiler = [s.strip() for s in yeni.splitlines() if s.strip().startswith(("- assets/sorular/", "- path: assets/sorular/"))]
    assert girdiler == [f"- assets/sorular/{urun}.paket"], f"{diger} paketi asset listesinde kalmamalı"
    assert "flavors:" not in yeni
    assert "default-flavor" not in yeni


def test_pubspec_beklenen_bicimde_degilse_hata():
    with pytest.raises(RuntimeError, match="bayraklı"):
        web_onizleme.pubspec_duzenle("flutter:\n  assets:\n    - x\n", "ymm")


def test_depodaki_pubspec_degismez(tmp_path):
    once = (KOK / "app/pubspec.yaml").read_text(encoding="utf-8")
    web_onizleme.pubspec_duzenle(once, "ymm")
    assert (KOK / "app/pubspec.yaml").read_text(encoding="utf-8") == once
    assert "flavors: [smmm]" in once and "flavors: [ymm]" in once
