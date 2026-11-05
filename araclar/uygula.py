"""Denetim kararlarını teslim dosyalarına uygular → content/teslim/smmm/_kabul/*.yaml (ret ve otomatik elenenler hariç)."""
import json, glob, re, sys, yaml
from pathlib import Path
KOK = Path(sys.argv[1]); KARAR = Path(sys.argv[2])
T = KOK / "content/teslim/smmm"; OUT = T / "_kabul"; OUT.mkdir(exist_ok=True)
RED = {("SPK_YHZ_20261102_1.yaml", 20), ("GKY_TUR_20261102_1.yaml", 20), ("TAB_LIK_20261102_3.yaml", 2)}
EK_RET = set(json.loads((KARAR / "ek_ret.json").read_text())) if (KARAR / "ek_ret.json").exists() else set()
K = {}
for f in KARAR.glob("g??.jsonl"):
    for l in f.read_text(encoding="utf-8").splitlines():
        if l.strip():
            k = json.loads(l); K[k["ref"]] = k
say = {"kabul": 0, "duzelt": 0, "ret": 0, "oto_ret": 0, "kararsiz": 0}
for f in sorted(T.glob("*.yaml")):
    if f.name.startswith("_") or f.name == "SHK_TCR_20261102_1.yaml":
        continue
    liste = yaml.safe_load(f.read_text(encoding="utf-8"))
    kalan = []
    for i, s in enumerate(liste, 1):
        ref = f"{f.name}#{i}"
        if (f.name, i) in RED:
            say["oto_ret"] += 1; continue
        k = K.get(ref)
        if not k:
            say["kararsiz"] += 1; continue
        if k["karar"] == "ret" or ref in EK_RET:
            say["ret"] += 1; continue
        if k["karar"] == "duzelt":
            d = k.get("duzeltme") or {}
            ac = s.setdefault("aciklama", {})
            if "kok" in d: s["kok"] = d["kok"]
            if "dogru_neden" in d: ac["dogru_neden"] = d["dogru_neden"]
            for h, yeni in (d.get("secenekler") or {}).items():
                eski = s["secenekler"][h]
                s["secenekler"][h] = yeni
                cel = (ac.get("celdiriciler") or {})
                if h != s["dogru"] and h in cel:
                    eski_say = re.sub(r"[^\d,]", "", eski)
                    if eski_say and eski_say in re.sub(r"[^\d,]", "", cel[h]) or re.search(r"\(", eski):
                        cel[h] = (f"{yeni} doğru hesaplamanın sonucu değildir; kökteki verilerle doğru sonuç "
                                  f"{s['secenekler'][s['dogru']]} olarak bulunur.")
            s.setdefault("gecmis", []).append({"tarih": "2026-11-02", "kim": "denetçi", "ne": "düzeltme: " + k.get("neden", "")[:200]})
            say["duzelt"] += 1
        else:
            say["kabul"] += 1
        kalan.append(s)
    (OUT / f.name).write_text(yaml.safe_dump({"yazar": "harici üretici (claude-sonnet-5-5)", "gorev": "SMMM talimatı 2026-11-02", "sorular": kalan},
                                             allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
print(say)
