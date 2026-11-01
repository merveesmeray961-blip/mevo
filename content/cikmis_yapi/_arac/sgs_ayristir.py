# -*- coding: utf-8 -*-
"""TESMER SGS cikmis soru PDF -> yapilandirilmis JSON.
Kullanim: python3 sgs_ayristir.py <yil> [<yil> ...]  (mevcut yil dosyasini atlar; --zorla ile yeniden yazar)
Ayarlar/anahtar kelimeler: sgs_ayar.py. pdftotext (poppler) gerekir.
"""
import sys, os, re, json, subprocess, unicodedata, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sgs_ayar import FIX, DERS, KAPAK_ADLARI, KWC

KOK = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
PDF_DIR = os.path.join(KOK, 'content', 'kaynaklar', 'cikmis', 'sgs')
OUT_DIR = os.path.join(KOK, 'content', 'cikmis_yapi', 'sgs')


def norm(s):
    return unicodedata.normalize('NFC', s.translate(FIX))


LINE_RX = re.compile(r'<line xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</line>', re.S)
WORD_RX = re.compile(r'<word [^>]*>(.*?)</word>', re.S)
PAGE_RX = re.compile(r'<page width="([\d.]+)" height="([\d.]+)">(.*?)</page>', re.S)


KOD_ISARET = re.compile('[Õú÷\x03\x81]')
KOD_OZEL = {'Õ': 'ı', 'ú': 'ş', '÷': 'ğ', '\x81': 'ü', 'o': 'ç', '|': 'ö', 'ø': 'İ', 'd': 'Ç', '¶': '’', '±': '_',
            '³': '“', '´': '”', 'g': 'Ö', 'h': 'Ü', 'ù': 'Ş', '\x87': '•', '«': '«'}
KOD_SAY = [0]


def kod_coz(t, zorla=False):
    """2014/2 gibi kaydirmali (+29) ozel kodlu fontlu sayfalar."""
    if not zorla:
        return t
    KOD_SAY[0] += 1
    o = []
    for ch in t:
        k = ord(ch)
        if ch in KOD_OZEL:
            o.append(KOD_OZEL[ch])
        elif k <= 0x5D:
            o.append(chr(k + 29))
        else:
            o.append(ch)
    return ''.join(o)


def pdftext_cols(path):
    """Her sayfa: sol sutun + sag sutun (satir koordinatina gore)."""
    import html as H
    x = subprocess.run(['pdftotext', '-bbox-layout', path, '-'], capture_output=True, text=True, errors='replace').stdout
    pages = []
    for pm in PAGE_RX.finditer(x):
        w = float(pm.group(1)); mid = w / 2
        cols = ([], [])
        kodlu_sayfa = len(KOD_ISARET.findall(pm.group(3))) > 20
        for lm in LINE_RX.finditer(pm.group(3)):
            x0, y1, x1 = float(lm.group(1)), float(lm.group(4)), float(lm.group(3))
            t = ' '.join(kod_coz(H.unescape(wm), kodlu_sayfa) for wm in WORD_RX.findall(lm.group(5)))
            c = 0 if x0 < mid - 8 else 1
            cols[c].append((y1, x0, t))
        txt = []
        for c in cols:
            c.sort()
            rows = []
            for y, x0, t in c:
                if rows and abs(y - rows[-1][0]) <= 3.0:
                    rows[-1][1].append((x0, t))
                else:
                    rows.append([y, [(x0, t)]])
            for y, items in rows:
                items.sort()
                if kodlu_sayfa:
                    # ')' karakteri bu fontta kayip: 'A metin' -> 'A) metin'
                    satir = ' '.join(t for _, t in items)
                    txt.append(re.sub(r'(^|\s)([A-E])\s+(?=\S)', r'\1\2) ', satir))
                else:
                    txt.append(' '.join(t for _, t in items))
            txt.append('')
        pages.append(norm('\n'.join(txt)))
    full = pages[0] if pages else ''
    return pages, full


