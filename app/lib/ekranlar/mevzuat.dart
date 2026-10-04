import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bilesenler/duzen.dart';
import '../mantik/mevzuat.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'calisma.dart';

/// Sorularda atıf yapılan maddelerin bulunduğu "Mevzuat" sekmesi: kaynak → madde listesi ve arama.
class MevzuatEkrani extends StatefulWidget {
  const MevzuatEkrani({super.key});

  @override
  State<MevzuatEkrani> createState() => _MevzuatEkraniState();
}

class _MevzuatEkraniState extends State<MevzuatEkrani> {
  final _alan = TextEditingController();
  String _sorgu = '';

  @override
  void dispose() {
    _alan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final bulunan = mevzuatAra(durum.banka.mevzuat, _sorgu);
    final gruplar = mevzuatGrupla(bulunan);
    final aramada = _sorgu.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Mevzuat')),
      body: Govde(
        child: durum.banka.mevzuat.isEmpty
            ? const Center(
                child: Padding(padding: EdgeInsets.all(24), child: Text('Bu pakette mevzuat bölümü yok.')),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  TextField(
                    controller: _alan,
                    onChanged: (v) => setState(() => _sorgu = v),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Kanun, madde veya metin ara',
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: aramada
                          ? IconButton(
                              tooltip: 'Aramayı temizle',
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _alan.clear();
                                setState(() => _sorgu = '');
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yalnızca sorularımızın dayandığı maddeler yer alır. ${mevzuatTarihNotu(durum.banka.mevzuatTarihi)}',
                    style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                  ),
                  if (bulunan.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: Text('Sonuç yok.')),
                    ),
                  for (final MapEntry(key: tur, value: kaynaklar) in gruplar.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 4),
                      child: Text(
                        turBasliklari[tur] ?? tur,
                        style: t.titleSmall?.copyWith(color: r.primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                    for (final MapEntry(key: ad, value: maddeler) in kaynaklar.entries)
                      _KaynakKarti(
                        key: ValueKey('$ad|$aramada'),
                        ad: ad,
                        maddeler: maddeler,
                        acik: aramada && bulunan.length <= 12,
                      ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _KaynakKarti extends StatelessWidget {
  final String ad;
  final List<MevzuatMaddesi> maddeler;
  final bool acik;

  const _KaynakKarti({super.key, required this.ad, required this.maddeler, required this.acik});

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final tam = maddeler.where((m) => m.tamMetin != null).length;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: acik,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(ad, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${maddeler.length} madde${tam > 0 ? ' · tam metin' : ' · alıntılar'}',
          style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
        ),
        children: [
          for (final m in maddeler)
            ListTile(
              title: Text(m.baslik == null ? m.madde : '${m.madde} · ${m.baslik}'),
              subtitle: Text('${m.soruIdler.length} soru', style: t.bodySmall?.copyWith(color: r.onSurfaceVariant)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MevzuatMaddeEkrani(madde: m))),
            ),
        ],
      ),
    );
  }
}

/// Bir maddenin tam metni (kanun) ya da sorulardaki alıntıları; sorulardan çözme ve resmî kaynağa gitme düğmeleri.
class MevzuatMaddeEkrani extends StatelessWidget {
  final MevzuatMaddesi madde;

  const MevzuatMaddeEkrani({super.key, required this.madde});

  Future<void> _resmiAc(BuildContext context) async {
    final mesaj = ScaffoldMessenger.of(context);
    var acildi = false;
    try {
      acildi = await launchUrl(Uri.parse(madde.mevzuatGovUrl!), mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!acildi) mesaj.showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final sorular = [
      for (final id in madde.soruIdler)
        if (durum.banka.soru(id) case final s? when s.bolumde(durum.bolum)) s,
    ];
    final tam = madde.tamMetin;
    final vurgu = tam == null ? null : alintiAraliklari(tam, [for (final a in madde.alintilar) a.metin]);
    final gosterilecekAlintilar = [
      for (var i = 0; i < madde.alintilar.length; i++)
        if (tam == null || vurgu!.bulunamayan.contains(i)) madde.alintilar[i],
    ].where((a) => a.metin.isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(title: Text(madde.madde)),
      body: Govde(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(madde.kaynak, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            if (madde.baslik != null) ...[
              const SizedBox(height: 2),
              Text(madde.baslik!, style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant)),
            ],
            const SizedBox(height: 12),
            if (sorular.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Bu maddeden ${sorular.length} soru çöz'),
                  onPressed: () =>
                      calismayaBasla(context, baslik: madde.madde, sorular: durum.ilerleme.calismaSirasi(sorular, 50)),
                ),
              ),
            if (madde.mevzuatGovUrl != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("mevzuat.gov.tr'de aç"),
                  onPressed: () => _resmiAc(context),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (tam != null) ...[
              SelectableText.rich(_vurguluMetin(context, tam, vurgu!.araliklar)),
              if (vurgu.araliklar.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'İşaretli kısımlar sorularımızda alıntılanmıştır.',
                    style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                  ),
                ),
            ] else
              Card(
                color: r.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Bu kaynağın tam metni uygulamada yer almaz; yalnızca sorularda kullanılan kısa alıntılar gösterilir.',
                    style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
                  ),
                ),
              ),
            if (gosterilecekAlintilar.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Sorulardaki alıntılar', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              for (final a in gosterilecekAlintilar)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.atif,
                            style: t.labelMedium?.copyWith(color: r.primary, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          SelectableText('“${a.metin}”'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            Text(mevzuatTarihNotu(durum.banka.mevzuatTarihi), style: t.bodySmall?.copyWith(color: r.onSurfaceVariant)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  TextSpan _vurguluMetin(BuildContext context, String metin, List<(int, int)> araliklar) {
    final r = Theme.of(context).colorScheme;
    final temel = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5);
    final isaret = temel?.copyWith(backgroundColor: r.tertiaryContainer, color: r.onTertiaryContainer);
    final parcalar = <TextSpan>[];
    var son = 0;
    for (final (b, e) in araliklar) {
      if (b > son) parcalar.add(TextSpan(text: metin.substring(son, b)));
      parcalar.add(TextSpan(text: metin.substring(b, e), style: isaret));
      son = e;
    }
    if (son < metin.length) parcalar.add(TextSpan(text: metin.substring(son)));
    return TextSpan(style: temel, children: parcalar);
  }
}
