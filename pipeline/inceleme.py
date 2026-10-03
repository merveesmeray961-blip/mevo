"""G8 — Uzman incelemesi sonuçlarını soru bankasına işler.

Önizleme sayfasındaki uzman kararları sayfanın veritabanında `inceleme/<soru-id>` belgeleri olarak durur.
Bu belgeler Claude'un ArtifactData aracıyla (`action: list`, `collection: inceleme`, `out_dir: <klasör>`)
yerel bir klasöre indirilir; bu betik o klasörü okur.

Kurallar:
- Karar sorunun GÜNCEL sürümüne aitse işlenir; eski sürüme ait kararlar "eski" olarak raporlanır.
- "dogru" → G8 gecti, durum onayli. "hatali" → G8 kaldi (kategori + not), durum kontrolde kalır.
- Kritik kategoriler (kritik_*) ayrıca listelenir; PLAN.md §6 gereği örneklemde kritik hata partinin
  tamamının incelenmesini gerektirir.

Kullanım:
    python -m pipeline.inceleme <indirilen_klasor> [--isle]
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter
from pathlib import Path

from pipeline import denetle, g2_yapi


def kararlari_oku(klasor: Path) -> dict[str, dict]:
    kararlar = {}
    for yol in sorted(Path(klasor).rglob("*.json")):
        belge = json.loads(yol.read_text(encoding="utf-8"))
        veri = belge.get("data", belge)
        if "soru" in veri and "karar" in veri:
            kararlar[veri["soru"]] = veri
    return kararlar


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("klasor", type=Path)
    ap.add_argument("--isle", action="store_true")
    args = ap.parse_args(argv[1:])

    kararlar = kararlari_oku(args.klasor)
    kayitlar = g2_yapi.dosyalari_yukle(g2_yapi.KOK / "content/sorular/smmm", [])
    sorular = {s["id"]: s for _, s in kayitlar}

    sayac: Counter = Counter()
    kritik, hatali, eski = [], [], []
    for sid, k in kararlar.items():
        soru = sorular.get(sid)
        if soru is None:
            continue
        if k.get("surum") != soru.get("surum"):
            eski.append(sid)
            sayac["eski"] += 1
            continue
        sayac[k["karar"]] += 1
        if k["karar"] == "hatali":
            hatali.append((sid, k.get("kategori", ""), k.get("not", "")))
            if str(k.get("kategori", "")).startswith("kritik"):
                kritik.append(sid)
        if args.isle:
            kapilar = soru.setdefault("uretim", {}).setdefault("kapilar", {})
            kapilar["G8"] = {"sonuc": "gecti" if k["karar"] == "dogru" else "kaldi",
                             "tarih": k.get("tarih", "")[:10],
                             **({"not": f"{k.get('kategori', '')}: {k.get('not', '')}"} if k["karar"] == "hatali" else {})}
            if k["karar"] == "dogru" and soru.get("durum") == "kontrolde":
                soru["durum"] = "onayli"

    if args.isle:
        degisen = {d for d, s in kayitlar if s["id"] in kararlar}
        denetle._yaz([(d, s) for d, s in kayitlar if d in degisen], g2_yapi.KOK / "content/sorular/smmm")

    incelenebilir = sum(1 for s in sorular.values() if s.get("durum") in ("kontrolde", "onayli"))
    print(f"Uzman kararı: {sayac['dogru']} doğru, {sayac['hatali']} hatalı, {sayac['eski']} eski sürüm "
          f"(incelenebilir soru: {incelenebilir})")
    if kritik:
        print(f"KRİTİK HATA: {len(kritik)} soru → ilgili partinin tamamı yeniden incelenmeli: {', '.join(kritik)}")
    for sid, kat, not_ in hatali:
        print(f"  HATALI {sid} [{kat}] {not_}")
    if eski:
        print(f"  Eski sürüme ait karar (soru sonradan güncellendi): {', '.join(eski)}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
