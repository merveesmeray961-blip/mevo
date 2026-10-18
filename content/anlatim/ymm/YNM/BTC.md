---
ders: YNM
konu: BTC
baslik: Bütçeleme ve standart maliyet
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Bütçeleme ve standart maliyet"
    madde: "-"
  - mevzuat: "Genel bilgi — Esnek bütçe ve sapma analizi"
    madde: "-"
  - mevzuat: "Genel bilgi — Genel üretim gideri sapmaları"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Ana bütçenin bileşenlerini ve hazırlanma sırasını
- Nakit bütçesini hazırlamayı ve finansman ihtiyacını (borçlanma, faiz, geri ödeme) bulmayı
- Statik bütçe ile esnek bütçe arasındaki farkı
- Malzeme ve işçilik sapmalarını fiyat ve miktar bileşenlerine ayırmayı
- Genel üretim gideri sapmalarını sınav anahtarının kullandığı modelle üçlü ve ikili ayrımla hesaplamayı
- Sapmaların toplamının toplam sapmaya eşitliğini kontrol etmeyi

## 1. Ana bütçe

**Ana bütçe** (master bütçe), işletmenin bir dönemlik faaliyet ve finansman planlarını birbirine bağlı bütçeler hâlinde toplayan kapsamlı plandır. İki bölümden oluşur:

- **Faaliyet bütçeleri**: satış, üretim, direkt malzeme kullanım ve satın alma, direkt işçilik, genel üretim gideri, satılan mamul maliyeti, faaliyet giderleri ve bütçelenmiş gelir tablosu.
- **Finansal bütçeler**: nakit bütçesi, yatırım bütçesi ve bütçelenmiş bilanço.

Kural: Hazırlık **satış bütçesiyle** başlar; çünkü diğer bütçeler satış tahminine dayanır. Temel bağlantılar:

- Üretim miktarı = Bütçelenen satış + İstenen dönem sonu mamul stoku − Dönem başı mamul stoku
- Malzeme satın alma miktarı = Üretim için gereken malzeme + İstenen dönem sonu malzeme stoku − Dönem başı malzeme stoku

- Ticari işletmede mal alım bütçesi = Satışların maliyeti + İstenen dönem sonu stok − Dönem başı stok

İstisna: Kapasite, hammadde ya da finansman satıştan daha bağlayıcı bir kısıtsa bütçe bu kısıttan başlatılır. Sonuç verilip satış istenirse aynı eşitliği bilinmeyene göre çöz.

### Nakit bütçesi ve finansman ihtiyacı

**Nakit bütçesi**, dönem başı kasa + tahsilatlar − ödemeler ile bulunan nakit durumunu **asgari kasa** bakiyesiyle karşılaştırır; açık varsa borçlanma, fazla varsa borç geri ödemesi planlanır. Tahsilat ve ödemeler satış ve alımların vade yapısından (ör. %60 peşin, %40 izleyen dönem) türetilir; amortisman nakit çıkışı değildir.

Örnek: Dönem başı kasa 60.000, asgari kasa 50.000 TL. Satışlar Ç1 400.000, Ç2 600.000 TL; %60'ı aynı çeyrek, %40'ı izleyen çeyrek tahsil edilir; dönem başı alacak 150.000 TL Ç1'de tahsil edilir. Alımlar Ç1 250.000, Ç2 300.000 TL; %50'si aynı, %50'si izleyen çeyrek ödenir; dönem başı borç 100.000 TL Ç1'de ödenir. Diğer nakit giderler Ç1 230.000, Ç2 150.000 TL. Borç 10.000 TL'nin katları hâlinde çeyrek başında alınır; faiz çeyreklik %4'tür ve anaparayla birlikte çeyrek sonunda ödenir.

