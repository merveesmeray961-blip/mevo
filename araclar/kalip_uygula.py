"""Yeniden yazılan çeldirici açıklamalarını (content/teslim/kalip/sonuc/sonuc_kalip_*.json) sorulara işler."""
import datetime as dt, json
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
yeni = {}
for p in sorted((KOK / "content/teslim/kalip/sonuc").glob("sonuc_kalip_*.json")):
    for r in json.loads(p.read_text(encoding="utf-8")):
        yeni[r["id"]] = r
n_soru = n_acik = 0
for p in sorted((KOK / "content/sorular").rglob("*.yaml")):
    liste = yaml.safe_load(p.read_text(encoding="utf-8")) or []
    degisti = False
    for s in liste:
        r = yeni.get(s["id"])
        if not r or not isinstance(s.get("aciklama"), dict):
            continue
        c = s["aciklama"].setdefault("celdiriciler", {})
        for h, t in (r.get("celdiriciler") or {}).items():
            if h != s["dogru"] and t and t.strip():
                c[h] = t.strip(); n_acik += 1
        s.setdefault("gecmis", []).append({"tarih": dt.date.today().isoformat(), "kim": "hakem",
                                           "ne": "kalıp çeldirici açıklamaları soruya özel yeniden yazıldı"})
        n_soru += 1; degisti = True
    if degisti:
        p.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
print(f"{n_soru} soru, {n_acik} açıklama güncellendi; sorun notu olanlar:",
      [k for k, v in yeni.items() if (v.get("sorun") or "").strip()])
