# Çıkmış sorular — yapılandırılmış veri raporu

Tarih: 2026-11-02. Kaynak: `content/kaynaklar/cikmis/` (TESMER PDF). Araçlar: `content/cikmis_yapi/_arac/` (poppler `pdftotext -bbox-layout`, Linux VM; doğru şık renkleri için Windows PyMuPDF).

## Özet

- **SGS 2004–2026**: 11516 tekil soru kaydı (`sgs/<yil>.json`), tam okunan **10838 (94.1%)**, kısmi 676, okunamadı 2.
- **SGS doğru cevap**: 4642 kayıtta `dogru` dolu (4456 tanesi seçenek metniyle çapraz doğrulandı). Kaynak: 2014/2 ve 2015+ kitapçıklarında doğru seçenek PDF'te **kırmızı basılı**; buradan çıkarıldı. 2004–2013 ve 2014/1, 2014/3 PDF'lerinde anahtar yok → `dogru: null` (resmî anahtar ayrıca bulunmalı).
- **SMMM 2026 test**: 320 soru (`smmm_test.json`; 2 dönem × 8 ders × 20), tam 303, kısmi 17, okunamadı 0. Doğru cevap PDF içindeki resmî A kitapçığı anahtarından (11 soru İPTAL işaretli); B/C/D kitapçık numaraları `diger_kitapciklar` alanında.
- SMMM 2026 öncesi klasik ve YMM klasik: **yapılmadı** (zaman SGS + SMMM teste ayrıldı).

## SGS yıl tablosu

| Yıl | PDF | Tekil kayıt | tam | kısmi | okunamadı | tam % | yabancı dil | dogru dolu | seviye |
|---|---|---|---|---|---|---|---|---|---|
| 2026 | 8 | 262 | 236 | 26 | 0 | 90.1% | 20 | 262 | lisans 262 |
| 2025 | 12 | 391 | 356 | 35 | 0 | 91.0% | 30 | 390 | lisans 391 |
| 2024 | 12 | 391 | 356 | 35 | 0 | 91.0% | 30 | 391 | lisans 391 |
| 2023 | 12 | 393 | 353 | 40 | 0 | 89.8% | 30 | 390 | lisans 393 |
| 2022 | 12 | 390 | 361 | 29 | 0 | 92.6% | 30 | 390 | lisans 390 |
| 2021 | 12 | 390 | 364 | 26 | 0 | 93.3% | 30 | 390 | lisans 390 |
| 2020 | 12 | 392 | 354 | 38 | 0 | 90.3% | 30 | 392 | lisans 392 |
| 2019 | 20 | 399 | 344 | 55 | 0 | 86.2% | 30 | 375 | lisans 399 |
| 2018 | 24 | 395 | 352 | 43 | 0 | 89.1% | 30 | 386 | lisans 395 |
| 2017 | 24 | 397 | 364 | 33 | 0 | 91.7% | 30 | 394 | lisans 397 |
| 2016 | 24 | 394 | 371 | 23 | 0 | 94.2% | 30 | 392 | lisans 394 |
| 2015 | 12 | 361 | 347 | 14 | 0 | 96.1% | 0 | 361 | lisans 361 |
| 2014 | 12 | 391 | 369 | 22 | 0 | 94.4% | 0 | 129 | lisans 391 |
| 2013 | 6 | 361 | 342 | 19 | 0 | 94.7% | 0 | 0 | lisans 361 |
| 2012 | 6 | 362 | 346 | 16 | 0 | 95.6% | 0 | 0 | lisans 362 |
| 2011 | 6 | 361 | 346 | 15 | 0 | 95.8% | 0 | 0 | lisans 361 |
| 2010 | 6 | 360 | 346 | 14 | 0 | 96.1% | 0 | 0 | lisans 360 |
| 2009 | 6 | 360 | 340 | 20 | 0 | 94.4% | 0 | 0 | lisans 360 |
| 2008 | 14 | 839 | 800 | 39 | 0 | 95.4% | 0 | 0 | lisans 361, lise 241, onlisans 237 |
| 2007 | 9 | 1068 | 1027 | 41 | 0 | 96.2% | 0 | 0 | lisans 360, lise 359, onlisans 349 |
| 2006 | 9 | 1074 | 1042 | 32 | 0 | 97.0% | 0 | 0 | lisans 360, lise 357, onlisans 357 |
| 2005 | 9 | 1070 | 1036 | 32 | 2 | 96.8% | 0 | 0 | lisans 360, lise 354, onlisans 356 |
| 2004 | 6 | 715 | 686 | 29 | 0 | 95.9% | 0 | 0 | lisans 240, lise 239, onlisans 236 |

