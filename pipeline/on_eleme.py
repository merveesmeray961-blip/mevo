"""Dış üretici teslimleri için ön eleme (model kullanmaz, token harcamaz).

Teslimdeki her soruyu görev planına (`content/gorevler/ymm_*.json`) ve `docs/uretici/YMM_MANIFESTO.md` kurallarına
göre denetler. Ret sebepleri manifestodaki kural kodlarıyla ([K01] …) raporlanır. Geçenler `--al` ile bankaya
`taslak` olarak alınır; sonra yalnız bunlar hakeme gider.

    python -m pipeline.on_eleme teslim.yaml                # yalnız rapor (teslim.rapor.md)
    python -m pipeline.on_eleme teslim.yaml --al 3         # geçenleri <KONU>.p3.yaml ve klasik/ olarak alır
    python -m pipeline.on_eleme teslim_klasoru/ [--al 3]   # klasördeki bütün teslimler, tek özet rapor

Teslim biçim kusurları otomatik düzeltilir: boş `gorev` dosya adından okunur; birden çok görevi tek dosyada veren
teslim (`gorev_satiri: "G03-7"` ya da `"YMM-YNM-G03:7"`) görevlere bölünür. Planda olmayan (eski tur) görevler atlanır.
"""
from __future__ import annotations

import re
import sys
import tempfile
from collections import Counter
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap, g7_ozgunluk, harita, klasik, uretici_paketi, ymm_gorev

KOK = g2_yapi.KOK
OLUMSUZ_SIK = re.compile(r"(değil|yoktur|olamaz|girmez|aranmaz|edilemez|yapılamaz|bulunmaz|gerekmez|uygulanmaz"
                         r"|sayılmaz|alınmaz|verilemez|doğmaz|yararlanamaz|kullanılamaz)", re.I)
YASAK_SIK = re.compile(r"^\s*(hepsi|hiçbiri|yukarıdakilerin (hepsi|tümü|hiçbiri)|bilinmez|hiçbir şey)\b", re.I)
YASAK_KOD = re.compile(r"\bimport\b|\bint\s*\(|\bfloat\s*\(|\bdef\b|\blambda\b|\bopen\s*\(|__|"
                       r"\[[^\]\n]*\bfor\b[^\]\n]*\bin\b|\([^)\n]*\bfor\b[^)\n]*\bin\b")
UZUNLUK_ORANI = 1.30


def _norm(t: str) -> str:
    return " ".join(str(t).replace("İ", "i").replace("I", "ı").lower().split())


