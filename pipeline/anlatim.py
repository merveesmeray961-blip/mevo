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
    python -m pipeline.anlatim paket IFM,FYN --sinav ymm  # YMM anlatım paketi (YMM_ANLATIM_KURALLARI.md)
    python -m pipeline.anlatim on_eleme teslim.zip --sinav ymm [--al]   # dış teslimin katı ön elemesi

Dış teslimler `on_eleme` ile denetlenir (kural kodları A01…: docs/uretici/YMM_ANLATIM_KURALLARI.md); `--al` geçenleri
`durum: taslak` olarak content/anlatim/<sinav>/ altına yazar. Zip yalnız okunur (açılmaz); yalnız .md dosyaları alınır.
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


_ALAN = re.compile(r'^(\s*(?:-\s+)?)([A-Za-z_]+):\s+(.*\S)\s*$')


def _tirnakla(on_bilgi: str) -> str:
    """Üreticilerin sık hatası: değerde tırnaksız ': ' ("Sıra No: 1") YAML'ı bozar. Böyle değerler tırnağa alınır."""
    satirlar = []
    for s in on_bilgi.splitlines():
        m = _ALAN.match(s)
        if m and ": " in m.group(3) and m.group(3)[0] not in "\"'[{|>":
            deger = m.group(3).replace("\\", "\\\\").replace('"', '\\"')
            s = f'{m.group(1)}{m.group(2)}: "{deger}"'
        satirlar.append(s)
    return "\n".join(satirlar)


def klasor(sinav: str = "smmm") -> Path:
    return KOK / "content" / "anlatim" / sinav


def oku(yol: Path) -> tuple[dict, str]:
    return metinden(yol.read_text(encoding="utf-8"), str(yol))


def metinden(ham: str, ad: str = "") -> tuple[dict, str]:
    m = _ON_BILGI.match(ham.lstrip("\ufeff").replace("\r\n", "\n"))
    if not m:
        raise ValueError(f"{ad}: YAML ön bilgisi (--- ... ---) yok")
    try:
        bilgi = yaml.safe_load(m.group(1))
    except yaml.YAMLError:
        bilgi = yaml.safe_load(_tirnakla(m.group(1)))
    return bilgi or {}, m.group(2).strip() + "\n"


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


def _mufredat(sinav: str = "smmm") -> list[dict]:
    return yaml.safe_load((KOK / f"content/mufredat/{sinav}.yaml").read_text(encoding="utf-8"))["dersler"]


def _dersler(sinav: str = "smmm") -> dict[str, set[str]]:
    return {d["kod"]: {k["kod"] for k in d["konular"]} for d in _mufredat(sinav)}


# Dış teslimin katı ön elemesi (docs/uretici/YMM_ANLATIM_KURALLARI.md, kodlar A01…).
SIKI_KELIME = (900, 1800)
_DOLGU = re.compile(r"\b(bu yazıda|yazar olarak|biz bu|sevgili okur|başarılar dileriz)\b", re.I)
_EMOJI = re.compile("[\U0001F300-\U0001FAFF\u2600-\u27BF]")
_DURAK = {"ve", "ile", "veya", "için", "olarak", "ilgili", "temel", "genel", "esasları", "hesabı", "türleri"}


def _kok(kelime: str) -> str:
    k = kelime.replace("İ", "i").replace("I", "ı").lower()
    return re.sub(r"[^0-9a-zçğıöşü]", "", k)[:6]


def siki_denetle(bilgi: dict, metin: str, konu: dict) -> list[str]:
    """Dış üretici anlatımı için ek kurallar; `denetle` hatalarına eklenir."""
    h = []
    kelime = len(metin.split())
    if not SIKI_KELIME[0] <= kelime <= SIKI_KELIME[1]:
        h.append(f"[A01] uzunluk {kelime} kelime; {SIKI_KELIME[0]}–{SIKI_KELIME[1]} olmalı")
    if not re.search(r"^## .*neler öğreneceksin", metin, re.I | re.M):
        h.append("[A02] '## Bu konuda neler öğreneceksin' bölümü yok")
    if not re.search(r"^## .*özet", metin, re.I | re.M):
        h.append("[A03] sonda '## Özet' bölümü yok")
    if len(re.findall(r"^> \*\*", metin, re.M)) < 2:
        h.append("[A04] en az 2 not kutusu (> **Sınav ipucu:** / > **Sık yapılan hata:**) yok")
    metin_kokleri = {_kok(w) for w in metin.split()}
    for kaz in konu.get("kazanimlar", []):
        anlamli = [_kok(w) for w in str(kaz).split() if len(_kok(w)) >= 4 and w.lower() not in _DURAK]
        if anlamli and not any(k in metin_kokleri for k in anlamli):
            h.append(f"[A05] kazanım işlenmemiş görünüyor: {kaz!r}")
    if _DOLGU.search(metin) or _EMOJI.search(metin):
        h.append("[A06] yasak üslup (dolgu ifade / emoji)")
    if not bilgi.get("kaynaklar") and konu.get("_kaynakli", True):
        h.append("[A07] ön bilgide kaynak yok")
    if bilgi.get("durum") != "taslak":
        h.append("[A08] durum: taslak olmalı")
    return h


