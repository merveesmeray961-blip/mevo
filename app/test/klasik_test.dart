import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/bolum_secimi.dart';
import 'package:mevo/ekranlar/klasik.dart';
import 'package:mevo/mantik/klasik.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/modeller.dart';

import 'yardimci.dart';

Map<String, dynamic> _klasik(String id, String konu, int puan, {int zorluk = 2}) => {
  'id': id,
  'ders': 'IFM',
  'konu': konu,
  'kazanimlar': ['kazanım'],
  'zorluk': zorluk,
  'puan': puan,
  'sure_dk': 30,
  'soru': 'A AŞ verileri aşağıdadır.\n\n(a) Kaydı yapınız (10 puan)',
  'cozum': '**(a)** 100 Kasa / 600 Satışlar',
  'puanlama': [
    {'olcut': 'Kayıt doğru', 'puan': puan - 5},
    {'olcut': 'Açıklama', 'puan': 5},
  ],
  'kaynaklar': [
    {'mevzuat': 'TFRS 3', 'madde': 'par. 32'},
  ],
};

/// Gerçek SMMM paketine YMM bölümü, bir YMM dersi ve klasik sorular eklenmiş banka.
SoruBankasi ymmBanka() {
  final j = gercekBankaJson();
  (j['formatlar'] as Map)['YMM'] = {
    'kod': 'YMM',
    'ad': 'Yeminli Mali Müşavirlik Sınavı',
    'yanlis_cezasi': 0,
    'gecme': {'ders_min': 50, 'ortalama_min': 65},
  };
  (j['dersler'] as Map)['IFM'] = {
    'ad': 'İleri Düzeyde Finansal Muhasebe',
    'sgs_ad': 'İleri Düzeyde Finansal Muhasebe',
    'soru': {'YMM': 1},
    'konular': {'KON': 'Konsolidasyon', 'ENF': 'Enflasyon düzeltmesi', 'FAR': 'Finansal araçlar'},
  };
  j['klasik'] = [
    _klasik('YMM-IFM-KON-K001', 'KON', 25, zorluk: 3),
    _klasik('YMM-IFM-KON-K002', 'KON', 25),
    _klasik('YMM-IFM-ENF-K001', 'ENF', 25, zorluk: 1),
    _klasik('YMM-IFM-FAR-K001', 'FAR', 30),
    _klasik('YMM-IFM-FAR-K002', 'FAR', 20),
  ];
  return SoruBankasi.fromJson(j);
}

void main() {
  group('Klasik deneme', () {
    final banka = ymmBanka();

    test('YMM dersi yalnız klasik sorusu olsa da bölüm derslerinde görünür', () {
      expect(banka.bolumDersleri('YMM').map((d) => d.kod), ['IFM']);
      expect(banka.dersler['IFM']!.sinavdakiSoru('YMM'), 1);
      expect(banka.bolumDersleri('YET').map((d) => d.kod), isNot(contains('IFM')));
    });

    test('plan her konudan soru alır ve 100 puanı aşmaz', () {
      for (var tohum = 0; tohum < 20; tohum++) {
        final plan = klasikDenemePlanla(banka, 'IFM', rastgele: Random(tohum));
        expect(plan.hamPuan, lessThanOrEqualTo(klasikHedefPuan));
        expect(plan.hamPuan, greaterThanOrEqualTo(75));
        expect(plan.sorular.map((k) => k.konu).toSet(), {'KON', 'ENF', 'FAR'});
        expect(plan.sureSn, plan.sorular.length * 30 * 60);
        final zorluklar = plan.sorular.map((k) => k.zorluk).toList();
        expect(zorluklar, [...zorluklar]..sort());
      }
    });

    test('puan 100 üzerinden orantılanır, kayıt geri kurulur', () {
      final plan = KlasikDenemePlani(
        ders: 'IFM',
        baslik: 'x',
        sorular: [banka.klasik('YMM-IFM-KON-K001')!, banka.klasik('YMM-IFM-ENF-K001')!],
      );
      final verilen = {'YMM-IFM-KON-K001': 20.0, 'YMM-IFM-ENF-K001': 99.0};
      // 20 + 25 (üst sınır) = 45 / 50 ham puan → 90
      expect(klasikDersPuani(plan, verilen), 90);
      final kayit = klasikKayit(plan, verilen, 600, DateTime(2026, 10, 11), dersMin: 50);
      expect(kayit.gecti, isTrue);
      expect(kayit.bolum, 'YMM');
      final geri = klasikKayittan(banka, kayit)!;
      expect(geri.$1.sorular.map((k) => k.id), plan.sorular.map((k) => k.id));
      expect(geri.$2['YMM-IFM-KON-K001'], 20);
    });
  });

  group('YMM ekranları', () {
    testWidgets('bölüm seçiminde YMM kartı çıkar', (tester) async {
      final durum = durumOlustur(banka: ymmBanka());
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: const MaterialApp(home: BolumSecimi(ilkAcilis: true)),
        ),
      );
      expect(find.text('Yeminli Mali Müşavirlik'), findsOneWidget);
    });

    testWidgets('öz puanlama ölçüt işaretleyince puanı günceller ve kaydeder', (tester) async {
      final banka = ymmBanka();
      final durum = durumOlustur(banka: banka, bolum: 'YMM');
      final plan = KlasikDenemePlani(ders: 'IFM', baslik: 'IFM denemesi', sorular: [banka.klasik('YMM-IFM-ENF-K001')!]);
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: MaterialApp(home: KlasikPuanlamaEkrani(plan: plan)),
        ),
      );
      expect(find.text('0'), findsWidgets);
      await tester.tap(find.text('Kayıt doğru'));
      await tester.pumpAndSettle();
      expect(find.text('80'), findsOneWidget); // 20 / 25 puan
      await tester.scrollUntilVisible(find.text('Puanı kaydet'), 200);
      await tester.tap(find.text('Puanı kaydet'));
      await tester.pumpAndSettle();
      expect(durum.ilerleme.denemeler.single.bolum, 'YMM');
      expect(durum.ilerleme.denemeler.single.puan, 80);
    });
  });
}
