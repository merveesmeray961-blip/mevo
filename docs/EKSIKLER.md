# Yayın öncesi eksik listesi (güncel: 2026-10-29)

Durum: iki uygulama (**Mizan SMMM**, **Tasdik YMM**) derlendi, imzalı AAB/APK hazır (`C:\Users\erene\dev\teslim\`),
analiz temiz, Flutter 355 ve Python 100 test geçiyor. Aşağıdakiler **kalan işlerdir**; sıra öncelik sırasıdır.

## A. Yayını engelleyenler (kullanıcı)

| # | İş | Not |
|---|---|---|
| A1 | **Destek e-postası ve veri sorumlusu adı** | `app/lib/uygulama.dart` `destekEposta`, `app/lib/ekranlar/yasal.dart` (2 yer), `docs/magaza/gizlilik.html` (2 yer) boş. E-posta açılınca verilecek. |
| A2 | **Yükleme anahtarı yedeği** | `C:\Users\erene\dev\mevo_gizli\` (jks + parola) USB + şifreli buluta. Kaybolursa güncelleme çıkarılamaz. |
| A3 | **Google Play geliştirici hesabı** (25 $) | İki uygulama + her birinde `tam_erisim` ürünü ve fiyatı. |
| A4 | **Gizlilik sayfasını internete koymak** | `docs/magaza/gizlilik.html` (Netlify Drop / GitHub Pages; bkz. `YAYIN.md` 0.2). Önce A1 doldurulmalı. |
| A5 | **Avukat onayı** | KVKK aydınlatma, gizlilik, kullanım koşulları. Taslaklar genişletildi ama hukuki görüş alınmadı. |
| A6 | **Satıcı kaydı** | Uygulamadan gelir için kişi/şirket ve vergi kaydı. |
| A7 | **Marka/ad kontrolü** | "Mizan" ve "Tasdik" adlarını turkpatent.gov.tr ve Google Play'de aratmak. Çıkarsa yedek ad. |
| A8 | **Kapalı test** | Notlarda "12 kişi × 14 gün" yazıyor; iki uygulama için ayrı ayrı gerekip gerekmediği Play Console'da doğrulanmalı. |

## B. Güven ve kalite (yayın öncesi önerilen)

| # | İş | Not |
|---|---|---|
| B1 | **Uzman teyidi** | SMMM: `docs/SMMM_Uzman_Kitapcik.pdf`; YMM: `docs/YMM_Uzman_Kitapcik.pdf` (60 test + 20 klasik, 68 sayfa). Hiçbir içerik insan uzman onayından geçmedi. YMM'de 2026 oranları (11257/9160/9707 CBK; 7555/7566/7582 s. Kanunlar) özellikle. |
| B2 | **Gerçek telefonda deneme** | Sesli okuma (Türkçe ses kalitesi), satın alma akışı (yalnız Play'den kurulan sürümde çalışır), ücretsiz katmanın hissi. Test edilemedi. |
| B3 | **Olumsuz kök oranı** | SMMM %13,7; resmî sözel derslerde %36–56. Sözel derslerde "…hangisi yanlıştır/değildir" soruları artırılmalı (`docs/denetim/2026-10-29_kalite_olcumu.md`). |
| B4 | **Kalan biçim farkları** | SMMM'de sayısal şıkların %19'u sırasız; YMM'de kökte madde numarası %17, BDS numarası %7,6. |
| B5 | **Kaynağı olmayan kazanımlar** | matrah artırımı (7143/7326/7440), TFRS 1, TFRS 13, konaklama vergisi 2026 oranı, YTM 2026 azami tazminat. |
| B6 | **Anlatımda insan kontrolü** | STD/KRL TSRS kapsam eşikleri, SPK/YHZ III-39.1 (kaynak klasöründe yok); `docs/denetim/2026-10-18_anlatim/grup*.md` "emin olunamayan" maddeler. |
| B7 | **Telif için hukuk görüşü** | Standart/mevzuat alıntıları ve çıkmamış sorulardan esinlenme. |

## C. Ürün ve içerik geliştirmeleri

| # | İş | Durum |
|---|---|---|
| C1 | **Soru artırımı** | SMMM 3.223 → hedef 5.000+ (≈1.800 eksik); YMM 1.887 → hedef 3.000+ (≈1.100 eksik; YMM'de elenme oranı ~%56). Harici üretici + denetim hattı gerekir; maliyet bilinmiyor, önce ~100 soruluk deneme önerilir. |
| C2 | **Arayüz yenilemesi** | Yalnız küçük iyileştirmeler yapıldı (karşılama, ayar grupları, başa dön, geri sayım rengi). "2026 arayüzü" için tasarım yönü seçilip ekranlar yeniden çizilmeli. |
| C3 | **Reklam kararı (YMM)** | YMM'yi ücretsiz+reklamlı yapmak istenirse: reklam kütüphanesi, gizlilik/KVKK/Data safety/yaş derecelendirmesi yeniden yazılır. Şu an uygulama "reklamsız, izlemez". |
| C4 | **Tanıtım videosu, videolu anlatım** | Yapılmadı; bütçe ve araç gerektirir. |
| C5 | **Uygulama içi uzman işareti** | Uzman teyidi gelince "uzman onaylı" etiketi ve sürüm notu. |

## D. Teknik borç ve küçük işler

- iOS: `flutter build ipa` Mac + Xcode ister; iOS'ta flavor/scheme kurulmadı (iki uygulama yalnız Android'de ayrılıyor).
- Web önizleme `--flavor` desteklemez; `docs/devir/araclar/web_onizleme.py` kullanılır.
- Dart paket adı (`mevo`) ve Kotlin namespace değişmedi (kullanıcıya görünmez).
- Depoda `YMM_konu_anlatimlari_TUMU.zip` izlenmiyor (commit edilmedi); kök dizindeki eski APK/AAB'ler `.gitignore`'da.
- `docs/magaza/VERI_GUVENLIGI_VE_DERECELENDIRME.md` iki uygulama için ortaktır; reklam eklenirse yenilenmeli.
- Play Console ekran görüntüleri **telefon** boyutunda; 7"/10" tablet görüntüleri yok (isteğe bağlı).
