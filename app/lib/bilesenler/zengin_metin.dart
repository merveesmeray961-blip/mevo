import 'package:flutter/material.dart';

/// Soru kökündeki sade biçimlendirmeyi gösterir: **kalın** vurgular ve `| a | b |` satırlarından tablo.
class ZenginMetin extends StatelessWidget {
  final String metin;
  final TextStyle? stil;

  const ZenginMetin(this.metin, {super.key, this.stil});

  @override
  Widget build(BuildContext context) {
    final temel = stil ?? Theme.of(context).textTheme.bodyLarge!;
    final parcalar = <Widget>[];
    final paragraf = <String>[];
    final tablo = <List<String>>[];

    void paragrafBitir() {
      if (paragraf.isEmpty) return;
      parcalar.add(Text.rich(TextSpan(children: satirIci(paragraf.join('\n'), temel)), style: temel));
      paragraf.clear();
    }

    void tabloBitir() {
      if (tablo.isEmpty) return;
      parcalar.add(_Tablo(satirlar: [...tablo], stil: temel));
      tablo.clear();
    }

    for (final satir in metin.split('\n')) {
      final t = satir.trim();
      if (t.startsWith('|')) {
        paragrafBitir();
        final hucreler = t.replaceAll(RegExp(r'^\||\|$'), '').split('|').map((h) => h.trim()).toList();
        if (!hucreler.every((h) => RegExp(r'^:?-{2,}:?$').hasMatch(h))) tablo.add(hucreler);
      } else if (t.isEmpty) {
        paragrafBitir();
        tabloBitir();
      } else {
        tabloBitir();
        paragraf.add(t);
      }
    }
    paragrafBitir();
    tabloBitir();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < parcalar.length; i++) ...[if (i > 0) const SizedBox(height: 10), parcalar[i]],
      ],
    );
  }
}

/// `**kalın**` işaretlerini TextSpan'lere çevirir.
List<TextSpan> satirIci(String metin, TextStyle temel) {
  final sonuc = <TextSpan>[];
  final desen = RegExp(r'\*\*(.+?)\*\*', dotAll: true);
  var konum = 0;
  for (final m in desen.allMatches(metin)) {
    if (m.start > konum) sonuc.add(TextSpan(text: metin.substring(konum, m.start)));
    sonuc.add(
      TextSpan(
        text: m.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
    konum = m.end;
  }
  if (konum < metin.length) sonuc.add(TextSpan(text: metin.substring(konum)));
  return sonuc;
}

/// Tablo ekran genişliğine sığar: ilk sütun (kalem adları) kalan genişliği alır ve gerekirse alt satıra kayar,
/// sayı sütunları kendi genişliğinde kalır (sayılar bölünmez). Sayı sütunları bile sığmıyorsa tablo bütünüyle
/// küçültülür; yatay kaydırma gerekmez.
class _Tablo extends StatelessWidget {
  final List<List<String>> satirlar;
  final TextStyle stil;

  const _Tablo({required this.satirlar, required this.stil});

  static const _yatayBosluk = 6.0;
  static const _ilkSutunEnAz = 96.0;

  @override
  Widget build(BuildContext context) {
    final renk = Theme.of(context).colorScheme;
    final olcek = MediaQuery.textScalerOf(context);
    final sutun = satirlar.fold<int>(0, (a, r) => r.length > a ? r.length : a);
    final kucuk = stil.copyWith(fontSize: (stil.fontSize ?? 16) - 2);
    TextStyle hucreStili(int i) => i == 0 ? kucuk.copyWith(fontWeight: FontWeight.w600) : kucuk;
    String hucre(int i, int j) => j < satirlar[i].length ? satirlar[i][j] : '';

    // Metin tablosu (ör. konu anlatımında "hesap | ne izlenir"): sütunlar kaydırılarak sola yaslı yazılır.
    // Sayı tablosu (soru kökündeki bilanço vb.): sayı sütunları tek satır ve sağa yaslıdır.
    final harf = RegExp(r'[A-Za-zÇĞİÖŞÜçğıöşü]{3}');
    final metinTablosu = [
      for (var i = 1; i < satirlar.length; i++)
        for (var j = 1; j < sutun; j++) hucre(i, j),
    ].any((h) => harf.hasMatch(h) && h.length > 12);
    if (metinTablosu) {
      return Table(
        columnWidths: {for (var j = 0; j < sutun; j++) j: FlexColumnWidth(j == 0 ? 1 : 1.6)},
        border: TableBorder.all(color: renk.outlineVariant),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          for (var i = 0; i < satirlar.length; i++)
            TableRow(
              decoration: i == 0 ? BoxDecoration(color: renk.primaryContainer.withValues(alpha: 0.5)) : null,
              children: [
                for (var j = 0; j < sutun; j++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text.rich(
                      TextSpan(children: satirIci(hucre(i, j), hucreStili(i))),
                      style: hucreStili(i),
                    ),
                  ),
              ],
            ),
        ],
      );
    }

    // Sayı sütunlarının doğal genişliği (en geniş hücre + iç boşluk).
    var sayiGenisligi = 0.0;
    for (var j = 1; j < sutun; j++) {
      var enGenis = 0.0;
      for (var i = 0; i < satirlar.length; i++) {
        final tp = TextPainter(
          text: TextSpan(text: hucre(i, j).replaceAll('**', ''), style: hucreStili(i)),
          textDirection: TextDirection.ltr,
          textScaler: olcek,
          maxLines: 1,
        )..layout();
        if (tp.width > enGenis) enGenis = tp.width;
      }
      sayiGenisligi += enGenis + 2 * _yatayBosluk + 1;
    }
    final enAzGenislik = sayiGenisligi + _ilkSutunEnAz + 2;

    return LayoutBuilder(
      builder: (context, kisit) {
        final genislik = kisit.maxWidth >= enAzGenislik ? kisit.maxWidth : enAzGenislik;
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: genislik,
            child: Table(
              columnWidths: const {0: FlexColumnWidth()},
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: TableBorder.all(color: renk.outlineVariant),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                for (var i = 0; i < satirlar.length; i++)
                  TableRow(
                    decoration: i == 0 ? BoxDecoration(color: renk.primaryContainer.withValues(alpha: 0.5)) : null,
                    children: [
                      for (var j = 0; j < sutun; j++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: _yatayBosluk, vertical: 4),
                          child: Text.rich(
                            TextSpan(children: satirIci(hucre(i, j), hucreStili(i))),
                            style: hucreStili(i),
                            textAlign: j == 0 ? TextAlign.left : TextAlign.right,
                            softWrap: j == 0,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
