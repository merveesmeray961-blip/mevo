import 'package:flutter/material.dart';

import '../urun.dart';

class YasalMetin {
  final String baslik;
  final String metin;

  const YasalMetin(this.baslik, this.metin);
}

// TASLAK — veri sorumlusu bilgileri eklendi; yayından önce hukuki gözden geçirme yapılacak.
// Uygulama hesap açmaz, sunucuya veri göndermez; yalnızca satın alma Google Play / App Store üzerinden yapılır.
// Bu metinlerin web karşılığı docs/magaza/gizlilik.html dosyasıdır; biri değişirse diğeri de güncellenmelidir.
// İki uygulama (Mizan SMMM, Tasdik YMM) aynı metni kullanır; yalnız sınav adı ürüne göre değişir.
List<YasalMetin> yasalMetinler(Urun urun) => [
  const YasalMetin('KVKK aydınlatma metni', '''
Bu uygulama hesap oluşturmanı istemez ve kişisel verilerini bir sunucuya göndermez.

İşlenen veriler: Çözdüğün sorular, verdiğin cevaplar, deneme sonuçların, notların ve uygulama ayarların. Bu veriler yalnızca kendi cihazında saklanır; bize ulaşmaz.

Hata bildirimi (isteğe bağlı): Bir soruda hata gördüğünde bayrak simgesiyle bildirim hazırlarsan, bildirim kendi e-posta uygulamanla destek adresine gönderilir. Bu durumda e-posta adresin, soru numarası, seçtiğin hata türü ve yazdığın not bize ulaşır. Bildirim göndermek tamamen sana kalmıştır; göndermezsen bu veriler cihazından çıkmaz.

Amaç: Sana ilerlemeni göstermek, yanlış yaptığın soruları tekrar sormak ve deneme sonuçlarını hesaplamak. Hata bildirimleri yalnızca ilgili soruyu düzeltmek için kullanılır.

Toplama yöntemi ve hukuki sebep: Çalışma verilerin uygulamayı kullanman sırasında otomatik olarak, yalnızca cihazında oluşur; uygulamanın sunulması bu işlemin sözleşmesel gereğidir (6698 sayılı Kanun md. 5/2-c). Hata bildirimi e-postasındaki veriler, bildirimi kendi isteğinle göndermen üzerine ve soru bankasının doğruluğunu sağlama meşru menfaatimiz kapsamında (md. 5/2-f) işlenir.

Satın alma: "Tam erişim" satın alımı Google Play (Android) veya App Store (iOS) üzerinden yapılır. Ödeme ve kart bilgilerin yalnızca mağaza tarafından işlenir, bize iletilmez. Uygulama, tam erişim hakkını açmak için mağazanın verdiği satın alma kaydını cihazında doğrular ve saklar.

Aktarım: Çalışma verilerin üçüncü kişilere veya yurt dışına aktarılmaz. Mağaza işlemleri ilgili mağazanın kendi gizlilik politikasına tabidir.

Saklama ve silme: Cihazındaki verileri Ayarlar > İlerlememi sıfırla ile ya da uygulamayı kaldırarak istediğin zaman silebilirsin. E-postayla gönderdiğin hata bildirimlerini, ilgili soru düzeltilene kadar ve en fazla bir yıl saklarız; daha önce silinmesini istersen destek adresine yazman yeterlidir.

Haklar: 6698 sayılı Kanun'un 11. maddesi uyarınca; kişisel verinin işlenip işlenmediğini öğrenme, işlenmişse bilgi talep etme, işlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme, aktarıldığı üçüncü kişileri bilme, eksik veya yanlış işlenmişse düzeltilmesini isteme, silinmesini veya yok edilmesini isteme, bu işlemlerin üçüncü kişilere bildirilmesini isteme, otomatik sistemlerle aleyhine bir sonuç çıkmasına itiraz etme ve kanuna aykırı işlenmesi nedeniyle zarara uğraman hâlinde zararın giderilmesini talep etme haklarına sahipsin. Başvurularını aşağıdaki iletişim adresine yazılı olarak iletebilirsin; en geç otuz gün içinde yanıtlanır.

Veri sorumlusu: Merve Er (iletişim: ristaycraft@gmail.com)
'''),
  const YasalMetin('Gizlilik politikası', '''
Uygulama reklam göstermez, seni izleyen bir reklam kimliği veya analiz aracı kullanmaz ve herhangi bir sunucuya veri göndermez.

Tüm çalışma verilerin (cevaplar, deneme sonuçları, ayarlar) yalnızca cihazında tutulur ve uygulamayı kaldırdığında silinir.

Tek seferlik "Tam erişim" satın alımı Google Play veya App Store üzerinden yapılır. Ödeme bilgilerin bize iletilmez; mağaza, satın aldığını uygulamaya bildirir ve uygulama bunu cihazında saklar. "Satın alımı geri yükle" dediğinde uygulama mağazaya yeniden sorar.

Gizlilikle ilgili sorular için: ristaycraft@gmail.com
'''),
  YasalMetin('Kullanım koşulları', '''
Sorular, ${urun.sinavCumlesi} hazırlık amacıyla özgün olarak hazırlanmıştır ve resmî sınav soruları değildir.

Sorular ilgili mevzuata dayanır ve yayından önce çok aşamalı kontrolden geçer; yine de hata içerebilir. Hata gördüğünde soru ekranındaki bayrak simgesiyle bildirebilirsin.

Mevzuat değişebilir; güncel hükümler için resmî kaynaklar esas alınmalıdır.

İçerik kişisel kullanım içindir; kopyalanıp çoğaltılamaz.
'''),
  const YasalMetin('Resmî bağlantı', '''
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
