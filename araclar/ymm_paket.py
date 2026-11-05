"""YMM eksik soru üretimi için ders başına kendine yeterli paket (zip) hazırlar.

Kullanım (proje kökünde):  python araclar/ymm_paket.py [klasik_ek=300]
Çıktı: uretim_paketi/YMM_<DERS>.zip  — içinde BASLA.md, GOREV.md, TALIMAT.md, şemalar, örnekler,
MEVCUT_SORULAR.md (tekrar yasağı) ve kaynaklar/ (o dersin resmî mevzuat metinleri).
"""
import csv, json, shutil, sys, datetime as dt
from collections import Counter, defaultdict
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(KOK))
from pipeline import harita  # noqa: E402

harita.sinav_sec("ymm")
EK = int(sys.argv[1]) if len(sys.argv) > 1 else 300
BUGUN = dt.date.today().isoformat()
CIKTI = KOK / "uretim_paketi"
if CIKTI.exists():
    shutil.rmtree(CIKTI)
CIKTI.mkdir()

rows = list(csv.DictReader(open(KOK / "docs/uretim_talimati/dagilim_ymm.csv", encoding="utf-8")))
dersler = sorted({r["ders"] for r in rows}, key=[r["ders"] for r in rows].index)

# Bankadaki klasik vakalar (geri çekilen hariç)
klasik = defaultdict(list)
for p in (KOK / "content/klasik/ymm").rglob("*.yaml"):
    for k in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        if k.get("durum") != "geri_cekildi":
            klasik[(k["ders"], k["konu"])].append(k)
# Bankadaki test soruları
test = defaultdict(list)
for p in (KOK / "content/sorular/ymm").rglob("*.yaml"):
    for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        if s.get("durum") != "geri_cekildi":
            test[(s["ders"], s["konu"])].append(s)
teslim_test = Counter()
for p in (KOK / "content/sorular/ymm").rglob("*.p5.yaml"):
    for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        teslim_test[(s["ders"], s["konu"])] += 1

