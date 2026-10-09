import 'package:flutter/material.dart';

import '../abonelik/abonelik.dart';
import '../uygulama.dart';
import '../veri/ayarlar.dart';
import 'bolum_secimi.dart';
import 'odeme.dart';
import 'yasal.dart';
import '../bilesenler/duzen.dart';

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
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Hazırlandığım sınav'),
                  subtitle: Text(bolumAdi[durum.bolum]!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BolumSecimi())),
                ),
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
                                label: Text(e.key, maxLines: 1, softWrap: false, overflow: TextOverflow.fade),
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
                for (final m in yasalMetinler)
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
