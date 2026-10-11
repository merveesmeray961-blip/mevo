---
ders: "MAL"
konu: "STD"
baslik: "Standart maliyet ve sapmalar"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 21"
    alinti: "Standart maliyetler; hammadde ve malzemenin, işçiliğin, etkinliğin ve kapasite kullanımının normal düzeylerini dikkate alır."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "7/A Seçeneği, Fark hesapları"
    alinti: "fiili giderler ile önceden saptanmış giderler arasındaki farkların kaydedildiği hesaplardır"
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "712 Direkt İlkmadde ve Malzeme Fiyat Farkı"
    alinti: "Olumsuz fiyat farkları bu hesabın borcuna, olumlu fiyat farkları ise alacağına kaydedilir."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "713 Direkt İlkmadde ve Malzeme Miktar Farkı"
    alinti: "Olumsuz miktar farkları hesabın borcuna, olumlu farklar ise alacağına kaydedilir."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "722 Direkt İşçilik Ücret Farkları"
    alinti: "Bu hesap dönem sonlarında ilgili stok ve satış maliyeti hesaplarına aktarılarak kapatılır."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "723 Direkt İşçilik Süre (Zaman) Farkları"
    alinti: "Olumsuz süre farkları bu hesabın borcuna olumlu süre farkları ise alacağına kaydedilir."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "733 Genel Üretim Giderleri Verimlilik Farkları"
    alinti: "olumlu ya da olumsuz verimlilik farklarının izlendiği hesaptır"
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "734 Genel Üretim Giderleri Kapasite Farkları"
    alinti: "olumlu ya da olumsuz kapasite farklarının izlendiği hesaptır"
---
## Bu konuda neler öğreneceksin

- **Standart maliyetin** anlamını, standart maliyet kartını ve "fiili üretim için izin verilen standart miktar" kavramını
- Direkt ilk madde ve malzeme **fiyat** ve **miktar** sapmalarını (ve karma farkı)
- Direkt işçilik **ücret** ve **zaman (süre)** sapmalarını
- GÜG **bütçe**, **verimlilik** ve **kapasite** sapmalarını
- Sapmaların olumlu/olumsuz yönünü, 71-72-73 grubu kayıtlarını ve dönem sonu kapanışını

## 1. Standart maliyetin mantığı

**Standart maliyet**, bir birim mamulün üretimi için normal koşullarda katlanılması gereken, bilimsel ve teknik incelemelerle **önceden saptanmış** maliyettir. Her maliyet unsuru için iki standart belirlenir: **miktar standardı** (kg, saat) ve **fiyat standardı** (TL/kg, TL/saat). TMS 2 paragraf 21'e göre standart maliyetler, sonuçlar maliyete yakın olduğu sürece stok ölçümünde kullanılabilir ve malzeme, işçilik, etkinlik ve kapasite kullanımının **normal** düzeylerini dikkate alır; düzenli olarak gözden geçirilir.

Standartlar ideal (hiç kayıp ve beklemenin olmadığı) düzeyde değil, ulaşılabilir normal düzeyde belirlenmelidir. Amaç, fiili sonuçları standartla karşılaştırıp **sapmaların (farkların)** nedenini ve sorumlusunu bulmaktır: fiyat sapması genellikle satın alma, miktar ve zaman sapmaları üretim, kapasite sapması yönetim sorumluluğundadır.

Sapma hesabındaki en kritik kavram **standart miktar (SM)** veya **standart süredir (SS)**: Fiili üretim miktarı × birim başına standart miktar. Bütçelenen üretim değil, **fiilen üretilen** miktar esas alınır.

Kısaltmalar: FM fiili miktar, SM standart miktar, FF fiili fiyat, SF standart fiyat, FS fiili süre, SS standart süre, FÜ fiili ücret, SÜ standart ücret. Formüllerde fark **fiili eksi standart** kurulur: sonuç pozitifse **olumsuz**, negatifse **olumlu** sapmadır.

## 2. Direkt ilk madde ve malzeme sapmaları

**Fiyat sapması = (FF − SF) × FM**

**Miktar sapması = (FM − SM) × SF**

**Toplam sapma = (FM × FF) − (SM × SF)** = fiyat sapması + miktar sapması

### Çözümlü örnek

Birim mamul için standart: 2 kg × 10 TL. Fiili üretim 5.000 birim; fiilen 10.400 kg malzeme kg'ı 9,50 TL'den kullanılmıştır.

