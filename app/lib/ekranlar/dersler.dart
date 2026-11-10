import 'package:flutter/material.dart';

import '../uygulama.dart';
import '../veri/ilerleme.dart';
import '../veri/modeller.dart';
import 'anlatimlar.dart';
import 'calisma.dart';
import 'klasik.dart';
import 'konu.dart';
import 'pdf_olustur.dart';
import '../bilesenler/duzen.dart';

class DerslerEkrani extends StatelessWidget {
  const DerslerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final bolum = durum.bolum;
        final dersler = durum.banka.bolumDersleri(bolum);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dersler'),
            actions: [
              IconButton(
                key: const Key('pdf-foy'),
                tooltip: 'PDF çalışma föyü',
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PdfOlusturEkrani())),
              ),
            ],
          ),
          // Geniş tablette (yatay 10") kartlar iki sütuna dizilir; dar ekranlarda tek sütun ve okuma genişliği korunur.
          body: Govde(
            enGenis: tabletGenisligi,
            child: LayoutBuilder(
              builder: (context, kisit) {
                final kartlar = [
                  for (final d in dersler)
                    _DersKarti(
                      ders: d,
                      bolum: bolum,
                      ist: durum.ilerleme.istatistik(durum.banka.dersSorulari(bolum, d.kod)),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DersDetay(ders: d))),
                    ),
                ];
                final anlatimSayisi = tumAnlatimlar(durum).length;
                final ust = anlatimSayisi == 0
                    ? null
                    : Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
                        leading: Icon(
                          Icons.auto_stories_rounded,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 30,
                        ),
                        title: Text(
                          'Konu anlatımları',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        subtitle: Text(
                          '$anlatimSayisi konu · ara, oku, sesli dinle',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnlatimlarEkrani())),
                      ),
                    );
                // Kısayol kartı ders kartlarının üstünde tam genişlikte durur.
                final Widget? ustKart = ust;
                const bosluk = EdgeInsets.fromLTRB(16, 8, 16, 24);
                if (kisit.maxWidth < ikiSutunEsigi) {
                  return ListView.separated(
                    padding: kisit.maxWidth > okumaGenisligi
                        ? EdgeInsets.symmetric(horizontal: (kisit.maxWidth - okumaGenisligi) / 2 + 16, vertical: 8)
                        : bosluk,
                    itemCount: kartlar.length + (ustKart == null ? 0 : 1),
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => ustKart == null ? kartlar[i] : (i == 0 ? ustKart : kartlar[i - 1]),
                  );
                }
                // İki sütun: satır başına iki kart, aynı yükseklikte (yazı büyük olsa da taşmaz).
                return ListView.separated(
                  padding: bosluk,
                  itemCount: (kartlar.length + 1) ~/ 2 + (ustKart == null ? 0 : 1),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, j) {
                    if (ustKart != null && j == 0) return ustKart;
                    final i = ustKart == null ? j : j - 1;
                    return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: kartlar[2 * i]),
                        const SizedBox(width: 8),
                        Expanded(child: 2 * i + 1 < kartlar.length ? kartlar[2 * i + 1] : const SizedBox()),
                      ],
                    ),
                  );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DersKarti extends StatelessWidget {
  final Ders ders;
  final String bolum;
  final DersIstatistigi ist;
  final VoidCallback onTap;

  const _DersKarti({required this.ders, required this.bolum, required this.ist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final basari = ist.basari;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(ders.gorunenAd(bolum), style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  if (basari != null) BasariRozeti(oran: basari),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                bolum == 'YMM'
                    ? 'Klasik sınav · Bankada ${ist.toplam} test, '
                          '${Kapsam.of(context).banka.klasikSorulari(ders.kod).length} klasik soru'
                    : 'Sınavda ${ders.sinavdakiSoru(bolum)} soru · Bankada ${ist.toplam} soru',
                style: t.bodySmall?.copyWith(color: r.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: ist.toplam == 0 ? 0 : ist.cozulen / ist.toplam, minHeight: 6),
              ),
              const SizedBox(height: 4),
              Text('${ist.cozulen}/${ist.toplam} soru görüldü', style: t.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class BasariRozeti extends StatelessWidget {
  final double oran;

  const BasariRozeti({super.key, required this.oran});

  @override
  Widget build(BuildContext context) {
    final renk = oran >= 0.7
        ? dogruRenk(context)
        : oran >= 0.5
        // Amber, açık temada beyaz zemin üstünde okunabilsin diye koyulaştırılır (WCAG AA ≥ 4.5:1).
        ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFC94D) : const Color(0xFF8A5A00))
        : yanlisRenk(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: renk.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
      child: Text(
        'Başarı %${(oran * 100).round()}',
        style: TextStyle(color: renk, fontWeight: FontWeight.w700, fontSize: 12.5),
      ),
    );
  }
}

class DersDetay extends StatelessWidget {
  final Ders ders;

  const DersDetay({super.key, required this.ders});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final bolum = durum.bolum;
        final il = durum.ilerleme;
        final havuz = durum.banka.dersSorulari(bolum, ders.kod);
        final zorlar = [
          for (final s in havuz)
            if (s.zorluk == 3) s,
        ];
        final yanlislar = il.yanlislar(havuz);
        // Sorusu ya da anlatımı olan konular; SGS hukuk gibi eşlenen derslerde konu, bankanın sorgusuyla bulunur.
        final konuSorulari = {for (final k in ders.konular.keys) k: durum.banka.dersSorulari(bolum, ders.kod, konu: k)};
        final klasikler = bolum == 'YMM' ? durum.banka.klasikSorulari(ders.kod) : const <KlasikSoru>[];
        final konular = [
          for (final e in ders.konular.entries)
            if (konuSorulari[e.key]!.isNotEmpty ||
                durum.banka.anlatim(ders.kod, e.key) != null ||
                klasikler.any((k) => k.konu == e.key))
              e,
        ];
        final t = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(ders.gorunenAd(bolum)),
            actions: [
              IconButton(
                tooltip: 'Bu dersten PDF föy',
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => PdfOlusturEkrani(ders: ders.kod))),
              ),
            ],
          ),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (klasikler.isNotEmpty) ...[
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.edit_note_rounded),
                    label: Text('Klasik sorular (${klasikler.length})'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => KlasikCalismaEkrani(baslik: ders.gorunenAd(bolum), sorular: klasikler),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                FilledButton.icon(
                  icon: const Icon(Icons.shuffle),
                  label: Text('Karışık çalış · ${durum.ayarlar.oturumBoyu} soru'),
                  onPressed: havuz.isEmpty
                      ? null
                      : () => calismayaBasla(
                          context,
                          baslik: ders.gorunenAd(bolum),
                          sorular: il.calismaSirasi(havuz, durum.ayarlar.oturumBoyu),
                        ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.local_fire_department_outlined),
                        label: Text('Zorlar (${zorlar.length})', maxLines: 1),
                        onPressed: zorlar.isEmpty
                            ? null
                            : () =>
                                  calismayaBasla(context, baslik: 'Zor sorular', sorular: il.calismaSirasi(zorlar, 50)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close_rounded),
                        label: Text('Yanlışlarım (${yanlislar.length})'),
                        onPressed: yanlislar.isEmpty
                            ? null
                            : () => calismayaBasla(context, baslik: 'Yanlışlarım', sorular: yanlislar),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Konular', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                for (final k in konular)
                  Builder(
                    builder: (context) {
                      final ist = il.istatistik(konuSorulari[k.key]!);
                      final anlatim = durum.banka.anlatim(ders.kod, k.key);
                      final okundu = anlatim != null && il.okundu(anlatim.anahtar);
                      final kilitli = anlatim != null && !durum.anlatimAcik(ders, k.key);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          // Sol simge yok: başlığa yer kalsın; anlatım durumu alt satırda, anlatım düğmesi sağda.
                          contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                          title: Text(k.value),
                          subtitle: Text(
                            '${anlatim == null ? '' : (kilitli ? 'Anlatım tam erişimde · ' : (okundu ? 'Okundu · ' : ''))}'
                            '${ist.cozulen}/${ist.toplam} soru',
                          ),
                          // Anlatımı olan konuda kitap düğmesi doğrudan anlatımı açar (konu sayfasına uğramadan).
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (ist.basari != null) BasariRozeti(oran: ist.basari!),
                              if (anlatim != null)
                                IconButton(
                                  tooltip: 'Anlatımı oku',
                                  icon: Icon(
                                    kilitli
                                        ? Icons.lock_outline_rounded
                                        : (okundu ? Icons.auto_stories_rounded : Icons.auto_stories_outlined),
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => anlatimAc(context, ders, anlatim),
                                )
                              else
                                const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => KonuEkrani(ders: ders, konu: k.key),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
