"""Modal soru üretim hattı (Qwen3-235B): görev → kaynak → üretim → yerel kapılar → kör çözücü ×2 + hakem + ortalama aday → karar.

    python -m pipeline.modal.hat pilot [--smmm 30] [--ymm 15] [--aday 2] [--cikti content/uretim_modal/pilot]
    python -m pipeline.modal.hat pilot --kuru      # yalnız görev + istem hazırlar, GPU kullanmaz
    python -m pipeline.modal.hat pilot --sahte     # sahte modelle uçtan uca boru testi (GPU yok)
    python -m pipeline.modal.hat isle <cikti>      # kayıtlı ham çıktılardan kararları yeniden üretir (GPU yok)

ÇIKMIŞ SORUDAN ÖZGÜN SORU (türev hattı, Qwen3-235B-A22B-Thinking-2507; ayrıntı pipeline/modal/turev.py):
    python -m pipeline.modal.hat turev --profil er-merve0614 [--aday 1] [--butce 4] [--cikti content/uretim_modal/turev_pilot]
    python -m pipeline.modal.hat turev --kuru                         # yalnız kalıp seçimi + istemler (GPU yok)
    python -m pipeline.modal.hat turev --isle [--cikti ...]           # ham çıktıdan kararları yeniden üret (GPU yok)
    python -m pipeline.modal.hat turev --dagilim VER=40,DEN=30 --profiller er-merve0614,er-enes127,boru57489 \
           --onceki content/uretim_modal/turev_pilot --cikti content/uretim_modal/turev   # tam üretim, profiller sırayla

Ortam: MODAL_PROFILE (ör. er-merve0614 — Qwen ağırlıkları bu hesabın tarih-en-hf volume'ünde).
Bankaya YAZMAZ: kabul edilenler <cikti>/kabul_<sinav>.yaml, reddedilenler <cikti>/red.json, maliyet <cikti>/maliyet.json.
"""
from __future__ import annotations

import datetime as dt
import json
import random
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap, g7_ozgunluk, harita, klasik, on_eleme, uretici_paketi, ymm_gorev
from pipeline.modal import getir, istemler

KOK = g2_yapi.KOK
MODEL_ADI = "Qwen3-235B-A22B-Instruct-2507-FP8 (Modal iç hat)"
FIYAT = {"B200": 6.25, "H200": 4.54, "H100": 3.95, "A100": 2.50}  # $/saat/GPU (Modal liste fiyatı)
BUTCE_USD = 4.0
# Resmî metni olmayan / yöntem ağırlıklı dersler: alıntı zorunlu değil (varsa birebir olmalı).
YONTEM = {("smmm", d) for d in ("TAB", "MAL", "EKO", "GKY")} | {("ymm", d) for d in ("FYN", "YNM")}
AKTIF = {"kontrolde", "onayli", "yayinda"}

# ---------------------------------------------------------------- banka (tek sefer yüklenir)
_YUKLU: dict = {}
_asil_yukle = g2_yapi.dosyalari_yukle


def _onbellekli_yukle(klasor, okunamayan=None):
    k = str(Path(klasor).resolve())
    if k not in _YUKLU:
        _YUKLU[k] = _asil_yukle(Path(klasor), [] if okunamayan is None else okunamayan)
    return _YUKLU[k]


g2_yapi.dosyalari_yukle = _onbellekli_yukle  # harita / ymm_gorev / uretici_paketi aynı önbelleği kullanır


def banka(sinav: str) -> list[dict]:
    return [s for _, s in _onbellekli_yukle(KOK / f"content/sorular/{sinav}", []) if isinstance(s, dict)]


# ---------------------------------------------------------------- görevler
SMMM_PILOT = {"TAB": 4, "SPK": 4, "MAL": 3, "FIN": 3, "MES": 3, "STD": 3, "EKO": 2, "MLY": 2, "VER": 2, "HUK": 2, "DEN": 2}
YMM_PILOT = {"IFM": 2, "FYN": 2, "YNM": 1, "DRM": 1, "REV": 2, "VTK": 2, "GUV": 2, "HSV": 1, "DTK": 1, "SPM": 1}
SMMM_BICIM = {"olay/senaryo": "standart (olay/senaryo)", "öncüllü (I, II, III)": "oncullu",
              "olumsuz kök (**yanlıştır**)": "olumsuz", "kavram ayrımı / karşılaştırma": "standart (kavram ayrımı)",
              "hesaplama / sayısal": "standart (hesaplama / sayısal)", "eşleştirme veya sıralama": "standart (eşleştirme/sıralama)"}


