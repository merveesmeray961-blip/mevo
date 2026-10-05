"""Harici soru yazarları (başka asistanlar) için görev paketi hazırlar ve teslimleri bankaya taslak olarak alır.

    python -m pipeline.uretici_paketi olustur HUK 30 [--cikti klasor]   # GOREV.md + kurallar + örnekler + kaynaklar → .zip
    python -m pipeline.uretici_paketi al teslim_x.yaml 6                 # teslimi doğrular, id verir, <KONU>.p6.yaml yazar

`al` soruları `durum: taslak` olarak yazar; ardından olağan denetim (SORU_URETIM_RECETESI.md "Harici üretici") uygulanır.
"""

from __future__ import annotations

import datetime as dt
import re
import shutil
import sys
from collections import defaultdict
from pathlib import Path

import yaml

from pipeline import g2_yapi, harita

KOK = g2_yapi.KOK
SORULAR = KOK / "content/sorular/smmm"
MEVZUAT = KOK / "content/kaynaklar/mevzuat"

# Ders → kaynaklar/ klasörüne konacak metin dosyalarının ön ekleri.
DERS_KAYNAK = {
    "FIN": ["msugt", "kavramsal_cerceve", "bobi_frs", "vuk", "ttk"],
    "STD": ["tms_", "tfrs_", "kavramsal_cerceve", "bobi_frs"],
    "TAB": ["msugt", "vuk", "ttk"],
    "MAL": ["msugt", "vuk", "gvk", "kvk"],
    "DEN": ["bds_", "sbds_", "gds_", "kys_", "ihs_", "bagimsiz_denetim_yon", "bd_etik_kurallar", "ttk"],
    "VER": ["gvk", "gv_teblig", "kvk", "kv_", "yerel_kuresel", "kdvk", "kdv_gut", "vuk", "aatuhk", "otv", "dvk",
            "vivk", "mtvk", "evk", "harclar", "fgk_cbk", "iyuk", "idare_mahkemeleri"],
    "HUK": ["ttk", "tbk", "isk", "sgk", "sosyal_sigorta", "sendikalar", "is_mahkemeleri", "iyuk", "aatuhk"],
    "SPK": ["spk", "ttk"],
    "MES": ["smmm_", "ymm_", "turmob", "disiplin_yon", "calisma_usul_yon", "etik_ilkeler_yon", "haksiz_rekabet_yon",
            "smge_yon", "ucretler_yon"],
    "EKO": [],
    "MLY": ["kmyk", "harclar", "aatuhk", "vuk"],
}
YAZAR_ALANLARI = ("bolum", "ders", "konu", "kazanim", "tip", "zorluk", "kok", "secenekler", "dogru", "aciklama",
                  "kaynaklar", "gecerlilik", "dogrulama")


def _kaynak_dosyalari(ders: str) -> list[Path]:
    return sorted(p for p in MEVZUAT.glob("*.txt") if any(p.stem.startswith(o) for o in DERS_KAYNAK[ders]))


def _ornekler(ders: str, n: int = 3) -> list[dict]:
    sorular = [s for _, s in g2_yapi.dosyalari_yukle(SORULAR, []) if s["ders"] == ders and s.get("durum") == "kontrolde"]
    secilen = {}
    for s in sorted(sorular, key=lambda s: -s.get("zorluk", 2)):
        secilen.setdefault(s.get("zorluk"), s)  # her zorluktan bir tane
    return [{k: s[k] for k in YAZAR_ALANLARI if k in s} for s in list(secilen.values())[:n]]


