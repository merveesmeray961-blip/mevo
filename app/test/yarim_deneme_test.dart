import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/deneme.dart';
import 'package:mevo/ekranlar/deneme_listesi.dart';
import 'package:mevo/mantik/deneme.dart';
import 'package:mevo/mantik/klasik.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';

import 'yardimci.dart';

Future<void> _ac(WidgetTester tester, Widget ekran, UygulamaDurumu durum) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(Kapsam(durum: durum, child: MaterialApp(home: ekran)));
  await tester.pump();
}

void main() {
  test('yarım deneme kaydı gidip gelince aynı kalır', () {
    final banka = gercekBanka();
    final plan = denemePlanla(banka, DenemeTuru.yetDers, ders: 'FIN');
    final y = YarimDeneme(
      plan: plan,
      cevaplar: {plan.sorular.first.id: 'A'},
      isaretli: {plan.sorular.last.id},
      gecenSn: 600,
      sira: 3,
      kayit: DateTime(2026, 11, 11, 15),
    );
    final geri = YarimDeneme.fromJson(banka, y.toJson())!;
    expect(geri.plan.sorular.map((s) => s.id), plan.sorular.map((s) => s.id));
    expect(geri.cevaplar, y.cevaplar);
    expect(geri.isaretli, y.isaretli);
    expect(geri.kalanSn, plan.sureSn - 600);
    expect(geri.sira, 3);
    // Bankadan kalkmış soru varsa kayıt geçersiz sayılır (çökme yerine null).
    final bozuk = y.toJson()..['sorular'] = ['YOK-0001'];
    expect(YarimDeneme.fromJson(banka, bozuk), isNull);
  });

  testWidgets('denemede cevap verilince yarım kayıt yazılır, listede devam kartı çıkar', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    final plan = denemePlanla(durum.banka, DenemeTuru.yetDers, ders: 'FIN');
    await _ac(tester, DenemeEkrani(plan: plan), durum);
    await tester.tap(find.textContaining(plan.sorular.first.secenekler['A']!).first);
    await tester.pump();
    final kayit = YarimDeneme.fromJson(durum.banka, durum.ilerleme.yarimDeneme);
    expect(kayit, isNotNull);
    expect(kayit!.cevaplar[plan.sorular.first.id], 'A');

    await _ac(tester, const DenemeListesi(), durum);
    expect(find.text('Yarım kalan deneme'), findsOneWidget);
    expect(find.text('1/${plan.sorular.length} cevaplandı · kalan süre ${sureYaz(kayit.kalanSn)}'), findsOneWidget);
  });

  test('yarım klasik deneme yazılan cevaplarla geri kurulur; çoktan seçmeli kayıtla karışmaz', () {
    final banka = gercekBanka(Urun.ymm);
    final plan = klasikDenemePlanla(banka, banka.bolumDersleri('YMM').first.kod);
    final y = YarimKlasik(plan: plan, cevaplar: {plan.sorular.first.id: 'Alacak devir hızı 6'}, gecenSn: 300, sira: 1);
    final j = y.toJson();
    final geri = YarimKlasik.fromJson(banka, j)!;
    expect(geri.cevaplar[plan.sorular.first.id], 'Alacak devir hızı 6');
    expect(geri.plan.sorular.map((k) => k.id), plan.sorular.map((k) => k.id));
    expect(geri.kalanSn, plan.sureSn - 300);
    expect(YarimDeneme.fromJson(banka, j), isNull);
  });
}
