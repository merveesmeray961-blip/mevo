import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../uygulama.dart';
import 'ayarlar_ekrani.dart';
import 'calisma.dart';
import 'odeme.dart';

class BugunEkrani extends StatelessWidget {
  const BugunEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final r = Theme.of(context).colorScheme;
        final bolum = durum.bolum;
        final havuz = durum.banka.bolumSorulari(bolum);
        final il = durum.ilerleme;
        final tekrar = il.tekrarlar(havuz);
        final yanlis = il.yanlislar(havuz);
        final isaretli = il.isaretliler(havuz);
        final ist = il.istatistik(havuz);
        final sinav = durum.banka.sonrakiSinav(bolum, il.simdi);

        return Scaffold(
          appBar: AppBar(
            title: Text(bolumAdi[bolum]!),
            actions: [
              IconButton(
                tooltip: 'Ayarlar',
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AyarlarEkrani())),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _GeriSayim(sinav: sinav, bugun: il.simdi),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _Sayac(deger: '${il.bugunCozulen}', etiket: 'bugün çözülen'),
                      _Sayac(deger: '${il.seri}', etiket: 'gün üst üste'),
                      _Sayac(deger: '${ist.cozulen}/${ist.toplam}', etiket: 'soru görüldü'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text('Hızlı çalış · ${durum.ayarlar.oturumBoyu} soru'),
                onPressed: () => calismayaBasla(
                  context,
                  baslik: 'Hızlı çalışma',
                  sorular: il.calismaSirasi(havuz, durum.ayarlar.oturumBoyu),
                ),
              ),
              if (!durum.abonelik.premium) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => odemeEkraniAc(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Ücretsiz sürüm: bugün ${durum.kalanUcretsizSoru}/$ucretsizGunlukSoru soru hakkın kaldı · Sınırsız çalış ›',
                      style: t.bodySmall?.copyWith(color: r.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _ListeKarti(
                ikon: Icons.replay,
                baslik: 'Tekrar zamanı gelenler',
                aciklama: 'Unutmadan önce yeniden sorulan sorular',
                sayi: tekrar.length,
                onTap: () => calismayaBasla(context, baslik: 'Tekrar', sorular: il.calismaSirasi(tekrar, 50)),
              ),
              const SizedBox(height: 8),
              _ListeKarti(
                ikon: Icons.close_rounded,
                baslik: 'Yanlış defterim',
                aciklama: 'Son cevabını yanlış verdiğin sorular',
                sayi: yanlis.length,
                onTap: () => calismayaBasla(context, baslik: 'Yanlış defterim', sorular: yanlis),
              ),
              const SizedBox(height: 8),
              _ListeKarti(
                ikon: Icons.bookmark_outline,
                baslik: 'İşaretlediklerim',
                aciklama: 'Sonra bakmak için ayırdığın sorular',
                sayi: isaretli.length,
                onTap: () => calismayaBasla(context, baslik: 'İşaretlediklerim', sorular: isaretli),
              ),
              const SizedBox(height: 24),
              Text(
                durum.banka.uyari,
                style: t.bodySmall?.copyWith(color: r.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GeriSayim extends StatelessWidget {
  final DateTime? sinav;
  final DateTime bugun;

  const _GeriSayim({required this.sinav, required this.bugun});

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final gun = sinav?.difference(DateTime(bugun.year, bugun.month, bugun.day)).inDays;
    return Card(
      color: r.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sıradaki sınav', style: t.labelLarge?.copyWith(color: r.onPrimaryContainer)),
                  const SizedBox(height: 4),
                  Text(
                    sinav == null ? 'Takvim henüz açıklanmadı' : tarihYaz(sinav!),
                    style: t.titleLarge?.copyWith(color: r.onPrimaryContainer, fontWeight: FontWeight.w700),
                  ),
                  if (sinav == null)
                    Text(
                      'TÜRMOB yeni yılın takvimini Aralık ayında açıklar.',
                      style: t.bodySmall?.copyWith(color: r.onPrimaryContainer),
                    ),
                ],
              ),
            ),
            if (gun != null)
              Column(
                children: [
                  Text(
                    gun == 0 ? 'Bugün' : '$gun',
                    style: t.displaySmall?.copyWith(color: r.onPrimaryContainer, fontWeight: FontWeight.w800),
                  ),
                  if (gun > 0) Text('gün kaldı', style: t.labelMedium?.copyWith(color: r.onPrimaryContainer)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Sayac extends StatelessWidget {
  final String deger;
  final String etiket;

  const _Sayac({required this.deger, required this.etiket});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(deger, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(etiket, style: t.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ListeKarti extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final int sayi;
  final VoidCallback onTap;

  const _ListeKarti({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
    required this.sayi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: sayi > 0,
        leading: Icon(ikon),
        title: Text(baslik),
        subtitle: Text(aciklama),
        trailing: Badge(label: Text('$sayi'), isLabelVisible: sayi > 0, child: const Icon(Icons.chevron_right)),
        onTap: sayi > 0 ? onTap : null,
      ),
    );
  }
}