def _mufredat(sinav: str) -> dict:
    return {d["kod"]: d for d in yaml.safe_load((KOK / f"content/mufredat/{sinav}.yaml").read_text(encoding="utf-8"))["dersler"]}


def smmm_gorevleri(dagilim: dict) -> list[dict]:
    harita.sinav_sec("smmm") if harita.SINAV != "smmm" else None
    muf = _mufredat("smmm")
    out = []
    for ders, n in dagilim.items():
        for p in harita.sonraki(n, ders):
            out.append({"sinav": "smmm", "ders": ders, "ders_ad": muf[ders]["ad"], "konu": p["konu"], "konu_ad": p["konu_ad"],
                        "kazanim": p["kazanim"], "zorluk": p["zorluk"], "bicim": SMMM_BICIM.get(p["bicim"], p["bicim"]),
                        "bolum": p["bolum"], "onekler": uretici_paketi.DERS_KAYNAK.get(ders, [])})
    return out


def ymm_gorevleri(dagilim: dict) -> list[dict]:
    muf = _mufredat("ymm")
    plan = ymm_gorev.plan_kur(pay=1.0)
    satirlar = defaultdict(list)
    for g in plan["gorevler"].values():
        satirlar[g["ders"]] += g["satirlar"]
    out = []
    for ders, n in dagilim.items():
        s = satirlar.get(ders, [])
        if not s:
            continue
        adim = max(1, len(s) // n)
        for r in s[::adim][:n]:  # konu ve zorluk karışsın diye aralıklı seçim
            out.append({"sinav": "ymm", "ders": ders, "ders_ad": muf[ders]["ad"], "konu": r["konu"], "konu_ad": r["konu_ad"],
                        "kazanim": r["kazanim"], "zorluk": r["zorluk"], "bicim": r["bicim"], "bolum": ["YMM"],
                        "onekler": list(muf[ders].get("kaynak_dosyalari") or [])})
    return out


# ---------------------------------------------------------------- hazırlık
def ornekler(g: dict, n: int = 2, sinir: int = 2600) -> list[dict]:
    aday = [s for s in banka(g["sinav"]) if s.get("ders") == g["ders"] and s.get("konu") == g["konu"]
            and s.get("durum") in AKTIF and "iç hat" not in str(s.get("uretim", {}).get("model", ""))
            and not s.get("ortak_veri")]
    aday.sort(key=lambda s: (s.get("zorluk") != g["zorluk"], str(s.get("id"))))
    secilen = []
    for s in aday:
        o = {k: s[k] for k in uretici_paketi.YAZAR_ALANLARI if k in s and k not in ("bolum", "ders", "konu")}
        if len(json.dumps(o, ensure_ascii=False)) <= sinir and all(x.get("zorluk") != o.get("zorluk") or len(aday) < 4
                                                                   for x in secilen):
            secilen.append(o)
        if len(secilen) >= n:
            break
    return secilen


def banka_kokleri(g: dict, n: int = 12) -> list[str]:
    kaz = str(g["kazanim"]).strip().lower()
    ayni = [s for s in banka(g["sinav"]) if s.get("ders") == g["ders"] and s.get("konu") == g["konu"]
            and s.get("durum") != "geri_cekildi"]
    ayni.sort(key=lambda s: str(s.get("kazanim", "")).strip().lower() != kaz)
    return [" ".join(str(s["kok"]).split())[:170] for s in ayni[:n]]


# Yöntem dersleri: parça verilmez (oran analizi, iktisat, finansal yönetim) ya da az parça (THP hesap işleyişi için).
PARCASIZ = {("smmm", "TAB"), ("smmm", "EKO"), ("smmm", "GKY"), ("ymm", "FYN")}
AZ_PARCA = {("smmm", "MAL"), ("ymm", "YNM")}


def parca_getir(g: dict) -> list[dict]:
    if not g["onekler"] or (g["sinav"], g["ders"]) in PARCASIZ:
        return []
    sorgu = f"{g['kazanim']} {g['kazanim']} {g['konu_ad']}"
    return getir.getir(g["onekler"], sorgu, butce=7000 if (g["sinav"], g["ders"]) in AZ_PARCA else 20000)


def hazirla(gorevler: list[dict]) -> None:
    for i, g in enumerate(gorevler):
        g["tid"] = f"T{i + 1:03d}"
        g["parcalar"] = parca_getir(g)
        g["hedef_harf"] = istemler.HARFLER[i % 5]


def uretim_istekleri(gorevler: list[dict], aday: int) -> list[dict]:
    ist = []
    for g in gorevler:
        u = istemler.uretim_kullanici(g, g["parcalar"], ornekler(g), banka_kokleri(g), g["hedef_harf"])
        for k in range(aday):
            ist.append({"anahtar": f"{g['tid']}-{k}", "system": istemler.uretim_sistem(g["sinav"]), "user": u,
                        "max_tokens": 4096, "temperature": (0.6, 0.85, 0.75)[k % 3], "seed": 1000 + k})
    return ist


# ---------------------------------------------------------------- yerel kapılar
_SAYAC: dict = {}


def _sonraki_id(sinav: str, ders: str, konu: str) -> str:
    if not _SAYAC:
        for sn in ("smmm", "ymm"):
            for s in banka(sn):
                m = re.search(r"(\d+)$", str(s.get("id", "")))
                k = (sn, s.get("ders"), s.get("konu"))
                _SAYAC[k] = max(_SAYAC.get(k, 0), int(m.group(1)) if m else 0)
    k = (sinav, ders, konu)
    _SAYAC[k] = _SAYAC.get(k, 0) + 1
    return f"{sinav.upper()}-{ders}-{konu}-{_SAYAC[k]:04d}"


def _madde_no(t: str) -> str | None:
    m = re.search(r"(\d+)", str(t or ""))
    return m.group(1) if m else None


def _parca_bul(alinti: str, parcalar: list[dict]) -> dict | None:
    n = uretici_paketi._norm(alinti)
    if len(n) < 15:
        return None
    for p in parcalar:
        if n in uretici_paketi._norm(p["metin"]):
            return p
    return None


_BANKA_PARCA: dict = {}


def _banka_parcalari(sinav: str, ders: str, konu: str) -> set:
    k = (sinav, ders, konu)
    if k not in _BANKA_PARCA:
        p = set()
        for s in banka(sinav):
            if s.get("ders") == ders and s.get("konu") == konu and s.get("durum") != "geri_cekildi":
                p |= g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s))
        _BANKA_PARCA[k] = p
    return _BANKA_PARCA[k]


