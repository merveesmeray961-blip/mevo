import 'package:flutter/material.dart';

import '../bilesenler/duzen.dart';
import '../uygulama.dart';
import '../veri/modeller.dart';
import '../veri/notlar.dart';
import 'calisma.dart';

/// Soru için not sayfasını açar. Sayfa kapanırken (düğme, aşağı sürükleme ya da dışına dokunma) not kendiliğinden kaydedilir.
Future<void> notSayfasiAc(BuildContext context, Soru soru) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  constraints: const BoxConstraints(maxWidth: okumaGenisligi),
  builder: (_) => _NotSayfasi(soru: soru),
);

class _NotSayfasi extends StatefulWidget {
  final Soru soru;

  const _NotSayfasi({required this.soru});

  @override
  State<_NotSayfasi> createState() => _NotSayfasiState();
}

class _NotSayfasiState extends State<_NotSayfasi> {
  late final Notlar _notlar = Kapsam.of(context).notlar;
  late final TextEditingController _metin = TextEditingController(text: _notlar.not(widget.soru.id)?.metin);
  bool _silindi = false;

  @override
  void dispose() {
    final metin = _metin.text;
    final id = widget.soru.id;
    final notlar = _notlar;
    final sil = _silindi;
    _metin.dispose();
    // Ağaç kilitliyken dinleyicileri tetiklememek için kayıt bir sonraki mikro göreve bırakılır.
    if (!sil) Future.microtask(() => notlar.kaydet(id, metin));
    super.dispose();
  }

  void _sil() {
    _silindi = true;
    _notlar.sil(widget.soru.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final durum = Kapsam.of(context);
    final ders = durum.banka.dersler[widget.soru.ders];
    final konu = ders?.konular[widget.soru.konu] ?? widget.soru.konu;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Notum', style: t.titleLarge),
              const SizedBox(height: 2),
              Text('${ders?.gorunenAd(durum.bolum) ?? widget.soru.ders} · $konu', style: t.bodyMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _metin,
                autofocus: true,
                minLines: 4,
                maxLines: 8,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Bu soru için notunu yaz…', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ListenableBuilder(
                    listenable: _metin,
                    builder: (context, _) => TextButton.icon(
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Notu sil'),
                      onPressed: _metin.text.isEmpty && _notlar.not(widget.soru.id) == null ? null : _sil,
                    ),
                  ),
                  FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Uygulama çubuğundaki "Not al" düğmesi; soruda not varsa simge dolu renkte ve noktalı görünür.
class NotDugmesi extends StatelessWidget {
  final Soru soru;

  const NotDugmesi({super.key, required this.soru});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final r = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: durum.notlar,
      builder: (context, _) {
        final notVar = durum.notlar.not(soru.id) != null;
        return IconButton(
          tooltip: 'Not al',
          icon: notVar
              ? Badge(
                  smallSize: 8,
                  backgroundColor: r.primary,
                  child: Icon(Icons.edit_note, color: r.primary),
                )
              : const Icon(Icons.edit_note),
          onPressed: () => notSayfasiAc(context, soru),
        );
      },
    );
  }
}

/// Cevaplanmış sorunun açıklamasının altında kullanıcının notunu gösterir (not yoksa boş).
class NotKarti extends StatelessWidget {
  final Soru soru;

  const NotKarti({super.key, required this.soru});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: durum.notlar,
      builder: (context, _) {
        final not = durum.notlar.not(soru.id);
        if (not == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => notSayfasiAc(context, soru),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.edit_note),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notun', style: t.labelLarge),
                          const SizedBox(height: 4),
                          Text(not.metin, style: t.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Notu olan soruların listesi: dokununca not sahibi sorudan başlayan bir çalışma oturumu açılır.
class NotlarimEkrani extends StatelessWidget {
  const NotlarimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: durum.notlar,
      builder: (context, _) {
        final sorular = durum.notlar.notluSorular(durum.banka.bolumSorulari(durum.bolum));
        return Scaffold(
          appBar: AppBar(title: const Text('Notlarım')),
          body: Govde(
            child: sorular.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Henüz notun yok. Çalışırken uygulama çubuğundaki not simgesine dokunarak not alabilirsin.',
                        style: t.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: sorular.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final s = sorular[i];
                      final not = durum.notlar.not(s.id)!;
                      final ders = durum.banka.dersler[s.ders];
                      return Dismissible(
                        key: ValueKey(s.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => durum.notlar.sil(s.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(color: r.errorContainer, borderRadius: BorderRadius.circular(14)),
                          child: Icon(Icons.delete_outline, color: r.onErrorContainer),
                        ),
                        child: Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                              '${ders?.gorunenAd(durum.bolum) ?? s.ders} · ${ders?.konular[s.konu] ?? s.konu}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(not.metin, maxLines: 2, overflow: TextOverflow.ellipsis),
                                Text(tarihYaz(not.tarih), style: t.bodySmall),
                              ],
                            ),
                            trailing: IconButton(
                              tooltip: 'Notu sil',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => durum.notlar.sil(s.id),
                            ),
                            onTap: () => calismayaBasla(
                              context,
                              baslik: 'Notlarım',
                              sorular: [s, ...sorular.where((x) => x.id != s.id)],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
