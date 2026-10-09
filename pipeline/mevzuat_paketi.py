"""Uygulamanın "Mevzuat" bölümü için veri: soruların `kaynaklar` alanından madde bazlı derleme.

- Kanunlarda (pipeline/kaynak.py KANUNLAR) madde metninin tamamı resmî metinden (`madde_getir`) eklenir
  (mevzuat metinleri FSEK md. 31 kapsamında serbestçe çoğaltılabilir).
- Standartlar (TMS/TFRS/BDS/KYS), THP/MSUGT, tebliğ, yönetmelik ve diğer kaynaklarda yalnızca sorulardaki
  birebir `alinti` parçaları verilir; standart metni ASLA eklenmez (telif).
"""

from __future__ import annotations

import re
from collections import defaultdict
from functools import lru_cache

from pipeline import kaynak

MEVZUAT_TARIHI = "2026-10-04"

# Kaynak adı → kanun kodu (pipeline/kaynak.py KANUNLAR). Kodsuz olanlar yalnızca alıntı gösterir.
# Önce resmî adlarla eşleşir (KANUNLAR[kod][1]); aşağıdaki tablo yazım farklarını da kapsar.
AD_KOD = {resmi: kod for kod, (_, resmi) in kaynak.KANUNLAR.items()}
AD_KOD.update({
    "Gelir Vergisi Kanunu": "gvk",
    "Kurumlar Vergisi Kanunu": "kvk",
    "Katma Değer Vergisi Kanunu": "kdvk",
    "Vergi Usul Kanunu": "vuk",
    "Türk Ticaret Kanunu": "ttk",
    "Sermaye Piyasası Kanunu": "spkn",
})

# mevzuat.gov.tr adresi: kod → (MevzuatNo, MevzuatTertip). Değerler content/kaynaklar/mevzuat/KAYNAKLAR.md'deki
# resmî indirme adreslerinden (1.<tertip>.<no>) alınmıştır.
GOV_NO = {
    "gvk": (193, 4), "kvk": (5520, 5), "kdvk": (3065, 5), "vuk": (213, 4), "6183": (6183, 3), "otvk": (4760, 5),
    "dvk": (488, 5), "vivk": (7338, 3), "mtvk": (197, 5), "evk": (1319, 5), "ttk": (6102, 5), "tbk": (6098, 5),
    "isk": (4857, 5), "5510": (5510, 5), "iyuk": (2577, 5), "spkn": (6362, 5), "3568": (3568, 5),
    "6356": (6356, 5), "7036": (7036, 5), "5018": (5018, 5), "492": (492, 5), "2576": (2576, 5),
}

# Aynı belgenin soru dosyalarında farklı yazılışları → tek ad.
AD_ESLEME = {
    "SMMM ve YMM Mesleklerine İlişkin Haksız Rekabet ve Reklam Yasağı Yönetmeliği":
        "Serbest Muhasebeci Mali Müşavirlik ve Yeminli Mali Müşavirlik Mesleklerine İlişkin Haksız Rekabet ve Reklam Yasağı Yönetmeliği",
}

MSUGT = "Muhasebe Sistemi Uygulama Genel Tebliği (Sıra No:1)"

# "md. 26/1-(ç)", "mük. md. 80/1", "md. 32/C-1", "md. 110/A-(1) (Ek: ...)" → ana madde numarası
_MD = re.compile(r"(?P<muk>mük\.\s*)?md\.\s*(?P<no>\d+(?:/[A-ZÇĞİÖŞÜ](?![a-zçğıöşü]))?)")
_PAR = re.compile(r"\bpar(?:ag)?\.\s*(?P<no>A?\d+)")


def kaynak_adi(ad: str) -> str:
    """Kaynak adını tek biçime getirir (boşluklar, MSUGT ek adları, yazım farkları)."""
    ad = " ".join(ad.split())
    if ad.startswith("Muhasebe Sistemi Uygulama Genel Tebliği"):
        return MSUGT
    return AD_ESLEME.get(ad, ad)