def kayit_kur(j: dict, g: dict) -> dict:
    kaynaklar = []
    for k in j.get("kaynaklar") or []:
        if isinstance(k, dict):
            kaynaklar.append({a: str(k[a]) for a in ("mevzuat", "madde", "alinti") if k.get(a) not in (None, "")})
    gec = j.get("gecerlilik") if isinstance(j.get("gecerlilik"), dict) else {}
    gec = {a: gec[a] for a in ("baslangic", "bitis", "yila_bagli_tutar", "yil") if a in gec}
    gec.setdefault("baslangic", "2026-01-01")
    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", str(gec["baslangic"])):
        gec["baslangic"] = "2026-01-01"
    aciklama = j.get("aciklama") if isinstance(j.get("aciklama"), dict) else {}
    aciklama = {a: aciklama[a] for a in ("dogru_neden", "celdiriciler", "hesap_adimlari") if a in aciklama}
    if j.get("tip") != "hesaplama":
        aciklama.pop("hesap_adimlari", None)
    s = {"id": f"{g['sinav'].upper()}-{g['ders']}-{g['konu']}-0000", "sinav": g["sinav"], "bolum": g["bolum"], "ders": g["ders"], "unite": g["konu_ad"], "konu": g["konu"],
         "kazanim": g["kazanim"], "tip": j.get("tip"), "zorluk": j.get("zorluk", g["zorluk"])}
    if j.get("soru_bicimi") in ("standart", "olumsuz", "oncullu", "bosluk", "yevmiye"):
        s["soru_bicimi"] = j["soru_bicimi"]
    s.update({"kok": j.get("kok"), "secenekler": j.get("secenekler"), "dogru": j.get("dogru"), "aciklama": aciklama,
              "kaynaklar": kaynaklar, "gecerlilik": gec})
    if j.get("tip") == "hesaplama" and isinstance(j.get("dogrulama"), dict) and j["dogrulama"].get("python"):
        s["dogrulama"] = {a: j["dogrulama"][a] for a in ("python", "secenek_sayisi_bekleniyor") if a in j["dogrulama"]}
    s.update({"durum": "taslak", "surum": 1, "uretim": {"kaynak_turu": "yapay_zeka", "model": MODEL_ADI,
                                                         "istem_surumu": istemler.SURUM}})
    return s


