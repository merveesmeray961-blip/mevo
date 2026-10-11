---
ders: "MAL"
konu: "SAF"
baslik: "Safha maliyeti ve eşdeğer birim"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 275"
    alinti: "İmal edilen emtianın (Tam ve yarı mamul mallar) maliyet bedeli aşağıda yazılı unsurları ihtiva eder"
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 25"
    alinti: "ilk giren ilk çıkar (FIFO) veya ağırlıklı ortalama maliyet yöntemi kullanılarak belirlenir"
  - mevzuat: "2 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği"
    madde: "Gelir tablosu dipnotu 9 düzeltmesi"
    alinti: "Maliyet hesaplama sistemleri (safha veya sipariş) ve stok değerleme yöntemleri"
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "151 Yarı Mamuller-Üretim"
    alinti: "Üretimi tamamlananların maliyet tutarı bu hesabın alacağı karşılığında ilgili stok hesaplarına aktarılır."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "152 Mamuller"
    alinti: "Bu hesap, üretimi tamamlanan mamullerin ambarlara alınmasıyla borçlandırılır."
---
## Bu konuda neler öğreneceksin

- **Safha maliyeti** sisteminin hangi üretim yapısında kullanıldığını ve sipariş maliyetinden farkını
- **Eşdeğer birim** kavramını, maliyet unsuru bazında (ilk madde, işçilik, GÜG) ayrı hesaplanmasını
- **Ağırlıklı ortalama** ve **FIFO** yöntemleriyle eşdeğer birim maliyeti, tamamlanan mamul ve dönem sonu yarı mamul maliyetini bulmayı
- Birden fazla safhalı üretimde önceki safhadan devralınan maliyeti
- **Tamamlanma derecesini geri hesaplama** tekniklerini
- 151 ve 152 hesapları arasındaki aktarım kaydını

## 1. Safha maliyeti sistemi

**Safha maliyeti**, aynı türden (homojen) mamullerin kesintisiz biçimde ve birbirini izleyen üretim aşamalarından (safhalardan) geçerek üretildiği işletmelerde kullanılır: çimento, un, şeker, kâğıt, iplik, kimya, rafineri. Maliyetler sipariş bazında değil, **her safha için dönem bazında** toplanır; safhanın dönem maliyeti o safhanın eşdeğer üretim miktarına bölünerek birim maliyet bulunur.

| Özellik | Safha maliyeti | Sipariş maliyeti |
|---|---|---|
| Üretim türü | Homojen, sürekli, seri | Farklı, müşteriye özel |
| Maliyet toplama birimi | Safha (gider yeri) ve dönem | Sipariş (iş emri) |
| Birim maliyet | Dönem maliyeti / eşdeğer birim | Sipariş maliyeti / sipariş miktarı |
| Ana rapor | Safha maliyet raporu | Sipariş maliyet kartı |

Vergi Usul Kanunu md. 275, imal edilen tam ve yarı mamullerin maliyet bedelinin ilk madde, işçilik ve genel imal giderlerinden mamule düşen payı içereceğini belirtir ve bu unsurları içermek şartıyla mükellefe usul seçme serbestisi tanır. TMS 2 paragraf 25'e göre birbirinin yerine geçebilen stokların maliyeti **FIFO** veya **ağırlıklı ortalama** yöntemiyle belirlenir; safha maliyetinde de bu iki yöntem kullanılır. Gelir tablosu dipnotlarında hangi maliyet hesaplama sisteminin (safha veya sipariş) ve hangi stok değerleme yönteminin kullanıldığı açıklanır.

Safha maliyetinde her safha için üç parçalı bir **safha maliyet raporu** hazırlanır:

