"""ÇIKMIŞ SORUDAN ÖZGÜN SORU hattı (türev): kalıp → yeni soru → yerel kapılar → kör çözücü ×2 + hakem → karar.

Tüm model aşamaları TEK Modal konteyner oturumunda (Qwen3-235B-A22B-Thinking-2507-FP8) yapılır.
Giriş: python -m pipeline.modal.hat turev ... (bkz. hat.py). Bankaya YAZMAZ.
"""
from __future__ import annotations

import datetime as dt
import difflib
import json
import os
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap, g7_ozgunluk, on_eleme, uretici_paketi
from pipeline.modal import getir, istemler, kalip
from pipeline.modal import turev_istem as ti

KOK = g2_yapi.KOK
MODEL_ADI = "Qwen3-235B-A22B-Thinking-2507-FP8 (Modal türev hattı)"
FIYAT = {"B200": 6.25, "H200": 4.54, "H100": 3.95}
KOPYA_ESIK = 0.15       # kalıpla kelime 5-gram Jaccard
KOK_BENZERLIK = 0.55    # kalıp kökü ile karakter benzerliği (difflib)
PILOT_DAGILIM = {"VER": 8, "DEN": 6, "MES": 6, "SPK": 6, "HUK": 5, "FIN": 5, "MAL": 4}
MAX_TOK = {"uretim": 12000, "onarim": 10000, "cozucu": 12000, "hakem": 14000}
# Yerel kapıda düzeltilebilir (biçim/kopya/alıntı) hatalar: model hatalarla birlikte bir kez onarıma gönderilir.
ONARILIR = {"G2", "SIK", "KOPYA", "ALINTI", "G4", "ATIF"}
DUSUNEN_ORNEKLEME = {"temperature": 0.6, "top_p": 0.95, "top_k": 20}

# ------------------------------------------------------------------ kalıp seçimi
def kaliplari_yukle() -> list[dict]:
    y = kalip.yapi_kaliplari()  # başka ajanın ayrıştırması hazırsa önce o
    return y + kalip.smmm2026()


def sec(kaliplar: list[dict], dagilim: dict, atla: set | None = None) -> list[dict]:
    atla = atla or set()
    muf = _mufredat()
    havuz = defaultdict(lambda: defaultdict(list))
    for k in kaliplar:
        if k.get("okuma_guveni", 0) < 0.9 or not k.get("dogru") or k["kid"] in atla:
            continue
        if (k["ders"], k.get("konu")) not in muf:
            continue
        havuz[k["ders"]][k["konu"]].append(k)
    out = []
    for ders, n in dagilim.items():
        konular = sorted(havuz[ders], key=lambda c: -len(havuz[ders][c]))
        i = 0
        while sum(1 for x in out if x["ders"] == ders) < n and any(havuz[ders][c] for c in konular):
            c = konular[i % len(konular)]
            if havuz[ders][c]:
                # dönemler karışsın: sıradaki kalıp alternatif dönemden
                liste = havuz[ders][c]
                out.append(liste.pop(0 if i % 2 == 0 else -1))
            i += 1
    return out


_MUF = {}


def _mufredat() -> dict:
    if not _MUF:
        for d in yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))["dersler"]:
            for c in d["konular"]:
                _MUF[(d["kod"], c["kod"])] = {"ders_ad": d["ad"], "konu_ad": c["ad"], "kazanimlar": c.get("kazanimlar") or []}
    return _MUF


# ------------------------------------------------------------------ hazırlık
def onekler(k: dict) -> list[str]:
    return uretici_paketi.DERS_KAYNAK.get(k["ders"], [])


KANUN_NO = {"193": "gvk", "5520": "kvk", "3065": "kdvk", "213": "vuk", "6183": "aatuhk", "4760": "otvk", "488": "dvk",
            "7338": "vivk", "197": "mtvk", "1319": "evk", "6098": "tbk", "6102": "ttk", "4857": "isk", "5510": "sgk",
            "2577": "iyuk", "6362": "spkn", "3568": "smmm_kanunu", "5549": "aklama_5549", "492": "harclar"}
ATILAN = {"msugt_1_ek5_thp_dipnotlu"}  # güncel THP ile mükerrer


def parca_getir(on: list[str], sorgu: str, butce: int) -> list[dict]:
    if not on:
        return []
    dz = getir.dizin(on)
    bonus = getir.dosya_bonusu(sorgu, on)
    for no in re.findall(r"(\d{3,4}) sayılı", sorgu):
        if no in KANUN_NO:
            for d in getir.dosyalar(on):
                if d == KANUN_NO[no] or d.startswith(KANUN_NO[no] + "_"):
                    bonus[d] = max(bonus.get(d, 1.0), 3.0)
    return [p for p in dz.ara(sorgu, butce=butce + 4000, dosya_bonus=bonus) if p["dosya"] not in ATILAN][:14]


