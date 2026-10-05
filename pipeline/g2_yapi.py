"""G2 — Yapısal kalite kapısı.

Soru dosyalarını (YAML) şemaya ve docs/PLAN.md §4.2 yazım kurallarına göre denetler.
Hata (error) içeren soru kapıdan geçemez; uyarılar (warning) uzman incelemesine işaretlenir.

Kullanım:
    python -m pipeline.g2_yapi content/sorular/smmm
"""

from __future__ import annotations

import json
import re
import sys
import unicodedata
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator

KOK = Path(__file__).resolve().parent.parent
SEMA = json.loads((KOK / "content/schema/soru.schema.json").read_text(encoding="utf-8"))
SIKLAR = ("A", "B", "C", "D", "E")

# Olumsuz kök ifadeleri: soruda geçiyorsa **kalın** yazılmış olmalı.
OLUMSUZ = re.compile(
    r"(?<!\*\*)\b(değildir|yanlıştır|olamaz|yoktur|bulunmaz|giremez|edilemez|yapılamaz|"
    r"aykırıdır|söylenemez|hangisi değil)\b(?!\*\*)",
    re.IGNORECASE,
)
HEPSI_HICBIRI = re.compile(r"\b(hepsi|hiçbiri|tümü|yukarıdakilerin)\b", re.IGNORECASE)

# Yayına girmeden önce geçilmesi zorunlu kapılar (G9 yayın sonrasıdır).
ZORUNLU_KAPILAR = ("G0", "G1", "G2", "G3", "G5", "G6", "G7", "G8")


@dataclass
class Sonuc:
    dosya: str
    soru_id: str
    hatalar: list[str] = field(default_factory=list)
    uyarilar: list[str] = field(default_factory=list)

    @property
    def gecti(self) -> bool:
        return not self.hatalar


def _normal(metin: str) -> str:
    metin = unicodedata.normalize("NFKC", metin).casefold()
    return re.sub(r"[\s\.,;:]+", " ", metin).strip()


def soru_denetle(soru: dict, dosya: str = "") -> Sonuc:
    sonuc = Sonuc(dosya=dosya, soru_id=str(soru.get("id", "?")))

    for hata in Draft202012Validator(SEMA).iter_errors(soru):
        yol = "/".join(str(p) for p in hata.absolute_path) or "(kök)"
        sonuc.hatalar.append(f"şema: {yol}: {hata.message}")
    if sonuc.hatalar:
        return sonuc  # Şema bozuksa diğer kontroller anlamsız

    secenekler = soru["secenekler"]
    dogru = soru["dogru"]

    # Şıklar birbirinden farklı olmalı
    normaller = Counter(_normal(v) for v in secenekler.values())
    for metin, adet in normaller.items():
        if adet > 1:
            sonuc.hatalar.append(f"aynı şık metni {adet} kez geçiyor: '{metin}'")

    # Açıklama tam olarak dört çeldiriciyi kapsamalı
    celdiriciler = set(soru["aciklama"]["celdiriciler"])
    beklenen = set(SIKLAR) - {dogru}
    if celdiriciler != beklenen:
        eksik = sorted(beklenen - celdiriciler)
        fazla = sorted(celdiriciler - beklenen)
        sonuc.hatalar.append(f"çeldirici açıklamaları uyumsuz (eksik: {eksik}, fazla: {fazla})")

    # Olumsuz kök vurgulanmalı (yalnız soru cümlesinde; olay anlatımındaki "değildir" sayılmaz)
    if OLUMSUZ.search(re.split(r"(?<=[.!])\s+", soru["kok"].strip())[-1]):
        sonuc.hatalar.append("olumsuz kök ifadesi **kalın** yazılmamış")

    # Hesaplama soruları adım adım çözüm içermeli
    if soru["tip"] == "hesaplama" and not soru["aciklama"].get("hesap_adimlari"):
        sonuc.hatalar.append("hesaplama sorusunda 'hesap_adimlari' yok")

    # Yıla bağlı tutar varsa yıl belirtilmeli
    gecerlilik = soru["gecerlilik"]
    if gecerlilik.get("yila_bagli_tutar") and not gecerlilik.get("yil"):
        sonuc.hatalar.append("yıla bağlı tutar işaretli ama 'yil' belirtilmemiş")

    # Yayındaki soru tüm zorunlu kapılardan geçmiş olmalı
    if soru["durum"] in ("onayli", "yayinda"):
        kapilar = soru["uretim"].get("kapilar", {})
        eksik_kapilar = [k for k in ZORUNLU_KAPILAR if kapilar.get(k, {}).get("sonuc") != "gecti"]
        if eksik_kapilar:
            sonuc.hatalar.append(f"'{soru['durum']}' durumunda ama geçilmemiş kapılar: {eksik_kapilar}")

    # Uyarılar (uzman incelemesine işaret)
    uzunluklar = {k: len(v) for k, v in secenekler.items()}
    en_uzun = max(uzunluklar.values())
    if uzunluklar[dogru] == en_uzun and list(uzunluklar.values()).count(en_uzun) == 1:
        ikinci = sorted(uzunluklar.values())[-2]
        if uzunluklar[dogru] > ikinci * 1.3:
            sonuc.uyarilar.append("doğru şık belirgin biçimde en uzun şık (ipucu riski)")

    return sonuc


