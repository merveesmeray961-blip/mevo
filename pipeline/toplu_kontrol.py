"""Harici teslimlerin toplu otomatik kontrolü (G2 şema, G6 alıntı, G4 hesap kodu, G7 benzerlik, şablon tekrarı, şık sezgileri).

    python -m pipeline.toplu_kontrol smmm      → content/teslim/smmm/_kontrol/otomatik.json + OZET.txt
"""
from __future__ import annotations

import difflib
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator

from pipeline import harita
from pipeline.uretici_paketi import alinti_sorunlari

KOK = Path(__file__).resolve().parents[1]


def norm(s: str) -> str:
    return re.sub(r"\s+", " ", str(s)).strip().lower().replace("’", "'")


KALIP = re.compile(r"^\d+ sayılı [^,]*?(kanunu|yönetmeli[gğ]i|tebli[gğ]i)'?n?[ıiuü]?'?[nñ]?a göre,? ?|aşağıdakilerden hangisi(dir)?|\*\*")


def ozgun(kok: str) -> str:
    return KALIP.sub("", norm(kok))


def imza(kok: str) -> str:
    """Şablon tespiti: sayıları, tek harfli/kısa büyük adları ve tutarları sil."""
    s = norm(kok)
    s = re.sub(r"\d[\d.,%]*", "#", s)
    s = re.sub(r"\b[a-zçğıöşü]\b", "_", s)
    s = re.sub(r"\(\w{1,3}\)", "_", s)
    return s


def ngram(s: str, k: int = 4) -> set:
    w = re.findall(r"\w+", s)
    return {tuple(w[i:i + k]) for i in range(len(w) - k + 1)}


def g4(kod: str, dogru_sik: str) -> str | None:
    ortam: dict = {}
    try:
        exec(kod, {"__builtins__": {"round": round, "abs": abs, "min": min, "max": max, "sum": sum, "range": range,
                                    "int": int, "float": float, "len": len, "pow": pow}}, ortam)
    except Exception as e:  # noqa: BLE001
        return f"kod hata: {e}"
    if "sonuc" not in ortam:
        return "sonuc yok"
    sonuc = ortam["sonuc"]
    sayilar = [float(x.replace(".", "").replace(",", ".")) for x in re.findall(r"-?\d[\d.]*(?:,\d+)?", dogru_sik)]
    if isinstance(sonuc, (int, float)):
        if not any(abs(float(sonuc) - x) <= max(0.011, abs(x) * 1e-6) for x in sayilar):
            return f"sonuç {sonuc} doğru şıkta yok ({dogru_sik[:60]})"
    return None


