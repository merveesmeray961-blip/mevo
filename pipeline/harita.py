"""Üretim haritası: 2000 soruluk hedefin ders → konu → kazanım kotaları ve sıradaki üretim listesi.

    python -m pipeline.harita durum                    # ders/konu bazında hedef, mevcut, eksik
    python -m pipeline.harita sonraki 40 [--ders HUK]  # sıradaki 40 soru için konu/kazanım/zorluk listesi (üretim ajanına verilir)

Kotalar müfredattaki konu ağırlıklarından (Yeterlilik ağırlığı, yoksa SGS) en büyük kalan yöntemiyle dağıtılır;
konu kotası kazanımlara eşit bölünür. Öncelik: (1) her Yeterlilik dersi en az 20 soru (tam deneme),
(2) doluluk oranı en düşük ders, (3) o derste doluluk oranı en düşük konu ve kazanım.
Zorluk hedefi Yeterlilik için %20/45/35 (kolay/orta/zor); konunun mevcut dağılımındaki açığa göre seçilir.
Mükerrer kontrolü üretimden sonra G7 (pipeline.denetle) ile bankanın tamamına karşı yapılır.
"""

from __future__ import annotations

import sys
from collections import Counter, defaultdict

import yaml

from pipeline import g2_yapi

KOK = g2_yapi.KOK
# Hedef 4000 (8 Ekim 2026 kararı). Eski PLAN.md §8 notu: Finansal Muhasebe 340 = FIN 280 + Muhasebe Standartları 60, Ekonomi+Maliye 140 = 70 + 70.
HEDEF = {"FIN": 380, "TAB": 380, "MAL": 380, "DEN": 380, "VER": 380, "HUK": 380, "SPK": 380, "MES": 380,
         "STD": 140, "EKO": 110, "MLY": 110, "GKY": 600}  # 4000: Yeterlilik dersleri eşit, SGS'ye özgü dersler 960
HESAPLI = {"FIN", "TAB", "MAL", "VER", "GKY"}
BICIMLER = ("olay/senaryo", "öncüllü (I, II, III)", "olumsuz kök (**yanlıştır**)", "kavram ayrımı / karşılaştırma",
            "hesaplama / sayısal", "eşleştirme veya sıralama")
YET_ASGARI = 20
ZORLUK_ORANI = (0.20, 0.45, 0.35)


def _dagit(toplam: int, agirliklar: dict[str, float]) -> dict[str, int]:
    """En büyük kalan yöntemi; ağırlığı 0 olanlar en az 1 alır (toplam yetiyorsa)."""
    if not agirliklar:
        return {}
    w = {k: (v if v > 0 else 1.0) for k, v in agirliklar.items()}
    s = sum(w.values())
    ham = {k: toplam * v / s for k, v in w.items()}
    sonuc = {k: int(x) for k, x in ham.items()}
    for k in sorted(ham, key=lambda k: ham[k] - sonuc[k], reverse=True)[: toplam - sum(sonuc.values())]:
        sonuc[k] += 1
    return sonuc


def harita() -> tuple[dict, dict]:
    m = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    kota: dict = {}
    for d in m["dersler"]:
        if d["kod"] not in HEDEF:
            continue
        agirlik = {k["kod"]: float(k.get("agirlik", {}).get("yet") or k.get("agirlik", {}).get("sgs") or 0)
                   for k in d["konular"]}
        konu_kota = _dagit(HEDEF[d["kod"]], agirlik)
        kota[d["kod"]] = {
            "ad": d["ad"],
            "yet": d["soru"].get("yet", 0) > 0,
            "sgs": d["soru"].get("sgs", 0) > 0,
            "konular": {
                k["kod"]: {
                    "ad": k["ad"],
                    "kota": konu_kota[k["kod"]],
                    "kazanimlar": _dagit(konu_kota[k["kod"]], {str(z): 1.0 for z in k.get("kazanimlar") or [k["ad"]]}),
                }
                for k in d["konular"]
            },
        }
    mevcut: dict = defaultdict(lambda: {"toplam": 0, "zorluk": Counter(), "kazanim": Counter()})
    yet_ders: Counter = Counter()
    for _, s in g2_yapi.dosyalari_yukle(KOK / "content/sorular/smmm", []):
        if s.get("durum") == "geri_cekildi":
            continue
        k = mevcut[(s["ders"], s["konu"])]
        k["toplam"] += 1
        k["zorluk"][s.get("zorluk", 2)] += 1
        k["kazanim"][str(s.get("kazanim", "")).strip().lower()] += 1
        if "YET" in s.get("bolum", []):
            yet_ders[s["ders"]] += 1
    return kota, {"konu": mevcut, "yet_ders": yet_ders}