def yerel_denetim(s: dict, g: dict, j: dict, kabul_parcalari: list[set]) -> list[str]:
    """Model kullanmayan kapılar: G2 (şema/yapı), G4 (hesap), şık yapısı [K10/K11], alıntı birebir, atıf, G7."""
    h = []
    if s.get("zorluk") != g["zorluk"]:
        h.append(f"gorev: zorluk {s.get('zorluk')} ≠ görev {g['zorluk']}")
    h += [f"G2: {x}" for x in g2_yapi.soru_denetle(s).hatalar]
    if h:
        return h
    h += [f"G2: {x}" for x in g2_yapi.soru_denetle(s).uyarilar]
    if s.get("dogrulama") and on_eleme.YASAK_KOD.search(s["dogrulama"]["python"]):
        h.append("G4: doğrulama kodunda yasak yapı")
    else:
        h += [f"G4: {x}" for x in g4_hesap.soru_denetle(s).hatalar]
    h += [f"SIK: {x}" for x in on_eleme.sik_sorunlari(s)]
    h += [f"ALINTI: metinde yok → {x}" for x in uretici_paketi.alinti_sorunlari(s["kaynaklar"])]
    alintili = 0
    tum = list(getir.dizin(g["onekler"]).parcalar) if g["onekler"] else []
    for k, ham in zip(s["kaynaklar"], [x for x in (j.get("kaynaklar") or []) if isinstance(x, dict)]):
        if not k.get("alinti"):
            continue
        p = _parca_bul(k["alinti"], g["parcalar"]) or _parca_bul(k["alinti"], tum)
        if p is None:
            continue
        alintili += 1
        if p.get("madde") and _madde_no(k.get("madde")) and _madde_no(k["madde"]) != _madde_no(p["madde"]):
            h.append(f"ATIF: '{k['madde']}' yazılmış, alıntı {p['dosya']} {p['baslik']} içinde")
    if (g["sinav"], g["ders"]) not in YONTEM and g["onekler"] and not alintili:
        h.append("ALINTI: mevzuat dersinde birebir doğrulanan alıntı yok")
    parca = g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s))
    oran = g7_ozgunluk.kapsanma(parca, _banka_parcalari(g["sinav"], g["ders"], g["konu"]))
    if oran > g7_ozgunluk.ESIK_BANKA:
        h.append(f"G7: bankadaki sorulara benzerlik %{oran * 100:.0f}")
    for p2 in kabul_parcalari:
        if g7_ozgunluk.kapsanma(parca, p2) > g7_ozgunluk.ESIK_BANKA:
            h.append("G7: bu partideki başka bir soruya çok benziyor")
            break
    return h


# ---------------------------------------------------------------- doğrulama istekleri
def dogrulama_istekleri(aday_listesi: list[dict], gorev: dict) -> list[dict]:
    ist = []
    for a in aday_listesi:
        g, s = gorev[a["tid"]], a["soru"]
        sn = g["sinav"].upper()
        ist.append({"anahtar": f"{a['anahtar']}|c1", "system": istemler.COZUCU_SISTEM.format(sinav=sn),
                    "user": istemler.cozucu_kullanici(s["kok"], s["secenekler"], g["parcalar"]), "max_tokens": 2500,
                    "temperature": 0.0})
        kar, _ = istemler.karistir(s["secenekler"], 2)
        ist.append({"anahtar": f"{a['anahtar']}|c2", "system": istemler.COZUCU_SISTEM.format(sinav=sn),
                    "user": istemler.cozucu_kullanici(s["kok"], kar, g["parcalar"]), "max_tokens": 2500,
                    "temperature": 0.0})
        ist.append({"anahtar": f"{a['anahtar']}|hk", "system": istemler.hakem_sistem(g["sinav"]),
                    "user": istemler.hakem_kullanici(s, g["parcalar"]), "max_tokens": 2500, "temperature": 0.0})
        ist.append({"anahtar": f"{a['anahtar']}|oa", "system": istemler.ADAY_SISTEM.format(sinav=sn),
                    "user": istemler.cozucu_kullanici(s["kok"], s["secenekler"], []), "max_tokens": 500,
                    "temperature": 0.0})
    return ist


