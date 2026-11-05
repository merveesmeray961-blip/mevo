"""p2 sorularında G2/G4 biçim kapılarına takılanları onarır (şık sırası, olumsuz kök kalın); onarılamayanları taslağa çeker."""
import glob, re, sys, os
sys.path.insert(0, os.getcwd())
import yaml
from pipeline import g2_yapi, g4_hesap
say = {"sira": 0, "kalin": 0, "geri": 0}
for p in glob.glob("content/sorular/smmm/*/*.p2.yaml"):
    d = yaml.safe_load(open(p, encoding="utf-8")); degisti = False
    for q in d:
        if q.get("durum") != "kontrolde":
            continue
        # olumsuz kök
        son = re.split(r"(?<=[.!])\s+", q["kok"].strip())
        if g2_yapi.OLUMSUZ.search(son[-1]):
            son[-1] = g2_yapi.OLUMSUZ.sub(lambda m: f"**{m.group(0)}**", son[-1])
            q["kok"] = " ".join(son); say["kalin"] += 1; degisti = True
        h = g4_hesap.soru_denetle(q).hatalar
        harf_atif = re.search(r"\b[A-E] (şıkkı|şıkkında|seçene)", str(q.get("aciklama")))
        if any("sıralı değil" in x for x in h) and len(h) == 1 and not harf_atif:
            deg = {k: g4_hesap.sayiya_cevir(v) for k, v in q["secenekler"].items()}
            sirali = sorted("ABCDE", key=lambda k: deg[k])
            eski = q["secenekler"]; cel = q["aciklama"].get("celdiriciler") or {}
            esle = {e: y for y, e in zip("ABCDE", sirali)}  # eski harf → yeni harf
            q["secenekler"] = {y: eski[e] for y, e in zip("ABCDE", sirali)}
            q["aciklama"]["celdiriciler"] = {esle[e]: t for e, t in cel.items()}
            q["dogru"] = esle[q["dogru"]]
            say["sira"] += 1; degisti = True
            h = g4_hesap.soru_denetle(q).hatalar
        h += g2_yapi.soru_denetle(q).hatalar if hasattr(g2_yapi, "soru_denetle") else []
        if h:
            q["durum"] = "taslak"
            q.setdefault("gecmis", []).append({"tarih": "2026-11-02", "kim": "asistan", "ne": "otomatik kapı: " + "; ".join(h)[:200]})
            say["geri"] += 1; degisti = True
    if degisti:
        open(p, "w", encoding="utf-8").write(yaml.safe_dump(d, allow_unicode=True, sort_keys=False, width=120))
print(say)