HDR = re.compile(r'^\s*TÜRMOB\s*[-–]?\s*TESMER|^\s*ThRMOB|^\s*TESMER\b|STAJA GİRİŞ SINAVI|STAJA BAŞLAMA SINAVI|Diğer sayfaya|DİĞER SAYFAYA|'
                 r'TEST BİTTİ|CEVAPLARINIZI KONTROL|^\s*\d{1,2}\s*$|^\s*[A-D]\s*$|^\s*\(?Yabancı Dil: İngilizce\)|\(Yabancı Dil|Yabancı Dil Muaf\)|'
                 r'^\s*\d{1,2}\s+(Ocak|Şubat|Mart|Nisan|Mayıs|Haziran|Temmuz|Ağustos|Eylül|Ekim|Kasım|Aralık|OCAK|ŞUBAT|MART|NİSAN|MAYIS|HAZİRAN|TEMMUZ|AĞUSTOS|EYLÜL|EKİM|KASIM|ARALIK)\s+20\d\d|^\s*20\d\d-\d\s*$')
SEC = [(re.compile(r'GENEL\s+KÜLTÜR'), 'GK'), (re.compile(r'^\s*YABANCI\s+DİL\s*(TESTİ)?\s*$'), 'YD'),
       (re.compile(r'^\s*ALAN\s+BİLGİSİ'), 'ALAN'), (re.compile(r'^\s*İNGİLİZCE\s*$'), 'YD')]
QSTART = re.compile(r'^\s*(\d{1,3})\s*\.\s*(.*)$')
OPT = re.compile(r'(?:(?<=\s)|^)([A-E])\s?\)\s*')
NUMONLY = re.compile(r'^\s*(\d{2,3})(?:\s+(\S.*))?$')
SON = re.compile(r'^SINAVDA UYULACAK KURALLAR|Sınav süresince görevlilerle konuşmak|^SINAV KURALLARI$')
FOOT = re.compile(r'\s*Sayfa \d{1,2}\s*$|\s*\d{1,2}\s+\S+\s+20\d\d\s*[–-]?\s*(Saat|SAAT)\s*:?\s*\d\d[.:]\d\d|\s*\d{0,2}\s*(İzleyen|Diğer|DİĞER|Sonraki) (sayfaya|SAYFAYA) (geçiniz|GEÇİNİZ)\.?\s*\d{0,2}|\s*TEST BİTTİ\.?.*$|\s*CEVAPLARINIZI KONTROL EDİNİZ\.?')
HAS_E = re.compile(r'(?:^|\s)E\s?\)')


def soru_bloklari(pages, reset=True):
    lines = []
    for pi, p in enumerate(pages):
        if pi == 0 and re.search(r'GENEL AÇIKLAMA|SOYADI|KİMLİK N|ADAYIN', p):
            continue
        for ln in p.split('\n'):
            ln = FOOT.sub('', ln)
            if not ln.strip():
                continue
            if HDR.search(ln):
                continue
            lines.append(ln.rstrip())
    blocks, cur, bolum, last = [], None, None, 0
    sec_i, pending = 0, False
    for ln in lines:
        s = ln.strip()
        if not s:
            continue
        if SON.search(s) and blocks:
            break
        hit = None
        for rx, b in SEC:
            if len(s) < 60 and rx.search(s):
                hit = b
        if hit:
            bolum = hit
            pending = True
            continue
        m = QSTART.match(s) or NUMONLY.match(s)
        if m:
            n = int(m.group(1))
            body = '\n'.join(cur['lines']) if cur else ''
            hasE = bool(HAS_E.search(body))
            ok = False
            if m.re is NUMONLY:
                ok = cur is not None and n == last + 1 and n >= 10 and hasE
            elif n == last + 1 and (cur is None or hasE or len(body) > 350):
                ok = True
            elif cur is not None and last + 1 < n <= last + 3 and hasE:
                ok = True
            elif reset and cur is not None and n == 1 and last >= 8 and hasE:
                ok = True
                if not pending:
                    bolum = None  # basliksiz yeni bolum
                pending = True
            if ok:
                if pending:
                    sec_i += 1
                    pending = False
                g2 = m.group(2) or ''
                cur = {'no': n, 'bolum': bolum, 'sec': sec_i, 'lines': [g2] if g2 else []}
                blocks.append(cur)
                last = n
                continue
        if cur:
            cur['lines'].append(s)
    return blocks


