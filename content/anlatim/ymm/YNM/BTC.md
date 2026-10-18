---
ders: YNM
konu: BTC
baslik: Bütçeleme ve standart maliyet
durum: taslak
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
- Statik bütçe ile esnek bütçe arasındaki farkı
- Malzeme ve işçilik sapmalarını fiyat ve miktar bileşenlerine ayırmayı
- Genel üretim gideri sapmalarını üçlü ve ikili ayrımla hesaplamayı
- Sapmaların toplamının toplam sapmaya eşitliğini kontrol etmeyi

## 1. Ana bütçe

**Ana bütçe** (master bütçe), işletmenin bir dönemlik faaliyet ve finansman planlarını birbirine bağlı bütçeler hâlinde toplayan kapsamlı plandır. İki bölümden oluşur:

- **Faaliyet bütçeleri**: satış, üretim, direkt malzeme kullanım ve satın alma, direkt işçilik, genel üretim gideri, satılan mamul maliyeti, faaliyet giderleri ve bütçelenmiş gelir tablosu.
- **Finansal bütçeler**: nakit bütçesi, yatırım bütçesi ve bütçelenmiş bilanço.

Kural: Hazırlık **satış bütçesiyle** başlar; çünkü diğer bütçeler satış tahminine dayanır. Temel bağlantılar:

- Üretim miktarı = Bütçelenen satış + İstenen dönem sonu mamul stoku − Dönem başı mamul stoku
- Malzeme satın alma miktarı = Üretim için gereken malzeme + İstenen dönem sonu malzeme stoku − Dönem başı malzeme stoku

İstisna: Kapasite, hammadde ya da finansman satıştan daha bağlayıcı bir kısıtsa bütçe bu kısıttan başlatılır.

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

Genel üretim gideri sapmaları ekole göre farklı ayrılır; bu anlatımda Türkiye'de yaygın olan model kullanılır:

- **Üçlü ayrım**: Bütçe farkı = Fiili GÜG − (Sabit bütçe + FS × Değişken oran); Kapasite farkı = (Normal kapasite − FS) × Sabit oran; Verimlilik farkı = (FS − SS) × Toplam oran.
- **İkili ayrım**: Bütçe (kontrol edilebilir) farkı = Fiili GÜG − (Sabit bütçe + SS × Değişken oran); Kapasite (hacim) farkı = (Normal kapasite − SS) × Sabit oran.

İstisna: Anglosakson modelinde üçlü ayrımda verimlilik yalnız değişken oranla, hacim farkı ise standart saatle hesaplanır. Her iki modelde de bütçe farkı ile toplam sapma aynıdır; yalnız verimlilik ve kapasite arasındaki bölüşüm değişir.

> **Sınav ipucu:** Tek Düzen Hesap Planı 7/A seçeneğinde GÜG farkları 732 Genel Üretim Giderleri Bütçe Farkları, 733 Genel Üretim Giderleri Verimlilik Farkları ve 734 Genel Üretim Giderleri Kapasite Farkları hesaplarında ayrı izlenir; olumsuz (aleyhte) farklar borca, olumlu (lehte) farklar alacağa yazılır. Soru hangi modeli istediğini belirtmiyorsa üçlü ayrımı kullan ve hangi oranı çarptığını yaz.

### Örnek: Standart maliyet sapmaları

Birim standartlar: direkt malzeme 4 kg × 10 TL = 40 TL; direkt işçilik 2 saat × 50 TL = 100 TL. Normal kapasite 10.000 direkt işçilik saati (5.000 birim); bütçelenen sabit GÜG 200.000 TL, değişken GÜG oranı saat başına 15 TL. Fiili üretim 4.800 birimdir. Fiili veriler: 19.500 kg malzeme × 10,40 TL; 9.800 saat × 49 TL; fiili GÜG 352.000 TL.