def gorev_kur(k: dict, i: int) -> dict:
    m = _mufredat()[(k["ders"], k["konu"])]
    sorgu = " ".join([kalip.kalip_metni(k), k.get("konu_aciklama") or "", m["konu_ad"]])
    butce = 9000 if k["ders"] == "MAL" else 16000
    parcalar = parca_getir(onekler(k), sorgu, butce)
    return {"tid": f"K{i + 1:03d}", "kid": k["kid"], "kalip": k, "sinav": k["sinav"], "ders": k["ders"],
            "ders_ad": m["ders_ad"], "konu": k["konu"], "konu_ad": m["konu_ad"], "kazanimlar": m["kazanimlar"],
            "bolum": ["YET"], "onekler": onekler(k), "parcalar": parcalar, "hedef_harf": istemler.HARFLER[(i * 3) % 5]}


def _banka_kokleri(g: dict, n: int = 10) -> list[str]:
    from pipeline.modal import hat
    ayni = [s for s in hat.banka(g["sinav"]) if s.get("ders") == g["ders"] and s.get("konu") == g["konu"]
            and s.get("durum") != "geri_cekildi"]
    # kalıba en çok benzeyenler önce (aynı kuralı soranları göstermek için)
    kp = set(kalip.kalip_metni(g["kalip"]).lower().split())
    ayni.sort(key=lambda s: -len(kp & set(str(s.get("kok", "")).lower().split())))
    return [" ".join(str(s["kok"]).split())[:170] for s in ayni[:n]]


def uretim_istekleri(gorevler: list[dict], aday: int) -> list[dict]:
    ist = []
    for g in gorevler:
        u = ti.uretim_kullanici(g["kalip"], g["parcalar"], g["kazanimlar"], _banka_kokleri(g), g["hedef_harf"])
        for a in range(aday):
            ist.append({"anahtar": f"{g['tid']}-{a}", "system": ti.uretim_sistem(), "user": u,
                        "max_tokens": MAX_TOK["uretim"], "seed": 2000 + a, **DUSUNEN_ORNEKLEME})
    return ist


# ------------------------------------------------------------------ yerel kapılar
def _kelime(t: str) -> list[str]:
    return re.findall(r"[0-9a-zçğıöşüâîû]+", t.replace("İ", "i").replace("I", "ı").lower())


def _ngram(t: str, n: int = 5) -> set:
    w = _kelime(t)
    return {tuple(w[i:i + n]) for i in range(len(w) - n + 1)}


def kopya_olc(k: dict, s: dict) -> dict:
    a = kalip.kalip_metni(k)
    b = s["kok"] + "\n" + "\n".join(f"{h}) {v}" for h, v in s["secenekler"].items())
    ga, gb = _ngram(a), _ngram(b)
    jac = len(ga & gb) / max(1, len(ga | gb))
    kok_a = " ".join(_kelime(k.get("kok") or a))
    kok_b = " ".join(_kelime(s["kok"]))
    oran = difflib.SequenceMatcher(None, kok_a, kok_b, autojunk=False).ratio()
    # aynı şık metni (normalize) kalıpta da var mı
    sik_a = {" ".join(_kelime(v)) for v in (k.get("secenekler") or {}).values()}
    ayni_sik = sum(1 for v in s["secenekler"].values() if len(_kelime(v)) >= 4 and " ".join(_kelime(v)) in sik_a)
    return {"jaccard5": round(jac, 3), "kok_benzerlik": round(oran, 3), "ayni_sik": ayni_sik}


SAYI = re.compile(r"\d[\d.,]*\d|\d")


def _sayilar(t: str) -> set:
    out = set()
    for x in SAYI.findall(t):
        n = x.replace(".", "").replace(",", "")
        if len(n) >= 3 and not re.fullmatch(r"(19|20)\d\d", n):
            out.add(n)
    return out


def sayi_tekrari(k: dict, s: dict, parcalar: list[dict]) -> list[str]:
    """Kalıptaki (mevzuatta geçmeyen) sayıların yeni soruda tekrar kullanılması."""
    parca = set().union(*[_sayilar(p["metin"]) for p in parcalar]) if parcalar else set()
    a = _sayilar(kalip.kalip_metni(k)) - parca
    b = _sayilar(s["kok"] + " " + " ".join(s["secenekler"].values()))
    return sorted(a & b)


_MEVZUAT_NORM: dict = {}


def _mevzuat_norm() -> dict:
    if not _MEVZUAT_NORM:
        for p in getir.MEVZUAT.glob("*.txt"):
            _MEVZUAT_NORM[p.stem] = uretici_paketi._norm(p.read_text(encoding="utf-8", errors="ignore"))
    return _MEVZUAT_NORM


