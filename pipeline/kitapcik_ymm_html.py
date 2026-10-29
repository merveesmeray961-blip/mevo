"""YMM uzman kitapçığının HTML üretimi (PDF'e `pipeline.kitapcik_ymm` çevirir)."""

from __future__ import annotations

import html
from datetime import date

from pipeline.kitapcik import _kok, _satir_ici

STIL = """
@page { size: A4; margin: 14mm 13mm; }
body { font: 11pt/1.45 "DejaVu Sans", Arial, sans-serif; color: #16211f; }
h1 { font-size: 17pt; margin: 0 0 4px; color: #1f4e8c; }
.giris { border: 1.5px solid #1f4e8c; border-radius: 6px; padding: 10px 14px; margin-bottom: 14px; }
.giris p { margin: 4px 0; }
.soru { border-top: 1px solid #c9d6d2; padding-top: 10px; margin-top: 12px; }
.ust { display: flex; gap: 10px; align-items: baseline; font-size: 9pt; color: #5b6b67; break-after: avoid; }
.kok p, table, .sik { break-inside: avoid; }
.no { font-size: 13pt; font-weight: bold; color: #1f4e8c; }
.id { margin-left: auto; font-family: monospace; }
table { border-collapse: collapse; margin: 6px 0; font-size: 9.5pt; }
td, th { border: 1px solid #c9d6d2; padding: 2px 7px; text-align: right; }
td:first-child, th:first-child { text-align: left; } th { background: #e3ecf7; }
.sik { margin: 3px 0 3px 4px; white-space: pre-line; }
.cevap { background: #eef2f8; border-left: 3px solid #1f4e8c; padding: 6px 10px; margin-top: 8px; font-size: 10pt; }
.dayanak { color: #5b6b67; font-size: 9pt; margin-top: 4px; }
"""

GIRIS = """
<p><b>{n_test} test sorusu + {n_klasik} klasik vaka</b> · {tarih} · Her birinin altında doğru cevap / örnek çözüm ve dayanak var.</p>
<p><b>Yapmanız gereken tek şey:</b> Yanlış ya da eksik gördüğünüz bir madde olursa numarasını ve kısa notunuzu iletmeniz.
Örn: <i>"12. soru: cevap C olmalı, çünkü…"</i> ya da <i>"31. vaka: (b) bendinde oran 2026'da farklı."</i></p>
<p><b>Özellikle bakmanızı rica ettiğimiz noktalar:</b> 2026'ya özgü oranlar ve tutarlar (11257 / 9160 / 9707 sayılı
Cumhurbaşkanı kararları, 7555 / 7566 / 7582 sayılı kanunlar) ve klasik vakalardaki puanlama ölçütlerinin sınav puanlamasına uygunluğu.</p>
<p>Doğru bulduğunuz maddeler için hiçbir şey yapmanıza gerek yok.</p>
<p style="font-size:9pt;color:#5b6b67">İçerik özgündür; TÜRMOB veya TESMER ile resmî bir bağlantı yoktur. Her madde yazıldıktan sonra
bağımsız çözüm, itiraz eden denetçi ve kaynak metinle karşılaştırma kontrolünden geçmiştir; uzman teyidi bu kitapçıkla alınacaktır.</p>
"""


def _konu_adi(ders: dict, kod: str) -> str:
    return next((k["ad"] for k in ders.get("konular", []) if k["kod"] == kod), kod)


def _test_blogu(no: int, s: dict, ders: dict) -> str:
    siklar = "".join(f"<div class='sik'><b>{h})</b> {_satir_ici(s['secenekler'][h])}</div>" for h in "ABCDE")
    dayanak = "; ".join(f"{k['mevzuat']}, {k['madde']}" for k in s["kaynaklar"])
    baslik = f"TEST · {html.escape(ders.get('ad', s['ders']))} · {html.escape(_konu_adi(ders, s['konu']))}"
    return f"""
<section class="soru"><div class="ust"><span class="no">{no}</span><span>{baslik}</span>
<span class="id">{s['id']} · s{s['surum']}</span></div>
<div class="kok">{_kok(s['kok'])}</div><div class="siklar">{siklar}</div>
<div class="cevap"><b>Cevap: {s['dogru']}</b> — {_satir_ici(s['aciklama']['dogru_neden'])}
<div class="dayanak">Dayanak: {html.escape(dayanak)}</div></div></section>"""


def _klasik_blogu(no: int, k: dict, ders: dict) -> str:
    olcutler = "".join(f"<li>{_satir_ici(o['olcut'])} <i>({o['puan']} puan)</i></li>" for o in k.get("puanlama", []))
    dayanak = "; ".join(f"{x['mevzuat']}, {x['madde']}" for x in k.get("kaynaklar", []))
    baslik = (f"KLASİK · {html.escape(ders.get('ad', k['ders']))} · "
              f"{html.escape(_konu_adi(ders, k['konu']))} · {k['puan']} puan")
    return f"""
<section class="soru"><div class="ust"><span class="no">{no}</span><span>{baslik}</span>
<span class="id">{k['id']} · s{k['surum']}</span></div>
<div class="kok">{_kok(k['soru'])}</div>
<div class="cevap"><b>Örnek çözüm</b><div>{_kok(k['cozum'])}</div>
<b>Puanlama ölçütleri</b><ul>{olcutler}</ul><div class="dayanak">Dayanak: {html.escape(dayanak)}</div></div></section>"""


def html_uret(sorular: list[dict], klasikler: list[dict], dersler: dict[str, dict]) -> str:
    bloklar = []
    for no, s in enumerate(sorular, 1):
        bloklar.append(_test_blogu(no, s, dersler.get(s["ders"], {})))
    for no, k in enumerate(klasikler, len(sorular) + 1):
        bloklar.append(_klasik_blogu(no, k, dersler.get(k["ders"], {})))
    giris = GIRIS.format(n_test=len(sorular), n_klasik=len(klasikler), tarih=f"{date.today():%d.%m.%Y}")
    return (f'<!doctype html><html lang="tr"><head><meta charset="utf-8"><style>{STIL}</style></head><body>'
            f'<h1>Tasdik YMM — Uzman Kontrol Kitapçığı</h1><div class="giris">{giris}</div>{"".join(bloklar)}</body></html>')
