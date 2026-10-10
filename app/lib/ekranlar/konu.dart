import 'package:flutter/material.dart';

import '../bilesenler/anlatim_gorunumu.dart';
import '../bilesenler/duzen.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'calisma.dart';
import 'dersler.dart';

/// Bir konunun sayfası: önce konu anlatımı, ardından o konudan soru çözme.
class KonuEkrani extends StatelessWidget {
  final Ders ders;
  final String konu;

  const KonuEkrani({super.key, required this.ders, required this.konu});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final r = Theme.of(context).colorScheme;
        final bolum = durum.bolum;
        final il = durum.ilerleme;
        final ad = ders.konular[konu] ?? konu;
        final anlatim = durum.banka.anlatim(ders.kod, konu);
        final sorular = durum.banka.dersSorulari(bolum, ders.kod, konu: konu);
        final ist = il.istatistik(sorular);
        final okundu = anlatim != null && il.okundu(anlatim.anahtar);
        return Scaffold(
          appBar: AppBar(title: Text(ad)),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Text(ders.gorunenAd(bolum), style: t.labelLarge?.copyWith(color: r.onSurfaceVariant)),
                const SizedBox(height: 16),
                _Adim(
                  numara: 1,
                  baslik: 'Konuyu çalış',
                  aciklama: anlatim == null
                      ? 'Bu konunun anlatımı hazırlanıyor; şimdilik sorularla çalışabilirsin.'
                      : '${anlatim.okumaDk} dakikalık okuma${okundu ? ' · okundu' : ''}',
                  tamam: okundu,
                  dugme: anlatim == null
                      ? null
                      : (okundu ? OutlinedButton.icon : FilledButton.icon)(
                          icon: const Icon(Icons.menu_book_rounded),
                          label: Text(okundu ? 'Tekrar oku' : 'Anlatımı aç'),
                          onPressed: () async {
                            // Anlatım "Okudum, soru çöz" ile kapanırsa sorular bu ekrandan başlatılır.
                            final coz = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => AnlatimEkrani(ders: ders, anlatim: anlatim),
                              ),
                            );
                            if (coz == true && context.mounted && sorular.isNotEmpty) {
                              await calismayaBasla(context, baslik: ad, sorular: il.calismaSirasi(sorular, 50));
                            }
                          },
                        ),
                ),
                const SizedBox(height: 12),
                _Adim(
                  numara: 2,
                  baslik: 'Soru çöz',
                  aciklama: sorular.isEmpty ? 'Bu konuda henüz soru yok.' : '${ist.cozulen}/${ist.toplam} soru görüldü',
                  tamam: ist.toplam > 0 && ist.cozulen == ist.toplam,
                  ek: ist.basari == null ? null : BasariRozeti(oran: ist.basari!),
                  dugme: sorular.isEmpty
                      ? null
                      : ((anlatim == null || okundu) ? FilledButton.icon : OutlinedButton.icon)(
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text('Soruları çöz (${sorular.length})'),
                          onPressed: () => calismayaBasla(context, baslik: ad, sorular: il.calismaSirasi(sorular, 50)),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Adim extends StatelessWidget {
  final int numara;
  final String baslik;
  final String aciklama;
  final bool tamam;
  final Widget? ek;
  final Widget? dugme;

  const _Adim({
    required this.numara,
    required this.baslik,
    required this.aciklama,
    required this.tamam,
    this.ek,
    this.dugme,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: tamam ? dogruRenk(context) : r.primaryContainer,
                  child: tamam
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : Text(
                          '$numara',
                          style: TextStyle(color: r.onPrimaryContainer, fontWeight: FontWeight.w700),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(baslik, style: t.titleMedium)),
                ?ek,
              ],
            ),
            const SizedBox(height: 8),
            Text(aciklama, style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant)),
            if (dugme != null) ...[const SizedBox(height: 12), dugme!],
          ],
        ),
      ),
    );
  }
}

/// Konu anlatımını okuma ekranı; sonunda "okudum, soruya geç" adımı vardır.
class AnlatimEkrani extends StatelessWidget {
  final Ders ders;
  final KonuAnlatimi anlatim;

  const AnlatimEkrani({super.key, required this.ders, required this.anlatim});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final sorular = durum.banka.dersSorulari(durum.bolum, ders.kod, konu: anlatim.konu);
    return Scaffold(
      appBar: AppBar(title: Text(anlatim.baslik, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Govde(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(anlatim.baslik, style: t.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${ders.gorunenAd(durum.bolum)} · ${anlatim.okumaDk} dk okuma',
              style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            AnlatimGorunumu(anlatim.metin),
            if (anlatim.kaynaklar.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Dayanak', style: t.titleSmall),
              const SizedBox(height: 4),
              for (final k in anlatim.kaynaklar) Text('• $k', style: t.bodySmall?.copyWith(color: r.onSurfaceVariant)),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              icon: const Icon(Icons.check_rounded),
              label: Text(sorular.isEmpty ? 'Okudum' : 'Okudum, şimdi soru çöz (${sorular.length})'),
              onPressed: () async {
                await durum.ilerleme.okunduIsaretle(anlatim.anahtar);
                if (context.mounted) Navigator.of(context).pop(sorular.isNotEmpty);
              },
            ),
          ],
        ),
      ),
    );
  }
}
