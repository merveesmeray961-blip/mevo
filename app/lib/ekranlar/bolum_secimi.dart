import 'package:flutter/material.dart';

import '../uygulama.dart';
import 'ana_kabuk.dart';

class BolumSecimi extends StatelessWidget {
  final bool ilkAcilis;

  const BolumSecimi({super.key, this.ilkAcilis = false});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final yet = durum.banka.formatlar['YET']!;
    final sgs = durum.banka.formatlar['SGS']!;

    Future<void> sec(String b) async {
      await durum.ayarlar.bolumSec(b);
      if (!context.mounted) return;
      if (ilkAcilis) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AnaKabuk()));
      } else {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: ilkAcilis ? null : AppBar(title: const Text('Sınavını seç')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (ilkAcilis) ...[
              const SizedBox(height: 24),
              Text('Hoş geldin', style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Hangi SMMM sınavına hazırlanıyorsun? Daha sonra ayarlardan değiştirebilirsin.', style: t.bodyLarge),
              const SizedBox(height: 24),
            ],
            _BolumKarti(
              baslik: 'Staja Giriş Sınavı',
              kisa: 'SGS',
              aciklama:
                  '${sgs.toplamSoru} soru · ${sgs.toplamSureDk} dakika · yanlış doğruyu götürmez · bağıl değerlendirme',
              secili: durum.ayarlar.bolum == 'SGS',
              onTap: () => sec('SGS'),
            ),
            const SizedBox(height: 12),
            _BolumKarti(
              baslik: 'Yeterlilik Sınavı',
              kisa: 'YET',
              aciklama:
                  '8 ders × ${yet.dersBasinaSoru} soru · ders başına ${yet.dersBasinaSureDk} dakika · '
                  '4 yanlış 1 doğruyu götürür · ders ≥${yet.dersMin}, ortalama ≥${yet.ortalamaMin}',
              secili: durum.ayarlar.bolum == 'YET',
              onTap: () => sec('YET'),
            ),
            const SizedBox(height: 32),
            Text(durum.banka.uyari, style: t.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _BolumKarti extends StatelessWidget {
  final String baslik;
  final String kisa;
  final String aciklama;
  final bool secili;
  final VoidCallback onTap;

  const _BolumKarti({
    required this.baslik,
    required this.kisa,
    required this.aciklama,
    required this.secili,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: secili ? r.primary : r.outlineVariant, width: secili ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: r.primaryContainer,
                child: Text(
                  kisa,
                  style: TextStyle(color: r.onPrimaryContainer, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(baslik, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(aciklama, style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
