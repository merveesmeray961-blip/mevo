"""YMM hakem kararlarını uygular: kabul → kontrolde, ret → geri_cekildi (gerekçeyle)."""
import json, glob
from pathlib import Path
import yaml
S = '<SCRATCHPAD>/ymm_hakem/'
H = {}
for f in sorted(glob.glob(S + 'h*.json')): H.update(json.load(open(f)))
BUGUN = "2026-10-11"; n = {"kabul": 0, "ret": 0}
for p in Path('/home/user/mevo/content/sorular/ymm').rglob('*.yaml'):
    d = yaml.safe_load(p.read_text(encoding='utf-8')); deg = False
    for s in d:
        h = H.get(s['id'])
        if s.get('durum') != 'taslak' or not h: continue
        ok = h.get('uygun') and h.get('cevap') == s['dogru'] and int(h.get('guven') or 0) >= 4
        k = s.setdefault('uretim', {}).setdefault('kapilar', {})
        if ok:
            k['G5'] = {"sonuc": "gecti", "tarih": BUGUN, "not": f"kitap düzeyi hakem: uygun, anahtarla aynı (güven {h['guven']}, seviye {h.get('seviye')})"}
            s['durum'] = 'kontrolde'; n['kabul'] += 1
            s.setdefault('gecmis', []).append({"tarih": BUGUN, "kim": "hakem", "ne": "durum: taslak → kontrolde", "neden": "kitap düzeyi hakem kabulü"})
        else:
            neden = h.get('neden') or f"hakem cevabı {h.get('cevap')} ≠ anahtar {s['dogru']}"
            k['G5'] = {"sonuc": "kaldi", "tarih": BUGUN, "not": neden}
            s['durum'] = 'geri_cekildi'; n['ret'] += 1
            s.setdefault('gecmis', []).append({"tarih": BUGUN, "kim": "hakem", "ne": "durum: taslak → geri_cekildi", "neden": neden})
        deg = True
    if deg: p.write_text(yaml.safe_dump(d, allow_unicode=True, sort_keys=False, width=120), encoding='utf-8')
print(n)