def secenek_ayir(text):
    ms = list(OPT.finditer(text))
    idx = None
    for i in range(len(ms)):
        if set(x.group(1) for x in ms[i:i + 5]) == set('ABCDE'):
            idx = i
            break
    if idx is None:
        for i, m in enumerate(ms):
            if m.group(1) == 'A' and 'B' in [x.group(1) for x in ms[i:i + 6]]:
                idx = i
                break
    if idx is None:
        return text.strip(), {}, ['seçenek bulunamadı']
    kok = text[:ms[idx].start()].strip()
    sec, notes, seen, use = {}, [], [], []
    for m in ms[idx:]:
        if m.group(1) in seen:
            break
        seen.append(m.group(1))
        use.append(m)
    raws = {}
    for i, m in enumerate(use):
        end = use[i + 1].start() if i + 1 < len(use) else len(text)
        raws[m.group(1)] = text[m.end():end]
    son = use[-1].group(1) if use else None
    if son and len(use) == 5:
        digerleri = [len(re.sub(r'\s+', ' ', v).strip()) for k, v in raws.items() if k != son]
        satirlar = [l for l in raws[son].split('\n') if l.strip()]
        if satirlar and max(digerleri or [0]) <= 45 and len(satirlar) > 1:
            raws[son] = satirlar[0]
            notes.append('son seçenekten sonraki taşan metin atıldı')
    for k, v in raws.items():
        sec[k] = re.sub(r'\s+', ' ', v).strip()
    if len(sec.get('E', '')) > 300:
        notes.append('E seçeneği uzun (taşma olabilir)')
    if sorted(sec) == list('BCDE'):
        sat = kok.split('\n')
        for j in range(len(sat) - 1, -1, -1):
            if re.search(r'[?:]\s*$', sat[j]) and j < len(sat) - 1:
                sec['A'] = re.sub(r'\s+', ' ', ' '.join(sat[j + 1:])).strip()
                kok = '\n'.join(sat[:j + 1])
                notes.append('A seçeneğinin başı kayıp olabilir (A) işareti okunamadı)')
                break
    if sorted(sec) != list('ABCDE'):
        notes.append('eksik seçenek: ' + ''.join(sorted(set('ABCDE') - set(sec))))
    if [m.group(1) for m in use] != sorted(m.group(1) for m in use):
        notes.append('seçenek sırası PDF metninde karışık (harfe göre yeniden dizildi)')
    return kok, sec, notes


def kalite(kok, sec, raw, notes):
    g, n = 'tam', list(notes)
    if any('kayıp' in x for x in notes):
        g = 'kismi'
    if sorted(sec) != list('ABCDE'):
        g = 'okunamadi' if len(sec) < 3 else 'kismi'
    if len(kok) < 12:
        g = 'okunamadi' if not sec else 'kismi'
        n.append('kök çok kısa/okunamadı')
    if any(not v for v in sec.values()):
        g = 'kismi' if g == 'tam' else g
        n.append('boş seçenek (görsel/formül olabilir)')
    lines = [l for l in raw.split('\n') if l.strip()]
    numl = sum(1 for l in lines if re.fullmatch(r'[\d\.\,\s₺%\-–()/]+', l.strip()) or len(l.strip().split()) <= 2)
    if numl >= 8 and numl > 0.35 * len(lines):
        g = 'kismi' if g == 'tam' else g
        n.append('tablo/çizelge içeriyor (düzen kaybolmuş olabilir)')
    if re.search(r'grafik|şekildeki|aşağıdaki şekil|aşağıdaki tablo(?!su)|tablodaki|tabloda(?!n)|çizelge', kok, re.I):
        g = 'kismi' if g == 'tam' else g
        n.append('grafik/şekil/tabloya atıf')
    if re.search(r'[\U0001D400-\U0001D7FF-�√∫∑]', raw):
        g = 'kismi' if g == 'tam' else g
        n.append('formül/özel karakter')
    acc = sum(len(re.findall(r'\b[1-7]\d\d\s+[A-ZÇĞİÖŞÜ]{3,}', v)) for v in sec.values())
    if acc >= 6:
        g = 'kismi' if g == 'tam' else g
        n.append('yevmiye kaydı şıkları (borç/alacak düzeni metinde kaybolmuş olabilir)')
    return g, n


