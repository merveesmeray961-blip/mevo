"""YMM dış üretici görev paketleri: eksik soruları (eleme payıyla) satır satır görevlere böler.

Her ders için hedef `HEDEF_TEST` test sorusu ve `HEDEF_KLASIK` klasik sorudur. Eksik = hedef − bankada `kontrolde`
olan. Eksik, konu ağırlığına ve kitap zorluk dağılımına göre satırlara bölünür, `--pay` ile eleme payı eklenir.
Plan `content/gorevler/ymm_<tarih>.json` olarak saklanır; ön eleme (`pipeline.on_eleme`) her teslimi bu plana göre
denetler. Paketler (zip) `uretici_paketleri/` altına yazılır (depoya girmez).

    python -m pipeline.ymm_gorev plan [--pay 1.3] [--soru 30]     # yalnız planı yazar ve özetler
    python -m pipeline.ymm_gorev paket [--pay 1.3] [--soru 30]    # plan + ders başına zip
    python -m pipeline.ymm_gorev paket --mevcut                    # planı değiştirmeden paketleri yeniden üret
"""
from __future__ import annotations

import datetime as dt
import json
import math
import shutil
import sys
from collections import Counter, defaultdict
from pathlib import Path

import yaml

from pipeline import g2_yapi, harita, klasik, uretici_paketi

KOK = g2_yapi.KOK
HEDEF_TEST = 300
HEDEF_KLASIK = 30
ZORLUK_ORANI = (0.20, 0.45, 0.35)
PLAN_DIZINI = KOK / "content/gorevler"
# Biçim döngüsü; muhasebe derslerinde yevmiye kaydı sorusu da sorulur.
BICIMLER = ["standart", "olumsuz", "oncullu", "standart", "bosluk"]
YEVMIYELI = {"IFM", "REV"}


def _mufredat() -> list[dict]:
    return yaml.safe_load((KOK / "content/mufredat/ymm.yaml").read_text(encoding="utf-8"))["dersler"]


def _banka() -> tuple[Counter, Counter, Counter]:
    """(ders, konu) ve (ders, konu, zorluk) başına kabul edilmiş test sorusu; (ders, konu) başına klasik soru."""
    konu, zorluk = Counter(), Counter()
    for _, s in g2_yapi.dosyalari_yukle(KOK / "content/sorular/ymm"):
        if s.get("durum") in klasik.AKTARILAN_DURUMLAR:
            konu[(s["ders"], s["konu"])] += 1
            zorluk[(s["ders"], s["konu"], s["zorluk"])] += 1
    kl = Counter((k["ders"], k["konu"]) for _, k in klasik.yukle("ymm") if k.get("durum") in klasik.AKTARILAN_DURUMLAR)
    return konu, zorluk, kl


def _dagit(toplam: int, agirlik: dict[str, float]) -> dict[str, int]:
    """Toplamı ağırlıklara göre tam sayılara böler (en büyük kalan yöntemi)."""
    t = sum(agirlik.values()) or 1
    ham = {k: toplam * v / t for k, v in agirlik.items()}
    sonuc = {k: math.floor(v) for k, v in ham.items()}
    for k in sorted(ham, key=lambda k: ham[k] - sonuc[k], reverse=True)[: toplam - sum(sonuc.values())]:
        sonuc[k] += 1
    return sonuc


def plan_kur(pay: float = 1.3, gorev_boyu: int = 30) -> dict:
    konu_say, zorluk_say, klasik_say = _banka()
    tarih = dt.date.today().isoformat()
    gorevler: dict[str, dict] = {}
    for d in _mufredat():
        ders = d["kod"]
        agirlik = {k["kod"]: k["agirlik"]["ymm"] for k in d["konular"]}
        konu_hedef = _dagit(HEDEF_TEST, agirlik)
        satirlar = []
        for k in d["konular"]:
            kk = k["kod"]
            eksik = max(0, konu_hedef[kk] - konu_say[(ders, kk)])
            if not eksik:
                continue
            # Zorluk: konu hedefindeki kitap dağılımından mevcutlar düşülür, eksik bu açığa göre dağıtılır.
            acik = {z: max(0.0, konu_hedef[kk] * ZORLUK_ORANI[z - 1] - zorluk_say[(ders, kk, z)]) for z in (1, 2, 3)}
            if not sum(acik.values()):
                acik = {z: ZORLUK_ORANI[z - 1] for z in (1, 2, 3)}
            adet = _dagit(math.ceil(eksik * pay), acik)
            sira = [z for z in (3, 2, 1) for _ in range(adet[z])]
            bicimler = BICIMLER + (["yevmiye"] if ders in YEVMIYELI else [])
            for i, z in enumerate(sira):
                satirlar.append({"ders": ders, "konu": kk, "konu_ad": k["ad"],
                                 "kazanim": k["kazanimlar"][i % len(k["kazanimlar"])],
                                 "zorluk": z, "bicim": bicimler[i % len(bicimler)]})
        kl_hedef = _dagit(HEDEF_KLASIK, agirlik)
        klasikler = []
        for k in d["konular"]:
            eksik = max(0, kl_hedef[k["kod"]] - klasik_say[(ders, k["kod"])])
            for i in range(math.ceil(eksik * pay)):
                kaz = k["kazanimlar"]
                klasikler.append({"ders": ders, "konu": k["kod"], "konu_ad": k["ad"],
                                  "kazanimlar": [kaz[i % len(kaz)], kaz[(i + 1) % len(kaz)]], "zorluk": 3 if i % 2 == 0 else 2})
        parca = max(1, math.ceil(len(satirlar) / gorev_boyu))
        for g in range(parca):
            kod = f"YMM-{ders}-G{g + 1:02d}"
            mb = math.ceil(len(satirlar) / parca)  # test soruları da görevlere eşit bölünür
            mc = satirlar[g * mb:(g + 1) * mb]
            kb = math.ceil(len(klasikler) / parca)  # klasik sorular görevlere eşit bölünür
            kl = klasikler[g * kb:(g + 1) * kb]
            gorevler[kod] = {"ders": ders, "ders_ad": d["ad"],
                             "satirlar": [dict(s, n=i + 1) for i, s in enumerate(mc)],
                             "klasik": [dict(s, n=f"K{i + 1}") for i, s in enumerate(kl)]}
    return {"tarih": tarih, "pay": pay, "hedef_test": HEDEF_TEST, "hedef_klasik": HEDEF_KLASIK, "gorevler": gorevler}