def karar(a: dict, cikti: dict) -> tuple[bool, list[str], dict]:
    s = a["soru"]
    c1 = istemler.json_coz(cikti.get("c1", "")) or {}
    c2 = istemler.json_coz(cikti.get("c2", "")) or {}
    hk = istemler.json_coz(cikti.get("hk", "")) or {}
    oa = istemler.json_coz(cikti.get("oa", "")) or {}
    _, esle = istemler.karistir(s["secenekler"], 2)
    c2_cevap = esle.get(str(c2.get("cevap", "")).strip().upper()[:1], str(c2.get("cevap")))
    neden = []

    def guven(x):
        try:
            return int(x.get("guven", 0))
        except (TypeError, ValueError):
            return 0
    for ad, cv, c in (("G3a", str(c1.get("cevap", "")).strip().upper()[:1], c1), ("G3b", c2_cevap, c2)):
        if not c:
            neden.append(f"{ad}: çözücü çıktısı okunamadı")
        elif cv != s["dogru"]:
            neden.append(f"{ad}: kör çözücü {c.get('cevap')} buldu (anahtar {s['dogru']}) — {str(c.get('cozum', ''))[:300]}")
        elif guven(c) < 4:
            neden.append(f"{ad}: kör çözücü doğru ama güven {guven(c)}")
    if not hk:
        neden.append("G5: hakem çıktısı okunamadı")
    else:
        hatalar = [x.get("ne", str(x)) for x in hk.get("sorunlar") or [] if isinstance(x, dict) and str(x.get("tur", "")).upper().startswith("HATA")]
        bayrak = [k for k in ("anahtar_dogru_mu", "tek_dogru_mu", "kok_acik_mi", "aciklama_dogru_mu", "alinti_birebir_mi",
                              "atif_dogru_mu") if hk.get(k) is False]
        if hk.get("gecerli") is not True or hatalar or bayrak:
            neden.append(f"G5: hakem reddetti [{', '.join(bayrak)}] " + " | ".join(hatalar)[:700])
    ek = {"c1": c1, "c2": c2, "hakem": hk, "ortalama_aday": oa}
    return not neden, neden, ek


# ---------------------------------------------------------------- çalıştırıcılar
class SahteUsta:
    """GPU'suz boru testi: üretimde örnek soruyu biraz değiştirip döndürür, çözücülerde anahtarı bilir."""

    def __init__(self):
        self.anahtar: dict = {}
        self.gpu = "sahte"

    def uret(self, istekler_: list) -> dict:
        m = []
        for i in istekler_:
            if "|" not in i["anahtar"]:
                ornek = re.search(r"## Kabul edilmiş örnek sorular.*?\n(\{.*?\})\n", i["user"], re.S)
                j = json.loads(ornek.group(1)) if ornek else {"atla": True, "neden": "örnek yok"}
                if "kok" in j:
                    j["kok"] = "SAHTE " + "".join(random.sample("abcdefghijklmnopqrstuvwxyz", 20)) + " " + j["kok"][:40]
                    j["zorluk"] = int(re.search(r"- Zorluk: (\d)", i["user"]).group(1))
                m.append(json.dumps(j, ensure_ascii=False))
            else:
                anahtar, tur = i["anahtar"].split("|")
                d = self.anahtar.get(anahtar, "A")
                if tur == "c2":
                    d = {v: k for k, v in istemler.karistir({h: h for h in "ABCDE"}, 2)[1].items()}[d]
                if tur == "hk":
                    m.append(json.dumps({"gecerli": True, "sorunlar": [], "zorluk_uygun_mu": True}))
                else:
                    m.append(json.dumps({"cozum": "sahte", "cevap": d, "guven": 5}))
        return {"metinler": m, "sure_sn": 0.1, "girdi_tok": 0, "cikti_tok": 0, "bitis": ["stop"] * len(m)}


def _yaz_json(yol: Path, veri) -> None:
    yol.parent.mkdir(parents=True, exist_ok=True)
    yol.write_text(json.dumps(veri, ensure_ascii=False, indent=1), encoding="utf-8")


