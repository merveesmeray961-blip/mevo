"""11 Kasım 2026 üretim turu: ajan başına görev paketi (GOREV.md, MEVCUT_SORULAR.md, ORNEKLER.yaml).
Çıktı: uretim2/<AJAN>/ ; mevzuat metinleri ayrıca uretim2/_mevzuat.zip"""
import csv, json, random, shutil, zipfile
from collections import defaultdict
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
C = KOK / "uretim2"
if C.exists():
    shutil.rmtree(C)
C.mkdir()

SMMM = {  # ajan: [(ders, konu, adet)]
    "SMMM_A": [("MAL", "STD", 25), ("MAL", "DIG", 20), ("MAL", "SAF", 15), ("MAL", "SIP", 20), ("FIN", "BOR", 20)],
    "SMMM_B": [("MLY", "BUT", 20), ("MLY", "KGH", 20), ("EKO", "DIS", 20), ("VER", "AAT", 20), ("MES", "HRK", 20)],
    "SMMM_C": [("DEN", "KAL", 20), ("DEN", "PRG", 20), ("STD", "KRL", 20), ("SPK", "YEN", 20), ("TAB", "TMS", 20)],
}
YMM_TEST = {"VTK": 70, "GUV": 60, "HSV": 60, "DTK": 55, "SPM": 55}
YMM_KLASIK = {"VTK": 9, "DTK": 9, "SPM": 9, "IFM": 9, "REV": 9}


def oku(klasor):
    d = defaultdict(list)
    for p in (KOK / klasor).rglob("*.yaml"):
        for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
            if s.get("durum") != "geri_cekildi":
                d[(s["ders"], s.get("konu"))].append(s)
    return d


ad = {}
for u in ("smmm", "ymm"):
    p = KOK / f"docs/uretim_talimati/dagilim_{u}.csv"
    for r in csv.DictReader(open(p, encoding="utf-8")):
        ad[(u, r["ders"], r["konu"])] = (r.get("ders_ad"), r.get("konu_ad"), r.get("bolum"))


def kisalt(t, n=150):
    t = " ".join(str(t).split())
    return t[:n] + ("…" if len(t) > n else "")


def paket(ajan, sinav, test_hedef, klasik_hedef):
    k = C / ajan; k.mkdir()
    T = oku(f"content/sorular/{sinav}"); K = oku(f"content/klasik/{sinav}") if sinav == "ymm" else {}
    satir = [f"# Görev — {ajan} ({sinav.upper()}) · 11 Kasım 2026", "",
             "Aşağıdaki adetler KESİNDİR (paketteki başka hedef tablolarını dikkate alma).", "",
             "| Ders | Konu kodu | Konu | Bankadaki test | **Yazılacak test** | Bankadaki klasik | **Yazılacak klasik** |",
             "|---|---|---|---|---|---|---|"]
    mevcut = ["# Bankadaki sorular (tekrar yazma: aynı senaryo/hesap/olgu yasak)", ""]
    ornek = []
    for ders, konu, n in test_hedef:
        kn = klasik_hedef.get((ders, konu), 0)
        a = ad.get((sinav, ders, konu), (ders, konu, ""))
        satir.append(f"| {ders} | {konu} | {a[1]} | {len(T[(ders, konu)])} | **{n}** | {len(K.get((ders, konu), []))} | **{kn}** |")
        mevcut.append(f"## {ders}/{konu} — {a[1]}")
        for s in T[(ders, konu)]:
            mevcut.append(f"- {kisalt(s['kok'])}")
        for s in K.get((ders, konu), []):
            mevcut.append(f"- [klasik] {kisalt(s['soru'], 200)}")
        mevcut.append("")
        iyi = [s for s in T[(ders, konu)] if s.get("durum") == "kontrolde"]
        random.Random(7).shuffle(iyi)
        ornek += iyi[:1]
    for (ders, konu), kn in klasik_hedef.items():
        if not any(d == ders and c == konu for d, c, _ in test_hedef):
            a = ad.get((sinav, ders, konu), (ders, konu, ""))
            satir.append(f"| {ders} | {konu} | {a[1]} | {len(T[(ders, konu)])} | **0** | {len(K.get((ders, konu), []))} | **{kn}** |")
            mevcut.append(f"## {ders}/{konu} — {a[1]} (klasik)")
            for s in K.get((ders, konu), []):
                mevcut.append(f"- [klasik] {kisalt(s['soru'], 200)}")
            mevcut.append("")
    if sinav == "ymm":
        kk = [s for v in K.values() for s in v if s.get("durum") == "kontrolde" and s["ders"] in {d for d, _, _ in test_hedef}]
        ornek += kk[:1]
    satir += ["", f"Toplam test: **{sum(n for *_, n in test_hedef)}**, toplam klasik: **{sum(klasik_hedef.values())}**.",
              "Konu kodlarını (ders, konu alanları) tabloda yazıldığı gibi kullan."]
    (k / "GOREV.md").write_text("\n".join(satir) + "\n", encoding="utf-8")
    (k / "MEVCUT_SORULAR.md").write_text("\n".join(mevcut) + "\n", encoding="utf-8")
    temiz = [{a: v for a, v in s.items() if a not in ("gecmis", "uretim", "durum")} for s in ornek]
    (k / "ORNEKLER.yaml").write_text(yaml.safe_dump(temiz, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")


for ajan, liste in SMMM.items():
    paket(ajan, "smmm", liste, {})
T = oku("content/sorular/ymm")
for ders in sorted(set(YMM_TEST) | set(YMM_KLASIK)):
    konular = sorted({c for d, c in T if d == ders}, key=lambda c: len(T[(ders, c)]))
    n = YMM_TEST.get(ders, 0)
    hedef = []
    if n:
        pay = [n // len(konular)] * len(konular)
        for i in range(n - sum(pay)):
            pay[i] += 1
        hedef = [(ders, c, p) for c, p in zip(konular, pay) if p]
    kh = {}
    if YMM_KLASIK.get(ders):
        K = oku("content/klasik/ymm")
        kon = sorted({c for d, c in T if d == ders}, key=lambda c: len(K.get((ders, c), [])))
        for i in range(YMM_KLASIK[ders]):
            kh[(ders, kon[i % len(kon)])] = kh.get((ders, kon[i % len(kon)]), 0) + 1
    paket(f"YMM_{ders}", "ymm", hedef, kh)
with zipfile.ZipFile(C / "_paket.zip", "w", zipfile.ZIP_DEFLATED) as z:
    for p in C.rglob("*"):
        if p.is_file() and p.suffix != ".zip":
            z.write(p, p.relative_to(C))
    for p in (KOK / "content/kaynaklar/mevzuat").glob("*.txt"):
        z.write(p, "_mevzuat/" + p.name)
    z.write(KOK / "docs/uretim_talimati/SMMM_URETIM_TALIMATI.md", "_ortak/SMMM_URETIM_TALIMATI.md")
print(sorted(p.name for p in C.iterdir()), (C / "_paket.zip").stat().st_size)
