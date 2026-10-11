import 'dart:async';

import 'package:flutter/material.dart';

import '../bilesenler/anlatim_gorunumu.dart';
import '../bilesenler/duzen.dart';
import '../mantik/klasik.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'odeme.dart';

/// Klasik soruları tek tek çalışma: soruyu oku, cevabını yaz, sonra örnek çözümü ve puanlama ölçütünü aç.
class KlasikCalismaEkrani extends StatefulWidget {
  final String baslik;
  final List<KlasikSoru> sorular;

  const KlasikCalismaEkrani({super.key, required this.baslik, required this.sorular});

  @override
  State<KlasikCalismaEkrani> createState() => _KlasikCalismaEkraniState();
}

class _KlasikCalismaEkraniState extends State<KlasikCalismaEkrani> {
  final Map<String, TextEditingController> _cevaplar = {};
  final Set<String> _acik = {};
  int _sira = 0;

  @override
  void dispose() {
    for (final c in _cevaplar.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = widget.sorular[_sira];
    final acik = _acik.contains(k.id);
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.baslik} · ${_sira + 1}/${widget.sorular.length}')),
      body: Govde(
        child: ListView(
          key: ValueKey(k.id),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            KlasikSoruBasligi(soru: k),
            const SizedBox(height: 12),
            AnlatimGorunumu(k.soru),
            const SizedBox(height: 16),
            TextField(
              controller: _cevaplar.putIfAbsent(k.id, TextEditingController.new),
              minLines: 4,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Cevabın (isteğe bağlı)',
                hintText: 'Kâğıda yazıyorsan burayı boş bırakabilirsin.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (!acik)
              FilledButton.icon(
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Örnek çözümü göster'),
                onPressed: () => setState(() => _acik.add(k.id)),
              )
            else ...[
              Text('Örnek çözüm', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              AnlatimGorunumu(k.cozum),
              const SizedBox(height: 16),
              PuanlamaTablosu(soru: k),
              KlasikKaynaklar(soru: k),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _sira == 0 ? null : () => setState(() => _sira--),
                    child: const Text('Önceki'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _sira == widget.sorular.length - 1 ? null : () => setState(() => _sira++),
                    child: const Text('Sonraki'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Soru başlığı: puan, süre ve zorluk.
class KlasikSoruBasligi extends StatelessWidget {
  final KlasikSoru soru;

  const KlasikSoruBasligi({super.key, required this.soru});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final konu = durum.banka.dersler[soru.ders]?.konular[soru.konu] ?? soru.konu;
    return Text(
      '$konu · ${soru.puan} puan · ~${soru.sureDk} dk · ${zorlukAdi[soru.zorluk]}',
      style: t.labelLarge?.copyWith(color: r.onSurfaceVariant),
    );
  }
}

/// Puanlama ölçütünü salt okunur tablo olarak gösterir.
class PuanlamaTablosu extends StatelessWidget {
  final KlasikSoru soru;

  const PuanlamaTablosu({super.key, required this.soru});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Puanlama', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            for (final p in soru.puanlama)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(p.olcut, style: t.bodyMedium)),
                    const SizedBox(width: 12),
                    Text(sayiYaz(p.puan), style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KlasikKaynaklar extends StatelessWidget {
  final KlasikSoru soru;

  const KlasikKaynaklar({super.key, required this.soru});

  @override
  Widget build(BuildContext context) {
    if (soru.kaynaklar.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Dayanak: ${soru.kaynaklar.map((k) => k.madde == '-' ? k.mevzuat : '${k.mevzuat} ${k.madde}').join(' · ')}',
        style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
      ),
    );
  }
}

Future<void> klasikDenemeyeBasla(BuildContext context, KlasikDenemePlani plan) async {
  final durum = Kapsam.of(context);
  if (!durum.denemeHakkiVar) {
    await odemeEkraniAc(context, neden: 'Ücretsiz deneme hakkını kullandın.');
    if (!context.mounted || !durum.denemeHakkiVar) return;
  }
  final f = durum.banka.formatlar['YMM'];
  final basla = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(plan.baslik),
      content: Text(
        [
          '${plan.sorular.length} klasik soru, ${plan.hamPuan} puan, ${plan.sureSn ~/ 60} dakika.',
          'Cevaplarını kâğıda ya da her sorunun altındaki alana yaz.',
          'Sınav bitince örnek çözümleri açıp her soruyu puanlama ölçütüne göre kendin puanlarsın.',
          if (f?.dersMin != null)
            'Gerçek sınavda her dersten en az ${f!.dersMin}, ortalama en az ${f.ortalamaMin} gerekir.',
        ].join('\n\n'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
        FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Başla')),
      ],
    ),
  );
  if (basla == true && context.mounted) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => KlasikDenemeEkrani(plan: plan)));
  }
}

/// Süreli klasik deneme: sorular sırayla, cevap alanlarıyla; süre dolunca ya da bitirince puanlamaya geçilir.
class KlasikDenemeEkrani extends StatefulWidget {
  final KlasikDenemePlani plan;

  const KlasikDenemeEkrani({super.key, required this.plan});

  @override
  State<KlasikDenemeEkrani> createState() => _KlasikDenemeEkraniState();
}

class _KlasikDenemeEkraniState extends State<KlasikDenemeEkrani> {
  late final Map<String, TextEditingController> _cevaplar = {
    for (final k in widget.plan.sorular) k.id: TextEditingController(),
  };
  final _saat = Stopwatch()..start();
  late final Timer _zamanlayici;
  int _sira = 0;
  bool _bitti = false;

  int get _kalanSn => (widget.plan.sureSn - _saat.elapsed.inSeconds).clamp(0, widget.plan.sureSn);

  @override
  void initState() {
    super.initState();
    _zamanlayici = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_kalanSn == 0) {
        _bitir(sureDoldu: true);
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _zamanlayici.cancel();
    for (final c in _cevaplar.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _bitir({bool sureDoldu = false}) {
    if (_bitti) return;
    _bitti = true;
    _zamanlayici.cancel();
    _saat.stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => KlasikPuanlamaEkrani(
          plan: widget.plan,
          cevaplar: {for (final e in _cevaplar.entries) e.key: e.value.text},
          kullanilanSn: _saat.elapsed.inSeconds.clamp(0, widget.plan.sureSn),
          sureDoldu: sureDoldu,
        ),
      ),
    );
  }

  Future<bool> _onay(String baslik, String metin, String evet) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(baslik),
          content: Text(metin),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Devam et')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(evet)),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final k = widget.plan.sorular[_sira];
    final son = _sira == widget.plan.sorular.length - 1;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _onay('Denemeden çıkılsın mı?', 'Cevapların kaydedilmez.', 'Çık') && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, color: _kalanSn < 300 ? yanlisRenk(context) : null),
              const SizedBox(width: 6),
              Text(sureYaz(_kalanSn)),
              const SizedBox(width: 12),
              Text('${_sira + 1}/${widget.plan.sorular.length}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await _onay('Sınavı bitir', 'Puanlamaya geçilsin mi?', 'Bitir')) _bitir();
              },
              child: const Text('Bitir'),
            ),
          ],
        ),
        body: Govde(
          child: ListView(
            key: ValueKey(k.id),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              KlasikSoruBasligi(soru: k),
              const SizedBox(height: 12),
              AnlatimGorunumu(k.soru),
              const SizedBox(height: 16),
              TextField(
                controller: _cevaplar[k.id],
                minLines: 6,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Cevabın', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sira == 0 ? null : () => setState(() => _sira--),
                      child: const Text('Önceki'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: son
                          ? () async {
                              if (await _onay('Sınavı bitir', 'Puanlamaya geçilsin mi?', 'Bitir')) _bitir();
                            }
                          : () => setState(() => _sira++),
                      child: Text(son ? 'Bitir ve puanla' : 'Sonraki'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Deneme sonrası öz puanlama: her soruda örnek çözüm ve ölçütler; adayın işaretlediği ölçütlerin puanı toplanır.
/// [verilen] doluysa (geçmiş deneme) ekran salt okunurdur.
class KlasikPuanlamaEkrani extends StatefulWidget {
  final KlasikDenemePlani plan;
  final Map<String, String> cevaplar;
  final int kullanilanSn;
  final bool sureDoldu;
  final Map<String, double>? verilen;

  const KlasikPuanlamaEkrani({
    super.key,
    required this.plan,
    this.cevaplar = const {},
    this.kullanilanSn = 0,
    this.sureDoldu = false,
    this.verilen,
  });

  @override
  State<KlasikPuanlamaEkrani> createState() => _KlasikPuanlamaEkraniState();
}

class _KlasikPuanlamaEkraniState extends State<KlasikPuanlamaEkrani> {
  /// Soru kimliği → işaretlenen ölçüt sıraları.
  final Map<String, Set<int>> _isaret = {};
  late bool _kaydedildi = widget.verilen != null;

  Map<String, double> get _puanlar =>
      widget.verilen ??
      {
        for (final k in widget.plan.sorular)
          k.id: [for (final i in _isaret[k.id] ?? const <int>{}) k.puanlama[i].puan].fold(0.0, (a, b) => a + b),
      };

  Future<void> _kaydet() async {
    final durum = Kapsam.of(context);
    final f = durum.banka.formatlar['YMM'];
    await durum.ilerleme.denemeEkle(
      klasikKayit(widget.plan, _puanlar, widget.kullanilanSn, durum.ilerleme.simdi, dersMin: f?.dersMin ?? 50),
    );
    if (mounted) setState(() => _kaydedildi = true);
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final f = durum.banka.formatlar['YMM'];
    final dersMin = f?.dersMin ?? 50;
    final puan = klasikDersPuani(widget.plan, _puanlar);
    return PopScope(
      canPop: _kaydedildi,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final cik = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Puan kaydedilmedi'),
            content: const Text('Puanlamayı kaydetmeden çıkarsan bu deneme geçmişe eklenmez.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Devam et')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Çık')),
            ],
          ),
        );
        if (cik == true && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.verilen == null ? 'Kendini puanla' : 'Deneme sonucu')),
        body: Govde(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (widget.sureDoldu)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('Süre doldu; sınav bitirildi.', style: t.bodyMedium?.copyWith(color: r.tertiary)),
                ),
              Card(
                color: r.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        widget.plan.baslik,
                        style: t.titleMedium?.copyWith(color: r.onPrimaryContainer),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sayiYaz(puan),
                        style: t.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: r.onPrimaryContainer),
                      ),
                      Text('100 üzerinden ders puanı', style: t.labelLarge?.copyWith(color: r.onPrimaryContainer)),
                      const SizedBox(height: 6),
                      Text(
                        puan >= dersMin ? 'Ders barajını ($dersMin) geçti' : 'Ders barajının ($dersMin) altında',
                        style: t.titleSmall?.copyWith(
                          color: puan >= dersMin ? dogruRenk(context) : yanlisRenk(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.verilen == null) ...[
                const SizedBox(height: 12),
                Text(
                  'Her sorunun örnek çözümünü kendi cevabınla karşılaştır; cevabının karşıladığı ölçütleri işaretle.',
                  style: t.bodyMedium,
                ),
              ],
              for (final (i, k) in widget.plan.sorular.indexed) ...[
                const SizedBox(height: 16),
                Card(
                  child: ExpansionTile(
                    initiallyExpanded: i == 0,
                    shape: const Border(),
                    title: Text('${i + 1}. soru · ${sayiYaz(_puanlar[k.id] ?? 0)}/${k.puan} puan'),
                    subtitle: KlasikSoruBasligi(soru: k),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnlatimGorunumu(k.soru),
                      if ((widget.cevaplar[k.id] ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('Cevabın', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(widget.cevaplar[k.id]!, style: t.bodyMedium),
                      ],
                      const SizedBox(height: 12),
                      Text('Örnek çözüm', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      AnlatimGorunumu(k.cozum),
                      const SizedBox(height: 12),
                      if (widget.verilen != null)
                        PuanlamaTablosu(soru: k)
                      else ...[
                        Text('Puanlama', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        for (final (j, p) in k.puanlama.indexed)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isaret[k.id]?.contains(j) ?? false,
                            onChanged: _kaydedildi
                                ? null
                                : (v) => setState(() {
                                    final s = _isaret.putIfAbsent(k.id, () => {});
                                    v == true ? s.add(j) : s.remove(j);
                                  }),
                            title: Text(p.olcut),
                            secondary: Text(sayiYaz(p.puan), style: t.titleSmall),
                          ),
                      ],
                      KlasikKaynaklar(soru: k),
                    ],
                  ),
                ),
              ],
              if (widget.verilen == null) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  icon: Icon(_kaydedildi ? Icons.check : Icons.save_outlined),
                  label: Text(_kaydedildi ? 'Kaydedildi' : 'Puanı kaydet'),
                  onPressed: _kaydedildi ? null : _kaydet,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
