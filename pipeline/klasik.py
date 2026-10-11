"""Klasik (açık uçlu) sorular: teslimden alma, yapı denetimi ve uygulama paketi.

YMM sınavı klasik yazılıdır; bu sorular adayın kendi cevabını örnek çözümle karşılaştırıp puanlama ölçütüne göre
kendini puanladığı denemeler içindir. Kayıtlar `content/klasik/<sinav>/<DERS>/<KONU>.yaml` altında tutulur
(şema `content/schema/klasik.schema.json`).

    python -m pipeline.klasik al teslim.yaml [--sinav ymm]   # teslimdeki `klasik:` listesini taslak olarak alır
    python -m pipeline.klasik denetle [--sinav ymm]          # yapı, puan toplamı, alıntı ve doğrulama kodu
    python -m pipeline.klasik terfi karar1.json ... [--sinav ymm]   # hakem kararı: kabul → kontrolde, ret → geri_cekildi
"""

from __future__ import annotations

import datetime as dt
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

import jsonschema
import yaml

from pipeline import g2_yapi, uretici_paketi

KOK = g2_yapi.KOK
SEMA = json.loads((KOK / "content/schema/klasik.schema.json").read_text(encoding="utf-8"))
AKTARILAN_DURUMLAR = {"kontrolde", "onayli", "yayinda"}
YAZAR_ALANLARI = ("ders", "konu", "kazanimlar", "zorluk", "puan", "sure_dk", "soru", "cozum", "puanlama", "kaynaklar",
                  "gecerlilik", "dogrulama")


def dizin(sinav: str = "ymm") -> Path:
    return KOK / "content/klasik" / sinav


def yukle(sinav: str = "ymm") -> list[tuple[Path, dict]]:
    return [(p, k) for p in sorted(dizin(sinav).rglob("*.yaml"))
            for k in (yaml.safe_load(p.read_text(encoding="utf-8")) or [])]


def _konular(sinav: str) -> dict[tuple[str, str], str]:
    m = yaml.safe_load((KOK / f"content/mufredat/{sinav}.yaml").read_text(encoding="utf-8"))
    return {(d["kod"], k["kod"]): k["ad"] for d in m["dersler"] for k in d["konular"]}


def dogrulama_calistir(kod: str) -> dict:
    ad_alani: dict = {}
    exec(kod, {"__builtins__": __builtins__}, ad_alani)  # noqa: S102 — kendi üretim hattımızın kodu
    if "sonuc" not in ad_alani:
        raise ValueError("doğrulama kodu 'sonuc' değişkenini atamıyor")
    sonuc = ad_alani["sonuc"]
    return sonuc if isinstance(sonuc, dict) else {"sonuc": sonuc}


def _sayilar(metin: str) -> set[float]:
    """Metindeki sayılar (Türkçe yazım: 1.250.000,50)."""
    sayilar = set()
    for s in re.findall(r"\d[\d.]*(?:,\d+)?", metin):
        s = s.rstrip(".")
        try:
            sayilar.add(float(s.replace(".", "").replace(",", ".")))
        except ValueError:
            pass
    return sayilar


def denetle(k: dict, konular: dict | None = None) -> list[str]:
    hatalar = [f"şema: {e.message}" for e in jsonschema.Draft202012Validator(SEMA).iter_errors(k)]
    if hatalar:
        return hatalar
    if konular is not None and (k["ders"], k["konu"]) not in konular:
        hatalar.append(f"müfredatta yok: {k['ders']}/{k['konu']}")
    toplam = sum(p["puan"] for p in k["puanlama"])
    if abs(toplam - k["puan"]) > 1e-9:
        hatalar.append(f"puanlama toplamı {toplam} ≠ puan {k['puan']}")
    if sorun := uretici_paketi.alinti_sorunlari(k.get("kaynaklar")):
        hatalar.append("alıntı metinde yok: " + " | ".join(sorun))
    if k.get("dogrulama"):
        try:
            sonuc = dogrulama_calistir(k["dogrulama"]["python"])
        except Exception as e:  # noqa: BLE001
            hatalar.append(f"doğrulama kodu çalışmadı: {e}")
        else:
            cozumdeki = _sayilar(k["cozum"])
            for ad, deger in sonuc.items():
                if isinstance(deger, (int, float)) and not any(abs(abs(deger) - c) <= max(1.0, abs(deger) * 1e-4)
                                                               for c in cozumdeki):
                    hatalar.append(f"doğrulama sonucu çözümde yok: {ad} = {deger}")
    return hatalar


