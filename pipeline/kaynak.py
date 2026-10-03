"""G0 — Kaynak madde getirici.

Kanun metinlerinden (content/kaynaklar/mevzuat/*.txt, mevzuat.gov.tr) tek bir maddenin güncel metnini çıkarır.
Soru üreticisi ve kontrol kapıları, bir iddiayı yalnızca bu araçla getirilen resmî metne dayanarak yazar/denetler.

Kullanım:
    python -m pipeline.kaynak kdvk 29
    python -m pipeline.kaynak kvk 32/C
    python -m pipeline.kaynak gvk "mükerrer 121"
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

KOK = Path(__file__).resolve().parent.parent
MEVZUAT = KOK / "content/kaynaklar/mevzuat"

# Kısa kod → dosya adı ve resmî ad
KANUNLAR = {
    "gvk": ("gvk", "193 sayılı Gelir Vergisi Kanunu"),
    "kvk": ("kvk", "5520 sayılı Kurumlar Vergisi Kanunu"),
    "kdvk": ("kdvk", "3065 sayılı Katma Değer Vergisi Kanunu"),
    "vuk": ("vuk", "213 sayılı Vergi Usul Kanunu"),
    "6183": ("aatuhk", "6183 sayılı Amme Alacaklarının Tahsil Usulü Hakkında Kanun"),
    "otvk": ("otvk", "4760 sayılı Özel Tüketim Vergisi Kanunu"),
    "dvk": ("dvk", "488 sayılı Damga Vergisi Kanunu"),
    "vivk": ("vivk", "7338 sayılı Veraset ve İntikal Vergisi Kanunu"),
    "mtvk": ("mtvk", "197 sayılı Motorlu Taşıtlar Vergisi Kanunu"),
    "evk": ("evk", "1319 sayılı Emlak Vergisi Kanunu"),
    "ttk": ("ttk", "6102 sayılı Türk Ticaret Kanunu"),
    "tbk": ("tbk", "6098 sayılı Türk Borçlar Kanunu"),
    "isk": ("isk", "4857 sayılı İş Kanunu"),
    "5510": ("sgk", "5510 sayılı Sosyal Sigortalar ve Genel Sağlık Sigortası Kanunu"),
    "iyuk": ("iyuk", "2577 sayılı İdari Yargılama Usulü Kanunu"),
    "spkn": ("spkn", "6362 sayılı Sermaye Piyasası Kanunu"),
    "3568": ("smmm_kanunu", "3568 sayılı Serbest Muhasebeci Mali Müşavirlik ve Yeminli Mali Müşavirlik Kanunu"),
    "6356": ("sendikalar", "6356 sayılı Sendikalar ve Toplu İş Sözleşmesi Kanunu"),
    "7036": ("is_mahkemeleri", "7036 sayılı İş Mahkemeleri Kanunu"),
    "5018": ("kmyk", "5018 sayılı Kamu Malî Yönetimi ve Kontrol Kanunu"),
    "492": ("harclar", "492 sayılı Harçlar Kanunu"),
    "2576": ("idare_mahkemeleri", "2576 sayılı Bölge İdare Mahkemeleri, İdare Mahkemeleri ve Vergi Mahkemelerinin Kuruluşu ve Görevleri Hakkında Kanun"),
}

# "Madde 40 –", "MADDE 32/C –", "Mükerrer Madde 121 –", "Geçici Madde 67 –", "Ek Madde 1 –"
BASLIK = re.compile(
    r"^\s*(?P<on>(?:Mükerrer|MÜKERRER|Geçici|GEÇİCİ|Ek|EK)\s+)?(?:Madde|MADDE)\s+"
    r"(?P<no>\d+(?:/[A-Za-zÇĞİÖŞÜ])?)\s*[-–—]",
    re.MULTILINE,
)


def _anahtar(on: str | None, no: str) -> str:
    on = (on or "").strip().casefold().replace("i̇", "i")
    return f"{on} {no.upper()}".strip()


def maddeler(kod: str) -> dict[str, str]:
    """Kanundaki tüm maddeleri {anahtar: metin} olarak döndürür. Aynı anahtar tekrarlanırsa ilki alınır."""
    dosya, _ = KANUNLAR[kod]
    metin = (MEVZUAT / f"{dosya}.txt").read_text(encoding="utf-8")
    eslesmeler = list(BASLIK.finditer(metin))
    sonuc: dict[str, str] = {}
    for i, m in enumerate(eslesmeler):
        bitis = eslesmeler[i + 1].start() if i + 1 < len(eslesmeler) else len(metin)
        sonuc.setdefault(_anahtar(m.group("on"), m.group("no")), metin[m.start():bitis].strip())
    return sonuc


def madde_getir(kod: str, madde: str) -> str:
    """Örn. madde_getir('kdvk', '29'), madde_getir('gvk', 'mükerrer 121'), madde_getir('kvk', '32/C')."""
    parcalar = madde.strip().split()
    on, no = (parcalar[0], parcalar[1]) if len(parcalar) == 2 else (None, parcalar[0])
    anahtar = _anahtar(on, no)
    tum = maddeler(kod)
    if anahtar not in tum:
        raise KeyError(f"{KANUNLAR[kod][1]}: '{madde}' bulunamadı")
    return tum[anahtar]


def main(argv: list[str]) -> int:
    if len(argv) < 3:
        print(__doc__)
        print("Kodlar:", ", ".join(KANUNLAR))
        return 1
    print(f"[{KANUNLAR[argv[1]][1]}]\n")
    print(madde_getir(argv[1], " ".join(argv[2:])))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