@dataclass
class BankaRaporu:
    sonuclar: list[Sonuc]
    banka_hatalari: list[str] = field(default_factory=list)
    banka_uyarilari: list[str] = field(default_factory=list)

    @property
    def gecti(self) -> bool:
        return not self.banka_hatalari and all(s.gecti for s in self.sonuclar)


def banka_denetle(sorular: list[tuple[str, dict]]) -> BankaRaporu:
    rapor = BankaRaporu(sonuclar=[soru_denetle(s, d) for d, s in sorular])

    idler = Counter(str(s.get("id")) for _, s in sorular)
    for soru_id, adet in idler.items():
        if adet > 1:
            rapor.banka_hatalari.append(f"kimlik tekrarı: {soru_id} ({adet} kez)")

    kokler = Counter(_normal(str(s.get("kok", ""))) for _, s in sorular)
    for kok, adet in kokler.items():
        if adet > 1:
            rapor.banka_hatalari.append(f"aynı soru kökü {adet} kez: '{kok[:60]}…'")

    gecerli = [s for _, s in sorular if isinstance(s.get("secenekler"), dict)]
    if gecerli:
        hepsi_hicbiri = sum(
            1 for s in gecerli if any(HEPSI_HICBIRI.search(v) for v in s["secenekler"].values())
        )
        oran = hepsi_hicbiri / len(gecerli)
        if oran > 0.05:
            rapor.banka_uyarilari.append(f"'hepsi/hiçbiri' içeren soru oranı %{oran * 100:.1f} (sınır %5)")

    # Doğru şık harf dağılımı (anlamlı örneklem için en az 50 soru)
    if len(gecerli) >= 50:
        dagilim = Counter(s.get("dogru") for s in gecerli)
        beklenen = len(gecerli) / 5
        for harf in SIKLAR:
            if abs(dagilim.get(harf, 0) - beklenen) > beklenen * 0.25:
                rapor.banka_uyarilari.append(
                    f"doğru şık dağılımı dengesiz: {dict(sorted(dagilim.items()))}"
                )
                break

    return rapor


def dosyalari_yukle(klasor: Path, okunamayan: list[tuple[str, str]] | None = None) -> list[tuple[str, dict]]:
    """Klasördeki tüm soru dosyalarını yükler.

    `okunamayan` verilirse YAML'ı bozuk dosyalar atlanır ve (dosya, hata) olarak bu listeye eklenir
    (ör. başka bir yazarın üzerinde çalıştığı yarım dosya); verilmezse hata yükseltilir.
    """
    sorular = []
    for yol in sorted(klasor.rglob("*.yaml")):
        try:
            icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        except yaml.YAMLError as hata:
            if okunamayan is None:
                raise
            okunamayan.append((str(yol), str(hata).splitlines()[0]))
            continue
        kayitlar = icerik if isinstance(icerik, list) else [icerik]
        sorular.extend((str(yol.relative_to(KOK) if yol.is_relative_to(KOK) else yol), k) for k in kayitlar)
    return sorular


def main(argv: list[str]) -> int:
    klasor = Path(argv[1]) if len(argv) > 1 else KOK / "content/sorular"
    rapor = banka_denetle(dosyalari_yukle(klasor))

    for s in rapor.sonuclar:
        if s.hatalar or s.uyarilar:
            print(f"\n{s.soru_id} ({s.dosya})")
            for h in s.hatalar:
                print(f"  HATA   {h}")
            for u in s.uyarilar:
                print(f"  UYARI  {u}")
    for h in rapor.banka_hatalari:
        print(f"BANKA HATA   {h}")
    for u in rapor.banka_uyarilari:
        print(f"BANKA UYARI  {u}")

    gecen = sum(1 for s in rapor.sonuclar if s.gecti)
    print(f"\nG2: {gecen}/{len(rapor.sonuclar)} soru geçti — {'GEÇTİ' if rapor.gecti else 'KALDI'}")
    return 0 if rapor.gecti else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
