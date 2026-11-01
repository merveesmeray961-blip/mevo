"""Kaynak getirme: dersin resmî metinlerinden kazanımla en ilgili parçalar (BM25, madde başlıklı).

Kanun/yönetmelik metinleri madde madde, diğerleri (TMS, BDS, tebliğ) paragraf bloklarıyla bölünür.
Her parça: {pid, dosya, baslik, metin}. Seçilen parçalar istemde [P1] … [Pn] olarak numaralanır.
"""
from __future__ import annotations

import math
import re
from collections import Counter
from functools import lru_cache
from pathlib import Path

KOK = Path(__file__).resolve().parents[2]
MEVZUAT = KOK / "content/kaynaklar/mevzuat"

BASLIK = re.compile(r"^\s*((?:Mükerrer|MÜKERRER|Geçici|GEÇİCİ|Ek|EK)\s+)?(?:Madde|MADDE)\s+(\d+(?:/[A-Za-zÇĞİÖŞÜ])?)\s*[-–—]",
                    re.MULTILINE)
PARCA_UZ = 1800  # karakter
DURAK = set("ve veya ile bir bu da de için olan olarak ilgili göre her en çok daha gibi kadar ise ki ya mı mi "
            "hangisi aşağıdakilerden şekilde edilir yapılır olur".split())


def _norm(t: str) -> str:
    return t.replace("İ", "i").replace("I", "ı").lower()


def kelimeler(t: str) -> list[str]:
    return [w[:6] for w in re.findall(r"[0-9a-zçğıöşüâîû]+", _norm(t)) if w not in DURAK and (len(w) > 2 or w.isdigit())]


def sikistir(t: str) -> str:
    t = re.sub(r"[ \t\u00a0]+", " ", t)
    t = re.sub(r" ?\n ?", "\n", t)
    return re.sub(r"\n{3,}", "\n\n", t).strip()


def _bol(metin: str, dosya: str) -> list[dict]:
    parcalar = [p for p in _bol_ham(metin, dosya)]
    for p in parcalar:
        p["metin"] = sikistir(p["metin"])
    return [p for p in parcalar if len(p["metin"]) > 40 and p["metin"].count("....") < 4]