1. Oranlar: sabit oran = 200.000 / 10.000 = 20 TL; toplam oran = 15 + 20 = 35 TL. Birim standart maliyet = 40 + 100 + 2 × 35 = 210 TL.
2. SM = 4.800 × 4 = 19.200 kg; SS = 4.800 × 2 = 9.600 saat.
3. Malzeme fiyat sapması = (10,40 − 10) × 19.500 = 7.800 TL A; miktar sapması = (19.500 − 19.200) × 10 = 3.000 TL A. Toplam = 202.800 − 192.000 = 10.800 TL A.
4. İşçilik ücret sapması = (49 − 50) × 9.800 = −9.800 TL L; süre sapması = (9.800 − 9.600) × 50 = 10.000 TL A. Toplam = 480.200 − 480.000 = 200 TL A.
5. Yüklenen GÜG = 9.600 × 35 = 336.000 TL; toplam GÜG sapması = 352.000 − 336.000 = 16.000 TL A.
6. Üçlü ayrım: FS'ye göre esnek bütçe = 200.000 + 9.800 × 15 = 347.000 TL. Bütçe farkı = 352.000 − 347.000 = 5.000 TL A; kapasite farkı = (10.000 − 9.800) × 20 = 4.000 TL A; verimlilik farkı = (9.800 − 9.600) × 35 = 7.000 TL A. Toplam 16.000 TL A.
7. İkili ayrım: SS'ye göre esnek bütçe = 200.000 + 9.600 × 15 = 344.000 TL. Bütçe farkı = 352.000 − 344.000 = 8.000 TL A; kapasite farkı = (10.000 − 9.600) × 20 = 8.000 TL A. Toplam 16.000 TL A.
8. Genel kontrol: fiili toplam maliyet = 202.800 + 480.200 + 352.000 = 1.035.000 TL; standart maliyet = 4.800 × 210 = 1.008.000 TL; fark 27.000 TL A = 10.800 + 200 + 16.000.

### Örnek: Ana bütçe ve esnek bütçe bağlantısı

Aynı işletmede satış 4.900 birim, istenen dönem sonu mamul stoku 500, dönem başı 400 birim bütçelenmiştir.

1. Üretim bütçesi = 4.900 + 500 − 400 = 5.000 birim.
2. Malzeme ihtiyacı = 5.000 × 4 = 20.000 kg; dönem sonu malzeme stoku 1.500 kg, dönem başı 1.000 kg ise satın alma = 20.500 kg × 10 = 205.000 TL.
3. Statik bütçe (5.000 birim): 200.000 + 500.000 + 150.000 + 200.000 = 1.050.000 TL. Fiili 1.035.000 TL ile karşılaştırma 15.000 TL lehte gösterir; bu yanıltıcıdır.
4. Esnek bütçe (4.800 birim): 192.000 + 480.000 + 144.000 + 200.000 = 1.016.000 TL; esnek bütçe farkı = 19.000 TL A.
5. Kontrol: 19.000 = 10.800 + 200 + 8.000 (ikili bütçe farkı). Kalan 8.000 TL kapasite farkıdır: 19.000 + 8.000 = 27.000 TL.

### Tasdik uygulama notu

Vergi Usul Kanunu stokların maliyet bedeliyle değerlenmesini esas aldığından standart maliyet sistemi uygulayan işletmede dönem sonu bilançosunda standart değil, fiili maliyete yaklaştırılmış tutar yer almalıdır. Tek Düzen Hesap Planı'na göre fark hesapları (712, 713, 722, 723, 732, 733, 734) dönem sonunda ilgili stok ve satış maliyeti hesaplarına aktarılarak kapatılır. Tam tasdikte bu kapanışın yapılıp yapılmadığı ve farkların 151 Yarı Mamuller - Üretim, 152 Mamuller ile 620 Satılan Mamuller Maliyeti arasında makul bir ölçüye (genellikle bu kalemlerdeki standart maliyet payına) göre dağıtılıp dağıtılmadığı kontrol edilir. Standartların gerçekçiliği, önemli ve süreklilik gösteren sapmaların nedenleri ile atıl kapasiteye bağlı kapasite farkının nasıl işlendiği çalışma kâğıdında belgelenir.

## Özet

- Ana bütçe satış bütçesiyle başlar; üretim = satış + dönem sonu stok − dönem başı stok.
- Esnek bütçe değişken maliyeti fiili hacme göre ayarlar; performans esnek bütçeyle ölçülür.
- İşaret kuralı: Sapma = Fiili − Standart; pozitif aleyhte, negatif lehte.
- Malzeme: fiyat (FF − SF) × FM, miktar (FM − SM) × SF; işçilik: ücret (FÜ − SÜ) × FS, süre (FS − SS) × SÜ.
- GÜG üçlü ayrım: bütçe, kapasite (NK − FS) × sabit oran, verimlilik (FS − SS) × toplam oran; ikili ayrım: bütçe ve kapasite (NK − SS) × sabit oran.
- Fiyat sapması kullanılan miktar üzerinden ayrıldığında sapmaların toplamı fiili maliyet ile standart maliyet farkına eşittir; dönem sonunda stoklar ve satılan mamul maliyeti arasında dağıtılır.
