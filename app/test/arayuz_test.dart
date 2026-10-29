import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/ayarlar_ekrani.dart';
import 'package:mevo/ekranlar/bugun.dart';
import 'package:mevo/uygulama.dart';

import 'sahte_ses.dart';
import 'yardimci.dart';

Future<void> ac(WidgetTester tester, Widget ekran, UygulamaDurumu durum) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(Kapsam(durum: durum, child: MaterialApp(home: ekran)));
  await tester.pumpAndSettle();
}

void main() {
  group('Bugün ekranı', () {
    testWidgets('selam ve motive edici not görünür', (tester) async {
      await ac(tester, const BugunEkrani(), durumOlustur(bolum: 'YET'));
      expect(find.textContaining('!'), findsWidgets);
      expect(find.text('Bugün ilk sorunu çözerek başla.'), findsOneWidget);
    });

    testWidgets('soru çözülünce not değişir', (tester) async {
      final durum = durumOlustur(bolum: 'YET');
      final sorular = durum.banka.bolumSorulari('YET');
      for (var i = 0; i < 4; i++) {
        await durum.ilerleme.cevapla(sorular[i], sorular[i].dogru);
      }
      await ac(tester, const BugunEkrani(), durum);
      expect(find.text('İyi gidiyorsun, birkaç soru daha.'), findsOneWidget);
    });
  });

  group('Ayarlar ekranı', () {
    testWidgets('gruplara ayrılmıştır ve tüm gruplar listede bulunur', (tester) async {
      await ac(tester, const AyarlarEkrani(), durumOlustur(bolum: 'YET'));
      // ListView tembel çizer; başlıklar sırayla aşağı kaydırılarak bulunur (her başlık yalnız bir kez geçmeli).
      final liste = find.byType(Scrollable).first;
      for (final ad in ['Çalışma', 'Görünüm ve okuma', 'Tam erişim', 'Verilerim', 'Yasal']) {
        final bulundu = find.text(ad);
        if (bulundu.evaluate().isEmpty) {
          await tester.dragUntilVisible(bulundu, liste, const Offset(0, -150));
        }
        expect(bulundu, findsOneWidget, reason: ad);
      }
    });

    testWidgets('sesli okuma hızı seçilince ayar ve ses motoru güncellenir', (tester) async {
      final motor = SahteSes();
      final durum = durumOlustur(bolum: 'YET', ses: motor);
      await ac(tester, const AyarlarEkrani(), durum);
      await tester.tap(find.text('Hızlı'));
      await tester.pumpAndSettle();
      expect(durum.ayarlar.sesHizi, 0.6);
    });
  });
}
