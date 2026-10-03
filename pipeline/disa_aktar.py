"""Soru bankasını önizleme uygulamasının okuduğu tek bir JSON dosyasına aktarır.

Yalnızca G2 ve G4'ten geçen ve `durum` değeri taslak/geri_cekildi olmayan sorular aktarılır.
Müfredattan ders ve konu adları, sınav ayarlarından format bilgisi eklenir.

Kullanım:
    python -m pipeline.disa_aktar web/onizleme/sorular.json                 (uzman önizlemesi, açıklama olduğu gibi)
    python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama  (mobil uygulama paketi)
"""

from __future__ import annotations

import json
import re
import sys
from datetime import date
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap

KOK = g2_yapi.KOK
AKTARILAN_DURUMLAR = {"kontrolde", "onayli", "yayinda"}

# Zor sorularda dogru_neden'in sonuna eklenen teknik/tuzak notu uygulamada ayrı bir "püf noktaları" bölümünde gösterilir.
PUF_ETIKETI = re.compile(r"\s*(?:Kullanılan teknikler|Zorluk \(\d\) kaynakları|Püf noktaları)\s*:\s*")


def aciklama_ayir(aciklama: dict) -> dict:
    parca = PUF_ETIKETI.split(aciklama["dogru_neden"], maxsplit=1)
    if len(parca) == 1:
        return aciklama
    return {**aciklama, "dogru_neden": parca[0].strip(), "puf_noktalari": parca[1].strip()}


def aktar(hedef: Path, durumlar: set[str] = AKTARILAN_DURUMLAR, puf_ayir: bool = False) -> dict:
    mufredat = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    sinav = yaml.safe_load((KOK / "content/sinavlar/smmm.yaml").read_text(encoding="utf-8"))
    kayitlar = g2_yapi.dosyalari_yukle(KOK / "content/sorular/smmm")

    dersler = {
        d["kod"]: {
            "ad": d["ad"],
            "sgs_ad": d.get("sgs_ad", d["ad"]),
            "soru": d["soru"],
            "notlar": d.get("notlar", []),
            "konular": {k["kod"]: k["ad"] for k in d["konular"]},
        }
        for d in mufredat["dersler"]
    }

    sorular, elenen = [], []
    for _, soru in kayitlar:
        if soru.get("durum") not in durumlar:
            continue
        hatalar = g2_yapi.soru_denetle(soru).hatalar + g4_hesap.soru_denetle(soru).hatalar
        if hatalar:
            elenen.append({"id": soru.get("id"), "hatalar": hatalar})
            continue
        sorular.append({
            "id": soru["id"],
            "surum": soru["surum"],
            "bolum": soru["bolum"],
            "ders": soru["ders"],
            "konu": soru["konu"],
            "kazanim": soru["kazanim"],
            "tip": soru["tip"],
            "zorluk": soru["zorluk"],
            "kok": soru["kok"],
            "secenekler": soru["secenekler"],
            "dogru": soru["dogru"],
            "aciklama": aciklama_ayir(soru["aciklama"]) if puf_ayir else soru["aciklama"],
            "kaynaklar": soru["kaynaklar"],
            "kapilar": {k: v.get("sonuc") for k, v in soru.get("uretim", {}).get("kapilar", {}).items()},
        })

    paket = {
        "olusturma": str(date.today()),
        "uyari": sinav["resmi_baglanti_yok_ibaresi"],
        "formatlar": {b["kod"]: b for b in sinav["bolumler"]},
        "takvim": {yil.removeprefix("takvim_"): t for yil, t in sinav.items() if yil.startswith("takvim_") and t},
        "dersler": dersler,
        "sorular": sorular,
    }
    hedef.parent.mkdir(parents=True, exist_ok=True)
    hedef.write_text(json.dumps(paket, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    return {"aktarilan": len(sorular), "elenen": elenen}


def main(argv: list[str]) -> int:
    puf_ayir = "--uygulama" in argv
    yollar = [a for a in argv[1:] if not a.startswith("--")]
    hedef = Path(yollar[0]) if yollar else KOK / "web/onizleme/sorular.json"
    sonuc = aktar(hedef, puf_ayir=puf_ayir)
    print(f"{sonuc['aktarilan']} soru aktarıldı → {hedef}")
    for e in sonuc["elenen"]:
        print(f"  ELENDİ {e['id']}: {'; '.join(e['hatalar'])}")
    return 1 if sonuc["elenen"] else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
