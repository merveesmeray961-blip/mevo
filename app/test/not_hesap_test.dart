import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/ana_kabuk.dart';
import 'package:mevo/ekranlar/ayarlar_ekrani.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/ekranlar/deneme.dart';
import 'package:mevo/ekranlar/hesap_makinesi.dart';
import 'package:mevo/ekranlar/notlar.dart';
import 'package:mevo/main.dart';
import 'package:mevo/mantik/deneme.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/depo.dart';
import 'package:mevo/veri/notlar.dart';

import 'duzen_test.dart' show boyutlar, dolguluDurum, hazirla, pompala;
import 'yardimci.dart';

Future<void> ac(WidgetTester tester, UygulamaDurumu durum) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MevoUygulamasi(durum: durum));
  await tester.pumpAndSettle();
}

Future<void> tus(WidgetTester tester, String tuslar) async {
  for (final t in tuslar.split('')) {
    await tester.ensureVisible(find.byKey(Key('tus:$t')));
    await tester.tap(find.byKey(Key('tus:$t')));
    await tester.pump();
  }
}

String sonuc(WidgetTester tester) => tester.widget<Text>(find.byKey(const Key('hesap_sonuc'))).data!;

CalismaEkrani calisma(UygulamaDurumu d) =>
    CalismaEkrani(baslik: 'Deneme', sorular: d.banka.dersSorulari('YET', 'FIN').take(5).toList());

