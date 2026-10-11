"""Ön eleme: şık yapısı ve doğrulama kodu kuralları (model kullanmadan)."""
from pipeline import on_eleme


def _soru(**sec):
    return {"kok": "Aşağıdakilerden hangisi doğrudur?", "dogru": "C",
            "secenekler": {"A": "Birinci seçenek", "B": "İkinci seçenek", "C": "Üçüncü seçenek",
                           "D": "Dördüncü seçenek", "E": "Beşinci seçenek", **sec}}


def test_dengeli_siklar_gecer():
    assert on_eleme.sik_sorunlari(_soru()) == []


def test_tek_olumlu_sik_cevabi_ele_verir():
    s = _soru(A="Matraha girmez", B="Matraha girmez ve istisnadır", C="Matraha girer",
              D="Hiçbir durumda matraha girmez", E="Yalnız beyanda matraha girmez")
    assert any("[K10]" in h for h in on_eleme.sik_sorunlari(s))


def test_dogru_sik_belirgin_uzun():
    s = _soru(C="Üçüncü seçenek ayrıntılı bir açıklama ile birlikte gelen ve diğerlerinden çok uzun olan şık")
    assert any("en uzun" in h for h in on_eleme.sik_sorunlari(s))


def test_yasak_sik():
    assert any("[K11]" in h for h in on_eleme.sik_sorunlari(_soru(E="Hiçbiri")))


def test_yasak_kod_yapilari():
    for kod in ("import math", "sonuc = int(5)", "sonuc = sum(x for x in [1])", "sonuc = [x for x in y]"):
        assert on_eleme.YASAK_KOD.search(kod), kod
    assert not on_eleme.YASAK_KOD.search("x = 0\nfor i in range(3):\n    x += i\nsonuc = round(x * 1.5, 2)")
