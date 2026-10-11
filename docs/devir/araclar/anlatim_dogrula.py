import sys, json
sys.path.insert(0, '/home/user/mevo')
from pathlib import Path
from pipeline import anlatim
R = Path('<SCRATCHPAD>/revizyon')
d = anlatim._dersler()
ok = 0
for y in sorted((R/'cikti').glob('*/*.md')):
    try:
        b, t = anlatim.oku(y); h = anlatim.denetle(b, t, d)
    except Exception as e:
        h = [repr(e)]
    w = len(t.split()) if not h or 'oku' else 0
    ipucu = t.count('> **Sınav ipucu') + t.count('> **Sık yapılan hata')
    flag = []
    if h: flag += h
    if ipucu < 2: flag.append(f'ipucu {ipucu}')
    if '## Özet' not in t: flag.append('özet yok')
    if b.get('durum') != 'kontrolde': flag.append('durum ' + str(b.get('durum')))
    if flag: print(y.parent.name + '/' + y.stem, flag)
    else: ok += 1
print('temiz', ok)
