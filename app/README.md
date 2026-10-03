# Mevo SMMM — mobil uygulama

Flutter ile yazılmış, internetsiz çalışan SMMM (Staja Giriş ve Yeterlilik) hazırlık uygulaması.

## Neler var

- Bölüm seçimi (SGS / Yeterlilik), sıradaki sınava geri sayım
- Ders ve konu bazlı çalışma; her cevaptan sonra çözüm, "neden bu şık değil", püf noktaları ve dayanak madde alıntıları
- Aralıklı tekrar (1–3–7–16–35 gün), yanlış defteri, işaretlenen sorular
- Gerçek kurallarla deneme: Yeterlilik ders/oturum denemeleri (20 soru/45 dk, 0,25 ceza, ders ≥50 / ortalama ≥60), SGS alan bilgisi denemesi
- İstatistik: son 7 gün, ders bazında başarı, zayıf konular
- Ücretsiz katman (günde 20 soru, 1 deneme) ve tek seferlik "Tam erişim" satın alımı (Google Play / App Store, ürün kimliği `tam_erisim`, fiyat mağazadan okunur; web önizlemesinde sahte `OnizlemeAbonelik`)
- Telefon ve tablet düzeni: okuma genişliği 720 dp, geniş ekranda yan çubuk, yazı ölçeği 2.0'a kadar, koyu tema
- Hata bildirimi, KVKK / gizlilik / kullanım koşulları taslakları

## Soru paketi

`assets/sorular/smmm.json` soru bankasından üretilir; elle düzenlenmez:

    cd .. && python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama

## Geliştirme

    flutter test          # birim ve ekran testleri (düzen testleri dahil)
    flutter analyze
    flutter build web --release --no-web-resources-cdn   # önizleme (sahte ödeme)
    flutter build appbundle --release                     # Android mağaza paketi
    flutter build apk --release --split-per-abi           # elle kurulacak APK
    flutter build ipa --release                           # iOS (yalnızca Mac + Xcode)

Android derlemesi için Android SDK (`ANDROID_HOME`) gerekir. Yayın imzası `android/key.properties` dosyasından okunur
(git'e girmez; yoksa debug anahtarı kullanılır ve paket mağazaya yüklenemez). Mağaza adımları, anahtar yedeği ve
yeni soru ekleyip güncelleme çıkarma: `../docs/YAYIN.md`. Mağaza metinleri ve gizlilik sayfası: `../docs/magaza/`.

Simge: `assets/ikon/ikon.png` (1024 px) + `on_plan.png`; değişirse `dart run flutter_launcher_icons`.
Yazı tipi: Roboto (SIL Open Font License 1.1, `assets/fonts/OFL.txt`).