1. **Miktar raporu (fiziki akış):** Dönem başı yarı mamul (DBYM) + dönemde üretime başlanan = tamamlanıp devredilen + dönem sonu yarı mamul (DSYM) + varsa kayıp.
2. **Eşdeğer birim hesabı:** Her maliyet unsuru için ayrı yapılır.
3. **Maliyet raporu:** Toplam maliyetin tamamlananlara ve DSYM'ye dağıtılması.

## 2. Eşdeğer birim

**Eşdeğer birim**, kısmen tamamlanmış birimlerin tam mamul cinsinden karşılığıdır.

**Eşdeğer birim = Fiziki miktar × Tamamlanma derecesi**

1.000 birim yarı mamul işçilik bakımından %40 tamamlanmışsa işçilik için 400 eşdeğer birimdir. Tamamlanma derecesi **her maliyet unsuru için farklı** olabilir:

- İlk madde **üretimin başında** tamamen konuluyorsa, yarı mamullerin ilk madde tamamlanma derecesi %100'dür.
- İlk madde **safhanın sonunda** ekleniyorsa, yarı mamullerin ilk madde derecesi %0'dır.
- Direkt işçilik ve GÜG çoğunlukla üretim boyunca düzenli oluşur; bu ikisine birlikte **dönüştürme (dönüşüm) maliyeti** denir ve genellikle aynı tamamlanma derecesi verilir.
- Önceki safhadan devralınan birimler, **devralınan maliyet** unsuru bakımından her zaman %100 tamamdır.

> **Sık yapılan hata:** DSYM'nin fiziki adedini doğrudan eşdeğer birim kabul etmek ya da tek bir derece ile bütün unsurları hesaplamak. İlk madde başta konuluyorsa 2.000 birim DSYM ilk madde için 2.000, %40 tamamlanmış dönüşüm için 800 eşdeğer birimdir.

## 3. Ortak örnek verileri

Aşağıdaki veriler hem ağırlıklı ortalama hem FIFO çözümünde kullanılacaktır. İlk madde safhanın başında konulmaktadır.

| Bilgi | Miktar | İlk madde derecesi | Dönüşüm derecesi |
|---|---:|---:|---:|
| DBYM | 1.000 birim | %100 | %60 |
| Dönemde başlanan | 9.000 birim | | |
| Tamamlanan | 8.000 birim | %100 | %100 |
| DSYM | 2.000 birim | %100 | %40 |

Fiziki kontrol: 1.000 + 9.000 = 8.000 + 2.000 = 10.000 birim.

| Maliyet | İlk madde | Dönüşüm | Toplam |
|---|---:|---:|---:|
| DBYM maliyeti | 22.000 TL | 26.800 TL | 48.800 TL |
| Dönem içi maliyet | 180.000 TL | 246.000 TL | 426.000 TL |
| Toplam | 202.000 TL | 272.800 TL | 474.800 TL |

## 4. Ağırlıklı ortalama yöntemi

Ağırlıklı ortalamada DBYM maliyeti ile dönem maliyeti **tek havuzda** toplanır; DBYM'nin geçen dönemde mi bu dönemde mi işlendiği ayrılmaz.

**Eşdeğer birim (ortalama) = Tamamlanan + DSYM × derece**

**Birim maliyet = (DBYM maliyeti + Dönem maliyeti) / Eşdeğer birim**

1. İlk madde eşdeğer birimi = 8.000 + 2.000 × %100 = **10.000**
2. Dönüşüm eşdeğer birimi = 8.000 + 2.000 × %40 = **8.800**
3. İlk madde birim maliyeti = 202.000 / 10.000 = **20,20 TL**
4. Dönüşüm birim maliyeti = 272.800 / 8.800 = **31,00 TL**
5. Tam birim maliyet = 20,20 + 31,00 = **51,20 TL**
6. Tamamlanan mamul maliyeti = 8.000 × 51,20 = **409.600 TL**
7. DSYM maliyeti = (2.000 × 20,20) + (800 × 31,00) = 40.400 + 24.800 = **65.200 TL**
8. Kontrol: 409.600 + 65.200 = **474.800 TL**

