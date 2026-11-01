"""TESMER çıkmış sorularını (content/cikmis_yapi) uygulamanın ücretsiz "Çıkmış sorular" paketine çevirir.

Yalnız güvenle okunmuş, resmî doğru cevabı belli ve metinde düzeni bozulmamış sorular alınır:
okuma_guveni == "tam", dogru dolu, 5 şık (SGS) / 5 şık (SMMM), İPTAL değil; tablo, grafik, formül,
yevmiye kaydı ve özel kodlu font notu taşıyanlar dışarıda bırakılır.

  python pipeline/cikmis_paketle.py
Çıktı: app/assets/cikmis/smmm_cikmis.paket (karartılmış) + app/assets/cikmis/smmm_cikmis.json (inceleme/test için)
"""
from __future__ import annotations

import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(KOK / "pipeline"))
from paket_sifre import sifrele  # noqa: E402

YAPI = KOK / "content/cikmis_yapi"
CIKTI = KOK / "app/assets/cikmis"
DISLA = ("tablo", "grafik", "formül", "yevmiye", "özel kodlu", "şekil", "okunamad")
SAYI = re.compile(r"\d[\d.,]*")
VERI_ATFI = re.compile(r"(aşağıda(ki)?|yukarıda(ki)?|tablo|şöyledir|verilmiştir|verilere göre|bilgilere göre|bilgiler|grafik|şekil)", re.I)
YEVMIYE = re.compile(r"\b\d{3}\s+[A-ZÇĞİÖŞÜ]{3,}")
MADDE = re.compile(r"^(?:[IVX]{1,4}\.|[a-eA-E]\)|[1-9]\)|-|•)\s")


def duzle(metin: str) -> str:
    """PDF satır kırılımlarını birleştirir; I., II., a) gibi madde satırlarını ayrı tutar."""
    # 2015 dönemi PDF'lerinde Türkçe harfler yanlış kod noktalarıyla gömülü (Ģ=ş, ġ=Ş, Ġ=İ).
    metin = metin.translate(str.maketrans({"Ģ": "ş", "ġ": "Ş", "Ġ": "İ", "−": "-"}))
    satirlar = [s.strip() for s in metin.replace("\r", "").split("\n") if s.strip()]
    out: list[str] = []
    for s in satirlar:
        if not out or MADDE.match(s):
            out.append(s)
        elif out[-1].endswith("-") and s[:1].islower():
            out[-1] = out[-1][:-1] + s
        else:
            out[-1] += " " + s
    return "\n".join(out)


def uygun(s: dict) -> bool:
    if s.get("okuma_guveni") != "tam" or not s.get("dogru"):
        return False
    sec = s.get("secenekler") or {}
    if len(sec) < 4 or s["dogru"] not in sec or not all(str(v).strip() for v in sec.values()):
        return False
    if "İPTAL" in str(s.get("dogru")).upper() or s.get("iptal"):
        return False
    notlar = str(s.get("notlar") or "").lower()
    if any(d in notlar for d in DISLA):
        return False
    kok = s["kok"]
    sayilar = len(SAYI.findall(kok))
    # Düzleşmiş tablo (çok sayı) ya da metinde bulunmayan veriye atıf (az sayı + "aşağıdaki bilgiler" vb.)
    if sayilar > 5:
        return False
    # Ortak veriye dayanan soru kümeleri: kök kısa, sayısal sonuç istiyor, şıklar sayı → veri metinde yok.
    sayisal_sik = sum(1 for v in sec.values() if re.fullmatch(r"[\s\d.,%₺()+\-–]+", str(v)))
    if len(kok) < 220 and sayisal_sik >= 4 and sayilar < 2:
        return False
    if VERI_ATFI.search(kok) and sayilar < 2 and re.search(r"(göre|verilen|bilgi|tablo|şöyle)", kok, re.I) and re.search(r"(tutar|kaç|oran|yüzde|hesapla|maliyet|kar|zarar|₺)", kok, re.I):
        return False
    if any(YEVMIYE.search(str(v)) for v in sec.values()):
        return False
    return True


def main() -> None:
    oturumlar: dict[str, dict] = {}
    say = Counter()
    for f in sorted((YAPI / "sgs").glob("*.json")) + [YAPI / "smmm_test.json"]:
        veri = json.loads(f.read_text(encoding="utf-8"))
        for s in veri["sorular"] if isinstance(veri, dict) else veri:
            say["toplam"] += 1
            if not uygun(s):
                continue
            sinav = "SGS" if s.get("tur") == "sgs" else "Yeterlilik"
            kod = f"{sinav.lower()}-{s['yil']}-{s.get('donem') or 0}"
            o = oturumlar.setdefault(kod, {"kod": kod, "sinav": sinav, "yil": s["yil"], "donem": s.get("donem") or 0, "sorular": []})
            o["sorular"].append({
                "id": f"CKM-{s['id']}",
                "ders": s.get("ders_kod") or "",
                "dersAd": s.get("ders_ad") or "",
                "no": s.get("no"),
                "kok": duzle(s["kok"]),
                "secenekler": {k: duzle(str(v)) for k, v in sorted(s["secenekler"].items())},
                "dogru": s["dogru"],
            })
            say[sinav] += 1
    liste = sorted(oturumlar.values(), key=lambda o: (-o["yil"], -o["donem"], o["sinav"]))
    for o in liste:
        o["sorular"].sort(key=lambda q: (q["no"] or 0))
    paket = {"kaynak": "TESMER yayımlanmış sınav soruları", "oturumlar": liste}
    ham = json.dumps(paket, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    CIKTI.mkdir(parents=True, exist_ok=True)
    (CIKTI / "smmm_cikmis.json").write_text(json.dumps(paket, ensure_ascii=False, indent=1), encoding="utf-8")
    (CIKTI / "smmm_cikmis.paket").write_bytes(sifrele(ham))
    print(dict(say), "oturum:", len(liste), "ham", len(ham) // 1024, "KB")
    dersler = defaultdict(Counter)
    for o in liste:
        for q in o["sorular"]:
            dersler[o["sinav"]][q["ders"]] += 1
    print({k: dict(v) for k, v in dersler.items()})


if __name__ == "__main__":
    main()
