"""Kör çözüm (G3) ve ortalama aday (GZ) yardımcıları.

    python -m pipeline.kor dosya <cikti.md> <desen>        # cevapsız soru dosyası (ör. desen: '.p3.')
    python -m pipeline.kor isle <g3.json> <gz.json>         # G3/GZ sonuçlarını sorulara yazar, durumu günceller

g3.json / gz.json biçimi: {"SMMM-...": {"cevap": "A", "guven": 1-5, "not": "..."}} (kimlikte "SMMM-" öneki olmayabilir).
G3: tek kaynaklı kör çözücü anahtarla aynı şıkkı güven ≥ 4 ile bulursa geçer; aksi hâlde `kaldi` (hakeme gider).
GZ: ortalama aday kaynaksız çözer; etiket 3 iken güven ≥ 4 ile doğru bulursa zorluk 2'ye iner (uretim.md §7).
Tüm kapıları geçen taslak soru `kontrolde` olur.
"""

from __future__ import annotations

import json
import sys
from datetime import date
from pathlib import Path

from pipeline import denetle, g2_yapi

KLASOR = g2_yapi.KOK / "content/sorular/smmm"
GEREKEN = ("G2", "G3", "G4", "G5", "G6", "G7", "GZ")


def _kimlik(k: str) -> str:
    return k if k.startswith("SMMM-") else "SMMM-" + k


def dosya(cikti: Path, desen: str) -> int:
    parca = []
    for yol, s in g2_yapi.dosyalari_yukle(KLASOR, []):
        if desen not in str(yol):
            continue
        sik = "\n".join(f"{h}) {t}" for h, t in s["secenekler"].items())
        parca.append(f"### {s['id']} ({s['ders']})\n{s['kok']}\n{sik}\n")
    cikti.write_text("\n".join(parca), encoding="utf-8")
    return len(parca)


def isle(g3_yolu: Path, gz_yolu: Path) -> None:
    g3 = {_kimlik(k): v for k, v in json.loads(g3_yolu.read_text(encoding="utf-8")).items()}
    gz = {_kimlik(k): v for k, v in json.loads(gz_yolu.read_text(encoding="utf-8")).items()}
    kayitlar = g2_yapi.dosyalari_yukle(KLASOR, [])
    bugun = str(date.today())
    dokunulan = set()
    for yol, s in kayitlar:
        kapilar = s.setdefault("uretim", {}).setdefault("kapilar", {})
        if s["id"] in g3:
            a = g3[s["id"]]
            gecti = a["cevap"] == s["dogru"] and int(a.get("guven", 0)) >= 4
            kapilar["G3"] = {"sonuc": "gecti" if gecti else "kaldi", "tarih": bugun,
                             "not": f"kör çözücü: {a['cevap']} (güven {a.get('guven')}) {a.get('not', '')}".strip()}
            if not gecti:
                print(f"G3 KALDI {s['id']}: anahtar {s['dogru']}, çözücü {a['cevap']} — hakeme gönder")
            dokunulan.add(yol)
        if s["id"] in gz:
            b = gz[s["id"]]
            dogru = b["cevap"] == s["dogru"]
            kapilar["GZ"] = {"sonuc": "gecti", "tarih": bugun,
                             "not": f"ortalama aday {'doğru' if dogru else 'yanlış'} ({b['cevap']}, güven {b.get('guven')})"}
            if s.get("zorluk") == 3 and dogru and int(b.get("guven", 0)) >= 4:
                s["zorluk"] = 2
                s.setdefault("gecmis", []).append({"tarih": bugun, "kim": "GZ", "ne": "Zorluk 3→2",
                                                    "neden": "Ortalama aday kaynaksız ve yüksek güvenle doğru çözdü."})
            if s.get("zorluk") == 1 and not dogru:
                print(f"GZ DİKKAT {s['id']}: kolay soruyu ortalama aday yanlış çözdü ({b['cevap']}) — kökte belirsizlik?")
            dokunulan.add(yol)
        if s.get("durum") == "taslak" and all(kapilar.get(k, {}).get("sonuc") in ("gecti", "atlandi") for k in GEREKEN):
            s["durum"] = "kontrolde"
    denetle._yaz([(y, s) for y, s in kayitlar if y in dokunulan], KLASOR)


def main(argv: list[str]) -> int:
    if len(argv) >= 4 and argv[1] == "dosya":
        print(f"{dosya(Path(argv[2]), argv[3])} soru → {argv[2]}")
        return 0
    if len(argv) >= 4 and argv[1] == "isle":
        isle(Path(argv[2]), Path(argv[3]))
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
