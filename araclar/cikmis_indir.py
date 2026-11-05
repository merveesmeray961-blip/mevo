"""TESMER geçmiş dönem soru-cevap PDF'lerini indirir: content/kaynaklar/cikmis/<tur>/<tur>_<yil>_<donem>_<ders>[_<ek>].pdf
Kullanım: python cikmis_indir.py sgs smmm ymm"""
import json, pathlib, sys, time, urllib.request
KOK = pathlib.Path(__file__).resolve().parents[1] / "content/kaynaklar/cikmis"
B = "https://www2.tesmer.org.tr"
EKLER = ["yabancidil_muaf", "ingilizce"]
def al(u, ikili=False):
    for d in range(3):
        try:
            with urllib.request.urlopen(urllib.request.Request(B + u, headers={"User-Agent": "Mozilla/5.0"}), timeout=60) as r:
                v = r.read()
                return v if ikili else json.loads(v.decode("utf-8", "replace"))
        except Exception as e:
            if d == 2: return None
            time.sleep(2)
kayit = []
for tur in sys.argv[1:]:
    hedef = KOK / tur; hedef.mkdir(parents=True, exist_ok=True)
    for y in [x["id"] for x in al(f"/ajax.php?type=sinav_yili&sinav_turu={tur}") or []]:
        for d in [x["id"] for x in al(f"/ajax.php?type=sinav_donemi&sinav_turu={tur}&sinav_yili={y}") or []]:
            for ders in al(f"/ajax.php?type=sinav_ders_turu&sinav_turu={tur}&sinav_yili={y}&sinav_donemi={d}") or []:
                k = ders["id"]
                adlar = [f"{tur}_{y}_{d}_{k}"] + ([f"{tur}_{y}_{d}_{k}_{e}" for e in EKLER] if tur == "sgs" and int(y) >= 2016 else [])
                for ad in adlar:
                    f = hedef / f"{ad}.pdf"
                    if f.exists() and f.stat().st_size > 1000:
                        kayit.append({"dosya": f.name, "ders": ders["value"], "durum": "vardı"}); continue
                    v = al(f"/files/ortak/soru_cevaplar/{tur}/{y}/{d}/{k}/{ad}.pdf", ikili=True)
                    if v and v[:4] == b"%PDF":
                        f.write_bytes(v); kayit.append({"dosya": f.name, "ders": ders["value"], "durum": "indi"})
                    print(ad, "ok" if v and v[:4] == b"%PDF" else "yok", flush=True)
    (hedef / "_liste.json").write_text(json.dumps([k for k in kayit if k["dosya"].startswith(tur)], ensure_ascii=False, indent=1), "utf-8")
print("BITTI", len(kayit), flush=True)