| Kalem | Ç1 | Ç2 |
|---|---|---|
| Dönem başı kasa | 60.000 | 55.000 |
| Tahsilat | 150.000 + 240.000 = 390.000 | 160.000 + 360.000 = 520.000 |
| Alım ödemeleri | 100.000 + 125.000 = 225.000 | 125.000 + 150.000 = 275.000 |
| Diğer giderler | 230.000 | 150.000 |
| Finansman öncesi kasa | −5.000 | 150.000 |
| Borçlanma / (geri ödeme) | 60.000 | (60.000) |
| Faiz | – | (60.000 × %4 × 2 = 4.800) |
| Dönem sonu kasa | 55.000 | 85.200 |

Ç1'de asgari kasaya ulaşmak için 55.000 TL gerekir; 10.000'in katı olarak 60.000 TL borç alınır. Ç2'de fazla nakitle anapara ve iki çeyreklik faiz ödenir; kasa 50.000 TL'nin üzerinde kalır.

## 2. Esnek bütçe

**Statik bütçe**, dönem başında tek bir faaliyet düzeyi için hazırlanan bütçedir. **Esnek bütçe** ise maliyetleri fiili olarak gerçekleşen faaliyet düzeyine göre yeniden hesaplayan bütçedir: değişken maliyetler fiili üretimle orantılı ayarlanır, sabit maliyetler bütçedeki tutarında kalır.

Kural: Performans değerlemesinde fiili maliyet statik bütçeyle değil, fiili üretim düzeyine göre hazırlanmış esnek bütçeyle karşılaştırılır. Aksi hâlde hacim farkı, maliyet kontrolündeki başarı ya da başarısızlıkla karışır.

İstisna: Sabit maliyetler esnek bütçede değişmez; ancak faaliyet ilgili aralığın dışına çıkarsa sabit maliyet de yeni düzeye göre yeniden bütçelenir.

## 3. Standart maliyet ve sapmaların işareti

**Standart maliyet**, bir birim mamulün etkin koşullarda olması gereken önceden belirlenmiş maliyetidir; miktar standardı ile fiyat standardının çarpımıdır. **Sapma** (fark), fiili maliyet ile standart maliyet arasındaki farktır.

Bu anlatımda kullanılan işaret kuralı: Sapma = Fiili − Standart. Sonuç pozitifse sapma **aleyhte** (A, maliyeti artırır), negatifse **lehte** (L, maliyeti azaltır). Bazı kaynaklar Standart − Fiili kullanır; o zaman işaretler ters döner, ama lehte/aleyhte yorumu aynı kalır.

Kısaltmalar: FM fiili miktar, SM fiili üretim için standart miktar, FF fiili fiyat, SF standart fiyat; FS fiili saat, SS fiili üretim için standart saat, FÜ fiili ücret, SÜ standart ücret.

## 4. Malzeme ve işçilik sapmaları

### Malzeme sapmaları

- **Fiyat sapması** = (FF − SF) × FM
- **Miktar sapması** = (FM − SM) × SF
- Toplam = FF × FM − SF × SM

Bu anlatımda fiyat sapması kullanılan miktar üzerinden hesaplanır. Fiyat sapmasını satın alma anında, satın alınan miktar üzerinden ayıran model de yaygındır; o durumda satın alınan ve kullanılan miktar farklıysa fiyat ve miktar sapmalarının toplamı kullanılan malzemenin toplam sapmasına eşit olmaz.

### İşçilik sapmaları

- **Ücret (fiyat) sapması** = (FÜ − SÜ) × FS
- **Süre (verimlilik) sapması** = (FS − SS) × SÜ
- Toplam = FÜ × FS − SÜ × SS

Kural: Fiyat ve ücret sapmaları genellikle satın alma ve personel birimlerinin, miktar ve süre sapmaları üretim biriminin sorumluluğundadır.

İstisna: Ucuz ve kalitesiz malzeme alımı lehte fiyat sapması ile aleyhte miktar ve süre sapmasını birlikte doğurabilir; sorumluluk sapmanın görüldüğü birime değil, nedenine göre belirlenir.

> **Sık yapılan hata:** Miktar sapmasında standart miktarı bütçelenen üretime göre almak. SM ve SS her zaman fiili üretim miktarı × birim standart ile bulunur.