Beklenen tekil sayılar: 2015–2025 ≈ 3 dönem × 130 (2016–2019 muaf kitapçıkları ingilizce kitapçığın alt kümesi) ; 2009–2014 3 × 120; 2026 2 × 130; 2004–2008 lisans/lise/önlisans ayrı sınavlar (dönem başına 120’şer). Fazlalık (ör. 2014: 391, 2019: 399) çoğunlukla formüllü matematik sorularının B/C/D kitapçığında farklı okunup mükerrer tespit edilememesidir.

## Ders dağılımı (SGS, tüm yıllar)

| ders_kod | ders_ad | kayıt |
|---|---|---|
| DEN | Denetim | 1149 |
| EKO | Ekonomi | 859 |
| FIN | Finansal Muhasebe | 1962 |
| GKY | Atatürk İlkeleri ve İnkılap Tarihi | 330 |
| GKY | Matematik | 823 |
| GKY | Türkçe | 752 |
| GKY | Yabancı Dil (İngilizce) | 320 |
| MAL | Maliyet Muhasebesi | 1037 |
| MES | Meslek Hukuku | 551 |
| MLY | Maliye | 525 |
| SHK | Borçlar Hukuku | 485 |
| SHK | Ticaret Hukuku | 493 |
| SHK | Vergi Hukuku | 658 |
| SHK | İş ve Sosyal Güvenlik Hukuku | 523 |
| STD | Muhasebe Standartları | 281 |
| TAB | Mali Tablolar Analizi | 768 |

`ders_kod` = `content/mufredat/smmm.yaml` kodları (FIN, STD, MAL, TAB, DEN, EKO, MLY, MES, SHK, GKY). SHK ve GKY için `alt_ders` alanı (IS/VER/TIC/BOR, TUR/MAT/ATA/YD). `yabanci_dil: true` = İngilizce soruları.

## SMMM 2026 test

| Dönem | FIN | TAB | MAL | DEN | VER | HUK | MES | SPK |
|---|---|---|---|---|---|---|---|---|
| 1 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |
| 2 | 20 | 20 | 20 | 20 | 20 | 20 | 20 | 20 |

Cevap dağılımı: A 71, B 63, C 64, D 59, E 63 (docs/denetim/smmm_test_2026_karsilastirma.md ile aynı: A71 B63 C64 D59 E63).
## Yöntem

