import 'package:flutter/material.dart';

import '../bilesenler/duzen.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'calisma.dart';
import 'konu.dart';
import 'odeme.dart';

/// Bir anlatım ve ait olduğu ders.
typedef DersAnlatimi = ({Ders ders, KonuAnlatimi anlatim});

/// Bölümdeki tüm konu anlatımları, müfredat sırasıyla (ders ders, konu konu).
List<DersAnlatimi> tumAnlatimlar(UygulamaDurumu durum) => [
  for (final d in durum.banka.bolumDersleri(durum.bolum))
    for (final k in d.konular.keys)
      if (durum.banka.anlatim(d.kod, k) case final a?) (ders: d, anlatim: a),
];

/// Ana ekrandaki "kaldığın yerden devam et" önerisi: son açılan anlatım okunmadıysa o; okunduysa ya da hiç
/// açılmadıysa erişilebilen ilk okunmamış anlatım; hepsi okunduysa son açılan.
DersAnlatimi? siradakiAnlatim(UygulamaDurumu durum) {
  final hepsi = tumAnlatimlar(durum);
  if (hepsi.isEmpty) return null;
  final il = durum.ilerleme;
  final son = il.sonAnlatim;
  final sonIndeks = son == null ? -1 : hepsi.indexWhere((e) => e.anlatim.anahtar == son);
  if (sonIndeks >= 0 && !il.okundu(son!)) return hepsi[sonIndeks];
  bool uygun(DersAnlatimi e) => !il.okundu(e.anlatim.anahtar) && durum.anlatimAcik(e.ders, e.anlatim.konu);
  // Önce son okunanın ardından gelenler, sonra baştan.
  for (var i = sonIndeks + 1; i < hepsi.length; i++) {
    if (uygun(hepsi[i])) return hepsi[i];
  }
  for (var i = 0; i <= sonIndeks && i < hepsi.length; i++) {
    if (uygun(hepsi[i])) return hepsi[i];
  }
  return sonIndeks >= 0 ? hepsi[sonIndeks] : hepsi.first;
}

/// Aynı dersteki bir sonraki anlatım (yoksa null).
DersAnlatimi? sonrakiAnlatim(UygulamaDurumu durum, Ders ders, KonuAnlatimi a) {
  final konular = ders.konular.keys.toList();
  for (var i = konular.indexOf(a.konu) + 1; i < konular.length; i++) {
    if (durum.banka.anlatim(ders.kod, konular[i]) case final s?) return (ders: ders, anlatim: s);
  }
  return null;
}

/// Anlatımı açar: kilitliyse önce ödeme ekranı; okunup "soru çöz" denirse o konunun soruları başlar.
/// [yerine] true ise açık ekranın (önceki anlatımın) yerine geçer.
Future<void> anlatimAc(
  BuildContext context,
  Ders ders,
  KonuAnlatimi anlatim, {
  bool yerine = false,
  bool dinle = false,
}) async {
  final durum = Kapsam.of(context);
  if (!durum.anlatimAcik(ders, anlatim.konu)) {
    await odemeEkraniAc(context, neden: 'Bu konunun anlatımı tam erişimde.');
    if (!context.mounted || !durum.anlatimAcik(ders, anlatim.konu)) return;
  }
  await durum.ilerleme.sonAnlatimKaydet(anlatim.anahtar);
  if (!context.mounted) return;
  final rota = MaterialPageRoute<bool>(builder: (_) => AnlatimEkrani(ders: ders, anlatim: anlatim, otomatikDinle: dinle));
  final nav = Navigator.of(context);
  final coz = await (yerine ? nav.pushReplacement<bool, bool>(rota) : nav.push<bool>(rota));
  // Yerine açılan ekranda ilk bağlam artık ağaçta değildir; soruları gezgin başlatır.
  final ctx = yerine ? nav.context : context;
  if (coz == true && ctx.mounted) {
    final sorular = durum.banka.dersSorulari(durum.bolum, ders.kod, konu: anlatim.konu);
    if (sorular.isNotEmpty) {
      await calismayaBasla(
        ctx,
        baslik: ders.konular[anlatim.konu] ?? anlatim.baslik,
        sorular: durum.ilerleme.calismaSirasi(sorular, 50),
      );
    }
  }
}

