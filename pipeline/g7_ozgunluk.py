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
    def klasorden(cls, klasor: Path) -> "Kulliyat":
        k = cls()
        for yol in sorted(Path(klasor).glob("*.txt")):
            k.parca_kumesi |= parcalar(yol.read_text(encoding="utf-8", errors="ignore"))
        return k


def kapsanma(soru_parcalari: set, hedef: set) -> float:
    return len(soru_parcalari & hedef) / len(soru_parcalari) if soru_parcalari else 0.0


def banka_denetle(sorular: list[dict], kulliyat: Kulliyat | None) -> dict[str, list[str]]:
    """{soru_id: [hata, ...]} — yalnız hatası olanlar."""
    hatalar: dict[str, list[str]] = {}
    tum = [(str(s.get("id")), parcalar(soru_metni(s))) for s in sorular]
    for i, (sid, p) in enumerate(tum):
        if kulliyat is not None:
            oran = kapsanma(p, kulliyat.parca_kumesi)
            if oran > ESIK_KULLIYAT:
                hatalar.setdefault(sid, []).append(f"çıkmış sorulara benzerlik %{oran * 100:.0f} (sınır %{ESIK_KULLIYAT * 100:.0f})")
        for sid2, p2 in tum[i + 1:]:
            oran = kapsanma(p, p2)
            if oran > ESIK_BANKA:
                hatalar.setdefault(sid, []).append(f"{sid2} ile benzerlik %{oran * 100:.0f}")
    return hatalar
