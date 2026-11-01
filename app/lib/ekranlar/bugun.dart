import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../bilesenler/duzen.dart';
import '../uygulama.dart';
import 'ana_kabuk.dart';
import 'anlatimlar.dart';
import 'ayarlar_ekrani.dart';
import 'calisma.dart';
import 'notlar.dart';
import 'odeme.dart';

/// Ana sayfa. Üstte renkli başlık (selam, günlük hedef halkası, sıradaki sınav); altında günün iki ana işi
/// (hızlı çalış ve konu anlatımı), kısayollar ve biriken listeler.
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
        final kalanGun = sinav?.difference(DateTime(il.simdi.year, il.simdi.month, il.simdi.day)).inDays;

        final baslik = _Baslik(
          bolumAd: bolumAdi[bolum]!,
          seri: il.seri,
          bugunCozulen: il.bugunCozulen,
          hedef: durum.abonelik.premium ? _GunlukHedef.tamHedef : ucretsizGunlukSoru,
          sinav: sinav,
          kalanGun: kalanGun,
          gorulen: ist.cozulen,
          toplam: ist.toplam,
        );

        final ustKartlar = <Widget>[
          // Günün ana işi: limon renkli, ekranın en dikkat çekici düğmesi.
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: limon,
              foregroundColor: limonYazi,
              minimumSize: const Size(64, 58),
              textStyle: const TextStyle(fontFamily: 'Sora', fontSize: 17, fontWeight: FontWeight.w800),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 26),
            label: Text('Hızlı çalış · ${durum.ayarlar.oturumBoyu} soru'),
            onPressed: () => calismayaBasla(
              context,
              baslik: 'Hızlı çalışma',
              sorular: il.calismaSirasi(havuz, durum.ayarlar.oturumBoyu),
            ),
          ),
          if (!durum.abonelik.premium) ...[
            const SizedBox(height: 4),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => odemeEkraniAc(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                // Hak bol iken yalnız bilgi verilir; çağrı, hak azalınca (≤5) belirir.
                child: Text(
                  durum.kalanUcretsizSoru <= 5
                      ? 'Bugün ${durum.kalanUcretsizSoru} ücretsiz soru hakkın kaldı · Sınırsız çalış ›'
                      : 'Bugün ${durum.kalanUcretsizSoru}/$ucretsizGunlukSoru ücretsiz soru hakkın var',
                  style: t.bodySmall?.copyWith(
                    color: durum.kalanUcretsizSoru <= 5 ? r.primary : r.onSurfaceVariant,
                    fontWeight: durum.kalanUcretsizSoru <= 5 ? FontWeight.w700 : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else
            const SizedBox(height: 12),
          const _AnlatimKarti(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Kutucuk(
                  ikon: Icons.timer_outlined,
                  baslik: 'Deneme sınavı',
                  aciklama: bolum == 'YMM' ? 'Klasik · 100 puan' : 'Gerçek kurallarla',
                  onTap: () => anaSekme.value = 2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Kutucuk(
                  ikon: Icons.insights_rounded,
                  baslik: 'Zayıf konularım',
                  aciklama: 'İstatistiğe bak',
                  onTap: () => anaSekme.value = 3,
                ),
              ),
            ],
          ),
        ];
        final altKartlar = <Widget>[
          const SizedBox(height: 16),
          // Yeni kullanıcı devre dışı gri kartlar yerine ne yapacağını söyleyen tek bir kart görür.
          if (ist.cozulen == 0)
            Card(
              color: r.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.rocket_launch_outlined, color: r.onSecondaryContainer, size: 30),
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
              ikon: Icons.replay_rounded,
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
              renk: yanlisRenk(context),
              onTap: () => calismayaBasla(context, baslik: 'Yanlış defterim', sorular: yanlis),
            ),
            _ListeKarti(
              ikon: Icons.bookmark_outline_rounded,
              baslik: 'İşaretlediklerim',
              aciklama: 'Sonra bakmak için ayırdığın sorular',
              sayi: isaretli.length,
              onTap: () => calismayaBasla(context, baslik: 'İşaretlediklerim', sorular: isaretli),
            ),
            _ListeKarti(
              ikon: Icons.edit_note_rounded,
              baslik: 'Notlarım',
              aciklama: 'Sorulara yazdığın kişisel notlar',
              sayi: notlu.length,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotlarimEkrani())),
            ),
          ])
            if (k.sayi > 0) Padding(padding: const EdgeInsets.only(top: 8), child: k),
          const SizedBox(height: 24),
          Text(
            durum.banka.uyari,
            style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ];

        return Scaffold(
          body: Govde(
            enGenis: tabletGenisligi,
            child: LayoutBuilder(
              builder: (context, kisit) {
                if (kisit.maxWidth < ikiSutunEsigi) {
                  final yan = kisit.maxWidth > okumaGenisligi ? (kisit.maxWidth - okumaGenisligi) / 2 : 0.0;
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(horizontal: yan), child: baslik),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16 + yan, 16, 16 + yan, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [...ustKartlar, ...altKartlar],
                        ),
                      ),
                    ],
                  );
                }
                // Geniş tablet: başlık üstte, altında iki sütun (solda günün işleri, sağda listeler).
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    baslik,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 24), children: ustKartlar)),
                            const SizedBox(width: 24),
                            Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 24), children: altKartlar)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Renkli başlık: bölüm adı + ayarlar, selam ve motive edici not, günlük hedef halkası, sıradaki sınav ve seri.
