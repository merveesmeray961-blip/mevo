import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/bilesenler/zengin_metin.dart';
import 'package:mevo/uygulama.dart';

import 'yardimci.dart';

/// WCAG 2.1 kontrast oranı.
double kontrast(Color a, Color b) {
  double l(Color c) {
    double k(double v) => v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * k(c.r) + 0.7152 * k(c.g) + 0.0722 * k(c.b);
  }

  final x = l(a), y = l(b);
  return (max(x, y) + 0.05) / (min(x, y) + 0.05);
}

void main() {
  group('Renk kontrastı (WCAG AA: metin ≥ 4,5)', () {
    for (final parlaklik in Brightness.values) {
      testWidgets('$parlaklik', (tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(
          MaterialApp(
            theme: tema(parlaklik),
            home: Builder(
              builder: (c) {
                ctx = c;
                return const SizedBox();
              },
            ),
          ),
        );
        final r = Theme.of(ctx).colorScheme;
        final ciftler = {
          'metin / zemin': (r.onSurface, r.surface),
          'ikincil metin / zemin': (r.onSurfaceVariant, r.surface),
          'soluk bilgi metni / zemin': (r.onSurfaceVariant, r.surface),
          'ana renk metni / zemin': (r.primary, r.surface),
          'düğme yazısı / ana renk': (r.onPrimary, r.primary),
          'kart yazısı / ana kap': (r.onPrimaryContainer, r.primaryContainer),
          'üçüncül metin / zemin': (r.tertiary, r.surface),
          'doğru rengi / zemin': (dogruRenk(ctx), r.surface),
          'yanlış rengi / zemin': (yanlisRenk(ctx), r.surface),
        };
        for (final e in ciftler.entries) {
          expect(kontrast(e.value.$1, e.value.$2), greaterThanOrEqualTo(4.5), reason: '${e.key} ($parlaklik)');
        }
      });
    }
  });

  group('Tablolar ekrana sığar (yatay kaydırma yok)', () {
    final banka = gercekBanka();
    final tablolu = [
      for (final s in banka.sorular)
        if (s.kok.contains('\n|')) s,
    ];

    test('soru bankasında tablolu soru var', () => expect(tablolu, isNotEmpty));

    for (final (genislik, yazi) in [(320.0, 1.0), (360.0, 1.3), (390.0, 2.0)]) {
      testWidgets('genişlik $genislik, yazı ölçeği $yazi', (tester) async {
        tester.view.physicalSize = Size(genislik * 3, 2400);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        for (final s in tablolu) {
          await tester.pumpWidget(
            MaterialApp(
              theme: tema(Brightness.light),
              home: MediaQuery(
                data: MediaQueryData(size: Size(genislik, 800), textScaler: TextScaler.linear(yazi)),
                child: Scaffold(
                  body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: ZenginMetin(s.kok)),
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull, reason: s.id);
          final yatay = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.right);
          expect(yatay, findsNothing, reason: '${s.id}: tablo yatay kaydırma gerektirmemeli');
          for (final e in tester.renderObjectList<RenderBox>(find.byType(Table))) {
            final sag = e.localToGlobal(Offset(e.size.width, 0)).dx;
            expect(sag, lessThanOrEqualTo(genislik - 16 + 0.5), reason: '${s.id}: tablo sağ kenardan taşıyor');
          }
        }
      });
    }
  });
}