def olustur(ders: str, adet: int, cikti: Path) -> Path:
    tarih = dt.date.today().isoformat()
    kod = f"{ders}-{tarih}-{adet}"
    klasor = cikti / f"uretici_{kod}"
    if klasor.exists():
        shutil.rmtree(klasor)
    (klasor / "kaynaklar").mkdir(parents=True)
    plan = harita.sonraki(adet, ders)
    satirlar = [f"# Görev {kod}", "",
                f"Yazacağın {len(plan)} soru aşağıda. Her satır için **tam o kazanımda, o zorlukta** bir soru yaz "
                "(1 kolay · 2 orta · 3 zor). Kurallar `MANIFESTO.md`'de; teslimde `gorev` alanına "
                f"`{kod}` yaz, her soruya `gorev_satiri` ver.", "",
                "| # | Ders | Konu kodu | Konu | Kazanım | Zorluk | Bölüm |", "|---|---|---|---|---|---|---|"]
    satirlar += [f"| {i} | {p['ders']} | {p['konu']} | {p['konu_ad']} | {p['kazanim']} | {p['zorluk']} | "
                 f"{','.join(p['bolum'])} |" for i, p in enumerate(plan, 1)]
    if not DERS_KAYNAK[ders]:
        satirlar += ["", "Bu derste resmî metin yoktur; sorular genel kabul görmüş ders bilgisine dayanır. "
                     "`kaynaklar` alanına başvurulan kavram/model adını yaz, `alinti` boş kalabilir."]
    (klasor / "GOREV.md").write_text("\n".join(satirlar) + "\n", encoding="utf-8")
    shutil.copy(KOK / "docs/uretici/MANIFESTO.md", klasor / "MANIFESTO.md")
    shutil.copy(KOK / "pipeline/istemler/uretim.md", klasor / "URETIM_KURALLARI.md")
    shutil.copy(KOK / "pipeline/istemler/kontrol.md", klasor / "KONTROL_LISTESI.md")
    shutil.copy(KOK / "content/schema/soru.schema.json", klasor / "SEMA.json")
    (klasor / "ORNEKLER.yaml").write_text(
        yaml.safe_dump(_ornekler(ders), allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    for p in _kaynak_dosyalari(ders):
        shutil.copy(p, klasor / "kaynaklar" / p.name)
    zip_yolu = shutil.make_archive(str(klasor), "zip", klasor.parent, klasor.name)
    return Path(zip_yolu)


def _sonraki_no() -> dict[tuple[str, str], int]:
    en_buyuk: dict = defaultdict(int)
    for _, s in g2_yapi.dosyalari_yukle(SORULAR, []):
        m = re.search(r"(\d+)$", s["id"])
        en_buyuk[(s["ders"], s["konu"])] = max(en_buyuk[(s["ders"], s["konu"])], int(m.group(1)) if m else 0)
    return en_buyuk


def al(teslim: Path, parti: int) -> list[str]:
    veri = yaml.safe_load(teslim.read_text(encoding="utf-8"))
    mufredat = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    konu_ad = {(d["kod"], k["kod"]): k["ad"] for d in mufredat["dersler"] for k in d["konular"]}
    no = _sonraki_no()
    bugun = dt.date.today().isoformat()
    rapor, dosyalar = [], defaultdict(list)
    for a in veri.get("atlanan") or []:
        rapor.append(f"atlandı satır {a.get('satir')}: {a.get('neden')}")
    for i, s in enumerate(veri.get("sorular") or [], 1):
        eksik = [k for k in YAZAR_ALANLARI if k not in s and k != "dogrulama"]
        anahtar = (s.get("ders"), s.get("konu"))
        if eksik or anahtar not in konu_ad or s.get("dogru") not in (s.get("secenekler") or {}):
            rapor.append(f"REDDEDİLDİ soru {i} (satır {s.get('gorev_satiri')}): eksik {eksik or ''} "
                         f"konu {anahtar if anahtar not in konu_ad else 'ok'}")
            continue
        no[anahtar] += 1
        yeni = {"id": f"SMMM-{anahtar[0]}-{anahtar[1]}-{no[anahtar]:04d}", "sinav": "smmm",
                "bolum": s["bolum"], "ders": s["ders"], "unite": konu_ad[anahtar]}
        yeni.update({k: s[k] for k in YAZAR_ALANLARI if k in s and k not in yeni})
        yeni.update({"durum": "taslak", "surum": 1, "uretim": {
            "kaynak_turu": "yapay_zeka", "model": f"harici: {veri.get('yazar', '?')}",
            "istem_surumu": f"uretici paketi {veri.get('gorev', '?')}",
            "kapilar": {g: {"sonuc": "bekliyor"} for g in ("G3", "G5", "G6", "GZ")}},
            "gecmis": [{"tarih": bugun, "kim": "uretici", "ne": f"harici teslim {teslim.name}, satır {s.get('gorev_satiri')}"}]})
        dosyalar[anahtar].append(yeni)
        rapor.append(f"alındı {yeni['id']} (satır {s.get('gorev_satiri')})")
    for (ders, konu), liste in dosyalar.items():
        yol = SORULAR / ders / f"{konu}.p{parti}.yaml"
        onceki = yaml.safe_load(yol.read_text(encoding="utf-8")) if yol.exists() else []
        yol.parent.mkdir(parents=True, exist_ok=True)
        yol.write_text(yaml.safe_dump(onceki + liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    return rapor


def main(argv: list[str]) -> int:
    if len(argv) >= 4 and argv[1] == "olustur":
        cikti = Path(argv[argv.index("--cikti") + 1]) if "--cikti" in argv else KOK / "uretici_paketleri"
        print(olustur(argv[2].upper(), int(argv[3]), cikti))
        return 0
    if len(argv) >= 4 and argv[1] == "al":
        print("\n".join(al(Path(argv[2]), int(argv[3]))))
        print("Sonraki: python -m pipeline.denetle content/sorular/smmm  →  kör dosya + hakem (reçete)")
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
