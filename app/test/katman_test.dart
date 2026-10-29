import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/bilesenler/duzen.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/dersler.dart';
import 'package:mevo/uygulama.dart';

import 'yardimci.dart';

void main() {
  group('Ücretsiz katman: konu anlatımı', () {
    test('ücretsiz kullanıcıya her dersin anlatımı olan yalnız ilk konusu açıktır', () {
      final durum = durumOlustur(bolum: 'YET');
      final fin = durum.banka.dersler['FIN']!;
      final anlatimli = [for (final k in fin.konular.keys) if (durum.banka.anlatim('FIN', k) != null) k];
      expect(anlatimli.length, greaterThan(1), reason: 'bu test birden çok anlatımlı konu ister');
      expect(durum.anlatimAcik(fin, anlatimli.first), isTrue);
      for (final k in anlatimli.skip(1)) {
        expect(durum.anlatimAcik(fin, k), isFalse, reason: k);
      }
    });

    test('tam erişimde bütün anlatımlar açıktır', () async {
      final durum = durumOlustur(bolum: 'YET');
      await durum.abonelik.satinAl(durum.abonelik.paketler.first);
      final fin = durum.banka.dersler['FIN']!;
      for (final k in fin.konular.keys) {
        expect(durum.anlatimAcik(fin, k), isTrue, reason: k);
      }
    });

    test('her derste en az bir anlatım ücretsiz görülebilir (kullanıcı kaliteyi tanır)', () {
      final durum = durumOlustur(bolum: 'YET');
      for (final ders in durum.banka.bolumDersleri('YET')) {
        final anlatimli = [for (final k in ders.konular.keys) if (durum.banka.anlatim(ders.kod, k) != null) k];
        if (anlatimli.isEmpty) continue;
        expect(anlatimli.where((k) => durum.anlatimAcik(ders, k)), hasLength(1), reason: ders.kod);
      }
    });
  });

  group('Ücretsiz katman: ekranlar', () {
    testWidgets('kilitli konu ders ekranında kilit simgesiyle ve "tam erişimde" notuyla görünür', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(bolum: 'YET');
      await tester.pumpWidget(Kapsam(durum: durum, child: MaterialApp(home: DersDetay(ders: durum.banka.dersler['FIN']!))));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.lock_outline_rounded), findsWidgets);
      expect(find.textContaining('tam erişimde'), findsWidgets);
    });

    testWidgets('hak boluyken Bugün ekranı satış çağrısı göstermez; azalınca gösterir', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(bolum: 'YET');
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: BugunEkrani())));
      await tester.pumpAndSettle();
      expect(find.textContaining('ücretsiz soru hakkın var'), findsOneWidget);
      expect(find.textContaining('Sınırsız çalış'), findsNothing);

      final sorular = durum.banka.bolumSorulari('YET');
      for (var i = 0; i < ucretsizGunlukSoru - 3; i++) {
        await durum.ilerleme.cevapla(sorular[i], sorular[i].dogru);
      }
      await tester.pumpAndSettle();
      expect(find.textContaining('3 ücretsiz soru hakkın kaldı'), findsOneWidget);
      expect(find.textContaining('Sınırsız çalış'), findsOneWidget);
    });

    testWidgets('günlük hedef halkası ücretsizde 20, tam erişimde 30 soruya göredir', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(bolum: 'YET');
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: BugunEkrani())));
      await tester.pumpAndSettle();
      expect(find.text('bugün · hedef $ucretsizGunlukSoru'), findsOneWidget);
      await durum.abonelik.satinAl(durum.abonelik.paketler.first);
      await tester.pumpAndSettle();
      expect(find.text('bugün · hedef 30'), findsOneWidget);
    });
  });

  group('Başa dön düğmesi', () {
    testWidgets('uzun listede aşağı inince belirir, basınca başa döner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YukariCikListe(children: [for (var i = 0; i < 80; i++) SizedBox(height: 60, child: Text('Satır $i'))]),
          ),
        ),
      );
      expect(find.byType(FloatingActionButton), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Satır 0'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('kısa listede düğme hiç çıkmaz', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: YukariCikListe(children: [Text('a'), Text('b')]))),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
