"""Resmî Gazete takibi: günlük içindekiler sayfasını, soru bankasının dayandığı mevzuatla karşılaştırır.

Soru bankasındaki `kaynaklar` alanından bir izleme listesi (kanun numaraları/adları, yönetmelik ve tebliğ adları,
standart kurumları) üretilir; Resmî Gazete'nin o günkü başlıkları bu listeyle eşleştirilir ve etkilenebilecek
soru kimlikleriyle birlikte Markdown rapor olarak yazılır.

Kullanım:
    python -m pipeline.rg_takip                       # bugün (Europe/Istanbul)
    python -m pipeline.rg_takip --tarih 2026-10-03    # belirli gün (mükerrer sayılar dahil)
    python -m pipeline.rg_takip --test-html sayfa.htm # kayıtlı sayfayı ayrıştır (ağ yok; testler için)
    python -m pipeline.rg_takip --cikti rapor.md      # raporu dosyaya da yaz

Çıkış kodu: 0 (eşleşme olsun olmasın; "ESLESME_SAYISI=n" satırı yazılır). 2: sayfa ağdan hiç alınamadı
(404 "yayın yok" sayılır, hata değildir).
"""

from __future__ import annotations

import argparse
import re
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from datetime import date, datetime
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urljoin
from zoneinfo import ZoneInfo

import yaml

from pipeline import mevzuat_paketi

KOK = Path(__file__).resolve().parent.parent
SORULAR = KOK / "content/sorular/smmm"
TABAN = "https://www.resmigazete.gov.tr/eskiler"
USER_AGENT = "mevo-rg-takip/1.0 (SMMM sinav hazirlik uygulamasi; gunluk tek istek; kisisel kullanim)"
AKTARILAN_DURUMLAR = {"kontrolde", "onayli", "yayinda"}
MUKERRER_ENFAZLA = 6

# Genel izleme terimleri → etkilenebilecek kaynakların adının başı (kaynak adı bu öneklerden biriyle başlıyorsa).
EK_IZLEME: list[tuple[str, list[str]]] = [
    ("Kamu Gözetimi", ["TMS", "TFRS", "BDS", "KYS", "KGK"]),
    ("Muhasebe Standartları", ["TMS", "TFRS"]),
    ("Finansal Raporlama Standartları", ["TMS", "TFRS"]),
    ("Bağımsız Denetim Standartları", ["BDS", "KYS", "KGK"]),
    ("Sermaye Piyasası", ["6362 sayılı", "Önemli Nitelikteki"]),
    ("Tekdüzen Hesap Planı", [mevzuat_paketi.MSUGT]),
    ("Muhasebe Sistemi Uygulama", [mevzuat_paketi.MSUGT]),
    ("Serbest Muhasebeci", ["3568 sayılı", "Serbest Muhasebeci", "SMMM", "Yeminli Mali"]),
    ("Yeminli Mali Müşavir", ["3568 sayılı", "Serbest Muhasebeci", "SMMM", "Yeminli Mali"]),
    ("Türkiye Muhasebe Standartları", ["TMS", "TFRS"]),
]


# ---------------------------------------------------------------- metin normalleştirme / eşleştirme
def normallestir(s: str) -> str:
    """Küçük harf (İ→i, I→ı), şapkalı harfler düz, noktalama boşluk, tek boşluk."""
    s = s.replace("İ", "i").replace("I", "ı").lower()
    s = s.translate(str.maketrans("âîû", "aiu"))
    s = re.sub(r"[^\w]+", " ", s.replace("'", "").replace("’", ""))
    return " ".join(s.split())


def _kelime_eslesir(baslik_kelime: str, terim_kelime: str, son: bool) -> bool:
    if not son or len(terim_kelime) <= 5:
        return baslik_kelime == terim_kelime
    return baslik_kelime.startswith(terim_kelime[:-3])  # çekim eki: "Yönetmeliği" ~ "Yönetmeliğinde"


