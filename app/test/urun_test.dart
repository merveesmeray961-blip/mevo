import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/ayarlar_ekrani.dart';
import 'package:mevo/ekranlar/yasal.dart';
import 'package:mevo/main.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/paket.dart';

import 'yardimci.dart';

void main() {
  group('Ürün (SMMM / YMM)', () {
    test('bayrak değerinden ürün bulunur; bilinmeyen ya da boş bayrak SMMM sayılır', () {
      expect(Urun.bayraktan('ymm'), Urun.ymm);
      expect(Urun.bayraktan('smmm'), Urun.smmm);
      expect(Urun.bayraktan(null), Urun.smmm);
      expect(Urun.bayraktan('baska'), Urun.smmm);
    });

    test('SMMM iki bölümlü, YMM tek bölümlüdür; bölüm kümeleri kesişmez', () {
      expect(Urun.smmm.bolumler, ['SGS', 'YET']);
      expect(Urun.ymm.bolumler, ['YMM']);
      expect(Urun.smmm.bolumSecimiVar, isTrue);
      expect(Urun.ymm.bolumSecimiVar, isFalse);
      expect(Urun.smmm.bolumler.toSet().intersection(Urun.ymm.bolumler.toSet()), isEmpty);
    });

    test('iki uygulamanın paketi, adı ve rengi farklıdır', () {
      expect(Urun.smmm.paketYolu, isNot(Urun.ymm.paketYolu));
      expect(Urun.smmm.ad, 'Mizan SMMM');
      expect(Urun.ymm.ad, 'Tasdik YMM');
      expect(Urun.smmm.anaRenk, isNot(Urun.ymm.anaRenk));
    });

    test('her ürünün paketi gömülüdür ve açılır; pakette kendi kodu yazar', () {
      for (final u in Urun.values) {
        final dosya = File(u.paketYolu);
        expect(dosya.existsSync(), isTrue, reason: u.paketYolu);
        final j = jsonDecode(paketCoz(dosya.readAsBytesSync())) as Map<String, dynamic>;
        expect(j['urun'], u.kod, reason: u.paketYolu);
      }
    });

    test('SMMM paketinde YMM içeriği, YMM paketinde SMMM içeriği yoktur', () {
      final smmm = gercekBanka(Urun.smmm);
      final ymm = gercekBanka(Urun.ymm);
      expect(smmm.formatlar.keys.toSet(), {'SGS', 'YET'});
      expect(smmm.klasikler, isEmpty);
      expect(smmm.sorular.any((s) => s.bolumde('YMM')), isFalse);
      expect(ymm.formatlar.keys.toSet(), {'YMM'});
      expect(ymm.klasikler, isNotEmpty);
      expect(ymm.sorular.every((s) => s.bolumde('YMM') && !s.bolumde('YET') && !s.bolumde('SGS')), isTrue);
      expect(ymm.dersler.keys.toSet().intersection(smmm.dersler.keys.toSet()), isEmpty);
    });

    test('YMM paketinin 10 dersi de bölüm derslerinde görünür', () {
      final ymm = gercekBanka(Urun.ymm);
      expect(ymm.bolumDersleri('YMM'), hasLength(10));
    });

    test('bölüm: YMM uygulamasında seçim gerekmez; SMMM\'de geçersiz kayıt yeniden sorulur', () {
      expect(durumOlustur(urun: Urun.ymm).bolumSecildi, isTrue);
      expect(durumOlustur(urun: Urun.ymm).bolum, 'YMM');
      // Eski sürümden kalan, bu uygulamaya ait olmayan değer kullanılmaz.
      expect(durumOlustur(urun: Urun.ymm, bolum: 'YET').bolum, 'YMM');
      expect(durumOlustur().bolumSecildi, isFalse);
      expect(durumOlustur(bolum: 'SGS').bolumSecildi, isTrue);
      expect(durumOlustur(bolum: 'SGS').bolum, 'SGS');
      expect(durumOlustur(bolum: 'YMM').bolumSecildi, isFalse, reason: 'YMM değeri SMMM uygulamasına ait değil');
    });

    test('yasal metinlerde sınav adı ürüne göre değişir ve yanlış sınav adı geçmez', () {
      String kosullar(Urun u) => yasalMetinler(u).singleWhere((m) => m.baslik == 'Kullanım koşulları').metin;
      expect(kosullar(Urun.smmm), contains('SMMM sınavlarına'));
      expect(kosullar(Urun.smmm), isNot(contains('YMM')));
      expect(kosullar(Urun.ymm), contains('YMM sınavına'));
      expect(kosullar(Urun.ymm), isNot(contains('SMMM')));
      for (final u in Urun.values) {
        expect(yasalMetinler(u).map((m) => m.baslik), containsAll(['KVKK aydınlatma metni', 'Gizlilik politikası']));
      }
    });
  });

  group('Ürün ekranları', () {
    testWidgets('YMM uygulaması ilk açılışta bölüm sormadan ana sayfayı açar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(urun: Urun.ymm);
      await tester.pumpWidget(MevoUygulamasi(durum: durum));
      await tester.pumpAndSettle();
      expect(find.text('Hoş geldin'), findsNothing);
      expect(find.text('Yeminli Mali Müşavirlik Sınavı'), findsWidgets);
      expect(find.text('Dersler'), findsWidgets);
    });

    testWidgets('SMMM uygulaması ilk açılışta bölüm seçtirir ve yalnız SMMM bölümlerini sunar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur();
      await tester.pumpWidget(MevoUygulamasi(durum: durum));
      await tester.pumpAndSettle();
      expect(find.text('Hoş geldin'), findsOneWidget);
      expect(find.textContaining('SMMM sınavına'), findsOneWidget);
      expect(find.text('Yeminli Mali Müşavirlik'), findsNothing);
    });

    testWidgets('YMM ayarlarında sınav satırı bilgi amaçlıdır (tıklanınca seçim ekranı açılmaz)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final durum = durumOlustur(urun: Urun.ymm);
      await tester.pumpWidget(Kapsam(durum: durum, child: const MaterialApp(home: AyarlarEkrani())));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hazırlandığım sınav'));
      await tester.pumpAndSettle();
      expect(find.text('Sınavını seç'), findsNothing);
    });

    testWidgets('uygulama başlığı ürüne göre değişir', (tester) async {
      for (final u in Urun.values) {
        final durum = durumOlustur(urun: u);
        await tester.pumpWidget(MevoUygulamasi(durum: durum));
        await tester.pump();
        expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).title, u.ad);
      }
    });
  });
}
