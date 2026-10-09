import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../uygulama.dart';
import 'ayarlar_ekrani.dart';
import 'calisma.dart';
import 'notlar.dart';
import 'odeme.dart';
import '../bilesenler/duzen.dart';

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
        final notlu = durum.notlar.notluSorular(havuz);
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
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _GeriSayim(sinav: sinav, bugun: il.simdi),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _GunlukHedef(cozulen: il.bugunCozulen),
                        _Sayac(
                          deger: '${il.seri}',
                          etiket: 'gün üst üste',
                          ikon: Icons.local_fire_department_rounded,
                          ikonRengi: il.seri > 0 ? const Color(0xFFF26B1D) : null,
                        ),
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
                // Yeni kullanıcı devre dışı gri kartlar yerine ne yapacağını söyleyen tek bir kart görür;
                // listeler yalnızca içlerinde soru olduğunda gösterilir.
                if (ist.cozulen == 0)
                  Card(
                    color: r.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.rocket_launch_outlined, color: r.onSecondaryContainer, size: 32),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'İlk ${durum.ayarlar.oturumBoyu} sorunu çöz; yanlışların, tekrar zamanı gelen sorular '
                              've işaretlediklerin burada birikir.',
                              style: t.bodyMedium?.copyWith(color: r.onSecondaryContainer),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                for (final k in [
                  _ListeKarti(
                    ikon: Icons.replay,
                    baslik: 'Tekrar zamanı gelenler',
                    aciklama: 'Unutmadan önce yeniden sorulan sorular',
                    sayi: tekrar.length,
                    onTap: () => calismayaBasla(context, baslik: 'Tekrar', sorular: il.calismaSirasi(tekrar, 50)),
                  ),
                  _ListeKarti(
                    ikon: Icons.close_rounded,
                    baslik: 'Yanlış defterim',
                    aciklama: 'Son cevabını yanlış verdiğin sorular',
                    sayi: yanlis.length,
                    onTap: () => calismayaBasla(context, baslik: 'Yanlış defterim', sorular: yanlis),
                  ),
                  _ListeKarti(
                    ikon: Icons.bookmark_outline,
                    baslik: 'İşaretlediklerim',
                    aciklama: 'Sonra bakmak için ayırdığın sorular',
                    sayi: isaretli.length,
                    onTap: () => calismayaBasla(context, baslik: 'İşaretlediklerim', sorular: isaretli),
                  ),
                  _ListeKarti(
                    ikon: Icons.edit_note,
                    baslik: 'Notlarım',
                    aciklama: 'Sorulara yazdığın kişisel notlar',
                    sayi: notlu.length,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotlarimEkrani())),
                  ),
                ])
                  if (k.sayi > 0) Padding(padding: const EdgeInsets.only(bottom: 8), child: k),
                const SizedBox(height: 24),
                Text(
                  durum.banka.uyari,
                  style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
  final IconData? ikon;
  final Color? ikonRengi;

  const _Sayac({required this.deger, required this.etiket, this.ikon, this.ikonRengi});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ikon != null) ...[
                Icon(ikon, size: 22, color: ikonRengi ?? Theme.of(context).colorScheme.outline),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(deger, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700), maxLines: 1),
              ),
            ],
          ),
          Text(etiket, style: t.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Günlük hedef halkası: bugün çözülen soru sayısı ve hedefe ne kadar kaldığı.
class _GunlukHedef extends StatelessWidget {
  static const hedef = 30;
  final int cozulen;

  const _GunlukHedef({required this.cozulen});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final tamam = cozulen >= hedef;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: (cozulen / hedef).clamp(0, 1).toDouble(),
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  backgroundColor: r.surfaceContainerHighest,
                  color: tamam ? dogruRenk(context) : r.primary,
                ),
                Center(
                  child: tamam
                      ? Icon(Icons.check_rounded, color: dogruRenk(context))
                      : Text('$cozulen', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(tamam ? 'günlük hedef tamam' : 'bugün · hedef $hedef', style: t.bodySmall, textAlign: TextAlign.center),
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
    final r = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(ikon, color: r.primary),
        title: Text(baslik),
        subtitle: Text(aciklama),
        // Sayı oka binmeyen, sakin renkli bir etiket olarak gösterilir.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: r.primaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '$sayi',
                style: TextStyle(color: r.onPrimaryContainer, fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
