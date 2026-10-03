"""G4 hesap ve G7 özgünlük kapılarının testleri (yapay örnekler)."""

from pipeline.g4_hesap import sayiya_cevir, soru_denetle
from pipeline.g7_ozgunluk import Kulliyat, banka_denetle, parcalar


def hesap_sorusu(**d):
    s = {
        "id": "SMMM-TST-HSP-0001", "tip": "hesaplama", "dogru": "C",
        "secenekler": {"A": "100.000 ₺", "B": "120.000 ₺", "C": "150.000 ₺", "D": "180.000 ₺", "E": "200.000 ₺"},
        "dogrulama": {"python": "sonuc = 500_000 * 0.30"},
    }
    s.update(d)
    return s


def test_sayi_okuma():
    assert sayiya_cevir("1.250.000 ₺") == 1250000
    assert sayiya_cevir("%12,50") == 12.5
    assert sayiya_cevir("0,875") == 0.875
    assert sayiya_cevir("Borç 100, Alacak 200") is None


def test_dogru_hesap_gecer():
    assert soru_denetle(hesap_sorusu()).gecti


def test_yanlis_anahtar_kalir():
    assert not soru_denetle(hesap_sorusu(dogru="B")).gecti


def test_ceteldirici_ayni_deger_kalir():
    s = hesap_sorusu()
    s["secenekler"]["E"] = "150.000 ₺"
    assert any("çeldirici" in h for h in soru_denetle(s).hatalar)


def test_sirasiz_siklar_kalir():
    s = hesap_sorusu()
    s["secenekler"]["A"], s["secenekler"]["B"] = s["secenekler"]["B"], s["secenekler"]["A"]
    assert any("sıralı" in h for h in soru_denetle(s).hatalar)


def test_import_yasak():
    assert not soru_denetle(hesap_sorusu(dogrulama={"python": "import os\nsonuc=1"})).gecti


def test_dogrulamasiz_hesap_kalir():
    s = hesap_sorusu()
    del s["dogrulama"]
    assert not soru_denetle(s).gecti


def test_ozgunluk_kulliyat_benzerligi():
    metin = "işletmenin dönem sonunda yaptığı sayımda kasada eksiklik tespit edilmiş ve nedeni araştırılmaktadır"
    k = Kulliyat(parca_kumesi=parcalar(metin))
    kopya = {"id": "X", "kok": metin, "secenekler": {}}
    ozgun = {"id": "Y", "kok": "Bambaşka kelimelerle yazılmış tamamen özgün bir soru kökü burada yer almaktadır efendim", "secenekler": {}}
    sonuc = banka_denetle([kopya, ozgun], k)
    assert "X" in sonuc and "Y" not in sonuc


def test_ozgunluk_ortak_veri_ciftleri_atlanir():
    tablo = "kalem 2024 2025 2026 hazır değerler 60 70 100 ticari alacaklar 120 140 160 stoklar 130 145 175 " * 3
    a = {"id": "A", "kok": tablo + " stok devir süresi kaç gündür", "secenekler": {}, "ortak_veri": "SET-1"}
    b = {"id": "B", "kok": tablo + " cari oran kaçtır", "secenekler": {}, "ortak_veri": "SET-1"}
    c = {"id": "C", "kok": tablo + " likidite oranı kaçtır", "secenekler": {}}
    sonuc = banka_denetle([a, b, c], None)
    assert not any("B ile" in h for h in sonuc.get("A", []))
    assert any("C ile" in h for h in sonuc.get("A", []))
