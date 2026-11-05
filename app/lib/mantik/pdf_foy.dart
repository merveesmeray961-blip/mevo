/// Yazdırılabilir çalışma föyü (PDF): seçilen test ve klasik sorular, isteğe bağlı cevap anahtarı ve çözümler.
library;

import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../veri/modeller.dart';

/// Föyün içeriği ve biçimi.
class FoyAyari {
  final String baslik;
  final String urunAdi;
  final List<Soru> testler;
  final List<KlasikSoru> klasikler;

  /// Ders kodu → görünen ad (soru başlıklarında ve kapakta).
  final Map<String, String> dersAdlari;
  final bool cevapAnahtari;
  final bool cozumler;

  /// Klasik sorunun altına cevap yazmak için çizgili boş alan bırakılır.
  final bool yazmaAlani;
  final DateTime tarih;

  const FoyAyari({
    required this.baslik,
    required this.urunAdi,
    required this.testler,
    required this.klasikler,
    required this.dersAdlari,
    this.cevapAnahtari = true,
    this.cozumler = false,
    this.yazmaAlani = true,
    required this.tarih,
  });
}

/// Yazı tipleri bir kez yüklenir (Roboto: Türkçe harfler ve ₺ işareti dahil).
class FoyYazilari {
  final pw.Font normal;
  final pw.Font kalin;

  /// Roboto'da olmayan işaretler (oklar, kök, onay işareti) için yedek yazılar.
  final List<pw.Font> yedek;

  const FoyYazilari(this.normal, this.kalin, [this.yedek = const []]);

  static FoyYazilari? _onbellek;

  static Future<FoyYazilari> yukle() async {
    if (_onbellek != null) return _onbellek!;
    Future<pw.Font> yaz(String ad) async => pw.Font.ttf(await rootBundle.load('assets/fonts/$ad.ttf'));
    return _onbellek = FoyYazilari(
      await yaz('Roboto-400'),
      await yaz('Roboto-700'),
      [await yaz('NotoSansMath-Regular'), await yaz('NotoSansSymbols2-Regular')],
    );
  }
}

const _aylar = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
const _murekkep = PdfColor.fromInt(0xFF111827);
const _gri = PdfColor.fromInt(0xFF555B6E);
const _cizgi = PdfColor.fromInt(0xFFD5D7E0);
const _zemin = PdfColor.fromInt(0xFFF2F3F7);

