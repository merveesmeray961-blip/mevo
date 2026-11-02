"""Yeni soru üretim dağılımını hesaplar (SMMM → 5.000 özgün, YMM → 3.000+ özgün, klasik ağırlıklı).

Yöntem: her konunun "sınav talebi" = sınavdaki ders soru sayısı × konunun ders içi ağırlığı (SGS ve Yeterlilik'ten
büyük olanı; ortak dersler iki sınava da hizmet eder). İdeal konu payı = hedef × talep / toplam talep; her konuya
taban sayı uygulanır. Eksik = ideal − mevcut (negatifse 0); eksikler hedef ek soru sayısına ölçeklenir.
Üretim siparişi = net ihtiyaç × KAYIP (kapı/inceleme kaybı payı), 5'in katına yuvarlanır.

    python3 docs/uretim_talimati/dagilim.py   → docs/uretim_talimati/dagilim_smmm.csv, dagilim_ymm.csv
"""
import csv
import json
import math
from collections import Counter
from pathlib import Path

import yaml

KOK = Path(__file__).resolve().parents[2]
KAYIP = 1.4  # %30 kayıp payı → net ihtiyacın 1,4 katı üretilir


def yuvarla5(x: float) -> int:
    return int(math.ceil(x / 5.0) * 5) if x > 0 else 0


def dagit(ihtiyac: dict, toplam: int, agirlik: dict) -> dict:
    """İhtiyaçları toplam'a ölçekler; artan pay ağırlığa göre dağıtılır. Tam sayı döner."""
    s = sum(ihtiyac.values())
    if s >= toplam:
        ham = {k: v * toplam / s for k, v in ihtiyac.items()}
    else:
        kalan = toplam - s
        w = sum(agirlik.values())
        ham = {k: ihtiyac[k] + kalan * agirlik[k] / w for k in ihtiyac}
    tam = {k: int(v) for k, v in ham.items()}
    for k in sorted(ham, key=lambda k: -(ham[k] - tam[k]))[: toplam - sum(tam.values())]:
        tam[k] += 1
    return tam


def smmm():
    m = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    sorular = json.loads((KOK / "app/assets/sorular/smmm.json").read_text(encoding="utf-8"))["sorular"]
    mevcut = Counter((q["ders"], q["konu"]) for q in sorular)
    hedef, ek = 5000, 5000 - len(sorular)
    talep, bilgi = {}, {}
    for d in m["dersler"]:
        yet_t = sum((k.get("agirlik") or {}).get("yet", 0) for k in d["konular"]) or 1
        sgs_t = sum((k.get("agirlik") or {}).get("sgs", 0) for k in d["konular"]) or 1
        for k in d["konular"]:
            a = k.get("agirlik") or {}
            qy = d["soru"].get("yet", 0) * a.get("yet", 0) / yet_t
            qs = d["soru"].get("sgs", 0) * a.get("sgs", 0) / sgs_t
            anahtar = (d["kod"], k["kod"])
            talep[anahtar] = max(qy, qs)
            bolum = [b for b, q in (("SGS", qs), ("YET", qy)) if q > 0]
            bilgi[anahtar] = (d["ad"], k["ad"], bolum)
    W = sum(talep.values())
    ideal = {k: max(40.0, hedef * t / W) for k, t in talep.items()}
    ihtiyac = {k: max(0.0, ideal[k] - mevcut.get(k, 0)) for k in talep}
    net = dagit(ihtiyac, ek, talep)
    satirlar = []
    for k in talep:
        satirlar.append({
            "ders": k[0], "ders_ad": bilgi[k][0], "konu": k[1], "konu_ad": bilgi[k][1], "bolum": "+".join(bilgi[k][2]),
            "sinav_talebi": round(talep[k], 2), "mevcut": mevcut.get(k, 0), "ideal": round(ideal[k]),
            "net_ihtiyac": net[k], "uretilecek": yuvarla5(net[k] * KAYIP),
        })
    return satirlar, len(sorular), ek


def ymm():
    m = yaml.safe_load((KOK / "content/mufredat/ymm.yaml").read_text(encoding="utf-8"))
    j = json.loads((KOK / "app/assets/sorular/ymm.json").read_text(encoding="utf-8"))
    test = Counter((q["ders"], q["konu"]) for q in j["sorular"])
    klasik = Counter((q["ders"], q["konu"]) for q in j["klasik"])
    TEST_EK, KLASIK_DERS = 300, 90  # test +300; klasik her derste 90'a (toplam 900)
    hedef_test_ders = (len(j["sorular"]) + TEST_EK) / len(m["dersler"])
    t_ihtiyac, k_net, talep, bilgi = {}, {}, {}, {}
    for d in m["dersler"]:
        top = sum(k["agirlik"]["ymm"] for k in d["konular"])
        k_ideal, k_iht = {}, {}
        for k in d["konular"]:
            a = (d["kod"], k["kod"])
            pay = k["agirlik"]["ymm"] / top
            talep[a] = pay
            bilgi[a] = (d["ad"], k["ad"])
            t_ihtiyac[a] = max(0.0, max(25.0, hedef_test_ders * pay) - test.get(a, 0))
            k_ideal[a] = max(4.0, KLASIK_DERS * pay)
            k_iht[a] = max(0.0, k_ideal[a] - klasik.get(a, 0))
        ders_ek = KLASIK_DERS - sum(klasik.get((d["kod"], k["kod"]), 0) for k in d["konular"])
        k_net.update(dagit(k_iht, max(0, ders_ek), {a: talep[a] for a in k_iht}))
    t_net = dagit(t_ihtiyac, TEST_EK, talep)
    satirlar = []
    for a in talep:
        satirlar.append({
            "ders": a[0], "ders_ad": bilgi[a][0], "konu": a[1], "konu_ad": bilgi[a][1],
            "agirlik_pay": round(talep[a], 3),
            "test_mevcut": test.get(a, 0), "test_net": t_net[a], "test_uretilecek": int(math.ceil(t_net[a] * KAYIP)),
            "klasik_mevcut": klasik.get(a, 0), "klasik_net": k_net[a], "klasik_uretilecek": int(math.ceil(k_net[a] * KAYIP)),
        })
    return satirlar, len(j["sorular"]), len(j["klasik"])


if __name__ == "__main__":
    out = KOK / "docs/uretim_talimati"
    s, n, ek = smmm()
    with open(out / "dagilim_smmm.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(s[0])); w.writeheader(); w.writerows(s)
    print("SMMM mevcut", n, "ek net", sum(r["net_ihtiyac"] for r in s), "üretilecek", sum(r["uretilecek"] for r in s))
    y, nt, nk = ymm()
    with open(out / "dagilim_ymm.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(y[0])); w.writeheader(); w.writerows(y)
    print("YMM test", nt, "+", sum(r["test_net"] for r in y), "üret", sum(r["test_uretilecek"] for r in y),
          "| klasik", nk, "+", sum(r["klasik_net"] for r in y), "üret", sum(r["klasik_uretilecek"] for r in y))