def alinti_denetle(s: dict, g: dict, j: dict) -> tuple[list[str], int]:
    h, sayac = [], 0
    tum = list(getir.dizin(g["onekler"]).parcalar) if g["onekler"] else []
    ham = [x for x in (j.get("kaynaklar") or []) if isinstance(x, dict)]
    for k in ham:
        al = str(k.get("alinti") or "")
        if not al:
            continue
        if "..." in al or "…" in al:
            h.append(f"ALINTI: kesintili alıntı ('...') → {al[:60]}")
            continue
        n = uretici_paketi._norm(al)
        if len(n) < 45:
            h.append(f"ALINTI: çok kısa ({len(n)} harf)")
            continue
        dosya = [d for d, m in _mevzuat_norm().items() if n in m]
        if not dosya:
            h.append(f"ALINTI: resmî metinde birebir yok → {k.get('madde')}: '{al[:80]}'")
            continue
        sayac += 1
        p = next((p for p in g["parcalar"] if n in uretici_paketi._norm(p["metin"])), None) or \
            next((p for p in tum if n in uretici_paketi._norm(p["metin"])), None)
        if p is not None:
            if re.search(r"\(\s*mülga", p["metin"][:300], re.I) and len(p["metin"]) < 600:
                h.append(f"GUNCEL: alıntılanan madde mülga görünüyor ({p['dosya']} {p['baslik']})")
            mn = re.search(r"(\d+)", str(k.get("madde") or ""))
            if p.get("madde") and mn and mn.group(1) != re.search(r"(\d+)", p["madde"]).group(1):
                h.append(f"ATIF: '{k.get('madde')}' yazılmış, alıntı {p['dosya']} {p['baslik']} içinde")
    return h, sayac


def kayit_kur(j: dict, g: dict) -> dict:
    from pipeline.modal import hat
    gg = {"sinav": g["sinav"], "ders": g["ders"], "konu": g["konu"], "konu_ad": g["konu_ad"], "bolum": g["bolum"],
          "kazanim": j.get("kazanim") if j.get("kazanim") in g["kazanimlar"] else (g["kazanimlar"] or ["-"])[0],
          "zorluk": j.get("zorluk", 2)}
    s = hat.kayit_kur(j, gg)
    s["uretim"] = {"kaynak_turu": "yapay_zeka", "model": MODEL_ADI, "istem_surumu": ti.SURUM}
    return s


def yerel_denetim(s: dict, g: dict, j: dict, parti: list[set]) -> tuple[list[str], dict]:
    from pipeline.modal import hat
    h = [f"G2: {x}" for x in g2_yapi.soru_denetle(s).hatalar]
    olcum = {}
    if h:
        return h, olcum
    h += [f"G2: {x}" for x in g2_yapi.soru_denetle(s).uyarilar]
    sayisal = sum(1 for v in s["secenekler"].values() if g4_hesap.sayiya_cevir(v) is not None) >= 4
    if s.get("tip") == "hesaplama" or sayisal:
        if not s.get("dogrulama"):
            h.append("G4: hesap/sayısal sorusunda dogrulama.python yok")
        elif on_eleme.YASAK_KOD.search(s["dogrulama"]["python"]):
            h.append("G4: doğrulama kodunda yasak yapı")
        else:
            if s.get("tip") != "hesaplama":
                s["tip"] = "hesaplama"
            h += [f"G4: {x}" for x in g4_hesap.soru_denetle(s).hatalar]
    h += [f"SIK: {x}" for x in on_eleme.sik_sorunlari(s)]
    ah, n_alinti = alinti_denetle(s, g, j)
    h += ah
    if not n_alinti:
        h.append("ALINTI: birebir doğrulanan resmî metin alıntısı yok")
    gun = j.get("guncellik") if isinstance(j.get("guncellik"), dict) else {}
    if gun.get("durum") not in ("gecerli", "guncellendi"):
        h.append(f"GUNCEL: model güncelliği teyit etmedi ({gun.get('durum')})")
    olcum = kopya_olc(g["kalip"], s)
    if olcum["jaccard5"] >= KOPYA_ESIK:
        h.append(f"KOPYA: kalıpla 5-gram Jaccard {olcum['jaccard5']} ≥ {KOPYA_ESIK}")
    if olcum["kok_benzerlik"] >= KOK_BENZERLIK:
        h.append(f"KOPYA: kök karakter benzerliği {olcum['kok_benzerlik']} ≥ {KOK_BENZERLIK}")
    if olcum["ayni_sik"] >= 2:
        h.append(f"KOPYA: {olcum['ayni_sik']} şık kalıpla aynı")
    st = sayi_tekrari(g["kalip"], s, g["parcalar"])
    olcum["kalip_sayilari"] = st
    if len(st) >= 2:
        h.append(f"KOPYA: kalıptaki sayılar tekrar kullanılmış {st[:5]}")
    parca = g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s))
    oran = g7_ozgunluk.kapsanma(parca, hat._banka_parcalari(g["sinav"], g["ders"], g["konu"]))
    olcum["banka_benzerlik"] = round(oran, 3)
    if oran > g7_ozgunluk.ESIK_BANKA:
        h.append(f"G7: bankadaki sorulara benzerlik %{oran * 100:.0f}")
    if any(g7_ozgunluk.kapsanma(parca, p) > g7_ozgunluk.ESIK_BANKA for p in parti):
        h.append("G7: bu partideki başka bir soruya çok benziyor")
    return h, olcum


