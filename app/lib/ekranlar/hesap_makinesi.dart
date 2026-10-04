import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mantik/hesap.dart';

/// Hesap makinesini alttan açılan, sürüklenip kapatılabilen bir sayfada gösterir.
/// Gerçek SMMM sınavlarında hesap makinesi yasak olduğu için deneme ekranında (DenemeEkrani) sunulmaz.
Future<void> hesapMakinesiAc(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  // Geniş ekranda sayfa 420 dp ile sınırlanır ve ortalanır.
  constraints: const BoxConstraints(maxWidth: 420),
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
  builder: (_) => const HesapTablosu(),
);

typedef _Kayit = ({String ifade, String sonuc, String ham});

/// Son 5 sonuç; yalnızca uygulama oturumu boyunca tutulur.
final List<_Kayit> _gecmis = [];

@visibleForTesting
void hesapGecmisiniTemizle() => _gecmis.clear();

const _tusEtiketi = {
  'C': 'Temizle',
  '⌫': 'Geri sil',
  '÷': 'Böl',
  '×': 'Çarp',
  '−': 'Çıkar',
  '+': 'Topla',
  ',': 'Virgül',
  '%': 'Yüzde',
  '(': 'Parantez aç',
  ')': 'Parantez kapat',
  '±': 'Eksi artı değiştir',
  '=': 'Eşittir',
};

const _satirlar = [
  ['C', '(', ')', '⌫'],
  ['7', '8', '9', '÷'],
  ['4', '5', '6', '×'],
  ['1', '2', '3', '−'],
  ['0', ',', '%', '+'],
];

class HesapTablosu extends StatefulWidget {
  const HesapTablosu({super.key});

  @override
  State<HesapTablosu> createState() => _HesapTablosuState();
}

class _HesapTablosuState extends State<HesapTablosu> {
  String _ifade = '';
  bool _bitti = false;
  bool _kopyalandi = false;

  void _tus(String t) {
    setState(() {
      _kopyalandi = false;
      // "=" sonrası rakam, virgül ya da parantez yeni bir hesap başlatır; işlem tuşları sonuca devam eder.
      if (_bitti && (t == ',' || t == '(' || RegExp(r'\d').hasMatch(t))) _ifade = '';
      _bitti = false;
      _ifade = Hesap.tusla(_ifade, t);
    });
  }

  void _esittir() {
    final s = Hesap.tamamla(_ifade);
    if (s.isEmpty) return;
    try {
      final d = Hesap.degerlendir(s);
      final ham = Hesap.bicimle(d, gruplu: false);
      setState(() {
        _kopyalandi = false;
        if (ham != s) {
          _gecmis.insert(0, (ifade: Hesap.goruntu(s), sonuc: Hesap.bicimle(d), ham: ham));
          if (_gecmis.length > 5) _gecmis.removeLast();
        }
        _ifade = ham.replaceFirst('-', '−');
        _bitti = true;
      });
    } on HesapHatasi {
      // Tanımsız ya da eksik ifade: önizleme zaten durumu gösteriyor.
    }
  }

  Future<void> _kopyala(String ham) async {
    await Clipboard.setData(ClipboardData(text: ham));
    if (mounted) setState(() => _kopyalandi = true);
  }

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final onizleme = _bitti ? null : Hesap.onizleme(_ifade);
    // Kopyalanacak sonuç: "=" sonrası ifadenin kendisi, aksi hâlde canlı önizleme.
    String? ham;
    if (_ifade.isNotEmpty) {
      try {
        ham = Hesap.bicimle(Hesap.degerlendir(Hesap.tamamla(_ifade)), gruplu: false);
      } on HesapHatasi {
        ham = null;
      }
    }
    final sonucYazisi = _bitti ? Hesap.goruntu(_ifade) : (onizleme ?? '');

    // Tuşlar sabit boyutlu kalsın; yazı ölçeği büyüdüğünde sayfa taşmasın.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Hesap makinesi', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (_gecmis.isNotEmpty) ...[
                SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < _gecmis.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          ActionChip(
                            key: Key('hesap_gecmis_$i'),
                            label: Text('${_gecmis[i].ifade} = ${_gecmis[i].sonuc}'),
                            tooltip: 'Sonucu kullan',
                            onPressed: () => setState(() {
                              _kopyalandi = false;
                              _ifade = _gecmis[i].ham.replaceFirst('-', '−');
                              _bitti = true;
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(color: r.surfaceContainerHighest, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _ifade.isEmpty ? '0' : Hesap.goruntu(_ifade),
                        key: const Key('hesap_ifade'),
                        style: t.headlineSmall?.copyWith(color: r.onSurfaceVariant),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 40),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Semantics(
                          liveRegion: true,
                          label: sonucYazisi.isEmpty ? null : 'Sonuç $sonucYazisi',
                          excludeSemantics: true,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              sonucYazisi,
                              key: const Key('hesap_sonuc'),
                              style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: r.onSurface),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (final satir in _satirlar) ...[
                Row(
                  children: [
                    for (final tus in satir) ...[
                      if (tus != satir.first) const SizedBox(width: 8),
                      Expanded(child: _Tus(tus, onTap: () => _tus(tus))),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Expanded(child: _Tus('±', onTap: () => _tus('±'))),
                  const SizedBox(width: 8),
                  Expanded(flex: 3, child: _Tus('=', onTap: _esittir)),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
                icon: Icon(_kopyalandi ? Icons.check : Icons.copy_outlined),
                label: Text(_kopyalandi ? 'Kopyalandı' : 'Kopyala'),
                onPressed: ham == null ? null : () => _kopyala(ham!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tus extends StatelessWidget {
  final String tus;
  final VoidCallback onTap;

  const _Tus(this.tus, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final (Color zemin, Color yazi) = switch (tus) {
      '=' => (r.primary, r.onPrimary),
      'C' => (r.errorContainer, r.onErrorContainer),
      '+' || '−' || '×' || '÷' => (r.primaryContainer, r.onPrimaryContainer),
      '(' || ')' || '%' || '±' || '⌫' => (r.secondaryContainer, r.onSecondaryContainer),
      _ => (r.surfaceContainerHighest, r.onSurface),
    };
    final etiket = _tusEtiketi[tus] ?? tus;
    return Semantics(
      button: true,
      label: etiket,
      excludeSemantics: true,
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: FilledButton(
          key: Key('tus:$tus'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 56),
            padding: EdgeInsets.zero,
            backgroundColor: zemin,
            foregroundColor: yazi,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: onTap,
          child: tus == '⌫'
              ? const Icon(Icons.backspace_outlined, size: 24)
              : Text(tus, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
