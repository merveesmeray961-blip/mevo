"""Soru bankasını önizleme uygulamasının okuduğu tek bir JSON dosyasına aktarır.

Yalnızca G2 ve G4'ten geçen ve `durum` değeri taslak/geri_cekildi olmayan sorular aktarılır.
Müfredattan ders ve konu adları, sınav ayarlarından format bilgisi eklenir.

Kullanım:
    python -m pipeline.disa_aktar web/onizleme/sorular.json                 (uzman önizlemesi, açıklama olduğu gibi)
    python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama  (mobil uygulama paketi)
"""

from __future__ import annotations

import json
import re
import sys
from datetime import date
from pathlib import Path

import yaml

from pipeline import g2_yapi, g4_hesap, mevzuat_paketi

KOK = g2_yapi.KOK
AKTARILAN_DURUMLAR = {"kontrolde", "onayli", "yayinda"}

# Zor sorularda dogru_neden'e eklenen teknik/tuzak notu uygulamada ayrı bir "püf noktaları" bölümünde gösterilir.
# Üretimde kullanılmış etiket yazılışları; yenileri eklenirse tests/test_g4_g7.py'deki örneklere de eklenmeli.
PUF_ETIKETI = re.compile(
    r"\s*(?:Bu soru zor düzeydedir;\s*)?(?:Kullanılan teknikler|kullanılan teknikler|Zor soru teknikleri"
    r"|Zorluk \(\d\) kaynakları|Zor soru; \w+ teknik birlikte kullanılır|Püf noktaları)\s*:\s*"
)


def yeniden_denetim_bekleyen(soru: dict) -> bool:
    """Düzeltilip G3/G5/G6/GZ kapıları sıfırlanmış (hakem denetimi bekleyen) taslak soru.

    Daha önce yayımlanmış bir sorunun düzeltmesi bekleme süresince paketten düşmesin diye pakete ve uzman
    kitapçığına girer; hiç denetlenmemiş yeni taslaklar (gecmis kaydı yok) girmez.
    """
    kapilar = soru.get("uretim", {}).get("kapilar", {})
    return (soru.get("durum") == "taslak" and bool(soru.get("gecmis"))
            and any(k.get("sonuc") == "bekliyor" for k in kapilar.values()))


def _ilk_cumle_sonu(metin: str) -> int:
    """Parantez dışındaki ilk '. ' + büyük harf sınırının konumu; yoksa metnin sonu."""
    derinlik = 0
    for i, c in enumerate(metin):
        if c == "(":
            derinlik += 1
        elif c == ")":
            derinlik = max(0, derinlik - 1)
        elif c == "." and derinlik == 0 and metin[i + 1 : i + 2] == " " and metin[i + 2 : i + 3].isupper():
            return i + 1
    return len(metin)


def aciklama_ayir(aciklama: dict) -> dict:
    metin = aciklama["dogru_neden"]
    m = PUF_ETIKETI.search(metin)
    if not m:
        return aciklama
    if metin[: m.start()].strip():
        once, puf = metin[: m.start()], metin[m.end() :]
    else:  # not açıklamanın başında: yalnız ilk cümle ayrılır, açıklamanın gerisi yerinde kalır
        son = m.end() + _ilk_cumle_sonu(metin[m.end() :])
        once, puf = metin[son:], metin[m.end() : son]
    return {**aciklama, "dogru_neden": once.strip(), "puf_noktalari": puf.strip()}


def aktar(hedef: Path, durumlar: set[str] = AKTARILAN_DURUMLAR, puf_ayir: bool = False) -> dict:
    mufredat = yaml.safe_load((KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    sinav = yaml.safe_load((KOK / "content/sinavlar/smmm.yaml").read_text(encoding="utf-8"))
    kayitlar = g2_yapi.dosyalari_yukle(KOK / "content/sorular/smmm")

    dersler = {
        d["kod"]: {
            "ad": d["ad"],
            "sgs_ad": d.get("sgs_ad", d["ad"]),
            "soru": d["soru"],
            "notlar": d.get("notlar", []),
            "konular": {k["kod"]: k["ad"] for k in d["konular"]},
        }
        for d in mufredat["dersler"]
    }

    sorular, elenen = [], []
    for _, soru in kayitlar:
        if soru.get("durum") not in durumlar and not yeniden_denetim_bekleyen(soru):
            continue
        hatalar = g2_yapi.soru_denetle(soru).hatalar + g4_hesap.soru_denetle(soru).hatalar
        if hatalar:
            elenen.append({"id": soru.get("id"), "hatalar": hatalar})
            continue
        sorular.append({
            "id": soru["id"],
            "surum": soru["surum"],
            "bolum": soru["bolum"],
            "ders": soru["ders"],
            "konu": soru["konu"],
            "kazanim": soru["kazanim"],
            "tip": soru["tip"],
            "zorluk": soru["zorluk"],
            "kok": soru["kok"],
            "secenekler": soru["secenekler"],
            "dogru": soru["dogru"],
            "aciklama": aciklama_ayir(soru["aciklama"]) if puf_ayir else soru["aciklama"],
            "kaynaklar": soru["kaynaklar"],
            "kapilar": {k: v.get("sonuc") for k, v in soru.get("uretim", {}).get("kapilar", {}).items()},
        })

    paket = {
        "olusturma": str(date.today()),
        "uyari": sinav["resmi_baglanti_yok_ibaresi"],
        "formatlar": {b["kod"]: b for b in sinav["bolumler"]},
        "takvim": {yil.removeprefix("takvim_"): t for yil, t in sinav.items() if yil.startswith("takvim_") and t},
        "dersler": dersler,
        "sorular": sorular,
    }
    if puf_ayir:  # uygulama paketi: "Mevzuat" bölümü (yalnız sorularda atıf yapılan maddeler)
        paket["mevzuat_tarihi"] = mevzuat_paketi.MEVZUAT_TARIHI
        paket["mevzuat"] = mevzuat_paketi.kaynaklari_derle(sorular)
    hedef.parent.mkdir(parents=True, exist_ok=True)
    hedef.write_text(json.dumps(paket, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    return {"aktarilan": len(sorular), "elenen": elenen, "mevzuat": paket.get("mevzuat", [])}


def main(argv: list[str]) -> int:
    puf_ayir = "--uygulama" in argv
    yollar = [a for a in argv[1:] if not a.startswith("--")]
    hedef = Path(yollar[0]) if yollar else KOK / "web/onizleme/sorular.json"
    sonuc = aktar(hedef, puf_ayir=puf_ayir)
    print(f"{sonuc['aktarilan']} soru aktarıldı → {hedef}")
    if sonuc["mevzuat"]:
        o = mevzuat_paketi.ozet(sonuc["mevzuat"])
        print(f"  Mevzuat: {o['kaynak']} kaynak, {o['madde']} madde ({o['tam_metinli']} tam metin, {o['yalniz_alinti']} yalnız alıntı)")
    for e in sonuc["elenen"]:
        print(f"  ELENDİ {e['id']}: {'; '.join(e['hatalar'])}")
    return 1 if sonuc["elenen"] else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