def puan(text, k):
    return sum(1 for rx in KWC[k] if rx.search(text))


def segment(items, order, ceza=1.5):
    """Monoton (ders sırası korunarak) DP segmentasyonu."""
    n, m = len(items), len(order)
    if n == 0:
        return []
    S = [[puan(t, k) for k in order] for t in items]
    NEG = -1e9
    dp = [[NEG] * m for _ in range(n)]
    bk = [[0] * m for _ in range(n)]
    for j in range(m):
        dp[0][j] = S[0][j] - 0.3 * j
    for i in range(1, n):
        best, bj = NEG, 0
        for j in range(m):
            stay = dp[i - 1][j]
            mv = best - ceza
            if stay >= mv:
                dp[i][j], bk[i][j] = stay + S[i][j], j
            else:
                dp[i][j], bk[i][j] = mv + S[i][j], bj
            if dp[i - 1][j] > best:
                best, bj = dp[i - 1][j], j
    j = max(range(m), key=lambda x: dp[n - 1][x])
    res = [None] * n
    for i in range(n - 1, -1, -1):
        res[i] = order[j]
        j = bk[i][j]
    return res


def kapak_sirasi(full):
    pos = sorted((full.find(ad), k) for ad, k in KAPAK_ADLARI if full.find(ad) >= 0)
    def uniq(lst, base):
        o = []
        for k in lst + base:
            if k in base and k not in o:
                o.append(k)
        return o
    ks = [k for _, k in pos]
    return uniq(ks, ['FIN', 'STD', 'MAL', 'TAB', 'DEN']) + ['EKO', 'MLY'] + uniq(ks, ['MES', 'IS', 'VER', 'TIC', 'BOR'])


def dosya_bilgi(fn):
    m = re.match(r'sgs_(\d{4})_(\d)_([a-z]+)_([a-d])_grubu(?:_(.*))?\.pdf', fn)
    return dict(yil=int(m.group(1)), donem=int(m.group(2)), seviye=m.group(3), kitapcik=m.group(4).upper(), ek=m.group(5) or '')


def anahtar(kok, sec):
    t = kok[:250] + '|' + '|'.join(sorted(v[:60] for v in sec.values()))
    t = re.sub(r'[^0-9a-zçğıöşüâîû]', '', t.lower())
    return hashlib.md5(t.encode()).hexdigest()[:16]


TALIMAT = re.compile(r'(sorularda|sorulara|soruları|sorular[ıi]n)\b', re.I)


def talimat_temizle(kok):
    lines = kok.split('\n')
    if any(TALIMAT.search(l) for l in lines[:3]):
        for i, l in enumerate(lines[:6]):
            m = re.match(r'^\s*\d{1,3}\s*\.\s*(.*)$', l)
            if m and i > 0:
                return '\n'.join([m.group(1)] + lines[i + 1:]).strip()
    return kok


def jetonlar(kok, sec):
    t = (kok + ' ' + ' '.join(sec.values())).lower()
    return set(w for w in re.findall(r'[0-9a-zçğıöşüâîû]+', t) if len(w) > 1)


def benzer(a, b):
    if not a or not b:
        return 0
    return len(a & b) / len(a | b)


