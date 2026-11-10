"""Henüz incelenmemiş taslak YMM klasik sorularını hakem paketlerine böler (paket/klasik_kNN.json)."""
import json, sys
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
H = KOK / "content/teslim/ymm_hakem"
P = H / "paket"
incelenen = {r["id"] for p in (H / "sonuc").glob("*.json") for r in json.loads(p.read_text(encoding="utf-8"))}
liste = [s for p in sorted((KOK / "content/klasik/ymm").rglob("*.yaml"))
         for s in (yaml.safe_load(p.read_text(encoding="utf-8")) or [])
         if s.get("durum") == "taslak" and s["id"] not in incelenen]
liste.sort(key=lambda s: s["id"])
for eski in P.glob("klasik_k*.json"):
    eski.unlink()
boy = int(sys.argv[1]) if len(sys.argv) > 1 else 12
for i in range(0, len(liste), boy):
    (P / f"klasik_k{i // boy + 1:02d}.json").write_text(json.dumps([
        {"id": s["id"], "ders": s["ders"], "konu": s.get("konu"), "puan": s.get("puan"), "soru": s["soru"],
         "cozum": s.get("cozum"), "puanlama": s.get("puanlama"), "kaynaklar": s.get("kaynaklar"),
         "dogrulama": s.get("dogrulama"), "hakem_notu": "tam inceleme (örneklem kusuru yüksek ders)"}
        for s in liste[i:i + boy]], ensure_ascii=False, indent=1), encoding="utf-8")
print(len(liste), "soru,", (len(liste) + boy - 1) // boy, "paket")