def _ders_mevcut(kota, mev, d):
    return sum(mev["konu"][(d, k)]["toplam"] for k in kota[d]["konular"])


def durum() -> str:
    kota, mev = harita()
    satir = ["| Ders | Hedef | Mevcut | Eksik | Yeterlilik |", "|---|---|---|---|---|"]
    th = tm = 0
    for d, v in kota.items():
        h, n = HEDEF[d], _ders_mevcut(kota, mev, d)
        th, tm = th + h, tm + n
        satir.append(f"| {d} {v['ad']} | {h} | {n} | {max(0, h - n)} | {mev['yet_ders'][d] if v['yet'] else '–'} |")
    satir.append(f"| **Toplam** | **{th}** | **{tm}** | **{max(0, th - tm)}** | |")
    return "\n".join(satir)


def _zorluk_sec(z: Counter, eklenen: Counter) -> int:
    toplam = sum(z.values()) + sum(eklenen.values()) + 1
    acik = {i + 1: ZORLUK_ORANI[i] * toplam - z[i + 1] - eklenen[i + 1] for i in range(3)}
    return max(acik, key=lambda i: acik[i])


def sonraki(n: int, ders: str | None = None) -> list[dict]:
    kota, mev = harita()
    plan: list[dict] = []
    eklenen_ders: Counter = Counter()
    eklenen_konu: Counter = Counter()
    eklenen_kaz: Counter = Counter()
    eklenen_zor: dict = defaultdict(Counter)
    for _ in range(n):
        adaylar = [d for d in kota if (ders is None or d == ders)]

        def ders_onceligi(d):
            n_d = _ders_mevcut(kota, mev, d) + eklenen_ders[d]
            yet_eksik = kota[d]["yet"] and mev["yet_ders"][d] + eklenen_ders[d] < YET_ASGARI
            return (0 if yet_eksik else 1, n_d / HEDEF[d])

        adaylar = [d for d in adaylar if _ders_mevcut(kota, mev, d) + eklenen_ders[d] < HEDEF[d]]
        if not adaylar:
            break
        d = min(adaylar, key=ders_onceligi)
        konular = kota[d]["konular"]
        k = min((k for k in konular if konular[k]["kota"] > 0),
                key=lambda k: (mev["konu"][(d, k)]["toplam"] + eklenen_konu[(d, k)]) / konular[k]["kota"])
        kazanimlar = konular[k]["kazanimlar"]
        kaz = min(kazanimlar, key=lambda z: (mev["konu"][(d, k)]["kazanim"][z.lower()] + eklenen_kaz[(d, k, z)])
                  / max(1, kazanimlar[z]))
        zor = _zorluk_sec(mev["konu"][(d, k)]["zorluk"], eklenen_zor[(d, k)])
        sira = mev["konu"][(d, k)]["kazanim"][kaz.lower()] + eklenen_kaz[(d, k, kaz)]
        bicimler = [b for b in BICIMLER if d in HESAPLI or not b.startswith("hesaplama")]
        plan.append({"ders": d, "konu": k, "konu_ad": konular[k]["ad"], "kazanim": kaz, "zorluk": zor,
                     "bicim": bicimler[(sira + len(plan)) % len(bicimler)],
                     "bolum": (["YET", "SGS"] if kota[d]["sgs"] else ["YET"]) if kota[d]["yet"] else ["SGS"]})
        eklenen_ders[d] += 1
        eklenen_konu[(d, k)] += 1
        eklenen_kaz[(d, k, kaz)] += 1
        eklenen_zor[(d, k)][zor] += 1
    return plan


def main(argv: list[str]) -> int:
    if len(argv) >= 2 and argv[1] == "durum":
        print(durum())
        return 0
    if len(argv) >= 3 and argv[1] == "sonraki":
        ders = argv[argv.index("--ders") + 1] if "--ders" in argv else None
        print("| # | Ders | Konu | Kazanım | Zorluk | Bölüm |\n|---|---|---|---|---|---|")
        for i, p in enumerate(sonraki(int(argv[2]), ders), 1):
            print(f"| {i} | {p['ders']} | {p['konu']} {p['konu_ad']} | {p['kazanim']} | {p['zorluk']} | {','.join(p['bolum'])} |")
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
