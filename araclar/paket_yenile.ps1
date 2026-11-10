Set-Location "C:\Users\erene\OneDrive\Masa$([char]0xfc)st$([char]0xfc)\RistayCraft-Yonetim-Platformu"
$env:PYTHONIOENCODING = 'utf-8'
'=== denetle'
python -m pipeline.klasik denetle --sinav ymm 2>&1 | Select-Object -Last 3
'=== ymm'
python -m pipeline.disa_aktar app/assets/sorular/ymm.json --uygulama --urun ymm 2>&1 | Select-Object -Last 4
'=== smmm'
python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama 2>&1 | Select-Object -Last 4
python -c "import json;[print(u, {k:len(v) for k,v in json.load(open(f'app/assets/sorular/{u}.json',encoding='utf-8')).items() if isinstance(v,list)}) for u in ('smmm','ymm')]"
'PAKET BITTI'
