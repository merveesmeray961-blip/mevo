"""Yalnız sayı / tarih / yüzde / süre içeren şıkları artan sıraya dizer (gerçek sınav kuralı).

Karışık sıra, doğru şıkkın sezilmesine yol açar ve resmî sınavda görülmez. Doğru şık, çeldirici açıklamaları ve
`dogru` harfi şıkla birlikte taşınır; soru metni, şık metinleri ve açıklama içeriği değişmez.

    python -m pipeline.sik_sirala [--dene] [--urun smmm|ymm]

Dokunulmayanlar:
  - kökte, açıklamada ya da şıklarda harfe gönderme yapılanlar ("B şıkkı", "(C)", "A ve C" ...),
  - hesaplama dışı sorular dahil her tür: yalnız ölçüt "tüm şıklar yalnız sayı/tarih" olmasıdır,
  - sayıları eşit olan şıklar (sıralama belirsiz).
"""
from __future__ import annotations

import re
import sys

import yaml

from pipeline import g2_yapi
from pipeline.sik_dengele import AKTIF, HARFLER, _HARF_GONDERME, _metinler

_SAF = re.compile(
    r"^\s*[₺%]?\s*-?\d[\d.\s]*(?:,\d+)?\s*(?:TL|₺|%|adet|ay|yıl|gün|dakika|saat)?\s*$"
)
_TARIH = re.compile(r"^\s*(\d{1,2})[./](\d{1,2})[./](\d{4})\s*$")
_OLUMSUZ_SAYI = re.compile(r"^\s*-")


def anahtar(metin: str) -> tuple[float, ...] | None:
    t = _TARIH.match(metin)
    if t:
        return (int(t.group(3)), int(t.group(2)), int(t.group(1)))
    if not _SAF.match(metin):
        return None
    x = re.search(r"-?\d[\d.]*(?:,\d+)?", metin.replace(" ", ""))
    if not x:
        return None
    try:
        return (float(x.group(0).replace(".", "").replace(",", ".")),)
    except ValueError:
        return None


def siralanabilir(s: dict) -> bool:
    if s.get("durum") not in AKTIF:
        return False
    sec = s.get("secenekler") or {}
    if sorted(sec) != list(HARFLER) or s.get("dogru") not in HARFLER:
        return False
    anahtarlar = [anahtar(str(sec[h])) for h in HARFLER]
    if any(a is None for a in anahtarlar) or len(set(anahtarlar)) != len(anahtarlar):
        return False
    if anahtarlar == sorted(anahtarlar) or anahtarlar == sorted(anahtarlar, reverse=True):
        return False  # zaten sıralı (artan ya da azalan)
    sik = [str(v) for v in sec.values()]
    return not any(_HARF_GONDERME.search(m) for m in _metinler(s) + sik)


def sirala(s: dict) -> None:
    sec = s["secenekler"]
    yeni_sira = sorted(HARFLER, key=lambda h: anahtar(str(sec[h])))  # eski harfler, artan değer sırasıyla
    eski_dogru = s["dogru"]
    harita = {eski: HARFLER[i] for i, eski in enumerate(yeni_sira)}  # eski harf -> yeni harf
    s["secenekler"] = {harita[e]: sec[e] for e in yeni_sira}
    a = s.get("aciklama") or {}
    cel = a.get("celdiriciler")
    if isinstance(cel, dict):
        a["celdiriciler"] = {harita[e]: cel[e] for e in yeni_sira if e in cel}
    s["dogru"] = harita[eski_dogru]
    s.setdefault("gecmis", []).append({
        "tarih": "2026-10-29",
        "kim": "otomatik",
        "ne": f"şık sıralama: sayısal şıklar artan sıraya dizildi (doğru şık {eski_dogru} → {s['dogru']}).",
    })


def calistir(urun: str = "smmm", yaz: bool = True) -> list[str]:
    klasor = g2_yapi.KOK / "content" / "sorular" / urun
    degisen: list[str] = []
    for yol in sorted(klasor.glob("*/*.yaml")):
        icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        liste = icerik if isinstance(icerik, list) else [icerik]
        dosyada = False
        for s in liste:
            if siralanabilir(s):
                sirala(s)
                degisen.append(s["id"])
                dosyada = True
        if dosyada and yaz:
            yol.write_text(yaml.safe_dump(icerik, allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")
    return degisen


def main(argv: list[str]) -> int:
    urun = argv[argv.index("--urun") + 1] if "--urun" in argv else "smmm"
    degisen = calistir(urun, yaz="--dene" not in argv)
    print(f"{urun}: sıralanan soru {len(degisen)}")
    for k in degisen[:60]:
        print("  ", k)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