def isle_pdf(fn):
    info = dosya_bilgi(fn)
    KOD_SAY[0] = 0
    pages, full = pdftext_cols(os.path.join(PDF_DIR, fn))
    kodlu = KOD_SAY[0] > 50
    def skor(bl):
        return sum(1 for b in bl if len(set(re.findall(r'(?:^|\s)([A-E])\s?\)', '\n'.join(b['lines'])))) >= 4)
    b1, b2 = soru_bloklari(pages, True), soru_bloklari(pages, False)
    blocks = b1 if skor(b1) > skor(b2) else b2
    order = kapak_sirasi(full)
    ing = info['ek'] == 'ingilizce' or 'İNGİLİZCE' in full.upper()
    recs = []
    for b in blocks:
        raw = '\n'.join(b['lines']).strip()
        kok, sec, notes = secenek_ayir(raw)
        kok = re.sub(r'[ \t]+', ' ', kok).strip()
        kok = talimat_temizle(kok)
        g, notes = kalite(kok, sec, raw, notes)
        if kodlu:
            notes.append('PDF özel kodlu fontla; metin karakter kaydırma ile çözüldü (Ü/Ö/Ğ büyük harflerde hata olabilir)')
        recs.append(dict(no=b['no'], bolum=b['bolum'], grp=b['sec'], kok=kok, sec=sec, guven=g, notlar=notes))
    gr_ = {}
    for r in recs:
        gr_.setdefault(r['grp'], []).append(r)
    for gi, rs in gr_.items():
        if sum(1 for r in rs if r['sec']) < 0.5 * len(rs):
            recs = [r for r in recs if r['grp'] != gi]
    tot = len(recs)
    gruplar = {}
    for r in recs:
        gruplar.setdefault(r['grp'], []).append(r)
    surekli = len(gruplar) <= 1 or max(r['no'] for r in recs) > 100
    for gi, rs in gruplar.items():
        for r in rs:
            if surekli and (r['bolum'] is None or (r['bolum'] == 'GK' and r['no'] > 20)):
                if r['no'] <= 20:
                    r['bolum'] = 'GK'
                elif ing and r['no'] <= 30 and tot >= 125:
                    r['bolum'] = 'YD'
                else:
                    r['bolum'] = 'ALAN'
            elif r['bolum'] is None:
                r['bolum'] = 'YD' if (ing and len(rs) <= 12) else ('GK' if len(rs) <= 25 else 'ALAN')
    gk = [r for r in recs if r['bolum'] == 'GK']
    al = [r for r in recs if r['bolum'] == 'ALAN']
    txt = lambda x: x['kok'] + ' ' + ' '.join(x['sec'].values())
    for r, k in zip(gk, segment([txt(x) for x in gk], ['TUR', 'MAT', 'ATA'], ceza=3)):
        r['alt'] = k
    for r, k in zip(al, segment([txt(x) for x in al], order)):
        r['alt'] = k
    for r in recs:
        if r['bolum'] == 'YD':
            r['alt'] = 'YD'
    return info, recs, len(pages)


