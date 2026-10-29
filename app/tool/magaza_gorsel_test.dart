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
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/ekranlar/dersler.dart';
import 'package:mevo/ekranlar/istatistik.dart';
import 'package:mevo/ekranlar/konu.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';

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

Future<UygulamaDurumu> hazirDurum(Urun urun) async {
  final bolum = urun == Urun.ymm ? 'YMM' : 'YET';
  final durum = durumOlustur(urun: urun, bolum: bolum);
  final sorular = durum.banka.bolumSorulari(bolum);
  for (var i = 0; i < 96; i++) {
    final s = sorular[(i * 7) % sorular.length];
    await durum.ilerleme.cevapla(s, i % 4 == 0 ? (s.dogru == 'A' ? 'B' : 'A') : s.dogru, gunlugeSay: i < 14);
  }
  await durum.abonelik.satinAl(durum.abonelik.paketler.first); // tam erişim: kilit simgesi görüntüde olmasın
  return durum;
}

Future<void> cek(WidgetTester tester, Urun urun, String ad, Widget Function(UygulamaDurumu) ekran) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final durum = await hazirDurum(urun);
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
  await expectLater(find.byKey(const ValueKey('cekim')), matchesGoldenFile('goldens/${urun.kod}_$ad.png'));
}

void main() {
  setUpAll(yaziTipleriniYukle);
  for (final urun in Urun.values) {
    final ders = urun == Urun.ymm ? 'IFM' : 'FIN';
    final konu = urun == Urun.ymm ? 'KCV' : 'ALC';
    testWidgets('${urun.kod} bugun', (t) => cek(t, urun, 'bugun', (_) => const BugunEkrani()));
    testWidgets('${urun.kod} dersler', (t) => cek(t, urun, 'dersler', (_) => const DerslerEkrani()));
    testWidgets('${urun.kod} istatistik', (t) => cek(t, urun, 'istatistik', (_) => const IstatistikEkrani()));
    testWidgets(
      '${urun.kod} ders detay',
      (t) => cek(t, urun, 'ders', (d) => DersDetay(ders: d.banka.dersler[ders]!)),
    );
    testWidgets(
      '${urun.kod} soru',
      (t) => cek(
        t,
        urun,
        'soru',
        (d) => CalismaEkrani(
          baslik: 'Hızlı çalışma',
          sorular: d.banka.dersSorulari(d.bolum, ders, konu: konu).take(5).toList(),
        ),
      ),
    );
    testWidgets(
      '${urun.kod} anlatim',
      (t) => cek(
        t,
        urun,
        'anlatim',
        (d) => AnlatimEkrani(ders: d.banka.dersler[ders]!, anlatim: d.banka.anlatimlar.values.firstWhere((a) => a.ders == ders)),
      ),
    );
  }
}