def on_eleme(teslim: Path, sinav: str = "ymm", al: bool = False) -> list[str]:
    """Zip (yalnız okunur) ya da klasördeki .md anlatımlarını denetler; `al` ise geçenleri yazar."""
    import zipfile

    if teslim.is_dir():
        dosyalar = {p.name: p.read_text(encoding="utf-8", errors="replace") for p in sorted(teslim.rglob("*.md"))}
    else:
        with zipfile.ZipFile(teslim) as z:
            dosyalar = {Path(n).name: z.read(n).decode("utf-8", errors="replace")
                        for n in z.namelist() if n.endswith(".md") and not n.endswith("/")}
    mufredat = {d["kod"]: d for d in _mufredat(sinav)}
    dersler = {k: {x["kod"] for x in d["konular"]} for k, d in mufredat.items()}
    rapor, gecen = [], 0
    for ad, ham in dosyalar.items():
        if ad.upper().startswith(("ANLATIM_KURALLARI", "GOREV", "PROMPT", "ORNEK", "YMM_")):
            continue
        try:
            bilgi, metin = metinden(ham, ad)
        except Exception as e:  # noqa: BLE001
            rapor.append(f"- RET {ad}: [A00] ön bilgi okunamadı ({e})")
            continue
        d = mufredat.get(bilgi.get("ders"), {})
        konu = next((k for k in d.get("konular", []) if k["kod"] == bilgi.get("konu")), {})
        konu = {**konu, "_kaynakli": bool(d.get("kaynak_dosyalari"))}
        h = denetle(bilgi, metin, dersler) + siki_denetle(bilgi, metin, konu)
        if h:
            rapor.append(f"- RET {ad}: " + " | ".join(h))
            continue
        gecen += 1
        rapor.append(f"- geçti {ad} ({len(metin.split())} kelime)")
        if al:
            hedef = klasor(sinav) / bilgi["ders"] / f"{bilgi['konu']}.md"
            if hedef.exists():
                rapor[-1] += " — ATLANDI: bu konunun anlatımı zaten var"
                continue
            hedef.parent.mkdir(parents=True, exist_ok=True)
            hedef.write_text(ham.lstrip("\ufeff").replace("\r\n", "\n"), encoding="utf-8")
    return [f"# Anlatım ön eleme: {teslim.name} — {gecen}/{len(rapor)} geçti", ""] + rapor


def paket_icin(klasor: Path = KLASOR, sinav: str = "smmm") -> tuple[list[dict], list[dict]]:
    """(uygulamaya girecek anlatımlar, elenenler)."""
    dersler = _dersler(sinav)
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


def paket_olustur(ders: str, cikti: Path, sinav: str = "smmm") -> Path:
    """Dış üretici için konu anlatımı paketi: GOREV.md (konular ve kazanımlar), kurallar, örnek ve kaynaklar."""
    import datetime as dt
    import shutil

    from pipeline import uretici_paketi

    from pipeline import harita

    harita.sinav_sec(sinav)
    d = next(x for x in _mufredat(sinav) if x["kod"] == ders)
    hedef = KOK / "content" / "anlatim" / sinav
    mevcut = {p.stem for p in (hedef / ders).glob("*.md")} if (hedef / ders).exists() else set()
    konular = [k for k in d["konular"] if k["kod"] not in mevcut]
    ad = f"anlatim_{'' if sinav == 'smmm' else sinav.upper() + '_'}{ders}-{dt.date.today().isoformat()}-{len(konular)}konu"
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
    kaynaklar = uretici_paketi._kaynak_dosyalari(ders)
    if not kaynaklar:
        from pipeline.ymm_gorev import GENEL_BILGI_NOTU

        satirlar[1:1] = ["", "> **ÖNEMLİ:** " + GENEL_BILGI_NOTU]
        (klasor / "kaynaklar" / "KAYNAK_YOK_OKU.md").write_text("# Bu klasör bilerek boştur\n\n" + GENEL_BILGI_NOTU + "\n",
                                                              encoding="utf-8")
    (klasor / "GOREV.md").write_text("\n".join(satirlar), encoding="utf-8")
    if sinav == "ymm":
        shutil.copy(KOK / "docs/uretici/YMM_ANLATIM_KURALLARI.md", klasor / "ANLATIM_KURALLARI.md")
        shutil.copy(KOK / "docs/uretici/YMM_ANLATIM_PROMPT.md", klasor / "PROMPT.md")
    else:
        shutil.copy(KOK / "docs/uretici/ANLATIM_KURALLARI.md", klasor / "ANLATIM_KURALLARI.md")
        shutil.copy(KOK / "docs/uretici/ANLATIM_PROMPT.md", klasor / "PROMPT.md")
    shutil.copy(KLASOR / "FIN" / "ALC.md", klasor / "ORNEK_ANLATIM.md")
    for kaynak in kaynaklar:
        shutil.copy(kaynak, klasor / "kaynaklar" / kaynak.name)
    zip_yolu = shutil.make_archive(str(klasor), "zip", root_dir=klasor.parent, base_dir=klasor.name)
    return Path(zip_yolu)


def main(argv: list[str]) -> int:
    sinav = argv[argv.index("--sinav") + 1] if "--sinav" in argv else "smmm"
    if len(argv) >= 3 and argv[1] == "paket":
        cikti = Path(argv[argv.index("--cikti") + 1]) if "--cikti" in argv else KOK / "uretici_paketleri"
        for ders in argv[2].split(","):
            print(paket_olustur(ders.upper(), cikti, sinav))
        return 0
    if len(argv) >= 3 and argv[1] == "on_eleme":
        rapor = on_eleme(Path(argv[2]), sinav, al="--al" in argv)
        print("\n".join(rapor))
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
