import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/ana_kabuk.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/ekranlar/mevzuat.dart';
import 'package:mevo/mantik/mevzuat.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/modeller.dart';

import 'yardimci.dart';

Future<void> ac(WidgetTester tester, Widget ekran, UygulamaDurumu durum) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    Kapsam(
      durum: durum,
      child: MaterialApp(theme: tema(Brightness.light), home: ekran),
    ),
  );
  await tester.pumpAndSettle();
}

MevzuatMaddesi bul(UygulamaDurumu d, String kaynakBasi, String madde) =>
    d.banka.mevzuat.firstWhere((m) => m.kaynak.startsWith(kaynakBasi) && m.madde == madde);

void main() {
  group('model', () {
    test('mevzuat anahtarı olmayan eski paket okunur', () {
      final j = jsonDecode(File('assets/sorular/smmm.json').readAsStringSync()) as Map<String, dynamic>
        ..remove('mevzuat')
        ..remove('mevzuat_tarihi');
      final banka = SoruBankasi.fromJson(j);
      expect(banka.mevzuat, isEmpty);
      expect(banka.mevzuatTarihi, isNull);
    });

    test('gerçek paket: kanunlarda tam metin, standartlarda yalnız alıntı', () {
      final banka = gercekBanka();
      expect(banka.mevzuatTarihi, '2026-10-04');
      expect(banka.mevzuat.length, greaterThan(100));
      final kanun = banka.mevzuat.firstWhere((m) => m.tur == 'kanun' && m.tamMetin != null);
      expect(kanun.kod, isNotNull);
      expect(kanun.mevzuatGovUrl, startsWith('https://www.mevzuat.gov.tr/'));
      for (final m in banka.mevzuat.where((m) => RegExp(r'^(TMS|TFRS|BDS|KYS)\s').hasMatch(m.kaynak))) {
        expect(m.tamMetin, isNull, reason: m.kaynak);
        expect(m.alintilar, isNotEmpty);
      }
      for (final m in banka.mevzuat) {
        for (final id in m.soruIdler) {
          expect(banka.soru(id), isNotNull, reason: '$id bankada yok');
        }
      }
    });

    test('madde alanları ayrıştırılır', () {
      final m = MevzuatMaddesi.fromJson({
        'kaynak': 'X Kanunu',
        'madde': 'md. 5',
        'alintilar': [
          {'atif': 'md. 5/1', 'metin': 'abc', 'soru_id': 'S1'},
        ],
        'soru_idler': ['S1'],
      });
      expect(m.tur, 'diger');
      expect(m.tamMetin, isNull);
      expect(m.alintilar.single.atif, 'md. 5/1');
    });
  });

  group('mantık', () {
    test('Türkçe harfe duyarlı arama', () {
      final banka = gercekBanka();
      expect(mevzuatAra(banka.mevzuat, 'VERGİ USUL').where((m) => m.kaynak.contains('Vergi Usul')), isNotEmpty);
      expect(mevzuatAra(banka.mevzuat, 'vergi usul kanunu zamanaşımı'), isNotEmpty);
      expect(mevzuatAra(banka.mevzuat, 'olmayan-bir-sözcük-xyz'), isEmpty);
      expect(mevzuatAra(banka.mevzuat, '  '), banka.mevzuat);
    });

    test('alıntı vurgusu boşluk ve üç nokta farkına dayanır', () {
      const metin = 'Madde 5 – Bir iki üç dört beş\naltı yedi sekiz dokuz on onbir. İkinci cümle burada biter.';
      final s = alintiAraliklari(metin, [
        'iki üç dört beş altı yedi sekiz',
        'Bir ... ikinci cümle burada biter',
        'hiç yok burada',
      ]);
      expect(s.bulunamayan, [2]);
      expect(s.araliklar, isNotEmpty);
      expect(metin.substring(s.araliklar.first.$1, s.araliklar.first.$2), startsWith('iki üç'));
    });

    test('tarih notu', () {
      expect(mevzuatTarihNotu('2026-10-04'), startsWith('Metin 4 Ekim 2026 itibarıyla alınmıştır.'));
      expect(mevzuatTarihNotu(null), contains('Güncel hâli için resmî kaynağa bakın.'));
    });
  });

  group('ekran', () {
    testWidgets('sekme açılır, arama listeyi süzer', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      await ac(tester, const AnaKabuk(), durum);
      await tester.tap(find.text('Mevzuat').last);
      await tester.pumpAndSettle();
      expect(find.text('Kanunlar'), findsOneWidget);
      expect(find.text('193 sayılı Gelir Vergisi Kanunu'), findsOneWidget);
      expect(find.textContaining('4 Ekim 2026'), findsWidgets);

      await tester.enterText(find.byType(TextField), '488 sayılı');
      await tester.pumpAndSettle();
      expect(find.text('488 sayılı Damga Vergisi Kanunu'), findsOneWidget);
      expect(find.text('193 sayılı Gelir Vergisi Kanunu'), findsNothing);
      expect(find.text('Standartlar (yalnızca alıntılar)'), findsNothing);

      await tester.enterText(find.byType(TextField), 'olmayan-bir-sözcük-xyz');
      await tester.pumpAndSettle();
      expect(find.text('Sonuç yok.'), findsOneWidget);
    });

    testWidgets('kanun maddesi tam metin, not ve bağlantı düğmesiyle açılır', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      final m = bul(durum, '213 sayılı', 'md. 114');
      await ac(tester, MevzuatMaddeEkrani(madde: m), durum);
      expect(find.byType(SelectableText), findsWidgets);
      expect(find.text("mevzuat.gov.tr'de aç"), findsOneWidget);
      final n = m.soruIdler.where((id) => durum.banka.soru(id)!.bolumde('YET')).length;
      expect(find.text('Bu maddeden $n soru çöz'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('Metin 4 Ekim 2026 itibarıyla alınmıştır'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
    });

    testWidgets('standart maddesinde tam metin yok, yalnız alıntı ve mevzuat.gov.tr düğmesi yok', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      await ac(tester, MevzuatMaddeEkrani(madde: bul(durum, 'TMS 2 ', 'par. 11')), durum);
      expect(find.textContaining('tam metni uygulamada yer almaz'), findsOneWidget);
      expect(find.text('Sorulardaki alıntılar'), findsOneWidget);
      expect(find.text("mevzuat.gov.tr'de aç"), findsNothing);
    });

    testWidgets('"soru çöz" çalışma oturumunu seçili bölümün sorularıyla başlatır', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      final m = bul(durum, '213 sayılı', 'md. 114');
      await ac(tester, MevzuatMaddeEkrani(madde: m), durum);
      await tester.tap(find.textContaining('Bu maddeden'));
      await tester.pumpAndSettle();
      final ekran = tester.widget<CalismaEkrani>(find.byType(CalismaEkrani));
      final beklenen = m.soruIdler.where((id) => durum.banka.soru(id)!.bolumde('YET')).toSet();
      expect(ekran.sorular, isNotEmpty);
      expect(ekran.sorular.map((s) => s.id).toSet().difference(beklenen), isEmpty);
    });

    testWidgets('seçili bölümde sorusu olmayan maddede "soru çöz" gizlenir', (tester) async {
      final durum = durumOlustur(bolum: 'SGS');
      final m = durum.banka.mevzuat.firstWhere((m) => m.soruIdler.every((id) => !durum.banka.soru(id)!.bolumde('SGS')));
      await ac(tester, MevzuatMaddeEkrani(madde: m), durum);
      expect(find.textContaining('soru çöz'), findsNothing);
    });
  });
}