def terim_eslesir(norm_baslik: str, terim: str) -> bool:
    """Terim tek kelime dizisi olarak başlıkta geçiyor mu (son kelimede çekim eki tolere edilir).
    "213 sayılı" gibi sayı içeren terimler tam kelime olarak aranır."""
    t = terim.split()
    b = norm_baslik.split()
    if not t:
        return False
    if t[0].isdigit():
        return any(b[i : i + len(t)] == t for i in range(len(b) - len(t) + 1))
    for i in range(len(b) - len(t) + 1):
        if all(_kelime_eslesir(b[i + j], w, j == len(t) - 1) for j, w in enumerate(t)):
            return True
    return False


# ---------------------------------------------------------------- izleme listesi
@dataclass
class Izleme:
    terim: str  # görünen
    norm: str
    kaynaklar: set[str] = field(default_factory=set)
    soru_idler: set[str] = field(default_factory=set)


def _kanun_terimleri(ad: str) -> list[str]:
    m = re.match(r"(\d+) sayılı (.+)$", ad)
    if not m:
        return []
    no, govde = m.groups()
    sade = re.sub(r"\s+(Hakkında\s+)?Kanunu?$", "", govde)
    terimler = [f"{no} sayılı"]
    terimler.append(sade if len(sade.split()) >= 2 else govde)
    return terimler


def _diger_terim(ad: str, tur: str) -> list[str]:
    if tur not in ("yonetmelik", "teblig"):
        return []
    ad = re.sub(r"\([^)]*\)", "", ad.split(" — ")[0].split(", RG")[0].split(", Ek")[0]).strip(" ,")
    ad = re.sub(r"^KGK\s+", "", ad)  # kurum öneki Resmî Gazete başlığında yer almaz
    return [ad] if len(ad.split()) >= 2 else []


def soru_kaynaklari(klasor: Path = SORULAR) -> dict[str, set[str]]:
    """{kanonik kaynak adı: {soru kimlikleri}} — yalnız uygulamaya aktarılan durumdaki sorular."""
    sonuc: dict[str, set[str]] = {}
    for yol in sorted(klasor.rglob("*.yaml")):
        try:
            icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        except yaml.YAMLError:
            continue  # başka oturumun yarım yazdığı dosya
        for s in icerik if isinstance(icerik, list) else [icerik]:
            if not isinstance(s, dict) or s.get("durum") not in AKTARILAN_DURUMLAR:
                continue
            for k in s.get("kaynaklar", []):
                sonuc.setdefault(mevzuat_paketi.kaynak_adi(k["mevzuat"]), set()).add(s["id"])
    return sonuc


def izleme_listesi(kaynaklar: dict[str, set[str]]) -> list[Izleme]:
    """Kaynak adlarından terimler (kanun no + ad, yönetmelik/tebliğ adı) ve genel terimler."""
    liste: dict[str, Izleme] = {}

    def ekle(terim: str, ad: str):
        norm = normallestir(terim)
        iz = liste.setdefault(norm, Izleme(terim, norm))
        iz.kaynaklar.add(ad)
        iz.soru_idler |= kaynaklar[ad]

    for ad in kaynaklar:
        tur = mevzuat_paketi.kaynak_turu(ad)
        for t in _kanun_terimleri(ad) if tur == "kanun" else _diger_terim(ad, tur):
            ekle(t, ad)
    for terim, oneckler in EK_IZLEME:
        norm = normallestir(terim)
        iz = liste.setdefault(norm, Izleme(terim, norm))
        for ad in kaynaklar:
            if any(ad.startswith(o) for o in oneckler):
                iz.kaynaklar.add(ad)
                iz.soru_idler |= kaynaklar[ad]
    return [i for i in liste.values() if i.soru_idler]


# ---------------------------------------------------------------- sayfa ayrıştırma
@dataclass
class Kalem:
    baslik: str
    url: str
    bolum: str = ""


