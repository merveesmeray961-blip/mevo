---
ders: FYN
konu: SBT
baslik: Sermaye bütçelemesi
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Sermaye bütçelemesi: net bugünkü değer"
    madde: "-"
  - mevzuat: "Genel bilgi — İç verim oranı"
    madde: "-"
  - mevzuat: "Genel bilgi — Geri ödeme süresi ve karlılık endeksi"
    madde: "-"
  - mevzuat: "Genel bilgi — Yatırım projelerinde nakit akışı tahmini"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Net bugünkü değer yöntemiyle yatırım kararı vermek
- İç verim oranını deneme ve doğrusal enterpolasyonla bulmak
- Geri ödeme süresini ve iskontolu geri ödeme süresini hesaplamak
- Karlılık endeksini yorumlamak ve yöntemleri karşılaştırmak
- Proje nakit akışlarını artımsal esasla tahmin etmek

## 1. Net bugünkü değer

**Sermaye bütçelemesi**, faydası bir yıldan uzun sürecek yatırım harcamalarının (makine, tesis, yeni ürün hattı) değerlendirilip seçilmesi sürecidir. Bu konudaki bütün iskontolu yöntemler paranın zaman değerine dayanır.

**Net bugünkü değer (NBD)**, projenin gelecekteki net nakit akışlarının sermaye maliyetiyle iskonto edilmiş toplamından ilk yatırım tutarının çıkarılmasıyla bulunur:

- NBD = Σ NAt / (1 + r)^t − I0

NAt t yılındaki net nakit akışı, r sermaye maliyeti (iskonto oranı), I0 ilk yatırımdır. Bu anlatımda literatürdeki yaygın kabul izlenmiştir: ilk yatırım sıfır anında yapılır, sonraki nakit akışları **her yılın sonunda** gerçekleşir.

Karar kuralı: NBD > 0 ise proje kabul edilir, NBD < 0 ise reddedilir. Birbirini dışlayan projelerde NBD'si en yüksek olan seçilir. NBD, projenin işletme değerine yaptığı katkıyı TL olarak gösterdiği için teorik olarak en güçlü yöntem kabul edilir.

### Örnek: Bir projenin dört yöntemle değerlendirilmesi

İlk yatırımı 100.000 TL olan bir projenin yıl sonu net nakit akışları sırasıyla 30.000, 40.000, 50.000 ve 20.000 TL'dir. Sermaye maliyeti yüzde 10'dur. Bugünkü değerler kuruşa yuvarlanmıştır.

1. Birinci yıl: 30.000 / 1,10 = 27.272,73 TL.
2. İkinci yıl: 40.000 / 1,10^2 = 33.057,85 TL.
3. Üçüncü yıl: 50.000 / 1,10^3 = 37.565,74 TL.
4. Dördüncü yıl: 20.000 / 1,10^4 = 13.660,27 TL.
5. Bugünkü değerler toplamı: 111.556,59 TL.
6. NBD = 111.556,59 − 100.000 = 11.556,59 TL. NBD pozitif olduğu için proje kabul edilir.

Aynı projenin iç verim oranı, geri ödeme süresi ve karlılık endeksi aşağıdaki bölümlerde bu verilerle hesaplanmıştır.

> **Sık yapılan hata:** İlk yatırımı da iskonto etmek. Sıfır anında yapılan harcama zaten bugünkü değerdir; yalnız sonraki yılların nakit akışları iskonto edilir.

## 2. İç verim oranı

**İç verim oranı (İVO)**, projenin NBD'sini sıfıra eşitleyen iskonto oranıdır. Başka bir ifadeyle nakit girişlerinin bugünkü değerini ilk yatırıma eşitleyen orandır:

- Σ NAt / (1 + İVO)^t − I0 = 0

Karar kuralı: İVO > sermaye maliyeti ise proje kabul edilir. Nakit akışları eşit değilse İVO formülle doğrudan çözülemez; ya deneme-yanılma ile ya da finansal hesap makinesi ve tablolama programıyla bulunur.

### Deneme ve doğrusal enterpolasyon