/// Föyü üretir ve PDF baytlarını döndürür.
Future<Uint8List> foyUret(FoyAyari a, {FoyYazilari? yazilar}) async {
  final y = yazilar ?? await FoyYazilari.yukle();
  final tema = pw.ThemeData.withFont(base: y.normal, bold: y.kalin, fontFallback: y.yedek);
  final belge = pw.Document(title: a.baslik, author: a.urunAdi, creator: a.urunAdi, theme: tema);
  final govde = pw.TextStyle(fontSize: 10.5, lineSpacing: 2.2, color: _murekkep);
  final kucuk = pw.TextStyle(fontSize: 8.5, color: _gri);
  final tarih = '${a.tarih.day} ${_aylar[a.tarih.month - 1]} ${a.tarih.year}';

  pw.Widget ust(pw.Context c) => pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 6),
    margin: const pw.EdgeInsets.only(bottom: 10),
    decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _cizgi, width: 0.8))),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(a.urunAdi, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _murekkep)),
        pw.Text(a.baslik, style: kucuk),
      ],
    ),
  );
  pw.Widget alt(pw.Context c) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text('Özgün hazırlık sorularıdır; resmî sınav soruları değildir.', style: kucuk),
      pw.Text('${c.pageNumber} / ${c.pagesCount}', style: kucuk),
    ],
  );

  final icerik = <pw.Widget>[
    pw.Text(a.baslik, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: _murekkep)),
    pw.SizedBox(height: 4),
    pw.Text(
      [
        tarih,
        if (a.testler.isNotEmpty) '${a.testler.length} test sorusu',
        if (a.klasikler.isNotEmpty) '${a.klasikler.length} klasik soru',
      ].join(' · '),
      style: pw.TextStyle(fontSize: 10, color: _gri),
    ),
    pw.SizedBox(height: 6),
    pw.Text(
      ({for (final s in a.testler) s.ders, for (final k in a.klasikler) k.ders}.map((d) => a.dersAdlari[d] ?? d)).join(', '),
      style: pw.TextStyle(fontSize: 9.5, color: _gri),
    ),
    pw.SizedBox(height: 10),
    pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: pw.BoxDecoration(color: _zemin, borderRadius: pw.BorderRadius.circular(6)),
      child: pw.Row(children: [
        pw.Expanded(child: pw.Text('Ad Soyad: ..............................................', style: govde)),
        pw.Text('Süre: ............', style: govde),
      ]),
    ),
    pw.SizedBox(height: 14),
  ];

  // Test soruları
  if (a.testler.isNotEmpty) {
    icerik.add(_bolumBasligi('Test soruları', y));
    for (var i = 0; i < a.testler.length; i++) {
      final s = a.testler[i];
      // Soru kökü sayfa akışına öğe öğe eklenir (uzun tablo içeren kök sayfadan taşmasın); şıklar bir arada kalır.
      icerik.add(pw.Text('Soru ${i + 1}', style: govde.copyWith(fontWeight: pw.FontWeight.bold)));
      icerik.addAll(markdown(s.kok, govde));
      icerik.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 4, bottom: 14),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final h in harfler)
                if (s.secenekler[h] != null)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 18, child: pw.Text('$h)', style: govde.copyWith(fontWeight: pw.FontWeight.bold))),
                        pw.Expanded(child: pw.RichText(text: pw.TextSpan(children: satirIci(s.secenekler[h]!, govde)))),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      );
    }
  }

  // Klasik sorular
  if (a.klasikler.isNotEmpty) {
    if (a.testler.isNotEmpty) icerik.add(pw.NewPage());
    icerik.add(_bolumBasligi('Klasik sorular', y));
    for (var i = 0; i < a.klasikler.length; i++) {
      final k = a.klasikler[i];
      icerik.add(
        pw.Text(
          'Soru ${i + 1} · ${a.dersAdlari[k.ders] ?? k.ders} · ${k.puan} puan · ${k.sureDk} dk',
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _murekkep),
        ),
      );
      icerik.add(pw.SizedBox(height: 4));
      icerik.addAll(markdown(k.soru, govde));
      if (a.yazmaAlani) {
        icerik.add(pw.SizedBox(height: 6));
        for (var c = 0; c < 14; c++) {
          icerik.add(pw.Container(
            height: 20,
            decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _cizgi, width: 0.6))),
          ));
        }
      }
      icerik.add(pw.SizedBox(height: 16));
    }
  }

  // Cevap anahtarı ve çözümler
  if (a.cevapAnahtari && (a.testler.isNotEmpty || (a.cozumler && a.klasikler.isNotEmpty))) {
    icerik.add(pw.NewPage());
    icerik.add(_bolumBasligi(a.cozumler ? 'Cevap anahtarı ve çözümler' : 'Cevap anahtarı', y));
    if (a.testler.isNotEmpty) {
      icerik.add(
        pw.Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < a.testler.length; i++)
              pw.Container(
                width: 46,
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: _cizgi), borderRadius: pw.BorderRadius.circular(4)),
                child: pw.Text('${i + 1}-${a.testler[i].dogru}', style: govde.copyWith(fontWeight: pw.FontWeight.bold)),
              ),
          ],
        ),
      );
      icerik.add(pw.SizedBox(height: 14));
    }
    if (a.cozumler) {
      for (var i = 0; i < a.testler.length; i++) {
        final s = a.testler[i];
        icerik.add(pw.Text('${i + 1}. Cevap: ${s.dogru}', style: govde.copyWith(fontWeight: pw.FontWeight.bold)));
        icerik.addAll(markdown(s.dogruNeden, govde));
        if (s.hesapAdimlari.isNotEmpty) {
          for (final h in s.hesapAdimlari) {
            icerik.add(pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: '• ', style: govde), ...satirIci(h, govde)])),
            ));
          }
        }
        if (s.pufNoktalari != null && s.pufNoktalari!.trim().isNotEmpty) {
          icerik.addAll(markdown('**Püf noktası:** ${s.pufNoktalari}', govde));
        }
        icerik.add(pw.SizedBox(height: 8));
      }
      for (var i = 0; i < a.klasikler.length; i++) {
        final k = a.klasikler[i];
        if (i == 0 && a.testler.isNotEmpty) icerik.add(pw.SizedBox(height: 8));
        icerik.add(pw.Text('Klasik soru ${i + 1} · örnek çözüm',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _murekkep)));
        icerik.add(pw.SizedBox(height: 4));
        icerik.addAll(markdown(k.cozum, govde));
        icerik.add(pw.SizedBox(height: 6));
        icerik.add(pw.Text('Puanlama', style: govde.copyWith(fontWeight: pw.FontWeight.bold)));
        icerik.add(_tablo([
          ['Ölçüt', 'Puan'],
          for (final p in k.puanlama) [p.olcut, _puan(p.puan)],
          ['Toplam', '${k.puan}'],
        ], govde, genislik: const {0: pw.FlexColumnWidth(), 1: pw.FixedColumnWidth(44)}));
        icerik.add(pw.SizedBox(height: 14));
      }
    }
  }

  belge.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(42, 36, 42, 36),
      header: ust,
      footer: alt,
      maxPages: 2000,
      build: (_) => icerik,
    ),
  );
  return belge.save();
}

String _puan(double p) => p == p.roundToDouble() ? p.toStringAsFixed(0) : p.toStringAsFixed(1).replaceAll('.', ',');