def adaylari_isle(asama1: dict, gorev: dict) -> tuple[list[dict], list[dict]]:
    adaylar, red, parti = [], [], []
    for anahtar, metin in asama1.items():
        g = gorev[anahtar.split("-")[0]]
        _, bitti = ti.dusunce_ayir(metin)
        j = ti.json_al(metin)
        taban = {"anahtar": anahtar, "kid": g["kid"]}
        if not bitti:
            red.append(taban | {"asama": "uretim", "neden": ["UZUNLUK: düşünme bitmedi (token sınırı)"]})
            continue
        if j is None:
            red.append(taban | {"asama": "uretim", "neden": ["JSON okunamadı"], "ham": ti.dusunce_ayir(metin)[0][:1500]})
            continue
        if j.get("atla"):
            red.append(taban | {"asama": "uretim", "neden": [f"ATLA: model atladı: {j.get('neden')}"]})
            continue
        s = kayit_kur(j, g)
        sorun, olcum = yerel_denetim(s, g, j, parti)
        if sorun:
            red.append(taban | {"asama": "yerel", "neden": sorun, "olcum": olcum, "soru": s,
                                "kalip_kurali": j.get("kalip_kurali")})
            continue
        parti.append(g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s)))
        adaylar.append({"anahtar": anahtar, "tid": g["tid"], "soru": s, "olcum": olcum,
                        "kalip_kurali": j.get("kalip_kurali"), "guncellik": j.get("guncellik")})
    return adaylar, red


def onarim_istekleri(red: list[dict], gorev: dict, asama1: dict) -> list[dict]:
    ist = []
    for r in red:
        if r["asama"] != "yerel" or not all(_tur(n) in ONARILIR for n in r["neden"]):
            continue
        g = gorev[r["anahtar"].split("-")[0]]
        taslak = ti.dusunce_ayir(asama1[r["anahtar"]])[0].strip()
        u = ti.uretim_kullanici(g["kalip"], g["parcalar"], g["kazanimlar"], _banka_kokleri(g), g["hedef_harf"])
        u += ("\n\n## Önceki taslağın otomatik kapılarda REDDEDİLDİ\n" + taslak[:9000] +
              "\n\n## Kapı hataları\n" + "\n".join(f"- {n}" for n in r["neden"]) +
              "\n\nBu hataların HEPSİNİ gider ve soruyu baştan doğrula: `aciklama.celdiriciler` doğru dışındaki dört harfin "
              "her biri için zorunlu; olumsuz ifade **kalın**; kök ve şıklar kalıptan farklı cümle yapısıyla, farklı "
              "senaryo/sayı/adla kurulmalı (kalıbın kök cümlesini kullanma); alıntı parçadan harfi harfine ve kesintisiz; "
              "doğru şık en uzun ya da en kısa şık olmasın; python yalnız düz aritmetik. Gideremiyorsan ATLA. Yalnız JSON.")
        ist.append({"anahtar": f"{g['tid']}-r", "system": ti.uretim_sistem(), "user": u, "max_tokens": MAX_TOK["onarim"],
                    "seed": 3000, **DUSUNEN_ORNEKLEME})
    return ist


# ------------------------------------------------------------------ doğrulama
def _dogrulama_parcalari(s: dict, g: dict) -> list[dict]:
    if not g["onekler"]:
        return []
    sorgu = s["kok"] + " " + " ".join(s["secenekler"].values())
    return parca_getir(g["onekler"], sorgu, 14000)


def _birlesik(a: list[dict], b: list[dict], sinir: int = 20000) -> list[dict]:
    out, gor, top = [], set(), 0
    for p in a + b:
        k = (p["dosya"], p["baslik"])
        if k in gor or top + len(p["metin"]) > sinir:
            continue
        gor.add(k)
        out.append(p)
        top += len(p["metin"])
    return out


def dogrulama_istekleri(adaylar: list[dict], gorev: dict) -> list[dict]:
    ist = []
    for a in adaylar:
        g, s = gorev[a["tid"]], a["soru"]
        sn = g["sinav"].upper()
        taze = _dogrulama_parcalari(s, g)
        # c1: üreticinin gördüğü parçalar; c2: yalnız yeni soruyla getirilen parçalar + şık sırası döndürülmüş
        ist.append({"anahtar": f"{a['anahtar']}|c1", "system": ti.COZUCU.format(sinav=sn),
                    "user": istemler.cozucu_kullanici(s["kok"], s["secenekler"], g["parcalar"]),
                    "max_tokens": MAX_TOK["cozucu"], "seed": 11, **DUSUNEN_ORNEKLEME})
        kar, _ = istemler.karistir(s["secenekler"], 2)
        ist.append({"anahtar": f"{a['anahtar']}|c2", "system": ti.COZUCU.format(sinav=sn),
                    "user": istemler.cozucu_kullanici(s["kok"], kar, taze or g["parcalar"]),
                    "max_tokens": MAX_TOK["cozucu"], "seed": 22, **DUSUNEN_ORNEKLEME})
        ist.append({"anahtar": f"{a['anahtar']}|hk", "system": ti.hakem_sistem(g["sinav"]),
                    "user": ti.hakem_kullanici(s, _birlesik(g["parcalar"], taze)),
                    "max_tokens": MAX_TOK["hakem"], "seed": 33, **DUSUNEN_ORNEKLEME})
    return ist


def _guven(x: dict) -> int:
    try:
        return int(x.get("guven", 0))
    except (TypeError, ValueError):
        return 0


