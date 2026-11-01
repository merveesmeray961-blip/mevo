"""Çıkmış soru "kalıpları": resmî sorular + resmî cevap anahtarı + konu eşlemesi.

Öncelik `content/cikmis_yapi/` JSON'larıdır (başka bir ajanın ayrıştırması; alanlar: kok, secenekler, dogru, ders_kod,
yil, okuma_guveni). Yoksa 2026 SMMM test metinleri (`content/kaynaklar/cikmis/smmm/smmm_2026_<donem>_<nn>.txt`, iki
sütunlu pdftotext çıktısı) burada sütunlara ayrılıp soru soru kesilir; doğru şık metnin sonundaki A kitapçığı
anahtarından, konu `docs/denetim/smmm_test_2026_karsilastirma.md` eşlemesinden alınır.

    python -m pipeline.modal.kalip            # kalıpları content/uretim_modal/kaliplar_smmm2026.json'a yazar, özet basar
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

KOK = Path(__file__).resolve().parents[2]
CIKMIS = KOK / "content/kaynaklar/cikmis"
YAPI = KOK / "content/cikmis_yapi"
ESLEME = KOK / "docs/denetim/smmm_test_2026_karsilastirma.md"
DERS_SIRA = {"01": "FIN", "02": "TAB", "03": "MAL", "04": "DEN", "05": "VER", "06": "HUK", "07": "MES", "08": "SPK"}
SECENEK = re.compile(r"(?:(?<=\s)|^)([A-E])\)\s")


def _sutun_ayir(sayfa: str) -> str:
    satirlar = sayfa.splitlines()
    en_iyi, x_iyi = 0, None
    for x in range(50, 100):
        n = 0
        for s in satirlar:
            if len(s) > x + 1 and s[x - 2:x] == "  " and s[x:].strip():
                n += 1
            elif len(s) > x and s[x - 1] != " " and s[x - 2] != " ":
                n -= 2  # sütun sınırı bir sözcüğü bölüyor
        if n > en_iyi:
            en_iyi, x_iyi = n, x
    if x_iyi is None or en_iyi < 5:
        return sayfa
    sol = [s[:x_iyi].rstrip() for s in satirlar]
    sag = [s[x_iyi:].rstrip() for s in satirlar]
    return "\n".join(sol) + "\n" + "\n".join(sag)


def _anahtar(metin: str) -> dict[int, str]:
    i = metin.find("Cevap Anahtar")
    if i < 0:
        return {}
    out = {}
    for m in re.finditer(r"^\s*(\d{1,2})\s+\d{1,2}\s+\d{1,2}\s+\d{1,2}\s+([A-E])\s*$", metin[i:], re.M):
        out[int(m.group(1))] = m.group(2)
    return out


def _esleme() -> dict[tuple[str, int, int], tuple[str, str]]:
    """(ders, dönem, soru) → (konu, açıklama)."""
    out, ders = {}, None
    for satir in ESLEME.read_text(encoding="utf-8").splitlines():
        m = re.match(r"## \d+\. \d\) .*\((\w+)\)", satir)
        if m:
            ders = m.group(1)
        m = re.match(r"- S(\d)\.(\d+): (\w+)(?: \(k\))? — (.*)", satir)
        if m and ders:
            out[(ders, int(m.group(1)), int(m.group(2)))] = (m.group(3), m.group(4).strip())
    return out


def _secenekler(govde: str) -> tuple[str, dict] | None:
    tek = " ".join(govde.split())
    tek = re.sub(r"(?:\b\d{1,3}\s+)?Diğer sayfaya geçiniz\.?", " ", tek, flags=re.I)
    tek = re.sub(r"TÜRMOB(?:-TESMER)? SMMM \d{4}-\d(?: [A-ZÇĞİÖŞÜ.]{2,})+", " ", tek)
    tek = re.sub(r"(?:\b\d{1,3}\s+)?TEST BİTTİ\.?", " ", tek)
    tek = " ".join(tek.split())
    yer = [(m.start(), m.group(1)) for m in SECENEK.finditer(tek)]
    # A..E sırasıyla ilk tam dizi
    for i, (p, h) in enumerate(yer):
        if h != "A":
            continue
        dizi, beklenen = [(p, "A")], "BCDE"
        for p2, h2 in yer[i + 1:]:
            if beklenen and h2 == beklenen[0]:
                dizi.append((p2, h2))
                beklenen = beklenen[1:]
        if len(dizi) == 5:
            kok = tek[:dizi[0][0]].strip()
            sec = {}
            for j, (p3, h3) in enumerate(dizi):
                son = dizi[j + 1][0] if j + 1 < 5 else len(tek)
                sec[h3] = tek[p3 + 3:son].strip()
            return kok, sec
    return None


def smmm2026() -> list[dict]:
    es = _esleme()
    out = []
    for f in sorted(CIKMIS.glob("smmm/smmm_2026_*_*.txt")):
        _, _, donem, nn = f.stem.split("_")
        ders = DERS_SIRA[nn]
        ham = f.read_text(encoding="utf-8", errors="ignore")
        anahtar = _anahtar(ham)
        govde = ham.split("Cevap Anahtar")[0]
        dz = "\n".join(_sutun_ayir(s) for s in govde.split("\f"))
        bas = [(m.start(), int(m.group(1))) for m in re.finditer(r"^\s{0,8}(\d{1,2})\.\s+(?!ve\s|soru)\S", dz, re.M)]
        # yalnız artan ve ardışık numaralar (sayfa no / öncül vb. elensin)
        secili, beklenen = [], 1
        for p, n in bas:
            if n == beklenen:
                secili.append((p, n))
                beklenen += 1
        for i, (p, n) in enumerate(secili):
            son = secili[i + 1][0] if i + 1 < len(secili) else len(dz)
            parca = dz[p:son]
            parca = re.sub(r"^\s*\d{1,2}\.\s+", "", parca, count=1)
            parca = re.sub(r"\n\s*(\d{1,3}|TEST BİTTİ\.|DİĞER SAYFAYA GEÇİNİZ\.?)\s*\n", "\n", parca)
            konu, acik = es.get((ders, int(donem), n), (None, None))
            r = _secenekler(parca)
            k = {"kid": f"S26-{donem}-{ders}-{n:02d}", "sinav": "smmm", "yil": 2026, "donem": int(donem), "ders": ders,
                 "no": n, "konu": konu, "konu_aciklama": acik, "dogru": anahtar.get(n), "ham": "\n".join(
                     x.strip() for x in parca.strip().splitlines() if x.strip())}
            if r:
                k["kok"], k["secenekler"] = r
            guven = 1.0
            if not r:
                guven = 0.2
            elif len(k["kok"]) < 40 or any(len(v) > 400 for v in k["secenekler"].values()):
                guven = 0.5
            if not k["dogru"] or not konu:
                guven = min(guven, 0.3)
            k["okuma_guveni"] = guven
            out.append(k)
    return out


def yapi_kaliplari() -> list[dict]:
    """content/cikmis_yapi JSON'ları (hazırsa)."""
    out = []
    for f in sorted(YAPI.rglob("*.json")):
        try:
            veri = json.loads(f.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            continue
        liste = veri.get("sorular", veri) if isinstance(veri, dict) else veri
        for i, s in enumerate(liste if isinstance(liste, list) else []):
            if not isinstance(s, dict) or not s.get("kok") or not s.get("dogru"):
                continue
            sinav = f.parts[len(YAPI.parts)] if f.parent != YAPI else f.stem.split("_")[0]
            out.append({"kid": f"{f.stem}-{i:03d}", "sinav": str(sinav).split("_")[0], "yil": s.get("yil"),
                        "ders": s.get("ders_kod"), "konu": s.get("konu_kod") or s.get("konu"), "kok": s["kok"],
                        "secenekler": s.get("secenekler") or {}, "dogru": s["dogru"],
                        "okuma_guveni": _guven(s.get("okuma_guveni", 0.5)), "kaynak_dosya": str(f.relative_to(KOK))})
    return out


def _guven(g) -> float:
    """Ayrıştırıcı güveni sayı ya da 'tam'/'kismi' olarak yazabilir."""
    if isinstance(g, (int, float)):
        return float(g)
    return {"tam": 1.0, "yuksek": 0.95, "kismi": 0.6}.get(str(g).strip().lower(), 0.5)


def kalip_metni(k: dict) -> str:
    if k.get("secenekler"):
        return k["kok"] + "\n" + "\n".join(f"{h}) {v}" for h, v in k["secenekler"].items())
    return k.get("ham", k.get("kok", ""))


def main() -> int:
    k = smmm2026()
    yol = KOK / "content/uretim_modal/kaliplar_smmm2026.json"
    yol.write_text(json.dumps(k, ensure_ascii=False, indent=1), encoding="utf-8")
    from collections import Counter
    print(len(k), "kalıp;", Counter(x["okuma_guveni"] for x in k), Counter(x["ders"] for x in k if x["okuma_guveni"] == 1))
    print("cikmis_yapi:", len(yapi_kaliplari()))
    return 0


if __name__ == "__main__":
    sys.exit(main())