## 5. FIFO yöntemi

FIFO'da **önce DBYM tamamlanır**. DBYM'nin geçen dönemden getirdiği maliyet ayrı tutulur; birim maliyet yalnızca **bu dönemin maliyeti / bu dönemin eşdeğer üretimi** ile bulunur.

**Eşdeğer birim (FIFO) = Tamamlanan − DBYM × geçen dönemdeki derece + DSYM × derece**

Aynı sonuç şöyle de kurulur: DBYM × (1 − derece) + dönemde başlanıp bitirilen + DSYM × derece.

1. Başlanıp bitirilen = 8.000 − 1.000 = **7.000 birim**
2. İlk madde eşdeğer birimi = 1.000 × %0 + 7.000 + 2.000 × %100 = **9.000**
3. Dönüşüm eşdeğer birimi = 1.000 × %40 + 7.000 + 2.000 × %40 = 400 + 7.000 + 800 = **8.200**
4. İlk madde birim maliyeti = 180.000 / 9.000 = **20 TL**; dönüşüm = 246.000 / 8.200 = **30 TL**
5. DBYM'nin tamamlanma maliyeti = 48.800 + (400 × 30) = **60.800 TL**
6. Başlanıp bitirilenler = 7.000 × (20 + 30) = **350.000 TL**
7. Tamamlanan mamul maliyeti = 60.800 + 350.000 = **410.800 TL**
8. DSYM maliyeti = (2.000 × 20) + (800 × 30) = **64.000 TL**
9. Kontrol: 410.800 + 64.000 = **474.800 TL**

> **Sınav ipucu:** FIFO'da DBYM'nin "yüzde kaç tamamlanmış olarak devraldığı" bilgisi, bu dönemde **kalan kısmı** hesaplamak için kullanılır. DBYM dönüşüm bakımından %60 tamamsa bu dönem 1.000 × %40 = 400 eşdeğer birimlik iş yapılmıştır; 600 değil.

## 6. İki yöntemin karşılaştırılması

| Konu | Ağırlıklı ortalama | FIFO |
|---|---|---|
| DBYM maliyeti | Dönem maliyetine eklenir | Ayrı tutulur, doğrudan tamamlananlara gider |
| Eşdeğer birim | Tamamlanan + DSYM eşdeğeri | Ortalamadaki eşdeğer birim − DBYM'nin geçen dönem eşdeğeri |
| Birim maliyet payı | DBYM + dönem maliyeti | Yalnız dönem maliyeti |
| DSYM değerlemesi | Ortalama birim maliyetle | Cari dönem birim maliyetiyle |

Önemli ilişki: **Ortalama eşdeğer birim − FIFO eşdeğer birim = DBYM × geçen dönemdeki tamamlanma derecesi.** Örnekte dönüşüm için 8.800 − 8.200 = 600 = 1.000 × %60; ilk madde için 10.000 − 9.000 = 1.000 = 1.000 × %100. DBYM yoksa iki yöntem aynı sonucu verir.

## 7. Birden fazla safhalı üretim

İkinci ve sonraki safhalarda, önceki safhadan devralınan birimlerin maliyeti **devralınan maliyet (önceki safha maliyeti)** adlı ayrı bir unsur gibi işlenir. Bu unsurun tamamlanma derecesi DSYM için de %100 kabul edilir. Örneğin I. safha ortalama yönteme göre 8.000 birimi 409.600 TL ile II. safhaya devretmişse, II. safhada bu 409.600 TL ayrı sütunda toplanır; II. safhanın kendi işçilik ve GÜG'si ise II. safhadaki tamamlanma derecelerine göre eşdeğer birime dağıtılır.

Kayıt akışı: Safhalar arası devirde 151 hesabının safha alt hesapları arasında aktarma yapılır. **Son safhadan** çıkan tam mamuller için:

