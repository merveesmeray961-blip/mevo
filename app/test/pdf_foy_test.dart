import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/ekranlar/pdf_olustur.dart';
import 'package:mevo/mantik/pdf_foy.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/modeller.dart';
import 'package:pdf/widgets.dart' as pw;

import 'yardimci.dart';

/// Bankadaki HER soru (kök, şıklar, çözüm, tablo, klasik çözüm ve puanlama) PDF'e sorunsuz dökülebilmeli.
Future<void> _hepsiniDok(SoruBankasi banka, String urunAdi) async {
  final adlar = {for (final d in banka.dersler.values) d.kod: d.ad};
  const parca = 250;
  for (var i = 0; i < banka.sorular.length; i += parca) {
    final bayt = await foyUret(FoyAyari(
      baslik: 'Deneme föyü',
      urunAdi: urunAdi,
      testler: banka.sorular.sublist(i, (i + parca).clamp(0, banka.sorular.length)),
      klasikler: const [],
      dersAdlari: adlar,
      cozumler: true,
      tarih: DateTime(2026, 11, 6),
    ));
    expect(String.fromCharCodes(bayt.take(5)), '%PDF-');
  }
  for (var i = 0; i < banka.klasikler.length; i += 60) {
    final bayt = await foyUret(FoyAyari(
      baslik: 'Klasik föy',
      urunAdi: urunAdi,
      testler: const [],
      klasikler: banka.klasikler.sublist(i, (i + 60).clamp(0, banka.klasikler.length)),
      dersAdlari: adlar,
      cozumler: true,
      tarih: DateTime(2026, 11, 6),
    ));
    expect(String.fromCharCodes(bayt.take(5)), '%PDF-');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('markdown: tablo, kalın ve madde işaretli satırlar öğeye dönüşür', () {
    final ogeler = markdown('**Kalın** giriş\n\n| A | B |\n|---|---|\n| 1 | 2 |\n- madde\n# Başlık', const pw.TextStyle());
    expect(ogeler.length, greaterThanOrEqualTo(5));
  });

  test('SMMM bankasının tamamı PDF olarak dökülebilir', () async {
    await _hepsiniDok(gercekBanka(Urun.smmm), 'Mizan SMMM');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('YMM bankasının tamamı (test + klasik) PDF olarak dökülebilir', () async {
    await _hepsiniDok(gercekBanka(Urun.ymm), 'Tasdik YMM');
  }, timeout: const Timeout(Duration(minutes: 10)));

  testWidgets('PDF ekranı açılır; ücretsiz kullanıcıda oluştur ödeme ekranına götürür', (tester) async {
    final durum = durumOlustur(urun: Urun.ymm);
    await tester.pumpWidget(
      Kapsam(
        durum: durum,
        child: MaterialApp(theme: tema(Brightness.light), home: const PdfOlusturEkrani()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PDF çalışma föyü'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Klasik'), 200);
    expect(find.text('Klasik'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pdf-olustur')));
    await tester.pumpAndSettle();
    expect(find.textContaining('PDF çalışma föyü tam erişimle açılır'), findsOneWidget);
  });
}