def karar(a: dict, c: dict) -> tuple[bool, list[str], dict]:
    s = a["soru"]
    c1, c2, hk = (ti.json_al(c.get(t, "")) or {} for t in ("c1", "c2", "hk"))
    _, esle = istemler.karistir(s["secenekler"], 2)
    cv1 = str(c1.get("cevap", "")).strip().upper()[:1]
    ham2 = str(c2.get("cevap", "")).strip().upper()[:1]
    cv2 = esle.get(ham2, ham2)
    neden = []
    for ad, cv, x, ham in (("COZUCU1", cv1, c1, c.get("c1", "")), ("COZUCU2", cv2, c2, c.get("c2", ""))):
        if not x:
            neden.append(f"{ad}: çıktı okunamadı{' (düşünme bitmedi)' if not ti.dusunce_ayir(ham)[1] else ''}")
        elif cv != s["dogru"]:
            neden.append(f"{ad}: kör çözücü {x.get('cevap')} buldu (anahtar {s['dogru']}) — {str(x.get('cozum', ''))[:300]}")
        elif _guven(x) < 4:
            neden.append(f"{ad}: doğru ama güven {_guven(x)}")
    if not hk:
        neden.append("HAKEM: çıktı okunamadı")
    else:
        hatalar = [str(x.get("ne", x)) for x in hk.get("sorunlar") or [] if isinstance(x, dict)
                   and str(x.get("tur", "")).upper().startswith("HATA")]
        bayrak = [k for k in ("anahtar_dogru_mu", "tek_dogru_mu", "kok_acik_mi", "aciklama_dogru_mu", "alinti_destekliyor_mu")
                  if hk.get(k) is False]
        bayrak += [k for k in ("uydurma_atif_var_mi", "imkansiz_varsayim_var_mi", "guncel_olmayan_hukum_var_mi")
                   if hk.get(k) is True]
        if hk.get("gecerli") is not True or hatalar or bayrak:
            neden.append(f"HAKEM: reddetti [{', '.join(bayrak)}] " + " | ".join(hatalar)[:800])
    return not neden, neden, {"c1": c1, "c2": c2, "hakem": hk}


# ------------------------------------------------------------------ çalıştırma
def _yaz_json(yol: Path, veri) -> None:
    yol.parent.mkdir(parents=True, exist_ok=True)
    yol.write_text(json.dumps(veri, ensure_ascii=False, indent=1), encoding="utf-8")