def kaynak_turu(ad: str) -> str:
    if ad in AD_KOD and "Kanun" in ad or "sayılı" in ad and "Kanun" in ad and not ad.endswith("Yönetmeliği"):
        return "kanun"
    if re.match(r"(TMS|TFRS|BDS|KYS|SBDS|GDS|İHS)\s", ad):
        return "standart"
    if "Tebliğ" in ad or "Yönergesi" in ad:
        return "teblig"
    if "Yönetmeli" in ad:
        return "yonetmelik"
    return "diger"


def kod_bul(ad: str) -> str | None:
    kod = AD_KOD.get(ad)
    return kod if kod in kaynak.KANUNLAR else None


def madde_normallestir(ham: str, ad: str, kod: str | None) -> tuple[str, str | None]:
    """(görünen madde etiketi, madde_getir anahtarı | None). Örn. 'md. 26/1-(ç)' → ('md. 26', '26')."""
    ham = " ".join(ham.split())
    m = _MD.search(ham)
    if m and (kod or kaynak_turu(ad) in ("yonetmelik", "teblig")):
        no = m.group("no").upper()
        if m.group("muk"):
            return f"mük. md. {no}", f"mükerrer {no}"
        return f"md. {no}", no
    p = _PAR.search(ham)
    if p and kaynak_turu(ad) == "standart":
        return f"par. {p.group('no')}", None
    return ham, None


def ek_etiketi(ham_ad: str) -> str:
    """MSUGT için "Ek-4"/"Ek-5"/"Ek V" ön eki (kaynak adından); yoksa boş."""
    m = re.search(r"Ek[- ]?(4|5|V)\b", ham_ad)
    return {"4": "Ek-4", "5": "Ek-5", "V": "Ek-5"}[m.group(1)] if m else ""


def _baslik_mi(b: str) -> bool:
    """Madde sonuna yapışmış kısa, cümle olmayan satır (bir sonraki maddenin ya da bölümün başlığı)."""
    govde = re.sub(r"^(?:\d+|[IVX]+|[A-ZÇĞİÖŞÜ])\s*[.)-]\s*", "", b)  # "3. Dava şartı…", "II - …", "C) …" numaralandırması
    return len(b) <= 140 and not b.startswith("(") and not re.search(r"[.;,)]$|\.\d+$", b) and ". " not in govde


def _blok_ayir(metin: str) -> tuple[str, list[str]]:
    """Madde metninin sonuna yapışan bölüm/madde başlığı satırlarını ayırır → (temiz metin, sondan başa başlıklar)."""
    bloklar = re.split(r"\n\s*\n", metin.replace("\x0c", "\n").rstrip())
    basliklar: list[str] = []
    while len(bloklar) > 1 and _baslik_mi(" ".join(bloklar[-1].split())):
        basliklar.append(" ".join(bloklar.pop().split()))
    return "\n\n".join(bloklar), basliklar


@lru_cache(maxsize=None)
def _kanun_maddeleri(kod: str) -> dict[str, tuple[str | None, str]]:
    """{anahtar: (başlık | None, temiz metin)}; başlık, önceki maddenin sonuna yapışmış satırdır."""
    sonuc: dict[str, tuple[str | None, str]] = {}
    onceki_baslik = None
    for anahtar, ham in kaynak.maddeler(kod).items():
        metin, basliklar = _blok_ayir(ham)
        sonuc[anahtar] = (onceki_baslik, metin)
        onceki_baslik = None
        if basliklar and not re.search(r"BÖLÜM|KISIM|AYIRIM", basliklar[0]):
            onceki_baslik = re.sub(r"(?<=[a-zçğıöşü])\d+$", "", basliklar[0])  # sondaki dipnot numarası
    return sonuc


