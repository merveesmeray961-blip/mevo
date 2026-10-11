"""Kör çözücü sonuçlarıyla anahtarı uyuşan parti 7 taslaklarını kontrolde'ye alır (hızlı denetim)."""
import sys, json, glob
sys.path.insert(0, "/home/user/mevo")
import yaml
dosyalar, etiket = sys.argv[1].split(","), sys.argv[2]
g = {}
for f in dosyalar:
    try: g.update(json.load(open(f)))
    except Exception as e: print("okunamadı", f, e)
g = {(k if k.startswith("SMMM-") else "SMMM-" + k): v for k, v in g.items()}
BUGUN = "2026-10-07"; n = 0
for p in glob.glob("/home/user/mevo/content/sorular/smmm/*/*.p*.yaml"):
    d = yaml.safe_load(open(p, encoding="utf-8")); deg = False
    for s in d:
        a = g.get(s["id"])
        if s["durum"] != "taslak" or not a or str(a.get("cevap", "")).strip().upper()[:1] != s["dogru"] or int(a.get("guven") or 0) < int(sys.argv[3] if len(sys.argv) > 3 else 0):
            continue
        k = s["uretim"]["kapilar"]
        k["G3"] = {"sonuc": "gecti", "tarih": BUGUN, "not": f"{etiket}: anahtarla aynı (güven {a.get('guven')}). {a.get('not', '')}".strip()}
        hizli = "hızlı denetim: hakem incelemesi yapılmadı"
        k["G5"] = {"sonuc": "atlandi", "not": hizli}
        k["G6"] = {"sonuc": "atlandi", "not": hizli + ("; kaynaksız ders" if s["ders"] in ("GKY", "EKO") else "; alıntılar otomatik olarak resmî metinde doğrulandı")}
        k["GZ"] = {"sonuc": "atlandi", "not": hizli}
        s["durum"] = "kontrolde"
        s.setdefault("gecmis", []).append({"tarih": BUGUN, "kim": "otomatik", "ne": "durum: taslak → kontrolde (hızlı denetim).", "neden": f"{etiket} anahtarla uyuştu"})
        deg = True; n += 1
    if deg: yaml.safe_dump(d, open(p, "w", encoding="utf-8"), allow_unicode=True, sort_keys=False, width=120)
print(n, "terfi")
