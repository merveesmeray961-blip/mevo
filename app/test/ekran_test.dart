import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/konu.dart';
import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/main.dart';
import 'package:mevo/uygulama.dart';

import 'yardimci.dart';

Future<void> ac(WidgetTester tester, UygulamaDurumu durum) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MevoUygulamasi(durum: durum));
  await tester.pumpAndSettle();
}

/// Çalışma ekranındaki soruyu A şıkkıyla cevaplar ve sonraki soruya geçer.
Future<void> cevaplaVeGec(WidgetTester tester) async {
  await tester.ensureVisible(find.text('A').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('A').first);
  await tester.pumpAndSettle();
  expect(find.text('Çözüm'), findsOneWidget);
  final dugme = find.byType(FilledButton).last;
  await tester.tap(dugme);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ilk açılışta bölüm seçilir ve ana sayfa açılır', (tester) async {
    final durum = durumOlustur();
    await ac(tester, durum);
    expect(find.text('Hoş geldin'), findsOneWidget);
    await tester.tap(find.text('Yeterlilik Sınavı'));
    await tester.pumpAndSettle();
    expect(durum.ayarlar.bolum, 'YET');
    expect(find.textContaining('Hızlı çalış'), findsOneWidget);
    expect(find.text('28 Kasım 2026'), findsOneWidget);
    expect(find.text('54'), findsOneWidget, reason: '5 Ekim → 28 Kasım 2026');
  });

  testWidgets('çalışma oturumu: cevap, açıklama, özet ve yanlış defteri', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    await durum.ayarlar.oturumBoyuSec(10);
    await ac(tester, durum);
    await tester.tap(find.textContaining('Hızlı çalış'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 10; i++) {
      expect(find.text('${i + 1} / 10'), findsOneWidget);
      await cevaplaVeGec(tester);
    }
    expect(find.textContaining('doğru ·'), findsOneWidget);
    expect(durum.ilerleme.bugunCozulen, 10);
    final yanlis = durum.ilerleme.yanlislar(durum.banka.bolumSorulari('YET')).length;
    expect(find.textContaining('${10 - yanlis} doğru · $yanlis yanlış'), findsOneWidget);
  });

  testWidgets('günlük ücretsiz hak bitince ödeme ekranı çıkar; önizleme erişimi açınca devam edilir', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    final soru = durum.banka.sorular.first;
    for (var i = 0; i < ucretsizGunlukSoru; i++) {
      await durum.ilerleme.cevapla(soru, soru.dogru);
    }
    await ac(tester, durum);
    await tester.tap(find.textContaining('Hızlı çalış'));
    await tester.pumpAndSettle();
    expect(find.text('Sınırsız çalış'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('Önizleme sürümü'), 200);
    await tester.ensureVisible(find.text('Tam erişimi aç'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tam erişimi aç'));
    await tester.pumpAndSettle();
    expect(durum.abonelik.premium, isTrue);
    expect(find.text('Hızlı çalışma'), findsOneWidget);
    expect(find.textContaining(' / '), findsWidgets);
  });

  testWidgets('konu: önce anlatım, okununca o konudan soru çözülür', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    final ders = durum.banka.dersler['FIN']!;
    final anlatim = durum.banka.anlatim('FIN', 'ALC');
    expect(anlatim, isNotNull);
    await tester.pumpWidget(
      Kapsam(
        durum: durum,
        child: MaterialApp(home: KonuEkrani(ders: ders, konu: 'ALC')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Konuyu çalış'), findsOneWidget);
    await tester.tap(find.text('Anlatımı aç'));
    await tester.pumpAndSettle();
    expect(find.text('Bu konuda neler öğreneceksin'), findsOneWidget);
    final bitir = find.textContaining('Okudum, şimdi soru çöz');
    await tester.scrollUntilVisible(bitir, 400);
    await tester.tap(bitir);
    await tester.pumpAndSettle();
    expect(durum.ilerleme.okundu('FIN/ALC'), isTrue);
    // Sorular konu ekranından başlar: çalışma ekranında sayaç görünür.
    expect(find.text('1 / ${durum.banka.dersSorulari('YET', 'FIN', konu: 'ALC').length.clamp(0, 50)}'), findsOneWidget);
  });

  testWidgets('deneme: kurallar, cevap, bitirme ve sonuç', (tester) async {
    final durum = durumOlustur(bolum: 'YET');
    await ac(tester, durum);
    await tester.tap(find.text('Deneme'));
    await tester.pumpAndSettle();
    final ders = find.text('Finansal Muhasebe');
    await tester.scrollUntilVisible(ders, 200, scrollable: find.byType(Scrollable).last);
    await tester.tap(ders);
    await tester.pumpAndSettle();
    expect(find.textContaining('0,25 doğruyu götürür'), findsOneWidget);
    await tester.tap(find.text('Başla'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    final n = durum.banka.dersSorulari('YET', 'FIN').length.clamp(0, 20);
    expect(find.text('1/$n · 0 cevaplandı'), findsOneWidget);
    await tester.ensureVisible(find.text('A').first);
    await tester.pump();
    await tester.tap(find.text('A').first);
    await tester.pump();
    expect(find.text('1/$n · 1 cevaplandı'), findsOneWidget);
    await tester.tap(find.text('Bitir'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('${n - 1} soruyu boş bıraktın'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Bitir'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Deneme sonucu'), findsOneWidget);
    expect(find.text('ders puanı'), findsOneWidget);
    expect(durum.ilerleme.denemeler, hasLength(1));
    expect(durum.denemeHakkiVar, isFalse);
    // Kayıt soruları ve cevapları saklar; geçmiş deneme listeden yeniden açılır.
    final kayit = durum.ilerleme.denemeler.single;
    expect(kayit.soruIdler, hasLength(n));
    expect(kayit.cevaplar, hasLength(1));
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Liste en son ders kartına kaydırılmıştı; geçmiş en üstte.
    await tester.scrollUntilVisible(find.text('Geçmiş denemelerim'), -300, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.textContaining('Puan ').first);
    await tester.pumpAndSettle();
    expect(find.text('Deneme sonucu'), findsOneWidget);
  });

  for (final bolum in ['YET', 'SGS']) {
    testWidgets('$bolum: tüm sekmeler, ders detayı ve ayarlar taşmadan açılır', (tester) async {
      final durum = durumOlustur(bolum: bolum);
      await durum.ayarlar.temaSec(ThemeMode.dark);
      for (final s in durum.banka.bolumSorulari(bolum).take(15)) {
        await durum.ilerleme.cevapla(s, s.zorluk == 3 ? 'A' : s.dogru);
      }
      await ac(tester, durum);
      for (final sekme in ['Dersler', 'Deneme', 'İstatistik', 'Bugün']) {
        await tester.tap(find.text(sekme).last);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Dersler').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();
      expect(find.text('Konular'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bugün').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Ayarlar'));
      await tester.pumpAndSettle();
      expect(find.text('Hazırlandığım sınav'), findsOneWidget);
    });
  }
}