def yil_isle(yil):
    files = [f for f in os.listdir(PDF_DIR) if f.startswith('sgs_%d_' % yil) and f.endswith('.pdf')]
    def sk(f):
        i = dosya_bilgi(f)
        return (i['donem'], i['seviye'], i['kitapcik'], 0 if i['ek'] in ('', 'ingilizce') else 1)
    files.sort(key=sk)
    out, by_key, stats = [], {}, []
    for fn in files:
        info, recs, npg = isle_pdf(fn)
        stats.append(dict(pdf=fn, sayfa=npg, soru=len(recs), tam=sum(r['guven'] == 'tam' for r in recs),
                          son_no=recs[-1]['no'] if recs else 0))
        grp = info['donem']
        etiket = info['kitapcik'] + ('-muaf' if info['ek'] == 'yabancidil_muaf' else '')
        for r in recs:
            key = (grp, anahtar(r['kok'], r['sec']))
            ref = ('' if info['seviye'] == 'lisans' else info['seviye'] + ':') + '%s/%s%d' % (etiket, {'GK': 'G', 'YD': 'Y', 'ALAN': 'A'}[r['bolum']], r['no'])
            js = jetonlar(r['kok'], r['sec'])
            hedef = by_key.get(key)
            if hedef is None and r['guven'] != 'okunamadi':
                adaylar = [(benzer(js, x['_j']), x) for x in out if x['donem'] == grp and x['_j']]
                if adaylar:
                    sc, x = max(adaylar, key=lambda z: z[0])
                    so = benzer(jetonlar('', r['sec']), jetonlar('', x['secenekler']))
                    if sc >= 0.72 and (so >= 0.7 or not r['sec']):
                        hedef = x
            if r['guven'] != 'okunamadi' and hedef is not None:
                hedef['diger_kitapciklar'].append(ref)
                SIRA = {'tam': 0, 'kismi': 1, 'okunamadi': 2}
                if SIRA[r['guven']] < SIRA[hedef['okuma_guveni']]:
                    hedef.update(kok=r['kok'], secenekler={k: r['sec'].get(k, '') for k in 'ABCDE'},
                                 okuma_guveni=r['guven'],
                                 notlar='; '.join(r['notlar'] + ['metin daha temiz okunan kitapçık %s kopyasından alındı' % ref]))
                continue
            if r['guven'] == 'okunamadi' and etiket != 'A':
                continue
            kod, ad = DERS[r['alt']]
            rid = 'SGS-%d-%d-%s-%s-%s%03d' % (info['yil'], info['donem'], info['seviye'].upper(),
                                            etiket.replace('-muaf', 'M'), {'GK': 'G', 'YD': 'Y', 'ALAN': 'A'}[r['bolum']], r['no'])
            rec = dict(id=rid, tur='sgs', yil=info['yil'], donem=info['donem'], seviye=info['seviye'],
                       kitapcik=etiket, ders_kod=kod, ders_ad=ad, alt_ders=r['alt'],
                       yabanci_dil=(r['alt'] == 'YD'), bolum=r['bolum'], no=r['no'], kok=r['kok'],
                       secenekler={k: r['sec'].get(k, '') for k in 'ABCDE'}, dogru=None,
                       kaynak_pdf='content/kaynaklar/cikmis/sgs/' + fn, okuma_guveni=r['guven'],
                       notlar='; '.join(r['notlar']), diger_kitapciklar=[], _j=js)
            by_key[key] = rec
            out.append(rec)
    for x in out:
        x.pop('_j', None)
    os.makedirs(OUT_DIR, exist_ok=True)
    meta = dict(yil=yil, kayit_sayisi=len(out),
                aciklama='Mükerrer kitapçık soruları tek kayıtta; diger_kitapciklar = aynı sorunun diğer kitapçıktaki yeri. '
                         'id/diger_kitapciklar içinde G=genel kültür, Y=yabancı dil, A=alan bilgisi bölümü (eski sınavlarda numaralama bölüm başında sıfırlanır). dogru=null: SGS PDF\'lerinde resmî cevap anahtarı yok. ders ataması kapak sırası + anahtar kelime ile otomatik.',
                pdf_istatistik=stats, sorular=out)
    tmp = os.path.join(OUT_DIR, '%d.json.tmp' % yil)
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(meta, f, ensure_ascii=False, indent=1)
    os.replace(tmp, os.path.join(OUT_DIR, '%d.json' % yil))
    return len(out), stats


if __name__ == '__main__':
    zorla = '--zorla' in sys.argv
    for a in [x for x in sys.argv[1:] if x.isdigit()]:
        y = int(a)
        if not zorla and os.path.exists(os.path.join(OUT_DIR, '%d.json' % y)):
            print(y, 'zaten var, atlandı')
            continue
        n, st = yil_isle(y)
        print(y, 'kayıt', n)
        for s in st:
            print('  ', s['pdf'], s['soru'], 'tam', s['tam'], 'son', s['son_no'])
        sys.stdout.flush()
