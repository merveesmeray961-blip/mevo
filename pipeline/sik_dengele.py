"""Doğru şık dağılımını dengeler: doğru cevabın A–E harflerine eşit dağılması için, şık sırası anlam taşımayan
sorularda doğru şık ile fazla kullanılmayan bir harfin metni yer değiştirir (çeldirici açıklamaları da taşınır).

    python -m pipeline.sik_dengele [--dene]     # --dene: dosyaya yazmadan ne değişeceğini gösterir

Dokunulmayan sorular (şık sırası anlamlı ya da harf metinde geçiyor):
  - sayısal şıklar (gerçek sınavda küçükten büyüğe sıralıdır, G4 bunu denetler),
  - öncül kombinasyonları ("Yalnız I", "I ve II", "Hepsi", "Hiçbiri"...),
  - kökte, açıklamada veya şıklarda harfe gönderme yapılan sorular ("B şıkkı", "(C)", "A ve C" gibi).
Yalnız yayına aday durumdaki sorular (kontrolde/onayli/yayinda) hesaba katılır ve değiştirilir.
"""
from __future__ import annotations

import random
import re
import sys
from collections import Counter

import yaml

from pipeline import g2_yapi

KLASOR = g2_yapi.KOK / "content" / "sorular" / "smmm"
HARFLER = "ABCDE"
AKTIF = {"kontrolde", "onayli", "yayinda"}

_ONCUL = re.compile(r"\b(I|II|III|IV|V)\b|\b(hepsi|hiçbiri|yukarıdaki|yalnız)\b", re.IGNORECASE)
_HARF_GONDERME = re.compile(
    r"\b[A-E]\s*(şıkk|şık\b|seçene)|\([A-E]\)|\b[A-E]\)|[\"“'‘][A-E][\"”'’]|\b[A-E] (ve|veya|ile) [A-E]\b"
    r"|\b[A-E]['’](da|de|daki|deki|nın|nin|ya|ye)\b"
)
_SAYI = re.compile(r"\d")


def _metinler(s: dict) -> list[str]:
    a = s.get("aciklama") or {}
    parcalar = [s.get("kok", ""), a.get("dogru_neden", "")]
    parcalar += [str(v) for v in (a.get("celdiriciler") or {}).values()]
    parcalar += [str(v) for v in (a.get("puf_noktalari") or [])]
    parcalar += [str(v) for v in (s.get("hesap_adimlari") or [])]
    return [p for p in parcalar if p]


def uygun(s: dict) -> bool:
    """Şıkların yeri değiştirilebilir mi?"""
    secenekler = s.get("secenekler") or {}
    if sorted(secenekler) != list(HARFLER) or s.get("dogru") not in HARFLER:
        return False
    if s.get("durum") not in AKTIF:
        return False
    sik = [str(v) for v in secenekler.values()]
    if sum(1 for v in sik if _SAYI.search(v)) >= 3:
        return False
    if any(_ONCUL.search(v) for v in sik):
        return False
    return not any(_HARF_GONDERME.search(m) for m in _metinler(s) + sik)


def takas(s: dict, hedef: str) -> None:
    """Doğru şıkkı `hedef` harfine taşır; o harfteki çeldirici eski doğru harfe geçer."""
    eski = s["dogru"]
    if eski == hedef:
        return
    sec = s["secenekler"]
    sec[eski], sec[hedef] = sec[hedef], sec[eski]
    s["secenekler"] = {h: sec[h] for h in HARFLER}
    cel = (s.get("aciklama") or {}).get("celdiriciler")
    if isinstance(cel, dict) and hedef in cel:
        cel[eski] = cel.pop(hedef)
        s["aciklama"]["celdiriciler"] = {h: cel[h] for h in HARFLER if h in cel}
    s["dogru"] = hedef
    s.setdefault("gecmis", []).append({
        "tarih": "2026-10-09",
        "kim": "otomatik",
        "ne": f"şık dengeleme: doğru şık {eski} → {hedef} (metinler yer değiştirdi).",
    })


def dengele(yaz: bool = True, tohum: int = 20261009) -> Counter:
    kayitlar: list[tuple[str, list | dict, list[dict]]] = []
    for yol in sorted(KLASOR.glob("*/*.yaml")):
        icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        liste = icerik if isinstance(icerik, list) else [icerik]
        kayitlar.append((str(yol), icerik, liste))
    sorular = [s for _, _, liste in kayitlar for s in liste if s.get("durum") in AKTIF]
    sayac = Counter(s["dogru"] for s in sorular)
    hedef = len(sorular) / len(HARFLER)
    adaylar = [s for s in sorular if uygun(s)]
    random.Random(tohum).shuffle(adaylar)
    degisen: set[str] = set()
    for s in adaylar:
        eski = s["dogru"]
        if sayac[eski] <= hedef:
            continue
        yeni = min(HARFLER, key=lambda h: sayac[h])
        if sayac[yeni] >= hedef:
            break
        takas(s, yeni)
        sayac[eski] -= 1
        sayac[yeni] += 1
        degisen.add(s["id"])
    print(f"aktif {len(sorular)}, yeri değiştirilebilir {len(adaylar)}, değişen {len(degisen)}")
    if yaz:
        for yol, icerik, liste in kayitlar:
            if any(s.get("id") in degisen for s in liste):
                with open(yol, "w", encoding="utf-8") as f:
                    f.write(yaml.safe_dump(icerik, allow_unicode=True, sort_keys=False, width=110))
    return sayac


def main(argv: list[str]) -> int:
    sayac = dengele(yaz="--dene" not in argv)
    print("dağılım:", dict(sorted(sayac.items())))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
