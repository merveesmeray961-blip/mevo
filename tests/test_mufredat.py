"""Müfredat ağacının sınav formatıyla tutarlılığı."""

from pathlib import Path

import pytest
import yaml

KOK = Path(__file__).resolve().parent.parent
MUFREDAT = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
DERSLER = MUFREDAT["dersler"]


def test_ders_kodlari_benzersiz():
    kodlar = [d["kod"] for d in DERSLER]
    assert len(kodlar) == len(set(kodlar))


def test_yeterlilik_toplam_160_soru():
    assert sum(d["soru"].get("yet", 0) for d in DERSLER) == 8 * 20


def test_sgs_toplam_130_soru():
    assert sum(d["soru"].get("sgs", 0) for d in DERSLER) == 130


@pytest.mark.parametrize("bolum", ["yet", "sgs"])
def test_konu_agirliklari_100(bolum):
    for ders in DERSLER:
        if not ders["soru"].get(bolum) or ders.get("durum") == "sonraki_surum":
            continue
        toplam = sum(k["agirlik"].get(bolum, 0) for k in ders["konular"])
        assert toplam == pytest.approx(100), f"{ders['kod']} {bolum}: {toplam}"


def test_konu_kodlari_ders_icinde_benzersiz():
    for ders in DERSLER:
        kodlar = [k["kod"] for k in ders["konular"]]
        assert len(kodlar) == len(set(kodlar)), ders["kod"]
