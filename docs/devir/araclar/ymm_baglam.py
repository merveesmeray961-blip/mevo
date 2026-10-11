"""Yazar ajanı için ders özeti: konu/kazanımlar, kaynak dosya önekleri, bankadaki soru kökleri (kısaltılmış) ve
geri çekilme gerekçeleri. Ajan tüm YAML dosyalarını okumak yerine bu küçük dosyayı okur (token tasarrufu).

    python3 docs/devir/araclar/ymm_baglam.py DERS KONU1,KONU2 > baglam_X.md
"""
import sys
from pathlib import Path
import yaml
K = Path(__file__).resolve().parents[3] / 'content'
ders, konular = sys.argv[1], sys.argv[2].split(',')
m = {d['kod']: d for d in yaml.safe_load((K / 'mufredat/ymm.yaml').read_text())['dersler']}[ders]
print(f"# {ders} — {m['ad']}\nKaynak dosya önekleri: {', '.join(m['kaynak_dosyalari']) or 'yok (genel bilgi)'}\n")
for k in m['konular']:
    if k['kod'] not in konular: continue
    print(f"## {k['kod']} — {k['ad']}\nKazanımlar: {'; '.join(k['kazanimlar'])}\n\nBankada olan (tekrar etme):")
    nedenler = []
    for p in sorted((K / 'sorular/ymm' / ders).glob(f"{k['kod']}.*.yaml")):
        for s in yaml.safe_load(p.read_text()):
            if s['durum'] == 'kontrolde':
                print(f"- {' '.join(str(s['kok']).split())[:110]}")
            elif s['durum'] == 'geri_cekildi':
                nedenler.append(str(s.get('uretim', {}).get('kapilar', {}).get('G5', {}).get('not', ''))[:100])
    for p in sorted((K / 'klasik/ymm' / ders).glob(f"{k['kod']}.yaml")):
        for s in yaml.safe_load(p.read_text()):
            if s['durum'] == 'kontrolde':
                print(f"- [klasik] {' '.join(s['soru'].split())[:110]}")
    if nedenler:
        print("\nElenen sorularda sık hatalar (bunlara düşme):")
        for n in nedenler[:8]:
            print(f"- {n}")
    print()
