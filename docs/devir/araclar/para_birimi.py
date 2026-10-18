"""SMMM bankasında tutarları resmî sınav biçimine (100.000 ₺) çevirir.

    python docs/devir/araclar/para_birimi.py [--uygula]

Yalnız sayı/bin/milyon ile birlikte geçen "TL" ve "(TL)" başlıkları değişir; ek ünlüsü
"lira" okunuşuna göre kalınlaştırılır (TL'dir → ₺'dır). Kaynak alıntıları, doğrulama kodu
ve geçmiş kayıtları olduğu gibi kalır. --uygula verilmezse yalnız sayım yapılır.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml

KOK = Path(__file__).resolve().parents[3]
ATLA = {"kaynaklar", "dogrulama", "gecmis", "uretim", "gecerlilik"}
KALIN = str.maketrans("eiöü", "aıou")
TUTAR = re.compile(r"(\d(?:[\d.,]*\d)?|\bbin|\bmilyon|\bmilyar)\s?(?:TL\b|₺)(?:(['’]{1,2})([a-zçğıöşü]+))?")
BASLIK = re.compile(r"\((?:bin |milyon )?TL\)")


def _ek(m: re.Match) -> str:
    sayi, kesme, ek = m.group(1), m.group(2), m.group(3)
    return f"{sayi} ₺" + (f"'{ek.translate(KALIN)}" if ek else "")


def cevir(metin: str) -> str:
    metin = TUTAR.sub(_ek, metin)
    return BASLIK.sub(lambda m: m.group(0).replace("TL", "₺"), metin)


def _gez(deger, sayac: list[int]):
    if isinstance(deger, str):
        yeni = cevir(deger)
        sayac[0] += yeni != deger
        return yeni
    if isinstance(deger, list):
        return [_gez(x, sayac) for x in deger]
    if isinstance(deger, dict):
        return {k: (v if k in ATLA else _gez(v, sayac)) for k, v in deger.items()}
    return deger


def main(argv: list[str]) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    toplam = dosya = 0
    for yol in sorted((KOK / "content/sorular/smmm").glob("*/*.yaml")):
        veri = yaml.safe_load(yol.read_text(encoding="utf-8"))
        sayac = [0]
        yeni = _gez(veri, sayac)
        if sayac[0]:
            toplam += sayac[0]
            dosya += 1
            if "--uygula" in argv:
                yol.write_text(yaml.safe_dump(yeni, allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")
    print(f"değişen alan: {toplam}, dosya: {dosya}{'' if '--uygula' in argv else ' (deneme)'}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