Sınavda kullanılan yöntem şudur: NBD'yi pozitif yapan bir oran (r1) ile negatif yapan bir oran (r2) bulunur ve arada doğrusal enterpolasyon yapılır:

- İVO ≈ r1 + (r2 − r1) × NBD1 / (NBD1 − NBD2)

Örnekteki projede yüzde 15'te NBD = 643,58 TL, yüzde 16'da NBD = −1.332,71 TL'dir. Enterpolasyonla İVO ≈ 0,15 + 0,01 × 643,58 / 1.976,29 ≈ yüzde 15,33 bulunur. Bilgisayarla bulunan kesin değer yaklaşık yüzde 15,32'dir; aradaki küçük fark, NBD eğrisinin doğrusal olmamasından kaynaklanır. Bu nedenle enterpolasyon aralığı dar (1 puan) seçilmelidir. İVO sermaye maliyetinden (yüzde 10) yüksek olduğu için proje kabul edilir.

### İVO'nun sınırları

İVO, ara nakit akışlarının yine İVO ile yeniden yatırıldığını varsayar. İşaret birden fazla değişen (alışılmamış) nakit akışlarında birden çok İVO çıkabilir. Birbirini dışlayan ve büyüklüğü farklı projelerde NBD ile İVO farklı sıralama verebilir; bu çatışmada NBD tercih edilir. Yeniden yatırım sorununu gidermek için **düzeltilmiş iç verim oranı** (ara akışların sermaye maliyetiyle yeniden yatırıldığını varsayan oran) kullanılabilir.

> **Sınav ipucu:** Bağımsız ve alışılmış nakit akışlı bir projede NBD ile İVO her zaman aynı kabul/ret kararını verir. Çatışma yalnız birbirini dışlayan projelerin sıralamasında ortaya çıkar.

## 3. Geri ödeme süresi

**Geri ödeme süresi**, ilk yatırımın projenin nakit girişleriyle kaç yılda geri kazanıldığını gösterir. Kümülatif nakit akışları ilk yatırıma ulaşana kadar toplanır; son yıl için kesir, yıl içinde akışların düzenli geldiği varsayımıyla bulunur.

Örnekte ilk iki yılın kümülatif girişi 70.000 TL'dir. Kalan 30.000 TL, üçüncü yılın 50.000 TL'lik girişinden karşılanır: 2 + 30.000 / 50.000 = 2,6 yıl. Karar kuralı: hesaplanan süre işletmenin belirlediği azami süreden kısaysa proje kabul edilir.

Yöntem basit ve likidite riskini öne çıkardığı için yaygındır; ancak paranın zaman değerini ve geri ödeme sonrasındaki nakit akışlarını dikkate almaz. Birinci eksikliği gidermek için **iskontolu geri ödeme süresi** kullanılır: kümülatif toplam, iskonto edilmiş akışlarla yapılır. Örnekte ilk üç yılın bugünkü değerleri toplamı 97.896,32 TL'dir; kalan 2.103,68 TL dördüncü yılın 13.660,27 TL'lik bugünkü değerinden karşılanır: 3 + 2.103,68 / 13.660,27 ≈ 3,15 yıl.

## 4. Karlılık endeksi

**Karlılık endeksi (KE)**, nakit girişlerinin bugünkü değerinin ilk yatırıma oranıdır; yatırılan her bir liranın bugünkü değer cinsinden ne kadar getiri sağladığını gösterir:

- KE = [Σ NAt / (1 + r)^t] / I0

Karar kuralı: KE > 1 ise proje kabul edilir. KE > 1 ile NBD > 0 aynı anlamı taşır. Örnekte KE = 111.556,59 / 100.000 ≈ 1,1156'dır; proje kabul edilir.

Karlılık endeksi özellikle **sermaye kısıtı** (bütçe sınırı) altında projeleri sıralamada işe yarar: bütçe yetmediğinde KE'si yüksek projelerden başlanarak seçim yapılır. İstisna olarak, birbirini dışlayan ve büyüklüğü farklı projelerde KE, NBD ile çelişebilir; bu durumda yine NBD esas alınır.

