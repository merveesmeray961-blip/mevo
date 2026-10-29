"""YMM uzman inceleme kitapçığı: her dersten örnek test soruları + klasik (yazılı) vakalar, cevap ve gerekçeyle.

YMM sınavı klasik yazılı olduğundan kitapçık iki bölümden oluşur:
  1. Test soruları: her dersten zor (3) sorulardan, konulara dağıtılmış örnek.
  2. Klasik vakalar: her dersten birkaç vaka; örnek çözüm ve puanlama ölçütüyle.

    python -m pipeline.kitapcik_ymm docs/YMM_Uzman_Kitapcik.pdf [--soru 6] [--klasik 2]

Çıktının yanına `.eslesme.txt` (numara–kimlik eşleşmesi) yazılır; uzman yalnız numara ve kısa notla geri bildirir.
HTML üretimi `pipeline/kitapcik_ymm_html.py` içindedir.
"""

from __future__ import annotations

import subprocess
import sys
import tempfile
from collections import defaultdict
from pathlib import Path

import yaml

from pipeline import g2_yapi
from pipeline.kitapcik import CHROMIUM

AKTIF = ("kontrolde", "onayli", "yayinda")


def mufredat() -> dict[str, dict]:
    m = yaml.safe_load((g2_yapi.KOK / "content/mufredat/ymm.yaml").read_text(encoding="utf-8"))
    return {d["kod"]: d for d in m["dersler"]}


def dagit(liste: list[dict], adet: int, anahtar) -> list[dict]:
    """Konulara dengeli dağıtarak `adet` kayıt seçer (her konudan sırayla birer; kimliğe göre deterministik)."""
    gruplar: dict[str, list[dict]] = defaultdict(list)
    for k in sorted(liste, key=lambda x: x["id"]):
        gruplar[anahtar(k)].append(k)
    secilen: list[dict] = []
    konular = sorted(gruplar)
    i = 0
    while konular and len(secilen) < adet and any(gruplar.values()):
        konu = konular[i % len(konular)]
        if gruplar[konu]:
            secilen.append(gruplar[konu].pop(0))
        i += 1
    return secilen


def secim(soru_basi: int = 6, klasik_basi: int = 2) -> tuple[list[dict], list[dict]]:
    sira = list(mufredat())
    sorular = [s for _, s in g2_yapi.dosyalari_yukle(g2_yapi.KOK / "content/sorular/ymm")
               if s.get("durum") in AKTIF and s.get("zorluk") == 3]
    klasikler: list[dict] = []
    for yol in sorted((g2_yapi.KOK / "content/klasik/ymm").rglob("*.yaml")):
        icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
        klasikler += [k for k in (icerik if isinstance(icerik, list) else [icerik]) if k.get("durum") in AKTIF]
    sec_s: list[dict] = []
    sec_k: list[dict] = []
    for ders in sira:
        sec_s += dagit([s for s in sorular if s["ders"] == ders], soru_basi, lambda s: s["konu"])
        sec_k += dagit([k for k in klasikler if k["ders"] == ders], klasik_basi, lambda k: k["konu"])
    return sec_s, sec_k


def main(argv: list[str]) -> int:
    from pipeline.kitapcik_ymm_html import html_uret

    soru_basi = int(argv[argv.index("--soru") + 1]) if "--soru" in argv else 6
    klasik_basi = int(argv[argv.index("--klasik") + 1]) if "--klasik" in argv else 2
    yollar = [a for i, a in enumerate(argv[1:], 1)
              if not a.startswith("--") and argv[i - 1] not in ("--soru", "--klasik")]
    hedef = Path(yollar[0]) if yollar else g2_yapi.KOK / "docs/YMM_Uzman_Kitapcik.pdf"
    sorular, klasikler = secim(soru_basi, klasik_basi)
    with tempfile.TemporaryDirectory() as gecici:
        sayfa = Path(gecici) / "kitapcik.html"
        sayfa.write_text(html_uret(sorular, klasikler, mufredat()), encoding="utf-8")
        hedef.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run([CHROMIUM, "--headless", "--no-sandbox", "--disable-gpu", "--no-pdf-header-footer",
                        f"--print-to-pdf={hedef.resolve()}", sayfa.as_uri()],
                       check=True, capture_output=True, timeout=180)
    kayitlar = [(s["id"], s["surum"]) for s in sorular] + [(k["id"], k["surum"]) for k in klasikler]
    eslesme = hedef.with_suffix(".eslesme.txt")
    eslesme.write_text("\n".join(f"{i}\t{kid}\t{sur}" for i, (kid, sur) in enumerate(kayitlar, 1)) + "\n",
                       encoding="utf-8")
    print(f"{len(sorular)} test + {len(klasikler)} klasik → {hedef} (eşleşme: {eslesme.name})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
