import 'dart:math';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../bilesenler/duzen.dart';
import '../mantik/pdf_foy.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'odeme.dart';

/// Yazdırılabilir çalışma föyü: ders/konu, soru türü, adet ve zorluk seçilir; PDF paylaşılır veya yazdırılır.
/// Tam erişim özelliğidir; ücretsiz kullanıcı ayarları görebilir, oluştururken ödeme ekranı açılır.
class PdfOlusturEkrani extends StatefulWidget {
  /// Ders ekranından açıldığında o ders seçili gelir.
  final String? ders;

  const PdfOlusturEkrani({super.key, this.ders});

  @override
  State<PdfOlusturEkrani> createState() => _PdfOlusturEkraniState();
}

enum _Tur { test, klasik, karisik }

class _PdfOlusturEkraniState extends State<PdfOlusturEkrani> {
  final Set<String> _dersler = {};
  final Set<String> _konular = {};
  _Tur _tur = _Tur.test;
  int _testAdet = 20;
  int _klasikAdet = 3;
  int? _zorluk;
  bool _karistir = true;
  bool _yanlislar = false;
  bool _cevapAnahtari = true;
  bool _cozumler = false;
  bool _yazmaAlani = true;
  bool _hazirlaniyor = false;
  bool _ilk = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ilk) {
      _ilk = false;
      final durum = Kapsam.of(context);
      final hepsi = durum.banka.bolumDersleri(durum.bolum).map((d) => d.kod);
      if (widget.ders != null && hepsi.contains(widget.ders)) {
        _dersler.add(widget.ders!);
      } else {
        _dersler.addAll(hepsi);
      }
      if (durum.bolum == 'YMM') _tur = _Tur.karisik;
    }
  }

  List<Soru> _testHavuzu(UygulamaDurumu d) {
    final havuz = [
      for (final ders in _dersler)
        for (final s in d.banka.dersSorulari(d.bolum, ders))
          if ((_konular.isEmpty || _konular.contains(s.konu)) && (_zorluk == null || s.zorluk == _zorluk)) s,
    ];
    return _yanlislar ? d.ilerleme.yanlislar(havuz) : havuz;
  }

  List<KlasikSoru> _klasikHavuzu(UygulamaDurumu d) => [
    for (final k in d.banka.klasikler)
      if (_dersler.contains(k.ders) &&
          (_konular.isEmpty || _konular.contains(k.konu)) &&
          (_zorluk == null || k.zorluk == _zorluk))
        k,
  ];

  List<T> _sec<T>(List<T> havuz, int adet) {
    final l = List<T>.of(havuz);
    if (_karistir) l.shuffle(Random());
    return l.take(adet).toList();
  }

  Future<void> _olustur({required bool yazdir}) async {
    final d = Kapsam.of(context);
    if (!d.abonelik.premium) {
      await odemeEkraniAc(context, neden: 'PDF çalışma föyü tam erişimle açılır.');
      if (!mounted || !d.abonelik.premium) return;
    }
    final klasikVar = d.bolum == 'YMM' && d.banka.klasikler.isNotEmpty;
    final testler = _tur == _Tur.klasik ? <Soru>[] : _sec(_testHavuzu(d), _testAdet);
    final klasikler = (!klasikVar || _tur == _Tur.test) ? <KlasikSoru>[] : _sec(_klasikHavuzu(d), _klasikAdet);
    if (testler.isEmpty && klasikler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seçimine uyan soru yok.')));
      return;
    }
    setState(() => _hazirlaniyor = true);
    try {
      final simdi = DateTime.now();
      final ayar = FoyAyari(
        baslik: '${d.urun.sinav} çalışma föyü',
        urunAdi: d.urun.ad,
        testler: testler,
        klasikler: klasikler,
        dersAdlari: {for (final x in d.banka.dersler.values) x.kod: x.gorunenAd(d.bolum)},
        cevapAnahtari: _cevapAnahtari,
        cozumler: _cevapAnahtari && _cozumler,
        yazmaAlani: _yazmaAlani,
        tarih: simdi,
      );
      final bayt = await foyUret(ayar);
      final ad = '${d.urun.kod}_foy_${simdi.year}${simdi.month.toString().padLeft(2, '0')}'
          '${simdi.day.toString().padLeft(2, '0')}_${simdi.hour}${simdi.minute.toString().padLeft(2, '0')}.pdf';
      if (yazdir) {
        await Printing.layoutPdf(onLayout: (_) async => bayt, name: ad);
      } else {
        await Printing.sharePdf(bytes: bayt, filename: ad);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF hazırlanamadı: $e')));
      }
    } finally {
      if (mounted) setState(() => _hazirlaniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = Kapsam.of(context);
    final renk = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final dersler = d.banka.bolumDersleri(d.bolum);
    final klasikVar = d.bolum == 'YMM' && d.banka.klasikler.isNotEmpty;
    final tekDers = _dersler.length == 1 ? d.banka.dersler[_dersler.first] : null;
    final testSay = _tur == _Tur.klasik ? 0 : _testHavuzu(d).length;
    final klasikSay = (!klasikVar || _tur == _Tur.test) ? 0 : _klasikHavuzu(d).length;

    Widget baslik(String s) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(s, style: t.titleSmall?.copyWith(color: renk.primary)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('PDF çalışma föyü')),
      body: Govde(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            Card(
              color: renk.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, size: 34, color: renk.onPrimaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Seçtiğin derslerden soru föyü hazırla; yazdır, kâğıt üzerinde çöz, cevap anahtarıyla kontrol et.'
                        '${d.abonelik.premium ? '' : '\nTam erişim özelliğidir.'}',
                        style: t.bodyMedium?.copyWith(color: renk.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            baslik('Dersler'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Tümü'),
                  selected: _dersler.length == dersler.length,
                  onSelected: (_) => setState(() {
                    _konular.clear();
                    if (_dersler.length == dersler.length) {
                      _dersler.clear();
                    } else {
                      _dersler.addAll(dersler.map((x) => x.kod));
                    }
                  }),
                ),
                for (final x in dersler)
                  FilterChip(
                    label: Text(x.gorunenAd(d.bolum)),
                    selected: _dersler.contains(x.kod),
                    onSelected: (v) => setState(() {
                      _konular.clear();
                      v ? _dersler.add(x.kod) : _dersler.remove(x.kod);
                    }),
                  ),
              ],
            ),
            if (tekDers != null) ...[
              baslik('Konular (seçmezsen hepsi)'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in tekDers.konular.entries)
                    FilterChip(
                      label: Text(e.value),
                      selected: _konular.contains(e.key),
                      onSelected: (v) => setState(() => v ? _konular.add(e.key) : _konular.remove(e.key)),
                    ),
                ],
              ),
            ],
            if (klasikVar) ...[
              baslik('Soru türü'),
              SegmentedButton<_Tur>(
                segments: const [
                  ButtonSegment(value: _Tur.test, label: Text('Test')),
                  ButtonSegment(value: _Tur.klasik, label: Text('Klasik')),
                  ButtonSegment(value: _Tur.karisik, label: Text('İkisi')),
                ],
                selected: {_tur},
                onSelectionChanged: (s) => setState(() => _tur = s.first),
                showSelectedIcon: false,
              ),
            ],
            if (_tur != _Tur.klasik) ...[
              baslik('Test sorusu sayısı: $_testAdet'),
              Slider(
                value: _testAdet.toDouble(),
                min: 5,
                max: 100,
                divisions: 19,
                label: '$_testAdet',
                onChanged: (v) => setState(() => _testAdet = v.round()),
              ),
            ],
            if (klasikVar && _tur != _Tur.test) ...[
              baslik('Klasik soru sayısı: $_klasikAdet'),
              Slider(
                value: _klasikAdet.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_klasikAdet',
                onChanged: (v) => setState(() => _klasikAdet = v.round()),
              ),
            ],
            baslik('Zorluk'),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Tümü')),
                ButtonSegment(value: 1, label: Text('Kolay')),
                ButtonSegment(value: 2, label: Text('Orta')),
                ButtonSegment(value: 3, label: Text('Zor')),
              ],
              selected: {_zorluk ?? 0},
              onSelectionChanged: (s) => setState(() => _zorluk = s.first == 0 ? null : s.first),
              showSelectedIcon: false,
            ),
            baslik('Föy ayarları'),
            if (_tur != _Tur.klasik)
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Yalnız yanlış yaptığım sorular'),
                subtitle: const Text('Yanlış defterindeki test soruları'),
                value: _yanlislar,
                onChanged: (v) => setState(() => _yanlislar = v),
              ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Soruları karıştır'),
              subtitle: const Text('Kapalıysa ders ve konu sırasıyla gelir'),
              value: _karistir,
              onChanged: (v) => setState(() => _karistir = v),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Cevap anahtarı'),
              subtitle: const Text('Ayrı sayfada, föyün sonunda'),
              value: _cevapAnahtari,
              onChanged: (v) => setState(() => _cevapAnahtari = v),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Çözümleri ekle'),
              subtitle: Text(klasikVar ? 'Açıklama, hesap adımları; klasikte örnek çözüm ve puanlama' : 'Açıklama ve hesap adımları'),
              value: _cevapAnahtari && _cozumler,
              onChanged: _cevapAnahtari ? (v) => setState(() => _cozumler = v) : null,
            ),
            if (klasikVar && _tur != _Tur.test)
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Klasik sorularda cevap alanı'),
                subtitle: const Text('Sorunun altına çizgili yazma alanı'),
                value: _yazmaAlani,
                onChanged: (v) => setState(() => _yazmaAlani = v),
              ),
            const SizedBox(height: 8),
            Text(
              [
                if (_tur != _Tur.klasik) 'Uygun test sorusu: $testSay',
                if (klasikVar && _tur != _Tur.test) 'uygun klasik soru: $klasikSay',
              ].join(' · '),
              style: t.bodySmall?.copyWith(color: renk.onSurfaceVariant),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _hazirlaniyor || _dersler.isEmpty ? null : () => _olustur(yazdir: true),
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Yazdır'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  key: const Key('pdf-olustur'),
                  onPressed: _hazirlaniyor || _dersler.isEmpty ? null : () => _olustur(yazdir: false),
                  icon: _hazirlaniyor
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(d.abonelik.premium ? Icons.picture_as_pdf_rounded : Icons.lock_outline),
                  label: Text(_hazirlaniyor ? 'Hazırlanıyor…' : 'PDF oluştur'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