| Yöntem | Kabul kuralı | Zaman değeri |
|---|---|---|
| Net bugünkü değer | NBD > 0 | Dikkate alır |
| İç verim oranı | İVO > sermaye maliyeti | Dikkate alır |
| Karlılık endeksi | KE > 1 | Dikkate alır |
| Geri ödeme süresi | Süre < azami süre | Dikkate almaz |

## 5. Yatırım projelerinde nakit akışı tahmini

Yöntemlerin hepsi doğru tahmin edilmiş nakit akışına dayanır. **Artımsal (ilave) nakit akışı ilkesi**: yalnız proje kabul edildiği için ortaya çıkacak nakit akışları hesaba katılır. Bu ilkenin sonuçları şunlardır:

- **Batık maliyetler** (proje kararından önce yapılmış ve geri alınamayacak harcamalar, ör. yapılmış fizibilite etüdü) dikkate alınmaz.
- **Fırsat maliyetleri** (ör. projede kullanılacak işletmeye ait arsanın alternatif kira geliri) dikkate alınır.
- **Net işletme sermayesi** artışı başlangıçta nakit çıkışı, proje sonunda geri dönüşü nakit girişi sayılır.
- Finansman giderleri (faiz) nakit akışına yazılmaz; finansman maliyeti iskonto oranının içindedir.

Proje nakit akışı üç kısımdan oluşur: başlangıç yatırımı, yıllık faaliyet nakit akışı ve proje sonu akışları (hurda değer ile işletme sermayesinin geri dönüşü). Amortisman nakit çıkışı değildir; ancak vergiyi azalttığı için faaliyet nakit akışını etkiler:

- Faaliyet nakit akışı = (Satışlar − Nakit giderler − Amortisman) × (1 − t) + Amortisman

Aşağıdaki örnekte vergi oranı **yalnız hesap amacıyla varsayılan yüzde 30** olarak alınmıştır; bu oran yürürlükteki bir vergi oranını göstermez. Yıllık satışlar 80.000 TL, nakit giderler 40.000 TL, amortisman 25.000 TL ise vergi öncesi kâr 15.000 TL, vergi 4.500 TL, net kâr 10.500 TL olur. Faaliyet nakit akışı 10.500 + 25.000 = 35.500 TL'dir.

> **Sık yapılan hata:** Amortismanı nakit çıkışı gibi düşmek ya da kredi faizini hem nakit akışına hem iskonto oranına yansıtarak finansman maliyetini iki kez saymak.

### Tasdik uygulama notu

YMM'ler sermaye bütçelemesi tablolarıyla özellikle yatırım teşvik belgeli projelerde, teşvik kapsamındaki yatırım harcamalarının tespitinde ve fizibilite raporlarının incelenmesinde karşılaşır. Kontrolde proje tutarının ve yatırım harcamalarının belgelerle uyumu, nakit akışı tahminlerinde batık maliyet ile finansman giderinin dışarıda tutulup tutulmadığı, amortismanın faaliyet nakit akışına doğru yansıtılıp yansıtılmadığı ve iskonto oranının gerekçesi incelenir. NBD ve İVO hesapları çalışma kâğıtlarında yeniden yapılarak doğrulanır.

## Özet

- NBD = Σ NAt / (1 + r)^t − I0; akışlar yıl sonunda varsayılır; NBD > 0 ise kabul.
- İVO, NBD'yi sıfırlayan orandır; enterpolasyon yaklaşık sonuç verir, aralık dar seçilmelidir.
- Birbirini dışlayan projelerde NBD ile İVO çatışırsa NBD esas alınır.
- Geri ödeme süresi zaman değerini ve sonraki akışları yok sayar; iskontolu türü ilk eksikliği giderir.
- KE = girişlerin bugünkü değeri / I0; KE > 1 ile NBD > 0 eşdeğerdir, sermaye kısıtında sıralama aracıdır.
- Nakit akışı artımsal esasla tahmin edilir: batık maliyet hariç, fırsat maliyeti ve işletme sermayesi dahil, faiz hariç.
