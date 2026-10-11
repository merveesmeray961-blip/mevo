import sys
sys.path.insert(0, '/home/user/mevo')
from pathlib import Path
from pipeline import anlatim, uretici_paketi as u
for f in sys.argv[1:]:
    b, t = anlatim.oku(Path(f))
    for k in b.get('kaynaklar') or []:
        n = u._norm(k['alinti'])
        hits = [s for s, m in u._metinler().items() if n in m]
        print(len(k['alinti']), k['madde'], hits)
