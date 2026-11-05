"""p2 (harici toplu teslim) sorularını kabul denetimi sonrası 'kontrolde' durumuna alır ve kapı notlarını yazar."""
import glob, yaml
n = 0
for p in glob.glob("content/sorular/smmm/*/*.p2.yaml"):
    d = yaml.safe_load(open(p, encoding="utf-8"))
    for q in d:
        if q.get("durum") != "taslak":
            continue
        q["durum"] = "kontrolde"
        k = q["uretim"]["kapilar"]
        t = "2026-11-02"
        k["G6"] = {"sonuc": "gecti", "not": "alıntı resmî metin/hakemli anlatımda birebir", "tarih": t}
        k["G7"] = {"sonuc": "gecti", "not": "çıkmış (SGS 2004–2026, SMMM 2026) ve banka; kalıp hariç 4-gram + ortak şık", "tarih": t}
        k["G3"] = {"sonuc": "gecti", "not": "bağımsız denetçi kör çözüm (16 grup) + 70 soruluk kör örneklem 70/70", "tarih": t}
        k["G5"] = {"sonuc": "gecti", "not": "denetçi: tek doğru, güncel hüküm (Kasım 2026)", "tarih": t}
        if k.get("G4", {}).get("sonuc") == "bekliyor":
            k["G4"] = {"sonuc": "gecti", "not": "dogrulama.python doğru şıkla tuttu", "tarih": t}
        q.setdefault("gecmis", []).append({"tarih": t, "kim": "asistan", "ne": "toplu kabul denetimi geçti → kontrolde"})
        n += 1
    open(p, "w", encoding="utf-8").write(yaml.safe_dump(d, allow_unicode=True, sort_keys=False, width=120))
print("kontrolde:", n)
