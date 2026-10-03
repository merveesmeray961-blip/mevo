# mevo

Meslek sınavlarına hazırlık uygulaması. İlk sınav: **SMMM** (Staja Giriş + Yeterlilik).

- [Ana plan](docs/PLAN.md)
- [Araştırma özeti](docs/ARASTIRMA.md)

## Yapı

```
docs/       planlar ve araştırmalar
content/    sınav formatları, müfredat, şema, soru bankası
pipeline/   soru üretimi ve kalite kapıları
tests/      testler
```

## Kalite kapısı G2 (yapı denetimi)

```
pip install pyyaml jsonschema pytest
python -m pytest tests
python -m pipeline.g2_yapi content/sorular/smmm
```

## Önizleme ve uzman inceleme

- Yayın: https://claude.ai/artifact/78StxYMPoB5ABFYo7Wtfwh (özel; yalnız paylaşılan kişiler açabilir)
- Güncelleme: `python -m pipeline.disa_aktar web/onizleme/sorular.json`, ardından aynı dosya yoluyla yeniden yayın.
- Uzman kararları sayfanın veritabanında `inceleme/<soru-id>` belgelerinde tutulur (karar, kategori, not, sürüm).