1. SM = 5.000 × 2 = **10.000 kg**
2. Fiili maliyet = 10.400 × 9,50 = **98.800 TL**
3. Standart maliyet = 10.000 × 10 = **100.000 TL**
4. Toplam sapma = 98.800 − 100.000 = **1.200 TL olumlu**
5. Fiyat sapması = (9,50 − 10) × 10.400 = **5.200 TL olumlu**
6. Miktar sapması = (10.400 − 10.000) × 10 = **4.000 TL olumsuz**
7. Kontrol: −5.200 + 4.000 = −1.200 (olumlu)

Toplam sapmanın olumlu olması her şeyin iyi gittiğini göstermez: ucuz alım (olumlu fiyat) belki düşük kaliteli malzeme nedeniyle fazla tüketime (olumsuz miktar) yol açmıştır.

**Karma (birleşik) fark:** Bazı kaynaklar sapmayı üçe ayırır: saf fiyat farkı (FF − SF) × SM = −0,50 × 10.000 = −5.000; miktar farkı 4.000; karma fark (FF − SF) × (FM − SM) = −0,50 × 400 = −200. Toplam yine −1.200'dür. İkili ayrımda karma fark fiyat sapmasının içindedir; bu nedenle fiyat sapmasında **fiili miktar** kullanılır.

**Kayıtlar (7/A):**

1. Fiili kullanım: **710** borç 98.800 / **150 İlk Madde ve Malzeme** alacak 98.800
2. Standart tutarın üretime yüklenmesi: **151** borç 100.000 / **711** alacak 100.000
3. Dönem sonu: **711** borç 100.000, **713** borç 4.000 / **710** alacak 98.800, **712** alacak 5.200

Fiyat sapması satın alma anında ayrılıyorsa (stok standart fiyatla kaydediliyorsa) hesaplama **satın alınan miktar** üzerinden yapılır; soru kökündeki "satın alınan" ve "kullanılan" miktar ayrımına dikkat et.

> **Sık yapılan hata:** Miktar sapmasını fiili fiyatla değerlemek veya SM yerine bütçelenen üretimin standart miktarını kullanmak. Miktar sapması **standart fiyatla**, fiyat sapması **fiili miktarla** hesaplanır; SM her zaman **fiili üretime** göre bulunur.

## 3. Direkt işçilik sapmaları

**Ücret sapması = (FÜ − SÜ) × FS**

**Zaman (süre) sapması = (FS − SS) × SÜ**

### Çözümlü örnek

Birim mamul için standart: 1,5 saat × 40 TL. Fiili üretim 5.000 birim; fiilen 7.200 saat, saati 42 TL'den çalışılmıştır.

1. SS = 5.000 × 1,5 = **7.500 saat**
2. Fiili işçilik = 7.200 × 42 = **302.400 TL**; standart işçilik = 7.500 × 40 = **300.000 TL**
3. Toplam sapma = **2.400 TL olumsuz**
4. Ücret sapması = (42 − 40) × 7.200 = **14.400 TL olumsuz**
5. Zaman sapması = (7.200 − 7.500) × 40 = **12.000 TL olumlu**
6. Kontrol: 14.400 − 12.000 = 2.400 (olumsuz)

**Kayıtlar:** Fiili işçilik **720** borç 302.400; standart yükleme **151** borç / **721** alacak 300.000; dönem sonu **721** borç 300.000, **722** borç 14.400 / **720** alacak 302.400, **723** alacak 12.000.

> **Sınav ipucu:** "Ücret" saat ücretindeki, "zaman/süre" çalışılan saatteki farkı gösterir. Ücret sapmasında **fiili saat**, zaman sapmasında **standart ücret** kullanılır; yapı ilk madde formülleriyle birebir aynıdır.

## 4. GÜG sapmaları

GÜG, bir faaliyet ölçüsü (çoğunlukla DİŞ saati veya makine saati) üzerinden **standart GÜG yükleme oranıyla** yüklenir:

- Sabit GÜG oranı = Bütçelenen sabit GÜG / Normal kapasite (saat)
- Standart GÜG yükleme oranı = Sabit oran + Değişken oran
- Maliyetlere yüklenen GÜG = SS × standart GÜG yükleme oranı
- Toplam GÜG sapması = Fiili GÜG − Yüklenen GÜG

Türkiye'deki ders kitaplarında ve THP'de toplam GÜG sapması üçe ayrılır:

| Sapma | Formül | Hesap |
|---|---|---|
| Bütçe farkı | Fiili GÜG − (Bütçelenen sabit GÜG + Değişken oran × FS) | 732 |
| Kapasite farkı | (Normal kapasite − FS) × Sabit GÜG oranı | 734 |
| Verimlilik farkı | (FS − SS) × Standart GÜG yükleme oranı | 733 |

