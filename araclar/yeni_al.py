"""ymm_yeni teslimi: @@kaynak:: işaretli alıntıları temizler; işaretli klasikleri ve hatasız testleri alım için hazırlar."""
import json, re, glob, os, yaml

T = "content/teslim/ymm_yeni"
OUT = T + "/_al2"
os.makedirs(OUT, exist_ok=True)
oto = json.load(open(T + "/_kontrol/otomatik.json", encoding="utf-8"))
hata = {(r["dosya"], r["no"]): r["hata"] for r in oto if r["hata"] and not all(h.startswith("şema") for h in r["hata"])}


def temizle(q):
    deg = False
    for k in q.get("kaynaklar") or []:
        a = str(k.get("alinti") or "")
        b = re.sub(r"@@[\w]+::", "", a).replace("@@", "")
        if b != a:
            k["alinti"] = b.strip()
            deg = True
    return deg


say = {"klasik_isaretli": 0, "test_temiz": 0, "test_isaret_duzeltildi": 0, "test_dislanan": 0}
for f in sorted(glob.glob(T + "/*.yaml")):
    ad = os.path.basename(f)
    liste = yaml.safe_load(open(f, encoding="utf-8")) or []
    klasik, test = [], []
    ti = 0
    for i, q in enumerate(liste, 1):
        if "cozum" in q:
            if temizle(q):  # işaretli alıntı → ilk alımda reddedilmişti
                klasik.append(q)
                say["klasik_isaretli"] += 1
        elif "secenekler" in q:
            h = hata.get((ad, i))
            if not h:
                test.append(q); say["test_temiz"] += 1
            elif all(x.startswith("alıntı") for x in h) and temizle(q):
                test.append(q); say["test_isaret_duzeltildi"] += 1
            else:
                say["test_dislanan"] += 1
    if klasik or test:
        yaml.safe_dump({"yazar": "harici üretici (claude, paket 2026-11-05)", "gorev": "YMM paketi 2026-11-05",
                        "klasik": klasik, "sorular": test},
                       open(f"{OUT}/{ad}", "w", encoding="utf-8"), allow_unicode=True, sort_keys=False, width=120)
print(say)