def tam_metin_getir(kod: str, anahtar: str) -> tuple[str | None, str]:
    tum = _kanun_maddeleri(kod)
    if anahtar not in tum and "/" in anahtar:  # "5/A" ayrı madde değil, madde içinde bent (ör. 3568 md. 5)
        anahtar = anahtar.split("/")[0]
    return tum[anahtar]


def _ad_anahtari(ad: str) -> str:
    """Yalnız büyük/küçük harf veya şapka (â, î, û) farkı olan adlar aynı kaynaktır: 'Emlâk' = 'Emlak'."""
    return ad.casefold().translate(str.maketrans("âîû", "aiu"))


def kaynaklari_derle(sorular: list[dict], tam_metin_getir=tam_metin_getir) -> list[dict]:
    """Soruların kaynaklarından madde listesi: [{kaynak, tur, kod?, madde, tam_metin?, alintilar, soru_idler, ...}]."""
    gruplar: dict[tuple[str, str], dict] = {}
    ilk_ad: dict[str, str] = {}
    for s in sorular:
        for k in s.get("kaynaklar", []):
            ad = kaynak_adi(k["mevzuat"])
            # Aynı kaynağın yazım farkları (büyük/küçük harf, şapka) ilk görülen adla birleştirilir.
            ad = ilk_ad.setdefault(_ad_anahtari(ad), ad)
            kod = kod_bul(ad)
            etiket, anahtar = madde_normallestir(k["madde"], ad, kod)
            if ad == MSUGT and (ek := ek_etiketi(k["mevzuat"])):
                etiket = f"{ek} · {etiket}"
            g = gruplar.setdefault((ad, etiket), {
                "kaynak": ad, "tur": kaynak_turu(ad), "madde": etiket, "_anahtar": anahtar, "_kod": kod,
                "alintilar": [], "soru_idler": [],
            })
            if s["id"] not in g["soru_idler"]:
                g["soru_idler"].append(s["id"])
            alinti = (k.get("alinti") or "").strip()
            kayit = {"atif": " ".join(k["madde"].split()), "metin": alinti, "soru_id": s["id"]}
            if alinti and not any(a["atif"] == kayit["atif"] and a["metin"] == alinti for a in g["alintilar"]):
                g["alintilar"].append(kayit)

    sonuc = []
    for g in gruplar.values():
        kod, anahtar = g.pop("_kod"), g.pop("_anahtar")
        g["soru_idler"].sort()
        if kod:
            g["kod"] = kod
            if kod in GOV_NO:
                no, tertip = GOV_NO[kod]
                g["mevzuat_gov_url"] = (
                    f"https://www.mevzuat.gov.tr/mevzuat?MevzuatNo={no}&MevzuatTur=1&MevzuatTertip={tertip}")
            if anahtar:
                try:
                    baslik, g["tam_metin"] = tam_metin_getir(kod, anahtar)
                    if baslik:
                        g["baslik"] = baslik
                except (KeyError, FileNotFoundError):
                    pass  # metin dosyası yok / madde bulunamadı: yalnız alıntı gösterilir
        sonuc.append(g)

    sira = {"kanun": 0, "yonetmelik": 1, "teblig": 2, "standart": 3, "diger": 4}
    sonuc.sort(key=lambda g: (sira[g["tur"]], g["kaynak"], _madde_sirasi(g["madde"])))
    return sonuc


def _madde_sirasi(madde: str):
    m = re.search(r"(\d+)(?:/([A-Z]))?", madde)
    return (0, int(m.group(1)), m.group(2) or "", madde) if m else (1, 0, "", madde)


def ozet(maddeler: list[dict]) -> dict:
    kaynaklar = defaultdict(int)
    for m in maddeler:
        kaynaklar[m["kaynak"]] += 1
    return {
        "kaynak": len(kaynaklar),
        "madde": len(maddeler),
        "tam_metinli": sum(1 for m in maddeler if m.get("tam_metin")),
        "yalniz_alinti": sum(1 for m in maddeler if not m.get("tam_metin")),
    }
