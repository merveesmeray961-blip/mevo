"""Otomatik kapıları (G2 yapı, G4 hesap, G7 özgünlük) soru bankası üzerinde çalıştırır.

Model tabanlı kapılar (G3 bağımsız çözüm, G5 düşman denetimi, G6 kaynak uyumu) ayrı ajanlarla yürütülür ve
sonuçları her sorunun `uretim.kapilar` alanına yazılır; bu betik onların varlığını da raporlar.

Kullanım:
    python -m pipeline.denetle content/sorular/smmm [--kulliyat KLASOR] [--isle]

--kulliyat : çıkmış soru metinlerinin bulunduğu yerel klasör (depoda tutulmaz). Verilmezse
             MEVO_KULLIYAT ortam değişkeni kullanılır; o da yoksa G7 yalnız banka içi benzerliğe bakar.
--isle     : G2/G4/G7 sonuçlarını her sorunun `uretim.kapilar` alanına yazar.
"""

from __future__ import annotations

import argparse
import os
import sys
from datetime import date
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap, g7_ozgunluk

MODEL_KAPILARI = ("G3", "G5", "G6")


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("klasor", type=Path)
    ap.add_argument("--kulliyat", type=Path, default=os.environ.get("MEVO_KULLIYAT"))
    ap.add_argument("--isle", action="store_true")
    args = ap.parse_args(argv[1:])

    kayitlar = g2_yapi.dosyalari_yukle(args.klasor)
    sorular = [s for _, s in kayitlar]
    g2 = g2_yapi.banka_denetle(kayitlar)
    g2_hatalari = {s.soru_id: s.hatalar for s in g2.sonuclar}
    g2_uyarilari = {s.soru_id: s.uyarilar for s in g2.sonuclar}
    g4 = {str(s.get("id")): g4_hesap.soru_denetle(s).hatalar for s in sorular}
    kulliyat = g7_ozgunluk.Kulliyat.klasorden(args.kulliyat) if args.kulliyat else None
    g7 = g7_ozgunluk.banka_denetle(sorular, kulliyat)

    toplam_hata = 0
    for soru in sorular:
        sid = str(soru.get("id"))
        sonuclar = {"G2": g2_hatalari.get(sid, []), "G4": g4.get(sid, []), "G7": g7.get(sid, [])}
        kapilar = soru.get("uretim", {}).get("kapilar", {})
        eksik_model = [k for k in MODEL_KAPILARI if kapilar.get(k, {}).get("sonuc") != "gecti"]
        hatalar = [f"{k}: {h}" for k, liste in sonuclar.items() for h in liste]
        toplam_hata += bool(hatalar)
        if hatalar or g2_uyarilari.get(sid) or eksik_model:
            print(f"\n{sid} [{soru.get('ders')}/{soru.get('konu')}]")
            for h in hatalar:
                print(f"  HATA   {h}")
            for u in g2_uyarilari.get(sid, []):
                print(f"  UYARI  G2: {u}")
            if eksik_model:
                print(f"  BEKLİYOR  model kapıları: {', '.join(eksik_model)}")
        if args.isle:
            yeni = soru.setdefault("uretim", {}).setdefault("kapilar", {})
            for k, liste in sonuclar.items():
                if k == "G4" and soru.get("tip") != "hesaplama":
                    yeni[k] = {"sonuc": "atlandi", "not": "hesaplama sorusu değil"}
                elif k == "G7" and kulliyat is None:
                    yeni[k] = {"sonuc": "gecti" if not liste else "kaldi", "not": "yalnız banka içi; külliyat verilmedi",
                               "tarih": str(date.today())}
                else:
                    yeni[k] = {"sonuc": "kaldi" if liste else "gecti", "tarih": str(date.today()),
                               **({"not": "; ".join(liste)} if liste else {})}

    if args.isle:
        _yaz(kayitlar, args.klasor)
    for h in g2.banka_hatalari:
        print(f"BANKA HATA   {h}")
    for u in g2.banka_uyarilari:
        print(f"BANKA UYARI  {u}")
    print(f"\nOtomatik kapılar: {len(sorular) - toplam_hata}/{len(sorular)} soru geçti"
          f"{'' if kulliyat else ' (G7 külliyatsız)'}")
    return 1 if toplam_hata or g2.banka_hatalari else 0


def _yaz(kayitlar: list[tuple[str, dict]], klasor: Path) -> None:
    dosyalar: dict[str, list[dict]] = {}
    for dosya, soru in kayitlar:
        dosyalar.setdefault(dosya, []).append(soru)
    for dosya, liste in dosyalar.items():
        yol = Path(dosya) if Path(dosya).is_absolute() else g2_yapi.KOK / dosya
        icerik = liste if len(liste) > 1 or yol.read_text(encoding="utf-8").lstrip().startswith("-") else liste[0]
        yol.write_text(yaml.safe_dump(icerik, allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")


if __name__ == "__main__":
    sys.exit(main(sys.argv))
