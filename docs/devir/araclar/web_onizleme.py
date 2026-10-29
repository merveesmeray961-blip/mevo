"""Mizan SMMM veya Tasdik YMM'yi Chrome'da çalıştırır (PC'de görsel önizleme).

Neden gerekli: soru paketleri `pubspec.yaml`'da `flavors:` ile yalnız kendi mobil uygulamasına bağlanır; Flutter web
derlemesi bu bayrağı yok saydığından paket web'e girmez. Bu betik `app/` klasörünün geçici bir kopyasını alır, kopyadaki
`pubspec.yaml`'ı seçilen ürünün paketini bayraksız ekleyecek şekilde düzenler ve orada `flutter run -d chrome` çalıştırır.
Depodaki dosyalara dokunulmaz; mobil derlemeler (APK/AAB) bundan etkilenmez.

Kullanım (depo kökünden, Windows'ta yolu ASCII olan bir klasöre kopyalanır):
    python docs/devir/araclar/web_onizleme.py --urun ymm
    python docs/devir/araclar/web_onizleme.py --urun smmm --port 5301 --flutter C:/Users/erene/dev/flutter/bin/flutter.bat

Önce paketi üretin: python -m pipeline.disa_aktar app/assets/sorular/<urun>.json --uygulama --urun <urun>
"""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

KOK = Path(__file__).resolve().parents[3]
URUNLER = ("smmm", "ymm")
KOPYALANMAYAN = shutil.ignore_patterns("build", ".dart_tool", ".gradle", "android", "ios", ".idea", "test")


def pubspec_duzenle(metin: str, urun: str) -> str:
    """Bayraklı iki paket girdisini seçilen ürünün tek, bayraksız girdisiyle değiştirir; default-flavor'ı kaldırır."""
    girdiler = re.compile(
        r"    - path: assets/sorular/smmm\.paket\n      flavors: \[smmm\]\n"
        r"    - path: assets/sorular/ymm\.paket\n      flavors: \[ymm\]\n"
    )
    yeni, adet = girdiler.subn(f"    - assets/sorular/{urun}.paket\n", metin)
    if adet != 1:
        raise RuntimeError("pubspec.yaml'daki bayraklı soru paketi girdileri beklenen biçimde bulunamadı")
    return re.sub(r"^  default-flavor: .*\n", "", yeni, flags=re.MULTILINE)


def hazirla(urun: str, hedef: Path) -> Path:
    paket = KOK / f"app/assets/sorular/{urun}.paket"
    if not paket.exists():
        raise FileNotFoundError(f"{paket} yok; önce paketi üretin (pipeline.disa_aktar --urun {urun})")
    app = hedef / "app"
    shutil.rmtree(app, ignore_errors=True)
    shutil.copytree(KOK / "app", app, ignore=KOPYALANMAYAN)
    pubspec = app / "pubspec.yaml"
    pubspec.write_text(pubspec_duzenle(pubspec.read_text(encoding="utf-8"), urun), encoding="utf-8")
    return app


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--urun", choices=URUNLER, required=True)
    ap.add_argument("--port", type=int, default=5300)
    ap.add_argument("--hedef", type=Path, default=Path.home() / "dev" / "mevo_web", help="geçici kopya klasörü (ASCII yol)")
    ap.add_argument("--flutter", default="flutter", help="flutter yürütülebilir dosyası")
    args = ap.parse_args(argv[1:])
    app = hazirla(args.urun, args.hedef)
    print(f"Geçici kopya: {app}")
    komut = [args.flutter, "run", "-d", "chrome", "--web-port", str(args.port), f"--dart-define=MEVO_URUN={args.urun}"]
    return subprocess.call(komut, cwd=app)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