def calistir(gorevler: list[dict], cikti: Path, aday: int, kip: str) -> None:
    cikti.mkdir(parents=True, exist_ok=True)
    log = open(cikti / "log.txt", "a", encoding="utf-8")

    def yaz(*a):
        satir = f"[{dt.datetime.now():%H:%M:%S}] " + " ".join(str(x) for x in a)
        print(satir, flush=True)
        log.write(satir + "\n")
        log.flush()

    hazirla(gorevler)
    gorev = {g["tid"]: g for g in gorevler}
    _yaz_json(cikti / "gorevler.json", [{k: v for k, v in g.items() if k != "parcalar"} | {
        "parcalar": [f"{p['dosya']} · {p['baslik']} ({p['puan']})" for p in g["parcalar"]]} for g in gorevler])
    ist1 = uretim_istekleri(gorevler, aday)
    tahmin = sum(len(i["system"]) + len(i["user"]) for i in ist1) / 3.0
    yaz(f"görev {len(gorevler)}, üretim isteği {len(ist1)}, tahmini girdi ≈ {tahmin / 1000:.0f}k token")
    if kip == "kuru":
        _yaz_json(cikti / "istem_ornegi.json", ist1[:2])
        yaz("kuru çalıştırma: istemler yazıldı, GPU kullanılmadı")
        return

    ham = {"gorevler": list(gorev), "asama1": {}, "asama2": {}, "maliyet": {}}
    t0 = time.time()
    if kip == "sahte":
        usta, baglam = SahteUsta(), None
    else:
        import modal
        sys.path.insert(0, str(Path(__file__).parent))
        import modal_app  # noqa: E402
        cikis = modal.enable_output()
        cikis.__enter__()
        baglam = modal_app.app.run()
        baglam.__enter__()
        usta = modal_app.Usta()
    try:
        bilgi = usta.bilgi.remote() if kip != "sahte" else {"gpu": "sahte", "yukleme_sn": 0}
        t_hazir = time.time()
        yaz(f"model hazır: {bilgi} (bekleme+yükleme {t_hazir - t0:.0f} sn)")
        r1 = usta.uret.remote(ist1) if kip != "sahte" else usta.uret(ist1)
        yaz(f"aşama 1: {len(ist1)} istek, {r1['sure_sn']:.0f} sn, girdi {r1['girdi_tok']} / çıktı {r1['cikti_tok']} token, "
            f"bitiş {Counter(r1['bitis'])}")
        ham["asama1"] = {i["anahtar"]: m for i, m in zip(ist1, r1["metinler"])}
        _yaz_json(cikti / "ham.json", ham)

        adaylar, red = adaylari_isle(ham["asama1"], gorev)
        yaz(f"yerel kapılar: {len(adaylar)} aday geçti, {len(red)} elendi")
        if kip == "sahte":
            usta.anahtar = {a["anahtar"]: a["soru"]["dogru"] for a in adaylar}
        ist2 = dogrulama_istekleri(adaylar, gorev)
        gecen_usd = (time.time() - t0) / 3600 * 2 * max(FIYAT.get(k, 0) for k in FIYAT if k in str(bilgi.get("gpu", "B200")) or k == "B200")
        if kip != "sahte" and gecen_usd > 0.8 * BUTCE_USD:
            yaz(f"BÜTÇE: şimdiye kadar ≈{gecen_usd:.2f} $; doğrulama aşaması atlandı (ham çıktılar kayıtlı)")
            ist2 = []
        if ist2:
            r2 = usta.uret.remote(ist2) if kip != "sahte" else usta.uret(ist2)
            yaz(f"aşama 2: {len(ist2)} istek, {r2['sure_sn']:.0f} sn, girdi {r2['girdi_tok']} / çıktı {r2['cikti_tok']} token")
            ham["asama2"] = {i["anahtar"]: m for i, m in zip(ist2, r2["metinler"])}
    finally:
        t1 = time.time()
        if baglam is not None:
            baglam.__exit__(None, None, None)
        gpu = str(bilgi.get("gpu", "")) if "bilgi" in dir() else ""
        n_gpu = int(re.match(r"(\d+)", gpu).group(1)) if re.match(r"(\d+)", gpu) else 2
        tur = next((k for k in FIYAT if k in gpu), "B200")
        sure = t1 - t0
        ham["maliyet"] = {"gpu": gpu, "toplam_sn": round(sure), "yukleme_sn": bilgi.get("yukleme_sn") if "bilgi" in dir() else None,
                          "tahmini_usd": round(sure / 3600 * FIYAT[tur] * n_gpu, 2) if kip != "sahte" else 0,
                          "fiyat_saat_gpu": FIYAT[tur]}
        _yaz_json(cikti / "ham.json", ham)
        yaz(f"oturum kapandı: {sure:.0f} sn, tahmini {ham['maliyet']['tahmini_usd']} $ ({gpu})")
    isle(cikti, gorevler)


