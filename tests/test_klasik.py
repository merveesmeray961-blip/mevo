"""Klasik soru hattı: yapı denetimi, puan toplamı ve doğrulama kodu."""
from pipeline import klasik


def _soru(**degisen):
    k = {
        "id": "YMM-YNM-MHK-K001", "sinav": "ymm", "ders": "YNM", "konu": "MHK", "kazanimlar": ["başabaş noktası"],
        "zorluk": 2, "puan": 20, "sure_dk": 25,
        "soru": "A işletmesinin birim satış fiyatı 50 TL, birim değişken maliyeti 30 TL, sabit giderleri 100.000 TL'dir. "
                "(a) Başabaş noktasını bulunuz (20 puan)",
        "cozum": "Birim katkı payı 50 − 30 = 20 TL. Başabaş noktası = 100.000 / 20 = 5.000 adet; satış tutarı "
                 "5.000 × 50 = 250.000 TL. Bu miktarın altındaki satışlarda işletme zarar eder.",
        "puanlama": [{"olcut": "Katkı payı", "puan": 8}, {"olcut": "Başabaş miktarı ve tutarı", "puan": 12}],
        "kaynaklar": [{"mevzuat": "Genel bilgi — maliyet hacim kâr", "madde": "-"}],
        "dogrulama": {"python": "sonuc = {'adet': 100000 / 20, 'tutar': 100000 / 20 * 50}"},
        "gecerlilik": {"baslangic": "2026-01-01", "bitis": None},
        "durum": "taslak", "surum": 1, "uretim": {"kaynak_turu": "yapay_zeka"},
    }
    k.update(degisen)
    return k


def test_gecerli_soru_hatasiz():
    assert klasik.denetle(_soru(), klasik._konular("ymm")) == []


def test_puan_toplami_tutmazsa_hata():
    hatalar = klasik.denetle(_soru(puan=25))
    assert any("puanlama toplamı" in h for h in hatalar)


def test_dogrulama_sonucu_cozumde_yoksa_hata():
    hatalar = klasik.denetle(_soru(dogrulama={"python": "sonuc = {'adet': 4000}"}))
    assert any("çözümde yok" in h for h in hatalar)


def test_mufredatta_olmayan_konu():
    assert any("müfredatta yok" in h for h in klasik.denetle(_soru(konu="XXX"), klasik._konular("ymm")))