def sik_sorunlari(s: dict) -> list[str]:
    """[K10][K11]: şık yapısı cevabı ele veriyor mu, yasak şık var mı."""
    h = []
    sec, dogru = s.get("secenekler") or {}, s.get("dogru")
    if dogru not in sec:
        return h
    for harf, metin in sec.items():
        if YASAK_SIK.search(str(metin)):
            h.append(f"[K11] yasak şık {harf}: {str(metin)[:40]!r}")
    uz = {k: len(str(v)) for k, v in sec.items()}
    digerleri = [v for k, v in uz.items() if k != dogru]
    if digerleri and uz[dogru] > UZUNLUK_ORANI * max(digerleri) and uz[dogru] > 25:
        h.append(f"[K10] doğru şık belirgin en uzun ({uz[dogru]} / {max(digerleri)} karakter)")
    if digerleri and min(digerleri) > 25 and uz[dogru] < 0.6 * sorted(digerleri)[len(digerleri) // 2]:
        h.append("[K10] doğru şık diğerlerinden belirgin kısa")
    olumsuz = {k for k, v in sec.items() if OLUMSUZ_SIK.search(str(v))}
    if len(sec) == 5 and ((olumsuz == {dogru}) or (len(olumsuz) == 4 and dogru not in olumsuz)):
        h.append("[K10] doğru şık tek olumlu/olumsuz şık; şık yapısı cevabı ele veriyor")
    dn = _norm(sec[dogru])
    if len(dn) >= 20 and dn in _norm(s.get("kok", "")):
        h.append("[K10] doğru şık metni kökte geçiyor")
    if len({_norm(v) for v in sec.values()}) < len(sec):
        h.append("[K11] aynı metne sahip iki şık var")
    return h


def _plan_satiri(plan: dict, gorev: str, n) -> dict | None:
    g = plan["gorevler"].get(gorev)
    if not g:
        return None
    liste = g["klasik"] if str(n).startswith("K") else g["satirlar"]
    return next((r for r in liste if str(r["n"]) == str(n)), None)


def _test_denetle(s: dict, plan: dict, gorev: str, banka: dict) -> list[str]:
    h = []
    eksik = [a for a in uretici_paketi.YAZAR_ALANLARI if a not in s and a != "dogrulama"]
    if eksik:
        return [f"[K17] eksik alan: {', '.join(eksik)}"]
    r = _plan_satiri(plan, gorev, s.get("gorev_satiri"))
    if r is None:
        h.append(f"[K01] görevde olmayan satır: {s.get('gorev_satiri')}")
    else:
        for alan, beklenen in (("ders", r["ders"]), ("konu", r["konu"]), ("zorluk", r["zorluk"]),
                               ("soru_bicimi", r["bicim"])):
            if str(s.get(alan)) != str(beklenen):
                h.append(f"[K01] {alan} {s.get(alan)!r} ≠ görev {beklenen!r}")
        if _norm(s.get("kazanim", "")) != _norm(r["kazanim"]):
            h.append(f"[K01] kazanım görevdekiyle aynı değil ({str(s.get('kazanim'))[:40]!r})")
    if s.get("bolum") != ["YMM"]:
        h.append("[K17] bolum: [YMM] olmalı")
    kod = (s.get("dogrulama") or {}).get("python", "")
    if kod and YASAK_KOD.search(kod):
        h.append("[K20] doğrulama kodunda yasak yapı (import, int(), float(), liste/üreteç ifadesi, def, lambda)")
    tam = {"id": "YMM-XXX-ON-0000", "sinav": "ymm", "unite": "-", "durum": "taslak", "surum": 1,
           "uretim": {"kaynak_turu": "yapay_zeka"}, **{a: s[a] for a in uretici_paketi.YAZAR_ALANLARI if a in s}}
    for m in g2_yapi.soru_denetle(tam).hatalar:
        h.append(("[K14] " if "kalın" in m else "[K12] " if "şık" in m else "[K17] ") + m)
    if not any(x.startswith("[K20]") for x in h):
        for m in g4_hesap.soru_denetle(tam).hatalar:
            h.append(("[K12] " if "sıralı" in m or "çeldirici" in m else "[K19] ") + m)
    h += [f"[K07] alıntı metinde yok: {x}" for x in uretici_paketi.alinti_sorunlari(s.get("kaynaklar"))]
    h += sik_sorunlari(s)
    parca = g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(tam))
    hedef = banka.get((s.get("ders"), s.get("konu")), set())
    if parca and hedef and g7_ozgunluk.kapsanma(parca, hedef) > g7_ozgunluk.ESIK_BANKA:
        h.append("[K22] bankadaki bir soruya çok benziyor")
    return h


def _klasik_denetle(k: dict, plan: dict, gorev: str) -> list[str]:
    h = []
    r = _plan_satiri(plan, gorev, k.get("gorev_satiri"))
    if r is None:
        h.append(f"[K01] görevde olmayan klasik satır: {k.get('gorev_satiri')}")
    elif (k.get("ders"), k.get("konu")) != (r["ders"], r["konu"]):
        h.append(f"[K01] klasik ders/konu {k.get('ders')}/{k.get('konu')} ≠ görev {r['ders']}/{r['konu']}")
    if not (20 <= int(k.get("puan") or 0) <= 25) or not (25 <= int(k.get("sure_dk") or 0) <= 35):
        h.append("[K30] puan 20–25 ve süre 25–35 dk olmalı")
    kod = (k.get("dogrulama") or {}).get("python", "")
    if kod and YASAK_KOD.search(kod):
        return h + ["[K20] doğrulama kodunda yasak yapı"]
    tam = {"id": "YMM-XXX-ON-K000", "sinav": "ymm", "durum": "taslak", "surum": 1, "uretim": {"kaynak_turu": "yapay_zeka"},
           **{a: k[a] for a in klasik.YAZAR_ALANLARI if a in k}}
    for m in klasik.denetle(tam, klasik._konular("ymm")):
        h.append(("[K32] " if "puanlama" in m else "[K33] " if "doğrulama" in m else "[K07] " if "alıntı" in m
                  else "[K31] ") + m)
    return h


