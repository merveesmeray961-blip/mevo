import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "docs/devir/araclar"))

from para_birimi import _gez, cevir  # noqa: E402


def test_tutar_ve_ek_uyumu():
    assert cevir("Tutar 100.000 TL'dir.") == "Tutar 100.000 ₺'dır."
    assert cevir("1.250,50 TL’ye") == "1.250,50 ₺'ya"
    assert cevir("2 bin TL'lik") == "2 bin ₺'lık"
    assert cevir("(bin TL)") == "(bin ₺)"


def test_sayisiz_tl_ve_virgul_dokunulmaz():
    assert cevir("KDV %20, TL cinsinden") == "KDV %20, TL cinsinden"
    assert cevir("TLX 8") == "TLX 8"


def test_alinti_ve_dogrulama_korunur():
    s = {"kok": "500 TL", "kaynaklar": [{"alinti": "500 TL"}], "dogrulama": {"python": "x = '500 TL'"}}
    yeni = _gez(s, [0])
    assert yeni["kok"] == "500 ₺"
    assert yeni["kaynaklar"][0]["alinti"] == "500 TL"
    assert yeni["dogrulama"]["python"] == "x = '500 TL'"