pw.Widget _bolumBasligi(String metin, FoyYazilari y) => pw.Container(
  margin: const pw.EdgeInsets.only(bottom: 10),
  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: pw.BoxDecoration(color: _murekkep, borderRadius: pw.BorderRadius.circular(5)),
  child: pw.Text(metin, style: pw.TextStyle(font: y.kalin, fontSize: 12, color: PdfColors.white)),
);

/// `**kalın**` işaretli satır içi metni parçalara ayırır.
List<pw.InlineSpan> satirIci(String metin, pw.TextStyle temel) {
  final parcalar = <pw.InlineSpan>[];
  final kalin = temel.copyWith(fontWeight: pw.FontWeight.bold);
  var i = 0;
  for (final m in RegExp(r'\*\*(.+?)\*\*').allMatches(metin)) {
    if (m.start > i) parcalar.add(pw.TextSpan(text: metin.substring(i, m.start), style: temel));
    parcalar.add(pw.TextSpan(text: m.group(1), style: kalin));
    i = m.end;
  }
  if (i < metin.length) parcalar.add(pw.TextSpan(text: metin.substring(i), style: temel));
  return parcalar;
}

pw.Widget _tablo(List<List<String>> satirlar, pw.TextStyle temel, {Map<int, pw.TableColumnWidth>? genislik}) {
  if (satirlar.isEmpty) return pw.SizedBox();
  final sutun = satirlar.map((s) => s.length).reduce((a, b) => a > b ? a : b);
  return pw.Table(
    columnWidths: genislik,
    border: pw.TableBorder.all(color: _cizgi, width: 0.6),
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      for (var r = 0; r < satirlar.length; r++)
        pw.TableRow(
          decoration: r == 0 ? const pw.BoxDecoration(color: _zemin) : null,
          children: [
            for (var c = 0; c < sutun; c++)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: satirIci(
                      c < satirlar[r].length ? satirlar[r][c] : '',
                      r == 0 ? temel.copyWith(fontSize: 9, fontWeight: pw.FontWeight.bold) : temel.copyWith(fontSize: 9),
                    ),
                  ),
                ),
              ),
          ],
        ),
    ],
  );
}

/// Uygulamadaki sade Markdown'ı (paragraf, başlık, madde işareti, tablo, kalın) PDF öğelerine çevirir.
List<pw.Widget> markdown(String metin, pw.TextStyle temel) {
  final ogeler = <pw.Widget>[];
  final satirlar = metin.replaceAll('\r', '').split('\n');
  var i = 0;
  while (i < satirlar.length) {
    final s = satirlar[i].trimRight();
    if (s.trimLeft().startsWith('|')) {
      final tablo = <List<String>>[];
      while (i < satirlar.length && satirlar[i].trimLeft().startsWith('|')) {
        final h = satirlar[i].trim();
        final hucreler = h.substring(1, h.endsWith('|') ? h.length - 1 : h.length).split('|').map((x) => x.trim()).toList();
        if (!hucreler.every((x) => RegExp(r'^:?-{2,}:?$').hasMatch(x))) tablo.add(hucreler);
        i++;
      }
      // Tablo doğrudan sayfa akışına eklenir: uzun tablolar sayfadan sayfaya bölünebilsin.
      ogeler
        ..add(pw.SizedBox(height: 4))
        ..add(_tablo(tablo, temel))
        ..add(pw.SizedBox(height: 4));
      continue;
    }
    if (s.trim().isEmpty) {
      ogeler.add(pw.SizedBox(height: 4));
    } else if (RegExp(r'^#{1,6}\s').hasMatch(s)) {
      ogeler.add(pw.Padding(
        padding: const pw.EdgeInsets.only(top: 4, bottom: 2),
        child: pw.Text(s.replaceFirst(RegExp(r'^#{1,6}\s'), '').replaceAll('**', ''),
            style: temel.copyWith(fontWeight: pw.FontWeight.bold, fontSize: (temel.fontSize ?? 10.5) + 1)),
      ));
    } else if (RegExp(r'^\s*([-*•]|\d+[.)])\s').hasMatch(s)) {
      final m = RegExp(r'^(\s*)([-*•]|\d+[.)])\s+(.*)$').firstMatch(s)!;
      final isaret = RegExp(r'^\d').hasMatch(m.group(2)!) ? '${m.group(2)} ' : '• ';
      ogeler.add(pw.Padding(
        padding: pw.EdgeInsets.only(left: 8.0 + m.group(1)!.length * 4, bottom: 1),
        child: pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: isaret, style: temel), ...satirIci(m.group(3)!, temel)])),
      ));
    } else if (s.startsWith('>')) {
      ogeler.add(pw.Container(
        padding: const pw.EdgeInsets.only(left: 8),
        decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: _cizgi, width: 2))),
        child: pw.RichText(text: pw.TextSpan(children: satirIci(s.replaceFirst(RegExp(r'^>\s?'), ''), temel.copyWith(color: _gri)))),
      ));
    } else {
      ogeler.add(pw.RichText(text: pw.TextSpan(children: satirIci(s, temel))));
    }
    i++;
  }
  return ogeler;
}