def _banka_parcalari() -> dict:
    banka: dict = {}
    for _, q in g2_yapi.dosyalari_yukle(KOK / "content/sorular/ymm"):
        if q.get("durum") != "geri_cekildi":
            banka.setdefault((q["ders"], q["konu"]), set()).update(g7_ozgunluk.parcalar(g7_ozgunluk.soru_metni(q)))
    return banka


_GOREV_KODU = re.compile(r"YMM-[A-Z]{3}-G\d{2}")
_SATIR = re.compile(r"(?:YMM-([A-Z]{3})-)?G(\d{2})\s*[-:/ ]\s*(K?\d+)$")


def normalle(veri: dict, ad: str) -> list[dict]:
    """Teslimi görev başına bir sözlüğe ayırır (boş görev kodu → dosya adı; birleşik teslim → bölünür)."""
    gorev = str(veri.get("gorev") or "")
    if not _GOREV_KODU.fullmatch(gorev):
        m = _GOREV_KODU.search(ad)
        tek = m.group(0) if m and len(_GOREV_KODU.findall(ad)) == 1 else None
    else:
        tek = gorev
    ders = (re.search(r"YMM-([A-Z]{3})", gorev or ad) or [None, None])[1]
    parcalar: dict[str, dict] = {}

    def ekle(alan: str, kayit: dict) -> None:
        kod, satir = tek, kayit.get("gorev_satiri")
        m = _SATIR.match(str(satir)) if satir is not None else None
        if m:
            kod, satir = f"YMM-{m.group(1) or ders}-G{m.group(2)}", m.group(3)
            satir = int(satir) if satir.isdigit() else satir
        parca = parcalar.setdefault(kod or gorev, {"yazar": veri.get("yazar"), "gorev": kod or gorev,
                                                    "sorular": [], "klasik": [], "atlanan": []})
        parca[alan].append({**kayit, "gorev_satiri": satir})

    for s in veri.get("sorular") or []:
        ekle("sorular", s)
    for k in veri.get("klasik") or []:
        ekle("klasik", k)
    if not parcalar:
        parcalar[tek or gorev] = {"yazar": veri.get("yazar"), "gorev": tek or gorev, "sorular": [], "klasik": []}
    ilk = next(iter(parcalar.values()))
    ilk["atlanan"] = list(veri.get("atlanan") or [])
    return list(parcalar.values())


def ele(teslim: Path, veri: dict | None = None) -> tuple[dict, list[str]]:
    """(geçen sorulardan oluşan teslim, rapor satırları)."""
    if veri is None:
        try:
            veri = yaml.safe_load(teslim.read_text(encoding="utf-8")) or {}
        except yaml.YAMLError as e:
            return {}, [f"TESLİM OKUNAMADI (YAML hatası): {e}"]
    plan, gorev = ymm_gorev.son_plan(), str(veri.get("gorev", ""))
    rapor = [f"# Ön eleme: {teslim.name} — görev {gorev or '?'} — yazar {veri.get('yazar', '?')}", ""]
    if gorev not in plan["gorevler"]:
        return {}, rapor + [f"TESLİM REDDEDİLDİ: görev kodu {gorev!r} planda yok"]
    banka, gecen, kl_gecen = _banka_parcalari(), [], []
    satirlar = Counter(str(s.get("gorev_satiri")) for s in veri.get("sorular") or [])
    icerik = Counter()
    for s in veri.get("sorular") or []:
        h = _test_denetle(s, plan, gorev, banka)
        if satirlar[str(s.get("gorev_satiri"))] > 1:
            h.append(f"[K02] satır {s.get('gorev_satiri')} birden çok kez kullanılmış")
        anahtar = _norm(s.get("kok", ""))[:120]
        icerik[anahtar] += 1
        if anahtar and icerik[anahtar] > 1:
            h.append("[K23] teslim içinde aynı kök tekrar ediyor")
        if h:
            rapor.append(f"- RET satır {s.get('gorev_satiri')}: " + " | ".join(h))
        else:
            gecen.append(s)
    for k in veri.get("klasik") or []:
        h = _klasik_denetle(k, plan, gorev)
        if h:
            rapor.append(f"- RET klasik {k.get('gorev_satiri')}: " + " | ".join(h))
        else:
            kl_gecen.append(k)
    dagilim = Counter(s["dogru"] for s in gecen)
    if gecen and max(dagilim.values()) > 0.30 * len(gecen) and len(gecen) >= 10:
        rapor.append(f"- UYARI [K13] doğru şık dağılımı dengesiz: {dict(sorted(dagilim.items()))} "
                     "(bankaya alındıktan sonra `python -m pipeline.sik_dengele` ile dengelenir)")
    for a in veri.get("atlanan") or []:
        rapor.append(f"- atlandı satır {a.get('satir')}: {a.get('neden')}")
    toplam_mc, toplam_kl = len(veri.get("sorular") or []), len(veri.get("klasik") or [])
    rapor[1:1] = [f"**Test: {len(gecen)}/{toplam_mc} geçti · Klasik: {len(kl_gecen)}/{toplam_kl} geçti**", ""]
    return {**{a: veri.get(a) for a in ("yazar", "gorev")}, "sorular": gecen, "klasik": kl_gecen}, rapor


