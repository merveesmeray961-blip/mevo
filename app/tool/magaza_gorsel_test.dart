// Mağaza ekran görüntülerini üretir (normal test paketine girmez; `tool/` altındadır).
//
//   cd app && flutter test tool/magaza_gorsel_test.dart --update-goldens
//
// Çıktı: app/tool/goldens/<urun>_<ekran>.png (1080x2340). `docs/devir/araclar/magaza_gorsel.py` bunları başlıklı
// mağaza görsellerine çevirir. Gerçek soru paketi ve gerçek ekranlar kullanılır; yalnız ilerleme verisi örnektir.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/anlatimlar.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/ekranlar/dersler.dart';
import 'package:mevo/ekranlar/istatistik.dart';
import 'package:mevo/ekranlar/konu.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/modeller.dart';

import '../test/sahte_ses.dart';
import '../test/yardimci.dart';

/// Flutter testleri yazıyı kutu olarak çizen "Ahem" yazı tipiyle çalışır; gerçek görünüm için uygulamaya gömülü Roboto yüklenir.
Future<void> yaziTipleriniYukle() async {
  final yukleyici = FontLoader('Roboto');
  for (final a in ['400', '500', '600', '700', '800']) {
    yukleyici.addFont(Future.value(ByteData.sublistView(File('assets/fonts/Roboto-$a.ttf').readAsBytesSync())));
  }
  await yukleyici.load();
  // Simgeler (Material Icons) Flutter SDK'nın önbelleğinden yüklenir; yoksa simgeler kutu çıkar.
  final sdk = Platform.environment['FLUTTER_ROOT'] ?? r'C:\Users\erene\dev\flutter';
  final simge = File('$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf');
  if (simge.existsSync()) {
    final s = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(simge.readAsBytesSync())));
    await s.load();
  }
}

Future<UygulamaDurumu> hazirDurum(Urun urun, {SahteSes? ses}) async {
  final bolum = urun == Urun.ymm ? 'YMM' : 'YET';
  final durum = durumOlustur(urun: urun, bolum: bolum, ses: ses);
  final sorular = durum.banka.bolumSorulari(bolum);
  for (var i = 0; i < 96; i++) {
    final s = sorular[(i * 7) % sorular.length];
    await durum.ilerleme.cevapla(s, i % 4 == 0 ? (s.dogru == 'A' ? 'B' : 'A') : s.dogru, gunlugeSay: i < 14);
  }
  await durum.abonelik.satinAl(durum.abonelik.paketler.first); // tam erişim: kilit simgesi görüntüde olmasın
  // Birkaç anlatım okunmuş, biri yarıda: "kaldığın yerden devam et" ve okundu işaretleri görünsün.
  final anlatimlar = tumAnlatimlar(durum);
  for (final e in anlatimlar.take(3)) {
    await durum.ilerleme.okunduIsaretle(e.anlatim.anahtar);
  }
  if (anlatimlar.length > 3) await durum.ilerleme.sonAnlatimKaydet(anlatimlar[3].anlatim.anahtar);
  return durum;
}

/// Cihaz sınıfları: telefon 1080×2340, 7" tablet 1200×1920, 10" tablet 1600×2560 (dikey, piksel).
const cihazlar = {
  'tel': (Size(1080, 2340), 3.0),
  'tab7': (Size(1200, 1920), 2.0),
  'tab10': (Size(1600, 2560), 2.0),
};

Future<void> cek(
  WidgetTester tester,
  Urun urun,
  String ad,
  Widget Function(UygulamaDurumu) ekran, {
  String cihaz = 'tel',
  SahteSes? ses,
  Future<void> Function(UygulamaDurumu)? once,
}) async {
  final (boyut, oran) = cihazlar[cihaz]!;
  tester.view.physicalSize = boyut;
  tester.view.devicePixelRatio = oran;
  addTearDown(tester.view.reset);
  final durum = await hazirDurum(urun, ses: ses);
  if (once != null) await once(durum);
  await tester.pumpWidget(
    Kapsam(
      durum: durum,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: tema(Brightness.light, urun.anaRenk),
        locale: const Locale('tr'),
        home: RepaintBoundary(key: const ValueKey('cekim'), child: ekran(durum)),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await expectLater(find.byKey(const ValueKey('cekim')), matchesGoldenFile('goldens/${urun.kod}_${cihaz == 'tel' ? '' : '${cihaz}_'}$ad.png'));
}

void main() {
  setUpAll(yaziTipleriniYukle);
  for (final urun in Urun.values) {
    final ders = urun == Urun.ymm ? 'IFM' : 'FIN';
    final konu = urun == Urun.ymm ? 'KCV' : 'ALC';
    for (final cihaz in cihazlar.keys) {
      final on = '${urun.kod} $cihaz';
      testWidgets('$on bugun', (t) => cek(t, urun, 'bugun', (_) => const BugunEkrani(), cihaz: cihaz));
      testWidgets('$on dersler', (t) => cek(t, urun, 'dersler', (_) => const DerslerEkrani(), cihaz: cihaz));
      testWidgets('$on istatistik', (t) => cek(t, urun, 'istatistik', (_) => const IstatistikEkrani(), cihaz: cihaz));
      testWidgets(
        '$on ders detay',
        (t) => cek(t, urun, 'ders', (d) => DersDetay(ders: d.banka.dersler[ders]!), cihaz: cihaz),
      );
      testWidgets(
        '$on soru',
        (t) => cek(
          t,
          urun,
          'soru',
          (d) => CalismaEkrani(
            baslik: 'Hızlı çalışma',
            sorular: d.banka.dersSorulari(d.bolum, ders, konu: konu).take(5).toList(),
          ),
          cihaz: cihaz,
        ),
      );
      testWidgets('$on anlatimlar', (t) => cek(t, urun, 'anlatimlar', (_) => const AnlatimlarEkrani(), cihaz: cihaz));
      testWidgets('$on anlatim', (t) {
        // Sesli dinleme açık: alttaki oynatıcı çubuğu görüntüde görünsün.
        final ses = SahteSes();
        KonuAnlatimi sec(UygulamaDurumu d) => d.banka.anlatimlar.values.firstWhere((a) => a.ders == ders);
        return cek(
          t,
          urun,
          'anlatim',
          (d) => AnlatimEkrani(ders: d.banka.dersler[ders]!, anlatim: sec(d)),
          cihaz: cihaz,
          ses: ses,
          once: (d) => ses.oku(
            'Bu konuda neler öğreneceksin.\n${sec(d).baslik} konusunun temel kavramları ve sınavda sık sorulan noktalar.',
            kaynak: 'anlatim/${sec(d).anahtar}',
          ),
        );
      });
    }
  }
}
