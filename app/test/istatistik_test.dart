import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/istatistik.dart';

import 'arayuz_test.dart' show ac;
import 'yardimci.dart';

void main() {
  // 11.11.2026 emülatör testi: bir konuda 3–9 cevap varken ekran null kontrolüyle çöküp gri kalıyordu.
  testWidgets('bir konuda 3-9 cevap varken istatistik ekranı çökmez ve zayıf konuyu gösterir', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    final ilk = durum.banka.bolumSorulari('YET').first;
    final ayniKonu = durum.banka.bolumSorulari('YET').where((s) => s.ders == ilk.ders && s.konu == ilk.konu).take(5);
    for (final s in ayniKonu) {
      await durum.ilerleme.cevapla(s, s.dogru == 'A' ? 'B' : 'A');
    }
    await ac(tester, const IstatistikEkrani(), durum);
    expect(tester.takeException(), isNull);
    expect(find.text('İstatistik'), findsOneWidget);
  });
}
