import 'package:flutter/material.dart';

import '../uygulama.dart';
import '../veri/modeller.dart';
import 'zengin_metin.dart';

/// Soru kökü ve şıklar. [cevapGoster] true olduğunda doğru şık yeşil, yanlış seçim kırmızı işaretlenir.
class SoruGorunumu extends StatelessWidget {
  final Soru soru;
  final String? secilen;
  final bool cevapGoster;
  final ValueChanged<String>? onSec;
  final String? ustBilgi;

  const SoruGorunumu({
    super.key,
    required this.soru,
    this.secilen,
    this.cevapGoster = false,
    this.onSec,
    this.ustBilgi,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ustBilgi != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(ustBilgi!, style: t.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
        ZenginMetin(soru.kok, stil: t.bodyLarge?.copyWith(height: 1.45)),
        const SizedBox(height: 16),
        for (final h in harfler) ...[
          _Sik(
            harf: h,
            metin: soru.secenekler[h] ?? '',
            durum: _durum(h),
            onTap: onSec == null ? null : () => onSec!(h),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  _SikDurumu _durum(String h) {
    if (!cevapGoster) return h == secilen ? _SikDurumu.secili : _SikDurumu.normal;
    if (h == soru.dogru) return _SikDurumu.dogru;
    if (h == secilen) return _SikDurumu.yanlis;
    return _SikDurumu.soluk;
  }
}

enum _SikDurumu { normal, secili, dogru, yanlis, soluk }

class _Sik extends StatelessWidget {
  final String harf;
  final String metin;
  final _SikDurumu durum;
  final VoidCallback? onTap;

  const _Sik({required this.harf, required this.metin, required this.durum, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final (Color kenar, Color? zemin, Color harfZemin, Color harfYazi) = switch (durum) {
      _SikDurumu.normal || _SikDurumu.soluk => (r.outlineVariant, null, r.surfaceContainerHighest, r.onSurface),
      _SikDurumu.secili => (r.primary, r.primaryContainer.withValues(alpha: 0.45), r.primary, r.onPrimary),
      _SikDurumu.dogru => (
        dogruRenk(context),
        dogruRenk(context).withValues(alpha: 0.12),
        dogruRenk(context),
        Colors.white,
      ),
      _SikDurumu.yanlis => (
        yanlisRenk(context),
        yanlisRenk(context).withValues(alpha: 0.12),
        yanlisRenk(context),
        Colors.white,
      ),
    };
    final ikon = switch (durum) {
      _SikDurumu.dogru => Icon(Icons.check_circle, color: dogruRenk(context)),
      _SikDurumu.yanlis => Icon(Icons.cancel, color: yanlisRenk(context)),
      _ => null,
    };
    return Opacity(
      opacity: durum == _SikDurumu.soluk ? 0.6 : 1,
      child: Material(
        color: zemin ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: kenar, width: durum == _SikDurumu.normal || durum == _SikDurumu.soluk ? 1 : 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: harfZemin,
                  child: Text(
                    harf,
                    style: TextStyle(color: harfYazi, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text.rich(TextSpan(children: satirIci(metin, Theme.of(context).textTheme.bodyLarge!))),
                  ),
                ),
                if (ikon != null) ...[const SizedBox(width: 8), ikon],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cevaptan sonra gösterilen açıklama: doğru cevabın gerekçesi, seçilen yanlış şıkkın neden yanlış olduğu,
/// çözüm adımları, diğer şıklar ve dayanak maddeler (alıntılarıyla).
class AciklamaKarti extends StatelessWidget {
  final Soru soru;
  final String? secilen;

  const AciklamaKarti({super.key, required this.soru, this.secilen});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final dogruMu = secilen == soru.dogru;
    final baslik = secilen == null
        ? 'Boş bıraktın · Doğru cevap ${soru.dogru}'
        : dogruMu
        ? 'Doğru!'
        : 'Yanlış · Doğru cevap ${soru.dogru}';
    final renk = secilen == null ? r.outline : (dogruMu ? dogruRenk(context) : yanlisRenk(context));
    final digerleri = [
      for (final h in harfler)
        if (h != soru.dogru && h != secilen && soru.celdiriciler[h] != null) h,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              baslik,
              style: t.titleMedium?.copyWith(color: renk, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (secilen != null && !dogruMu && soru.celdiriciler[secilen] != null) ...[
              Text('Neden $secilen değil?', style: t.labelLarge),
              const SizedBox(height: 4),
              Text.rich(TextSpan(children: satirIci(soru.celdiriciler[secilen]!, t.bodyMedium!))),
              const SizedBox(height: 12),
            ],
            Text('Çözüm', style: t.labelLarge),
            const SizedBox(height: 4),
            Text.rich(TextSpan(children: satirIci(soru.dogruNeden, t.bodyMedium!)), style: t.bodyMedium),
            if (soru.hesapAdimlari.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Adım adım', style: t.labelLarge),
              const SizedBox(height: 4),
              for (var i = 0; i < soru.hesapAdimlari.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${i + 1}. ${soru.hesapAdimlari[i]}', style: t.bodyMedium),
                ),
            ],
            if (soru.pufNoktalari != null)
              _Acilir(
                baslik: 'Sorunun püf noktaları',
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text.rich(
                      TextSpan(children: satirIci(soru.pufNoktalari!, t.bodyMedium!)),
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
            if (digerleri.isNotEmpty)
              _Acilir(
                baslik: 'Diğer şıklar',
                children: [
                  for (final h in digerleri)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$h) ',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            ...satirIci(soru.celdiriciler[h]!, t.bodyMedium!),
                          ],
                        ),
                        style: t.bodyMedium,
                      ),
                    ),
                ],
              ),
            if (soru.kaynaklar.isNotEmpty)
              _Acilir(
                baslik: 'Dayanak (${soru.kaynaklar.length})',
                children: [
                  for (final k in soru.kaynaklar)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${k.mevzuat}, ${k.madde}', style: t.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                          if (k.alinti != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border(left: BorderSide(color: r.primary, width: 3)),
                              ),
                              child: Text('“${k.alinti}”', style: t.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Acilir extends StatelessWidget {
  final String baslik;
  final List<Widget> children;

  const _Acilir({required this.baslik, required this.children});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(baslik, style: Theme.of(context).textTheme.labelLarge),
        children: children,
      ),
    );
  }
}
