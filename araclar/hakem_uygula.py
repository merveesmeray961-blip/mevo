"""Hakem sonuçlarını (content/teslim/ymm_hakem/sonuc/*.json) taslak YMM sorularına işler.

- İncelenen soru: degisiklikler uygulanır; kabul/duzelt → kontrolde, ret → geri_cekildi.
- İncelenmeyen soru (kabul örneklemesi): dersin örneklem kusur oranı ESIK'i aşmıyorsa ve (test için)
  yerel model uyuşmazlığı yoksa → kontrolde; aksi hâlde taslakta kalır (tam inceleme gerekir).
Kullanım: python araclar/hakem_uygula.py [--kuru]   (--kuru: dosyaya yazmaz, yalnız rapor)
"""
import datetime as dt, json, sys
from collections import defaultdict
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
H = KOK / "content/teslim/ymm_hakem"
ESIK = 0.10
KURU = "--kuru" in sys.argv
BUGUN = dt.date.today().isoformat()

secim = json.loads((H / "secim.json").read_text(encoding="utf-8"))
sonuc = {}
for p in sorted((H / "sonuc").glob("sonuc_*.json")):
    for r in json.loads(p.read_text(encoding="utf-8")):
        sonuc[r["id"]] = r
kor = {}
for kp in (H / "kor_gemma4_12b.jsonl", H / "kor_gemma4_12b_tekrar.jsonl"):  # tekrar, öncekini ezer
    if kp.exists():
        for l in kp.read_text(encoding="utf-8").splitlines():
            if l.strip():
                k = json.loads(l)
                if k["model"] != "?" or k["id"] not in kor:
                    kor[k["id"]] = k

# Ders bazında örneklem kusur oranı (yalnız rastgele örneklem; işaretliler yanlı olduğu için hariç).
oran = {}
for tur in ("test", "klasik"):
    say = defaultdict(lambda: [0, 0])
    for sid, neden in secim[tur].items():
        if neden == "örneklem" and sid in sonuc:
            ders = sid.split("-")[1]
            say[ders][0] += 1
            say[ders][1] += sonuc[sid]["karar"] != "kabul"
    oran[tur] = {d: (k / n if n else 1.0, n) for d, (n, k) in say.items()}


def uygula(s, r, tur):
    hatalar = []
    for d in r.get("degisiklikler") or []:
        alan, eski, yeni = d["alan"], d.get("eski", ""), d.get("yeni", "")
        hedef_metin = json.dumps(s["secenekler"].get(alan[-1]) if alan.startswith("secenek_") else s.get(alan), ensure_ascii=False)
        if yeni and yeni in hedef_metin and eski not in hedef_metin:
            continue  # daha önceki bir çalıştırmada zaten uygulanmış
        if alan == "dogru":
            s["dogru"] = yeni.strip(); continue
        if alan.startswith("secenek_"):
            h = alan[-1]; hedef = s["secenekler"]
            if hedef.get(h, "").count(eski) == 1: hedef[h] = hedef[h].replace(eski, yeni); continue
            hatalar.append(alan); continue
        if alan == "puanlama":
            bulundu = False
            for o in s.get("puanlama") or []:
                if eski in o.get("olcut", ""):
                    o["olcut"] = o["olcut"].replace(eski, yeni, 1); bulundu = True; break
            if not bulundu: hatalar.append(alan)
            continue
        if isinstance(s.get(alan), str) and s[alan].count(eski) == 1:
            s[alan] = s[alan].replace(eski, yeni); continue
        # İç içe alan (ör. aciklama içindeki çeldirici notları): metni geçtiği tek yerde değiştir.
        yerler = []
        def gez(o):
            for k, v in (o.items() if isinstance(o, dict) else enumerate(o) if isinstance(o, list) else []):
                if isinstance(v, str) and eski in v: yerler.append((o, k))
                else: gez(v)
        gez(s.get(alan))
        if len(yerler) == 1 and yerler[0][0][yerler[0][1]].count(eski) == 1:
            o, k = yerler[0]; o[k] = o[k].replace(eski, yeni); continue
        hatalar.append(alan)
    return hatalar


rapor = defaultdict(int); sorunlu = []
for tur, klasor in (("test", "content/sorular/ymm"), ("klasik", "content/klasik/ymm")):
    for yol in sorted((KOK / klasor).rglob("*.yaml")):
        liste = yaml.safe_load(yol.read_text(encoding="utf-8")) or []
        degisti = False
        for s in liste:
            if s.get("durum") != "taslak":
                continue
            r = sonuc.get(s["id"])
            ders = s["ders"]
            if r:
                hata = uygula(s, r, tur) if r["karar"] == "duzelt" else []
                if hata:
                    sorunlu.append((s["id"], hata)); rapor[f"{tur} düzeltme uygulanamadı"] += 1; continue
                yeni = "geri_cekildi" if r["karar"] == "ret" else "kontrolde"
                neden = f"hakem {r['karar']}" + (f": {r['sorun']}" if r.get("sorun") else "")
            else:
                o, n = oran[tur].get(ders, (1.0, 0))
                k = kor.get(s["id"])
                if tur == "test" and (not k or not k["tutar"]):
                    rapor[f"{tur} beklemede (yerel model yok/uyuşmaz)"] += 1; continue
                if n == 0 or o > ESIK:
                    rapor[f"{tur} beklemede (ders {ders} örneklem kusuru %{o*100:.0f}, n={n})"] += 1; continue
                yeni, neden = "kontrolde", f"kabul örneklemesi: {ders} örneklem kusuru %{o*100:.0f} (n={n})" + (", yerel model tuttu" if tur == "test" else "")
            s.setdefault("uretim", {}).setdefault("kapilar", {})["G5"] = {
                "sonuc": "kaldi" if yeni == "geri_cekildi" else "gecti", "tarih": BUGUN, "not": neden[:300]}
            s.setdefault("gecmis", []).append({"tarih": BUGUN, "kim": "hakem", "ne": f"durum: taslak → {yeni}", "neden": neden[:300]})
            s["durum"] = yeni
            rapor[f"{tur} {yeni}"] += 1
            degisti = True
        if degisti and not KURU:
            yol.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")

print(json.dumps({"oran": {t: {d: f"%{o*100:.0f} n={n}" for d, (o, n) in v.items()} for t, v in oran.items()},
                  "rapor": rapor, "uygulanamayan": sorunlu}, ensure_ascii=False, indent=1))
