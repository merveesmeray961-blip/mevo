"""Mağaza görselleri: uygulama ekran görüntülerini başlıklı Play Store görsellerine çevirir.

Girdi : app/tool/goldens/<urun>_<ekran>.png   (flutter test tool/magaza_gorsel_test.dart --update-goldens)
Çıktı : docs/magaza/gorseller/telefon_N.png (Mizan SMMM), docs/magaza/gorseller_ymm/telefon_N.png (Tasdik YMM)
        1080×1920, dikey gradyan zemin, üstte başlık, ortada telefon çerçevesi içinde ekran.

    python docs/devir/araclar/magaza_gorsel.py [smmm|ymm]
"""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

KOK = Path(__file__).resolve().parents[3]
GIRDI = KOK / "app/tool/goldens"
FONT = KOK / "app/assets/fonts/Roboto-800.ttf"
BOY = (1080, 1920)

URUNLER = {
    "smmm": {
        "cikti": KOK / "docs/magaza/gorseller",
        "ust": (18, 120, 104),
        "alt": (8, 70, 60),
        "ekranlar": [
            ("bugun", "Sınava kaç gün kaldı,\nbugün ne çalışmalısın"),
            ("dersler", "SGS ve Yeterlilik,\nbinlerce özgün soru"),
            ("ders", "Konu konu çalış,\nanlatım ve soru bir arada"),
            ("soru", "Her soruda çözüm ve\ndayanak mevzuat maddesi"),
            ("anlatim", "Konu özetlerini oku\nya da sesli dinle"),
            ("istatistik", "Zayıf konunu gör,\nonu çalış"),
        ],
    },
    "ymm": {
        "cikti": KOK / "docs/magaza/gorseller_ymm",
        "ust": (40, 92, 160),
        "alt": (20, 52, 104),
        "ekranlar": [
            ("bugun", "YMM sınavına\nplanlı hazırlan"),
            ("dersler", "10 ders, test ve\nklasik vaka soruları"),
            ("ders", "Konu konu çalış,\nanlatım ve soru bir arada"),
            ("soru", "Her soruda çözüm ve\ndayanak mevzuat maddesi"),
            ("anlatim", "Konu anlatımları,\nsesli dinleme desteğiyle"),
            ("istatistik", "Zayıf konunu gör,\nonu çalış"),
        ],
    },
}


def gradyan(ust: tuple, alt: tuple) -> Image.Image:
    g = Image.new("RGB", BOY, ust)
    cizim = ImageDraw.Draw(g)
    for y in range(BOY[1]):
        t = y / (BOY[1] - 1)
        cizim.line([(0, y), (BOY[0], y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(ust, alt)))
    return g


def telefon(ekran: Image.Image, genislik: int = 700) -> Image.Image:
    """Ekranı yuvarlatılmış köşeli, koyu çerçeveli bir telefon görseline yerleştirir."""
    oran = ekran.height / ekran.width
    yukseklik = round(genislik * oran)
    ekran = ekran.resize((genislik, yukseklik), Image.LANCZOS).convert("RGB")
    pay = 14
    kaplama = Image.new("RGBA", (genislik + 2 * pay, yukseklik + 2 * pay), (0, 0, 0, 0))
    ImageDraw.Draw(kaplama).rounded_rectangle([0, 0, kaplama.width - 1, kaplama.height - 1], 54, fill=(18, 24, 24, 255))
    maske = Image.new("L", ekran.size, 0)
    ImageDraw.Draw(maske).rounded_rectangle([0, 0, ekran.width - 1, ekran.height - 1], 42, fill=255)
    kaplama.paste(ekran, (pay, pay), maske)
    return kaplama


def uret(urun: str) -> None:
    ayar = URUNLER[urun]
    ayar["cikti"].mkdir(parents=True, exist_ok=True)
    baslik_font = ImageFont.truetype(str(FONT), 76)
    for no, (ekran_adi, baslik) in enumerate(ayar["ekranlar"], 1):
        yol = GIRDI / f"{urun}_{ekran_adi}.png"
        if not yol.exists():
            raise FileNotFoundError(f"{yol} yok; önce ekran görüntülerini üretin (flutter test tool/magaza_gorsel_test.dart)")
        tuval = gradyan(ayar["ust"], ayar["alt"])
        cizim = ImageDraw.Draw(tuval)
        cizim.multiline_text((BOY[0] / 2, 235), baslik, font=baslik_font, fill="white", anchor="mm", align="center", spacing=14)
        tel = telefon(Image.open(yol))
        # Telefon alttan taşar: ekranın üst kısmı görünür, sınır tuvalde kesilir.
        tuval.paste(tel, ((BOY[0] - tel.width) // 2, 430), tel)
        hedef = ayar["cikti"] / f"telefon_{no}.png"
        tuval.save(hedef, optimize=True)
        print("yazıldı:", hedef.relative_to(KOK))


if __name__ == "__main__":
    for u in sys.argv[1:] or list(URUNLER):
        uret(u)
