import 'dart:math';

import 'package:flutter/material.dart';

import '../bilesenler/duzen.dart';
import '../uygulama.dart';
import '../veri/cikmis.dart';
import '../veri/modeller.dart';
import 'calisma.dart';

/// Çıkmış sorulardaki ders kodlarının okunur adları (SGS'de bankada olmayan dersler de var).
const cikmisDersAdlari = {
  'FIN': 'Finansal Muhasebe',
  'STD': 'Muhasebe Standartları',
  'MAL': 'Maliyet Muhasebesi',
  'TAB': 'Finansal Tablolar ve Analizi',
  'DEN': 'Muhasebe Denetimi',
  'EKO': 'İktisat',
  'MLY': 'Maliye',
  'MES': 'Meslek Hukuku',
  'SHK': 'Hukuk ve Vergi',
  'GKY': 'Genel Kültür ve Yetenek',
  'VER': 'Vergi Mevzuatı',
  'HUK': 'Hukuk',
  'SPK': 'Sermaye Piyasası Mevzuatı',
};

/// Ana sayfadan açılan ücretsiz çıkmış sorular bölümü.
Future<void> cikmisAc(BuildContext context) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CikmisEkrani()));

class CikmisEkrani extends StatefulWidget {
  /// Açılışta seçili sınav ("SGS" / "Yeterlilik"); verilmezse kullanıcının bölümü.
  final String? baslangicSinav;

  const CikmisEkrani({super.key, this.baslangicSinav});

  @override
  State<CikmisEkrani> createState() => _CikmisEkraniState();
}

class _CikmisEkraniState extends State<CikmisEkrani> {
  late final Future<List<CikmisOturum>> _yukleme = cikmisYukle();
  late String? _sinav = widget.baslangicSinav;
  String? _ders; // null: tüm dersler

  void _baslat(BuildContext context, String baslik, List<Soru> sorular, String Function(Soru) ust) {
    if (sorular.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CalismaEkrani(baslik: baslik, sorular: sorular, ucretsiz: true, ustBilgi: ust),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final durum = Kapsam.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Çıkmış sorular')),
      body: Govde(
        child: FutureBuilder<List<CikmisOturum>>(
          future: _yukleme,
          builder: (context, an) {
            if (!an.hasData) return const Center(child: CircularProgressIndicator());
            final hepsi = an.data!;
            if (hepsi.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Çıkmış soru bulunamadı.')));
            }
            final sinavlar = {for (final o in hepsi) o.sinav}.toList();
            final sinav = _sinav ?? (durum.bolum == 'SGS' || !sinavlar.contains('Yeterlilik') ? 'SGS' : 'Yeterlilik');
            final oturumlar = [for (final o in hepsi) if (o.sinav == sinav) o];
            final dersler = <String>{for (final o in oturumlar) ...o.dersler}.toList()
              ..sort((a, b) => (cikmisDersAdlari[a] ?? a).compareTo(cikmisDersAdlari[b] ?? b));
            List<Soru> suzulmus(CikmisOturum o) => [for (final s in o.sorular) if (_ders == null || s.ders == _ders) s];
            final havuz = [for (final o in oturumlar) ...suzulmus(o)];
            final oturumAdi = {for (final o in hepsi) for (final s in o.sorular) s.id: o.ad};
            String ust(Soru s) => '${cikmisDersAdlari[s.ders] ?? s.konu} · ${oturumAdi[s.id] ?? ''}';
            final ilkYil = oturumlar.map((o) => o.yil).reduce(min);
            final sonYil = oturumlar.map((o) => o.yil).reduce(max);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Card(
                  color: r.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.history_edu_rounded, color: r.onSecondaryContainer, size: 32),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'TESMER\'in yayımladığı geçmiş sınav soruları, resmî cevap anahtarıyla. '
                            'Bu bölüm ücretsizdir; günlük soru hakkından düşmez.',
                            style: t.bodyMedium?.copyWith(color: r.onSecondaryContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (sinavlar.length > 1)
                  SegmentedButton<String>(
                    segments: [for (final s in sinavlar) ButtonSegment(value: s, label: Text(s))],
                    selected: {sinav},
                    onSelectionChanged: (v) => setState(() {
                      _sinav = v.single;
                      _ders = null;
                    }),
                  ),
                const SizedBox(height: 8),
                // Dersler yatay kayar: liste ekranın üst yarısını kaplamaz.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final c in <Widget>[
                    ChoiceChip(
                      label: const Text('Tüm dersler'),
                      selected: _ders == null,
                      onSelected: (_) => setState(() => _ders = null),
                    ),
                    for (final d in dersler)
                      ChoiceChip(
                        label: Text(cikmisDersAdlari[d] ?? d),
                        selected: _ders == d,
                        onSelected: (_) => setState(() => _ders = _ders == d ? null : d),
                      ),
                      ]) Padding(padding: const EdgeInsets.only(right: 8), child: c),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.shuffle_rounded),
                  label: const Text('Karışık 20 soru çöz'),
                  onPressed: havuz.isEmpty
                      ? null
                      : () => _baslat(context, 'Çıkmış · karışık', (havuz.toList()..shuffle()).take(20).toList(), ust),
                ),
                const SizedBox(height: 6),
                Text(
                  '${havuz.length} soru · ${oturumlar.where((o) => suzulmus(o).isNotEmpty).length} sınav',
                  style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text('Sınavlar ($ilkYil–$sonYil)', style: t.titleMedium),
                const SizedBox(height: 8),
                for (final o in oturumlar)
                  if (suzulmus(o).isNotEmpty)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: r.primaryContainer,
                          foregroundColor: r.onPrimaryContainer,
                          child: Text("'${(o.yil % 100).toString().padLeft(2, '0')}", style: t.labelLarge),
                        ),
                        title: Text(o.ad),
                        subtitle: Text('${suzulmus(o).length} soru'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _baslat(context, o.ad, suzulmus(o), ust),
                      ),
                    ),
                const SizedBox(height: 8),
                Text(
                  'Tablo, grafik veya formül içeren ve metne düzgün aktarılamayan sorular listeye alınmadı. '
                  'Sorular sınav tarihindeki mevzuata göredir.',
                  style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