- **152 Mamuller** hesabı borçlandırılır,
- **151 Yarı Mamuller-Üretim** hesabı alacaklandırılır.

DSYM maliyeti 151 hesabında borç kalanı olarak kalır ve gelecek dönemin DBYM'sini oluşturur.

## 8. Tamamlanma derecesinin geri hesaplanması

Sınavlarda tamamlanma derecesi çoğu zaman bilinmeyen olarak sorulur. Dört yol vardır (örnek verileri kullanılmıştır):

1. **Toplam eşdeğer birimden:** Ortalama yönteminde dönüşüm eşdeğer birimi 8.800, tamamlanan 8.000 ise DSYM eşdeğeri 800'dür. Derece = 800 / 2.000 = **%40**.
2. **Toplam maliyet ve birim maliyetten:** Ortalama yönteminde toplam dönüşüm maliyeti 272.800 TL ve dönüşüm birim maliyeti 31 TL verilmişse eşdeğer birim = 272.800 / 31 = 8.800 → DSYM eşdeğeri 800 → **%40**.
3. **DSYM maliyetinden:** DSYM maliyeti 65.200 TL, birim maliyetler ilk madde 20,20 TL ve dönüşüm 31 TL ise: (65.200 − 2.000 × 20,20) / 31 = 24.800 / 31 = 800 → **%40**.
4. **İki yöntemin farkından:** Dönüşüm için ortalama eşdeğer birim 8.800, FIFO eşdeğer birim 8.200 ise fark 600 = DBYM × derece → 600 / 1.000 = DBYM'nin geçen dönemdeki derecesi **%60**.

> **Sık yapılan hata:** Geri hesapta önce hangi maliyet unsurunun sorulduğunu belirlememek. İlk madde başta konuluyorsa ilk madde derecesi zaten %100'dür; bilinmeyen derece neredeyse her zaman dönüşüm (işçilik ve GÜG) derecesidir. Ayrıca FIFO'da DBYM'nin **geçen dönemde ulaştığı** derece ile **bu dönemde tamamlanan** kısmı karıştırma.

> **Sınav ipucu:** Soru kökü yöntem söylüyorsa ona uy; "ilk giren ilk çıkar" ifadesi FIFO'yu, "ortalama maliyet" ifadesi ağırlıklı ortalamayı gösterir. Seçeneklerde iki yöntemin sonuçlarının ikisi de bulunabilir; bu yüzden eşdeğer birimi hangi formülle kurduğunu son adımda tekrar kontrol et.

## Özet

- **Safha maliyeti** homojen ve sürekli üretimde kullanılır; maliyetler safha ve dönem bazında toplanır.
- **Eşdeğer birim = fiziki miktar × tamamlanma derecesi**; her maliyet unsuru için ayrı hesaplanır. Başta konulan ilk madde için yarı mamul derecesi %100'dür.
- **Ağırlıklı ortalama:** eşdeğer birim = tamamlanan + DSYM eşdeğeri; birim maliyet = (DBYM + dönem maliyeti) / eşdeğer birim.
- **FIFO:** eşdeğer birim = tamamlanan − DBYM'nin geçen dönem eşdeğeri + DSYM eşdeğeri; birim maliyet = dönem maliyeti / eşdeğer birim; DBYM maliyeti doğrudan tamamlananlara eklenir.
- İki yöntemin eşdeğer birim farkı = DBYM × geçen dönemdeki derece; DBYM yoksa sonuçlar aynıdır.
- Sonraki safhalarda devralınan maliyet ayrı unsurdur ve derecesi %100'dür.
- Tamamlanma derecesi eşdeğer birimden, birim maliyetten, DSYM maliyetinden veya iki yöntem farkından geri bulunabilir.
- Son safhada tamamlananlar **152 Mamuller** borç / **151 Yarı Mamuller-Üretim** alacak kaydıyla aktarılır; DSYM 151'de kalır.
