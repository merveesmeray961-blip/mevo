"""G2 yapısal kapısının testleri.

Buradaki soru metinleri yalnızca test amaçlı yapay örneklerdir; içerik doğruluğu iddiası taşımaz.
"""

import copy

from pipeline.g2_yapi import banka_denetle, soru_denetle

ORNEK = {
    "id": "SMMM-TST-ORN-0001",
    "sinav": "smmm",
    "bolum": ["YET"],
    "ders": "test_dersi",
    "konu": "test konusu",
    "kazanim": "test kazanımı",
    "tip": "bilgi",
    "zorluk": 2,
    "kok": "Aşağıdakilerden hangisi test amaçlı yazılmış bir soru köküdür?",
    "secenekler": {"A": "Birinci şık", "B": "İkinci şık", "C": "Üçüncü şık", "D": "Dördüncü şık", "E": "Beşinci şık"},
    "dogru": "C",
    "aciklama": {
        "dogru_neden": "Üçüncü şık test için doğru kabul edilmiştir.",
        "celdiriciler": {"A": "Test çeldiricisi.", "B": "Test çeldiricisi.", "D": "Test çeldiricisi.", "E": "Test çeldiricisi."},
    },
    "kaynaklar": [{"mevzuat": "Test Kanunu", "madde": "md. 1"}],
    "gecerlilik": {"baslangic": "2026-01-01"},
    "durum": "taslak",
    "surum": 1,
    "uretim": {"kaynak_turu": "insan"},
}


def ornek(**degisiklik):
    soru = copy.deepcopy(ORNEK)
    soru.update(degisiklik)
    return soru


def test_gecerli_soru_gecer():
    sonuc = soru_denetle(ornek())
    assert sonuc.gecti, sonuc.hatalar


def test_eksik_sik_sema_hatasi():
    soru = ornek()
    del soru["secenekler"]["E"]
    assert not soru_denetle(soru).gecti


def test_ayni_sik_metni_hata():
    soru = ornek()
    soru["secenekler"]["B"] = "birinci  şık."
    assert any("aynı şık" in h for h in soru_denetle(soru).hatalar)


def test_celdirici_aciklamasi_eksik():
    soru = ornek()
    del soru["aciklama"]["celdiriciler"]["E"]
    assert any("çeldirici" in h for h in soru_denetle(soru).hatalar)


def test_dogru_sikka_celdirici_aciklamasi_hata():
    soru = ornek()
    soru["aciklama"]["celdiriciler"]["C"] = "Olmaması gereken açıklama."
    assert any("çeldirici" in h for h in soru_denetle(soru).hatalar)


def test_olumsuz_kok_kalin_degilse_hata():
    soru = ornek(kok="Aşağıdakilerden hangisi test amaçlı bir kök değildir?")
    assert any("olumsuz" in h for h in soru_denetle(soru).hatalar)


def test_olumsuz_kok_kalinsa_gecer():
    soru = ornek(kok="Aşağıdakilerden hangisi test amaçlı bir kök **değildir**?")
    assert soru_denetle(soru).gecti


def test_hesaplama_adimsiz_hata():
    assert any("hesap_adimlari" in h for h in soru_denetle(ornek(tip="hesaplama")).hatalar)


def test_yila_bagli_tutar_yilsiz_hata():
    soru = ornek(gecerlilik={"baslangic": "2026-01-01", "yila_bagli_tutar": True})
    assert any("yil" in h for h in soru_denetle(soru).hatalar)


def test_yayindaki_soru_kapisiz_hata():
    assert any("kapılar" in h for h in soru_denetle(ornek(durum="yayinda")).hatalar)


def test_yayindaki_soru_tum_kapilarla_gecer():
    kapilar = {k: {"sonuc": "gecti"} for k in ("G0", "G1", "G2", "G3", "G5", "G6", "G7", "G8")}
    soru = ornek(durum="yayinda", uretim={"kaynak_turu": "yapay_zeka", "kapilar": kapilar})
    assert soru_denetle(soru).gecti


def test_dogru_sik_en_uzun_uyari():
    soru = ornek()
    soru["secenekler"]["C"] = "Bu şık diğerlerinden belirgin biçimde çok daha uzun yazılmış bir metindir"
    assert soru_denetle(soru).uyarilar


def test_banka_kimlik_tekrari():
    rapor = banka_denetle([("a", ornek()), ("b", ornek(kok="Farklı bir test kökü burada yer alıyor mu?"))])
    assert any("kimlik" in h for h in rapor.banka_hatalari)


def test_banka_ayni_kok():
    rapor = banka_denetle([("a", ornek()), ("b", ornek(id="SMMM-TST-ORN-0002"))])
    assert any("kök" in h for h in rapor.banka_hatalari)
