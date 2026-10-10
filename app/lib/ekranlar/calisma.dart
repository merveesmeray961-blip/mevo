import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bilesenler/soru_gorunumu.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'hesap_makinesi.dart';
import 'notlar.dart';
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
    // Dokunsal geri bildirim: doğru cevapta hafif, yanlışta belirgin titreşim.
    if (h == _soru.dogru) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    // Açıklamanın başı ekranın alt çeyreğine gelecek kadar kaydır; seçilen şık ve doğru şık ekranda kalır.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kutu = _aciklamaAnahtari.currentContext?.findRenderObject();
      if (kutu == null || !_kaydirma.hasClients) return;
      final p = _kaydirma.position;
      final ust = RenderAbstractViewport.of(kutu).getOffsetToReveal(kutu, 0).offset - p.viewportDimension * 0.72;
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
      _secilen = _cevaplar[_soru.id];
    });
    _kaydirma.jumpTo(0);
  }

  /// Önceki soruya döner (cevabı ve açıklamasıyla birlikte, salt okunur).
  void _onceki() {
    if (_sira == 0) return;
    setState(() {
      _sira--;
      _secilen = _cevaplar[_soru.id];
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
        titleSpacing: 0,
        // Sayaç her zaman görünür; oturum adı küçük ikinci satırda (uzun adlar kesilse de sayaç kaybolmaz).
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_sira + 1} / ${widget.sorular.length}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              widget.baslik,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Hesap makinesi',
            icon: const Icon(Icons.calculate_outlined),
            onPressed: () => hesapMakinesiAc(context),
          ),
          NotDugmesi(soru: _soru),
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
                NotKarti(soru: _soru),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _cevaplandi || _sira > 0
          ? SafeArea(
              child: OrtalaGenislik(
                icerikYuksekligi: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      if (_sira > 0) ...[
                        IconButton.outlined(
                          tooltip: 'Önceki soru',
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _onceki,
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (_cevaplandi)
                        Expanded(
                          child: FilledButton(
                            onPressed: _sonraki,
                            child: Text(_sira + 1 >= widget.sorular.length ? 'Bitir' : 'Sonraki soru'),
                          ),
                        ),
                    ],
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
            // Oturum sonu geri bildirimi: başarıya göre kutlama ya da cesaretlendirme.
            Icon(
              oran >= 0.8
                  ? Icons.emoji_events_rounded
                  : (oran >= 0.5 ? Icons.trending_up_rounded : Icons.school_rounded),
              size: 44,
              color: oran >= 0.8 ? const Color(0xFFE0A100) : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              oran >= 0.8 ? 'Harika iş!' : (oran >= 0.5 ? 'İyi gidiyorsun' : 'Tekrar, öğrenmenin yarısıdır'),
              style: t.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
            Text(
              destekEposta.isEmpty
                  ? 'Bildirimin bu cihaza kaydedilir.'
                  : 'Gönder\'e basınca e-posta uygulaman hazır bir iletiyle açılır; gönderdiğinde ekibimiz inceler.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
    final aciklama = not.text.trim();
    await durum.ilerleme.bildirimEkle(soru, tur!, aciklama);
    // Bildirim e-postayla iletilir; uygulama sunucuya bağlanmaz, gönderimi kullanıcı kendi e-posta uygulamasından yapar.
    var acildi = false;
    if (destekEposta.isNotEmpty) {
      final ileti = Uri(
        scheme: 'mailto',
        path: destekEposta,
        query: _sorguKodla({
          'subject': 'Mevo SMMM hata bildirimi: ${soru.id}',
          'body': 'Soru: ${soru.id} (sürüm ${soru.surum})\nTür: $tur\nAçıklama: ${aciklama.isEmpty ? '-' : aciklama}\n',
        }),
      );
      try {
        acildi = await launchUrl(ileti, mode: LaunchMode.externalApplication);
      } catch (_) {
        acildi = false;
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            acildi || destekEposta.isEmpty
                ? 'Teşekkürler! Bildirimin kaydedildi.'
                : 'E-posta uygulaması açılamadı. Bildirimini $destekEposta adresine yazabilirsin (soru: ${soru.id}).',
          ),
        ),
      );
    }
  }
  not.dispose();
}

/// mailto sorgusu: Uri.queryParameters boşlukları "+" yaptığı için e-posta uygulamalarında bozulur; %20 kullanılır.
String _sorguKodla(Map<String, String> p) =>
    p.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
