import 'dart:async';

import 'package:flutter/material.dart';

import '../bilesenler/anlatim_gorunumu.dart';
import '../bilesenler/duzen.dart';
import '../bilesenler/sesli_okuma.dart';
import '../mantik/sesli_okuma.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import 'calisma.dart';
import 'dersler.dart';
import 'klasik.dart';
import '../veri/ayarlar.dart';
import 'anlatimlar.dart';

/// Bir konunun sayfası: önce konu anlatımı, ardından o konudan soru çözme.
class KonuEkrani extends StatelessWidget {
  final Ders ders;
  final String konu;

  const KonuEkrani({super.key, required this.ders, required this.konu});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final r = Theme.of(context).colorScheme;
        final bolum = durum.bolum;
        final il = durum.ilerleme;
        final ad = ders.konular[konu] ?? konu;
        final anlatim = durum.banka.anlatim(ders.kod, konu);
        final sorular = durum.banka.dersSorulari(bolum, ders.kod, konu: konu);
        final ist = il.istatistik(sorular);
        final okundu = anlatim != null && il.okundu(anlatim.anahtar);
        final acik = durum.anlatimAcik(ders, konu);
        final klasikler = bolum == 'YMM' ? durum.banka.klasikSorulari(ders.kod, konu: konu) : const <KlasikSoru>[];
        return Scaffold(
          appBar: AppBar(title: Text(ad)),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Text(ders.gorunenAd(bolum), style: t.labelLarge?.copyWith(color: r.onSurfaceVariant)),
                const SizedBox(height: 16),
                _Adim(
                  numara: 1,
                  baslik: 'Konuyu çalış',
                  aciklama: anlatim == null
                      ? 'Bu konunun anlatımı hazırlanıyor; şimdilik sorularla çalışabilirsin.'
                      : '${anlatim.okumaDk} dakikalık okuma${okundu ? ' · okundu' : ''}',
                  tamam: okundu,
                  dugme: anlatim == null
                      ? null
                      : (okundu ? OutlinedButton.icon : FilledButton.icon)(
                          icon: Icon(acik ? Icons.menu_book_rounded : Icons.lock_outline_rounded),
                          label: Text(okundu ? 'Tekrar oku' : (acik ? 'Anlatımı aç' : 'Anlatımı aç · tam erişim')),
                          onPressed: () => anlatimAc(context, ders, anlatim),
                        ),
                ),
                const SizedBox(height: 12),
                _Adim(
                  numara: 2,
                  baslik: 'Soru çöz',
                  aciklama: sorular.isEmpty ? 'Bu konuda henüz soru yok.' : '${ist.cozulen}/${ist.toplam} soru görüldü',
                  tamam: ist.toplam > 0 && ist.cozulen == ist.toplam,
                  ek: ist.basari == null ? null : BasariRozeti(oran: ist.basari!),
                  dugme: sorular.isEmpty
                      ? null
                      : ((anlatim == null || okundu) ? FilledButton.icon : OutlinedButton.icon)(
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text('Soruları çöz (${sorular.length})'),
                          onPressed: () => calismayaBasla(context, baslik: ad, sorular: il.calismaSirasi(sorular, 50)),
                        ),
                ),
                if (klasikler.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _Adim(
                    numara: 3,
                    baslik: 'Klasik soru yaz',
                    aciklama: 'Sınavdaki gibi açık uçlu soru: cevabını yaz, örnek çözüm ve puanlamayla karşılaştır.',
                    tamam: false,
                    dugme: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_note_rounded),
                      label: Text('Klasik sorular (${klasikler.length})'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => KlasikCalismaEkrani(baslik: ad, sorular: klasikler),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Adim extends StatelessWidget {
  final int numara;
  final String baslik;
  final String aciklama;
  final bool tamam;
  final Widget? ek;
  final Widget? dugme;

  const _Adim({
    required this.numara,
    required this.baslik,
    required this.aciklama,
    required this.tamam,
    this.ek,
    this.dugme,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: tamam ? dogruRenk(context) : r.primaryContainer,
                  child: tamam
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : Text(
                          '$numara',
                          style: TextStyle(color: r.onPrimaryContainer, fontWeight: FontWeight.w700),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(baslik, style: t.titleMedium)),
                ?ek,
              ],
            ),
            const SizedBox(height: 8),
            Text(aciklama, style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant)),
            if (dugme != null) ...[const SizedBox(height: 12), dugme!],
          ],
        ),
      ),
    );
  }
}