def _bol_ham(metin: str, dosya: str) -> list[dict]:
    basliklar = list(BASLIK.finditer(metin))
    parcalar = []
    if len(basliklar) >= 8:  # kanun / yönetmelik: madde madde
        if basliklar[0].start() > 200:
            basliklar = [None] + basliklar
        for i, m in enumerate(basliklar):
            bas = m.start() if m else 0
            son = basliklar[i + 1].start() if i + 1 < len(basliklar) else len(metin)
            govde = metin[bas:son].strip()
            baslik = (f"{(m.group(1) or '').strip()} Madde {m.group(2)}".strip() if m else "Giriş")
            j, k = 0, 0
            while j < len(govde):
                son_ = j + PARCA_UZ
                if son_ < len(govde):
                    kes = govde.rfind("\n", j + PARCA_UZ // 2, son_)
                    son_ = kes if kes > 0 else son_
                parcalar.append({"dosya": dosya, "baslik": baslik + (f" (devam {k})" if k else ""),
                                 "madde": m.group(2) if m else None, "metin": govde[j:son_]})
                j, k = son_, k + 1
        return parcalar
    # Tebliğ / standart: satır satır; bölüm başlığı (GUT "5.7.2.", "II/A-8.1") ve paragraf no (TMS "85") izlenir.
    blok, uz, bolum, ilk_par, son_par = [], 0, "", None, None

    def kapat():
        if blok:
            b = " · ".join(x for x in (bolum, f"par. {ilk_par}" + (f"–{son_par}" if son_par and son_par != ilk_par else "")
                                       if ilk_par else "") if x)
            parcalar.append({"dosya": dosya, "baslik": b, "madde": None, "metin": "\n".join(blok).strip()})

    for satir in metin.splitlines():
        h = BOLUM.match(satir)
        p = PARAGRAF.match(satir)
        sinir = (not satir.strip()) or h or p
        if sinir and uz > PARCA_UZ:
            kapat()
            blok, uz, ilk_par, son_par = [], 0, None, None
        if h:
            bolum = " ".join(satir.split())[:70]
        if p:
            ilk_par = ilk_par or p.group(1)
            son_par = p.group(1)
        if uz > 2 * PARCA_UZ:  # sınırsız uzun blok
            kapat()
            blok, uz, ilk_par, son_par = [], 0, None, None
        blok.append(satir.rstrip())
        uz += len(" ".join(satir.split())) + 1
    kapat()
    return parcalar


BOLUM = re.compile(r"^\s*(?:[IVX]+/[A-Z](?:-\d+(?:\.\d+)*)?\.?|\d+\.\d+(?:\.\d+)*\.?)\s+[A-ZÇĞİÖŞÜ]")
PARAGRAF = re.compile(r"^([A-Z]{0,2}\d{1,3}[A-Z]?)\.?\s{2,}\S")


@lru_cache(maxsize=None)
def dosya_parcalari(stem: str) -> tuple:
    metin = (MEVZUAT / f"{stem}.txt").read_text(encoding="utf-8", errors="ignore")
    return tuple(_bol(metin, stem))


def dosyalar(onekler: list[str]) -> list[str]:
    return sorted(p.stem for p in MEVZUAT.glob("*.txt") if any(p.stem.startswith(o) for o in onekler))


class Dizin:
    def __init__(self, onekler: list[str]):
        self.parcalar = [p for d in dosyalar(onekler) for p in dosya_parcalari(d)]
        self.tf = [Counter(kelimeler(p["baslik"] + " " + p["metin"])) for p in self.parcalar]
        self.uz = [sum(t.values()) for t in self.tf]
        self.ort = (sum(self.uz) / len(self.uz)) if self.uz else 1
        df = Counter(w for t in self.tf for w in t)
        n = len(self.tf)
        self.idf = {w: math.log(1 + (n - c + 0.5) / (c + 0.5)) for w, c in df.items()}

    def ara(self, sorgu: str, butce: int = 22000, en_cok: int = 14, dosya_bonus: dict | None = None) -> list[dict]:
        if not self.parcalar:
            return []
        q = Counter(kelimeler(sorgu))
        k1, b = 1.4, 0.75
        puan = []
        for i, t in enumerate(self.tf):
            s = 0.0
            for w, qn in q.items():
                f = t.get(w)
                if f:
                    s += qn * self.idf[w] * f * (k1 + 1) / (f + k1 * (1 - b + b * self.uz[i] / self.ort))
            if s and dosya_bonus:
                s *= dosya_bonus.get(self.parcalar[i]["dosya"], 1.0)
            puan.append((s, i))
        puan.sort(reverse=True)
        secilen, top = [], 0
        for s, i in puan:
            if s <= 0 or len(secilen) >= en_cok:
                break
            p = self.parcalar[i]
            if top + len(p["metin"]) > butce:
                continue
            secilen.append(dict(p, puan=round(s, 2)))
            top += len(p["metin"])
        return secilen


_DIZIN: dict = {}


def dizin(onekler: list[str]) -> Dizin:
    k = tuple(onekler)
    if k not in _DIZIN:
        _DIZIN[k] = Dizin(onekler)
    return _DIZIN[k]


def dosya_bonusu(sorgu: str, onekler: list[str]) -> dict:
    """Sorguda dosya adı geçiyorsa (ör. 'TFRS 16', 'BDS 500', 'KDV') o dosyaya ağırlık ver."""
    s = _norm(sorgu)
    bonus = {}
    for d in dosyalar(onekler):
        m = re.match(r"(tms|tfrs|bds|sbds|gds|kys|ihs|tsrs)_(\d+)", d)
        if m and re.search(rf"\b{m.group(1)}\s*{m.group(2)}\b", s):
            bonus[d] = 4.0
    anahtar = {"kdv": ("kdvk", "kdv_gut"), "ötv": ("otvk", "otv_"), "damga": ("dvk",), "harç": ("harclar",),
               "emlak": ("evk",), "veraset": ("vivk",), "motorlu": ("mtvk",), "gelir vergisi": ("gvk",),
               "kurumlar vergisi": ("kvk", "kv_"), "tekdüzen": ("msugt",), "hesap planı": ("msugt",),
               "bobi": ("bobi_frs",), "kavramsal": ("kavramsal_cerceve",), "anonim": ("ttk",), "limited": ("ttk",),
               "iş sözleşme": ("isk",), "kıdem": ("isk",), "sigorta": ("sgk",), "idari yargı": ("iyuk",),
               "borçlar": ("tbk",), "kira": ("tbk",), "sermaye piyasası": ("spkn",), "aklama": ("aklama_5549",),
               "disiplin": ("disiplin_yon",), "gümrük": ("gumruk",), "kambiyo": ("kambiyo_", "tpkk_")}
    for k, onek in anahtar.items():
        if k in s:
            for d in dosyalar(onekler):
                if any(d.startswith(o) for o in onek):
                    bonus[d] = max(bonus.get(d, 1.0), 2.0)
    return bonus


def getir(onekler: list[str], sorgu: str, butce: int = 22000) -> list[dict]:
    dz = dizin(onekler)
    return dz.ara(sorgu, butce=butce, dosya_bonus=dosya_bonusu(sorgu, onekler))


def bicimle(parcalar: list[dict]) -> str:
    return "\n\n".join(f"[P{i}] ({p['dosya']} · {p['baslik']})\n{p['metin']}" for i, p in enumerate(parcalar, 1))
