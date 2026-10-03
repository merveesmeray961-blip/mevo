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

class _Tablo extends StatelessWidget {
  final List<List<String>> satirlar;
  final TextStyle stil;

  const _Tablo({required this.satirlar, required this.stil});

  @override
  Widget build(BuildContext context) {
    final renk = Theme.of(context).colorScheme;
    final sutun = satirlar.fold<int>(0, (a, r) => r.length > a ? r.length : a);
    final kucuk = stil.copyWith(fontSize: (stil.fontSize ?? 16) - 2);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(color: renk.outlineVariant),
        children: [
          for (var i = 0; i < satirlar.length; i++)
            TableRow(
              decoration: i == 0 ? BoxDecoration(color: renk.primaryContainer.withValues(alpha: 0.5)) : null,
              children: [
                for (var j = 0; j < sutun; j++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text.rich(
                      TextSpan(children: satirIci(j < satirlar[i].length ? satirlar[i][j] : '', kucuk)),
                      style: i == 0 ? kucuk.copyWith(fontWeight: FontWeight.w600) : kucuk,
                      textAlign: j == 0 ? TextAlign.left : TextAlign.right,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
