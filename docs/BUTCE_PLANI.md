# 79 $ ile yayına çıkış planı

> 3 Ekim 2026 · Kalan bütçe: 79 $ (yalnız Claude kullanımı). Bütçe bitince geliştirme durur;
> bu yüzden her aşama **tek başına çalışan** bir sonuç bırakır ve uygulama yayından sonra **sıfır işletme
> maliyetiyle** yaşar.

## 1. Temel kararlar

| Konu | Karar | Neden |
|---|---|---|
| Sunucu | **Yok.** Supabase ve RevenueCat plandan çıkarıldı. | Aylık maliyet ve bakım gerektirmeyen tek yol. Uygulama zaten internetsiz çalışıyor. |
| Ödeme | Google Play **tek seferlik uygulama içi satın alma** ("Tam erişim"). Abonelik yok. | Sunucusuz yapılabilir, kod azdır, kullanıcıya basit gelir. |
| Platform | **Yalnız Android** (Google Play, tek seferlik 25 $). iOS yok. | Apple yıllık 99 $; bütçeye sığmaz. |
| İlk ürün | **Yalnız Yeterlilik Sınavı.** SGS "yakında" olarak kalır. | Yeterlilik 2026/1'den beri test usulü; yeni formata göre hazırlanmış uygulama boşluğu var. Odaklı ürün daha az soruyla "tam" görünür. |
| Hedef dönem | 2026/3 Yeterlilik (28 Kasım 2026) | Adaylar şu anda çalışıyor. |
| Yayından sonra | Mevzuat güncellemesi yapılamaz; uygulamada "2026 mevzuatına göredir" ibaresi yer alır. | Bütçe sonrası bakım yok. |

## 2. Aşamalar (her biri ayrı bir oturumda; her aşama sonunda bakiye kontrolü)

Her aşama **yeni bir oturumda** `docs/DEVAM.md` okunarak başlar. Uzun oturumlar her mesajda tüm geçmişi yeniden
okuduğu için pahalıdır; kısa oturumlar aynı işi daha ucuza yapar.

| # | Aşama | Bütçe payı (yaklaşık) | Sonunda elde olan |
|---|---|---|---|
| A | **Bilinen hataları düzelt:** düzeltme listesindeki 12 soru + 7 eski not. Ajan kullanılmaz; düzeltme doğrudan yapılır, otomatik kapılar (G2/G4/G7, ücretsiz) yeniden çalıştırılır. | %10 | Temiz 100 soru, güncel PDF |
| B | **Uygulamayı yayına hazırla:** Google Play satın alma, yalnız Yeterlilik, Android derleme ve imzalama, simge, mağaza metinleri, gizlilik politikası sayfası. | %25 | Play Console'a yüklenebilir AAB dosyası |
| C | **Soru üret (Yeterlilik):** her ders en az 20 soruya (tam bir 8 derslik deneme) → +74 soru; bütçe kalırsa ders başı 30–40. Üretim ve kontroller daha ucuz modelle, son denetim mevcut modelle; 20'lik partiler. | %50 | Her parti bitince yayına girebilir |
| D | **Son kontrol ve yayın:** yeni sorular için hakem taraması, muhasebeciye PDF, kapalı test sonrası yayın. | %15 | Mağazada canlı uygulama |

Bir aşamanın ortasında bütçe biterse, o ana kadar kaydedilmiş her şey kullanılabilir durumda kalır
(her parti ayrı kaydedilir ve gönderilir).

## 3. Merve'nin yapacakları (bütçe harcamaz)

1. **Google Play geliştirici hesabı** (25 $, tek sefer) — kimlik doğrulaması birkaç gün sürebilir, hemen başlanmalı.
2. **Kapalı test:** Yeni kişisel hesaplarda yayından önce en az **12 test kullanıcısının 14 gün** boyunca kapalı testte
   kalması gerekiyor. Muhasebeci, arkadaşlar ve stajyer adaylar. Takvim: hesap → test (≈ 20 Ekim) → yayın (≈ 5 Kasım).
3. **Fiyat** ve **uygulama adı** kararı.
4. Muhasebecinin PDF incelemesi (düzeltilmiş PDF ile).
5. Her aşama sonunda Claude kullanım sayfasından kalan bakiyeyi yazmak.

## 4. Takvim

| Tarih | İş |
|---|---|
| 3–6 Ekim | A ve B; Play hesabı açılır |
| 7–20 Ekim | C (partiler halinde); kapalı test başlar |
| 20 Ekim – 3 Kasım | 14 günlük kapalı test; D |
| ≈ 5 Kasım | Yayın — sınava 3 hafta |
| 28 Kasım | 2026/3 Yeterlilik Sınavı |
