# -*- coding: utf-8 -*-
"""renk/<pdf>.json (kirmizi basilmis dogru secenekler) -> sgs/<yil>.json 'dogru' alani.
Kirmizi ogeler okuma sirasina (sayfa, sutun, y) dizilir; kayitlarla sirali hizalanir ve secenek metniyle dogrulanir."""
import os, re, json, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
B = os.path.dirname(os.path.abspath(__file__))
SGS = os.path.join(B, '..', 'sgs')
RENK = os.path.join(B, 'renk')
nz = lambda t: re.sub(r'[^0-9a-zçğıöşüâîû]', '', t.lower().replace('İ', 'i').replace('I', 'ı'))


def ogeler(js):
    w = js.get('sayfa_genislik') or 595
    sp = sorted(js['kirmizi'], key=lambda s: (s[0], 0 if s[1] < w / 2 - 8 else 1, s[2], s[1]))
    items = []
    import sgs_ayristir as S
    kodlu = sum(len(S.KOD_ISARET.findall(t)) for *_, t in sp) > 20
    for pg, x, y, t in sp:
        if kodlu:
            t = S.kod_coz(t.replace(' ', '\x03'), True)
            m = re.match(r'^\s*([A-E])\s*\)?\s+(.*)$', t) or re.match(r'^\s*([A-E])\s*$', t)
            if m and m.lastindex == 1:
                items.append([m.group(1), '', pg]); continue
        else:
            m = re.match(r'^\s*([A-E])\s?\)\s*(.*)$', t)
        if m:
            items.append([m.group(1), m.group(2), pg])
        elif items and items[-1][2] == pg:
            items[-1][1] += ' ' + t
    return items


def benzer(a, b):
    a, b = nz(a), nz(b)
    if not a or not b:
        return 0.0
    if a == b:
        return 1.0
    if len(a) > 6 and (a in b or b in a):
        return 0.9
    sa, sb = set(a[i:i + 3] for i in range(len(a) - 2)), set(b[i:i + 3] for i in range(len(b) - 2))
    return len(sa & sb) / max(1, len(sa | sb))


def yil(y):
    p = os.path.join(SGS, '%d.json' % y)
    d = json.load(open(p, encoding='utf-8'))
    by_pdf = {}
    for r in d['sorular']:
        by_pdf.setdefault(r['kaynak_pdf'].split('/')[-1], []).append(r)
    say = dict(kayit=len(d['sorular']), eslesen=0, renkli_pdf=0)
    for fn, recs in by_pdf.items():
        rp = os.path.join(RENK, fn + '.json')
        if not os.path.exists(rp):
            continue
        items = ogeler(json.load(open(rp, encoding='utf-8')))
        if len(items) < 5:
            continue
        say['renkli_pdf'] += 1
        if len(items) == len(recs):
            for r, (L, t, _) in zip(recs, items):
                sim = benzer(t, r['secenekler'].get(L, ''))
                r['dogru'] = L
                r['dogru_kaynak'] = 'PDF\'te kırmızı basılı doğru seçenek (sıra ile eşleme' + (', metin doğrulandı)' if sim >= 0.4 else ', metin doğrulanamadı)')
                say['eslesen'] += 1
                say['dogrulanan'] = say.get('dogrulanan', 0) + (sim >= 0.4)
            continue
        say.setdefault('sira_uyumsuz', []).append('%s %d/%d' % (fn, len(items), len(recs)))
        j = 0
        for r in recs:  # kayitlar PDF okuma sirasinda
            best = None
            if r.get('bolum') != 'GK' or r['no'] <= 20:
                k = r['no'] - 1
                if 0 <= k < len(items) and benzer(items[k][1], r['secenekler'].get(items[k][0], '')) >= 0.55:
                    r['dogru'] = items[k][0]
                    r['dogru_kaynak'] = 'PDF\'te kırmızı basılı doğru seçenek (soru no ile eşleme, metin doğrulandı)'
                    say['eslesen'] += 1
                    continue
            for k in range(j, min(j + 4, len(items))):
                L, t, _ = items[k]
                sim = benzer(t, r['secenekler'].get(L, ''))
                if sim >= 0.55:
                    best = (k, L, sim)
                    break
            if best:
                k, L, sim = best
                r['dogru'] = L
                r['dogru_kaynak'] = 'PDF\'te kırmızı basılı doğru seçenek'
                j = k + 1
                say['eslesen'] += 1
    for r in d['sorular']:
        if r.get('dogru') is None:
            r.setdefault('dogru_kaynak', None)
    d['aciklama'] = d['aciklama'].replace("dogru=null: SGS PDF'lerinde resmî cevap anahtarı yok.",
        "dogru: 2018+ kitapçıklarında doğru seçenek kırmızı basılı; buradan eşlendi (dogru_kaynak). Eşlenemeyen/eski yıllarda null (PDF'te anahtar yok).")
    json.dump(d, open(p + '.tmp', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    os.replace(p + '.tmp', p)
    return say


if __name__ == '__main__':
    for a in sys.argv[1:]:
        print(a, yil(int(a)))
