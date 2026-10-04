"""Uygulamanın Mevzuat bölümü verisi: gruplama, madde normalleştirme, telif kuralı (standart metni yok)."""

import re

import pytest

from pipeline import kaynak, mevzuat_paketi as mp


def soru(sid, *kaynaklar):
    return {"id": sid, "kaynaklar": [{"mevzuat": a, "madde": b, "alinti": c} for a, b, c in kaynaklar]}


def sahte_metin(kod, anahtar):
    return ("Başlık", f"Madde {anahtar} – tam metin {kod}")


KVK = "5520 sayılı Kurumlar Vergisi Kanunu"
TMS2 = "TMS 2 Stoklar"


@pytest.mark.parametrize("ham, etiket, anahtar", [
    ("md. 26/1-(ç)", "md. 26", "26"),
    ("md. 32/C-1, 2-a", "md. 32/C", "32/C"),
    ("mük. md. 80/3, 80/4", "mük. md. 80", "mükerrer 80"),
    ("md. 110/A-(1) (Ek: 26/6/2024-7518/13 md.)", "md. 110/A", "110/A"),
    ("md. 10/b, c, d", "md. 10", "10"),
    ("md. 5/1-a(1)", "md. 5", "5"),
    ("md. 344 (7524 ile eklenen fıkra)", "md. 344", "344"),
])
def test_kanun_madde_normallestirme(ham, etiket, anahtar):
    assert mp.madde_normallestir(ham, KVK, "kvk") == (etiket, anahtar)


def test_standart_paragraf_normallestirme_ve_anahtarsiz():
    assert mp.madde_normallestir("par. 16(c)", TMS2, None) == ("par. 16", None)
    assert mp.madde_normallestir("parag. A21", "BDS 450 Başlık", None) == ("par. A21", None)


def test_gruplama_ve_tekillestirme():
    sorular = [
        soru("S1", (KVK, "md. 12/1", "alıntı bir")),
        soru("S2", (KVK, "md. 12/3-b", "alıntı iki"), (KVK, "md. 9/1-a", "dokuz")),
        soru("S1", (KVK, "md. 12/1", "alıntı bir")),  # tekrar: çift kayıt oluşmaz
    ]
    r = mp.kaynaklari_derle(sorular, sahte_metin)
    m12 = next(x for x in r if x["madde"] == "md. 12")
    assert m12["soru_idler"] == ["S1", "S2"]
    assert [(a["atif"], a["soru_id"]) for a in m12["alintilar"]] == [("md. 12/1", "S1"), ("md. 12/3-b", "S2")]
    assert m12["kod"] == "kvk" and m12["tam_metin"].startswith("Madde 12") and m12["baslik"] == "Başlık"
    assert "MevzuatNo=5520" in m12["mevzuat_gov_url"] and "MevzuatTur=1" in m12["mevzuat_gov_url"]
    assert [x["madde"] for x in r] == ["md. 9", "md. 12"]  # madde numarasına göre sıralı


def test_ad_esleme_ve_msugt_birlestirme():
    sorular = [
        soru("S1", ("Muhasebe Sistemi Uygulama Genel Tebliği (Sıra No:1), Ek V Hesap Planı Açıklamaları", "191 İndirilecek KDV", "a")),
        soru("S2", ("Muhasebe Sistemi Uygulama Genel Tebliği (Sıra No:1) — Ek-4 Mali Tabloların Düzenlenmesi ve Sunulması", "A-2-e) Satışların Maliyeti Tablosu", "b")),
        soru("S3", ("SMMM ve YMM Mesleklerine İlişkin Haksız Rekabet ve Reklam Yasağı Yönetmeliği", "md. 18", "c")),
        soru("S4", ("Serbest Muhasebeci Mali Müşavirlik ve Yeminli Mali Müşavirlik Mesleklerine İlişkin Haksız Rekabet ve Reklam Yasağı Yönetmeliği", "md. 18/2", "d")),
    ]
    r = mp.kaynaklari_derle(sorular, sahte_metin)
    assert {x["kaynak"] for x in r if x["kaynak"].startswith("Muhasebe")} == {mp.MSUGT}
    assert {x["madde"] for x in r if x["kaynak"] == mp.MSUGT} == {
        "Ek-5 · 191 İndirilecek KDV", "Ek-4 · A-2-e) Satışların Maliyeti Tablosu"}
    haksiz = [x for x in r if "Haksız Rekabet" in x["kaynak"]]
    assert len(haksiz) == 1 and haksiz[0]["soru_idler"] == ["S3", "S4"] and "tam_metin" not in haksiz[0]


def test_standart_ve_bilinmeyen_kaynakta_tam_metin_yok():
    sorular = [soru("S1", (TMS2, "par. 11", "stok alıntısı"), ("TFRS 15 Müşteri Sözleşmelerinden Hasılat", "par. 74", "x"),
                    ("BDS 450 Yanlışlıklar", "parag. 6(b)", "y"), ("Bilinmeyen Tebliğ (Seri 9)", "md. 3", "z"))]
    r = mp.kaynaklari_derle(sorular, sahte_metin)  # sahte getirici bile çağrılmamalı
    assert len(r) == 4
    for x in r:
        assert "tam_metin" not in x and "kod" not in x and x["alintilar"]


def test_url_yalniz_kanunda():
    r = mp.kaynaklari_derle([soru("S1", ("193 sayılı Gelir Vergisi Kanunu", "md. 21/2", "a"), (TMS2, "par. 9", "b"))], sahte_metin)
    gvk = next(x for x in r if x["tur"] == "kanun")
    assert gvk["mevzuat_gov_url"].endswith("MevzuatNo=193&MevzuatTur=1&MevzuatTertip=4")
    assert all("mevzuat_gov_url" not in x for x in r if x["tur"] != "kanun")


def test_eksik_madde_yalniz_alinti_kalir():
    def yok(kod, anahtar):
        raise KeyError(anahtar)
    r = mp.kaynaklari_derle([soru("S1", (KVK, "md. 999/1", "a"))], yok)
    assert "tam_metin" not in r[0] and r[0]["kod"] == "kvk"


def test_ad_kod_tablosundaki_kodlar_gecerli():
    assert set(mp.AD_KOD.values()) <= set(kaynak.KANUNLAR)
    assert set(mp.GOV_NO) <= set(kaynak.KANUNLAR)


@pytest.mark.skipif(not (kaynak.MEVZUAT / "kvk.txt").exists(), reason="mevzuat metinleri yerelde yok (gitignore)")
def test_gercek_paket_telif_kurali():
    import json
    paket = json.loads((kaynak.KOK / "app/assets/sorular/smmm.json").read_text(encoding="utf-8"))
    assert paket["mevzuat_tarihi"] == "2026-10-04"
    for x in paket["mevzuat"]:
        if re.match(r"(TMS|TFRS|BDS|KYS)\s", x["kaynak"]) or x["tur"] != "kanun":
            assert "tam_metin" not in x, x["kaynak"]
        assert x["soru_idler"]
    assert any(x.get("tam_metin") for x in paket["mevzuat"])
