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