ozet = []
for ders in dersler:
    dr = [r for r in rows if r["ders"] == ders]
    # Klasik: ders başına EK/len(dersler) vaka, konu ağırlığı / (1 + mevcut) oranında
    pay = EK // len(dersler)
    w = {r["konu"]: float(r["agirlik_pay"]) / (1 + len(klasik[(ders, r["konu"])])) for r in dr}
    top = sum(w.values()) or 1
    k_ad = {k: int(pay * v / top) for k, v in w.items()}
    for k in sorted(w, key=lambda k: -w[k])[: pay - sum(k_ad.values())]:
        k_ad[k] += 1
    t_ad = {r["konu"]: max(0, int(r["test_uretilecek"]) - teslim_test[(ders, r["konu"])]) for r in dr}
    kl = CIKTI / f"YMM_{ders}"
    (kl / "kaynaklar").mkdir(parents=True)
    satir = [f"# Görev — Tasdik YMM · {dr[0]['ders_ad']} ({ders})", "",
             f"Hazırlanış: {BUGUN}. Önce **klasik vakaları**, sonra test sorularını yaz.", "",
             "| Konu kodu | Konu | Bankadaki klasik | **Yazılacak klasik** | Bankadaki test | **Yazılacak test** |",
             "|---|---|---|---|---|---|"]
    for r in dr:
        k = r["konu"]
        satir.append(f"| {k} | {r['konu_ad']} | {len(klasik[(ders, k)])} | **{k_ad[k]}** | {len(test[(ders, k)])} | **{t_ad[k]}** |")
    tk, tt = sum(k_ad.values()), sum(t_ad.values())
    satir += [f"| **Toplam** | | | **{tk}** | | **{tt}** |", ""]
    (kl / "GOREV.md").write_text("\n".join(satir) + "\n", encoding="utf-8")
    # Tekrar yasağı listesi
    m = [f"# Bankada ZATEN OLAN sorular — {ders}", "",
         "Aynı senaryoyu, aynı hesabı, aynı hükmü aynı kurguyla TEKRAR YAZMA. Farklı hüküm, istisna, şart veya vaka kur.", ""]
    for r in dr:
        k = r["konu"]
        m.append(f"## {k} — {r['konu_ad']}")
        for x in klasik[(ders, k)]:
            m.append("- [klasik] " + " ".join(str(x.get("soru", "")).split())[:220])
        for x in test[(ders, k)]:
            m.append("- [test] " + " ".join(str(x.get("kok", "")).split())[:150])
        m.append("")
    (kl / "MEVCUT_SORULAR.md").write_text("\n".join(m), encoding="utf-8")
    # Örnekler: dersin kontrolden geçmiş 2 klasik + 2 test sorusu
    ok_k = [x for (d, _), v in klasik.items() if d == ders for x in v if x.get("durum") in ("kontrolde", "onayli", "yayinda")][:2]
    ok_t = [x for (d, _), v in test.items() if d == ders for x in v if x.get("durum") in ("kontrolde", "onayli", "yayinda")][:2]
    temiz = lambda x: {a: b for a, b in x.items() if a not in ("uretim", "gecmis", "surum", "durum")}
    (kl / "ORNEKLER.yaml").write_text(yaml.safe_dump({"klasik": [temiz(x) for x in ok_k], "test": [temiz(x) for x in ok_t]},
                                                     allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    shutil.copy(KOK / "docs/uretim_talimati/YMM_URETIM_TALIMATI.md", kl / "TALIMAT.md")
    shutil.copy(KOK / "content/schema/klasik.schema.json", kl / "SEMA_klasik.json")
    shutil.copy(KOK / "content/schema/soru.schema.json", kl / "SEMA_test.json")
    on = harita.KAYNAK_ONEK.get(ders, [])
    kaynak = sorted(p for p in (KOK / "content/kaynaklar/mevzuat").glob("*.txt") if any(p.stem.startswith(o) for o in on))
    for p in kaynak:
        shutil.copy(p, kl / "kaynaklar" / p.name)
    if not kaynak:
        (kl / "kaynaklar" / "OKU.txt").write_text("Bu derste resmî mevzuat metni yoktur; sorular genel kabul görmüş "
                                                   "ders bilgisine dayanır. kaynaklar.alinti boş kalabilir.\n", encoding="utf-8")
    (kl / "BASLA.md").write_text(f"""# BAŞLA — Tasdik YMM soru üretimi ({ders})

Bu klasördeki dosyalar işin TAMAMIDIR. İnternette arama yapma, başka kaynak arama, mevzuat indirme.

1. `TALIMAT.md` kurallarını oku (bölüm 3 ve 3a kesin kurallardır). Talimattaki sayısal hedef tablolarını DİKKATE ALMA;
   bu paketteki adetler `GOREV.md`'dedir.
2. Mevzuat: yalnız `kaynaklar/` klasöründeki metinler. Bunlar Kasım 2026 itibarıyla yürürlükteki hükümler kabul edilir.
   `kaynaklar.alinti` bu dosyalardaki metinden BİREBİR kopya olmalı.
3. Biçim: `ORNEKLER.yaml`'deki örneklerle aynı alanlar; şema `SEMA_klasik.json` / `SEMA_test.json`. `id: TASLAK`.
4. Tekrar yasağı: `MEVCUT_SORULAR.md`'deki soruların senaryosunu/hesabını yeniden yazma.
5. Teslim: her konu için ayrı YAML dosyası, kök düzeyde LİSTE. Ad: `{ders}_<KONU>_{BUGUN.replace('-', '')}_<n>.yaml`
   (klasik ve test aynı dosyada olabilir). Bir dosyada en çok 15 soru.
6. Hesaplı vakalarda `dogrulama.python` çalıştırılır; çözümde geçen sayılarla tutmazsa soru reddedilir.
   Teslimden önce kodunu kendin çalıştırıp çözümdeki sayılarla karşılaştır.
7. Emin olmadığın hükümden soru yazma. Az ama doğru soru.
""", encoding="utf-8")
    shutil.make_archive(str(kl), "zip", kl.parent, kl.name)
    shutil.rmtree(kl)
    ozet.append(f"{ders}: klasik {tk}, test {tt}, kaynak {len(kaynak)} dosya")

print("\n".join(ozet))
print("TOPLAM klasik", EK - EK % len(dersler), "| zip klasörü:", CIKTI)
