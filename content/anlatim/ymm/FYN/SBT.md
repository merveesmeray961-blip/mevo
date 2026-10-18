---
ders: FYN
konu: SBT
baslik: Sermaye bütçelemesi
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Sermaye bütçelemesi: net bugünkü değer"
    madde: "-"
  - mevzuat: "Genel bilgi — İç verim oranı ve düzeltilmiş iç verim oranı"
    madde: "-"
  - mevzuat: "Genel bilgi — Geri ödeme süresi ve karlılık endeksi"
    madde: "-"
  - mevzuat: "Genel bilgi — Yatırım projelerinde nakit akışı tahmini ve makine yenileme"
    madde: "-"
  - mevzuat: "Genel bilgi — Yıllık eşdeğer ve ikame zinciri"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Net bugünkü değer yöntemiyle yatırım kararı vermek
- İç verim oranını enterpolasyonla, düzeltilmiş iç verim oranını (MIRR) formülle bulmak
- Geri ödeme süresini, iskontolu geri ödeme süresini ve karlılık endeksini hesaplamak
- Proje nakit akışlarını artımsal esasla ve vergi etkisiyle tahmin etmek
- Farklı ömürlü projeleri yıllık eşdeğerle karşılaştırmak ve makine yenileme kararı vermek

## 1. Net bugünkü değer

**Sermaye bütçelemesi**, faydası bir yıldan uzun sürecek yatırım harcamalarının değerlendirilip seçilmesidir. **Net bugünkü değer (NBD)**, gelecekteki net nakit akışlarının sermaye maliyetiyle iskonto edilmiş toplamından ilk yatırımın çıkarılmasıdır:

- NBD = Σ NAt / (1 + r)^t − I0

NAt t yılının net nakit akışı, r sermaye maliyeti, I0 ilk yatırımdır. Aksi söylenmedikçe ilk yatırım sıfır anında, sonraki akışlar **yıl sonunda** gerçekleşir. Karar kuralı: NBD > 0 ise kabul; birbirini dışlayan projelerde NBD'si en yüksek olan seçilir.

### Örnek: Bir projenin bütün yöntemlerle değerlendirilmesi

İlk yatırım 100.000 TL; yıl sonu akışları 30.000, 40.000, 50.000 ve 20.000 TL; sermaye maliyeti %10. Tutarlar kuruşa yuvarlanmıştır.

1. Bugünkü değerler: 27.272,73 + 33.057,85 + 37.565,74 + 13.660,27 = 111.556,59 TL.
2. NBD = 111.556,59 − 100.000 = 11.556,59 TL > 0; proje kabul edilir.

> **Sık yapılan hata:** Sıfır anındaki ilk yatırımı da iskonto etmek. Yalnız sonraki yılların akışları iskonto edilir.

## 2. İç verim oranı ve düzeltilmiş iç verim oranı

**İç verim oranı (İVO)**, NBD'yi sıfıra eşitleyen iskonto oranıdır. Karar kuralı: İVO > sermaye maliyeti ise kabul. Akışlar eşit değilse İVO deneme ve **doğrusal enterpolasyonla** bulunur: NBD'yi pozitif yapan r1 ile negatif yapan r2 arasında

- İVO ≈ r1 + (r2 − r1) × NBD1 / (NBD1 − NBD2)

Örnekte %15'te NBD = 643,58 TL, %16'da NBD = −1.332,71 TL'dir. İVO ≈ 0,15 + 0,01 × 643,58 / 1.976,29 ≈ %15,33 (kesin değer %15,32). Sınavda aralık çoğu zaman %5 veya %10 genişlikte verilir; aralık genişledikçe hata büyür ama yöntem aynıdır.

İVO, ara akışların İVO ile yeniden yatırıldığını varsayar; işareti birden fazla değişen akışlarda birden çok İVO çıkabilir. **Düzeltilmiş iç verim oranı (MIRR)** ara akışları sermaye maliyetiyle proje sonuna taşır:

- MIRR = (Girişlerin n yılındaki gelecek değeri / Çıkışların bugünkü değeri)^(1/n) − 1

