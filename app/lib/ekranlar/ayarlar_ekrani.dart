import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../abonelik/abonelik.dart';
import '../uygulama.dart';
import '../veri/ayarlar.dart';
import '../veri/yedek.dart';
import 'bolum_secimi.dart';
import 'odeme.dart';
import 'yasal.dart';
import '../bilesenler/duzen.dart';
import '../bilesenler/sesli_okuma.dart';

/// Ayarlar listesinde bir grubun başlığı.
class _GrupBasligi extends StatelessWidget {
  final String ad;

  const _GrupBasligi(this.ad);

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        ad,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: r.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class AyarlarEkrani extends StatelessWidget {
  const AyarlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final ay = durum.ayarlar;
        final t = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(title: const Text('Ayarlar')),
          body: Govde(
            child: ListView(
              children: [
                const _GrupBasligi('Çalışma'),
                // Tek sınavlı uygulamada (Tasdik YMM) seçilecek bir şey yoktur; sınav adı yalnız bilgi olarak görünür.
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Hazırlandığım sınav'),
                  subtitle: Text(bolumAdi[durum.bolum]!),
                  trailing: durum.urun.bolumSecimiVar ? const Icon(Icons.chevron_right) : null,
                  onTap: durum.urun.bolumSecimiVar
                      ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BolumSecimi()))
                      : null,
                ),
                const _GrupBasligi('Görünüm ve okuma'),
                ListTile(
                  leading: const Icon(Icons.format_size),
                  title: const Text('Yazı boyutu'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<double>(
                          segments: [
                            for (final e in yaziSecenekleri.entries)
                              ButtonSegment(
                                value: e.value,
                                label: FittedBox(fit: BoxFit.scaleDown, child: Text(e.key, maxLines: 1, softWrap: false)),
                              ),
                          ],
                          selected: {ay.yazi},
                          onSelectionChanged: (s) => ay.yaziSec(s.first),
                          showSelectedIcon: false,
                        ),
                        const SizedBox(height: 10),
                        // Canlı önizleme: seçilen boyut soru ekranında böyle görünür.
                        Text(
                          'Örnek: Aşağıdakilerden hangisi dönen varlıklar arasında yer alır?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ),
                const _GrupBasligi('Sesli okuma'),
                const _SesAyarlari(),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: const Text('Çalışma oturumu'),
                  trailing: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 10, label: Text('10')),
                      ButtonSegment(value: 20, label: Text('20')),
                      ButtonSegment(value: 30, label: Text('30')),
                    ],
                    selected: {ay.oturumBoyu},
                    onSelectionChanged: (s) => ay.oturumBoyuSec(s.first),
                    showSelectedIcon: false,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Görünüm'),
                  trailing: DropdownButton<ThemeMode>(
                    value: ay.tema,
                    underline: const SizedBox(),
                    onChanged: (m) => ay.temaSec(m!),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('Sistem')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Açık')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Koyu')),
                    ],
                  ),
                ),
                const Divider(),
                const _GrupBasligi('Tam erişim'),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: Text(durum.abonelik.premium ? 'Tam erişim açık' : 'Ücretsiz sürüm'),
                  subtitle: Text(
                    durum.abonelik.premium
                        ? (durum.abonelik.onizleme ? 'Önizleme: ödeme alınmadı' : 'Satın alındı, teşekkürler')
                        : 'Günde $ucretsizGunlukSoru soru, $ucretsizDeneme deneme',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => odemeEkraniAc(context),
                ),
                if (durum.abonelik case final OnizlemeAbonelik o when o.premium)
                  ListTile(
                    leading: const Icon(Icons.undo),
                    title: const Text('Önizleme erişimini kapat'),
                    subtitle: const Text('Ücretsiz sürümü denemek için'),
                    onTap: o.iptal,
                  ),
                const Divider(),
                const _GrupBasligi('Verilerim'),
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text('İlerlememi yedekle'),
                  subtitle: const Text('Telefon değiştirirken çalışma geçmişini taşımak için'),
                  onTap: () => yedekGoster(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_backup_restore),
                  title: const Text('Yedekten geri yükle'),
                  onTap: () => yedekGeriYukle(context),
                ),
                ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('İlerlememi sıfırla'),
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('İlerleme sıfırlansın mı?'),
                        content: const Text(
                          'Çözdüğün sorular, yanlış defterin ve deneme sonuçların silinir (notların silinmez). Bu işlem geri alınamaz.',
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sıfırla')),
                        ],
                      ),
                    );
                    if (ok == true) await durum.ilerleme.sifirla();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text('Notlarımı sil'),
                  subtitle: Text(durum.notlar.sayi == 0 ? 'Henüz notun yok' : '${durum.notlar.sayi} not'),
                  enabled: durum.notlar.sayi > 0,
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tüm notlar silinsin mi?'),
                        content: Text('${durum.notlar.sayi} notun silinir. Bu işlem geri alınamaz.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sil')),
                        ],
                      ),
                    );
                    if (ok == true) await durum.notlar.hepsiniSil();
                  },
                ),
                const Divider(),
                const _GrupBasligi('Yasal'),
                for (final m in yasalMetinler(durum.urun))
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(m.baslik),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => YasalMetinEkrani(metin: m))),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${_surum.isEmpty ? '' : 'Sürüm $_surum\n'}'
                    'Soru bankası: ${durum.banka.sorular.length} soru · ${durum.banka.olusturma}\n'
                    'Gönderdiğin hata bildirimi: ${durum.ilerleme.bildirimler.length}\n\n'
                    '${durum.banka.uyari}',
                    style: t.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Sesli okuma ayarları: hız, cihazdaki Türkçe seslerden seçim ve örnek dinleme.
