import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/bilesenler/duzen.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/dersler.dart';
import 'package:mevo/uygulama.dart';

import 'yardimci.dart';

/// Cihaz sınıfları (dp): 7" dikey 600, 10" dikey 800, 10" yatay 1280.
const _cihazlar = {'7 in dikey': Size(600, 960), '10 in dikey': Size(800, 1280), '10 in yatay': Size(1280, 800)};

Future<void> _ac(WidgetTester tester, Widget ekran, Size boyut, {double yazi = 1, bool koyu = false}) async {
  tester.view.physicalSize = boyut;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final durum = durumOlustur(bolum: 'YET');
  await tester.pumpWidget(
    Kapsam(
      durum: durum,
      child: MaterialApp(
        theme: tema(Brightness.light),
        darkTheme: tema(Brightness.dark),
        themeMode: koyu ? ThemeMode.dark : ThemeMode.light,
        builder: (c, w) => MediaQuery(data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(yazi)), child: w!),
        home: ekran,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('eşik değerleri tutarlı', () {
    expect(ikiSutunEsigi, greaterThan(genisEkranEsigi));
    expect(tabletGenisligi, greaterThan(ikiSutunEsigi));
  });

  for (final MapEntry(key: ad, value: boyut) in _cihazlar.entries) {
    for (final yazi in [1.0, 2.0]) {
      testWidgets('Dersler ve Bugün taşmadan açılır · $ad · yazı ×$yazi', (tester) async {
        await _ac(tester, const DerslerEkrani(), boyut, yazi: yazi, koyu: yazi > 1);
        expect(tester.takeException(), isNull);
        await _ac(tester, const BugunEkrani(), boyut, yazi: yazi, koyu: yazi > 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Dersler: dikey tabletlerde tek, yatay tablette iki sütun', (tester) async {
    Future<(Offset, Offset)> kartlar(Size b) async {
      await _ac(tester, const DerslerEkrani(), b);
      final k = find.byType(Card);
      return (tester.getTopLeft(k.at(0)), tester.getTopLeft(k.at(1)));
    }

    final dikey = await kartlar(const Size(800, 1280));
    expect(dikey.$1.dx, dikey.$2.dx, reason: 'dikey tablette kartlar alt alta');
    expect(dikey.$2.dy, greaterThan(dikey.$1.dy));
    final yatay = await kartlar(const Size(1280, 800));
    expect(yatay.$1.dy, yatay.$2.dy, reason: 'yatay tablette iki kart yan yana');
    expect(yatay.$2.dx, greaterThan(yatay.$1.dx));
  });

  testWidgets('Dersler: dikey tablette içerik okuma genişliğiyle sınırlı ve ortalı', (tester) async {
    await _ac(tester, const DerslerEkrani(), const Size(800, 1280));
    final kart = tester.getRect(find.byType(Card).first);
    expect(kart.width, lessThanOrEqualTo(okumaGenisligi));
    expect((kart.left - (800 - kart.right)).abs(), lessThan(2), reason: 'sol ve sağ boşluk eşit (ortalı)');
  });

  testWidgets('Bugün: yatay tablette iki sütun, önemli kartlar görünür kalır', (tester) async {
    // Yanlış defteri kartı yalnız yanlış cevap varsa çıkar; önce bir yanlış cevap verilir.
    final durum = durumOlustur(bolum: 'YET');
    final soru = durum.banka.bolumSorulari('YET').first;
    await durum.ilerleme.cevapla(soru, soru.dogru == 'A' ? 'B' : 'A');
    Future<void> ac(Size b) async {
      tester.view.physicalSize = b;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: BugunEkrani())));
      await tester.pumpAndSettle();
    }

    await ac(const Size(1280, 800));
    expect(find.byType(ListView), findsNWidgets(2));
    expect(find.textContaining('Hızlı çalış'), findsOneWidget);
    expect(find.text('Yanlış defterim'), findsOneWidget);
    await ac(const Size(800, 1280));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Yanlış defterim'), findsOneWidget);
  });
}