Bütçe farkı, fiili gideri **fiili saate göre ayarlanmış (esnek) bütçe** ile karşılaştırır; harcama kontrolünü ölçer. Kapasite farkı, normal kapasitenin altında çalışıldığında sabit giderin eksik yüklenmesini gösterir. Verimlilik farkı, fiili üretim için gerekenden fazla veya az saat çalışılmasının GÜG'ye etkisidir.

### Çözümlü örnek

Normal kapasite 8.000 DİŞ saati; bütçelenen sabit GÜG 160.000 TL (sabit oran 20 TL/saat); değişken GÜG oranı 12 TL/saat; standart GÜG yükleme oranı 32 TL/saat. Yukarıdaki işçilik verileri geçerlidir: FS 7.200, SS 7.500. Fiili GÜG 250.000 TL'dir.

1. Yüklenen GÜG = 7.500 × 32 = **240.000 TL**
2. Toplam sapma = 250.000 − 240.000 = **10.000 TL olumsuz**
3. Fiili saate göre bütçe = 160.000 + 12 × 7.200 = **246.400 TL**
4. Bütçe farkı = 250.000 − 246.400 = **3.600 TL olumsuz** (732)
5. Kapasite farkı = (8.000 − 7.200) × 20 = **16.000 TL olumsuz** (734)
6. Verimlilik farkı = (7.200 − 7.500) × 32 = **9.600 TL olumlu** (733)
7. Kontrol: 3.600 + 16.000 − 9.600 = **10.000 TL olumsuz**

Kapasite farkı ayrıca şöyle de bulunur: Fiili saate göre bütçe − FS × standart oran = 246.400 − 230.400 = 16.000.

**Dönem sonu kaydı:** **731** borç 240.000, **732** borç 3.600, **734** borç 16.000 / **730** alacak 250.000, **733** alacak 9.600.

> **Sınav ipucu:** Hesap kodlarını sapma türüyle eşle: 712 fiyat, 713 miktar, 722 ücret, 723 süre (zaman), 732 bütçe, 733 verimlilik, 734 kapasite. "73**3** verimlilik, 73**4** kapasite" sırası sık sorulur.

## 5. Olumlu/olumsuz sapma ve dönem sonu

THP'ye göre bütün fark hesaplarında **olumsuz farklar borca, olumlu farklar alacağa** kaydedilir; fark hesapları borç veya alacak kalanı verebilir. Dönem sonunda fark hesapları **ilgili stok (151, 152) ve satış maliyeti** hesaplarına aktarılarak kapatılır; böylece stoklar ve satılan mamul maliyeti fiili maliyete yaklaştırılır.

Fiili tutar standarttan büyükse fark **olumsuzdur**, maliyeti artırır ve kârı azaltır. Fiili tutar standarttan küçükse fark **olumludur**. Fark hesapları bir gelir veya gider hesabı değildir; yansıtma hesabı (711, 721, 731) standart tutarı, gider hesabı (710, 720, 730) fiili tutarı taşır, fark hesabı aradaki farkı kapatır.

> **Sık yapılan hata:** Olumsuz farkı "zarar gibi alacağa" yazmak. Kayıtta fiili gider hesabı (710/720/730) alacaklanırken standart tutar (711/721/731) borçlanır; fiili büyükse eksik kalan borç tarafı fark hesabının **borcuyla** tamamlanır.

## 6. Çözüm şablonu

1. Fiili üretimi bul; SM ve SS'yi **fiili üretime** göre hesapla.
2. Her unsur için fiili ve standart toplamı yaz, toplam sapmayı bul.
3. İlk maddede fiyat/miktar, işçilikte ücret/zaman, GÜG'de bütçe/kapasite/verimlilik ayrımını yap.
4. Alt sapmaların toplamının toplam sapmaya eşit olduğunu kontrol et.
5. Yönü (fiili eksi standart) ve hesap kodunu belirle.

## Özet

- **Standart maliyet**, normal koşullarda önceden saptanmış birim maliyettir; SM ve SS daima fiili üretime göre hesaplanır.
- İlk madde: **fiyat = (FF − SF) × FM** (712), **miktar = (FM − SM) × SF** (713).
- İşçilik: **ücret = (FÜ − SÜ) × FS** (722), **zaman = (FS − SS) × SÜ** (723).
- GÜG: **bütçe** = fiili GÜG − fiili saate göre bütçe (732); **kapasite** = (normal kapasite − FS) × sabit oran (734); **verimlilik** = (FS − SS) × standart oran (733).
- Fiili standarttan büyükse olumsuz (borç), küçükse olumlu (alacak) fark.
- Fark hesapları dönem sonunda ilgili stok ve satış maliyeti hesaplarına aktarılarak kapatılır.
- Alt sapmaların toplamı daima toplam sapmaya eşittir; bu kontrol işlem hatasını yakalar.
