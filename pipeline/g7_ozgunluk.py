"""G7 — Özgünlük kapısı.

Her sorunun kök + şık metninden kelime 6'lıları (shingle) çıkarılır ve
(a) çıkmış soru külliyatına (depoya alınmayan, yerel klasördeki kitapçık metinleri),
(b) bankadaki diğer sorulara karşı "kapsanma oranı" hesaplanır.

Kapsanma = sorunun 6'lılarından külliyatta da geçenlerin oranı. Eşik üstü soru yeniden yazılmak üzere kalır.
"""

from __future__ import annotations

import re
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path

N = 6
ESIK_KULLIYAT = 0.20
ESIK_BANKA = 0.50


def _kelimeler(metin: str) -> list[str]:
    metin = unicodedata.normalize("NFKC", metin).casefold()
    return re.findall(r"[0-9a-zçğıöşüâîû]+", metin)


def parcalar(metin: str, n: int = N) -> set[tuple[str, ...]]:
    k = _kelimeler(metin)
    return {tuple(k[i:i + n]) for i in range(len(k) - n + 1)}


def soru_metni(soru: dict) -> str:
    return " ".join([soru.get("kok", ""), *soru.get("secenekler", {}).values()])


@dataclass
class Kulliyat:
    parca_kumesi: set[tuple[str, ...]] = field(default_factory=set)

    @classmethod
    def klasorden(cls, klasor: Path, serbest_metin_klasorleri: tuple[Path, ...] = ()) -> "Kulliyat":
        """Çıkmış soru metinlerinden 6'lıları toplar.

        `serbest_metin_klasorleri` (kanun, yönetmelik, standart metinleri) içinde de geçen 6'lılar çıkarılır:
        mevzuat FSEK m.31 gereği serbesttir; telif riski yalnızca sınav yazarının kendi ifadelerindedir.
        """
        k = cls()
        for yol in sorted(Path(klasor).glob("*.txt")):
            k.parca_kumesi |= parcalar(yol.read_text(encoding="utf-8", errors="ignore"))
        for serbest in serbest_metin_klasorleri:
            for yol in sorted(Path(serbest).glob("*.txt")):
                k.parca_kumesi -= parcalar(yol.read_text(encoding="utf-8", errors="ignore"))
        return k


def kapsanma(soru_parcalari: set, hedef: set) -> float:
    return len(soru_parcalari & hedef) / len(soru_parcalari) if soru_parcalari else 0.0


def banka_denetle(sorular: list[dict], kulliyat: Kulliyat | None) -> dict[str, list[str]]:
    """{soru_id: [hata, ...]} — yalnız hatası olanlar."""
    hatalar: dict[str, list[str]] = {}
    # Aynı ortak veri bloğuna (ör. FTA tabloları) bağlı sorular tabloyu bilerek tekrarlar; birbirleriyle karşılaştırılmaz.
    tum = [(str(s.get("id")), parcalar(soru_metni(s)), s.get("ortak_veri")) for s in sorular]
    for i, (sid, p, ortak) in enumerate(tum):
        if kulliyat is not None:
            oran = kapsanma(p, kulliyat.parca_kumesi)
            if oran > ESIK_KULLIYAT:
                hatalar.setdefault(sid, []).append(f"çıkmış sorulara benzerlik %{oran * 100:.0f} (sınır %{ESIK_KULLIYAT * 100:.0f})")
        for sid2, p2, ortak2 in tum[i + 1:]:
            if ortak and ortak == ortak2:
                continue
            oran = kapsanma(p, p2)
            if oran > ESIK_BANKA:
                hatalar.setdefault(sid, []).append(f"{sid2} ile benzerlik %{oran * 100:.0f}")
    return hatalar