def adaylari_isle(asama1: dict, gorev: dict) -> tuple[list[dict], list[dict]]:
    global _SAYAC
    _SAYAC = {}
    adaylar, red = [], []
    for anahtar, metin in asama1.items():
        g = gorev[anahtar.split("-")[0]]
        j = istemler.json_coz(metin)
        if j is None:
            red.append({"anahtar": anahtar, "asama": "uretim", "neden": ["JSON okunamadı"], "ham": metin[:1500]})
            continue
        if j.get("atla"):
            red.append({"anahtar": anahtar, "asama": "uretim", "neden": [f"model atladı: {j.get('neden')}"]})
            continue
        s = kayit_kur(j, g)
        sorun = yerel_denetim(s, g, j, [])
        if sorun:
            red.append({"anahtar": anahtar, "asama": "yerel", "neden": sorun, "soru": s})
            continue
        adaylar.append({"anahtar": anahtar, "tid": g["tid"], "soru": s, "ham_json": j})
    return adaylar, red


def isle(cikti: Path, gorevler: list[dict] | None = None) -> None:
    ham = json.loads((cikti / "ham.json").read_text(encoding="utf-8"))
    if gorevler is None:
        gorevler = json.loads((cikti / "gorevler.json").read_text(encoding="utf-8"))
        for g in gorevler:
            g["parcalar"] = parca_getir(g)
    gorev = {g["tid"]: g for g in gorevler}
    adaylar, red = adaylari_isle(ham["asama1"], gorev)
    kabul, kabul_parca, gorev_kabul = [], [], set()
    bugun = dt.date.today().isoformat()
    for a in adaylar:
        c = {t: ham["asama2"].get(f"{a['anahtar']}|{t}", "") for t in ("c1", "c2", "hk", "oa")}
        if not any(c.values()):
            red.append({"anahtar": a["anahtar"], "asama": "dogrulama", "neden": ["doğrulama yapılmadı"], "soru": a["soru"]})
            continue
        ok, neden, ek = karar(a, c)
        s = a["soru"]
        parca = g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(s))
        if ok and a["tid"] in gorev_kabul:
            ok, neden = False, ["fazla aday: bu görev için başka bir aday zaten kabul edildi"]
        if ok and any(g7_ozgunluk.kapsanma(parca, p) > g7_ozgunluk.ESIK_BANKA for p in kabul_parca):
            ok, neden = False, ["G7: bu partide kabul edilen bir soruya çok benziyor"]
        if not ok:
            red.append({"anahtar": a["anahtar"], "asama": "dogrulama", "neden": neden, "soru": s, "denetim": ek})
            continue
        g = gorev[a["tid"]]
        oa = ek["ortalama_aday"]
        notlar = []
        if s["zorluk"] == 3 and str(oa.get("cevap", ""))[:1] == s["dogru"] and int(oa.get("guven", 0) or 0) >= 4:
            notlar.append("GZ: ortalama aday kaynaksız ve yüksek güvenle doğru buldu; zorluk 3 → 2")
            s["zorluk"] = 2
        elif s["zorluk"] == 1 and str(oa.get("cevap", ""))[:1] != s["dogru"]:
            notlar.append("GZ DİKKAT: zorluk 1 ama ortalama aday yanıldı")
        s["id"] = _sonraki_id(s["sinav"], s["ders"], s["konu"])
        s["uretim"]["kapilar"] = {
            "G2": {"sonuc": "gecti", "tarih": bugun},
            "G4": {"sonuc": "gecti", "tarih": bugun} if s.get("dogrulama") else {"sonuc": "atlandi", "not": "hesaplama sorusu değil"},
            "G7": {"sonuc": "gecti", "not": "banka içi (aynı konu) + parti içi", "tarih": bugun},
            "G3": {"sonuc": "gecti", "not": f"iç hat: 2 kör çözücü (şık sırası farklı) güven {ek['c1'].get('guven')}/{ek['c2'].get('guven')}", "tarih": bugun},
            "G5": {"sonuc": "gecti", "not": "iç hat hakem (aynı model, bağımsız istem)", "tarih": bugun},
            "G6": {"sonuc": "gecti", "not": "alıntı yerelde birebir arandı; atıf parça başlığıyla eşleşti", "tarih": bugun},
            "GZ": {"sonuc": "gecti", "not": "; ".join(notlar) or f"ortalama aday {oa.get('cevap')}/{oa.get('guven')}", "tarih": bugun}}
        s["gecmis"] = [{"tarih": bugun, "kim": "modal-hat", "ne": f"pilot üretim {a['anahtar']}",
                        "neden": "; ".join(notlar) or "tüm iç kapılar geçti"}]
        iyi = [x.get("ne") for x in ek["hakem"].get("sorunlar") or [] if isinstance(x, dict)]
        kabul.append({"soru": s, "hakem_iyilestirme": iyi})
        kabul_parca.append(parca)
        gorev_kabul.add(a["tid"])
    for sn in ("smmm", "ymm"):
        liste = [k["soru"] for k in kabul if k["soru"]["sinav"] == sn]
        (cikti / f"kabul_{sn}.yaml").write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=110),
                                                encoding="utf-8")
    _yaz_json(cikti / "red.json", red)
    _yaz_json(cikti / "kabul_notlari.json", {k["soru"]["id"]: k["hakem_iyilestirme"] for k in kabul})
    ozet(cikti, gorevler, kabul, red, ham)


