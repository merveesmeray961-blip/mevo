# -*- coding: utf-8 -*-
"""Windows (PyMuPDF) ile SGS/SMMM PDF'lerindeki siyah olmayan (kirmizi vb.) metin parcalarini cikarir.
Bazi kitapciklarda dogru secenek kirmizi basilmis. Cikti: _arac/renk/<pdf>.json (zaten varsa atlar)."""
import os, sys, json, fitz
B = os.path.dirname(os.path.abspath(__file__))
KOK = os.path.abspath(os.path.join(B, '..', '..', '..'))
SRC = os.path.join(KOK, 'content', 'kaynaklar', 'cikmis', 'sgs')
OUT = os.path.join(B, 'renk')
os.makedirs(OUT, exist_ok=True)
files = sorted(f for f in os.listdir(SRC) if f.endswith('.pdf'))
files.sort(key=lambda f: f[4:8], reverse=True)
for fn in files:
    o = os.path.join(OUT, fn + '.json')
    if os.path.exists(o):
        continue
    d = fitz.open(os.path.join(SRC, fn))
    res = []
    for pi, page in enumerate(d):
        w = page.rect.width
        for b in page.get_text('dict')['blocks']:
            for l in b.get('lines', []):
                for s in l['spans']:
                    c = s['color']
                    r, g, bb = (c >> 16) & 255, (c >> 8) & 255, c & 255
                    if r > 150 and g < 110 and bb < 110 and s['text'].strip():
                        res.append([pi, round(s['bbox'][0], 1), round(s['bbox'][1], 1), s['text']])
    json.dump(dict(pdf=fn, sayfa_genislik=w, kirmizi=res), open(o, 'w', encoding='utf-8'), ensure_ascii=False)
    print(fn, len(res), flush=True)