def al(teslim: Path, sinav: str = "ymm") -> list[str]:
    veri = yaml.safe_load(teslim.read_text(encoding="utf-8")) or {}
    konular = _konular(sinav)
    no: dict = defaultdict(int)
    for _, k in yukle(sinav):
        m = re.search(r"K(\d+)$", k["id"])
        no[(k["ders"], k["konu"])] = max(no[(k["ders"], k["konu"])], int(m.group(1)) if m else 0)
    bugun = dt.date.today().isoformat()
    rapor, dosyalar = [], defaultdict(list)
    for i, s in enumerate(veri.get("klasik") or [], 1):
        anahtar = (s.get("ders"), s.get("konu"))
        if anahtar not in konular:
            rapor.append(f"REDDEDİLDİ klasik {i}: konu {anahtar} müfredatta yok")
            continue
        no[anahtar] += 1
        yeni = {"id": f"{sinav.upper()}-{anahtar[0]}-{anahtar[1]}-K{no[anahtar]:03d}", "sinav": sinav}
        yeni.update({a: s[a] for a in YAZAR_ALANLARI if a in s})
        yeni.update({"durum": "taslak", "surum": 1,
                     "uretim": {"kaynak_turu": "yapay_zeka", "model": f"harici: {veri.get('yazar', '?')}",
                                "istem_surumu": f"uretici paketi {veri.get('gorev', '?')}",
                                "kapilar": {"G2": {"sonuc": "bekliyor"}, "G5": {"sonuc": "bekliyor"}}},
                     "gecmis": [{"tarih": bugun, "kim": "uretici", "ne": f"harici teslim {teslim.name}, klasik {i}"}]})
        hatalar = denetle(yeni, konular)
        if hatalar:
            no[anahtar] -= 1
            rapor.append(f"REDDEDİLDİ klasik {i} ({anahtar[0]}/{anahtar[1]}): " + "; ".join(hatalar))
            continue
        yeni["uretim"]["kapilar"]["G2"] = {"sonuc": "gecti", "tarih": bugun}
        dosyalar[anahtar].append(yeni)
        rapor.append(f"alındı {yeni['id']}")
    for (ders, konu), liste in dosyalar.items():
        yol = dizin(sinav) / ders / f"{konu}.yaml"
        onceki = yaml.safe_load(yol.read_text(encoding="utf-8")) if yol.exists() else []
        yol.parent.mkdir(parents=True, exist_ok=True)
        yol.write_text(yaml.safe_dump(onceki + liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    return rapor


HAKEM_GUVENI = 4


def terfi(kararlar: dict, sinav: str = "ymm") -> dict[str, int]:
    """Hakem kararlarını taslak klasik sorulara işler (docs/devir/YMM_KLASIK_HAKEM_TALIMATI.md çıktısı)."""
    bugun, n = dt.date.today().isoformat(), {"kabul": 0, "ret": 0}
    for yol in sorted(dizin(sinav).rglob("*.yaml")):
        liste, degisti = yaml.safe_load(yol.read_text(encoding="utf-8")) or [], False
        for k in liste:
            h = kararlar.get(k["id"])
            if k.get("durum") != "taslak" or not h:
                continue
            kabul = bool(h.get("uygun")) and int(h.get("guven") or 0) >= HAKEM_GUVENI
            neden = "kitap düzeyi hakem kabulü" if kabul else (h.get("neden") or "hakem uygun bulmadı")
            k.setdefault("uretim", {}).setdefault("kapilar", {})["G5"] = {
                "sonuc": "gecti" if kabul else "kaldi", "tarih": bugun,
                "not": f"güven {h.get('guven')}, seviye {h.get('seviye')}" if kabul else neden}
            yeni = "kontrolde" if kabul else "geri_cekildi"
            k.setdefault("gecmis", []).append({"tarih": bugun, "kim": "hakem", "ne": f"durum: taslak → {yeni}", "neden": neden})
            k["durum"] = yeni
            n["kabul" if kabul else "ret"] += 1
            degisti = True
        if degisti:
            yol.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    return n


def paket_icin(sinav: str = "ymm") -> tuple[list[dict], list[dict]]:
    """Uygulama paketine girecek klasik sorular (hakemden geçmiş) ve yapı denetiminden kalanlar."""
    konular = _konular(sinav)
    giden, elenen = [], []
    for _, k in yukle(sinav):
        if k.get("durum") not in AKTARILAN_DURUMLAR:
            continue
        if hatalar := denetle(k, konular):
            elenen.append({"id": k["id"], "hatalar": hatalar})
            continue
        giden.append({a: k[a] for a in ("id", "surum", "ders", "konu", "kazanimlar", "zorluk", "puan", "sure_dk",
                                        "soru", "cozum", "puanlama", "kaynaklar")})
    return giden, elenen


def main(argv: list[str]) -> int:
    sinav = argv[argv.index("--sinav") + 1] if "--sinav" in argv else "ymm"
    if len(argv) >= 3 and argv[1] == "al":
        print("\n".join(al(Path(argv[2]), sinav)))
        return 0
    if len(argv) >= 3 and argv[1] == "terfi":
        kararlar: dict = {}
        for yol in argv[2:]:
            if not yol.startswith("--") and yol != sinav:
                kararlar.update(json.loads(Path(yol).read_text(encoding="utf-8")))
        print(terfi(kararlar, sinav))
        return 0
    if len(argv) >= 2 and argv[1] == "denetle":
        konular, kotu = _konular(sinav), 0
        kayitlar = yukle(sinav)
        for p, k in kayitlar:
            if hatalar := denetle(k, konular):
                kotu += 1
                print(f"{k.get('id')} ({p.relative_to(KOK)}): " + "; ".join(hatalar))
        print(f"{len(kayitlar)} klasik soru, {kotu} hatalı")
        return 1 if kotu else 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
