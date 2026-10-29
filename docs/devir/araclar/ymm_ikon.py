"""Tasdik YMM uygulamasının simgesini ve açılış görselini SMMM simgesinden türetir.

SMMM simgesi: koyu yeşil zemin, beyaz tik + açık kitap + "SMMM" yazısı. YMM sürümü aynı çizimi korur, yazıyı "YMM"
yapar ve zemini maviye çevirir. Çıktılar:

    app/assets/ikon/ikon_ymm.png, on_plan_ymm.png        (kaynak görseller, 1024 px)
    app/android/app/src/ymm/res/...                      (Android: eski simgeler, uyarlanabilir ön plan, açılış logosu)
    docs/magaza/gorseller_ymm/simge_512.png, one_cikan_gorsel_1024x500.png   (Google Play görselleri)

Kullanım (depo kökünden):  python docs/devir/araclar/ymm_ikon.py
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

KOK = Path(__file__).resolve().parents[3]
IKON = KOK / "app/assets/ikon"
RES_SMMM = KOK / "app/android/app/src/main/res"
RES_YMM = KOK / "app/android/app/src/ymm/res"
MAGAZA = KOK / "docs/magaza/gorseller_ymm"
FONT_800 = KOK / "app/assets/fonts/Roboto-800.ttf"
FONT_500 = KOK / "app/assets/fonts/Roboto-500.ttf"

SMMM_ZEMIN = (15, 107, 92)  # #0F6B5C
YMM_ZEMIN = (31, 78, 140)  # #1F4E8C (app/lib/urun.dart ve src/ymm/res/values/colors.xml ile aynı)
YAZI = "YMM"
KAPAK_YUKSEKLIGI = 0.711  # Roboto büyük harf yüksekliği / punto


def _satir_gruplari(maske: np.ndarray, esik: float = 0.05, bosluk: int = 3) -> list[tuple[int, int]]:
    """Maskede içerik bulunan ardışık satır aralıkları (tik, kitap, yazı ayrı gruplar olur)."""
    satirlar = np.where(maske.max(axis=1) > esik)[0]
    gruplar, bas = [], int(satirlar[0])
    for onceki, sonraki in zip(satirlar, satirlar[1:]):
        if sonraki - onceki > bosluk:
            gruplar.append((bas, int(onceki)))
            bas = int(sonraki)
    gruplar.append((bas, int(satirlar[-1])))
    return gruplar


def _yaziyi_degistir(maske: np.ndarray) -> np.ndarray:
    """Maskedeki son grubu (altta duran "SMMM" yazısı) siler ve aynı yerde "YMM" çizer."""
    ust, alt = _satir_gruplari(maske)[-1]
    sutunlar = np.where(maske[ust : alt + 1].max(axis=0) > 0.05)[0]
    merkez_x = (int(sutunlar[0]) + int(sutunlar[-1])) / 2
    yukseklik = alt - ust + 1

    yeni = maske.copy()
    yeni[ust : alt + 1, :] = 0
    font = ImageFont.truetype(str(FONT_800), round(yukseklik / KAPAK_YUKSEKLIGI))
    x0, y0, x1, y1 = font.getbbox(YAZI)
    tuval = Image.new("L", (maske.shape[1], maske.shape[0]), 0)
    ImageDraw.Draw(tuval).text((merkez_x - (x0 + x1) / 2, ust - y0), YAZI, font=font, fill=255)
    return np.maximum(yeni, np.asarray(tuval, dtype=np.float32) / 255)


def _kaydet(goruntu: Image.Image, yol: Path) -> None:
    yol.parent.mkdir(parents=True, exist_ok=True)
    goruntu.save(yol, optimize=True)


def ikon_uret() -> tuple[Image.Image, Image.Image]:
    """(ikon_ymm: RGB zemin + çizim, on_plan_ymm: şeffaf zeminde beyaz çizim)."""
    ikon = np.asarray(Image.open(IKON / "ikon.png").convert("RGB"), dtype=np.float32)
    maske = np.clip((ikon[:, :, 0] - SMMM_ZEMIN[0]) / (255 - SMMM_ZEMIN[0]), 0, 1)
    maske = _yaziyi_degistir(maske)
    zemin = np.array(YMM_ZEMIN, dtype=np.float32)
    renkli = zemin + maske[:, :, None] * (255 - zemin)
    ikon_ymm = Image.fromarray(np.rint(renkli).astype(np.uint8), "RGB")

    on_plan = np.asarray(Image.open(IKON / "on_plan.png").convert("RGBA"), dtype=np.float32)
    alfa = _yaziyi_degistir(on_plan[:, :, 3] / 255)
    cikti = np.zeros(on_plan.shape, dtype=np.uint8)
    cikti[:, :, :3] = 255
    cikti[:, :, 3] = np.rint(alfa * 255).astype(np.uint8)
    return ikon_ymm, Image.fromarray(cikti, "RGBA")


def android_kaynaklari(ikon_ymm: Image.Image, on_plan_ymm: Image.Image) -> None:
    for klasor, boyut in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        _kaydet(ikon_ymm.resize((boyut, boyut), Image.LANCZOS), RES_YMM / f"mipmap-{klasor}/ic_launcher.png")
    for klasor, boyut in {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}.items():
        _kaydet(
            on_plan_ymm.resize((boyut, boyut), Image.LANCZOS),
            RES_YMM / f"drawable-{klasor}/ic_launcher_foreground.png",
        )
    # Açılış logosu: SMMM'deki yuvarlatılmış kare biçimi (alfa kanalı) aynen korunur, içerik YMM simgesidir.
    kalip = Image.open(RES_SMMM / "drawable-nodpi/launch_logo.png").convert("RGBA")
    logo = ikon_ymm.resize(kalip.size, Image.LANCZOS).convert("RGBA")
    logo.putalpha(kalip.getchannel("A"))
    _kaydet(logo, RES_YMM / "drawable-nodpi/launch_logo.png")


def magaza_gorselleri(ikon_ymm: Image.Image) -> None:
    _kaydet(ikon_ymm.resize((512, 512), Image.LANCZOS), MAGAZA / "simge_512.png")
    # Öne çıkan görsel (1024×500): düz mavi zemin, solda simge, sağda ad ve alt başlık.
    tuval = Image.new("RGB", (1024, 500), YMM_ZEMIN)
    simge = ikon_ymm.resize((300, 300), Image.LANCZOS)
    tuval.paste(simge, (90, 100))
    cizim = ImageDraw.Draw(tuval)
    cizim.text((440, 150), "Tasdik YMM", font=ImageFont.truetype(str(FONT_800), 92), fill="white")
    cizim.text(
        (444, 270),
        "Yeminli Mali Müşavirlik\nsınav hazırlığı",
        font=ImageFont.truetype(str(FONT_500), 44),
        fill=(214, 228, 245),
        spacing=10,
    )
    _kaydet(tuval, MAGAZA / "one_cikan_gorsel_1024x500.png")


def main() -> None:
    ikon_ymm, on_plan_ymm = ikon_uret()
    _kaydet(ikon_ymm, IKON / "ikon_ymm.png")
    _kaydet(on_plan_ymm, IKON / "on_plan_ymm.png")
    android_kaynaklari(ikon_ymm, on_plan_ymm)
    magaza_gorselleri(ikon_ymm)
    print("YMM simgeleri üretildi:", IKON / "ikon_ymm.png")


if __name__ == "__main__":
    main()
