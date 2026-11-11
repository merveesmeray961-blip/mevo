import json, collections
from pathlib import Path
K = Path(__file__).resolve().parents[1]
out = {}
for u in ("smmm", "ymm"):
    d = json.load(open(K / f"app/assets/sorular/{u}.json", encoding="utf-8"))
    t = collections.Counter((s.get("ders"), s.get("konu")) for s in d["sorular"])
    dd = collections.Counter(s.get("ders") for s in d["sorular"])
    kl = collections.Counter(k.get("ders") for k in d.get("klasik", []))
    out[u] = {"ders_test": dict(dd), "ders_klasik": dict(kl),
              "zayif_konu": sorted(((f"{a}/{b}", n) for (a, b), n in t.items()), key=lambda x: x[1])[:40],
              "konu_sayisi": len(t)}
(K / "araclar/_dagilim.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
print("ok")
