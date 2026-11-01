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

const anaRenk = Color(0xFF4B3FE0);

/// Hata bildirimlerinin ve destek taleplerinin gittiği adres (gizlilik metnindeki iletişim adresiyle aynı).
/// Boşsa bildirim yalnız cihaza kaydedilir; yayından önce doldurulmalıdır.
const destekEposta = 'ristaycraft@gmail.com';

/// Görsel kimlik (Yön C): çivit / mürekkep ana renk, limon vurgu. Limon, ana çağrı düğmelerinde ve vurgularda kullanılır.
const limon = Color(0xFFC8F04A);
const limonYazi = Color(0xFF111827);

/// Ana rengi koyu mürekkep olan uygulama (Tasdik YMM) mı?
bool _murekkep(Color c) => c.computeLuminance() < 0.03;

ThemeData tema(Brightness parlaklik, [Color renk = anaRenk]) {
  final koyu = parlaklik == Brightness.dark;
  final murekkep = _murekkep(renk);
  final temel = ColorScheme.fromSeed(seedColor: murekkep ? const Color(0xFF3B4A6B) : renk, brightness: parlaklik);
  final renkler = koyu
      ? temel.copyWith(
          primary: murekkep ? limon : const Color(0xFFB3ADFF),
          onPrimary: murekkep ? limonYazi : const Color(0xFF1B1466),
          primaryContainer: murekkep ? const Color(0xFF2A3245) : const Color(0xFF332A9E),
          onPrimaryContainer: murekkep ? const Color(0xFFEEF9C8) : const Color(0xFFE7E4FF),
          secondary: limon,
          onSecondary: limonYazi,
          secondaryContainer: const Color(0xFF34401A),
          onSecondaryContainer: const Color(0xFFE6F7B5),
          surface: const Color(0xFF0F1320),
          onSurface: const Color(0xFFECEDF3),
          onSurfaceVariant: const Color(0xFFA9AEBE),
          surfaceContainerLowest: const Color(0xFF0B0E18),
          surfaceContainerLow: const Color(0xFF151A29),
          surfaceContainer: const Color(0xFF191F30),
          surfaceContainerHigh: const Color(0xFF1F2638),
          surfaceContainerHighest: const Color(0xFF262E42),
          outline: const Color(0xFF6E7488),
          outlineVariant: const Color(0xFF2C3246),
          error: const Color(0xFFFF8A80),
        )
      : temel.copyWith(
          primary: renk,
          onPrimary: Colors.white,
          primaryContainer: murekkep ? const Color(0xFFE6E8EE) : const Color(0xFFECEAFE),
          onPrimaryContainer: murekkep ? const Color(0xFF111827) : const Color(0xFF2A1FA8),
          secondary: const Color(0xFF5B7A00),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFEEF9C8),
          onSecondaryContainer: const Color(0xFF2E3D00),
          tertiaryContainer: const Color(0xFFFFE8D6),
          onTertiaryContainer: const Color(0xFF6B2C00),
          surface: const Color(0xFFF4F4F8),
          onSurface: const Color(0xFF111827),
          onSurfaceVariant: const Color(0xFF555B6E),
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainer: const Color(0xFFF0F0F5),
          surfaceContainerHigh: const Color(0xFFEBEBF2),
          surfaceContainerHighest: const Color(0xFFE4E4EC),
          outline: const Color(0xFF8C90A0),
          outlineVariant: const Color(0xFFE2E2EC),
          error: const Color(0xFFC0362C),
        );
  // Başlıklar Sora (karakterli, geniş), gövde metni Roboto (uzun mevzuat ve soru metninde okunaklı). ₺ gibi Sora'da
  // olmayan işaretler Roboto'dan gelir.
  final temelYazi = ThemeData(brightness: parlaklik, fontFamily: 'Roboto', useMaterial3: true).textTheme;
  TextStyle? sora(TextStyle? s, FontWeight w, [double harf = 0]) =>
      s?.copyWith(fontFamily: 'Sora', fontFamilyFallback: const ['Roboto'], fontWeight: w, letterSpacing: harf);
  final yazilar = temelYazi.copyWith(
    displayLarge: sora(temelYazi.displayLarge, FontWeight.w800, -1),
    displayMedium: sora(temelYazi.displayMedium, FontWeight.w800, -1),
    displaySmall: sora(temelYazi.displaySmall, FontWeight.w800, -0.5),
    headlineLarge: sora(temelYazi.headlineLarge, FontWeight.w800, -0.5),
    headlineMedium: sora(temelYazi.headlineMedium, FontWeight.w800, -0.5),
    headlineSmall: sora(temelYazi.headlineSmall, FontWeight.w800, -0.3),
    titleLarge: sora(temelYazi.titleLarge, FontWeight.w700, -0.2),
    titleMedium: sora(temelYazi.titleMedium, FontWeight.w600),
    titleSmall: sora(temelYazi.titleSmall, FontWeight.w600),
    labelLarge: sora(temelYazi.labelLarge, FontWeight.w600),
    labelMedium: sora(temelYazi.labelMedium, FontWeight.w600),
    labelSmall: sora(temelYazi.labelSmall, FontWeight.w600),
  );
  final yuvarlak = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  return ThemeData(
    colorScheme: renkler,
    fontFamily: 'Roboto',
    textTheme: yazilar,
    useMaterial3: true,
    scaffoldBackgroundColor: renkler.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: renkler.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0.5,
      titleTextStyle: yazilar.titleLarge?.copyWith(color: renkler.onSurface, fontSize: 20),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: renkler.surfaceContainerLowest,
      indicatorColor: renkler.primaryContainer,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontFamily: 'Sora',
          fontSize: 11.5,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: renkler.surfaceContainerLowest,
      indicatorColor: renkler.primaryContainer,
    ),
    chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    cardTheme: CardThemeData(
      elevation: 0,
      color: renkler.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: renkler.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: ListTileThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: yuvarlak,
        textStyle: const TextStyle(fontSize: 16, fontFamily: 'Sora', fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: yuvarlak,
        side: BorderSide(color: renkler.outlineVariant),
        textStyle: const TextStyle(fontSize: 15, fontFamily: 'Sora', fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(textStyle: const TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.w600)),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(textStyle: const TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.w600)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: renkler.surfaceContainerLowest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: renkler.outlineVariant)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: renkler.outlineVariant),
      ),
    ),
    dividerTheme: DividerThemeData(color: renkler.outlineVariant, space: 1),
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
