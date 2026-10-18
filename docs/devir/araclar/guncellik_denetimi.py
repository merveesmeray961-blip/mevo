"""Aktif (kontrolde) soruların token harcamayan güncellik ve kaynak denetimi.

Kurallar:
  R1 yıla bağlı tutar eski yıla ait (gecerlilik.yil < HEDEF_YIL ya da yıl yok)
  R2 metinde eski oran/tutar kalıbı (KDV %18, damga binde 9,48, KV %20/%22/%23 …) — elle bakılır
  R3 kaynak alıntısı resmî metinlerde birebir bulunamadı
  R4 2026-10-09 tam hakemde "zayıf" işaretli (yeniden yazım adayı)
  R5 doğru şık en uzun çeldiriciden %30 fazla uzun (talimattaki sınır; resmî sınavda bu oran %24, bankada %62)
  R6 yalnız çeldiricilerde mutlak ifade (hiçbir, yalnızca, her zaman …) — eleme ipucu (resmîde %1,5)
  R7 SMMM kökünde BDS numarası (2026 resmî sorularında hiç yok)

    python docs/devir/araclar/guncellik_denetimi.py [--cikti docs/denetim/<tarih>_guncellik.json]
"""
from __future__ import annotations

import collections
import json
import re
import sys
from pathlib import Path

KOK = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(KOK))

import yaml  # noqa: E402

from pipeline.uretici_paketi import alinti_sorunlari  # noqa: E402

HEDEF_YIL = 2026
ESKI_KALIPLAR = [
    (r"(KDV|katma değer)[^.\n]{0,60}%\s?18\b|%\s?18\b[^.\n]{0,40}(KDV|katma değer)", "KDV genel oranı %18 (2023/7'den beri %20)"),
    (r"(KDV|katma değer)[^.\n]{0,60}%\s?8\b|%\s?8\b[^.\n]{0,40}(KDV|katma değer)", "KDV %8 (2023/7'den beri %10)"),
    (r"binde\s?9,48", "damga vergisi binde 9,48 (güncel oran binde 9,48 değil mi kontrol)"),
    (r"kurumlar vergisi[^.\n]{0,40}%\s?(20|22|23)\b", "kurumlar vergisi oranı %20/22/23 (2023'ten beri %25)"),
    (r"\b(2021|2022|2023|2024) yılı (için|itibarıyla)", "eski yıla ait tutar/eşik atfı"),
]


MUTLAK = re.compile(r"\b(hiçbir|hiç bir|yalnızca|sadece|her zaman|her durumda|asla|tamamen|kesinlikle|hiçbir zaman|daima)\b", re.I)


def _sorular(sinav: str):
    for f in sorted((KOK / "content/sorular" / sinav).glob("*/*.yaml")):
        v = yaml.safe_load(f.read_text(encoding="utf-8"))
        for s in v if isinstance(v, list) else (v.get("sorular") or [v]):
            if s.get("durum") == "kontrolde":
                yield f, s


def _metin(s: dict) -> str:
    parcalar = [str(s.get("kok", "")), json.dumps(s.get("secenekler", {}), ensure_ascii=False),
                json.dumps(s.get("aciklama", {}), ensure_ascii=False)]
    return "\n".join(parcalar)


def denetle() -> dict:
    zayif = json.loads((KOK / "docs/denetim/2026-10-09_tam_hakem.json").read_text(encoding="utf-8"))["zayif"]
    istisna_yolu = KOK / "docs/denetim/guncellik_istisna.json"  # elle doğrulanmış yanlış alarmlar
    istisna = json.loads(istisna_yolu.read_text(encoding="utf-8")) if istisna_yolu.exists() else {}
    bulgu: dict[str, list[str]] = {}
    for sinav in ("smmm", "ymm"):
        for _, s in _sorular(sinav):
            h = []
            g = s.get("gecerlilik") or {}
            if g.get("yila_bagli_tutar") and (g.get("yil") or 0) < HEDEF_YIL:
                h.append(f"R1 yıla bağlı tutar: yıl {g.get('yil')}")
            metin = _metin(s)
            h += [f"R2 {aciklama}" for desen, aciklama in ESKI_KALIPLAR if re.search(desen, metin, re.I)]
            h += [f"R3 alıntı yok: {x}" for x in alinti_sorunlari(s.get("kaynaklar") or [])]
            duzeltildi = any(g.get("ne") == "düzeltildi" for g in s.get("gecmis") or [])
            if s["id"] in zayif and not duzeltildi:
                h.append("R4 zayıf: " + zayif[s["id"]][:120])
            sec = s.get("secenekler") or {}
            if sec and s.get("dogru") in sec:
                uz = {k: len(str(v)) for k, v in sec.items()}
                digerleri = [v for k, v in uz.items() if k != s["dogru"]]
                if digerleri and max(uz.values()) > 20 and uz[s["dogru"]] > 1.3 * max(digerleri):  # kısa/sayısal şıklarda ipucu sayılmaz
                    h.append("R5 doğru şık en uzun")
                mutlak = [k for k, v in sec.items() if k != s["dogru"] and MUTLAK.search(str(v))]
                if mutlak and not MUTLAK.search(str(sec[s["dogru"]])):
                    h.append("R6 mutlak ifade yalnız çeldiricide: " + ",".join(mutlak))
            if sinav == "smmm" and re.search(r"\bBDS\s?\d{3}", str(s.get("kok", ""))):
                h.append("R7 kökte BDS numarası")
            h = [x for x in h if x[:2] not in istisna.get(s["id"], {}).get("kurallar", [])]
            if h:
                bulgu[s["id"]] = h
    return bulgu


def main(argv: list[str]) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    bulgu = denetle()
    sayac = collections.Counter(x[:2] for h in bulgu.values() for x in h)
    ders = collections.Counter("-".join(i.split("-")[:2]) for i in bulgu)
    print(f"bulgulu soru: {len(bulgu)}")
    print("kural:", dict(sorted(sayac.items())))
    print("ders:", dict(sorted(ders.items())))
    if "--cikti" in argv:
        Path(argv[argv.index("--cikti") + 1]).write_text(json.dumps(bulgu, ensure_ascii=False, indent=1), encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