class _Ayristirici(HTMLParser):
    def __init__(self, taban: str):
        super().__init__(convert_charrefs=True)
        self.taban = taban
        self.kalemler: list[Kalem] = []
        self.bolum = ""
        self._altcizgi = 0
        self._altcizgi_metin: list[str] = []
        self._a_href: str | None = None
        self._a_metin: list[str] = []

    def handle_starttag(self, tag, attrs):
        if tag == "u":
            self._altcizgi += 1
            self._altcizgi_metin = []
        elif tag == "a":
            self._a_href = dict(attrs).get("href") or None
            self._a_metin = []

    def handle_endtag(self, tag):
        if tag == "u" and self._altcizgi:
            self._altcizgi -= 1
            metin = " ".join("".join(self._altcizgi_metin).split())
            if metin and not self._altcizgi:
                self.bolum = metin
        elif tag == "a" and self._a_href is not None:
            metin = " ".join("".join(self._a_metin).split())
            metin = re.sub(r"^[–—\-\s]+", "", metin)
            href = self._a_href
            self._a_href = None
            if metin and "main.aspx" not in href and not href.startswith(("javascript:", "mailto:")):
                self.kalemler.append(Kalem(metin, urljoin(self.taban, href), self.bolum))

    def handle_data(self, data):
        if self._altcizgi:
            self._altcizgi_metin.append(data)
        if self._a_href is not None:
            self._a_metin.append(data)


def coz(veri: bytes) -> str:
    """Resmî Gazete eski sayfaları windows-1254; UTF-8 ise onu kullan."""
    try:
        return veri.decode("utf-8")
    except UnicodeDecodeError:
        return veri.decode("cp1254", errors="replace")


def sayfayi_ayristir(icerik: str | bytes, url: str = TABAN + "/") -> list[Kalem]:
    """Sayfadaki madde başlıkları ve bağlantıları (bölüm başlığıyla). Boş/ikon bağlantıları ve ilanlar atlanır."""
    metin = coz(icerik) if isinstance(icerik, bytes) else icerik
    p = _Ayristirici(url)
    p.feed(metin)
    p.close()
    gorulen, sonuc = set(), []
    for k in p.kalemler:
        if (k.baslik, k.url) in gorulen or re.fullmatch(r"\d{8}(M\d+)?\.pdf", k.url.rsplit("/", 1)[-1]):
            continue  # günün tam PDF'i
        gorulen.add((k.baslik, k.url))
        sonuc.append(k)
    return sonuc


# ---------------------------------------------------------------- ağ
class AgHatasi(Exception):
    pass


def indir(url: str, deneme: int = 3, zaman_asimi: int = 30) -> bytes | None:
    """404 → None (yayın yok). Diğer hatalarda üstel bekleyişle yeniden dener, sonunda AgHatasi."""
    son = None
    for i in range(deneme):
        try:
            istek = urllib.request.Request(url, headers={"User-Agent": USER_AGENT, "Accept-Language": "tr"})
            with urllib.request.urlopen(istek, timeout=zaman_asimi) as r:
                return r.read()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            son = e
        except (urllib.error.URLError, TimeoutError, OSError) as e:
            son = e
        if i + 1 < deneme:
            time.sleep(2 * (i + 1))
    raise AgHatasi(f"{url}: {son}")


def sayfa_adresleri(gun: date) -> tuple[str, list[str]]:
    d = gun.strftime("%Y%m%d")
    taban = f"{TABAN}/{gun:%Y}/{gun:%m}"
    return f"{taban}/{d}.htm", [f"{taban}/{d}M{i}.htm" for i in range(1, MUKERRER_ENFAZLA + 1)]


def gunu_cek(gun: date) -> tuple[list[tuple[str, list[Kalem]]], list[str]]:
    """[(sayfa adı, kalemler)], notlar. Ana sayfa alınamazsa AgHatasi; mükerrer yoksa (404) sessizce biter."""
    ana, mukerrerler = sayfa_adresleri(gun)
    notlar, sayfalar = [], []
    veri = indir(ana)
    if veri is None:
        return [], [f"{gun:%d.%m.%Y} için Resmî Gazete sayfası yok (404)."]
    sayfalar.append(("Resmî Gazete", sayfayi_ayristir(veri, ana)))
    for i, adres in enumerate(mukerrerler, 1):
        try:
            veri = indir(adres, deneme=2, zaman_asimi=20)
        except AgHatasi as e:
            notlar.append(f"Mükerrer {i}. sayı denenirken ağ hatası (atlandı): {e}")
            break
        if veri is None:
            break
        sayfalar.append((f"Mükerrer {i}", sayfayi_ayristir(veri, adres)))
    return sayfalar, notlar


