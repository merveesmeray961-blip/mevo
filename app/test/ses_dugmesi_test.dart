import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/bilesenler/sesli_okuma.dart';
import 'package:mevo/ekranlar/konu.dart';
import 'package:mevo/uygulama.dart';

import 'sahte_ses.dart';
import 'yardimci.dart';

Future<void> kur(WidgetTester tester, SesMotoru motor, String Function() metin) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: SesDugmesi(motor: motor, metin: metin)),
  ),
);

void main() {
  group('Ses düğmesi', () {
    testWidgets('dokununca metni okutur, tekrar dokununca durdurur', (tester) async {
      final motor = SahteSes();
      await kur(tester, motor, () => 'Merhaba');
      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pump();
      expect(motor.okunan, ['Merhaba']);
      expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.stop_circle_outlined));
      await tester.pump();
      expect(motor.durdurma, 1);
      expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
    });

    testWidgets('Türkçe ses yoksa okumaz, kullanıcıya nedenini söyler', (tester) async {
      final motor = SahteSes(turkce: false);
      await kur(tester, motor, () => 'Merhaba');
      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pump();
      expect(motor.okunan, isEmpty);
      expect(find.textContaining('Türkçe ses bulunamadı'), findsOneWidget);
    });

    testWidgets('ekran kapanınca okuma durur', (tester) async {
      final motor = SahteSes();
      await kur(tester, motor, () => 'Merhaba');
      await tester.tap(find.byIcon(Icons.volume_up_outlined));
      await tester.pump();
      expect(motor.okuyor, isTrue);
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
      await tester.pump();
      expect(motor.okuyor, isFalse);
    });
  });

  group('Ekranlar', () {
    testWidgets('konu anlatımı ekranında sesli dinle düğmesi anlatımı okutur', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final motor = SahteSes();
      final durum = durumOlustur(bolum: 'YET', ses: motor);
      final ders = durum.banka.dersler['FIN']!;
      final anlatim = durum.banka.anlatim('FIN', 'ALC')!;
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: MaterialApp(home: AnlatimEkrani(ders: ders, anlatim: anlatim)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Konuyu sesli dinle'));
      await tester.pump();
      expect(motor.okunan.single, startsWith(anlatim.baslik));
      expect(motor.okunan.single, isNot(contains('**')));
    });
  });
}
