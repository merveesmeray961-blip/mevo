"""Dışa aktarımda G2/G4 nedeniyle elenen eski YMM test sorularını mekanik olarak onarır (11.11.2026).
- Doğru şıkkı sayı olmayan ya da yalnız kural uygulayan (tarih, yasal sınır) 'hesaplama' soruları → tip 'uygulama'
- Olumsuz kök sözcüğü kalın; yıla bağlı tutarda eksik 'yil' → 2026; yuvarlama farkı → round()"""
import re, sys
from pathlib import Path
import yaml
KOK = Path(__file__).resolve().parents[1]; sys.path.insert(0, str(KOK))
from pipeline import g2_yapi
UYGULAMA = {"DTK-KMB-0111", "DTK-KMB-0113", "DTK-KMB-0115", "IFM-ENF-0048", "REV-GNL-0077", "SPM-DNT-0053",
            "SPM-DNT-0054", "SPM-IHR-0084", "SPM-IHR-0088", "SPM-HAO-0093", "SPM-HAO-0097", "SPM-PAL-0018",
            "SPM-SUC-0055", "SPM-YKF-0069", "SPM-YKF-0070", "SPM-YKF-0072", "SPM-YKF-0073", "VTK-CEZ-0020",
            "VTK-YRG-0023", "VTK-YRG-0024"}
KALIN = {"FYN-PIY-0020", "HSV-SRV-0067", "HSV-SRV-0074", "VTK-SRM-0018", "VTK-THS-0020", "VTK-UGN-0022"}
rapor = []
for yol in sorted((KOK / "content/sorular/ymm").rglob("*.yaml")):
    liste = yaml.safe_load(yol.read_text(encoding="utf-8")) or []
    degisti = False
    for s in liste:
        k = s["id"][4:]
        if k in UYGULAMA and s.get("tip") == "hesaplama":
            s["tip"] = "uygulama"; degisti = True; rapor.append((s["id"], "tip"))
        if k == "DTK-TKP-0024" and s.get("gecerlilik", {}).get("yila_bagli_tutar") and not s["gecerlilik"].get("yil"):
            s["gecerlilik"]["yil"] = 2026; degisti = True; rapor.append((s["id"], "yil"))
        if k == "FYN-PIY-0020" and "round(" not in s["dogrulama"]["python"].splitlines()[-1]:
            s["dogrulama"]["python"] = s["dogrulama"]["python"].rstrip() + "\nsonuc = round(sonuc)"; degisti = True
            rapor.append((s["id"], "round"))
        if k in KALIN:
            kok = s["kok"]
            son = re.split(r"(?<=[.!])\s+", "\n".join(x for x in kok.splitlines() if not re.match(r"\s*[IVX]+\.\s", x)).strip())[-1]
            m = g2_yapi.OLUMSUZ.search(son)
            if m and kok.count(son) == 1:
                s["kok"] = kok.replace(son, son[:m.start()] + f"**{m.group(0)}**" + son[m.end():]); degisti = True
                rapor.append((s["id"], "kalın"))
    if degisti:
        yol.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
print(len(rapor)); [print(r) for r in rapor]
