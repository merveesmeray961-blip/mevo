---
ders: "MAL"
konu: "DIG"
baslik: "Değişken/tam maliyet"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 13"
    alinti: "Sabit genel üretim giderleri, üretim tesislerinin normal kapasitesi esas alınarak dönüştürme maliyetlerine dağıtılır."
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 13"
    alinti: "Her bir üretim birimine dağıtılan sabit genel gider miktarı, düşük üretim düzeyi veya atıl kapasite nedeniyle arttırılmaz."
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 16(a)"
    alinti: "Normalin üstünde gerçekleşen; hammadde fire ve kayıpları, işçilik ve diğer üretim maliyetleri"
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 27"
    alinti: "Ağırlıklı ortalama, işletmenin koşullarına bağlı olarak, dönemsel olarak veya işletmeye stok girişi oldukça hesaplanabilir."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "680 Çalışmayan Kısım Gider ve Zararları"
    alinti: "Üretimle ilgili giderlerden çalışılmayan döneme ve çalışmayan kısımlara ait giderleri içerir."
---
## Bu konuda neler öğreneceksin

- **Tam**, **değişken** ve **normal maliyet** yöntemlerinde sabit GÜG'nin nereye gittiğini
- İki yöntemin dönem kârını neden ve ne kadar farklı gösterdiğini
- **Maliyet-hacim-kâr (MHK)** analizinde katkı payı, başabaş noktası, hedef kâr ve güvenlik marjını
- **Üretim kayıplarında** normal ve anormal kayıp ayrımını ve maliyetlerinin yüklenmesini
- İlk madde ve malzeme çıkışlarının **FIFO**, **hareketli ortalama** ve dönemsel ağırlıklı ortalama ile değerlenmesini

## 1. Tam, değişken ve normal maliyet yöntemleri

Üç yöntem arasındaki fark, **sabit genel üretim giderlerinin** mamul maliyetine girip girmediği ve ne ölçüde girdiğidir. Direkt ilk madde, direkt işçilik ve değişken GÜG her üç yöntemde de mamul maliyetine girer; pazarlama, yönetim ve finansman giderleri hiçbirinde girmez.

| Yöntem | Sabit GÜG | Kullanım alanı |
|---|---|---|
| Tam maliyet | Tamamı fiili üretime yüklenir | Klasik yöntem; birim maliyet üretim hacmine göre dalgalanır |
| Değişken maliyet | Mamule yüklenmez, tamamı dönem gideri | Yönetim kararları, MHK analizi; dış raporlamada kabul görmez |
| Normal maliyet | Normal kapasiteye göre yüklenir; kullanılmayan kapasite payı dönem gideri | TMS 2 paragraf 13'ün öngördüğü yaklaşım |

TMS 2 paragraf 13'e göre sabit genel üretim giderleri normal kapasite esas alınarak dağıtılır ve birim başına sabit gider **düşük üretim veya atıl kapasite nedeniyle artırılmaz**; dağıtılmayan kısım gerçekleştiği dönemde gider yazılır. Fiili üretim normal kapasiteye yakınsa fiili üretim düzeyi de kullanılabilir; anormal yüksek üretimde ise birim başına sabit gider düşer.

## 2. Tam ve değişken maliyetle kâr hesabı

### Çözümlü örnek

Dönem başı stok yoktur. Üretim 10.000 birim, satış 8.000 birim, satış fiyatı 50 TL. Birim değişken üretim maliyeti 20 TL, sabit GÜG 100.000 TL (birim başına 10 TL). Birim değişken pazarlama gideri 2 TL, sabit faaliyet giderleri 40.000 TL.

**Tam maliyet:** Birim mamul maliyeti = 20 + 10 = 30 TL.

1. Satışlar = 8.000 × 50 = **400.000 TL**
2. Satılan mamul maliyeti = 8.000 × 30 = **240.000 TL** → brüt kâr 160.000 TL
3. Faaliyet giderleri = 8.000 × 2 + 40.000 = **56.000 TL** → faaliyet kârı **104.000 TL**
4. Dönem sonu stok = 2.000 × 30 = **60.000 TL**

**Değişken maliyet:** Birim mamul maliyeti = 20 TL.

1. Değişken giderler = 8.000 × 20 + 8.000 × 2 = **176.000 TL** → katkı payı 400.000 − 176.000 = **224.000 TL**
2. Sabit giderler = 100.000 + 40.000 = **140.000 TL** → faaliyet kârı **84.000 TL**
3. Dönem sonu stok = 2.000 × 20 = **40.000 TL**

**Fark** = 104.000 − 84.000 = **20.000 TL** = stok artışı 2.000 × birim sabit GÜG 10 TL. Tam maliyette 20.000 TL sabit GÜG stokta kalmış, gelecek döneme ertelenmiştir.

| Stok değişimi | Kâr karşılaştırması |
|---|---|
| Üretim satıştan büyük (stok artar) | Tam maliyet kârı daha büyük |
| Üretim satışa eşit | Kârlar eşit |
| Üretim satıştan küçük (stok azalır) | Değişken maliyet kârı daha büyük |

