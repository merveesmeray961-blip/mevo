import 'package:flutter/material.dart';

import 'abonelik/abonelik.dart';
import 'bilesenler/sesli_okuma.dart';
import 'urun.dart';
import 'veri/ayarlar.dart';
import 'veri/ilerleme.dart';
import 'veri/modeller.dart';
import 'veri/notlar.dart';

/// Uygulama genelinde paylaşılan nesneler. Ekranlar `Kapsam.of(context)` ile erişir.
class UygulamaDurumu {
  final SoruBankasi banka;
  final Ilerleme ilerleme;
  final Ayarlar ayarlar;
  final AbonelikServisi abonelik;
  final Notlar notlar;

  /// Çalışan uygulama (Mizan SMMM veya Tasdik YMM).
  final Urun urun;

  /// Sesli okuma motoru (mobilde cihazın Türkçe sesi; testlerde ve webde sessiz).
  final SesMotoru ses;

  UygulamaDurumu({
    required this.banka,
    required this.ilerleme,
    required this.ayarlar,
    required this.abonelik,
    required this.notlar,
    this.urun = Urun.smmm,
    SesMotoru? ses,
  }) : ses = ses ?? SessizSes();

  /// Kullanıcının seçtiği bölüm bu uygulamaya ait mi? (Tek bölümlü uygulamada seçim gerekmez; eski sürümden kalma
  /// başka uygulamaya ait bir değer geçersiz sayılır ve bölüm yeniden sorulur.)
  bool get bolumSecildi => !urun.bolumSecimiVar || urun.bolumler.contains(ayarlar.bolum);

  /// Çalışılan bölüm: tek bölümlü uygulamada hep o bölüm; aksi hâlde seçilen, seçilmemişse Yeterlilik.
  String get bolum => !urun.bolumSecimiVar
      ? urun.bolumler.single
      : (urun.bolumler.contains(ayarlar.bolum) ? ayarlar.bolum! : 'YET');

  /// Ücretsiz kullanıcı günlük soru sınırına ulaştıysa false.
  bool get soruHakkiVar => abonelik.premium || ilerleme.bugunCozulen < ucretsizGunlukSoru;

  int get kalanUcretsizSoru => (ucretsizGunlukSoru - ilerleme.bugunCozulen).clamp(0, ucretsizGunlukSoru);

  bool get denemeHakkiVar => abonelik.premium || ilerleme.denemeler.length < ucretsizDeneme;

  /// Ücretsiz kullanıcıya açık konu anlatımı: her dersin anlatımı bulunan ilk konusu (müfredat sırasıyla).
  /// Tam erişimde hepsi açıktır. Böylece kullanıcı anlatımın kalitesini görür, devamı için tam erişim ister.
  bool anlatimAcik(Ders ders, String konu) {
    if (abonelik.premium) return true;
    for (final k in ders.konular.keys) {
      if (banka.anlatim(ders.kod, k) != null) return k == konu;
    }
    return true;
  }

  Listenable get degisim => Listenable.merge([ilerleme, ayarlar, abonelik, notlar]);
}

class Kapsam extends InheritedWidget {
  final UygulamaDurumu durum;

  const Kapsam({super.key, required this.durum, required super.child});

  static UygulamaDurumu of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Kapsam>()!.durum;

  @override
  bool updateShouldNotify(Kapsam eski) => eski.durum != durum;
}

const anaRenk = Color(0xFF0F6B5C);

/// Hata bildirimlerinin ve destek taleplerinin gittiği adres (gizlilik metnindeki iletişim adresiyle aynı).
/// Boşsa bildirim yalnız cihaza kaydedilir; yayından önce doldurulmalıdır.
const destekEposta = 'ristaycraft@gmail.com';

ThemeData tema(Brightness parlaklik, [Color renk = anaRenk]) {
  // Koyu temada "canlı" şema: ana düğmeler soluk nane rengine dönmeden belirgin kalır. Açık temada varsayılan
  // (yumuşak tonlu) şema, canlı şemanın neon tonlarından daha dinlendiricidir.
  final renkler = ColorScheme.fromSeed(
    seedColor: renk,
    brightness: parlaklik,
    dynamicSchemeVariant: parlaklik == Brightness.dark ? DynamicSchemeVariant.vibrant : DynamicSchemeVariant.tonalSpot,
  );
  final temel = ThemeData(brightness: parlaklik, fontFamily: 'Roboto', useMaterial3: true).textTheme;
  // Başlıklar daha karakterli: kalın ağırlık, hafif sıkı harf aralığı; gövde metni okunaklı kalır.
  final yazilar = temel.copyWith(
    headlineMedium: temel.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
    headlineSmall: temel.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
    titleLarge: temel.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
    titleMedium: temel.titleMedium?.copyWith(fontWeight: FontWeight.w600),
  );
  return ThemeData(
    colorScheme: renkler,
    // Yazı tipi uygulamaya gömülüdür; web sürümü internetten yazı tipi indirmez.
    fontFamily: 'Roboto',
    textTheme: yazilar,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: renkler.surface,
      scrolledUnderElevation: 1,
      titleTextStyle: yazilar.titleLarge?.copyWith(color: renkler.onSurface),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: renkler.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) =>
            TextStyle(fontSize: 12, fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500),
      ),
    ),
    chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: renkler.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      // Yazı tipi açıkça verilir: düğme yazısı, gömülü Roboto'dan başka bir yazı tipine düşmesin.
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
      ),
    ),
  );
}

/// Doğru / yanlış renkleri (açık ve koyu temada okunur).
Color dogruRenk(BuildContext c) =>
    Theme.of(c).brightness == Brightness.dark ? const Color(0xFF6FD3A0) : const Color(0xFF1B7F4B);
Color yanlisRenk(BuildContext c) =>
    Theme.of(c).brightness == Brightness.dark ? const Color(0xFFFF8A80) : const Color(0xFFC62828);

const zorlukAdi = {1: 'Kolay', 2: 'Orta', 3: 'Zor'};
const bolumAdi = {'SGS': 'Staja Giriş Sınavı', 'YET': 'Yeterlilik Sınavı', 'YMM': 'Yeminli Mali Müşavirlik Sınavı'};

const _aylar = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

String tarihYaz(DateTime t) => '${t.day} ${_aylar[t.month - 1]} ${t.year}';

String sureYaz(int sn) {
  final s = sn ~/ 3600, d = (sn % 3600) ~/ 60, k = sn % 60;
  final dk = d.toString().padLeft(2, '0'), sk = k.toString().padLeft(2, '0');
  return s > 0 ? '$s:$dk:$sk' : '$dk:$sk';
}

/// Türkçe ondalık yazımı: 62,5
String sayiYaz(double x, {int basamak = 1}) {
  final s = x.toStringAsFixed(basamak);
  return (s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s).replaceAll('.', ',');
}
