"""Konu anlatımı denetimi: HTML kuralı ve dış teslim ön elemesi."""

import pytest

from pipeline import anlatim

_GOVDE = "## Giriş\n" + "kelime " * anlatim.EN_AZ_KELIME


def _hatalar(metin: str) -> list[str]:
    return anlatim.denetle({"ders": "D", "konu": "K", "baslik": "B"}, metin, {"D": {"K"}})


def test_kucuktur_isareti_html_sayilmaz():
    assert _hatalar(_GOVDE + "\nρ < +1 ise; %5 < %10; Süre < azami süre\n") == []


@pytest.mark.parametrize("parca", ["<b>kalın</b>", "satır</p>", "<!-- not -->", "[bağlantı](https://x)"])
def test_etiket_ve_baglanti_reddedilir(parca):
    assert any("HTML" in h for h in _hatalar(_GOVDE + parca))


def test_on_eleme_ayni_konu_kodu_farkli_derste_ezilmez(tmp_path):
    for ders in ("IFM", "DTK"):
        (tmp_path / ders).mkdir()
        (tmp_path / ders / "VRG.md").write_text(f"---\nders: {ders}\nkonu: VRG\n---\n## A\nmetin\n", encoding="utf-8")
    rapor = anlatim.on_eleme(tmp_path, "ymm")
    assert sum(1 for s in rapor if s.startswith("- ")) == 2
