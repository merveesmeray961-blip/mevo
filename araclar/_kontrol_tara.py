"""Hakem düzeltmelerinden sonra eskide kalan doğrulama kodları ve bir gerekçe metni (11 Kasım 2026)."""
from pathlib import Path
import yaml

K = Path(__file__).resolve().parents[1]
DOG = {
    "YMM-HSV-USL-K007": [("oran=0.075", "oran=0.05  # 10767 sayılı CBK: 2026 için %5"),
                         ("a_vergi==3000000 and b_vergi==1500000 and kv_tasarruf==750000",
                          "a_vergi==2000000 and b_vergi==1000000 and kv_tasarruf==500000")],
    "YMM-REV-AKT-K012": [("toplam = arsa_etki - yol_am + kat_etki + ozel_etki",
                          "yalitim_am = 500000 * 0.02\ntoplam = arsa_etki - yol_am - yalitim_am + kat_etki + ozel_etki")],
    "YMM-REV-ULU-K011": [("b2 = 600000 * 0.15", "b2 = 600000 * 0.20  # kooperatif kira ödemesi: %20")],
    "YMM-SPM-IHR-K018": [("satilamayan = 2000000 * 20", "satilamayan = 2000000 * 18  # md. 5/7 son cümle: taban fiyat")],
}
METIN = {"YMM-FYN-ZDP-0021": ("Yanlış ifade C'dir", "Yanlış ifade E'dir")}
for d in ("content/sorular", "content/klasik"):
    for p in (K / d).rglob("*.yaml"):
        liste = yaml.safe_load(p.read_text(encoding="utf-8")) or []
        degisti = False
        for s in liste:
            for eski, yeni in DOG.get(s["id"], []):
                kod = s["dogrulama"]["python"]
                assert kod.count(eski) == 1, (s["id"], eski)
                s["dogrulama"]["python"] = kod.replace(eski, yeni); degisti = True
            if s["id"] in METIN:
                eski, yeni = METIN[s["id"]]
                assert eski in s["aciklama"]["dogru_neden"]
                s["aciklama"]["dogru_neden"] = s["aciklama"]["dogru_neden"].replace(eski, yeni); degisti = True
        if degisti:
            p.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
            print("yazildi", p.name)
