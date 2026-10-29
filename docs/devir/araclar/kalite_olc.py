"""Soru bankasının biçim kalitesini ölçer ve 18.10.2026'daki resmî 2026 TESMER testleriyle karşılaştırma değerleriyle
yan yana yazar (docs/denetim/smmm_test_2026_karsilastirma.md §1.4).

Yalnız `kontrolde/onayli/yayinda` sorular sayılır. Kullanım (depo kökünden):
    python docs/devir/araclar/kalite_olc.py [smmm|ymm]
"""

from __future__ import annotations

import re
import sys
from collections import Counter
from pathlib import Path

import yaml

KOK = Path(__file__).resolve().parents[3]
AKTIF = {"kontrolde", "onayli", "yayinda"}
MUTLAK = re.compile(
    r"\b(hiçbir|hiç bir|yalnızca|sadece|her zaman|her durumda|asla|tamamen|kesinlikle|hiçbir zaman|daima)\b", re.I
)
OLUMSUZ = re.compile(r"\*\*[^*]+\*\*")
BDS_NO = re.compile(r"\bBDS\s*\d{3}\b")
MADDE_NO = re.compile(r"\b(md\.|madde)\s*\d+", re.I)
TL = re.compile(r"\bTL\b")
LIRA = "₺"


def yukle(urun: str) -> list[dict]:
    sorular = []
    for yol in sorted((KOK / "content/sorular" / urun).rglob("*.yaml")):
        icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        for s in icerik if isinstance(icerik, list) else [icerik]:
            if s.get("durum") in AKTIF:
                sorular.append(s)
    return sorular


def yuzde(pay: int, payda: int) -> str:
    return f"%{100 * pay / payda:.1f}" if payda else "-"


def sayisal(metin: str) -> float | None:
    m = re.search(r"-?\d[\d.]*(?:,\d+)?", metin.replace(" ", ""))
    if not m:
        return None
    try:
        return float(m.group(0).replace(".", "").replace(",", "."))
    except ValueError:
        return None


def olc(urun: str) -> None:
    sorular = yukle(urun)
    n = len(sorular)
    en_uzun = mutlak_yanlis = yanlis_toplam = olumsuz = oncullu = bds = madde = tl = lira = 0
    sayisal_soru = sirali = 0
    dagilim: Counter = Counter()
    for s in sorular:
        sec = {k: str(v) for k, v in (s.get("secenekler") or {}).items()}
        dogru = s.get("dogru")
        dagilim[dogru] += 1
        if sec and dogru in sec and len(sec[dogru]) == max(len(v) for v in sec.values()) and \
                sum(len(v) == len(sec[dogru]) for v in sec.values()) == 1:
            en_uzun += 1
        for k, v in sec.items():
            if k != dogru:
                yanlis_toplam += 1
                mutlak_yanlis += bool(MUTLAK.search(v))
        kok = str(s.get("kok", ""))
        olumsuz += bool(OLUMSUZ.search(kok))
        oncullu += bool(re.search(r"^\s*I\.\s", kok, re.M))
        bds += bool(BDS_NO.search(kok))
        madde += bool(MADDE_NO.search(kok))
        tl += bool(TL.search(kok))
        lira += bool(LIRA in kok)
        degerler = [sayisal(v) for v in sec.values()]
        if sec and all(d is not None for d in degerler) and len({*degerler}) == len(degerler):
            sayisal_soru += 1
            sirali += degerler == sorted(degerler)
    print(f"\n=== {urun.upper()}: {n} aktif soru ===")
    print(f"doğru şık en uzun (tek başına)     : {yuzde(en_uzun, n):>7}   (resmî ≈ %24, 18.10 bankası %62)")
    print(f"yanlış şıkta mutlak ifade           : {yuzde(mutlak_yanlis, yanlis_toplam):>7}   (resmî %1,5, 18.10 bankası %31)")
    print(f"olumsuz kök (kalın)                 : {yuzde(olumsuz, n):>7}   (resmî sözel derslerde %36-56)")
    print(f"öncüllü soru                        : {yuzde(oncullu, n):>7}")
    print(f"kökte BDS numarası                  : {yuzde(bds, n):>7}   (resmî 0, 18.10 DEN %35)")
    print(f"kökte madde numarası                : {yuzde(madde, n):>7}   (resmî çok nadir)")
    print(f"kökte TL / ₺                        : {tl} / {lira}")
    print(f"sayısal şıklı soru artan sırada     : {yuzde(sirali, sayisal_soru)} ({sirali}/{sayisal_soru})   (resmî neredeyse hep artan)")
    toplam = sum(dagilim.values())
    print("doğru şık dağılımı                  : " + " ".join(f"{h}={yuzde(dagilim.get(h, 0), toplam)}" for h in "ABCDE"))


if __name__ == "__main__":
    hedefler = sys.argv[1:] or ["smmm", "ymm"]
    for u in hedefler:
        olc(u)