void main() {
  setUp(hesapGecmisiniTemizle);

  group('hesap makinesi', () {
    testWidgets('çalışma ekranından açılır; dokunuşlarla 1.250 × 12 % hesaplanır', (tester) async {
      String? panoya;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') panoya = (call.arguments as Map)['text'] as String;
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      final durum = durumOlustur(bolum: 'YET');
      await ac(tester, durum);
      await tester.tap(find.textContaining('Hızlı çalış'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Hesap makinesi'));
      await tester.pumpAndSettle();
      await tus(tester, '1250×12%');
      expect(find.text('1.250 × 12%'), findsOneWidget);
      expect(sonuc(tester), '150');
      await tus(tester, 'C');
      await tus(tester, '1250+12%');
      expect(sonuc(tester), '1.400');
      await tus(tester, '=');
      expect(find.byKey(const Key('hesap_gecmis_0')), findsOneWidget);
      expect(find.text('1.250 + 12% = 1.400'), findsOneWidget);
      await tus(tester, 'C');
      await tus(tester, '5÷0');
      expect(sonuc(tester), 'Tanımsız');
      await tester.tap(find.byKey(const Key('tus:C')));
      await tester.pump();
      await tus(tester, '2(3+4');
      expect(sonuc(tester), '14');
      await tester.ensureVisible(find.text('Kopyala'));
      await tester.tap(find.text('Kopyala'));
      await tester.pumpAndSettle();
      expect(find.text('Kopyalandı'), findsOneWidget);
      expect(panoya, '14');
      // Tuşlar en az 56 dp yüksekliğinde.
      expect(tester.getSize(find.byKey(const Key('tus:7'))).height, greaterThanOrEqualTo(56));
    });

    testWidgets('geçmiş en çok 5 sonuç tutar ve dokununca sonucu kullanır', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      await ac(tester, durum);
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: MaterialApp(
            home: Builder(
              builder: (c) => TextButton(onPressed: () => hesapMakinesiAc(c), child: const Text('aç')),
            ),
          ),
        ),
      );
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
      for (var i = 1; i <= 6; i++) {
        await tus(tester, 'C');
        await tus(tester, '$i+$i');
        await tus(tester, '=');
      }
      expect(find.byKey(const Key('hesap_gecmis_4')), findsOneWidget);
      expect(find.byKey(const Key('hesap_gecmis_5')), findsNothing);
      await tester.tap(find.byKey(const Key('hesap_gecmis_0')));
      await tester.pump();
      expect(sonuc(tester), '12');
    });

    testWidgets('deneme ekranında (sınav sürerken) hesap makinesi yok; deneme incelemesinde var', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      final plan = denemePlanla(durum.banka, DenemeTuru.yetDers, ders: 'FIN');
      await ac(tester, durum);
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: MaterialApp(home: DenemeEkrani(plan: plan)),
        ),
      );
      await tester.pump();
      expect(find.byTooltip('Hesap makinesi'), findsNothing);
      expect(find.byIcon(Icons.calculate_outlined), findsNothing);
      expect(find.byTooltip('Not al'), findsOneWidget);
      await tester.pumpWidget(
        Kapsam(
          durum: durum,
          child: MaterialApp(home: DenemeInceleme(sonuc: denemePuanla(durum.banka, plan, {}, 60), baslangic: 0)),
        ),
      );
      await tester.pump();
      expect(find.byTooltip('Hesap makinesi'), findsOneWidget);
      expect(find.byTooltip('Not al'), findsOneWidget);
    });
  });

  group('notlar', () {
    test('Notlar aynı Depo ile yeni örnekte okunur; boş metin siler; sıfırlama notlara dokunmaz', () async {
      final depo = BellekDepo();
      final durum = durumOlustur(depo: depo);
      final id = durum.banka.sorular.first.id;
      await durum.notlar.kaydet(id, '  Amortisman: normal / azalan  ');
      final yeni = Notlar(depo);
      expect(yeni.not(id)?.metin, 'Amortisman: normal / azalan');
      expect(yeni.sayi, 1);
      await durum.ilerleme.sifirla();
      expect(Notlar(depo).sayi, 1);
      await yeni.kaydet(id, '   ');
      expect(Notlar(depo).sayi, 0);
      await yeni.kaydet(id, 'x');
      await yeni.hepsiniSil();
      expect(Notlar(depo).sayi, 0);
    });

    testWidgets('çalışmada not eklenir, kapanınca kaydedilir, açıklamada ve Notlarım listesinde görünür', (
      tester,
    ) async {
      final depo = BellekDepo({
        'ayarlar.v1': jsonEncode({'bolum': 'YET'}),
      });
      final durum = durumOlustur(depo: depo);
      final soru = durum.banka.dersSorulari('YET', 'FIN').first;
      await ac(tester, durum);
      await tester.tap(find.textContaining('Hızlı çalış'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Not al'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Bunu tekrar et');
      // Düğmeye basmadan, sayfayı dışına dokunarak kapat: otomatik kaydedilmeli.
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(durum.notlar.sayi, 1);
      final id = durum.notlar.notluSorular(durum.banka.sorular).single.id;
      expect(Notlar(depo).not(id)?.metin, 'Bunu tekrar et');
      expect(soru.id, isNotEmpty);

      // Bugün ekranına dön: Notlarım kartı sayıyı gösterir ve listeyi açar.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Notlarım'), 200);
      await tester.tap(find.text('Notlarım'));
      await tester.pumpAndSettle();
      expect(find.text('Bunu tekrar et'), findsOneWidget);
      // Dokununca çalışma oturumu açılır; soru cevaplanınca "Notun" kartı görünür.
      await tester.tap(find.text('Bunu tekrar et'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 1'), findsOneWidget);
      expect(find.text('Notun'), findsNothing);
      await tester.ensureVisible(find.text('A').first);
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      expect(find.text('Notun'), findsOneWidget);
      expect(find.text('Bunu tekrar et'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      // Silme düğmesi.
      await tester.tap(find.byTooltip('Notu sil'));
      await tester.pumpAndSettle();
      expect(durum.notlar.sayi, 0);
      expect(find.textContaining('Henüz notun yok'), findsOneWidget);
    });

    testWidgets('kaydırarak silme ve ayarlardan "Notlarımı sil"', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      final sorular = durum.banka.bolumSorulari('YET').take(2).toList();
      await durum.notlar.kaydet(sorular[0].id, 'ilk not');
      await durum.notlar.kaydet(sorular[1].id, 'ikinci not');
      await ac(tester, durum);
      await tester.scrollUntilVisible(find.text('Notlarım'), 200);
      await tester.tap(find.text('Notlarım'));
      await tester.pumpAndSettle();
      await tester.drag(find.text('ilk not'), const Offset(-800, 0));
      await tester.pumpAndSettle();
      expect(durum.notlar.sayi, 1);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Ayarlar'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Notlarımı sil'), 200);
      await tester.tap(find.text('Notlarımı sil'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sil'));
      await tester.pumpAndSettle();
      expect(durum.notlar.sayi, 0);
    });
  });

  group('taşma yok: hesap makinesi, not sayfası ve Notlarım', () {
    for (final MapEntry(key: boyutAdi, value: boyut) in boyutlar.entries) {
      for (final olcek in [1.0, 2.0]) {
        final ad = '$boyutAdi · yazı ×$olcek';
        testWidgets('Hesap makinesi · $ad', (tester) async {
          final durum = dolguluDurum();
          await hazirla(durum);
          await pompala(tester, calisma(durum), durum, boyut, olcek, olcek > 1);
          await tester.tap(find.byTooltip('Hesap makinesi'));
          await tester.pumpAndSettle();
          await tus(tester, '1250×12%');
          await tus(tester, '=');
          await tus(tester, '×(1234567890,123456×987654321)');
          expect(tester.takeException(), isNull);
          expect(find.byKey(const Key('hesap_sonuc')), findsOneWidget);
        });

        testWidgets('Not sayfası · $ad', (tester) async {
          final durum = dolguluDurum();
          await hazirla(durum);
          await pompala(tester, calisma(durum), durum, boyut, olcek, olcek > 1);
          await tester.tap(find.byTooltip('Not al'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), 'Uzun bir not ' * 30);
          await tester.pump();
          expect(tester.takeException(), isNull);
          expect(find.text('Tamam'), findsOneWidget);
        });

        testWidgets('Notlarım · $ad', (tester) async {
          final durum = dolguluDurum();
          for (final s in durum.banka.bolumSorulari('YET').take(4)) {
            await durum.notlar.kaydet(s.id, 'Çok uzun bir not metni ' * 12);
          }
          await pompala(tester, const NotlarimEkrani(), durum, boyut, olcek, olcek > 1);
          expect(tester.takeException(), isNull);
          expect(find.byType(Dismissible), findsWidgets);
        });
      }
    }

    testWidgets('Ana kabuk (Bugün) Notlarım kartıyla taşmaz', (tester) async {
      final durum = dolguluDurum();
      await durum.notlar.kaydet(durum.banka.sorular.first.id, 'x');
      await pompala(tester, const AnaKabuk(), durum, const Size(320, 568), 2, false);
      expect(tester.takeException(), isNull);
      await pompala(tester, const AyarlarEkrani(), durum, const Size(320, 568), 2, false);
      expect(tester.takeException(), isNull);
    });
  });
}
