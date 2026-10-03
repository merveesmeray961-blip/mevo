"""Uzman için okunabilir PDF inceleme kitapçığı üretir (sınav kitapçığı biçiminde, cevap ve kısa açıklamalı).

Varsayılan seçim: tüm zor (3) sorular + ÖZEL listesindeki uzmanın bakması istenen sorular.

    python -m pipeline.kitapcik docs/SMMM_Uzman_Kitapcik.pdf
"""

from __future__ import annotations

import html
import re
import subprocess
import sys
import tempfile
from datetime import date
from pathlib import Path

import yaml

from pipeline import g2_yapi

CHROMIUM = "/opt/pw-browsers/chromium-1194/chrome-linux/chrome"
OZEL = ["SMMM-TAB-TMS-0001", "SMMM-FIN-MKY-0002", "SMMM-VER-VUK-0001", "SMMM-MES-ETK-0001",
        "SMMM-MAL-SIP-0001", "SMMM-FIN-BOR-0001"]


def _satir_ici(t: str) -> str:
    return re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", html.escape(t))


def _kok(metin: str) -> str:
    cikti, tablo, paragraf = [], [], []

    def paragraf_bitir():
        if paragraf:
            cikti.append("<p>" + "<br>".join(_satir_ici(x) for x in paragraf) + "</p>")
            paragraf.clear()

    def tablo_bitir():
        if tablo:
            satirlar = [r for r in tablo if not all(re.fullmatch(r":?-{2,}:?", h) for h in r)]
            govde = "".join("<tr>" + "".join(f"<{'th' if i == 0 else 'td'}>{_satir_ici(h)}</{'th' if i == 0 else 'td'}>"
                                              for h in r) + "</tr>" for i, r in enumerate(satirlar))
            cikti.append(f"<table>{govde}</table>")
            tablo.clear()

    for satir in metin.split("\n"):
        t = satir.strip()
        if t.startswith("|"):
            paragraf_bitir()
            tablo.append([h.strip() for h in t.strip("|").split("|")])
        elif not t:
            paragraf_bitir()
            tablo_bitir()
        else:
            tablo_bitir()
            paragraf.append(t)
    paragraf_bitir()
    tablo_bitir()
    return "".join(cikti)