/// Konu anlatımını okuma ekranı: üstte "sesli dinle", altta oynatıcı çubuğu; sonunda "okudum, soruya geç" ve
/// "sonraki konu" adımları vardır.
class AnlatimEkrani extends StatefulWidget {
  final Ders ders;
  final KonuAnlatimi anlatim;

  const AnlatimEkrani({super.key, required this.ders, required this.anlatim});

  @override
  State<AnlatimEkrani> createState() => _AnlatimEkraniState();
}

class _AnlatimEkraniState extends State<AnlatimEkrani> {
  late final SesMotoru _ses = Kapsam.of(context).ses;

  String get _kaynak => 'anlatim/${widget.anlatim.anahtar}';

  bool get _okunuyor => _ses.okuyor && _ses.kaynak == _kaynak;

  Future<void> _dinle() async {
    if (_okunuyor) {
      return _ses.duraklatildi ? _ses.devam() : _ses.duraklat();
    }
    await sesliOkumayaBasla(context, _ses, anlatimOkumaMetni(widget.anlatim), kaynak: _kaynak);
  }

  @override
  void dispose() {
    // Anlatımdan çıkınca okuma da durur (ses arka planda sahipsiz kalmasın).
    if (_okunuyor) scheduleMicrotask(_ses.durdur);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final anlatim = widget.anlatim;
    final ders = widget.ders;
    final sorular = durum.banka.dersSorulari(durum.bolum, ders.kod, konu: anlatim.konu);
    final sonraki = sonrakiAnlatim(durum, ders, anlatim);
    return Scaffold(
      appBar: AppBar(
        title: Text(anlatim.baslik, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          // Konu anlatımının tamamını cihazın Türkçe sesiyle okur (ücretsiz ve çevrimdışı).
          ListenableBuilder(
            listenable: _ses,
            builder: (context, _) => IconButton(
              tooltip: _okunuyor ? (_ses.duraklatildi ? 'Dinlemeye devam et' : 'Duraklat') : 'Konuyu sesli dinle',
              icon: Icon(
                _okunuyor && !_ses.duraklatildi ? Icons.pause_circle_outline_rounded : Icons.headphones_rounded,
              ),
              onPressed: _dinle,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SesOynatici(
        motor: _ses,
        kaynak: _kaynak,
        hizlar: sesHizlari.values.toList(),
        hizDegisti: durum.ayarlar.sesHiziSec,
      ),
      body: Govde(
        child: YukariCikListe(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(anlatim.baslik, style: t.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${ders.gorunenAd(durum.bolum)} · ${anlatim.okumaDk} dk okuma',
              style: t.bodyMedium?.copyWith(color: r.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            // Büyük, görünür dinleme düğmesi: kullanıcı ses özelliğini üst çubukta aramak zorunda kalmaz.
            ListenableBuilder(
              listenable: _ses,
              builder: (context, _) => Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  icon: Icon(_okunuyor && !_ses.duraklatildi ? Icons.pause_rounded : Icons.headphones_rounded),
                  label: Text(
                    !_okunuyor
                        ? 'Sesli dinle'
                        : (_ses.duraklatildi ? 'Dinlemeye devam et' : 'Dinleniyor · duraklat'),
                  ),
                  onPressed: _dinle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnlatimGorunumu(anlatim.metin),
            if (anlatim.kaynaklar.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Dayanak', style: t.titleSmall),
              const SizedBox(height: 4),
              for (final k in anlatim.kaynaklar) Text('• $k', style: t.bodySmall?.copyWith(color: r.onSurfaceVariant)),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              icon: const Icon(Icons.check_rounded),
              label: Text(sorular.isEmpty ? 'Okudum' : 'Okudum, şimdi soru çöz (${sorular.length})'),
              onPressed: () async {
                await durum.ilerleme.okunduIsaretle(anlatim.anahtar);
                if (context.mounted) Navigator.of(context).pop(sorular.isNotEmpty);
              },
            ),
            if (sonraki != null) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: Icon(
                  durum.anlatimAcik(ders, sonraki.anlatim.konu) ? Icons.arrow_forward_rounded : Icons.lock_outline_rounded,
                ),
                label: Text(
                  'Sonraki konu: ${ders.konular[sonraki.anlatim.konu] ?? sonraki.anlatim.baslik}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
                onPressed: () async {
                  await durum.ilerleme.okunduIsaretle(anlatim.anahtar);
                  if (context.mounted) await anlatimAc(context, ders, sonraki.anlatim, yerine: true);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
