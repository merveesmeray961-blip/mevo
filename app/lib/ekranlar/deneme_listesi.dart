import 'package:flutter/material.dart';

import '../mantik/deneme.dart';
import '../uygulama.dart';
import 'deneme.dart';
import 'odeme.dart';
import '../bilesenler/duzen.dart';

class DenemeListesi extends StatelessWidget {
  const DenemeListesi({super.key});

  @override
  Widget build(BuildContext context) {
    final durum = Kapsam.of(context);
    return ListenableBuilder(
      listenable: durum.degisim,
      builder: (context, _) {
        final t = Theme.of(context).textTheme;
        final banka = durum.banka;
        final bolum = durum.bolum;
        final f = banka.formatlar[bolum]!;
        final gecmis = [
          for (final d in durum.ilerleme.denemeler)
            if (d.bolum == bolum) d,
        ];

        final kartlar = <Widget>[];
        if (bolum == 'YET') {
          kartlar.add(_Baslik('Oturum denemeleri'));
          for (var o = 1; o <= f.oturumlar.length; o++) {
            final plan = denemePlanla(banka, DenemeTuru.yetOturum, oturum: o);
            kartlar.add(
              _DenemeKarti(
                baslik: '$o. oturum',
                aciklama: f.oturumlar[o - 1].map((d) => banka.dersler[d]!.ad).join(' · '),
                plan: plan,
                olustur: () => denemePlanla(banka, DenemeTuru.yetOturum, oturum: o),
              ),
            );
          }
          kartlar.add(_Baslik('Ders denemeleri'));
          for (final d in banka.bolumDersleri('YET')) {
            kartlar.add(
              _DenemeKarti(
                baslik: d.ad,
                plan: denemePlanla(banka, DenemeTuru.yetDers, ders: d.kod),
                olustur: () => denemePlanla(banka, DenemeTuru.yetDers, ders: d.kod),
              ),
            );
          }
        } else {
          kartlar.add(_Baslik('Tam deneme'));
          kartlar.add(
            _DenemeKarti(
              baslik: 'Alan bilgisi denemesi',
              aciklama: 'Genel kültür, yetenek ve yabancı dil bölümleri sonraki sürümde eklenecek.',
              plan: denemePlanla(banka, DenemeTuru.sgs),
              olustur: () => denemePlanla(banka, DenemeTuru.sgs),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Deneme sınavı')),
          body: Govde(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                Text(
                  bolum == 'YET'
                      ? 'Gerçek sınav kuralları: ders başına ${f.dersBasinaSoru} soru ve ${f.dersBasinaSureDk} dakika, '
                            '4 yanlış 1 doğruyu götürür, hesap makinesi yok.'
                      : 'Gerçek sınav kuralları: ${f.toplamSoru} soru, ${f.toplamSureDk} dakika, yanlış doğruyu götürmez, '
                            'hesap makinesi yok.',
                  style: t.bodyMedium,
                ),
                if (gecmis.isNotEmpty) ...[
                  _Baslik('Geçmiş denemelerim'),
                  for (final d in gecmis)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(d.baslik),
                        subtitle: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${tarihYaz(d.tarih)} · ${sureYaz(d.kullanilanSn)}\n'),
                              TextSpan(
                                text: bolum == 'YET'
                                    ? 'Puan ${sayiYaz(d.puan, basamak: 2)}'
                                    : 'Doğru %${d.puan.round()}',
                                style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              if (d.gecti != null)
                                TextSpan(
                                  text: d.gecti! ? ' · Barajı geçti' : ' · Baraj altı',
                                  style: TextStyle(color: d.gecti! ? dogruRenk(context) : yanlisRenk(context)),
                                ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          final sonuc = DenemeSonucu.kayittan(banka, d);
                          if (sonuc == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bu deneme eski sürümde çözüldüğü için ayrıntısı saklanmadı.'),
                              ),
                            );
                            return;
                          }
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => DenemeSonucEkrani(sonuc: sonuc)));
                        },
                        // Puan ve baraj durumu alt satırda; büyük yazıda da satır yüksekliğine sığar.
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                ],
                ...kartlar,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Baslik extends StatelessWidget {
  final String metin;

  const _Baslik(this.metin);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(metin, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
  );
}

class _DenemeKarti extends StatelessWidget {
  final String baslik;
  final String? aciklama;
  final DenemePlani plan;
  final DenemePlani Function() olustur;

  const _DenemeKarti({required this.baslik, this.aciklama, required this.plan, required this.olustur});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = Theme.of(context).colorScheme;
    final bilgi = '${plan.sorular.length} soru · ${plan.sureSn ~/ 60} dakika';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(baslik),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (aciklama != null) Text(aciklama!),
            Text(bilgi),
            if (plan.eksik)
              Text(
                'Gerçek sınavda ${plan.hedefToplam} soru; soru bankası büyüdükçe tamamlanacak.',
                style: t.bodySmall?.copyWith(color: r.tertiary),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.play_circle_outline),
        onTap: plan.sorular.isEmpty ? null : () => denemeyeBasla(context, olustur()),
      ),
    );
  }
}

Future<void> denemeyeBasla(BuildContext context, DenemePlani plan) async {
  final durum = Kapsam.of(context);
  if (!durum.denemeHakkiVar) {
    await odemeEkraniAc(context, neden: 'Ücretsiz deneme hakkını kullandın.');
    if (!context.mounted || !durum.denemeHakkiVar) return;
  }
  final f = durum.banka.formatlar[plan.bolum]!;
  final basla = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(plan.baslik),
      content: Text(
        [
          '${plan.sorular.length} soru, ${plan.sureSn ~/ 60} dakika.',
          if (f.yanlisCezasi > 0)
            'Her yanlış ${sayiYaz(f.yanlisCezasi, basamak: 2)} doğruyu götürür; emin olmadığın soruyu boş bırakabilirsin.'
          else
            'Yanlış cevaplar doğruları etkilemez; boş bırakma.',
          'Gerçek sınavdaki gibi hesap makinesi kullanma.',
          'Cevaplar ve açıklamalar sınav bitince gösterilir.',
        ].join('\n\n'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Vazgeç')),
        FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Başla')),
      ],
    ),
  );
  if (basla == true && context.mounted) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => DenemeEkrani(plan: plan)));
  }
}
