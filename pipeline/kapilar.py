"""Model tabanlı kapılar (G3, G5, G6) için yardımcılar.

kor     : Bir klasördeki soruların yalnızca kök ve şıklarını (cevap, açıklama, kaynak OLMADAN) JSON olarak yazar.
          Bağımsız çözücüler (G3) yalnızca bu dosyayı görür.
isle    : Kontrolcülerin karar dosyasını (JSON) okuyup sorulara `uretim.kapilar` olarak işler.
          G3 için iki çözücünün sonuçları birleştirilir: ikisi de anahtarla aynı şıkkı ≥4 güvenle bulmalı.
durum   : Tüm kapılardan (G2, G3, G4, G5, G6, G7) geçen taslak soruları `kontrolde` durumuna alır.

Kullanım:
    python -m pipeline.kapilar kor content/sorular/smmm/HUK  > /tmp/kor_HUK.json
    python -m pipeline.kapilar isle G3 karar.json            # [{id, cevap, guven, gerekce, cozucu}]
    python -m pipeline.kapilar isle G5 karar.json            # [{id, sonuc, itirazlar, onerilen_duzeltme}]
    python -m pipeline.kapilar isle G6 karar.json            # [{id, sonuc, desteksiz_iddialar}]
    python -m pipeline.kapilar durum content/sorular/smmm
"""

from __future__ import annotations

import json
import sys
from datetime import date
from pathlib import Path

from pipeline import denetle, g2_yapi

GECME_GUVENI = 4
GEREKEN_KAPILAR = ("G2", "G3", "G4", "G5", "G6", "G7")


def kor(klasor: Path) -> list[dict]:
    return [{"id": s["id"], "ders": s.get("ders"), "kok": s["kok"], "secenekler": s["secenekler"]}
            for _, s in g2_yapi.dosyalari_yukle(klasor)]


def _tum_kayitlar() -> list[tuple[str, dict]]:
    return g2_yapi.dosyalari_yukle(g2_yapi.KOK / "content/sorular/smmm")


def isle(kapi: str, kararlar: list[dict]) -> dict[str, str]:
    kayitlar = _tum_kayitlar()
    sorular = {s["id"]: s for _, s in kayitlar}
    bugun = str(date.today())
    sonuc: dict[str, str] = {}

    if kapi == "G3":
        gruplu: dict[str, list[dict]] = {}
        for k in kararlar:
            gruplu.setdefault(k["id"], []).append(k)
        for sid, liste in gruplu.items():
            soru = sorular.get(sid)
            if soru is None:
                continue
            uygun = [k for k in liste if k.get("cevap") == soru["dogru"] and int(k.get("guven", 0)) >= GECME_GUVENI]
            gecti = len(liste) >= 2 and len(uygun) == len(liste)
            ozet = "; ".join(f"{k.get('cozucu', '?')}: {k.get('cevap')} (güven {k.get('guven')})" for k in liste)
            if not gecti:
                ozet += " | " + " / ".join(k.get("gerekce", "")[:300] for k in liste if k not in uygun)
            soru.setdefault("uretim", {}).setdefault("kapilar", {})["G3"] = {
                "sonuc": "gecti" if gecti else "kaldi", "not": ozet, "tarih": bugun}
            sonuc[sid] = "gecti" if gecti else "kaldi"
    else:
        for k in kararlar:
            soru = sorular.get(k["id"])
            if soru is None:
                continue
            notlar = k.get("itirazlar") or k.get("desteksiz_iddialar") or []
            if k.get("onerilen_duzeltme"):
                notlar = [*notlar, "Öneri: " + k["onerilen_duzeltme"]]
            kayit = {"sonuc": k["sonuc"], "tarih": bugun}
            if notlar:
                kayit["not"] = " | ".join(notlar)
            soru.setdefault("uretim", {}).setdefault("kapilar", {})[kapi] = kayit
            sonuc[k["id"]] = k["sonuc"]

    denetle._yaz(kayitlar, g2_yapi.KOK / "content/sorular/smmm")
    return sonuc


def durum_guncelle(klasor: Path) -> tuple[int, int]:
    kayitlar = g2_yapi.dosyalari_yukle(klasor)
    terfi = 0
    for _, soru in kayitlar:
        kapilar = soru.get("uretim", {}).get("kapilar", {})
        tamam = all(kapilar.get(k, {}).get("sonuc") in ("gecti", "atlandi") for k in GEREKEN_KAPILAR)
        if soru.get("durum") == "taslak" and tamam:
            soru["durum"] = "kontrolde"
            terfi += 1
    denetle._yaz(kayitlar, klasor)
    return terfi, len(kayitlar)


def main(argv: list[str]) -> int:
    komut = argv[1] if len(argv) > 1 else ""
    if komut == "kor":
        print(json.dumps(kor(Path(argv[2])), ensure_ascii=False, indent=1))
    elif komut == "isle":
        kararlar = json.loads(Path(argv[3]).read_text(encoding="utf-8"))
        sonuc = isle(argv[2], kararlar)
        gecen = sum(v == "gecti" for v in sonuc.values())
        print(f"{argv[2]}: {gecen}/{len(sonuc)} geçti")
        for sid, v in sorted(sonuc.items()):
            if v != "gecti":
                print(f"  KALDI {sid}")
    elif komut == "durum":
        terfi, toplam = durum_guncelle(Path(argv[2]))
        print(f"{terfi} soru 'kontrolde' durumuna alındı (toplam {toplam})")
    else:
        print(__doc__)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
