import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../uygulama.dart';

Future<void> odemeEkraniAc(BuildContext context, {String? neden}) =>
    Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => OdemeEkrani(neden: neden)));

class OdemeEkrani extends StatefulWidget {
  final String? neden;

  const OdemeEkrani({super.key, this.neden});

  @override
  State<OdemeEkrani> createState() => _OdemeEkraniState();
}

class _OdemeEkraniState extends State<OdemeEkrani> {
  String? _secili;
  bool _isleniyor = false;

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final abonelik = durum.abonelik;
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final paketler = abonelik.paketler;
    _secili ??= paketler.first.kimlik;

    Future<void> satinAl() async {
      setState(() => _isleniyor = true);
      final ok = await abonelik.satinAl(paketler.firstWhere((p) => p.kimlik == _secili));
      if (!context.mounted) return;
      setState(() => _isleniyor = false);
      if (ok) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          if (widget.neden != null) ...[
            Text(
              widget.neden!,
              style: t.bodyLarge?.copyWith(color: r.tertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          Text(
            'Sınırsız çalış',
            style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          for (final (ikon, metin) in [
            (Icons.all_inclusive, 'Günlük soru sınırı yok'),
            (Icons.timer_outlined, 'Gerçek sınav kurallarıyla sınırsız deneme'),
            (Icons.replay, 'Yanlış defteri ve aralıklı tekrar'),
            (Icons.menu_book_outlined, 'Her sorunun kanun maddesine dayanan açıklaması'),
            (Icons.update, 'Mevzuat değiştikçe güncellenen soru bankası'),
          ])
            ListTile(
              leading: Icon(ikon, color: r.primary),
              title: Text(metin),
              dense: true,
            ),
          const SizedBox(height: 12),
          RadioGroup<String>(
            groupValue: _secili,
            onChanged: (v) => setState(() => _secili = v),
            child: Column(
              children: [
                for (final p in paketler)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: _secili == p.kimlik ? r.primary : r.outlineVariant,
                          width: _secili == p.kimlik ? 2 : 1,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: p.kimlik,
                        title: Text(p.ad, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(p.aciklama),
                        secondary: Text(p.fiyat ?? '—', style: t.titleMedium),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _isleniyor ? null : satinAl,
            child: _isleniyor
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Devam et'),
          ),
          TextButton(
            onPressed: () async {
              final ok = await abonelik.geriYukle();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ok ? 'Aboneliğin geri yüklendi.' : 'Bu hesapta etkin bir abonelik bulunamadı.')),
              );
              if (ok) Navigator.of(context).pop();
            },
            child: const Text('Satın alımı geri yükle'),
          ),
          if (abonelik.onizleme)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: r.tertiaryContainer, borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Önizleme sürümü: ödeme alınmaz. "Devam et" yalnızca bu cihazda tam erişimi açar; '
                'fiyatlar mağaza yayınından önce belirlenecek.',
                style: t.bodySmall?.copyWith(color: r.onTertiaryContainer),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Ücretsiz sürümde günde $ucretsizGunlukSoru soru ve $ucretsizDeneme deneme sınavı. '
            'Abonelik, mağaza hesabından istediğin zaman iptal edilebilir.',
            style: t.bodySmall?.copyWith(color: r.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
