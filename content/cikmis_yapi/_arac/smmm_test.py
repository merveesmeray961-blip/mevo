# -*- coding: utf-8 -*-
"""SMMM 2026 test (yeni format) PDF -> content/cikmis_yapi/smmm_test.json (cevap anahtari PDF icinde)."""
import os, re, json, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sgs_ayristir as S

KAYNAK = os.path.join(S.KOK, 'content', 'kaynaklar', 'cikmis', 'smmm')
OUT = os.path.join(S.KOK, 'content', 'cikmis_yapi', 'smmm_test.json')
DERS = {'01': ('FIN', 'Finansal Muhasebe'), '02': ('TAB', 'Finansal Tablolar ve Analizi'), '03': ('MAL', 'Maliyet Muhasebesi'),
        '04': ('DEN', 'Muhasebe Denetimi'), '05': ('VER', 'Vergi Mevzuatı ve Uygulaması'), '06': ('HUK', 'Hukuk'),
        '07': ('MES', 'Muhasebecilik ve Mali Müşavirlik Meslek Hukuku'), '08': ('SPK', 'Sermaye Piyasası Mevzuatı')}
KEY = re.compile(r'^[ \t]*(\d{1,2})[ \t]+(\d{1,2})[ \t]+(\d{1,2})[ \t]+(\d{1,2})[ \t]+([A-E])[ \t]*(İPTAL|IPTAL)?', re.M)


def isle(fn):
    path = os.path.join(KAYNAK, fn)
    pages, full = S.pdftext_cols(path)
    import subprocess
    anahtar = {}
    np_ = len(pages)
    raw = ''
    for pg in range(1, np_ + 1):
        t = subprocess.run(['pdftotext', '-layout', '-f', str(pg), '-l', str(pg), path, '-'], capture_output=True, text=True).stdout
        if 'Cevap Anahtar' in t or 'Kitapçığı' in t:
            raw += t
    i = 0
    if raw:
        for m in KEY.finditer(raw[i:]):
            anahtar[int(m.group(1))] = (m.group(5), bool(m.group(6)), {'B': int(m.group(2)), 'C': int(m.group(3)), 'D': int(m.group(4))})
    # cevap anahtari sayfalarini soru metninden cikar
    pages = [p for p in pages if 'Cevap Anahtar' not in p]
    blocks = S.soru_bloklari(pages, reset=False)
    m = re.match(r'smmm_(\d{4})_(\d)_(\d\d)\.pdf', fn)
    yil, donem, dk = int(m.group(1)), int(m.group(2)), m.group(3)
    kod, ad = DERS[dk]
    out = []
    for b in blocks:
        rawb = '\n'.join(b['lines']).strip()
        kok, sec, notes = S.secenek_ayir(rawb)
        kok = re.sub(r'[ \t]+', ' ', kok).strip()
        g, notes = S.kalite(kok, sec, rawb, notes)
        k = anahtar.get(b['no'])
        if k and k[1]:
            notes.append('resmî anahtarda İPTAL')
        if not k:
            notes.append('cevap anahtarında bulunamadı')
        out.append(dict(id='SMMM-%d-%d-%s-%02d' % (yil, donem, kod, b['no']), tur='smmm_test', yil=yil, donem=donem,
                        kitapcik='A', ders_kod=kod, ders_ad=ad, no=b['no'], kok=kok,
                        secenekler={x: sec.get(x, '') for x in 'ABCDE'}, dogru=(k[0] if k else None),
                        iptal=bool(k and k[1]), diger_kitapciklar=({x: k[2][x] for x in 'BCD'} if k else {}),
                        kaynak_pdf='content/kaynaklar/cikmis/smmm/' + fn, okuma_guveni=g, notlar='; '.join(notes)))
    return out, len(anahtar)


if __name__ == '__main__':
    files = sorted(f for f in os.listdir(KAYNAK) if re.match(r'smmm_2026_\d_\d\d\.pdf$', f))
    hepsi, ist = [], []
    for fn in files:
        r, na = isle(fn)
        hepsi += r
        ist.append(dict(pdf=fn, soru=len(r), anahtar=na, tam=sum(x['okuma_guveni'] == 'tam' for x in r)))
        print(fn, len(r), 'anahtar', na, 'tam', ist[-1]['tam'])
    with open(OUT + '.tmp', 'w', encoding='utf-8') as f:
        json.dump(dict(aciklama='SMMM Yeterlilik 2026 test (20 soru/ders). dogru = resmî A kitapçığı cevap anahtarı; '
                                 'diger_kitapciklar = aynı sorunun B/C/D kitapçığındaki numarası.',
                       kayit_sayisi=len(hepsi), pdf_istatistik=ist, sorular=hepsi), f, ensure_ascii=False, indent=1)
    os.replace(OUT + '.tmp', OUT)
