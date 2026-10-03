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

## Mobil uygulama

- Kod: `app/` (Flutter) — ayrıntılar `app/README.md`
- Web önizlemesi: https://claude.ai/artifact/5wqhHpzT192EAPJ7sXzsAd (özel; önizlemede ödeme alınmaz)
- Güncelleme: `python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama`, `cd app && flutter build web --release --no-web-resources-cdn`, ardından aynı sayfa dosyasıyla yeniden yayın (`*.symbols` ve `AssetManifest.bin` yüklenmez).

## Önizleme ve uzman inceleme

- Yayın: https://claude.ai/artifact/78StxYMPoB5ABFYo7Wtfwh (özel; yalnız paylaşılan kişiler açabilir)
- Güncelleme: `python -m pipeline.disa_aktar web/onizleme/sorular.json`, ardından aynı dosya yoluyla yeniden yayın.
- Uzman kararları sayfanın veritabanında `inceleme/<soru-id>` belgelerinde tutulur (karar, kategori, not, sürüm).