def plan_yaz(plan: dict) -> Path:
    PLAN_DIZINI.mkdir(parents=True, exist_ok=True)
    yol = PLAN_DIZINI / f"ymm_{plan['tarih']}.json"
    yol.write_text(json.dumps(plan, ensure_ascii=False, indent=1), encoding="utf-8")
    return yol


def son_plan() -> dict:
    yollar = sorted(PLAN_DIZINI.glob("ymm_*.json"))
    if not yollar:
        raise FileNotFoundError("görev planı yok: önce `python -m pipeline.ymm_gorev plan`")
    return json.loads(yollar[-1].read_text(encoding="utf-8"))


GENEL_BILGI_NOTU = ('Bu dersin resmî mevzuat metni YOKTUR ve `kaynaklar/` klasörü bilerek boştur. Sorular/anlatım, genel kabul görmüş ders bilgisine (yerleşik finansal yönetim / yönetim muhasebesi literatüründeki standart tanım, formül ve yöntemlere) dayanır. Bu derste kaynak yokluğu ATLAMA SEBEBİ DEĞİLDİR: her satır yazılmalıdır ([K03] uygulanmaz). Kaynak alanına `mevzuat: "Genel bilgi — <konu adı>"`, `madde: "-"` yaz, `alinti` yazma. Tartışmalı/ekole bağlı konularda en yaygın kabul gören yöntemi kullan ve kökte hangi yöntemin kullanılacağını açıkça belirt.')


def _gorev_md(kod: str, g: dict, kaynakli: bool = True) -> str:
    s = [f"# Görev {kod} — {g['ders_ad']}", ""]
    if not kaynakli:
        s += ["> **ÖNEMLİ:** " + GENEL_BILGI_NOTU, ""]
    s += [
         f"Aşağıdaki **{len(g['satirlar'])} test sorusunu** ve **{len(g['klasik'])} klasik soruyu** `YMM_MANIFESTO.md`",
         f"kurallarına birebir uyarak yaz. Teslim: `teslim_<adın>_{kod}.yaml`, `gorev: \"{kod}\"`.", "",
         "## Test soruları", "",
         "| # | Ders | Konu kodu | Konu | Kazanım | Zorluk | Soru biçimi |", "|---|---|---|---|---|---|---|"]
    s += [f"| {r['n']} | {r['ders']} | {r['konu']} | {r['konu_ad']} | {r['kazanim']} | {r['zorluk']} | {r['bicim']} |"
          for r in g["satirlar"]]
    if g["klasik"]:
        s += ["", "## Klasik sorular (gorev_satiri: K1, K2, …)", "",
              "| # | Ders | Konu kodu | Konu | Kazanımlar | Zorluk |", "|---|---|---|---|---|---|"]
        s += [f"| {r['n']} | {r['ders']} | {r['konu']} | {r['konu_ad']} | {'; '.join(r['kazanimlar'])} | {r['zorluk']} |"
              for r in g["klasik"]]
    return "\n".join(s) + "\n"


def _bankada_olan(ders: str) -> str:
    s = [f"# {ders}: bankada zaten olan sorular — AYNI bilgiyi, kurguyu, sayısal senaryoyu TEKRARLAMA", ""]
    kokler = defaultdict(list)
    for _, q in g2_yapi.dosyalari_yukle(KOK / "content/sorular/ymm" / ders):
        if q.get("durum") in klasik.AKTARILAN_DURUMLAR:
            kokler[q["konu"]].append(" ".join(str(q["kok"]).split())[:160])
    for _, k in klasik.yukle("ymm"):
        if k["ders"] == ders and k.get("durum") in klasik.AKTARILAN_DURUMLAR:
            kokler[k["konu"]].append("[klasik] " + " ".join(k["soru"].split())[:160])
    for konu in sorted(kokler):
        s += [f"## {konu}", ""] + [f"- {x}" for x in kokler[konu]] + [""]
    return "\n".join(s)


