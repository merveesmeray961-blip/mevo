"""G4 — Hesap doğrulama kapısı.

Hesaplama sorularında `dogrulama.python` kodu yalıtılmış bir ad alanında çalıştırılır ve `sonuc` değişkeni
doğru şıkkın sayısal değeriyle karşılaştırılır. Ayrıca hiçbir çeldiricinin aynı değeri taşımadığı denetlenir.

Kodda yalnızca aritmetik ve `round`, `min`, `max`, `abs`, `sum` kullanılabilir; içe aktarma yapılamaz.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

IZINLI = {"round": round, "min": min, "max": max, "abs": abs, "sum": sum, "range": range, "len": len}
SAYI = re.compile(r"-?\d[\d.]*(?:,\d+)?")
TOLERANS = 0.005


@dataclass
class Sonuc:
    soru_id: str
    hatalar: list[str] = field(default_factory=list)
    hesaplanan: float | None = None

    @property
    def gecti(self) -> bool:
        return not self.hatalar


def sayiya_cevir(metin: str) -> float | None:
    """'1.250.000 ₺' → 1250000 · '%12,50' → 12.5 · '0,875' → 0.875. Şıkta tek sayı yoksa None."""
    bulunan = SAYI.findall(metin.replace(" ", " "))
    if len(bulunan) != 1:
        return None
    ham = bulunan[0]
    if "," in ham:
        ham = ham.replace(".", "").replace(",", ".")
    elif ham.count(".") >= 1 and all(len(p) == 3 for p in ham.split(".")[1:]):
        ham = ham.replace(".", "")  # binlik ayırıcı
    try:
        return float(ham)
    except ValueError:
        return None


def calistir(kod: str) -> float:
    if re.search(r"\b(import|open|exec|eval|__)", kod):
        raise ValueError("doğrulama kodunda izin verilmeyen ifade")
    ad_alani: dict = {}
    exec(kod, {"__builtins__": IZINLI}, ad_alani)  # noqa: S102 — yalnız kendi ürettiğimiz kod, kısıtlı builtins
    if "sonuc" not in ad_alani:
        raise ValueError("doğrulama kodu 'sonuc' değişkenini atamıyor")
    return float(ad_alani["sonuc"])


def esit(a: float, b: float) -> bool:
    return abs(a - b) <= max(TOLERANS, abs(b) * 1e-9)


def soru_denetle(soru: dict) -> Sonuc:
    sonuc = Sonuc(soru_id=str(soru.get("id")))
    dogrulama = soru.get("dogrulama")
    if soru.get("tip") != "hesaplama":
        return sonuc
    if not dogrulama:
        sonuc.hatalar.append("hesaplama sorusunda 'dogrulama.python' yok")
        return sonuc
    try:
        sonuc.hesaplanan = calistir(dogrulama["python"])
    except Exception as hata:  # noqa: BLE001
        sonuc.hatalar.append(f"doğrulama kodu çalışmadı: {hata}")
        return sonuc

    if not dogrulama.get("secenek_sayisi_bekleniyor", True):
        return sonuc

    degerler = {h: sayiya_cevir(m) for h, m in soru["secenekler"].items()}
    dogru_deger = degerler.get(soru["dogru"])
    if dogru_deger is None:
        sonuc.hatalar.append("doğru şıkta tek bir sayısal değer okunamadı")
        return sonuc
    if not esit(sonuc.hesaplanan, dogru_deger):
        sonuc.hatalar.append(f"hesaplanan {sonuc.hesaplanan:g} ≠ doğru şık {dogru_deger:g}")
    for harf, deger in degerler.items():
        if harf != soru["dogru"] and deger is not None and esit(deger, sonuc.hesaplanan):
            sonuc.hatalar.append(f"çeldirici {harf} de hesaplanan değere eşit ({deger:g})")
    sirali = [degerler[h] for h in "ABCDE"]
    if all(d is not None for d in sirali) and sirali != sorted(sirali) and sirali != sorted(sirali, reverse=True):
        sonuc.hatalar.append("sayısal şıklar sıralı değil (gerçek sınavda her zaman sıralı)")
    return sonuc
