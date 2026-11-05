"""Taslak YMM sorularından hakem (Claude) inceleme paketleri hazırlar.

Seçim (kabul örneklemesi):
  test  : ek_kontrol işaretlileri + yerel model uyuşmazlıkları/boşları + kalanların %15'i (ders katmanlı)
  klasik: ek_kontrol işaretlileri + her dersten %12 (en az 5)
Çıktı: content/teslim/ymm_hakem/paket/{test,klasik}_NN.json (yalın alanlar) + secim.json

Kullanım: python araclar/hakem_hazirla.py [kor_dosyasi.jsonl]
"""
import json, random, sys
from collections import defaultdict
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
H = KOK / "content/teslim/ymm_hakem"
P = H / "paket"
P.mkdir(parents=True, exist_ok=True)
for eski in P.glob("*.json"):
    eski.unlink()


def oku(klasor):
    return [s for p in sorted((KOK / klasor).rglob("*.yaml"))
            for s in (yaml.safe_load(p.read_text(encoding="utf-8")) or []) if s.get("durum") == "taslak"]


testler, klasikler = oku("content/sorular/ymm"), oku("content/klasik/ymm")
isaret = json.loads((H / "ek_kontrol.json").read_text(encoding="utf-8")) if (H / "ek_kontrol.json").exists() else {}
kor = {}
if len(sys.argv) > 1 and Path(sys.argv[1]).exists():
    for l in Path(sys.argv[1]).read_text(encoding="utf-8").splitlines():
        if l.strip():
            k = json.loads(l)
            kor[k["id"]] = k
rnd = random.Random(2026)


def sec(liste, oran, en_az, neden_f):
    secim, gerekce = [], {}
    kalan = defaultdict(list)
    for s in liste:
        n = neden_f(s)
        if n:
            secim.append(s); gerekce[s["id"]] = n
        else:
            kalan[s["ders"]].append(s)
    for ders, l in kalan.items():
        rnd.shuffle(l)
        for s in l[:max(en_az, round(len(l) * oran))]:
            secim.append(s); gerekce[s["id"]] = "örneklem"
    return secim, gerekce


def test_neden(s):
    if s["id"] in isaret:
        return "işaret: " + "; ".join(isaret[s["id"]]) if isinstance(isaret[s["id"]], list) else "işaret"
    k = kor.get(s["id"])
    if k and k["model"] == "?":
        return None  # model cevap veremedi: örneklem dışı bilgi yok
    if k and not k["tutar"]:
        return f"yerel model {k['model']} dedi (anahtar {s['dogru']})"
    return None


ts, tg = sec(testler, 0.15, 3, test_neden)
ks, kg = sec(klasikler, 0.12, 5, lambda s: ("işaret: " + "; ".join(isaret[s["id"]]) if isinstance(isaret.get(s["id"]), list) else "işaret") if s["id"] in isaret else None)


def yalin_test(s):
    return {"id": s["id"], "ders": s["ders"], "konu": s.get("konu"), "kok": s["kok"], "secenekler": s["secenekler"],
            "dogru": s["dogru"], "aciklama": s.get("aciklama"), "kaynaklar": s.get("kaynaklar"), "hakem_notu": tg[s["id"]]}


def yalin_klasik(s):
    return {"id": s["id"], "ders": s["ders"], "konu": s.get("konu"), "puan": s.get("puan"), "soru": s["soru"],
            "cozum": s.get("cozum"), "puanlama": s.get("puanlama"), "kaynaklar": s.get("kaynaklar"),
            "dogrulama": s.get("dogrulama"), "hakem_notu": kg[s["id"]]}


def yaz(ad, liste, f, boy):
    liste = sorted(liste, key=lambda s: s["id"])
    n = 0
    for i in range(0, len(liste), boy):
        n += 1
        (P / f"{ad}_{n:02d}.json").write_text(json.dumps([f(s) for s in liste[i:i + boy]], ensure_ascii=False, indent=1), encoding="utf-8")
    return n


nt = yaz("test", ts, yalin_test, 40)
nk = yaz("klasik", ks, yalin_klasik, 12)
(H / "secim.json").write_text(json.dumps({"test": tg, "klasik": kg}, ensure_ascii=False, indent=1), encoding="utf-8")
print(f"test {len(ts)}/{len(testler)} → {nt} paket; klasik {len(ks)}/{len(klasikler)} → {nk} paket")
print("test gerekçe:", {k: sum(1 for v in tg.values() if v.startswith(k)) for k in ("işaret", "yerel", "örneklem")})
print("klasik gerekçe:", {k: sum(1 for v in kg.values() if v.startswith(k)) for k in ("işaret", "örneklem")})
