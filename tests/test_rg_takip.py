"""Resmî Gazete takibi: ayrıştırma, terim eşleştirme, rapor (ağ yok; yapay sayfa tests/veri/rg_ornek.htm)."""

from datetime import date
from pathlib import Path

import pytest

from pipeline import rg_takip as rg

FIXTURE = Path(__file__).parent / "veri" / "rg_ornek.htm"

KAYNAKLAR = {
    "213 sayılı Vergi Usul Kanunu": {"Q-VUK-1", "Q-VUK-2"},
    "6102 sayılı Türk Ticaret Kanunu": {"Q-TTK-1"},
    "193 sayılı Gelir Vergisi Kanunu": {"Q-GVK-1"},
    "Gelir Vergisi Genel Tebliği (Seri No: 332), RG 31.12.2025, 33124 (5. Mük.)": {"Q-GVK-2"},
    "KGK Bağımsız Denetim Yönetmeliği": {"Q-DEN-1"},
    "TMS 2 Stoklar": {"Q-STK-1"},
    "5510 sayılı Sosyal Sigortalar ve Genel Sağlık Sigortası Kanunu": {"Q-SGK-1"},
    "6362 sayılı Sermaye Piyasası Kanunu": {"Q-SPK-1"},
    "Muhasebe Sistemi Uygulama Genel Tebliği (Sıra No:1)": {"Q-THP-1"},
}


def test_normallestirme():
    assert rg.normallestir("İŞ KANUNU’NDA Değişiklik") == "iş kanununda değişiklik"
    assert rg.normallestir("Malî  Müşavirlik, ILIK") == "mali müşavirlik ılık"


@pytest.mark.parametrize("baslik, terim, beklenen", [
    ("Vergi Usul Kanunu ile Bazı Kanunlarda", "Vergi Usul", True),
    ("Bağımsız Denetim Yönetmeliğinde Değişiklik", "Bağımsız Denetim Yönetmeliği", True),
    ("6102 Sayılı Türk Ticaret Kanununun Bazı Maddelerinde", "6102 sayılı", True),
    ("16102 sayılı bir şey", "6102 sayılı", False),
    ("Sermaye Piyasasında Yeni Düzenleme", "Sermaye Piyasası", True),
    ("Sermaye Kurulu", "Sermaye Piyasası", False),
])
def test_terim_eslesme(baslik, terim, beklenen):
    assert rg.terim_eslesir(rg.normallestir(baslik), rg.normallestir(terim)) is beklenen


def test_sayfa_ayristirma():
    kalemler = rg.sayfayi_ayristir(FIXTURE.read_bytes(), "https://www.resmigazete.gov.tr/eskiler/2026/10/20261003.htm")
    basliklar = [k.baslik for k in kalemler]
    assert len(kalemler) == 9  # günün PDF'i, ikon bağlantısı ve ilan bağlantısı hariç
    assert basliklar[0].startswith("Vergi Usul Kanunu ile Bazı Kanunlarda Değişiklik")  # satır sonu ve "––" temizlendi
    assert "Bağımsız Denetim Yönetmeliğinde Değişiklik Yapılmasına Dair Yönetmelik" in basliklar  # windows-1254 çözüldü
    assert kalemler[0].bolum == "KANUNLAR" and kalemler[2].bolum == "YÖNETMELİKLER"
    assert kalemler[0].url == "https://www.resmigazete.gov.tr/eskiler/2026/10/20261003-1.htm"
    assert not any("ilan" in b for b in basliklar)


def test_izleme_listesi_terimleri():
    terimler = {i.terim for i in rg.izleme_listesi(KAYNAKLAR)}
    assert {"213 sayılı", "Vergi Usul", "Türk Ticaret", "Gelir Vergisi Genel Tebliği", "Kamu Gözetimi"} <= terimler
    assert "TMS 2 Stoklar" not in terimler  # tek tek standartlar değil, kurum/genel terimler izlenir