def secim() -> list[dict]:
    mufredat = yaml.safe_load((g2_yapi.KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    sira = [d["kod"] for d in mufredat["dersler"]]
    sorular = [s for _, s in g2_yapi.dosyalari_yukle(g2_yapi.KOK / "content/sorular/smmm")
               if s.get("durum") in ("kontrolde", "onayli") and (s["zorluk"] == 3 or s["id"] in OZEL)]
    return sorted(sorular, key=lambda s: (sira.index(s["ders"]) if s["ders"] in sira else 99, s["id"]))


def html_uret(sorular: list[dict]) -> str:
    mufredat = yaml.safe_load((g2_yapi.KOK / "content/mufredat/smmm.yaml").read_text(encoding="utf-8"))
    dersler = {d["kod"]: d for d in mufredat["dersler"]}
    bloklar = []
    for no, s in enumerate(sorular, 1):
        d = dersler.get(s["ders"], {})
        konu = next((k["ad"] for k in d.get("konular", []) if k["kod"] == s["konu"]), s["konu"])
        siklar = "".join(f"<div class='sik'><b>{h})</b> {_satir_ici(s['secenekler'][h])}</div>" for h in "ABCDE")
        dayanak = "; ".join(f"{k['mevzuat']}, {k['madde']}" for k in s["kaynaklar"])
        bloklar.append(f"""
<section class="soru">
  <div class="ust"><span class="no">{no}</span><span>{html.escape(d.get('ad', s['ders']))} · {html.escape(konu)}</span>
  <span class="id">{s['id']} · s{s['surum']}</span></div>
  <div class="kok">{_kok(s['kok'])}</div>
  <div class="siklar">{siklar}</div>
  <div class="cevap"><b>Cevap: {s['dogru']}</b> — {_satir_ici(s['aciklama']['dogru_neden'])}
  <div class="dayanak">Dayanak: {html.escape(dayanak)}</div></div>
</section>""")
    return f"""<!doctype html><html lang="tr"><head><meta charset="utf-8"><style>
@page {{ size: A4; margin: 14mm 13mm; }}
body {{ font: 11pt/1.45 "DejaVu Sans", Arial, sans-serif; color: #16211f; }}
h1 {{ font-size: 17pt; margin: 0 0 4px; color: #0f6b5c; }}
.giris {{ border: 1.5px solid #0f6b5c; border-radius: 6px; padding: 10px 14px; margin-bottom: 14px; }}
.giris p {{ margin: 4px 0; }}
.soru {{ border-top: 1px solid #c9d6d2; padding-top: 10px; margin-top: 12px; }}
.ust {{ display: flex; gap: 10px; align-items: baseline; font-size: 9pt; color: #5b6b67; break-after: avoid; }}
.kok p, table, .sik, .cevap {{ break-inside: avoid; }}
.kok {{ break-after: avoid; }}
.no {{ font-size: 13pt; font-weight: bold; color: #0f6b5c; }}
.id {{ margin-left: auto; font-family: monospace; }}
.kok p {{ margin: 6px 0; }}
table {{ border-collapse: collapse; margin: 6px 0; font-size: 9.5pt; }}
td, th {{ border: 1px solid #c9d6d2; padding: 2px 7px; text-align: right; }}
td:first-child, th:first-child {{ text-align: left; }} th {{ background: #e6f2ef; }}
.sik {{ margin: 3px 0 3px 4px; white-space: pre-line; }}
.cevap {{ background: #eef6f3; border-left: 3px solid #0f6b5c; padding: 6px 10px; margin-top: 8px; font-size: 10pt; }}
.dayanak {{ color: #5b6b67; font-size: 9pt; margin-top: 4px; }}
</style></head><body>
<h1>SMMM Pilot Soru Seti — Uzman Kontrol Kitapçığı</h1>
<div class="giris">
<p><b>{len(sorular)} soru</b> · {date.today():%d.%m.%Y} · Her sorunun altında doğru cevap ve kısa gerekçe var.</p>
<p><b>Yapmanız gereken tek şey:</b> Yanlış ya da eksik gördüğünüz bir soru olursa numarasını ve kısa notunuzu
WhatsApp'tan yazmanız veya sesli mesaj bırakmanız. Örn: <i>"7. soru: cevap C olmalı, çünkü…"</i></p>
<p>Doğru bulduğunuz sorular için hiçbir şey yapmanıza gerek yok.</p>
<p style="font-size:9pt;color:#5b6b67">Sorular özgündür; TÜRMOB veya TESMER ile resmî bir bağlantı yoktur. Tüm sorular yazıldıktan sonra
iki bağımsız çözücü, bir denetçi ve kanun metniyle karşılaştırma kontrolünden geçmiştir.</p>
</div>
{''.join(bloklar)}
</body></html>"""


def main(argv: list[str]) -> int:
    hedef = Path(argv[1]) if len(argv) > 1 else g2_yapi.KOK / "docs/SMMM_Uzman_Kitapcik.pdf"
    sorular = secim()
    with tempfile.TemporaryDirectory() as gecici:
        sayfa = Path(gecici) / "kitapcik.html"
        sayfa.write_text(html_uret(sorular), encoding="utf-8")
        hedef.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run([CHROMIUM, "--headless", "--no-sandbox", "--disable-gpu", "--no-pdf-header-footer",
                        f"--print-to-pdf={hedef.resolve()}", sayfa.as_uri()],
                       check=True, capture_output=True, timeout=120)
    eslesme = hedef.with_suffix(".eslesme.txt")
    eslesme.write_text("\n".join(f"{i}\t{s['id']}\t{s['surum']}" for i, s in enumerate(sorular, 1)) + "\n",
                       encoding="utf-8")
    print(f"{len(sorular)} soru → {hedef} (numara–kimlik eşleşmesi: {eslesme.name})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
