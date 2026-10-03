import 'package:flutter/material.dart';

class YasalMetin {
  final String baslik;
  final String metin;

  const YasalMetin(this.baslik, this.metin);
}

// TASLAK — yayından önce veri sorumlusu bilgileri eklenecek ve hukuki gözden geçirme yapılacak (PLAN.md §11, iş 6).
// Bu sürüm hesap açmaz ve hiçbir veriyi cihaz dışına göndermez; metinler buna göre yazılmıştır. Sunucu eşitleme
// veya ödeme altyapısı eklendiğinde metinler güncellenmelidir.
const yasalMetinler = [
  YasalMetin('KVKK aydınlatma metni', '''
Bu uygulamanın mevcut sürümü hesap oluşturmanı istemez ve kişisel verilerini sunucuya göndermez.

İşlenen veriler: Çözdüğün sorular, verdiğin cevaplar, deneme sonuçların, uygulama ayarların ve gönderdiğin hata bildirimleri. Bu veriler yalnızca kendi cihazında saklanır.

Amaç: Sana ilerlemeni göstermek, yanlış yaptığın soruları tekrar sormak ve deneme sonuçlarını hesaplamak.

Aktarım: Bu sürümde veriler üçüncü kişilere veya yurt dışına aktarılmaz.

Saklama ve silme: Verileri Ayarlar > İlerlememi sıfırla ile ya da uygulamayı kaldırarak istediğin zaman silebilirsin.

Haklar: 6698 sayılı Kanun'un 11. maddesindeki haklarını kullanmak için veri sorumlusuna başvurabilirsin.

Veri sorumlusu: [yayın öncesi eklenecek]
'''),
  YasalMetin('Gizlilik politikası', '''
Uygulama reklam göstermez ve seni izleyen bir reklam kimliği kullanmaz.

Bu sürümde tüm çalışma verilerin cihazında tutulur. Hesap, sunucu eşitleme veya ödeme altyapısı eklendiğinde bu politika güncellenecek ve sana bildirilecektir.

Satın alımlar App Store veya Google Play üzerinden yapılır; ödeme bilgilerin bize iletilmez.
'''),
  YasalMetin('Kullanım koşulları', '''
Sorular, SMMM sınavlarına hazırlık amacıyla özgün olarak hazırlanmıştır ve resmî sınav soruları değildir.

Sorular ilgili mevzuata dayanır ve yayından önce çok aşamalı kontrolden geçer; yine de hata içerebilir. Hata gördüğünde soru ekranındaki bayrak simgesiyle bildirebilirsin.

Mevzuat değişebilir; güncel hükümler için resmî kaynaklar esas alınmalıdır.

İçerik kişisel kullanım içindir; kopyalanıp çoğaltılamaz.
'''),
  YasalMetin('Resmî bağlantı', '''
Bu uygulamanın TÜRMOB veya TESMER ile resmî bir bağlantısı yoktur.

Sınav kuralları (soru sayıları, süreler, yanlış cezası, geçme notları) TÜRMOB ve TESMER'in yayımladığı yönerge ve duyurulardan alınmıştır. Kesin bilgi için her zaman resmî duyuruları takip et.
'''),
];

class YasalMetinEkrani extends StatelessWidget {
  final YasalMetin metin;

  const YasalMetinEkrani({super.key, required this.metin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(metin.baslik)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SelectableText(metin.metin.trim(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
