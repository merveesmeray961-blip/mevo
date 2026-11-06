"""Tarayıcının doğru çalıştığını bilinen geçmiş gazetelerle sınar (durum dosyalarına yazmaz).
Kullanım: python sina.py 2024-08-02 2025-01-01 ..."""
import datetime as dt, sys, yaml
from pathlib import Path
import tara

cfg = yaml.safe_load((tara.K / "izleme.yaml").read_text(encoding="utf-8"))
for k in cfg["konular"]:
    k["rg"] = [tara.kucult(x) for x in k["rg"]]; k["soru"] = [tara.kucult(x) for x in k["soru"]]
for a in ("genel", "atla", "icerik_bolumleri"):
    cfg[a] = [tara.kucult(x) for x in cfg[a]]
for g in sys.argv[1:]:
    liste = tara.fihrist(dt.date.fromisoformat(g)) or []
    print(f"== {g}: {len(liste)} başlık")
    for bolum, baslik, url, sayi in liste:
        sev, konu, md, notu = tara.eslestir(cfg, bolum, baslik, url)
        if sev:
            print(f"  [{sev}] {baslik[:90]} -> {', '.join(konu)} | {notu} | md {md[:8]}")