def _al(sonuc: dict, parti: int) -> int:
    with tempfile.NamedTemporaryFile("w", suffix=".yaml", delete=False, encoding="utf-8") as f:
        yaml.safe_dump(sonuc, f, allow_unicode=True, sort_keys=False)
    alinan = [x for x in uretici_paketi.al(Path(f.name), parti) if x.startswith("alındı")]
    alinan += [x for x in klasik.al(Path(f.name), "ymm") if x.startswith("alındı")]
    return len(alinan)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__)
        return 1
    harita.sinav_sec("ymm")
    hedef = Path(argv[1])
    parti = int(argv[argv.index("--al") + 1]) if "--al" in argv else None
    dosyalar = sorted(hedef.rglob("*.yaml")) if hedef.is_dir() else [hedef]
    plan = ymm_gorev.son_plan()["gorevler"]
    ozet, tum_rapor, alinan = Counter(), [], 0
    for yol in dosyalar:
        try:
            veri = yaml.safe_load(yol.read_text(encoding="utf-8")) or {}
        except yaml.YAMLError as e:
            tum_rapor.append(f"## {yol.name}\nOKUNAMADI (YAML hatası): {str(e)[:200]}\n")
            ozet["okunamayan dosya"] += 1
            continue
        for parca in normalle(veri, yol.name):
            if parca["gorev"] not in plan:
                ozet["planda olmayan (eski tur) görev"] += 1
                tum_rapor.append(f"## {yol.name}\natlandı: görev {parca['gorev']!r} güncel planda yok\n")
                continue
            sonuc, rapor = ele(yol, parca)
            ozet["test gönderilen"] += len(parca["sorular"])
            ozet["test geçen"] += len(sonuc.get("sorular") or [])
            ozet["klasik gönderilen"] += len(parca["klasik"])
            ozet["klasik geçen"] += len(sonuc.get("klasik") or [])
            ozet["atlanan satır"] += len(parca.get("atlanan") or [])
            for r in rapor:
                for kod in re.findall(r"\[(K\d\d)\]", r):
                    ozet["ret " + kod] += 1
            tum_rapor.append(f"## {yol.name} → {parca['gorev']}\n" + "\n".join(rapor[1:]) + "\n")
            if parti is not None and (sonuc.get("sorular") or sonuc.get("klasik")):
                alinan += _al(sonuc, parti)
    bas = ["# Ön eleme özeti", ""] + [f"- {k}: {v}" for k, v in sorted(ozet.items())]
    if parti is not None:
        bas.append(f"- bankaya taslak olarak alınan: {alinan}")
    rapor_yolu = (hedef / "ON_ELEME_RAPORU.md") if hedef.is_dir() else hedef.with_suffix(".rapor.md")
    rapor_yolu.write_text("\n".join(bas + ["", *tum_rapor]) + "\n", encoding="utf-8")
    print("\n".join(bas) + f"\n(rapor: {rapor_yolu})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
