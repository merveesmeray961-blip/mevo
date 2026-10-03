import 'package:flutter/material.dart';

class YasalMetin {
  final String baslik;
  final String metin;

  const YasalMetin(this.baslik, this.metin);
}

// TASLAK — yayından önce veri sorumlusu bilgileri eklenecek ve hukuki gözden geçirme yapılacak.
// Uygulama hesap açmaz, sunucuya veri göndermez; yalnızca satın alma Google Play / App Store üzerinden yapılır.
// Bu metinlerin web karşılığı docs/magaza/gizlilik.html dosyasıdır; biri değişirse diğeri de güncellenmelidir.
const yasalMetinler = [
  YasalMetin('KVKK aydınlatma metni', '''
Bu uygulama hesap oluşturmanı istemez ve kişisel verilerini bir sunucuya göndermez.

İşlenen veriler: Çözdüğün sorular, verdiğin cevaplar, deneme sonuçların, uygulama ayarların ve gönderdiğin hata bildirimleri. Bu veriler yalnızca kendi cihazında saklanır.

Amaç: Sana ilerlemeni göstermek, yanlış yaptığın soruları tekrar sormak ve deneme sonuçlarını hesaplamak.

Satın alma: "Tam erişim" satın alımı Google Play (Android) veya App Store (iOS) üzerinden yapılır. Ödeme ve kart bilgilerin yalnızca mağaza tarafından işlenir, bize iletilmez. Uygulama, tam erişim hakkını açmak için mağazanın verdiği satın alma kaydını cihazında doğrular ve saklar.

Aktarım: Çalışma verilerin üçüncü kişilere veya yurt dışına aktarılmaz. Mağaza işlemleri ilgili mağazanın kendi gizlilik politikasına tabidir.

Saklama ve silme: Verileri Ayarlar > İlerlememi sıfırla ile ya da uygulamayı kaldırarak istediğin zaman silebilirsin.

Haklar: 6698 sayılı Kanun'un 11. maddesindeki haklarını kullanmak için veri sorumlusuna başvurabilirsin.

Veri sorumlusu: [yayın öncesi eklenecek]
'''),
  YasalMetin('Gizlilik politikası', '''
Uygulama reklam göstermez, seni izleyen bir reklam kimliği veya analiz aracı kullanmaz ve herhangi bir sunucuya veri göndermez.

Tüm çalışma verilerin (cevaplar, deneme sonuçları, ayarlar) yalnızca cihazında tutulur ve uygulamayı kaldırdığında silinir.

Tek seferlik "Tam erişim" satın alımı Google Play veya App Store üzerinden yapılır. Ödeme bilgilerin bize iletilmez; mağaza, satın aldığını uygulamaya bildirir ve uygulama bunu cihazında saklar. "Satın alımı geri yükle" dediğinde uygulama mağazaya yeniden sorar.

Gizlilikle ilgili sorular için: [yayın öncesi eklenecek]
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
