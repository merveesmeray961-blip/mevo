"""Konu anlatımları: content/anlatim/<sinav>/<DERS>/<KONU>.md dosyalarını okur, denetler ve uygulama paketine hazırlar.

Dosya biçimi: YAML ön bilgi + sade Markdown gövde.

    ---
    ders: FIN
    konu: ALC
    baslik: Alacaklar ve senetler
    durum: kontrolde            # taslak | kontrolde | onayli | yayinda (taslak uygulamaya girmez)
    yazar: ...
    kaynaklar:
      - mevzuat: 213 sayılı Vergi Usul Kanunu
        madde: md. 323
        alinti: "Alacak senetleri ... "   # mevzuattan birebir; otomatik doğrulanır
    ---
    ## Başlık
    Paragraf, **kalın**, - madde, 1. sıralı, > not kutusu, | tablo |

    python -m pipeline.anlatim                          # bütün anlatımları denetler
    python -m pipeline.anlatim paket FIN,TAB [--cikti D]  # dış üretici için anlatım paketi (zip)
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml

from pipeline import g2_yapi

KOK = g2_yapi.KOK
KLASOR = KOK / "content" / "anlatim" / "smmm"
AKTIF = {"kontrolde", "onayli", "yayinda"}
DAKIKADA_KELIME = 180  # mevzuat metni yavaş okunur
EN_AZ_KELIME = 600

_ON_BILGI = re.compile(r"\A---\n(.*?)\n---\n(.*)\Z", re.S)
_IZINLI_BASLIK = re.compile(r"^#{2,3} \S")


def oku(yol: Path) -> tuple[dict, str]:
    m = _ON_BILGI.match(yol.read_text(encoding="utf-8"))
    if not m:
        raise ValueError(f"{yol}: YAML ön bilgisi (--- ... ---) yok")
    return yaml.safe_load(m.group(1)) or {}, m.group(2).strip() + "\n"


def denetle(bilgi: dict, metin: str, dersler: dict[str, set[str]]) -> list[str]:
    """Yayına engel hatalar."""
    hatalar = []
    ders, konu = bilgi.get("ders"), bilgi.get("konu")
    if ders not in dersler or konu not in dersler.get(ders, set()):
        hatalar.append(f"müfredatta olmayan ders/konu: {ders}/{konu}")
    if not bilgi.get("baslik"):
        hatalar.append("başlık yok")
    kelime = len(metin.split())
    if kelime < EN_AZ_KELIME:
        hatalar.append(f"metin çok kısa ({kelime} kelime; en az {EN_AZ_KELIME})")
    for satir in metin.splitlines():
        if satir.startswith("#") and not _IZINLI_BASLIK.match(satir):
            hatalar.append(f"desteklenmeyen başlık düzeyi: {satir[:40]!r} (yalnız ## ve ###)")
    if "](" in metin or "<" in re.sub(r"<\s*\d", "", metin):
        hatalar.append("bağlantı veya HTML kullanılmış; uygulama göstermez")
    from pipeline.uretici_paketi import alinti_sorunlari  # döngüsel içe aktarmayı önlemek için burada

    hatalar += [f"alıntı mevzuatta yok: {s}" for s in alinti_sorunlari(bilgi.get("kaynaklar") or [])]
    return hatalar


def _dersler() -> dict[str, set[str]]:
    m = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    return {d["kod"]: {k["kod"] for k in d["konular"]} for d in m["dersler"]}


def paket_icin(klasor: Path = KLASOR) -> tuple[list[dict], list[dict]]:
    """(uygulamaya girecek anlatımlar, elenenler)."""
    dersler = _dersler()
    girenler, elenen = [], []
    for yol in sorted(klasor.glob("*/*.md")):
        bilgi, metin = oku(yol)
        if bilgi.get("durum") not in AKTIF:
            continue
        hatalar = denetle(bilgi, metin, dersler)
        if hatalar:
            elenen.append({"dosya": str(yol.relative_to(KOK)), "hatalar": hatalar})
            continue
        girenler.append({
            "ders": bilgi["ders"],
            "konu": bilgi["konu"],
            "baslik": bilgi["baslik"],
            "metin": metin,
            "okuma_dk": max(1, round(len(metin.split()) / DAKIKADA_KELIME)),
            # Aynı maddeye birden çok alıntı olabilir; uygulamada her madde bir kez listelenir.
            "kaynaklar": list(dict.fromkeys(f"{k['mevzuat']} · {k['madde']}" for k in (bilgi.get("kaynaklar") or []))),
        })
    return girenler, elenen


def paket_olustur(ders: str, cikti: Path) -> Path:
    """Dış üretici için konu anlatımı paketi: GOREV.md (konular ve kazanımlar), kurallar, örnek ve kaynaklar."""
    import datetime as dt
    import shutil

    from pipeline import uretici_paketi

    m = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    d = next(x for x in m["dersler"] if x["kod"] == ders)
    mevcut = {p.stem for p in (KLASOR / ders).glob("*.md")} if (KLASOR / ders).exists() else set()
    konular = [k for k in d["konular"] if k["kod"] not in mevcut]
    ad = f"anlatim_{ders}-{dt.date.today().isoformat()}-{len(konular)}konu"
    klasor = cikti / ad
    if klasor.exists():
        shutil.rmtree(klasor)
    (klasor / "kaynaklar").mkdir(parents=True)
    satirlar = [
        f"# GÖREV {ad}: {d['ad']} — konu anlatımları",
        "",
        "Önce `ANLATIM_KURALLARI.md` ve `ORNEK_ANLATIM.md` dosyalarını oku. Aşağıdaki **her konu için ayrı bir `.md`**",
        "dosyası yaz (dosya adı = konu kodu) ve hepsini tek zip olarak teslim et. Kaynak metinler `kaynaklar/` klasöründe.",
        "Her konunun kazanımlarının hepsi anlatımda işlenmelidir.",
        "",
        "| # | Konu kodu | Konu | İşlenecek kazanımlar | Kaynak ipucu |",
        "|---|---|---|---|---|",
    ]
    for i, k in enumerate(konular, 1):
        kaz = "; ".join(str(z) for z in k.get("kazanimlar", []))
        satirlar.append(f"| {i} | {k['kod']} | {k['ad']} | {kaz} | {', '.join(map(str, k.get('kaynaklar', [])))} |")
    satirlar += ["", f"Ön bilgide `ders: {ders}` ve ilgili `konu:` kodunu kullan; `durum: taslak` yaz.", ""]
    (klasor / "GOREV.md").write_text("\n".join(satirlar), encoding="utf-8")
    shutil.copy(KOK / "docs/uretici/ANLATIM_KURALLARI.md", klasor / "ANLATIM_KURALLARI.md")
    shutil.copy(KLASOR / "FIN" / "ALC.md", klasor / "ORNEK_ANLATIM.md")
    for kaynak in uretici_paketi._kaynak_dosyalari(ders):
        shutil.copy(kaynak, klasor / "kaynaklar" / kaynak.name)
    zip_yolu = shutil.make_archive(str(klasor), "zip", root_dir=klasor.parent, base_dir=klasor.name)
    return Path(zip_yolu)


def main(argv: list[str]) -> int:
    if len(argv) >= 3 and argv[1] == "paket":
        cikti = Path(argv[argv.index("--cikti") + 1]) if "--cikti" in argv else KOK / "uretici_paketleri"
        for ders in argv[2].split(","):
            print(paket_olustur(ders.upper(), cikti))
        return 0
    dersler = _dersler()
    hata = 0
    for yol in sorted(KLASOR.glob("*/*.md")):
        bilgi, metin = oku(yol)
        h = denetle(bilgi, metin, dersler)
        hata += bool(h)
        print(f"{'HATA ' if h else 'tamam'} {yol.relative_to(KOK)} [{bilgi.get('durum')}] {len(metin.split())} kelime")
        for x in h:
            print("   -", x)
    return 1 if hata else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
