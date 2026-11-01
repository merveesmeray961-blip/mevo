import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/anlatimlar.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/ekranlar/konu.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';

import 'sahte_ses.dart';
import 'yardimci.dart';

void main() {
  void telefon(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  for (final urun in Urun.values) {
    final bolum = urun == Urun.ymm ? 'YMM' : 'YET';
    testWidgets('${urun.kod}: ana ekrandan tek dokunuşla konu anlatımı açılır', (tester) async {
      telefon(tester);
      final durum = durumOlustur(bolum: bolum, urun: urun);
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: BugunEkrani())));
      await tester.pumpAndSettle();
      expect(find.text('Konu anlatımları'), findsOneWidget);
      final ilk = siradakiAnlatim(durum)!;
      // Kart, telefonda kaydırmadan görünür olmalı (ana ekrandan kolay erişim).
      final konum = tester.getRect(find.text('Konuyu aç'));
      expect(konum.bottom, lessThan(780 - 80), reason: 'kısayol ekranın altında kalmamalı');
      await tester.tap(find.text('Konuyu aç'));
      await tester.pumpAndSettle();
      expect(find.byType(AnlatimEkrani), findsOneWidget);
      expect(durum.ilerleme.sonAnlatim, ilk.anlatim.anahtar);
      await tester.pageBack();
      await tester.pumpAndSettle();
      // Açılıp okunmayan anlatım "kaldığın yer" olarak önerilir.
      expect(find.text('Okumaya devam et', skipOffstage: false), findsOneWidget);
    });

    testWidgets('${urun.kod}: tüm anlatımlar listelenir ve aranır', (tester) async {
      telefon(tester);
      final durum = durumOlustur(bolum: bolum, urun: urun);
      final hepsi = tumAnlatimlar(durum);
      expect(hepsi, isNotEmpty);
      expect(hepsi.length, lessThanOrEqualTo(durum.banka.anlatimlar.length));
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: AnlatimlarEkrani())));
      await tester.pumpAndSettle();
      expect(find.textContaining('${hepsi.length} konu'), findsOneWidget);
      final aranan = hepsi[1].ders.konular[hepsi[1].anlatim.konu]!;
      await tester.enterText(find.byType(TextField), aranan);
      await tester.pumpAndSettle();
      expect(find.text(aranan), findsWidgets);
    });
  }

  testWidgets('anlatım ekranında büyük "Sesli dinle" düğmesi okutur, oynatıcı çıkar, sonraki konu var', (tester) async {
    telefon(tester);
    final ses = SahteSes();
    final durum = durumOlustur(bolum: 'YET', ses: ses);
    final e = tumAnlatimlar(durum).first;
    await tester.pumpWidget(
      Kapsam(
        durum: durum,
        child: MaterialApp(home: AnlatimEkrani(ders: e.ders, anlatim: e.anlatim)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sesli dinle'));
    await tester.pumpAndSettle();
    expect(ses.okunan, hasLength(1));
    expect(ses.kaynak, 'anlatim/${e.anlatim.anahtar}');
    expect(find.byTooltip('Duraklat'), findsWidgets);
    await tester.tap(find.byTooltip('Duraklat').last);
    await tester.pumpAndSettle();
    expect(ses.duraklatildi, isTrue);
    // Aynı dersin sonraki anlatımı müfredat sırasıyla bulunur.
    final sonraki = sonrakiAnlatim(durum, e.ders, e.anlatim);
    if (sonraki != null) {
      final konular = e.ders.konular.keys.toList();
      expect(konular.indexOf(sonraki.anlatim.konu), greaterThan(konular.indexOf(e.anlatim.konu)));
    }
  });
}