def _ornekler(ders: str) -> list[dict]:
    secilen: dict = {}
    for _, q in g2_yapi.dosyalari_yukle(KOK / "content/sorular/ymm" / ders):
        if q.get("durum") in klasik.AKTARILAN_DURUMLAR and "iç hat" not in str(q.get("uretim", {}).get("model", "x")):
            secilen.setdefault(q["zorluk"], {a: q[a] for a in uretici_paketi.YAZAR_ALANLARI if a in q})
    ornek = [secilen[z] for z in sorted(secilen)]
    kl = next((k for _, k in klasik.yukle("ymm") if k["ders"] == ders and k.get("durum") in klasik.AKTARILAN_DURUMLAR), None)
    if kl:
        ornek.append({"klasik_ornegi": {a: kl[a] for a in klasik.YAZAR_ALANLARI if a in kl}})
    return ornek


def paket_olustur(plan: dict, cikti: Path) -> list[Path]:
    harita.sinav_sec("ymm")
    zipler = []
    dersler = defaultdict(list)
    for kod, g in plan["gorevler"].items():
        dersler[g["ders"]].append((kod, g))
    for ders, liste in dersler.items():
        klasor = cikti / f"YMM_{ders}_{plan['tarih']}"
        if klasor.exists():
            shutil.rmtree(klasor)
        (klasor / "kaynaklar").mkdir(parents=True)
        kaynaklar = uretici_paketi._kaynak_dosyalari(ders)
        for i, (kod, g) in enumerate(liste, 1):
            (klasor / f"GOREV_{i:02d}.md").write_text(_gorev_md(kod, g, bool(kaynaklar)), encoding="utf-8")
        if not kaynaklar:
            (klasor / "kaynaklar" / "KAYNAK_YOK_OKU.md").write_text("# Bu klasör bilerek boştur\n\n" + GENEL_BILGI_NOTU + "\n",
                                                                  encoding="utf-8")
        shutil.copy(KOK / "docs/uretici/YMM_MANIFESTO.md", klasor / "YMM_MANIFESTO.md")
        shutil.copy(KOK / "docs/uretici/YMM_PROMPT.md", klasor / "PROMPT.md")
        shutil.copy(KOK / "content/schema/soru.schema.json", klasor / "SEMA_TEST.json")
        shutil.copy(KOK / "content/schema/klasik.schema.json", klasor / "SEMA_KLASIK.json")
        (klasor / "ORNEKLER.yaml").write_text(
            yaml.safe_dump(_ornekler(ders), allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
        (klasor / "BANKADA_OLAN.md").write_text(_bankada_olan(ders), encoding="utf-8")
        for p in kaynaklar:
            shutil.copy(p, klasor / "kaynaklar" / p.name)
        zipler.append(Path(shutil.make_archive(str(klasor), "zip", klasor.parent, klasor.name)))
    return zipler


def ozet(plan: dict) -> str:
    sayac = Counter()
    for g in plan["gorevler"].values():
        sayac[(g["ders"], "test")] += len(g["satirlar"])
        sayac[(g["ders"], "klasik")] += len(g["klasik"])
        sayac[(g["ders"], "gorev")] += 1
    dersler = sorted({d for d, _ in sayac})
    satir = [f"{d}: {sayac[(d, 'gorev')]} görev, {sayac[(d, 'test')]} test, {sayac[(d, 'klasik')]} klasik" for d in dersler]
    satir.append(f"TOPLAM: {len(plan['gorevler'])} görev, {sum(v for (d, t), v in sayac.items() if t == 'test')} test, "
                 f"{sum(v for (d, t), v in sayac.items() if t == 'klasik')} klasik (eleme payı ×{plan['pay']})")
    return "\n".join(satir)


def main(argv: list[str]) -> int:
    if len(argv) < 2 or argv[1] not in ("plan", "paket"):
        print(__doc__)
        return 1
    pay = float(argv[argv.index("--pay") + 1]) if "--pay" in argv else 1.3
    boy = int(argv[argv.index("--soru") + 1]) if "--soru" in argv else 30
    if "--mevcut" in argv:  # dağıtılmış görevlerin satırları değişmesin: son plandan paket üret
        plan = son_plan()
        print(f"mevcut plan ({plan['tarih']}) kullanılıyor")
    else:
        plan = plan_kur(pay, boy)
        print(f"plan → {plan_yaz(plan).relative_to(KOK)}")
    print(ozet(plan))
    if argv[1] == "paket":
        cikti = Path(argv[argv.index("--cikti") + 1]) if "--cikti" in argv else KOK / "uretici_paketleri"
        for z in paket_olustur(plan, cikti):
            print(z)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