Örnekte girişlerin 4. yıl sonu değeri: 30.000 × 1,331 + 40.000 × 1,21 + 50.000 × 1,10 + 20.000 = 39.930 + 48.400 + 55.000 + 20.000 = 163.330 TL. MIRR = (163.330 / 100.000)^(1/4) − 1 ≈ %13,05. MIRR %10'u aştığı için proje kabul edilir; MIRR her zaman sermaye maliyeti ile İVO arasında kalır.

> **Sınav ipucu:** Bağımsız ve alışılmış akışlı projede NBD, İVO, MIRR ve KE aynı kabul/ret kararını verir. Çatışma yalnız birbirini dışlayan projelerin sıralamasında çıkar; o zaman NBD esas alınır. Karar tablosunda her yöntemin sonucunu ayrı satırda "kabul/ret" diye yaz; nihai karar cümlesi ayrı puan alır.

## 3. Geri ödeme süresi

**Geri ödeme süresi**, ilk yatırımın kümülatif girişlerle kaç yılda geri kazanıldığıdır. Örnekte ilk iki yılın toplamı 70.000 TL; kalan 30.000 TL üçüncü yılın 50.000 TL'sinden karşılanır: 2 + 30.000 / 50.000 = 2,6 yıl. Yöntem paranın zaman değerini ve geri ödeme sonrasındaki akışları dikkate almaz.

**İskontolu geri ödeme süresi** kümülatif toplamı bugünkü değerlerle yapar: ilk üç yılın bugünkü değeri 97.896,32 TL; kalan 2.103,68 TL dördüncü yılın 13.660,27 TL'sinden karşılanır: 3 + 2.103,68 / 13.660,27 ≈ 3,15 yıl.

## 4. Karlılık endeksi

**Karlılık endeksi (KE)**, girişlerin bugünkü değerinin çıkışların bugünkü değerine oranıdır. Örnekte KE = 111.556,59 / 100.000 ≈ 1,12 > 1; kabul. KE > 1 ile NBD > 0 aynı anlamdadır; KE özellikle **sermaye kısıtı** altında projeleri sıralamada kullanılır.

Yatırım birden fazla döneme yayılıyorsa payda da iskonto edilir. Örnekteki 100.000 TL'nin 60.000 TL'si bugün, 44.000 TL'si birinci yıl sonunda ödenseydi çıkışların bugünkü değeri 60.000 + 44.000 / 1,10 = 100.000 TL olurdu; payda bu tutardır, iskontosuz toplam (104.000 TL) değildir.

## 5. Nakit akışı tahmini ve makine yenileme kararı

**Artımsal nakit akışı ilkesi**: yalnız proje kabul edildiği için ortaya çıkan akışlar hesaba katılır. Batık maliyetler (yapılmış fizibilite etüdü) dışarıda kalır; fırsat maliyetleri (kullanılacak arsanın kira geliri) ve net işletme sermayesi artışı (başta çıkış, sonda giriş) dahil edilir; faiz nakit akışına yazılmaz, çünkü finansman maliyeti iskonto oranının içindedir. Amortisman nakit çıkışı değildir ama vergiyi azaltır:

- Faaliyet nakit akışı = (Satışlar − Nakit giderler − Amortisman) × (1 − t) + Amortisman
- Eşdeğeri: (Nakit giderlerdeki tasarruf) × (1 − t) + Amortisman × t (amortisman vergi kalkanı)

### Örnek: Makine yenileme

Eski makinenin defter değeri 40.000 TL, kalan ömrü 4 yıl (yıllık amortisman 10.000 TL), bugünkü satış değeri 30.000 TL, 4 yıl sonraki hurda değeri sıfırdır. Yeni makine 200.000 TL'dir; 4 yılda doğrusal amortismana tabidir (yıllık 50.000 TL) ve yıllık nakit gideri 60.000 TL azaltır. 4 yıl sonra 20.000 TL'ye satılacaktır (defter değeri sıfır). Vergi oranı %25, sermaye maliyeti %12 alınmıştır.

