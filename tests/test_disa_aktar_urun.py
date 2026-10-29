"""İki ayrı uygulama paketi (SMMM, YMM): içerik karışmaz, her paket kendi ürününü taşır."""

import json

import pytest

from pipeline import disa_aktar


@pytest.fixture(scope="module")
def paketler(tmp_path_factory):
    klasor = tmp_path_factory.mktemp("paketler")
    sonuc = {}
    for urun in disa_aktar.URUNLER:
        hedef = klasor / f"{urun}.json"
        ozet = disa_aktar.aktar(hedef, puf_ayir=True, urun=urun)
        sonuc[urun] = (json.loads(hedef.read_text(encoding="utf-8")), ozet)
    return sonuc


def test_paket_kendi_urununu_tasir(paketler):
    for urun, (paket, _) in paketler.items():
        assert paket["urun"] == urun


def test_smmm_paketinde_ymm_icerigi_yok(paketler):
    paket, _ = paketler["smmm"]
    assert set(paket["formatlar"]) == {"SGS", "YET"}
    assert not paket.get("klasik")
    assert all("YMM" not in s["bolum"] for s in paket["sorular"])
    assert all(s["id"].startswith("SMMM-") for s in paket["sorular"])
    assert all(not a["ders"] in {"IFM", "FYN", "YNM", "SPM", "REV", "VTK", "GUV", "HSV", "DTK", "DRM"}
               for a in paket["anlatimlar"])


def test_ymm_paketinde_smmm_icerigi_yok(paketler):
    paket, ozet = paketler["ymm"]
    assert set(paket["formatlar"]) == {"YMM"}
    assert all(s["bolum"] == ["YMM"] for s in paket["sorular"])
    assert all(s["id"].startswith("YMM-") for s in paket["sorular"])
    assert len(paket["klasik"]) == 300
    assert ozet["klasik"] == 300
    # YMM müfredatı 10 dersten oluşur; SMMM dersleri pakete girmez.
    assert set(paket["dersler"]) == {"IFM", "FYN", "YNM", "SPM", "REV", "VTK", "GUV", "HSV", "DTK", "DRM"}


def test_paketler_hatasiz_uretilir(paketler):
    for urun, (_, ozet) in paketler.items():
        assert ozet["elenen"] == [], f"{urun}: {ozet['elenen'][:3]}"


def test_ymm_paketinde_smmm_derslerine_ait_anlatim_yok(paketler):
    paket, _ = paketler["ymm"]
    ymm_dersleri = set(paket["dersler"])
    assert paket["anlatimlar"], "YMM paketinde anlatım olmalı"
    assert all(a["ders"] in ymm_dersleri for a in paket["anlatimlar"])


def test_bilinmeyen_urun_reddedilir(tmp_path):
    with pytest.raises(ValueError, match="bilinmeyen ürün"):
        disa_aktar.aktar(tmp_path / "x.json", urun="spk")


def test_argumanlar_urun_degerini_yol_sanmaz(tmp_path):
    hedef, uygulama, urun = disa_aktar.argumanlari_coz(
        ["x", "app/assets/sorular/ymm.json", "--uygulama", "--urun", "ymm"]
    )
    assert (str(hedef).replace("\\", "/"), uygulama, urun) == ("app/assets/sorular/ymm.json", True, "ymm")
    _, uygulama, urun = disa_aktar.argumanlari_coz(["x", "a.json"])
    assert (uygulama, urun) == (False, "smmm")


def test_urun_degeri_eksikse_hata():
    with pytest.raises(ValueError, match="--urun"):
        disa_aktar.argumanlari_coz(["x", "a.json", "--urun"])