def _neden_turu(n: str) -> str:
    for on, ad in (("JSON", "json_bozuk"), ("model atladı", "model_atladi"), ("gorev:", "gorev_uyumsuz"), ("G2:", "G2_yapi"),
                   ("G4:", "G4_hesap"), ("SIK:", "sik_yapisi"), ("ALINTI:", "alinti"), ("ATIF:", "atif"), ("G7:", "G7_benzerlik"),
                   ("G3", "kor_cozucu"), ("G5:", "hakem"), ("fazla aday", "fazla_aday"), ("doğrulama yapılmadı", "dogrulanmadi")):
        if n.startswith(on):
            return ad
    return "diger"


def ozet(cikti: Path, gorevler: list[dict], kabul: list[dict], red: list[dict], ham: dict) -> None:
    aday_say = len(ham["asama1"])
    tur = Counter()
    for r in red:
        if any(n.startswith("fazla aday") for n in r["neden"]):
            continue
        for t in {_neden_turu(n) for n in r["neden"]}:
            tur[t] += 1
    gorev_kabul = Counter(k["soru"]["sinav"] for k in kabul)
    gorev_say = Counter(g["sinav"] for g in gorevler)
    m = ham.get("maliyet", {})
    usd = m.get("tahmini_usd") or 0
    o = {"gorev": dict(gorev_say), "uretilen_aday": aday_say, "kabul": dict(gorev_kabul), "kabul_toplam": len(kabul),
         "gorev_basina_kabul_orani": round(len(kabul) / max(1, len(gorevler)), 3),
         "aday_basina_kabul_orani": round(len(kabul) / max(1, aday_say), 3),
         "red_nedenleri (aday sayısı; bir aday birden çok nedenle)": dict(tur.most_common()),
         "maliyet": m, "kabul_basina_usd": round(usd / max(1, len(kabul)), 3),
         "kabul_basina_sn": round((m.get("toplam_sn") or 0) / max(1, len(kabul)), 1)}
    _yaz_json(cikti / "maliyet.json", o)
    print(json.dumps(o, ensure_ascii=False, indent=1))


def main(argv: list[str]) -> int:
    def arg(ad, vars_):
        return argv[argv.index(ad) + 1] if ad in argv else vars_
    if len(argv) >= 2 and argv[1] == "pilot":
        cikti = KOK / arg("--cikti", "content/uretim_modal/pilot")
        ns, ny = int(arg("--smmm", 30)), int(arg("--ymm", 15))
        kip = "kuru" if "--kuru" in argv else "sahte" if "--sahte" in argv else "gpu"
        sm = smmm_gorevleri(SMMM_PILOT) if ns else []
        ym = ymm_gorevleri(YMM_PILOT) if ny else []
        calistir(sm[:ns] + ym[:ny], cikti, int(arg("--aday", 2)), kip)
        return 0
    if len(argv) >= 2 and argv[1] == "turev":
        from pipeline.modal import turev
        return turev.ana(argv[1:])
    if len(argv) >= 3 and argv[1] == "isle":
        isle(KOK / argv[2])
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