class _SesAyarlari extends StatefulWidget {
  const _SesAyarlari();

  @override
  State<_SesAyarlari> createState() => _SesAyarlariState();
}

class _SesAyarlariState extends State<_SesAyarlari> {
  static const _ornek =
      'Merhaba. Amortisman, iktisadi kıymetin değerindeki azalmanın giderleştirilmesidir. '
      'Vergi Usul Kanunu madde 313 uyarınca, 2026 yılı için sınır 12.000 liradır.';
  Future<void>? _hazirlik;

  @override
  void dispose() {
    final ses = _ses;
    if (ses != null && ses.kaynak == 'ayarlar/ornek') scheduleMicrotaskSafe(ses.durdur);
    super.dispose();
  }

  SesMotoru? _ses;

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    final ses = _ses = durum.ses;
    final ay = durum.ayarlar;
    _hazirlik ??= ses.hazirla();
    return FutureBuilder<void>(
      future: _hazirlik,
      builder: (context, _) => ListenableBuilder(
        listenable: ses,
        builder: (context, _) {
          final sesler = ses.sesler;
          final secili = sesler.any((s) => s.ad == ay.sesAdi) ? ay.sesAdi : (sesler.isEmpty ? null : sesler.first.ad);
          final ornekCaliyor = ses.okuyor && ses.kaynak == 'ayarlar/ornek';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.speed_rounded),
                title: const Text('Okuma hızı'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SegmentedButton<double>(
                    segments: [
                      for (final e in sesHizlari.entries)
                        ButtonSegment(
                          value: e.value,
                          label: FittedBox(fit: BoxFit.scaleDown, child: Text(e.key, maxLines: 1, softWrap: false)),
                        ),
                    ],
                    selected: {ay.sesHizi},
                    onSelectionChanged: (s) {
                      ay.sesHiziSec(s.first);
                      ses.hizSec(s.first);
                    },
                    showSelectedIcon: false,
                  ),
                ),
              ),
              if (!ses.turkceVar)
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Türkçe ses bulunamadı'),
                  subtitle: Text(
                    'Telefon Ayarları › Metin okuma çıkışı bölümünden "Google Konuşma Hizmetleri"ni seçip '
                    'Türkçe ses verisini yükle; ardından uygulamayı yeniden aç.',
                  ),
                )
              else if (sesler.length > 1)
                ListTile(
                  leading: const Icon(Icons.record_voice_over_outlined),
                  title: const Text('Ses'),
                  // Seçim kutusu alt satırda tam genişlikte: büyük yazıda yan yana dizilince açıklama tek harflik
                  // sütuna sıkışıyordu (emülatör testi, 11.11.2026).
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cihazdaki Türkçe sesler; en doğal olanı seç'),
                      DropdownButton<String>(
                        value: secili,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (ad) async {
                          await ay.sesAdiSec(ad);
                          await ses.sesSec(ad);
                          if (context.mounted) await ses.oku(_ornek, kaynak: 'ayarlar/ornek');
                        },
                        items: [
                          for (final s in sesler)
                            DropdownMenuItem(value: s.ad, child: Text(s.etiket, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              if (ses.turkceVar)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      icon: Icon(ornekCaliyor ? Icons.stop_rounded : Icons.play_arrow_rounded),
                      label: Text(ornekCaliyor ? 'Durdur' : 'Örnek dinle'),
                      onPressed: () => ornekCaliyor ? ses.durdur() : ses.oku(_ornek, kaynak: 'ayarlar/ornek'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

void scheduleMicrotaskSafe(Future<void> Function() f) => Future.microtask(f);

/// Derleme sırasında `--dart-define=MEVO_SURUM=…` ile verilir (araclar/derle.cmd); geliştirmede boştur.
const _surum = String.fromEnvironment('MEVO_SURUM');

/// Yedek kodunu gösterir; kullanıcı kopyalayıp kendine gönderir.
Future<void> yedekGoster(BuildContext context) async {
  final durum = Kapsam.of(context);
  final kod = yedekOlustur(durum.ilerleme.depo, durum.urun.kod, DateTime.now());
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('İlerleme yedeği'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aşağıdaki kodu kopyala ve kendine gönder (not, e-posta ya da mesaj). Yeni telefonda '
              'Ayarlar › Verilerim › Yedekten geri yükle bölümüne yapıştır.\n\n'
              'Kod yalnız çalışma geçmişini, notlarını ve ayarlarını içerir. Tam erişim mağazadan '
              '"Satın alımı geri yükle" ile gelir.',
            ),
            const SizedBox(height: 12),
            Text('${(kod.length / 1024).toStringAsFixed(1)} KB', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Kapat')),
        FilledButton.icon(
          icon: const Icon(Icons.copy),
          label: const Text('Kodu kopyala'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: kod));
            if (!context.mounted) return;
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Yedek kodu kopyalandı. Kendine gönderip sakla.')),
            );
          },
        ),
      ],
    ),
  );
}

/// Yapıştırılan yedek kodunu doğrular, onay alır ve bu cihazdaki ilerlemenin yerine yazar.
Future<void> yedekGeriYukle(BuildContext context) async {
  final durum = Kapsam.of(context);
  final alan = TextEditingController();
  final pano = await Clipboard.getData(Clipboard.kTextPlain);
  if (pano?.text?.trim().startsWith(yedekOnEki) ?? false) alan.text = pano!.text!.trim();
  if (!context.mounted) return;
  final kod = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Yedekten geri yükle'),
      content: TextField(
        controller: alan,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Yedek kodunu buraya yapıştır', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Vazgeç')),
        FilledButton(onPressed: () => Navigator.of(context).pop(alan.text), child: const Text('Devam')),
      ],
    ),
  );
  if (kod == null || kod.trim().isEmpty || !context.mounted) return;
  final ({DateTime tarih, Map<String, String> veri}) yedek;
  try {
    yedek = yedekCoz(kod, durum.urun.kod);
  } on YedekHatasi catch (h) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(h.mesaj)));
    return;
  }
  final onay = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Yedek geri yüklensin mi?'),
      content: Text(
        '${tarihYaz(yedek.tarih)} tarihli yedek yüklenecek. Bu telefondaki çalışma geçmişi, notlar ve ayarlar '
        'yedektekilerle değiştirilir.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
        FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Geri yükle')),
      ],
    ),
  );
  if (onay != true) return;
  await yedekYaz(durum.ilerleme.depo, yedek.veri);
  durum.ilerleme.yenidenYukle();
  durum.notlar.yenidenYukle();
  durum.ayarlar.yenidenYukle();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yedek geri yüklendi.')));
}