def test_eslestirme_ve_soru_kimlikleri():
    izleme = rg.izleme_listesi(KAYNAKLAR)
    sayfalar = [("Resmî Gazete", rg.sayfayi_ayristir(FIXTURE.read_bytes()))]
    assert "Bağımsız Denetim Yönetmeliği" in {i.terim for i in izleme}
    es = {e.kalem.baslik[:25]: e for e in rg.eslestir(sayfalar, izleme)}
    vuk = next(e for b, e in es.items() if b.startswith("Vergi Usul"))
    assert vuk.soru_idler == ["Q-VUK-1", "Q-VUK-2"]
    ttk = next(e for b, e in es.items() if "Türk Ticaret" in b)
    assert ttk.soru_idler == ["Q-TTK-1"]
    den = next(e for b, e in es.items() if b.startswith("Bağımsız Denetim"))
    assert den.soru_idler == ["Q-DEN-1"]
    gvk = next(e for b, e in es.items() if b.startswith("Gelir Vergisi Genel"))
    assert "Q-GVK-2" in gvk.soru_idler
    kgk = next(e for b, e in es.items() if b.startswith("Kamu Gözetimi"))
    assert {"Q-STK-1", "Q-DEN-1"} <= set(kgk.soru_idler)  # genel terim → TMS/BDS kaynaklarına bağlı
    spk = next(e for b, e in es.items() if b.startswith("Sermaye Piyasası"))
    assert "Q-SPK-1" in spk.soru_idler
    sgk = next(e for b, e in es.items() if b.startswith("Sosyal Sigortalar"))
    assert "Q-SGK-1" in sgk.soru_idler
    assert not any(b.startswith(("Tarım", "Karayolları")) for b in es)  # ilgisiz başlıklar eşleşmez
    assert len(es) == 7


def test_rapor_ve_cikis_kodu(tmp_path, capsys):
    soru_klasoru = tmp_path / "sorular"
    soru_klasoru.mkdir()
    (soru_klasoru / "a.yaml").write_text(
        "- id: Q-VUK-1\n  durum: kontrolde\n  kaynaklar: [{mevzuat: '213 sayılı Vergi Usul Kanunu', madde: 'md. 114/1'}]\n"
        "- id: Q-TASLAK\n  durum: taslak\n  kaynaklar: [{mevzuat: '6102 sayılı Türk Ticaret Kanunu', madde: 'md. 4'}]\n"
        "- id: Q-BOZUK\n  durum: kontrolde\n  kaynaklar: [{mevzuat: '488 sayılı Damga Vergisi Kanunu', madde: 'md. 1'}]\n",
        encoding="utf-8",
    )
    (soru_klasoru / "yarim.yaml").write_text("- id: [bozuk\n", encoding="utf-8")  # başka oturumun yarım dosyası atlanır
    cikti = tmp_path / "rapor.md"
    kod = rg.main(["--test-html", str(FIXTURE), "--tarih", "2026-10-03", "--sorular", str(soru_klasoru), "--cikti", str(cikti)])
    assert kod == 0
    rapor = cikti.read_text(encoding="utf-8")
    assert "**1 eşleşme**" in rapor and "Q-VUK-1" in rapor and "Q-TASLAK" not in rapor
    assert "https://www.resmigazete.gov.tr/eskiler/2026/10/20261003-1.htm" in rapor
    assert "ESLESME_SAYISI=1" in capsys.readouterr().out


def test_sayfa_adresleri():
    ana, mukerrer = rg.sayfa_adresleri(date(2026, 10, 3))
    assert ana == "https://www.resmigazete.gov.tr/eskiler/2026/10/20261003.htm"
    assert mukerrer[0].endswith("/20261003M1.htm")


def test_ag_hatasi_cikis_kodu_2(monkeypatch, capsys):
    def patla(url, **kw):
        raise rg.AgHatasi("bağlantı yok")
    monkeypatch.setattr(rg, "indir", patla)
    assert rg.main(["--tarih", "2026-10-03"]) == 2


def test_yayin_yok_404(monkeypatch):
    monkeypatch.setattr(rg, "indir", lambda url, **kw: None)
    sayfalar, notlar = rg.gunu_cek(date(2026, 10, 3))
    assert sayfalar == [] and "404" in notlar[0]


def test_mukerrer_sayilar(monkeypatch):
    veri = {"20261003.htm": FIXTURE.read_bytes(), "20261003M1.htm": FIXTURE.read_bytes()}
    monkeypatch.setattr(rg, "indir", lambda url, **kw: veri.get(url.rsplit("/", 1)[-1]))
    sayfalar, _ = rg.gunu_cek(date(2026, 10, 3))
    assert [ad for ad, _ in sayfalar] == ["Resmî Gazete", "Mükerrer 1"]
