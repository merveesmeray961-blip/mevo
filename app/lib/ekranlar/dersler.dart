import 'package:flutter/material.dart';

import '../uygulama.dart';
import '../veri/ilerleme.dart';
import '../veri/modeller.dart';
import 'calisma.dart';
import 'konu.dart';
import '../bilesenler/duzen.dart';

class DerslerEkrani extends StatelessWidget {
  const DerslerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final bolum = durum.bolum;
        final dersler = durum.banka.bolumDersleri(bolum);
        return Scaffold(
          appBar: AppBar(title: const Text('Dersler')),
          body: Govde(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: dersler.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final d = dersler[i];
                final ist = durum.ilerleme.istatistik(durum.banka.dersSorulari(bolum, d.kod));
                return _DersKarti(
                  ders: d,
                  bolum: bolum,
                  ist: ist,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DersDetay(ders: d))),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DersKarti extends StatelessWidget {
  final Ders ders;
  final String bolum;
  final DersIstatistigi ist;
  final VoidCallback onTap;

  const _DersKarti({required this.ders, required this.bolum, required this.ist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final basari = ist.basari;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(ders.gorunenAd(bolum), style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  if (basari != null) BasariRozeti(oran: basari),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Sınavda ${ders.sinavdakiSoru(bolum)} soru · Bankada ${ist.toplam} soru',
                style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: ist.toplam == 0 ? 0 : ist.cozulen / ist.toplam, minHeight: 6),
              ),
              const SizedBox(height: 4),
              Text('${ist.cozulen}/${ist.toplam} soru görüldü', style: t.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class BasariRozeti extends StatelessWidget {
  final double oran;

  const BasariRozeti({super.key, required this.oran});

  @override
  Widget build(BuildContext context) {
    final renk = oran >= 0.7
        ? dogruRenk(context)
        : oran >= 0.5
        // Amber, açık temada beyaz zemin üstünde okunabilsin diye koyulaştırılır (WCAG AA ≥ 4.5:1).
        ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFC94D) : const Color(0xFF8A5A00))
        : yanlisRenk(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: renk.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
      child: Text(
        '%${(oran * 100).round()}',
        style: TextStyle(color: renk, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class DersDetay extends StatelessWidget {
  final Ders ders;

  const DersDetay({super.key, required this.ders});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final bolum = durum.bolum;
        final il = durum.ilerleme;
        final havuz = durum.banka.dersSorulari(bolum, ders.kod);
        final zorlar = [
          for (final s in havuz)
            if (s.zorluk == 3) s,
        ];
        final yanlislar = il.yanlislar(havuz);
        // Sorusu ya da anlatımı olan konular; SGS hukuk gibi eşlenen derslerde konu, bankanın sorgusuyla bulunur.
        final konuSorulari = {for (final k in ders.konular.keys) k: durum.banka.dersSorulari(bolum, ders.kod, konu: k)};
        final konular = [
          for (final e in ders.konular.entries)
            if (konuSorulari[e.key]!.isNotEmpty || durum.banka.anlatim(ders.kod, e.key) != null) e,
        ];
        final t = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(title: Text(ders.gorunenAd(bolum))),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.shuffle),
                  label: Text('Karışık çalış · ${durum.ayarlar.oturumBoyu} soru'),
                  onPressed: () => calismayaBasla(
                    context,
                    baslik: ders.gorunenAd(bolum),
                    sorular: il.calismaSirasi(havuz, durum.ayarlar.oturumBoyu),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.local_fire_department_outlined),
                        label: Text('Zor sorular (${zorlar.length})'),
                        onPressed: zorlar.isEmpty
                            ? null
                            : () =>
                                  calismayaBasla(context, baslik: 'Zor sorular', sorular: il.calismaSirasi(zorlar, 50)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close_rounded),
                        label: Text('Yanlışlarım (${yanlislar.length})'),
                        onPressed: yanlislar.isEmpty
                            ? null
                            : () => calismayaBasla(context, baslik: 'Yanlışlarım', sorular: yanlislar),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Konular', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                for (final k in konular)
                  Builder(
                    builder: (context) {
                      final ist = il.istatistik(konuSorulari[k.key]!);
                      final anlatim = durum.banka.anlatim(ders.kod, k.key);
                      final okundu = anlatim != null && il.okundu(anlatim.anahtar);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            okundu ? Icons.menu_book_rounded : Icons.menu_book_outlined,
                            color: anlatim == null
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(k.value),
                          subtitle: Text(
                            '${anlatim == null ? '' : (okundu ? 'Anlatım okundu · ' : 'Anlatım var · ')}'
                            '${ist.cozulen}/${ist.toplam} soru görüldü',
                          ),
                          trailing: ist.basari == null
                              ? const Icon(Icons.chevron_right)
                              : BasariRozeti(oran: ist.basari!),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => KonuEkrani(ders: ders, konu: k.key),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
