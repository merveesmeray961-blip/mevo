import 'package:flutter/material.dart';

import '../uygulama.dart';
import 'calisma.dart';
import 'dersler.dart';
import '../bilesenler/duzen.dart';

class IstatistikEkrani extends StatelessWidget {
  const IstatistikEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final r = Theme.of(context).colorScheme;
        final bolum = durum.bolum;
        final banka = durum.banka;
        final il = durum.ilerleme;
        final havuz = banka.bolumSorulari(bolum);
        final genel = il.istatistik(havuz);
        final gunler = il.sonYediGun();
        final enCok = gunler.fold(1, (a, b) => b > a ? b : a);

        // Zayıf konular: en az 3 cevap verilmiş konulardan başarısı en düşük olanlar.
        final konular = <(String, String, double, int)>[];
        for (final d in banka.bolumDersleri(bolum)) {
          for (final k in d.konular.entries) {
            final ist = il.istatistik(banka.dersSorulari(bolum, d.kod, konu: k.key));
            if (ist.deneme >= 3) konular.add((d.kod, k.key, ist.basari!, ist.deneme));
          }
        }
        konular.sort((a, b) => a.$3.compareTo(b.$3));
        final zayif = konular.where((k) => k.$3 < 0.7).take(5).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('İstatistik')),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  children: [
                    _Kutu(deger: '${genel.cozulen}', etiket: 'farklı soru'),
                    const SizedBox(width: 8),
                    _Kutu(deger: '${genel.deneme}', etiket: 'toplam cevap'),
                    const SizedBox(width: 8),
                    _Kutu(deger: genel.basari == null ? '–' : '%${(genel.basari! * 100).round()}', etiket: 'başarı'),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Son 7 gün', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80 + MediaQuery.textScalerOf(context).scale(40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (var i = 0; i < 7; i++)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(gunler[i] == 0 ? '' : '${gunler[i]}', style: t.labelSmall),
                                      ),
                                      const SizedBox(height: 2),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: FractionallySizedBox(
                                            heightFactor: (gunler[i] / enCok).clamp(0.02, 1.0),
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                              decoration: BoxDecoration(
                                                color: i == 6 ? r.primary : r.primary.withValues(alpha: 0.45),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          _gunKisa(il.simdi.subtract(Duration(days: 6 - i))),
                                          style: t.labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Ders bazında başarı', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      for (final d in banka.bolumDersleri(bolum))
                        Builder(
                          builder: (context) {
                            final ist = il.istatistik(banka.dersSorulari(bolum, d.kod));
                            return ListTile(
                              dense: true,
                              title: Text(d.gorunenAd(bolum)),
                              subtitle: Text('${ist.cozulen}/${ist.toplam} soru görüldü'),
                              trailing: ist.basari == null ? const Text('–') : BasariRozeti(oran: ist.basari!),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Güçlendirmen gereken konular', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (zayif.isEmpty)
                  Text(
                    konular.isEmpty
                        ? 'Konu bazında değerlendirme için biraz daha soru çöz (konu başına en az 3 cevap).'
                        : 'Şu an %70 altında kalan konun yok. Böyle devam!',
                    style: t.bodyMedium,
                  )
                else
                  for (final k in zayif)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(banka.dersler[k.$1]!.konular[k.$2]!),
                        subtitle: Text(banka.dersler[k.$1]!.gorunenAd(bolum)),
                        trailing: BasariRozeti(oran: k.$3),
                        onTap: () => calismayaBasla(
                          context,
                          baslik: banka.dersler[k.$1]!.konular[k.$2]!,
                          sorular: il.calismaSirasi(banka.dersSorulari(bolum, k.$1, konu: k.$2), 50),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  static const _gunAdlari = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  static String _gunKisa(DateTime t) => _gunAdlari[t.weekday - 1];
}

class _Kutu extends StatelessWidget {
  final String deger;
  final String etiket;

  const _Kutu({required this.deger, required this.etiket});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(deger, style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              Text(etiket, style: t.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