1. Başlangıç akışı: −200.000 + 30.000 (eski makinenin satışı) + 10.000 × 0,25 (satış zararının vergi tasarrufu 2.500) = −167.500 TL.
2. Yıllık artımsal akış: 60.000 × 0,75 = 45.000 TL; amortisman farkı (50.000 − 10.000) × 0,25 = 10.000 TL vergi kalkanı; toplam 55.000 TL. Eski makinenin kaybedilen 10.000 TL'lik amortismanı bu farkla dikkate alınmış olur.
3. Proje sonu: hurda 20.000 TL tamamen kazanç olduğundan vergi sonrası 20.000 × 0,75 = 15.000 TL.
4. Bugünkü değer: 55.000 × 3,0373 (4 yıl, %12 anüite faktörü) = 167.054,21 TL; 15.000 / 1,12^4 = 9.532,77 TL; toplam 176.586,98 TL.
5. NBD = 176.586,98 − 167.500 = 9.086,98 TL > 0; makine yenilenir.

> **Sık yapılan hata:** Eski makinenin satış bedelini vergi etkisi olmadan almak ya da eski makinenin amortismanını hiç düşmeden yeni makinenin bütün amortismanını vergi kalkanı saymak. Yenileme kararı her kalemde "yeni − eski" farkıyla çözülür.

## 6. Yıllık eşdeğer ve ikame zinciri

Ömürleri farklı, birbirini dışlayan projeler NBD ile doğrudan karşılaştırılamaz. **Yıllık eşdeğer** yöntemi NBD'yi (ya da maliyetlerin bugünkü değerini) proje ömrü boyunca eşit yıllık tutara çevirir:

- Yıllık eşdeğer = NBD / Anüite faktörü(r, n)

Gelir doğuran projelerde yıllık eşdeğer net hasılası büyük olan, yalnız gider içeren seçeneklerde yıllık eşdeğer gideri küçük olan seçilir. **İkame zinciri** ise projeleri ortak ömre (ömürlerin en küçük ortak katına) kadar tekrar ederek NBD'leri karşılaştırır; iki yöntem aynı kararı verir.

### Örnek: Yıllık eşdeğer gider

A makinesi 100.000 TL, 3 yıl ömürlü, yıllık işletme gideri 20.000 TL; B makinesi 150.000 TL, 5 yıl ömürlü, yıllık gideri 15.000 TL; r = %10.

1. A: 100.000 / 2,4869 + 20.000 = 40.211,48 + 20.000 = 60.211,48 TL.
2. B: 150.000 / 3,7908 + 15.000 = 39.569,62 + 15.000 = 54.569,62 TL.
3. B'nin yıllık eşdeğer gideri düşük olduğundan B seçilir. İkame zincirinde ortak ömür 15 yıldır (A beş kez, B üç kez tekrarlanır) ve sonuç aynıdır.

### Tasdik uygulama notu

YMM, sermaye bütçelemesi tablolarıyla yatırım teşvik belgeli projelerde, fizibilite raporlarında ve değerleme raporlarında karşılaşır. Kontrolde yatırım harcamalarının belgelerle uyumu, batık maliyet ve faizin nakit akışından çıkarıldığı, eski varlık satışının vergi etkisi ve amortisman vergi kalkanının doğru yansıtıldığı, iskonto oranının gerekçesi incelenir; NBD ve İVO çalışma kâğıdında yeniden hesaplanır.

## Özet

- NBD = Σ NAt / (1 + r)^t − I0; akışlar yıl sonunda varsayılır; NBD > 0 ise kabul.
- İVO enterpolasyonla bulunur; MIRR = (girişlerin gelecek değeri / çıkışların bugünkü değeri)^(1/n) − 1.
- Birbirini dışlayan projelerde yöntemler çatışırsa NBD esas alınır.
- Geri ödeme süresi zaman değerini yok sayar; iskontolu türü bu eksikliği giderir.
- KE = girişlerin bugünkü değeri / çıkışların bugünkü değeri; çok dönemli yatırımda payda da iskonto edilir.
- Nakit akışı artımsal ve vergi sonrası tahmin edilir; yenileme kararında satış zararı, amortisman farkı ve hurda vergisi hesaba katılır.
- Farklı ömürlü projeler yıllık eşdeğer ya da ikame zinciriyle karşılaştırılır.