## 5. Genel üretim gideri sapmaları

**Genel üretim gideri** (GÜG) standart maliyete **yükleme oranıyla** aktarılır: Yükleme oranı = Bütçelenen GÜG / Normal kapasite (direkt işçilik saati). Oran değişken ve sabit kısımlara ayrılır. Mamullere yüklenen GÜG = SS × Toplam oran.

Genel üretim gideri sapmaları ekole göre farklı ayrılır. YMM sınavının resmî cevap anahtarları (2022/1 ve 2023/2) **Anglosakson modelini** kullanır; bu anlatımda da varsayılan model budur:

- **Üçlü ayrım**: Harcama (bütçe) farkı = Fiili GÜG − (Sabit bütçe + FS × Değişken oran); **Verimlilik farkı = (FS − SS) × Değişken oran**; **Kapasite (hacim) farkı = (Normal kapasite − SS) × Sabit oran** (= SS'deki esnek bütçe − SS × Toplam oran).
- **İkili ayrım**: Bütçe (kontrol edilebilir) farkı = Fiili GÜG − (Sabit bütçe + SS × Değişken oran); Kapasite (hacim) farkı = (Normal kapasite − SS) × Sabit oran.

Alternatif (Türk ders kitaplarında yaygın) model: Verimlilik = (FS − SS) × Toplam oran, Kapasite = (Normal kapasite − FS) × Sabit oran. Harcama farkı ve toplam sapma iki modelde aynıdır; yalnız verimlilik ile kapasite arasındaki bölüşüm değişir. Model belirtilmemişse Anglosakson modeliyle çöz ve formülü yaz.

> **Sınav ipucu:** Tek Düzen Hesap Planı 7/A seçeneğinde GÜG farkları 732 Genel Üretim Giderleri Bütçe Farkları, 733 Genel Üretim Giderleri Verimlilik Farkları ve 734 Genel Üretim Giderleri Kapasite Farkları hesaplarında ayrı izlenir; olumsuz (aleyhte) farklar borca, olumlu (lehte) farklar alacağa yazılır. Soru hangi modeli istediğini belirtmiyorsa üçlü ayrımı Anglosakson modeliyle kullan ve hangi oranı çarptığını yaz.

### Örnek: Standart maliyet sapmaları

Birim standartlar: direkt malzeme 4 kg × 10 TL = 40 TL; direkt işçilik 2 saat × 50 TL = 100 TL. Normal kapasite 10.000 direkt işçilik saati (5.000 birim); bütçelenen sabit GÜG 200.000 TL, değişken GÜG oranı saat başına 15 TL. Fiili üretim 4.800 birimdir. Fiili veriler: 19.500 kg malzeme × 10,40 TL; 9.800 saat × 49 TL; fiili GÜG 352.000 TL.

1. Oranlar: sabit oran = 200.000 / 10.000 = 20 TL; toplam oran = 15 + 20 = 35 TL. Birim standart maliyet = 40 + 100 + 2 × 35 = 210 TL.
2. SM = 4.800 × 4 = 19.200 kg; SS = 4.800 × 2 = 9.600 saat.
3. Malzeme fiyat sapması = (10,40 − 10) × 19.500 = 7.800 TL A; miktar sapması = (19.500 − 19.200) × 10 = 3.000 TL A. Toplam = 202.800 − 192.000 = 10.800 TL A.
4. İşçilik ücret sapması = (49 − 50) × 9.800 = −9.800 TL L; süre sapması = (9.800 − 9.600) × 50 = 10.000 TL A. Toplam = 480.200 − 480.000 = 200 TL A.
5. Yüklenen GÜG = 9.600 × 35 = 336.000 TL; toplam GÜG sapması = 352.000 − 336.000 = 16.000 TL A.
6. Üçlü ayrım (Anglosakson): FS'ye göre esnek bütçe = 200.000 + 9.800 × 15 = 347.000 TL. Harcama farkı = 352.000 − 347.000 = 5.000 TL A; verimlilik farkı = (9.800 − 9.600) × 15 = 3.000 TL A; kapasite farkı = (10.000 − 9.600) × 20 = 8.000 TL A. Toplam 16.000 TL A. (Alternatif modelde verimlilik 200 × 35 = 7.000 TL A, kapasite (10.000 − 9.800) × 20 = 4.000 TL A; toplam yine 16.000 TL.)
7. İkili ayrım: SS'ye göre esnek bütçe = 200.000 + 9.600 × 15 = 344.000 TL. Bütçe farkı = 352.000 − 344.000 = 8.000 TL A (= harcama 5.000 + verimlilik 3.000); kapasite farkı = 8.000 TL A. Toplam 16.000 TL A.
8. Genel kontrol: fiili toplam maliyet = 202.800 + 480.200 + 352.000 = 1.035.000 TL; standart maliyet = 4.800 × 210 = 1.008.000 TL; fark 27.000 TL A = 10.800 + 200 + 16.000.

### Örnek: Ana bütçe ve esnek bütçe bağlantısı

Aynı işletmede satış 4.900 birim, istenen dönem sonu mamul stoku 500, dönem başı 400 birim bütçelenmiştir.

1. Üretim bütçesi = 4.900 + 500 − 400 = 5.000 birim.
2. Malzeme ihtiyacı = 5.000 × 4 = 20.000 kg; dönem sonu malzeme stoku 1.500 kg, dönem başı 1.000 kg ise satın alma = 20.500 kg × 10 = 205.000 TL.
3. Statik bütçe (5.000 birim): 200.000 + 500.000 + 150.000 + 200.000 = 1.050.000 TL. Fiili 1.035.000 TL ile karşılaştırma 15.000 TL lehte gösterir; bu yanıltıcıdır.
4. Esnek bütçe (4.800 birim): 192.000 + 480.000 + 144.000 + 200.000 = 1.016.000 TL; esnek bütçe farkı = 19.000 TL A.
5. Kontrol: 19.000 = 10.800 + 200 + 8.000 (ikili bütçe farkı). Kalan 8.000 TL kapasite farkıdır: 19.000 + 8.000 = 27.000 TL.

### Tasdik uygulama notu

Vergi Usul Kanunu stokların maliyet bedeliyle değerlenmesini esas aldığından standart maliyet uygulayan işletmede dönem sonu bilançosunda fiili maliyete yaklaştırılmış tutar yer almalıdır. Fark hesapları (712, 713, 722, 723, 732, 733, 734) dönem sonunda 151 Yarı Mamuller, 152 Mamuller ve 620 Satılan Mamuller Maliyeti arasında makul bir ölçüyle dağıtılarak kapatılır. Tam tasdikte bu dağıtım ve atıl kapasiteye bağlı kapasite farkının işlenişi kontrol edilir.

## Özet

- Ana bütçe satış bütçesiyle başlar; üretim = satış + dönem sonu stok − dönem başı stok.
- Esnek bütçe değişken maliyeti fiili hacme göre ayarlar; performans esnek bütçeyle ölçülür.
- İşaret kuralı: Sapma = Fiili − Standart; pozitif aleyhte, negatif lehte.
- Malzeme: fiyat (FF − SF) × FM, miktar (FM − SM) × SF; işçilik: ücret (FÜ − SÜ) × FS, süre (FS − SS) × SÜ.
- GÜG üçlü ayrım (sınav anahtarı modeli): harcama, verimlilik (FS − SS) × değişken oran, kapasite (NK − SS) × sabit oran; ikili ayrım: bütçe ve kapasite (NK − SS) × sabit oran.
- Nakit bütçesinde finansman öncesi kasa asgari kasa ile karşılaştırılır; açık borçla kapatılır, fazla nakitle anapara ve faiz ödenir.
- Fiyat sapması kullanılan miktar üzerinden ayrıldığında sapmaların toplamı fiili maliyet ile standart maliyet farkına eşittir; dönem sonunda stoklar ve satılan mamul maliyeti arasında dağıtılır.
