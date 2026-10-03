import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../bilesenler/soru_gorunumu.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'odeme.dart';
import '../bilesenler/duzen.dart';

/// Çalışma oturumu açar. Ücretsiz kullanıcının günlük hakkı bittiyse önce ödeme ekranı gösterilir.
Future<void> calismayaBasla(BuildContext context, {required String baslik, required List<Soru> sorular}) async {
  if (sorular.isEmpty) return;
  final durum = Kapsam.of(context);
  if (!durum.soruHakkiVar) {
    await odemeEkraniAc(context, neden: 'Bugünkü ücretsiz soru hakkını kullandın.');
    if (!context.mounted || !durum.soruHakkiVar) return;
  }
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CalismaEkrani(baslik: baslik, sorular: sorular),
    ),
  );
}

class CalismaEkrani extends StatefulWidget {
  final String baslik;
  final List<Soru> sorular;

  const CalismaEkrani({super.key, required this.baslik, required this.sorular});

  @override
  State<CalismaEkrani> createState() => _CalismaEkraniState();
}

class _CalismaEkraniState extends State<CalismaEkrani> {
  int _sira = 0;
  String? _secilen;
  final Map<String, String> _cevaplar = {};
  final _kaydirma = ScrollController();
  final _aciklamaAnahtari = GlobalKey();

  Soru get _soru => widget.sorular[_sira];
  bool get _cevaplandi => _cevaplar.containsKey(_soru.id);

  @override
  void dispose() {
    _kaydirma.dispose();
    super.dispose();
  }

  Future<void> _sec(String h) async {
    if (_cevaplandi) return;
    final durum = Kapsam.of(context);
    if (!durum.soruHakkiVar) {
      await odemeEkraniAc(context, neden: 'Bugünkü ücretsiz soru hakkını kullandın.');
      if (!mounted || !durum.soruHakkiVar) return;
    }
    setState(() {
      _secilen = h;
      _cevaplar[_soru.id] = h;
    });
    // Açıklamanın başı ekranın ortasına gelecek kadar kaydır; şıklar mümkün olduğunca ekranda kalır.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kutu = _aciklamaAnahtari.currentContext?.findRenderObject();
      if (kutu == null || !_kaydirma.hasClients) return;
      final p = _kaydirma.position;
      final ust = RenderAbstractViewport.of(kutu).getOffsetToReveal(kutu, 0).offset - p.viewportDimension * 0.45;
      if (ust > p.pixels) {
        _kaydirma.animateTo(
          ust.clamp(p.minScrollExtent, p.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    await durum.ilerleme.cevapla(_soru, h);
  }

  void _sonraki() {
    if (_sira + 1 >= widget.sorular.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CalismaOzeti(baslik: widget.baslik, sorular: widget.sorular, cevaplar: _cevaplar),
        ),
      );
      return;
    }
    setState(() {
      _sira++;
      _secilen = null;
    });
    _kaydirma.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final ders = durum.banka.dersler[_soru.ders];
    final konu = ders?.konular[_soru.konu] ?? _soru.konu;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.baslik} · ${_sira + 1}/${widget.sorular.length}'),
        actions: [
          ListenableBuilder(
            listenable: durum.ilerleme,
            builder: (context, _) {
              final isaretli = durum.ilerleme.durum(_soru.id)?.isaretli ?? false;
              return IconButton(
                tooltip: isaretli ? 'İşareti kaldır' : 'İşaretle',
                icon: Icon(isaretli ? Icons.bookmark : Icons.bookmark_outline),
                onPressed: () => durum.ilerleme.isaretle(_soru.id, !isaretli),
              );
            },
          ),
          IconButton(
            tooltip: 'Hata bildir',
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => hataBildir(context, _soru),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_sira + (_cevaplandi ? 1 : 0)) / widget.sorular.length),
        ),
      ),
      body: Govde(
        child: SingleChildScrollView(
          controller: _kaydirma,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SoruGorunumu(
                soru: _soru,
                secilen: _secilen,
                cevapGoster: _cevaplandi,
                onSec: _cevaplandi ? null : _sec,
                ustBilgi: '${ders?.gorunenAd(durum.bolum) ?? _soru.ders} · $konu · ${zorlukAdi[_soru.zorluk]}',
              ),
              if (_cevaplandi) ...[
                const SizedBox(height: 8),
                // Açıklamanın üst kısmı (sonuç satırı) görünür olsun diye anahtar kartın başına konur.
                AciklamaKarti(key: _aciklamaAnahtari, soru: _soru, secilen: _cevaplar[_soru.id]),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _cevaplandi
          ? SafeArea(
              child: OrtalaGenislik(
                icerikYuksekligi: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: FilledButton(
                    onPressed: _sonraki,
                    child: Text(_sira + 1 >= widget.sorular.length ? 'Bitir' : 'Sonraki soru'),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class CalismaOzeti extends StatelessWidget {
  final String baslik;
  final List<Soru> sorular;
  final Map<String, String> cevaplar;

  const CalismaOzeti({super.key, required this.baslik, required this.sorular, required this.cevaplar});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cozulen = [
      for (final s in sorular)
        if (cevaplar.containsKey(s.id)) s,
    ];
    final yanlislar = [
      for (final s in cozulen)
        if (cevaplar[s.id] != s.dogru) s,
    ];
    final dogru = cozulen.length - yanlislar.length;
    final oran = cozulen.isEmpty ? 0.0 : dogru / cozulen.length;
    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: Govde(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(value: oran, strokeWidth: 12, strokeCap: StrokeCap.round),
                    Center(
                      child: Text(
                        '%${(oran * 100).round()}',
                        style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('$dogru doğru · ${yanlislar.length} yanlış', style: t.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              yanlislar.isEmpty
                  ? 'Harika! Bu sorular birkaç gün sonra tekrar karşına çıkacak.'
                  : 'Yanlış yaptığın sorular yanlış defterine eklendi ve kısa süre sonra tekrar sorulacak.',
              style: t.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (yanlislar.isNotEmpty) ...[
              FilledButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Yanlışları hemen tekrar çöz'),
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => CalismaEkrani(baslik: 'Yanlışlar', sorular: yanlislar),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        ),
      ),
    );
  }
}

const hataTurleri = [
  'Cevap anahtarı yanlış',
  'Birden fazla doğru şık var',
  'Mevzuat güncel değil',
  'Açıklama yetersiz / anlaşılmıyor',
  'Yazım hatası',
  'Diğer',
];

Future<void> hataBildir(BuildContext context, Soru soru) async {
  final durum = Kapsam.of(context);
  String? tur;
  final not = TextEditingController();
  final gonderildi = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bu soruda hata mı var?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Bildirimin uzmanlarımızca incelenir.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final h in hataTurleri)
                  ChoiceChip(label: Text(h), selected: tur == h, onSelected: (_) => setState(() => tur = h)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: not,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Kısaca açıklar mısın? (isteğe bağlı)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: tur == null ? null : () => Navigator.of(context).pop(true),
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    ),
  );
  if (gonderildi == true && tur != null) {
    await durum.ilerleme.bildirimEkle(soru, tur!, not.text.trim());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Teşekkürler! Bildirimin kaydedildi.')));
    }
  }
  not.dispose();
}
