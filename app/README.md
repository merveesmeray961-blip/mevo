# Mevo SMMM — mobil uygulama

Flutter ile yazılmış, internetsiz çalışan SMMM (Staja Giriş ve Yeterlilik) hazırlık uygulaması.

## Neler var

- Bölüm seçimi (SGS / Yeterlilik), sıradaki sınava geri sayım
- Ders ve konu bazlı çalışma; her cevaptan sonra çözüm, "neden bu şık değil", püf noktaları ve dayanak madde alıntıları
- Aralıklı tekrar (1–3–7–16–35 gün), yanlış defteri, işaretlenen sorular
- Gerçek kurallarla deneme: Yeterlilik ders/oturum denemeleri (20 soru/45 dk, 0,25 ceza, ders ≥50 / ortalama ≥60), SGS alan bilgisi denemesi
- İstatistik: son 7 gün, ders bazında başarı, zayıf konular
- Ücretsiz katman (günde 20 soru, 1 deneme) ve ödeme ekranı — ödeme altyapısı `lib/abonelik/` arayüzü üzerinden bağlanacak
- Hata bildirimi, KVKK / gizlilik / kullanım koşulları taslakları

## Soru paketi

`assets/sorular/smmm.json` soru bankasından üretilir; elle düzenlenmez:

    cd .. && python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama

## Geliştirme

    flutter test          # birim ve ekran testleri
    flutter analyze
    flutter build web --release --no-web-resources-cdn   # önizleme
    flutter build appbundle / ipa                         # mağaza (imzalama ayarları gerekir)

Yazı tipi: Roboto (SIL Open Font License 1.1, `assets/fonts/OFL.txt`).
