"""11.11 teslimi yeni sorularda dışa aktarım (G2/G4) elemelerini mekanik olarak onarır.
1) SMMM yeni sorularda 1-5 zorluk ölçeği → 1-3 (1,2→1; 3→2; 4,5→3)
2) dogrulama 'sonuc' sözlük ise doğru şık tutarına eşit anahtar seçilir (sonuc = sonuc[...]).
3) Doğru şıkkı sayı olmayan (tarih vb.) 'hesaplama' soruları → tip 'uygulama' (G4 sayısal kıyas yapamaz).
4) Olumsuz kök sözcüğü soru cümlesinde kalın yapılır.
Kullanım: python araclar/u1111_onar.py [--kuru]"""
import json, re, sys, glob
from pathlib import Path
import yaml
KOK = Path(__file__).resolve().parents[1]; sys.path.insert(0, str(KOK))
from pipeline import g2_yapi, g4_hesap
KURU = "--kuru" in sys.argv
yeni = set()
for f in glob.glob(str(KOK / "content/teslim/u1111_hakem/paket/*test*.json")):
    yeni |= {q["id"] for q in json.load(open(f, encoding="utf-8"))}
ZOR = {1: 1, 2: 1, 3: 2, 4: 3, 5: 3}
rapor = {}
def say(k): rapor[k] = rapor.get(k, 0) + 1
def calis(kod):
    ad = {"__builtins__": g4_hesap.IZINLI}
    exec(kod, ad); return ad.get("sonuc")
for yol in sorted((KOK / "content/sorular").rglob("*.yaml")):
    liste = yaml.safe_load(yol.read_text(encoding="utf-8")) or []
    degisti = False
    for s in liste:
        if s.get("id") not in yeni or s.get("durum") != "kontrolde":
            continue
        if s["sinav"] == "smmm" and s.get("zorluk") in ZOR:
            z = ZOR[s["zorluk"]]
            if z != s["zorluk"]: s["zorluk"] = z; degisti = True; say("zorluk")
        d = s.get("dogrulama") or {}
        if s.get("tip") == "hesaplama" and d.get("python"):
            dv = g4_hesap.sayiya_cevir(s["secenekler"][s["dogru"]])
            try:
                r = calis(d["python"]) if not re.search(r"\b(import|open|exec|eval|__)", d["python"]) else "YASAK"
            except Exception:
                r = "HATA"
            if dv is None:
                s["tip"] = "uygulama"; degisti = True; say("tip→uygulama (sayısal olmayan doğru şık)")
            elif isinstance(r, dict):
                anahtar = [k for k, v in r.items() if isinstance(v, (int, float)) and g4_hesap.esit(abs(v), abs(dv))]
                if anahtar:
                    d["python"] = d["python"].rstrip() + f"\nsonuc = sonuc[{anahtar[-1]!r}]"; degisti = True; say("sonuc sözlük→tutar")
                else:
                    say("ELLE: sözlükte doğru tutar yok " + s["id"])
            elif r in ("YASAK", "HATA") or isinstance(r, str):
                say(f"ELLE: doğrulama {r if isinstance(r,str) and len(r)<10 else 'metin'} " + s["id"])
        # olumsuz kök
        satirlar = s["kok"]
        son = re.split(r"(?<=[.!])\s+", "\n".join(x for x in satirlar.splitlines() if not re.match(r"\s*[IVX]+\.\s", x)).strip())[-1]
        m = g2_yapi.OLUMSUZ.search(son)
        if m and satirlar.count(son) == 1:
            yeni_son = son[:m.start()] + f"**{m.group(0)}**" + son[m.end():]
            s["kok"] = satirlar.replace(son, yeni_son); degisti = True; say("olumsuz kalın")
    if degisti and not KURU:
        yol.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
print(json.dumps(rapor, ensure_ascii=False, indent=1))