def calistir(gorevler: list[dict], cikti: Path, aday: int, kip: str, butce: float) -> None:
    cikti.mkdir(parents=True, exist_ok=True)
    log = open(cikti / "log.txt", "a", encoding="utf-8")

    def yaz(*a):
        satir = f"[{dt.datetime.now():%H:%M:%S}] " + " ".join(str(x) for x in a)
        print(satir, flush=True)
        log.write(satir + "\n")
        log.flush()

    gorev = {g["tid"]: g for g in gorevler}
    _yaz_json(cikti / "gorevler.json", [{k: v for k, v in g.items() if k not in ("parcalar",)} | {
        "parcalar": [f"{p['dosya']} · {p['baslik']} ({p['puan']})" for p in g["parcalar"]]} for g in gorevler])
    ist1 = uretim_istekleri(gorevler, aday)
    yaz(f"profil {os.environ.get('MODAL_PROFILE')}, kalıp {len(gorevler)}, üretim isteği {len(ist1)}, "
        f"girdi ≈ {sum(len(i['system']) + len(i['user']) for i in ist1) / 3000:.0f}k token")
    if kip == "kuru":
        _yaz_json(cikti / "istem_ornegi.json", ist1[:2])
        return
    import modal
    sys.path.insert(0, str(Path(__file__).parent))
    import modal_app  # noqa: E402
    ham = {"asama1": {}, "asama2": {}, "maliyet": {}}
    t0 = time.time()
    bilgi = {}
    cik = modal.enable_output()
    cik.__enter__()
    baglam = modal_app.app.run()
    baglam.__enter__()
    try:
        usta = modal_app.Dusunen()
        bilgi = usta.bilgi.remote()
        yaz(f"model hazır: {bilgi} (bekleme+yükleme {time.time() - t0:.0f} sn)")
        r1 = usta.uret.remote(ist1)
        yaz(f"aşama 1: {len(ist1)} istek, {r1['sure_sn']:.0f} sn, girdi {r1['girdi_tok']} / çıktı {r1['cikti_tok']} token, "
            f"bitiş {Counter(r1['bitis'])}")
        ham["asama1"] = {i["anahtar"]: m for i, m in zip(ist1, r1["metinler"])}
        _yaz_json(cikti / "ham.json", ham)
        adaylar, red = adaylari_isle(ham["asama1"], gorev)
        yaz(f"yerel kapılar: {len(adaylar)} aday geçti, {len(red)} elendi")
        ist1b = onarim_istekleri(red, gorev, ham["asama1"])
        s_usd = 2 * FIYAT[next((k for k in FIYAT if k in str(bilgi.get("gpu", ""))), "B200")]
        h1 = r1["cikti_tok"] / max(1.0, r1["sure_sn"])
        tah_1b = len(ist1b) * r1["cikti_tok"] / max(1, len(ist1)) / max(1.0, h1) / 3600 * s_usd
        if ist1b and (time.time() - t0) / 3600 * s_usd + tah_1b > 0.6 * butce:
            yaz(f"BÜTÇE: onarım aşaması atlandı (tahmini {tah_1b:.2f} $)")
            ist1b = []
        if ist1b:
            r1b = usta.uret.remote(ist1b)
            yaz(f"aşama 1b (onarım): {len(ist1b)} istek, {r1b['sure_sn']:.0f} sn, çıktı {r1b['cikti_tok']} token, "
                f"bitiş {Counter(r1b['bitis'])}")
            ham["asama1b"] = {i["anahtar"]: m for i, m in zip(ist1b, r1b["metinler"])}
            _yaz_json(cikti / "ham.json", ham)
            adaylar, red = adaylari_isle({**ham["asama1"], **ham["asama1b"]}, gorev)
            yaz(f"onarım sonrası yerel kapılar: {len(adaylar)} aday geçti")
        ist2 = dogrulama_istekleri(adaylar, gorev)
        gpu = str(bilgi.get("gpu", ""))
        saat_usd = 2 * FIYAT[next((k for k in FIYAT if k in gpu), "B200")]
        harcanan = (time.time() - t0) / 3600 * saat_usd
        # aşama 2 süresi tahmini: aşama 1'in çıktı hızıyla, istek başına aşama 1 ortalamasının %60'ı kadar çıktı
        hiz = r1["cikti_tok"] / max(1.0, r1["sure_sn"])
        ort = r1["cikti_tok"] / max(1, len(ist1))
        def tahmin(n):
            return n * 1.0 * ort / max(1.0, hiz) / 3600 * saat_usd * 1.15 + 60 / 3600 * saat_usd
        kalan = butce - harcanan
        n_aday = len(adaylar)
        while n_aday > 0 and tahmin(3 * n_aday) > kalan:
            n_aday -= 1
        if n_aday < len(adaylar):
            yaz(f"BÜTÇE: ≈{harcanan:.2f} $ harcandı; aşama 2 tahmini {tahmin(len(ist2)):.2f} $ > kalan {kalan:.2f} $ "
                f"→ yalnız ilk {n_aday}/{len(adaylar)} aday doğrulanacak")
            ist2 = ist2[:3 * n_aday]
        else:
            yaz(f"bütçe: ≈{harcanan:.2f} $ harcandı, aşama 2 tahmini {tahmin(len(ist2)):.2f} $")
        if ist2:
            r2 = usta.uret.remote(ist2)
            yaz(f"aşama 2: {len(ist2)} istek, {r2['sure_sn']:.0f} sn, girdi {r2['girdi_tok']} / çıktı {r2['cikti_tok']} token, "
                f"bitiş {Counter(r2['bitis'])}")
            ham["asama2"] = {i["anahtar"]: m for i, m in zip(ist2, r2["metinler"])}
            ham["tok"] = {"a1": [r1["girdi_tok"], r1["cikti_tok"], r1["sure_sn"]], "a2": [r2["girdi_tok"], r2["cikti_tok"], r2["sure_sn"]]}
    finally:
        sure = time.time() - t0
        baglam.__exit__(None, None, None)
        gpu = str(bilgi.get("gpu", ""))
        tur = next((k for k in FIYAT if k in gpu), "H200")
        ham["maliyet"] = {"gpu": gpu, "model": bilgi.get("model"), "profil": os.environ.get("MODAL_PROFILE"),
                          "toplam_sn": round(sure), "yukleme_sn": bilgi.get("yukleme_sn"),
                          "tahmini_usd": round(sure / 3600 * FIYAT[tur] * 2, 2), "fiyat_saat_gpu": FIYAT[tur]}
        _yaz_json(cikti / "ham.json", ham)
        yaz(f"oturum kapandı: {sure:.0f} sn, tahmini {ham['maliyet']['tahmini_usd']} $ ({gpu})")
    isle(cikti, gorevler)


def gorevleri_yukle(cikti: Path) -> list[dict]:
    """isle için: kayıtlı görevlerden parçaları aynı sırayla yeniden getirir."""
    gorevler = json.loads((cikti / "gorevler.json").read_text(encoding="utf-8"))
    tum = {k["kid"]: k for k in kaliplari_yukle()}
    out = []
    for i, g in enumerate(gorevler):
        yeni = gorev_kur(tum[g["kid"]], i)
        yeni["tid"], yeni["hedef_harf"] = g["tid"], g["hedef_harf"]
        out.append(yeni)
    return out


