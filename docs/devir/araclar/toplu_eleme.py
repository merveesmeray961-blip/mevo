"""Toplu teslim ön elemesi: biçim düzeltme, alıntı doğrulama, tekrar taraması → ders başına al'a hazır YAML."""
import sys, re, glob, collections
sys.path.insert(0, "/home/user/mevo")
import yaml
from pipeline import g2_yapi
from pipeline.uretici_paketi import alinti_sorunlari, _norm, DERS_KAYNAK

kaynak_dizin, cikti_dizin = sys.argv[1], sys.argv[2]
SINAV = sys.argv[3] if len(sys.argv) > 3 else "smmm"
m = yaml.safe_load(open(f"/home/user/mevo/content/mufredat/{SINAV}.yaml", encoding="utf-8"))
konular = {(d["kod"], k["kod"]) for d in m["dersler"] for k in d["konular"]}
HARF = "ABCDE"
KONU_DERS = {}
for d_, k_ in konular: KONU_DERS.setdefault(k_, d_)
# Üreticiler bazen konu kodu yerine konu adını yazar: ad → kod eşlemesi (+ kısa adlar).
KONU_AD = {(d["kod"], k["ad"].casefold()): k["kod"] for d in m["dersler"] for k in d["konular"]}
KISA_AD = {"ötv": "OTV", "damga vergisi": "DMG", "harçlar": "DMG", "usul": "USL", "mtv": "SRV",
           "emlak vergisi": "SRV", "veraset ve intikal": "SRV"}

def konu_coz(ders, konu):
    if (ders, konu) in konular or not isinstance(konu, str):
        return konu
    k = konu.strip().casefold()
    if (ders, k) in KONU_AD:
        return KONU_AD[(ders, k)]
    aday = [kod for (d, ad), kod in KONU_AD.items() if d == ders and (k in ad or ad in k)]
    if len(aday) == 1:
        return aday[0]
    return KISA_AD.get(k, konu)

def trigram(s):
    w = re.findall(r"\w+", s.lower())
    return {tuple(w[i:i+3]) for i in range(len(w) - 2)}

havuz = collections.defaultdict(list)
for _, s in (g2_yapi.dosyalari_yukle(g2_yapi.KOK / f"content/sorular/{SINAV}", []) if (g2_yapi.KOK / f"content/sorular/{SINAV}").exists() else []):
    if s.get("durum") != "geri_cekildi":
        havuz[(s["ders"], s["konu"])].append(trigram(s["kok"] + " " + " ".join(map(str, s["secenekler"].values()))))

cikti = collections.defaultdict(lambda: {"yazar": "coklu", "gorev": "toplu-2026-10-07", "atlanan": [], "sorular": []})
say = collections.defaultdict(collections.Counter)
for f in sorted(glob.glob(kaynak_dizin + "/**/*.y*ml", recursive=True)):
    ad = f.rsplit("/", 1)[1].replace("teslim_", "").rsplit(".", 1)[0]
    try:
        v = yaml.safe_load(open(f, encoding="utf-8"))
        sorular = v.get("sorular") or []
    except Exception as e:
        print("OKUNAMADI", ad, str(e)[:80]); continue
    puf = collections.Counter(p for s in sorular if isinstance(s, dict)
                              for p in re.findall(r"Püf noktaları:[^\n]*", str((s.get("aciklama") or {}).get("dogru_neden", ""))))
    for s in sorular:
        if not isinstance(s, dict): continue
        ders = str(s.get("ders", "")).upper()
        if ders in KONU_DERS and not any(d == ders for d, _ in konular):  # ders alanına konu kodu yazılmış
            s["konu"], ders = ders, KONU_DERS[ders]
        s["ders"] = ders
        etiket = f"{ad} #{s.get('gorev_satiri')}"
        def red(neden):
            say[ders][neden] += 1; cikti[ders]["atlanan"].append({"satir": etiket, "neden": neden})
        a = s.get("aciklama") or {}
        sec = s.get("secenekler") or {}
        if not isinstance(sec, dict) or sorted(sec) != list(HARF) or s.get("dogru") not in HARF or not isinstance(a, dict):
            red("biçim: şık/anahtar"); continue
        s["konu"] = konu_coz(ders, s.get("konu"))
        if (ders, s.get("konu")) not in konular:
            red("konu kodu geçersiz"); continue
        a["dogru_neden"] = str(a.get("dogru_neden", ""))
        for p, n in puf.items():
            if n >= 3: a["dogru_neden"] = a["dogru_neden"].replace(" " + p, "").replace(p, "")
        c = a.get("celdiriciler")
        if isinstance(c, list) and len(c) == 5: c = dict(zip(HARF, c))
        if isinstance(c, str):
            parca = re.split(r"(?:^|\s)([A-E])[:)]\s", c)
            c = {parca[i]: parca[i + 1].strip() for i in range(1, len(parca) - 1, 2)}
        if not isinstance(c, dict): red("biçim: çeldirici"); continue
        c = {k: re.sub(r"^(Doğru hüküm bu şıkta değil; \w: |[A-E]: )", "", str(t)) for k, t in c.items() if k != s["dogru"]}
        if sorted(c) != sorted(set(HARF) - {s["dogru"]}): red("biçim: çeldirici eksik"); continue
        a["celdiriciler"] = c; s["aciklama"] = a
        if not s.get("kok") or not s.get("kaynaklar") and DERS_KAYNAK.get(ders):
            red("kök/kaynak yok"); continue
        if DERS_KAYNAK.get(ders) and alinti_sorunlari(s.get("kaynaklar")):
            red("alıntı metinde yok"); continue
        t = trigram(str(s["kok"]) + " " + " ".join(map(str, sec.values())))
        h = havuz[(ders, s["konu"])]
        if any(len(t & x) / max(1, len(t | x)) > 0.45 for x in h):
            red("tekrar"); continue
        h.append(t)
        s.setdefault("bolum", ["SGS"] if ders in ("GKY", "STD", "EKO", "MLY") else ["YET"])
        s["gorev_satiri"] = etiket
        cikti[ders]["sorular"].append(s); say[ders]["aday"] += 1

top = collections.Counter()
for ders, v in sorted(cikti.items()):
    yaml.safe_dump(v, open(f"{cikti_dizin}/aday_{ders}.yaml", "w", encoding="utf-8"), allow_unicode=True, sort_keys=False, width=120)
    print(ders, dict(say[ders])); top.update(say[ders])
print("TOPLAM", dict(top))