class _Baslik extends StatelessWidget {
  final String bolumAd;
  final int seri;
  final int bugunCozulen;
  final int hedef;
  final DateTime? sinav;
  final int? kalanGun;
  final int gorulen;
  final int toplam;

  const _Baslik({
    required this.bolumAd,
    required this.seri,
    required this.bugunCozulen,
    required this.hedef,
    required this.sinav,
    required this.kalanGun,
    required this.gorulen,
    required this.toplam,
  });

  /// Saat → selam (saf işlev; test edilebilir).
  static String selam(int saat) => saat < 5
      ? 'İyi geceler'
      : saat < 12
      ? 'Günaydın'
      : saat < 18
      ? 'İyi günler'
      : 'İyi akşamlar';

  /// Duruma göre tek cümlelik motive edici not.
  static String not(int seri, int bugunCozulen) {
    if (bugunCozulen == 0 && seri > 0) return '$seri günlük serini bugün de sürdür.';
    if (bugunCozulen == 0) return 'Bugün ilk sorunu çözerek başla.';
    if (bugunCozulen < 10) return 'İyi gidiyorsun, birkaç soru daha.';
    return 'Bugünkü çalışman harika, böyle devam.';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final koyu = Theme.of(context).brightness == Brightness.dark;
    // Başlık zemini: açık temada ana renk, koyu temada biraz daha derin bir yüzey; yazılar her ikisinde de beyaz.
    final zemin = koyu ? r.primaryContainer : r.primary;
    const yazi = Colors.white;
    final soluk = Colors.white.withValues(alpha: 0.78);
    final gun = kalanGun;
    final ust = MediaQuery.paddingOf(context).top;
    return Container(
      decoration: BoxDecoration(
        color: zemin,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, ust + 4, 8, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bolumAd,
                  style: t.titleSmall?.copyWith(color: soluk),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _SeriRozeti(seri: seri),
              IconButton(
                tooltip: 'Ayarlar',
                color: yazi,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AyarlarEkrani())),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${selam(DateTime.now().hour)}!', style: t.headlineSmall?.copyWith(color: yazi)),
                const SizedBox(height: 4),
                Text(not(seri, bugunCozulen), style: t.bodyMedium?.copyWith(color: soluk)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _GunlukHedef(cozulen: bugunCozulen, hedef: hedef),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIRADAKİ SINAV',
                              style: t.labelSmall?.copyWith(color: soluk, letterSpacing: 1),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sinav == null ? 'Takvim açıklanmadı' : tarihYaz(sinav!),
                              style: t.titleMedium?.copyWith(color: yazi, fontWeight: FontWeight.w800),
                            ),
                            if (gun != null && gun >= 0)
                              Text(
                                gun == 0 ? 'Sınav bugün' : '$gun gün kaldı',
                                style: t.bodyMedium?.copyWith(color: soluk),
                              )
                            else
                              Text('TÜRMOB yeni takvimi Aralık\'ta açıklar', style: t.bodySmall?.copyWith(color: soluk)),
                            const SizedBox(height: 4),
                            Text('$gorulen/$toplam soru görüldü', style: t.labelSmall?.copyWith(color: soluk)),
                          ],
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
    );
  }
}

/// Günlük hedef halkası: bugün çözülen soru sayısı ve hedef.
class _GunlukHedef extends StatelessWidget {
  /// Tam erişimli kullanıcının günlük hedefi.
  static const tamHedef = 30;
  final int cozulen;
  final int hedef;