def isle(cikti: Path, gorevler: list[dict] | None = None) -> None:
    ham = json.loads((cikti / "ham.json").read_text(encoding="utf-8"))
    gorevler = gorevler or gorevleri_yukle(cikti)
    gorev = {g["tid"]: g for g in gorevler}
    adaylar, red = adaylari_isle({**ham["asama1"], **ham.get("asama1b", {})}, gorev)
    kabul, kabul_parca, gorev_kabul = [], [], set()
    bugun = dt.date.today().isoformat()
    from pipeline.modal import hat
    hat._SAYAC.clear()
    for a in adaylar:
        c = {t: ham["asama2"].get(f"{a['anahtar']}|{t}", "") for t in ("c1", "c2", "hk")}
        s = a["soru"]
        g = gorev[a["tid"]]
        if not any(c.values()):
            red.append({"anahtar": a["anahtar"], "kid": g["kid"], "asama": "dogrulama", "neden": ["doğrulama yapılmadı"], "soru": s})
            continue
        ok, neden, ek = karar(a, c)
        parca = g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s))
        if ok and a["tid"] in gorev_kabul:
            ok, neden = False, ["fazla aday: bu kalıptan başka bir aday zaten kabul edildi"]
        if ok and any(g7_ozgunluk.kapsanma(parca, p) > g7_ozgunluk.ESIK_BANKA for p in kabul_parca):
            ok, neden = False, ["G7: bu partide kabul edilen bir soruya çok benziyor"]
        if not ok:
            red.append({"anahtar": a["anahtar"], "kid": g["kid"], "asama": "dogrulama", "neden": neden, "soru": s,
                        "denetim": ek, "olcum": a["olcum"]})
            continue
        s["id"] = hat._sonraki_id(s["sinav"], s["ders"], s["konu"])
        o = a["olcum"]
        s["uretim"]["kapilar"] = {
            "G2": {"sonuc": "gecti", "tarih": bugun},
            "G4": {"sonuc": "gecti", "tarih": bugun} if s.get("dogrulama") else {"sonuc": "atlandi", "not": "hesaplama sorusu değil"},
            "G7": {"sonuc": "gecti", "not": f"banka %{o['banka_benzerlik'] * 100:.0f}; kalıp 5-gram Jaccard {o['jaccard5']}, kök benzerliği {o['kok_benzerlik']}", "tarih": bugun},
            "G3": {"sonuc": "gecti", "not": f"türev hat: 2 kör çözücü (Thinking; farklı parça seti + şık sırası) güven {ek['c1'].get('guven')}/{ek['c2'].get('guven')}", "tarih": bugun},
            "G5": {"sonuc": "gecti", "not": "türev hat hakemi (Thinking; uydurma atıf/imkânsız varsayım/güncellik/tek doğru)", "tarih": bugun},
            "G6": {"sonuc": "gecti", "not": "alıntı resmî metinlerde birebir arandı; madde no parça başlığıyla eşleşti", "tarih": bugun}}
        s["gecmis"] = [{"tarih": bugun, "kim": "modal-turev", "ne": f"türev üretim {a['anahtar']} ← kalıp {g['kid']}",
                        "neden": "tüm türev kapıları geçti; uzman incelemesi (G8) bekliyor"}]
        kabul.append({"soru": s, "kid": g["kid"], "kalip_kurali": a["kalip_kurali"], "guncellik": a["guncellik"],
                      "hakem_iyilestirme": [x.get("ne") for x in ek["hakem"].get("sorunlar") or [] if isinstance(x, dict)],
                      "olcum": o})
        kabul_parca.append(parca)
        gorev_kabul.add(a["tid"])
    (cikti / "kabul_smmm.yaml").write_text(yaml.safe_dump([k["soru"] for k in kabul if k["soru"]["sinav"] == "smmm"],
                                                          allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")
    ymm = [k["soru"] for k in kabul if k["soru"]["sinav"] == "ymm"]
    if ymm:
        (cikti / "kabul_ymm.yaml").write_text(yaml.safe_dump(ymm, allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")
    _yaz_json(cikti / "red.json", red)
    _yaz_json(cikti / "kabul_notlari.json", {k["soru"]["id"]: {kk: k[kk] for kk in ("kid", "kalip_kurali", "guncellik", "olcum", "hakem_iyilestirme")} for k in kabul})
    ozet(cikti, gorevler, kabul, red, ham)


def _tur(n: str) -> str:
    return n.split(":")[0].split(" ")[0]


def ozet(cikti, gorevler, kabul, red, ham) -> None:
    tur = Counter()
    for r in red:
        if any(n.startswith("fazla aday") for n in r["neden"]):
            tur["fazla_aday"] += 1
            continue
        for t in {_tur(n) for n in r["neden"]}:
            tur[t] += 1
    m = ham.get("maliyet", {})
    usd = m.get("tahmini_usd") or 0
    o = {"kalip": len(gorevler), "uretilen_aday": len(ham["asama1"]), "onarim_aday": len(ham.get("asama1b", {})),
         "kabul": len(kabul),
         "kalip_basina_kabul": round(len(kabul) / max(1, len(gorevler)), 3),
         "ders_kabul": dict(Counter(k["soru"]["ders"] for k in kabul)),
         "red_nedenleri (aday; bir aday birden çok nedenle)": dict(tur.most_common()),
         "asama_red": dict(Counter(r["asama"] for r in red)),
         "maliyet": m, "token": ham.get("tok"), "kabul_basina_usd": round(usd / max(1, len(kabul)), 3)}
    _yaz_json(cikti / "maliyet.json", o)
    print(json.dumps(o, ensure_ascii=False, indent=1))


def ornekler_md(cikti: Path, n: int = 10) -> None:
    notlar = json.loads((cikti / "kabul_notlari.json").read_text(encoding="utf-8"))
    sorular = yaml.safe_load((cikti / "kabul_smmm.yaml").read_text(encoding="utf-8")) or []
    tum = {k["kid"]: k for k in kaliplari_yukle()}
    sat = ["# Türev pilot — kabul edilen sorulardan örnekler (kalıp ↔ yeni soru)", "",
           "Kalıp metni telif/özgünlük nedeniyle yalnız kısa özet olarak verilmiştir.", ""]
    secilen, dersler = [], Counter()
    for s in sorular:  # ders çeşitliliği
        if dersler[s["ders"]] < 2:
            secilen.append(s)
            dersler[s["ders"]] += 1
    secilen += [s for s in sorular if s not in secilen]
    for s in secilen[:n]:
        nt = notlar[s["id"]]
        k = tum[nt["kid"]]
        sat += [f"## {s['id']}  ←  kalıp {nt['kid']} (resmî cevap {k['dogru']})", "",
                f"**Kalıp özeti:** {k.get('konu')} — {k.get('konu_aciklama')}. Kalıbın ölçtüğü kural (modelin tespiti): {nt['kalip_kurali']}",
                f"**Kalıp kökünün ilk 140 karakteri:** {(k.get('kok') or '')[:140]}…", "",
                f"**Yeni soru** (tip {s['tip']}, zorluk {s['zorluk']}):", "", s["kok"], ""]
        sat += [f"- {h}) {v}" for h, v in s["secenekler"].items()]
        sat += ["", f"**Doğru:** {s['dogru']} — {s['aciklama'].get('dogru_neden')}", "", "**Çeldiriciler:**"]
        sat += [f"- {h}: {v}" for h, v in (s["aciklama"].get("celdiriciler") or {}).items()]
        if s["aciklama"].get("hesap_adimlari"):
            sat += ["", "**Hesap:** " + " → ".join(map(str, s["aciklama"]["hesap_adimlari"]))]
        sat += ["", "**Kaynak:**"] + [f"- {x.get('mevzuat')} {x.get('madde')}: “{x.get('alinti', '')}”" for x in s["kaynaklar"]]
        sat += ["", f"**Ölçüm:** kalıp 5-gram Jaccard {nt['olcum']['jaccard5']}, kök benzerliği {nt['olcum']['kok_benzerlik']}, "
                f"banka benzerliği {nt['olcum']['banka_benzerlik']}; güncellik: {json.dumps(nt['guncellik'], ensure_ascii=False)}",
                f"**Hakem iyileştirme notları:** {'; '.join(map(str, nt['hakem_iyilestirme'])) or '-'}", "", "---", ""]
    (cikti / "ORNEKLER.md").write_text("\n".join(sat), encoding="utf-8")


def ana(argv: list[str]) -> int:
    def arg(ad, vars_):
        return argv[argv.index(ad) + 1] if ad in argv else vars_
    cikti = KOK / arg("--cikti", "content/uretim_modal/turev_pilot")
    if "--isle" in argv:
        isle(cikti)
        ornekler_md(cikti)
        return 0
    if "--ornekler" in argv:
        ornekler_md(cikti)
        return 0
    profiller = [p for p in arg("--profiller", "").split(",") if p]
    if profiller:  # tam üretim: kalıplar profillere bölünür, her profil kendi oturumunda sırayla çalışır
        import subprocess
        temel, atla_sonraki = [], False
        for a in argv[1:]:
            if atla_sonraki:
                atla_sonraki = False
                continue
            if a in ("--profiller", "--cikti", "--profil", "--parca"):
                atla_sonraki = True
                continue
            temel.append(a)
        kok_cikti = arg("--cikti", "content/uretim_modal/turev")
        for i, p in enumerate(profiller):
            env = dict(os.environ, MODAL_PROFILE=p, PYTHONIOENCODING="utf-8")
            komut = [sys.executable, "-m", "pipeline.modal.hat", "turev", *temel, "--parca", f"{i + 1}/{len(profiller)}",
                     "--cikti", f"{kok_cikti}/{p}"]
            print("→", p, " ".join(komut[3:]), flush=True)
            if subprocess.call(komut, env=env, cwd=str(KOK)) != 0:
                print(f"{p}: hata ya da kredi bitti; sonraki profile geçiliyor", flush=True)
        return 0
    if "--profil" in argv:
        os.environ["MODAL_PROFILE"] = arg("--profil", "")
    dagilim = PILOT_DAGILIM
    if "--dagilim" in argv:  # ör. VER=8,DEN=6
        dagilim = {a.split("=")[0]: int(a.split("=")[1]) for a in arg("--dagilim", "").split(",")}
    atla = set()
    if "--onceki" in argv:  # önceki çıktılarda kullanılan kalıpları atla
        for d in arg("--onceki", "").split(","):
            p = KOK / d / "gorevler.json"
            if p.exists():
                atla |= {g["kid"] for g in json.loads(p.read_text(encoding="utf-8"))}
    kaliplar = sec(kaliplari_yukle(), dagilim, atla)
    if "--parca" in argv:
        i, n = map(int, arg("--parca", "1/1").split("/"))
        kaliplar = kaliplar[i - 1::n]
    gorevler = [gorev_kur(k, i) for i, k in enumerate(kaliplar)]
    kip = "kuru" if "--kuru" in argv else "gpu"
    calistir(gorevler, cikti, int(arg("--aday", 1)), kip, float(arg("--butce", 4.0)))
    if kip == "gpu":
        ornekler_md(cikti)
    return 0
