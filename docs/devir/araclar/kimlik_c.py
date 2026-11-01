"""Yeni görsel kimlik (Yön C — çivit / mürekkep / limon): uygulama simgeleri, Android kaynakları ve mağaza simge/öne çıkan görselleri.

    python docs/devir/araclar/kimlik_c.py

Mizan SMMM: çivit zemin, beyaz "M" (terazi kolu), limon kol + nokta.  Tasdik YMM: mürekkep zemin, beyaz halka, limon onay + kesik halka.
"""
from __future__ import annotations
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

KOK = Path(__file__).resolve().parents[3]
IKON = KOK / "app/assets/ikon"
FONT = KOK / "app/assets/fonts"
CIVIT, MUREKKEP, LIMON, BEYAZ = (75, 63, 224), (17, 24, 39), (200, 240, 74), (255, 255, 255)
S = 4096 / 168  # SVG 168 birimlik tasarımdan 4096 px'e

def _cizgi(d, pts, w, renk):
    pts = [(x * S, y * S) for x, y in pts]
    d.line(pts, fill=renk, width=round(w * S), joint="curve")
    r = w * S / 2
    for x, y in pts:
        d.ellipse([x - r, y - r, x + r, y + r], fill=renk)

def _mizan_glif(d):
    _cizgi(d, [(38, 118), (38, 58), (84, 98), (130, 58), (130, 118)], 13, BEYAZ)
    _cizgi(d, [(30, 44), (138, 44)], 8, LIMON)
    r = 9 * S; d.ellipse([84 * S - r, 40 * S - r, 84 * S + r, 40 * S + r], fill=LIMON)

def _tasdik_glif(d):
    c = 84 * S
    for r, w, renk in [(46, 11, BEYAZ)]:
        R = r * S; d.ellipse([c - R, c - R, c + R, c + R], outline=renk, width=round(w * S))
    R = 60 * S; cevre = 2 * math.pi * 60; adim = 15  # 6 dolu + 9 boş birim
    t = 0.0
    while t < cevre:
        a0, a1 = t / cevre * 360, min(t + 6, cevre) / cevre * 360
        d.arc([c - R, c - R, c + R, c + R], a0 - 90, a1 - 90, fill=LIMON, width=round(4 * S))
        t += adim
    _cizgi(d, [(64, 85), (78, 99), (106, 69)], 12, LIMON)

def simge(zemin, glif, boyut=1024, kose=True):
    im = Image.new("RGBA", (4096, 4096), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    if zemin:
        d.rounded_rectangle([0, 0, 4095, 4095], radius=round(38 * S) if kose else 0, fill=zemin)
    glif(d)
    return im.resize((boyut, boyut), Image.LANCZOS)

def kaydet(im, yol):
    yol.parent.mkdir(parents=True, exist_ok=True); im.save(yol, optimize=True)

def android(res, zemin, glif, renk_hex):
    kare = simge(zemin, glif, 1024, kose=False).convert("RGB")
    for k, b in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        kaydet(kare.resize((b, b), Image.LANCZOS), res / f"mipmap-{k}/ic_launcher.png")
    on = simge(None, glif, 1024)
    for k, b in {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}.items():
        kaydet(on.resize((b, b), Image.LANCZOS), res / f"drawable-{k}/ic_launcher_foreground.png")
    kalip = Image.open(KOK / "app/android/app/src/main/res/drawable-nodpi/launch_logo.png").convert("RGBA")
    logo = simge(zemin, glif, kalip.size[0])
    kaydet(logo, res / "drawable-nodpi/launch_logo.png")
    renkler = res / "values/colors.xml"
    if renkler.exists():
        t = renkler.read_text("utf-8")
        import re
        t = re.sub(r'(<color name="ic_launcher_background">)#[0-9A-Fa-f]{6}', rf"\g<1>{renk_hex}", t)
        t = re.sub(r'(<color name="launch_zemin">)#[0-9A-Fa-f]{6}', r"\g<1>#F4F4F8", t)
        renkler.write_text(t, "utf-8")

def one_cikan(zemin, glif, ad, alt, yol):
    tuval = Image.new("RGB", (1024, 500), zemin)
    tuval.paste(simge(zemin, glif, 300), (90, 100), simge(zemin, glif, 300))
    d = ImageDraw.Draw(tuval)
    d.text((440, 140), ad, font=ImageFont.truetype(str(FONT / "Sora-800.ttf"), 80), fill="white")
    d.text((444, 262), alt, font=ImageFont.truetype(str(FONT / "Sora-500.ttf"), 38), fill=LIMON, spacing=12)
    kaydet(tuval, yol)

def main():
    for ad, zemin, glif, res, renk, png, onp, magaza, baslik, alt in [
        ("smmm", CIVIT, _mizan_glif, KOK / "app/android/app/src/main/res", "#4B3FE0", "ikon.png", "on_plan.png",
         KOK / "docs/magaza/gorseller", "Mizan SMMM", "SGS ve Yeterlilik\nsınav hazırlığı"),
        ("ymm", MUREKKEP, _tasdik_glif, KOK / "app/android/app/src/ymm/res", "#111827", "ikon_ymm.png", "on_plan_ymm.png",
         KOK / "docs/magaza/gorseller_ymm", "Tasdik YMM", "Yeminli Mali Müşavirlik\nsınav hazırlığı"),
    ]:
        kaydet(simge(zemin, glif, 1024).convert("RGB") if False else simge(zemin, glif, 1024, kose=False).convert("RGB"), IKON / png)
        kaydet(simge(None, glif, 1024), IKON / onp)
        android(res, zemin, glif, renk)
        kaydet(simge(zemin, glif, 512, kose=False).convert("RGB"), magaza / "simge_512.png")
        one_cikan(zemin, glif, baslik, alt, magaza / "one_cikan_gorsel_1024x500.png")
        print("tamam", ad)

if __name__ == "__main__":
    main()
