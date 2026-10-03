import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../bilesenler/duzen.dart';
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
  bool _geriYukleniyor = false;
  bool _basladi = false;
  bool _kapandi = false;
  late bool _baslangicPremium;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_basladi) return;
    _basladi = true;
    final abonelik = Kapsam.of(context).abonelik;
    _baslangicPremium = abonelik.premium;
    // Mağaza fiyatı her açılışta tazelenir; bağlantı kurulamadıysa "Yeniden dene" ile tekrar sorulur.
    if (abonelik.magaza != MagazaDurumu.hazir) Future.microtask(abonelik.baslat);
  }

  void _kapat() {
    if (_kapandi || !mounted) return;
    _kapandi = true;
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  Future<void> _geriYukle(AbonelikServisi abonelik) async {
    setState(() => _geriYukleniyor = true);
    final ok = await abonelik.geriYukle();
    if (!mounted) return;
    setState(() => _geriYukleniyor = false);
    if (ok) return; // premium değişimi dinleyicisi ekranı kapatır
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(abonelik.hata ?? 'Bu hesapta daha önce yapılmış bir satın alım bulunamadı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final abonelik = Kapsam.of(context).abonelik;
    return ListenableBuilder(
      listenable: abonelik,
      builder: (context, _) {
        if (abonelik.premium && !_baslangicPremium) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _kapat());
        }
        return _govde(context, abonelik);
      },
    );
  }

  Widget _govde(BuildContext context, AbonelikServisi abonelik) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final paket = abonelik.paketler.first;
    final magaza = abonelik.magaza;
    final suruyor = abonelik.islem == IslemDurumu.suruyor;
    final satinAlinabilir = magaza == MagazaDurumu.hazir && !suruyor && abonelik.islem != IslemDurumu.beklemede;

    return Scaffold(
      appBar: AppBar(),
      body: Govde(
        child: ListView(
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
              (Icons.system_update_alt, 'Uygulama güncellemeleriyle gelen yeni sorular'),
            ])
              ListTile(
                leading: Icon(ikon, color: r.primary),
                title: Text(metin),
                dense: true,
              ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: r.primary, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      children: [
                        Text(paket.ad, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        Text(paket.fiyat ?? '—', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(paket.aciklama, style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._durumBolumu(context, abonelik, satinAlinabilir: satinAlinabilir, paket: paket),
            TextButton(
              onPressed: _geriYukleniyor || suruyor ? null : () => _geriYukle(abonelik),
              child: _geriYukleniyor
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Satın alımı geri yükle'),
            ),
            if (abonelik.onizleme)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: r.tertiaryContainer, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Önizleme sürümü: ödeme alınmaz. "Tam erişimi aç" yalnızca bu cihazda tam erişimi açar; '
                  'fiyat mağazada belirlenir.',
                  style: t.bodySmall?.copyWith(color: r.onTertiaryContainer),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Ücretsiz sürümde günde $ucretsizGunlukSoru soru ve $ucretsizDeneme deneme sınavı. '
              'Tam erişim tek seferlik bir ödemedir; abonelik değildir, otomatik yenilenmez.',
              style: t.bodySmall?.copyWith(color: r.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _durumBolumu(
    BuildContext context,
    AbonelikServisi abonelik, {
    required bool satinAlinabilir,
    required AbonelikPaketi paket,
  }) {
    final r = Theme.of(context).colorScheme;
    Widget mesaj(String metin, {Color? renk, bool yeniden = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Text(
            metin,
            textAlign: TextAlign.center,
            style: TextStyle(color: renk ?? r.onSurfaceVariant),
          ),
          if (yeniden)
            TextButton.icon(
              onPressed: abonelik.baslat,
              icon: const Icon(Icons.refresh),
              label: const Text('Yeniden dene'),
            ),
        ],
      ),
    );

    return [
      switch (abonelik.magaza) {
        MagazaDurumu.yukleniyor => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        ),
        MagazaDurumu.kullanilamiyor => mesaj(
          'Mağazaya şu anda ulaşılamıyor. İnternet bağlantını ve Google Play / App Store hesabını kontrol edip tekrar dene.',
          yeniden: true,
        ),
        MagazaDurumu.urunYok => mesaj(
          'Tam erişim ürünü mağazada şu anda bulunamadı. Biraz sonra tekrar dene.',
          yeniden: true,
        ),
        MagazaDurumu.hazir => FilledButton(
          onPressed: satinAlinabilir ? () => abonelik.satinAl(paket) : null,
          child: abonelik.islem == IslemDurumu.suruyor
              ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(paket.fiyat == null ? 'Tam erişimi aç' : 'Tam erişimi aç · ${paket.fiyat}'),
        ),
      },
      if (abonelik.islem == IslemDurumu.beklemede)
        mesaj('Ödemen onay bekliyor. Onaylandığında tam erişim kendiliğinden açılır.'),
      if (abonelik.islem == IslemDurumu.iptal) mesaj('Satın alma iptal edildi. Ücret alınmadı.'),
      if (abonelik.islem == IslemDurumu.hata) mesaj(abonelik.hata ?? 'Satın alma tamamlanamadı.', renk: r.error),
    ];
  }
}
