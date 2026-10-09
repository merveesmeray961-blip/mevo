import 'dart:async';

import 'package:flutter/material.dart';

import '../bilesenler/soru_gorunumu.dart';
import '../mantik/deneme.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'calisma.dart';
import 'hesap_makinesi.dart';
import 'notlar.dart';
import '../bilesenler/duzen.dart';

class DenemeEkrani extends StatefulWidget {
  final DenemePlani plan;

  const DenemeEkrani({super.key, required this.plan});

  @override
  State<DenemeEkrani> createState() => _DenemeEkraniState();
}

class _DenemeEkraniState extends State<DenemeEkrani> {
  final Map<String, String> _cevaplar = {};
  final Set<String> _isaretli = {};
  final _saat = Stopwatch()..start();
  late final Timer _zamanlayici;
  int _sira = 0;
  bool _bitti = false;

  List<Soru> get _sorular => widget.plan.sorular;
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
    super.dispose();
  }

  void _sec(String h) {
    final id = _sorular[_sira].id;
    setState(() => _cevaplar[id] == h ? _cevaplar.remove(id) : _cevaplar[id] = h);
  }

  void _git(int i) => setState(() => _sira = i.clamp(0, _sorular.length - 1));

  Future<void> _bitirSor() async {
    final bos = _sorular.length - _cevaplar.length;
    final tamam = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sınavı bitir'),
        content: Text(
          bos > 0 ? '$bos soruyu boş bıraktın. Yine de bitirmek istiyor musun?' : 'Tüm soruları cevapladın.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Devam et')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Bitir')),
        ],
      ),
    );
    if (tamam == true) await _bitir();
  }

  Future<void> _bitir({bool sureDoldu = false}) async {
    if (_bitti) return;
    _bitti = true;
    _zamanlayici.cancel();
    _saat.stop();
    final durum = Kapsam.of(context);
    final sonuc = denemePuanla(
      durum.banka,
      widget.plan,
      Map.of(_cevaplar),
      _saat.elapsed.inSeconds.clamp(0, widget.plan.sureSn),
    );
    for (final s in _sorular) {
      final c = _cevaplar[s.id];
      if (c != null) await durum.ilerleme.cevapla(s, c, gunlugeSay: false);
    }
    await durum.ilerleme.denemeEkle(sonuc.kayit(durum.ilerleme.simdi));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DenemeSonucEkrani(sonuc: sonuc, sureDoldu: sureDoldu),
      ),
    );
  }

  Future<bool> _cikisOnayi() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Denemeden çıkılsın mı?'),
          content: const Text('Cevapların kaydedilmez.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Devam et')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Çık')),
          ],
        ),
      ) ??
      false;

  void _soruListesi() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final r = Theme.of(context).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Renklerin anlamı: ızgarayı ilk kez gören aday neyin ne olduğunu bilsin.
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      _Lejant(dolgu: r.primaryContainer, kenar: r.outlineVariant, metin: 'Cevaplandı'),
                      _Lejant(kenar: r.tertiary, kalin: true, metin: 'İşaretli'),
                      _Lejant(kenar: r.primary, kalin: true, metin: 'Şu anki soru'),
                      _Lejant(kenar: r.outlineVariant, metin: 'Boş'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < _sorular.length; i++)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            _git(i);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _cevaplar.containsKey(_sorular[i].id) ? r.primaryContainer : null,
                              border: Border.all(
                                color: i == _sira
                                    ? r.primary
                                    : (_isaretli.contains(_sorular[i].id) ? r.tertiary : r.outlineVariant),
                                width: i == _sira || _isaretli.contains(_sorular[i].id) ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${i + 1}'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final soru = _sorular[_sira];
    final r = Theme.of(context).colorScheme;
    final azKaldi = _kalanSn < 300;
    final ders = durum.banka.dersler[soru.ders];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _cikisOnayi() && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Çık',
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _cikisOnayi() && context.mounted) Navigator.of(context).pop();
            },
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: azKaldi ? yanlisRenk(context) : null),
                const SizedBox(width: 6),
                Text(
                  sureYaz(_kalanSn),
                  style: TextStyle(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: azKaldi ? yanlisRenk(context) : null,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            NotDugmesi(soru: soru),
            IconButton(
              tooltip: 'Sonra dönmek için işaretle',
              icon: Icon(_isaretli.contains(soru.id) ? Icons.flag : Icons.outlined_flag),
              onPressed: () =>
                  setState(() => _isaretli.contains(soru.id) ? _isaretli.remove(soru.id) : _isaretli.add(soru.id)),
            ),
            TextButton(onPressed: _bitirSor, child: const Text('Bitir')),
          ],
        ),
        body: Govde(
          child: ListView(
            key: ValueKey(soru.id),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SoruGorunumu(
                soru: soru,
                secilen: _cevaplar[soru.id],
                onSec: _sec,
                ustBilgi: ders?.gorunenAd(widget.plan.bolum),
              ),
              if (_cevaplar.containsKey(soru.id))
                Text(
                  'Cevabı kaldırmak için seçili şıkka tekrar dokun.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: r.onSurfaceVariant),
                ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: OrtalaGenislik(
            icerikYuksekligi: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  IconButton.outlined(
                    onPressed: _sira == 0 ? null : () => _git(_sira - 1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _soruListesi,
                      icon: const Icon(Icons.grid_view_rounded),
                      label: Text('${_sira + 1}/${_sorular.length} · ${_cevaplar.length} cevaplandı'),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: _sira + 1 >= _sorular.length ? _bitirSor : () => _git(_sira + 1),
                    icon: Icon(_sira + 1 >= _sorular.length ? Icons.check : Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DenemeSonucEkrani extends StatelessWidget {
  final DenemeSonucu sonuc;
  final bool sureDoldu;

  const DenemeSonucEkrani({super.key, required this.sonuc, this.sureDoldu = false});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final plan = sonuc.plan;
    final f = durum.banka.formatlar[plan.bolum]!;
    final yet = plan.bolum == 'YET';

    return Scaffold(
      appBar: AppBar(title: const Text('Deneme sonucu')),
      body: Govde(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (sureDoldu)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Süre doldu; sınav otomatik bitirildi.', style: t.bodyMedium?.copyWith(color: r.tertiary)),
              ),
            Card(
              color: r.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      plan.baslik,
                      style: t.titleMedium?.copyWith(color: r.onPrimaryContainer),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      yet ? sayiYaz(sonuc.puan, basamak: 2) : '%${sonuc.puan.round()}',
                      style: t.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: r.onPrimaryContainer),
                    ),
                    Text(
                      yet ? (plan.dersler.length > 1 ? 'ortalama puan' : 'ders puanı') : 'doğru oranı',
                      style: t.labelLarge?.copyWith(color: r.onPrimaryContainer),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${sonuc.dogru} doğru · ${sonuc.yanlis} yanlış · ${sonuc.bos} boş · ${sureYaz(sonuc.kullanilanSn)}',
                      style: t.bodyMedium?.copyWith(color: r.onPrimaryContainer),
                    ),
                    if (sonuc.gecti != null) ...[
                      const SizedBox(height: 12),
                      Chip(
                        avatar: Icon(
                          sonuc.gecti! ? Icons.check_circle : Icons.info_outline,
                          color: sonuc.gecti! ? dogruRenk(context) : yanlisRenk(context),
                        ),
                        label: Text(
                          sonuc.gecti!
                              ? (plan.dersler.length > 1 ? 'Barajları geçtin' : 'Ders barajını (${f.dersMin}) geçtin')
                              : (plan.dersler.length > 1
                                    ? 'Baraj altı: her ders ≥${f.dersMin}, ortalama ≥${f.ortalamaMin}'
                                    : 'Ders barajı ${f.dersMin}'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              yet
                  ? 'Puan: (doğru − yanlış × ${sayiYaz(f.yanlisCezasi, basamak: 2)}) × 100 / soru sayısı. Gerçek sınavda her ders ≥${f.dersMin} '
                        've 8 ders ile tezkiye notunun ortalaması ≥${f.ortalamaMin} olmalıdır.'
                  : 'SGS bağıl değerlendirilir: puanın, o sınava girenlerin ortalamasına göre hesaplanır; sabit bir doğru sayısı barajı yoktur.',
              style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
            ),
            if (plan.dersler.length > 1) ...[
              const SizedBox(height: 16),
              Text('Ders bazında', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    for (final d in plan.dersler)
                      ListTile(
                        dense: true,
                        title: Text(durum.banka.dersler[d]!.gorunenAd(plan.bolum)),
                        subtitle: Text(
                          '${sonuc.dersler[d]!.dogru} D · ${sonuc.dersler[d]!.yanlis} Y · ${sonuc.dersler[d]!.bos} B',
                        ),
                        trailing: Text(
                          yet ? sayiYaz(sonuc.dersler[d]!.puan, basamak: 2) : '%${sonuc.dersler[d]!.puan.round()}',
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: yet && sonuc.dersler[d]!.puan < f.dersMin! ? yanlisRenk(context) : null,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text('Cevaplar ve açıklamalar', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < plan.sorular.length; i++)
                  _SonucKutusu(
                    no: i + 1,
                    durum: sonuc.cevaplar[plan.sorular[i].id] == null
                        ? null
                        : sonuc.cevaplar[plan.sorular[i].id] == plan.sorular[i].dogru,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DenemeInceleme(sonuc: sonuc, baslangic: i),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Kapat')),
          ],
        ),
      ),
    );
  }
}

class _SonucKutusu extends StatelessWidget {
  final int no;
  final bool? durum;
  final VoidCallback onTap;

  const _SonucKutusu({required this.no, required this.durum, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final renk = durum == null
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : (durum! ? dogruRenk(context) : yanlisRenk(context));
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: renk.withValues(alpha: 0.14),
          border: Border.all(color: renk),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$no',
          style: TextStyle(color: renk, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class DenemeInceleme extends StatefulWidget {
  final DenemeSonucu sonuc;
  final int baslangic;

  const DenemeInceleme({super.key, required this.sonuc, required this.baslangic});

  @override
  State<DenemeInceleme> createState() => _DenemeIncelemeState();
}

class _DenemeIncelemeState extends State<DenemeInceleme> {
  late final PageController _sayfa = PageController(initialPage: widget.baslangic);
  late int _sira = widget.baslangic;

  @override
  void dispose() {
    _sayfa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sorular = widget.sonuc.plan.sorular;
    final durum = Kapsam.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${_sira + 1}/${sorular.length}'),
        actions: [
          IconButton(
            tooltip: 'Hesap makinesi',
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () => hesapMakinesiAc(context),
          ),
          NotDugmesi(soru: sorular[_sira]),
          IconButton(
            tooltip: 'Hata bildir',
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => hataBildir(context, sorular[_sira]),
          ),
        ],
      ),
      body: Govde(
        child: PageView.builder(
          controller: _sayfa,
          itemCount: sorular.length,
          onPageChanged: (i) => setState(() => _sira = i),
          itemBuilder: (context, i) {
            final s = sorular[i];
            final secilen = widget.sonuc.cevaplar[s.id];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                SoruGorunumu(
                  soru: s,
                  secilen: secilen,
                  cevapGoster: true,
                  ustBilgi:
                      '${durum.banka.dersler[s.ders]?.gorunenAd(widget.sonuc.plan.bolum) ?? s.ders} · ${zorlukAdi[s.zorluk]}',
                ),
                const SizedBox(height: 8),
                AciklamaKarti(soru: s, secilen: secilen),
                NotKarti(soru: s),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Deneme soru ızgarasındaki kutu türlerinin küçük açıklaması.
class _Lejant extends StatelessWidget {
  final Color? dolgu;
  final Color kenar;
  final bool kalin;
  final String metin;

  const _Lejant({this.dolgu, required this.kenar, this.kalin = false, required this.metin});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: dolgu,
          border: Border.all(color: kenar, width: kalin ? 2 : 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 6),
      Text(metin, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}
