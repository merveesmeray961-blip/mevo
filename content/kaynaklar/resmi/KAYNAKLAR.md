# Resmî kaynak arşivi (Katman A)

PDF ve metin dosyaları depoya **eklenmez** (`.gitignore`). Bu dizin, hangi belgenin nereden, ne zaman indirildiğini ve içeriğinin değişmediğini (SHA-256) kayıt altına alır. Yeniden indirmek için `indir.sh` kullanılır.

İndirme tarihi: 3 Ekim 2026

| Dosya | Belge | Kaynak | SHA-256 |
|---|---|---|---|
| `test_karari_tesmer.pdf` | TÜRMOB YK kararı E.233, 14.01.2026: SMMM sınavı test yöntemi (e-imzalı, ekli açıklamalar) | https://www.tesmer.org.tr/wp-content/uploads/2024/12/2684286SMMM-Sinavi-Yapilma-Yontemi__5.pdf | a9c9099fe4c98bdfc31bfe7a5459ea4cc62234139ceca67cbbe010ee36f1779f |
| `test_karari_ismmmo.pdf` | Aynı kararın İSMMMO duyurusu | https://www.ismmmo.org.tr/dosya/5865/Staj-Dosya/15012026-smmm-sinav-degisiklik-duyuru.pdf | 485d3dfe2c88f2be7dcd1ad77ad92563a25bee7ba869366a202631f542774f47 |
| `sinav_yonetmeligi_2025.pdf` | YMM ve SMMM Sınav Yönetmeliği (24.02.2025 değişiklikleri işlenmiş, TÜRMOB konsolide metni) | https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/YONETMELIKLER_3MART2025/6-S%C4%B1nav-2025.pdf | fba318e05ae5a274cfa0f83512e235c1e03877ec7bb17196c28e401e3240ff77 |
| `staj_yonetmeligi_2025.pdf` | SMMM Staj Yönetmeliği (konsolide) | https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/YONETMELIKLER_3MART2025/4-Staj-2025.pdf | 2177f5fc3e75b01a5ce62840c0cd9623dd5f7a31a9fda840e8f1c85b0000facd |
| `yonerge_2026.pdf` | TESMER Staj ve Sınavlara İlişkin Uygulama Yönergesi 2026 | https://www.tesmer.org.tr/wp-content/uploads/2026/01/TESMER-Staj-ve-Sinavlara-Iliskin-Uygulama-Yonergesi-2026.pdf | 66317049b413c853d03983461825436bdb8294d3f5d95d9bb2495fae1ca808b2 |
| `takvim_2026.pdf` | TÜRMOB 2026 sınav takvimi | https://www.tesmer.org.tr/wp-content/uploads/2024/12/TURMOB_2026_sinav_takvimi.pdf | 433fe1fa8cf6048d682a5b1199947e34eb950d1d7c82eb745fa55604e28fcea7 |
| `asym_sgs_2025_1.pdf` | ASYM SGS 2025/1 uygulama kılavuzu | https://asym.ankara.edu.tr/wp-content/uploads/sites/372/2025/03/TURMOB-TESMER-STAJA-GIRIS-SINAVI-2025-1.DONEM-UYGULAMA-KILAVUZU.pdf | 3be79d9d00ba6fb4520dcd5dd5aec7ab8f704043a3859b8cc551728f7336d5a7 |

## Erişilemeyenler

- **resmigazete.gov.tr** ve **mevzuat.gov.tr**: çalışma ortamından zaman aşımı (muhtemelen yurt dışı bağlantı kısıtı). Yönetmeliklerin konsolide metinleri TÜRMOB'dan alındı. Kanun metinleri için alternatif kaynak gerekecek.
- **TESMER 2026 ücretler PDF'i**: bağlantı yanıt vermedi.

## Katman C: çıkmış soru kitapçıkları

TESMER'in resmî arşivi (https://www.tesmer.org.tr/?p=2050) her sayfada şu notu taşır: *"TESMER'in yazılı izni olmadan kopya edilmesi, … çoğaltılması, yayımlanması ya da kullanılması yasaktır."* Bu nedenle kitapçıklar **depoya alınmaz**. Yalnızca geçici çalışma alanında okunup konu, ağırlık ve tarz analizi yapılır; analiz çıktılarında soru metni yer almaz.