**Kâr farkı = Stok değişimi (birim) × Birim sabit GÜG** formülü, birim sabit GÜG dönemler arasında aynı olduğunda geçerlidir. Farklıysa: Kâr farkı = dönem sonu stoklarındaki (yarı mamul ve mamul) sabit GÜG − dönem başı stoklarındaki sabit GÜG.

> **Sınav ipucu:** "Tam maliyet her zaman daha çok kâr gösterir" yanlıştır; yönü stok değişimi belirler. Değişken maliyette kâr yalnız satış miktarına bağlıdır; üretimi artırarak kâr yükseltilemez.

## 3. Normal maliyet ve kapasite

Aynı örnekte normal kapasite 12.500 birim olsun (fiili üretim 10.000).

1. Sabit GÜG yükleme oranı = 100.000 / 12.500 = **8 TL/birim**
2. Mamullere yüklenen sabit GÜG = 10.000 × 8 = **80.000 TL**; birim maliyet = 20 + 8 = **28 TL**
3. Kullanılmayan (atıl) kapasite maliyeti = 100.000 − 80.000 = **20.000 TL** veya (12.500 − 10.000) × 8

Atıl kapasite payı mamul maliyetine girmez; dönem gideri olarak **680 Çalışmayan Kısım Gider ve Zararları** hesabına alınır. Tam maliyette birim maliyet 30 TL iken normal maliyette 28 TL'dir; fark, düşük üretimin bedelinin stoklara yüklenmemesidir.

> **Sık yapılan hata:** Normal kapasiteyi fiili üretimle karıştırmak. Normal kapasite, planlı bakım-onarım duruşları da dikkate alınarak normal koşullarda birkaç dönemde ulaşılması beklenen **ortalama** üretim düzeyidir.

## 4. Maliyet-hacim-kâr analizi

MHK analizi; satış fiyatı, birim değişken gider ve toplam sabit giderin faaliyet hacmi içinde sabit kaldığı, üretimin satışa eşit olduğu ve (çok ürünlüde) satış karışımının değişmediği varsayımlarına dayanır.

- **Birim katkı payı (KP)** = Satış fiyatı − Birim değişken gider
- **KP oranı** = Birim KP / Satış fiyatı
- **Başabaş miktarı** = Sabit giderler / Birim KP
- **Başabaş tutarı** = Sabit giderler / KP oranı
- **Hedef kâr için miktar** = (Sabit giderler + Hedef kâr) / Birim KP
- Hedef **vergi sonrası** kâr verilmişse önce vergi öncesine çevir: Vergi sonrası kâr / (1 − vergi oranı)
- **Güvenlik marjı** = (Fiili satış − Başabaş satışı) / Fiili satış
- **Faaliyet kaldıracı** = Toplam KP / Faaliyet kârı

### Çözümlü örnek

Satış fiyatı 80 TL, birim değişken gider 50 TL, sabit giderler 90.000 TL.

1. Birim KP = 80 − 50 = **30 TL**; KP oranı = 30 / 80 = **%37,5**
2. Başabaş miktarı = 90.000 / 30 = **3.000 birim**; başabaş tutarı = 90.000 / 0,375 = **240.000 TL**
3. 30.000 TL kâr için: (90.000 + 30.000) / 30 = **4.000 birim**
4. Vergi oranı %20 iken 24.000 TL vergi sonrası kâr için: 24.000 / 0,80 = 30.000 TL vergi öncesi → yine **4.000 birim**
5. Fiili satış 5.000 birim ise güvenlik marjı = (5.000 − 3.000) / 5.000 = **%40**
6. Bu düzeyde toplam KP 150.000, kâr 60.000 → faaliyet kaldıracı = 150.000 / 60.000 = **2,5**. Satışlar %10 artarsa kâr %25 artar.

> **Sık yapılan hata:** Başabaş formülünün paydasına satış fiyatını yazmak veya vergi sonrası hedef kârı doğrudan formüle koymak. Bölen **birim KP**, bölünen ise sabit gider + **vergi öncesi** kârdır.

## 5. Üretim kayıpları

Üretimde buharlaşma, kesim artığı, bozuk ürün gibi kayıplar oluşur. Ayrım, kaybın olağan olup olmadığına göre yapılır:

- **Normal kayıp:** Üretim sürecinin doğasında olan, verimli çalışmada da önlenemeyen kayıptır. Maliyeti **sağlam (iyi) ürünlerin maliyetine** yüklenir; ayrı gider yazılmaz.
- **Anormal kayıp:** Normal sınırı aşan, dikkatsizlik, makine arızası gibi önlenebilir nedenlerden doğan kayıptır. TMS 2 paragraf 16(a)'ya göre normalin üstündeki fire ve kayıplar stok maliyetine girmez, **dönem gideri** yazılır (uygulamada çoğunlukla 689 Diğer Olağandışı Gider ve Zararlar).
- Kayıp birimlerin hurda değeri varsa önce bu değer üretim maliyetinden düşülür.

### Çözümlü örnek

