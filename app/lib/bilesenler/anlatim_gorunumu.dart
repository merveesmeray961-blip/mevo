import 'package:flutter/material.dart';

import 'zengin_metin.dart';

/// Konu anlatımı metnini gösterir. Desteklenen sade Markdown:
/// `## Başlık`, `### Alt başlık`, `- madde`, `1. sıralı madde`, `> not kutusu`, `**kalın**` ve `| tablo |` satırları.
/// Not kutusu `> **Sınav ipucu:** …` gibi kalın bir etiketle başlarsa etiket vurgulanır.
class AnlatimGorunumu extends StatelessWidget {
  final String metin;

  const AnlatimGorunumu(this.metin, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final govde = t.bodyLarge!.copyWith(height: 1.55);
    final parcalar = <Widget>[];
    final duz = <String>[];
    final kutu = <String>[];

    void duzBitir() {
      if (duz.isEmpty) return;
      parcalar.add(ZenginMetin(duz.join('\n'), stil: govde));
      duz.clear();
    }

    void kutuBitir() {
      if (kutu.isEmpty) return;
      parcalar.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: r.secondaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: r.primary, width: 4)),
          ),
          child: ZenginMetin(kutu.join('\n'), stil: govde.copyWith(color: r.onSecondaryContainer)),
        ),
      );
      kutu.clear();
    }

    for (final satir in metin.split('\n')) {
      final s = satir.trimRight();
      final m = s.trimLeft();
      if (m.startsWith('>')) {
        duzBitir();
        kutu.add(m.replaceFirst(RegExp(r'^>\s?'), ''));
        continue;
      }
      kutuBitir();
      if (m.startsWith('### ') || m.startsWith('## ')) {
        duzBitir();
        final alt = m.startsWith('### ');
        parcalar.add(
          Padding(
            padding: EdgeInsets.only(top: alt ? 6 : 14),
            child: Text(
              m.replaceFirst(RegExp(r'^#{2,3}\s'), ''),
              style: (alt ? t.titleMedium : t.titleLarge)?.copyWith(
                fontWeight: FontWeight.w700,
                color: alt ? null : r.primary,
              ),
            ),
          ),
        );
      } else if (RegExp(r'^(-|\*|\d+\.)\s').hasMatch(m)) {
        duzBitir();
        final sirali = RegExp(r'^\d+\.').stringMatch(m);
        final icerik = m.replaceFirst(RegExp(r'^(-|\*|\d+\.)\s'), '');
        parcalar.add(
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: sirali == null ? 18 : 26,
                  child: Text(
                    sirali ?? '•',
                    style: govde.copyWith(color: r.primary, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text.rich(TextSpan(children: satirIci(icerik, govde)), style: govde),
                ),
              ],
            ),
          ),
        );
      } else {
        duz.add(s);
      }
    }
    duzBitir();
    kutuBitir();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < parcalar.length; i++) ...[if (i > 0) const SizedBox(height: 10), parcalar[i]],
      ],
    );
  }
}