1. Her PDF sayfası `pdftotext -bbox-layout` ile satır koordinatlarına ayrıldı; sol/sağ sütun sayfa ortasına göre bölündü, satırlar y-taban çizgisine göre sıralandı (iki sütunlu düzen). Başlık/altbilgi satırları (TÜRMOB-TESMER, tarih, "Diğer/İzleyen sayfaya geçiniz", sayfa no) atıldı.
2. Soru başı = sıradaki numara (`N.`); eski sınavlarda bölüm başında numaralama sıfırlandığı için iki mod (sürekli / bölüm sıfırlamalı) denendi, daha çok tam seçenekli soru veren seçildi. Kayıt `id` / `diger_kitapciklar` içinde `G`=genel kültür-yetenek, `Y`=yabancı dil, `A`=alan bilgisi bölümü.
3. Seçenekler `A)`…`E)` işaretlerinden ayrıldı (PDF'te sıra karışıksa harfe göre dizildi). Son seçenekten sonra taşan metin (sonraki sorunun parçası) kısa seçenekli sorularda atıldı.
4. **Mükerrer kitapçıklar**: aynı dönemdeki A/B/C/D (ve yabancı dil muaf, 2004–2008'de lise/önlisans ortak soruları) metin benzerliğiyle (kelime Jaccard ≥ 0,72 + seçenek benzerliği ≥ 0,7) tek kayda indirildi; diğer kitapçıktaki yeri `diger_kitapciklar` (ör. `B/A57`, `C-muaf/A47`, `lise:A/G5`). Daha temiz okunan kopyanın metni kullanıldı.
5. **Ders**: kapakta yazan ders sırası + anahtar kelime puanı ile monoton (sıra koruyan) dinamik programlama; GK bölümü Türkçe → Matematik → Atatürk sırasıyla. Otomatik atamadır; bölüm sınırlarındaki 1–2 soru komşu derse kaymış olabilir.
6. **okuma_guveni**: `tam` = kök + 5 seçenek temiz; `kismi` = formül/özel matematik karakteri, tablo/çizelge, grafik/şekil atfı, yevmiye kaydı şıkları (hesap–tutar satırları tek satıra düşer, borç/alacak girintisi kaybolur), eksik/boş seçenek; `okunamadi` = seçenekler çıkarılamadı. Neden `notlar` alanında.
7. 2014/2 kitapçıkları özel kodlu fontla (karakter +29 kaydırmalı) gömülü: kod çözülerek okundu, `notlar`da belirtildi (büyük Ü/Ö/Ğ'de hata olabilir).
8. Doğru şık (SGS): `_arac/renk_cikar.py` (Windows, PyMuPDF) kırmızı metin parçalarını `_arac/renk/*.json`'a yazar; `_arac/dogru_eslestir.py` bunları soru sırasıyla hizalar ve seçenek metniyle doğrular. `dogru_kaynak` alanı eşleme yöntemini ve metin doğrulamasını söyler ("doğrulanamadı" olanlar çoğunlukla formüllü matematik şıkları).

## Rastgele 10 SGS sorusunun PDF ile elle karşılaştırması

PDF sayfası görüntü olarak açılıp kayıtla karşılaştırıldı (görüntüler `_arac/ornek_kontrol/`).

| Kayıt | Ders | Sonuç |
|---|---|---|
| SGS-2020-3-LISANS-A-A114 | Vergi Hukuku | Kök + 5 şık birebir; kırmızı doğru E = kayıttaki `dogru` E |
| SGS-2005-2-LISANS-A-G013 | Matematik | Kök + şıklar birebir (anahtar yok) |
| SGS-2012-3-LISANS-A-A092 | Meslek Hukuku | Birebir |
| SGS-2023-2-LISANS-A-A114 | Vergi Hukuku | Birebir; doğru E eşleşiyor |
| SGS-2024-1-LISANS-A-Y030 | Yabancı Dil | Birebir; doğru B eşleşiyor |
| SGS-2006-3-LISANS-A-A111 | Ticaret Hukuku (defterler) | Birebir |
| SGS-2006-1-LISE-A-A088 | Ekonomi | Birebir |
| SGS-2014-2-LISANS-A-A096 | Meslek Hukuku (kod çözülmüş font) | Metin anlamlı ve tutarlı; sayfa görüntüsünde soru bir sonraki sayfadaydı, harf harf karşılaştırılamadı |
| SGS-2005-1-LISANS-A-G018 | Atatürk İlkeleri | Birebir |
| SGS-2024-2-LISANS-A-A044 | Finansal Muhasebe (tablolu kök) | Tablo satırları metne düzgün aktarılmış; şıklar birebir; doğru B eşleşiyor |

Sonuç: 9/10 tam doğrulandı, 1/10 kısmen (metin tutarlı, görsel karşılaştırma yapılamadı). İncelenen 4 kırmızı doğru şıkkın 4'ü doğru eşlenmiş.

## Bilinen sorunlar / yapılacaklar

- SGS 2004–2013 (+2014/1, 2014/3) için **doğru cevap yok**; resmî anahtarlar TESMER'den ayrıca indirilmeli. Bu kayıtlar soru bankası olarak kullanılabilir ama "çıkmış soru + çözüm" olarak yayımlanmadan önce cevaplanmalı.
- Matematik (özellikle 2016+ formül fontları) ve tablolu sorular `kismi`; yayında bu sorular için PDF görüntüsü/elle düzeltme önerilir.
- Yevmiye kaydı şıkları tek satır metin ("320 SATICILAR 4.800 100 KASA 4.800"); borç/alacak tarafı ayrılmadı.
- 2004–2008 lise/önlisans sınavları ayrı `seviye` değeriyle aynı yıl dosyasında; ortak GK soruları tek kayda indirildi.
- Kayıt sayılarında birkaç düzine mükerrer kalmış olabilir (formüllü sorular).
- Yeniden üretim (Linux, proje kökünden): `python3 -I content/cikmis_yapi/_arac/sgs_ayristir.py <yil...> --zorla` → ardından `python3 -I content/cikmis_yapi/_arac/dogru_eslestir.py <yil...>` (ayrıştırma `dogru`yu sıfırlar, eşleştirme yeniden çalıştırılmalı); `smmm_test.py` SMMM 2026 testi. `renk/` yoksa Windows'ta `renk_cikar.py`.