Bir safhada (DBYM ve DSYM yok) 10.000 kg üretime başlanmış, 9.300 kg sağlam ürün tamamlanmıştır. Kayıplar safhanın sonunda kontrolde tespit edilir (tamamlanma %100). Normal kayıp, başlanan miktarın %5'idir. Toplam üretim maliyeti 285.000 TL.

1. Toplam kayıp = 10.000 − 9.300 = **700 kg**
2. Normal kayıp = 10.000 × %5 = **500 kg**; anormal kayıp = 700 − 500 = **200 kg**
3. Birim maliyet = 285.000 / 10.000 = **28,50 TL**
4. Normal kayıp maliyeti = 500 × 28,50 = **14.250 TL** → sağlam ürünlere eklenir
5. Sağlam ürün maliyeti = 9.300 × 28,50 + 14.250 = 265.050 + 14.250 = **279.300 TL** (birim 30,03 TL)
6. Anormal kayıp maliyeti = 200 × 28,50 = **5.700 TL** → dönem gideri
7. Kontrol: 279.300 + 5.700 = **285.000 TL**

> **Sınav ipucu:** Önce normal kaybı hesapla, sonra fiili kayıpla karşılaştır; fiili kaybın tamamını anormal saymak sık yapılan hatadır. Normal kayıp üretim sonunda oluşuyorsa maliyeti yalnızca o dönem **tamamlanan** sağlam ürünlere yüklenir, DSYM'ye pay verilmez.

## 6. İlk madde ve malzeme çıkışlarının değerlenmesi

TMS 2 paragraf 25'e göre birbirinin yerine geçebilen stokların maliyeti **FIFO** veya **ağırlıklı ortalama** ile belirlenir; LIFO bu standartta yer almaz. Paragraf 27'ye göre ağırlıklı ortalama **dönemsel** olarak veya **her stok girişinde** (hareketli ortalama) hesaplanabilir.

### Çözümlü örnek (Mart ayı)

| Tarih | Hareket | Miktar | Birim fiyat |
|---|---|---:|---:|
| 1 Mart | Dönem başı stok | 1.000 kg | 10 TL |
| 5 Mart | Alış | 2.000 kg | 13 TL |
| 10 Mart | Üretime çıkış | 1.800 kg | |
| 20 Mart | Alış | 1.800 kg | 15 TL |
| 25 Mart | Üretime çıkış | 1.500 kg | |

Toplam: 4.800 kg, 63.000 TL; toplam çıkış 3.300 kg; dönem sonu stok 1.500 kg.

**FIFO (ilk giren ilk çıkar):**

1. 10 Mart: 1.000 × 10 + 800 × 13 = **20.400 TL**
2. 25 Mart: 1.200 × 13 + 300 × 15 = **20.100 TL**
3. Toplam çıkış **40.500 TL**; dönem sonu stok 1.500 × 15 = **22.500 TL**

**Hareketli ortalama:**

1. 5 Mart sonrası: 36.000 / 3.000 = **12 TL**; 10 Mart çıkışı 1.800 × 12 = **21.600 TL**; kalan 1.200 kg, 14.400 TL
2. 20 Mart sonrası: (14.400 + 27.000) / 3.000 = **13,80 TL**; 25 Mart çıkışı 1.500 × 13,80 = **20.700 TL**
3. Toplam çıkış **42.300 TL**; dönem sonu stok **20.700 TL**

**Dönemsel ağırlıklı ortalama:** 63.000 / 4.800 = **13,125 TL**; çıkış 3.300 × 13,125 = **43.312,50 TL**; dönem sonu stok **19.687,50 TL**.

Her yöntemde çıkış + dönem sonu stok = 63.000 TL'dir. Fiyatlar yükselirken FIFO üretime en düşük maliyeti aktarır, dönem sonu stoku en yüksek gösterir ve kârı en yüksek çıkarır.

> **Sık yapılan hata:** Hareketli ortalamada birim maliyeti yalnız **girişte** yeniden hesaplamak gerekirken çıkışta da değiştirmek. Çıkış ortalamayı değiştirmez; yeni ortalama ancak yeni bir giriş olduğunda bulunur.

## Özet

- **Tam maliyet** sabit GÜG'nin tamamını, **normal maliyet** normal kapasiteye düşen kısmını mamule yükler; **değişken maliyet** sabit GÜG'yü dönem gideri yapar.
- Atıl kapasite payı stok maliyetine girmez, 680 hesabıyla gider yazılır (TMS 2 paragraf 13).
- Tam ve değişken maliyet kâr farkı = stok değişimi × birim sabit GÜG; stok artıyorsa tam maliyet kârı yüksektir.
- **Başabaş miktarı = sabit gider / birim KP**; hedef kâr sabit gidere (bölünene) eklenir, vergi sonrası kâr önce (1 − t)'ye bölünür.
- **Normal kayıp** sağlam ürünlere yüklenir; **anormal kayıp** dönem gideridir (TMS 2 paragraf 16).
- Malzeme çıkışları FIFO, hareketli ortalama veya dönemsel ağırlıklı ortalama ile değerlenir; LIFO TMS 2'de yoktur.