/// Bütün konu anlatımları tek listede: arama, ders ders gruplama, okundu ve kilit durumu.
class AnlatimlarEkrani extends StatefulWidget {
  const AnlatimlarEkrani({super.key});

  @override
  State<AnlatimlarEkrani> createState() => _AnlatimlarEkraniState();
}

class _AnlatimlarEkraniState extends State<AnlatimlarEkrani> {
  final _arama = TextEditingController();
  String _sorgu = '';

  static String _sade(String s) => s
      .replaceAll('İ', 'i')
      .replaceAll('I', 'ı')
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('û', 'u');

  @override
  void dispose() {
    _arama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final r = Theme.of(context).colorScheme;
        final il = durum.ilerleme;
        final hepsi = tumAnlatimlar(durum);
        final okunan = hepsi.where((e) => il.okundu(e.anlatim.anahtar)).length;
        final q = _sade(_sorgu.trim());
        final suzulmus = q.isEmpty
            ? hepsi
            : hepsi
                  .where(
                    (e) =>
                        _sade(e.anlatim.baslik).contains(q) ||
                        _sade(e.ders.konular[e.anlatim.konu] ?? '').contains(q) ||
                        _sade(e.ders.gorunenAd(durum.bolum)).contains(q) ||
                        (q.length >= 4 && _sade(e.anlatim.metin).contains(q)),
                  )
                  .toList();
        final ogeler = <Widget>[];
        String? sonDers;
        for (final e in suzulmus) {
          if (e.ders.kod != sonDers) {
            sonDers = e.ders.kod;
            final dersteki = hepsi.where((x) => x.ders.kod == e.ders.kod);
            final dOkunan = dersteki.where((x) => il.okundu(x.anlatim.anahtar)).length;
            ogeler.add(
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 18, 4, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.ders.gorunenAd(durum.bolum),
                        style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: r.primary),
                      ),
                    ),
                    Text('$dOkunan/${dersteki.length} okundu', style: t.labelMedium),
                  ],
                ),
              ),
            );
          }
          ogeler.add(Padding(padding: const EdgeInsets.only(bottom: 8), child: AnlatimKarti(oge: e)));
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Konu anlatımları')),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Text(
                  '${hepsi.length} konu · $okunan okundu',
                  style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _arama,
                  onChanged: (s) => setState(() => _sorgu = s),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Konu ara (ör. amortisman, KDV, kıdem)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _sorgu.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Aramayı temizle',
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() {
                              _arama.clear();
                              _sorgu = '';
                            }),
                          ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
                    isDense: true,
                  ),
                ),
                if (suzulmus.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text('"$_sorgu" ile eşleşen konu yok.', textAlign: TextAlign.center),
                  ),
                ...ogeler,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tek bir anlatımın kartı: başlık, süre, okundu/kilit; dokununca anlatım açılır.
class AnlatimKarti extends StatelessWidget {
  final DersAnlatimi oge;
  final bool dersGoster;

  const AnlatimKarti({super.key, required this.oge, this.dersGoster = false});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final r = Theme.of(context).colorScheme;
    final a = oge.anlatim;
    final okundu = durum.ilerleme.okundu(a.anahtar);
    final acik = durum.anlatimAcik(oge.ders, a.konu);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
        leading: CircleAvatar(
          backgroundColor: okundu ? dogruRenk(context).withValues(alpha: 0.15) : r.primaryContainer,
          child: Icon(
            !acik ? Icons.lock_outline_rounded : (okundu ? Icons.check_rounded : Icons.menu_book_rounded),
            color: okundu ? dogruRenk(context) : r.onPrimaryContainer,
          ),
        ),
        title: Text(oge.ders.konular[a.konu] ?? a.baslik),
        subtitle: Text(
          [
            if (dersGoster) oge.ders.gorunenAd(durum.bolum),
            '${a.okumaDk} dk',
            if (!acik) 'tam erişimde' else if (okundu) 'okundu',
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => anlatimAc(context, oge.ders, a),
      ),
    );
  }
}
