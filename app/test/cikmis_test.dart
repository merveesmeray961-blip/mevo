import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/cikmis.dart';

import 'yardimci.dart';

void main() {
  final oturumlar = cikmisCoz(File(cikmisPaketYolu).readAsBytesSync());

  test('çıkmış paketi açılır; her sorunun resmî cevabı şıklar arasında', () {
    expect(oturumlar.length, greaterThan(30));
    final sorular = [for (final o in oturumlar) ...o.sorular];
    expect(sorular.length, greaterThan(3000));
    expect({for (final s in sorular) s.id}.length, sorular.length, reason: 'kimlikler tekil');
    for (final s in sorular) {
      expect(s.secenekler.containsKey(s.dogru), isTrue, reason: s.id);
      expect(s.kok.trim(), isNotEmpty, reason: s.id);
      // 2015 PDF'lerindeki bozuk harfler düzeltilmiş olmalı.
      expect(s.kok.contains(RegExp('[ĢġĠ]')), isFalse, reason: s.id);
    }
    expect({for (final o in oturumlar) o.sinav}, containsAll(['SGS', 'Yeterlilik']));
  });

  testWidgets('çıkmış sorular ücretsiz: günlük hak düşmez, ilerlemeye yazılmaz', (tester) async {
    final durum = durumOlustur(bolum: 'SGS');
    final sorular = oturumlar.first.sorular.take(2).toList();
    final once = durum.ilerleme.bugunCozulen;
    await tester.pumpWidget(
      Kapsam(
        durum: durum,
        child: MaterialApp(home: CalismaEkrani(baslik: 'Çıkmış', sorular: sorular, ucretsiz: true)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Hata bildir'), findsNothing);
    final yanlis = sorular.first.secenekler.keys.firstWhere((h) => h != sorular.first.dogru);
    await tester.tap(find.text(sorular.first.secenekler[yanlis]!).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Resmî cevap anahtarına göre'), findsWidgets);
    expect(durum.ilerleme.bugunCozulen, once);
    expect(durum.ilerleme.durum(sorular.first.id), isNull);
  });

  for (final urun in Urun.values) {
    testWidgets('${urun.kod}: ana ekranda çıkmış sorular kartı ${urun == Urun.smmm ? 'var' : 'yok'}', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(bolum: urun == Urun.ymm ? 'YMM' : 'YET', urun: urun);
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: BugunEkrani())));
      await tester.pumpAndSettle();
      expect(find.text('Çıkmış sorular', skipOffstage: false), urun == Urun.smmm ? findsOneWidget : findsNothing);
    });
  }
}