def main(sinav: str) -> None:
    harita.sinav_sec(sinav)
    sema = Draft202012Validator(json.loads((KOK / "content/schema/soru.schema.json").read_text(encoding="utf-8")))
    klasor = KOK / f"content/teslim/{sinav}"
    cikti = klasor / "_kontrol"
    cikti.mkdir(exist_ok=True)
    banka = json.loads((KOK / f"app/assets/sorular/{sinav}.json").read_text(encoding="utf-8"))["sorular"]
    banka_g = [(q["id"], ngram(ozgun(q["kok"]))) for q in banka]
    cikmis = []
    for f in list((KOK / "content/cikmis_yapi/sgs").glob("*.json")) + [KOK / "content/cikmis_yapi/smmm_test.json"]:
        for q in json.loads(f.read_text(encoding="utf-8"))["sorular"]:
            cikmis.append((q["id"], ngram(ozgun(q["kok"])), {norm(v) for v in (q.get("secenekler") or {}).values()}))
    kayitlar = []
    for f in sorted(klasor.glob("*.yaml")):
        if f.name.startswith("_") or f.name == "SHK_TCR_20261102_1.yaml":
            continue
        veri = yaml.safe_load(f.read_text(encoding="utf-8"))
        liste = veri.get("sorular", veri) if isinstance(veri, dict) else veri
        for i, s in enumerate(liste, 1):
            kayitlar.append((f.name, i, s))
    imzalar = defaultdict(list)
    for f, i, s in kayitlar:
        imzalar[(s.get("ders"), s.get("konu"), imza(s.get("kok", "")))].append(f"{f}#{i}")
    sonuc = []
    ozet = Counter()
    for f, i, s in kayitlar:
        hata, uyari = [], []
        s2 = dict(s, id=f"{sinav.upper()}-{s.get('ders', 'XXX')}-{s.get('konu', 'X')}-0001")
        hata += [f"şema: {e.message[:90]}" for e in sema.iter_errors(s2)]
        if not hata:
            if a := alinti_sorunlari(s.get("kaynaklar")):
                hata.append("alıntı: " + " | ".join(a)[:200])
            cel = (s.get("aciklama") or {}).get("celdiriciler") or {}
            eksik = [h for h in "ABCDE" if h != s["dogru"] and h not in cel]
            if eksik:
                hata.append(f"çeldirici açıklaması eksik: {eksik}")
            if s.get("dogrulama", {}).get("python"):
                if e := g4(s["dogrulama"]["python"], s["secenekler"][s["dogru"]]):
                    hata.append("G4: " + e)
            ok = ozgun(s["kok"])
            g = ngram(ok)
            if g:
                bj = max(((len(g & b) / len(g | b)), bid) for bid, b in banka_g if b) if banka_g else (0, "")
                cj = max(((len(g & c[1]) / len(g | c[1])), c[0]) for c in cikmis if c[1])
                sik = {norm(v) for v in s["secenekler"].values()}
                ortak = max((len(sik & c[2]), c[0]) for c in cikmis)
                if bj[0] >= 0.5:
                    hata.append(f"G7 banka benzerliği {bj[0]:.2f} ({bj[1]})")
                elif bj[0] >= 0.35:
                    uyari.append(f"banka benzerliği {bj[0]:.2f} ({bj[1]})")
                if cj[0] >= 0.45 or (cj[0] >= 0.25 and ortak[0] >= 3):
                    hata.append(f"G7 çıkmış benzerliği {cj[0]:.2f} / ortak şık {ortak[0]} ({cj[1]})")
            sik_len = [len(v) for v in s["secenekler"].values()]
            dl = len(s["secenekler"][s["dogru"]])
            if dl == max(sik_len) and sik_len.count(dl) == 1 and dl > 1.6 * sorted(sik_len)[-2]:
                uyari.append("doğru şık belirgin biçimde en uzun")
            if re.search(r"(değildir|yanlıştır|söylenemez|olamaz)\??\s*$", s["kok"]) and "**" not in s["kok"]:
                uyari.append("olumsuz kök kalın değil")
            ayni = imzalar[(s.get("ders"), s.get("konu"), imza(s["kok"]))]
            if len(ayni) > 1:
                uyari.append(f"şablon tekrarı ×{len(ayni)}")
        durum = "HATA" if hata else ("UYARI" if uyari else "TEMİZ")
        ozet[durum] += 1
        ozet[f"{s.get('ders')}:{durum}"] += 1
        sonuc.append({"dosya": f, "no": i, "ders": s.get("ders"), "konu": s.get("konu"), "durum": durum,
                      "hata": hata, "uyari": uyari})
    (cikti / "otomatik.json").write_text(json.dumps(sonuc, ensure_ascii=False, indent=1), encoding="utf-8")
    sablon = Counter()
    for (d, k, _), v in imzalar.items():
        if len(v) > 1:
            sablon[f"{d}/{k}"] += len(v)
    satirlar = [f"toplam {len(sonuc)}", json.dumps({k: v for k, v in ozet.items() if ':' not in k}, ensure_ascii=False)]
    for d in sorted({r['ders'] for r in sonuc}):
        satirlar.append(f"{d}: " + ", ".join(f"{x}={ozet[f'{d}:{x}']}" for x in ("TEMİZ", "UYARI", "HATA")))
    satirlar.append("şablon tekrarı (konu: soru sayısı): " + json.dumps(dict(sablon.most_common()), ensure_ascii=False))
    hc = Counter(h.split(":")[0] for r in sonuc for h in r["hata"])
    uc = Counter(u.split(" ")[0] + " " + u.split(" ")[1] for r in sonuc for u in r["uyari"])
    satirlar.append("hata türleri: " + json.dumps(dict(hc), ensure_ascii=False))
    satirlar.append("uyarı türleri: " + json.dumps(dict(uc), ensure_ascii=False))
    (cikti / "OZET.txt").write_text("\n".join(satirlar), encoding="utf-8")
    print("\n".join(satirlar))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "smmm")