  const _GunlukHedef({required this.cozulen, this.hedef = tamHedef});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final tamam = cozulen >= hedef;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 58,
          height: 58,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: (cozulen / hedef).clamp(0, 1).toDouble(),
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                color: limon,
              ),
              Center(
                child: tamam
                    ? const Icon(Icons.check_rounded, color: limon)
                    : Text(
                        '$cozulen',
                        style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 76,
          child: Text(
            tamam ? 'hedef tamam' : 'bugün · hedef $hedef',
            style: t.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.78)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Ana sayfadaki kare kısayol kartı.
class _Kutucuk extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final VoidCallback onTap;

  const _Kutucuk({required this.ikon, required this.baslik, required this.aciklama, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(ikon, color: r.primary),
              const SizedBox(height: 8),
              Text(baslik, style: t.titleSmall),
              const SizedBox(height: 2),
              Text(aciklama, style: t.bodySmall?.copyWith(color: r.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListeKarti extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final int sayi;
  final Color? renk;
  final VoidCallback onTap;

  const _ListeKarti({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
    required this.sayi,
    required this.onTap,
    this.renk,
  });

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(ikon, color: renk ?? r.primary),
        title: Text(baslik, style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(aciklama),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: r.primaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '$sayi',
                style: TextStyle(color: r.onPrimaryContainer, fontWeight: FontWeight.w800, fontFamily: 'Sora'),
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

/// Ana sayfadan konu anlatımına tek dokunuşla erişim: kaldığın (ya da sıradaki) konu, sesli dinleme ve tüm liste.
class _AnlatimKarti extends StatelessWidget {
  const _AnlatimKarti();

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    // Sabit (const) olduğu için üst ekranla birlikte yeniden çizilmez; ilerlemeyi kendisi dinler.
    return ListenableBuilder(listenable: durum.degisim, builder: (context, _) => _ciz(context, durum));
  }

  Widget _ciz(BuildContext context, UygulamaDurumu durum) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final hepsi = tumAnlatimlar(durum);
    if (hepsi.isEmpty) return const SizedBox.shrink();
    final siradaki = siradakiAnlatim(durum)!;
    final il = durum.ilerleme;
    final okunan = hepsi.where((e) => il.okundu(e.anlatim.anahtar)).length;
    final devam = il.sonAnlatim == siradaki.anlatim.anahtar && !il.okundu(siradaki.anlatim.anahtar);
    final acik = durum.anlatimAcik(siradaki.ders, siradaki.anlatim.konu);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text('Konu anlatımları', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('$okunan/${hepsi.length} okundu', style: t.labelMedium?.copyWith(color: r.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: r.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: Icon(
                    acik ? Icons.menu_book_rounded : Icons.lock_outline_rounded,
                    color: r.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        devam ? 'KALDIĞIN YER' : 'SIRADAKİ KONU',
                        style: t.labelSmall?.copyWith(color: r.primary, letterSpacing: 1),
                      ),
                      Text(
                        siradaki.ders.konular[siradaki.anlatim.konu] ?? siradaki.anlatim.baslik,
                        style: t.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${siradaki.ders.gorunenAd(durum.bolum)} · ${siradaki.anlatim.okumaDk} dk',
                        style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size(64, 46)),
                    onPressed: () => anlatimAc(context, siradaki.ders, siradaki.anlatim),
                    child: Text(devam ? 'Okumaya devam et' : 'Konuyu aç'),
                  ),
                ),
                const SizedBox(width: 8),
                // Kulaklık: anlatımı açar ve sesli okumayı hemen başlatır.
                IconButton.outlined(
                  tooltip: 'Sesli dinle',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(52, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: BorderSide(color: r.outlineVariant),
                  ),
                  icon: Icon(Icons.headphones_rounded, color: r.primary),
                  onPressed: () => anlatimAc(context, siradaki.ders, siradaki.anlatim, dinle: true),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnlatimlarEkrani())),
              child: Text('Tüm konu anlatımları (${hepsi.length}) ›'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Çalışma serisi rozeti (limon).
class _SeriRozeti extends StatelessWidget {
  final int seri;

  const _SeriRozeti({required this.seri});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: limon, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded, size: 16, color: limonYazi),
          const SizedBox(width: 2),
          Text(
            '$seri',
            style: t.labelMedium?.copyWith(color: limonYazi, fontWeight: FontWeight.w800),
            semanticsLabel: '$seri gün üst üste',
          ),
        ],
      ),
    );
  }
}