# ---------------------------------------------------------------- eşleştirme ve rapor
@dataclass
class Eslesme:
    kalem: Kalem
    sayfa: str
    izlemeler: list[Izleme]

    @property
    def soru_idler(self) -> list[str]:
        return sorted({s for i in self.izlemeler for s in i.soru_idler})


def eslestir(sayfalar: list[tuple[str, list[Kalem]]], izleme: list[Izleme]) -> list[Eslesme]:
    sonuc = []
    for sayfa, kalemler in sayfalar:
        for k in kalemler:
            nb = normallestir(k.baslik)
            bulunan = [i for i in izleme if terim_eslesir(nb, i.norm)]
            if bulunan:
                sonuc.append(Eslesme(k, sayfa, bulunan))
    return sonuc


def rapor_yaz(gun: date | None, sayfalar, eslesmeler: list[Eslesme], notlar: list[str], izleme_sayisi: int) -> str:
    kalem_sayisi = sum(len(k) for _, k in sayfalar)
    satir = [f"# Resmî Gazete takibi — {gun.strftime('%d.%m.%Y') if gun else 'kayıtlı sayfa'}", ""]
    satir.append(
        f"{len(sayfalar)} sayfa, {kalem_sayisi} başlık tarandı; {izleme_sayisi} izleme terimi; "
        f"**{len(eslesmeler)} eşleşme**."
    )
    for n in notlar:
        satir.append(f"\n> Not: {n}")
    if eslesmeler:
        satir += ["", "Eşleşen başlıklar soru bankamızın dayandığı mevzuatı değiştirmiş olabilir. İlgili sorulardaki "
                      "`kaynaklar` ve açıklamaları güncel metne göre gözden geçirin (docs/YAYIN.md → Mevzuat takibi).", ""]
    for e in eslesmeler:
        satir.append(f"## {e.kalem.baslik}")
        satir.append(f"- Kaynak: {e.sayfa}" + (f" · {e.kalem.bolum}" if e.kalem.bolum else ""))
        satir.append(f"- Bağlantı: {e.kalem.url}")
        satir.append("- Eşleşen terim: " + ", ".join(f"`{i.terim}`" for i in e.izlemeler))
        kaynaklar = sorted({k for i in e.izlemeler for k in i.kaynaklar})
        satir.append("- Etkilenebilecek kaynaklar: " + "; ".join(kaynaklar))
        idler = e.soru_idler
        satir.append(f"- Etkilenebilecek sorular ({len(idler)}): " + ", ".join(f"`{s}`" for s in idler))
        satir.append("")
    return "\n".join(satir).rstrip() + "\n"


def bugun_istanbul() -> date:
    return datetime.now(ZoneInfo("Europe/Istanbul")).date()


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tarih", help="YYYY-MM-DD (varsayılan: bugün, Europe/Istanbul)")
    ap.add_argument("--test-html", help="ağ yerine bu kayıtlı sayfayı ayrıştır")
    ap.add_argument("--cikti", help="raporu bu dosyaya da yaz")
    ap.add_argument("--sorular", default=str(SORULAR), help="soru klasörü (varsayılan content/sorular/smmm)")
    a = ap.parse_args(argv)

    izleme = izleme_listesi(soru_kaynaklari(Path(a.sorular)))
    gun, notlar = (date.fromisoformat(a.tarih) if a.tarih else None), []
    if a.test_html:  # bağlantılar --tarih verilmişse o günün adresine göre çözülür
        taban = sayfa_adresleri(gun)[0] if gun else TABAN + "/"
        sayfalar = [("Kayıtlı sayfa", sayfayi_ayristir(Path(a.test_html).read_bytes(), taban))]
    else:
        gun = gun or bugun_istanbul()
        try:
            sayfalar, notlar = gunu_cek(gun)
        except AgHatasi as e:
            print(f"HATA: Resmî Gazete sayfası alınamadı: {e}", file=sys.stderr)
            return 2
    eslesmeler = eslestir(sayfalar, izleme)
    rapor = rapor_yaz(gun, sayfalar, eslesmeler, notlar, len(izleme))
    if a.cikti:
        Path(a.cikti).write_text(rapor, encoding="utf-8")
    print(rapor)
    print(f"ESLESME_SAYISI={len(eslesmeler)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
