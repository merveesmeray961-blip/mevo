"""Genel (soruya özgü olmayan) çeldirici açıklaması taşıyan soruları bulur ve yeniden yazım paketleri hazırlar.
Genel sayılan: >=3 kez tekrar eden VE soruya özgü bilgi taşımayan kalıplar ("Bu seçenek ...", "İlgili BDS'nin ..." vb.).
"I/II/III doğru-yanlış" gibi kısa ama doğru öncül notları genel sayılmaz."""
import collections, json, re
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
P = KOK / "content/teslim/kalip"; P.mkdir(parents=True, exist_ok=True)
for e in P.glob("kalip_*.json"):
    e.unlink()
GENEL = re.compile(r"^(bu seçenek|bu kombinasyon|bu şık|ilgili (bds|tms|tfrs|madde|hüküm|kanun)|seçenek,|bu ifade,? (kökteki|kaynak|soruda))", re.I)
tum = []
say = collections.Counter()
for p in sorted((KOK / "content/sorular").rglob("*.yaml")):
    for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        a = s.get("aciklama")
        if s.get("durum") in ("geri_cekildi", "taslak") or not isinstance(a, dict):
            continue
        for t in (a.get("celdiriciler") or {}).values():
            say[(t or "").strip()] += 1
        tum.append(s)
secilen = []
for s in tum:
    c = s["aciklama"].get("celdiriciler") or {}
    kotu = [h for h, t in c.items() if (t or "").strip() and say[t.strip()] >= 3 and GENEL.match(t.strip())]
    if kotu:
        secilen.append({"id": s["id"], "kok": s["kok"], "secenekler": s["secenekler"], "dogru": s["dogru"],
                        "dogru_neden": s["aciklama"].get("dogru_neden", "")[:1500], "yeniden_yaz": kotu})
for i in range(0, len(secilen), 40):
    (P / f"kalip_{i // 40 + 1:02d}.json").write_text(json.dumps(secilen[i:i + 40], ensure_ascii=False, indent=1), encoding="utf-8")
print(len(secilen), "soru,", sum(len(x["yeniden_yaz"]) for x in secilen), "açıklama,", (len(secilen) + 39) // 40, "paket")
print(collections.Counter(x["id"].split("-")[0] for x in secilen))
