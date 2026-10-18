---
ders: YNM
konu: MSS
baslik: "Maliyet sistemleri ve maliyet akışı"
durum: taslak
yazar: mevo-editor
kaynaklar:
  - mevzuat: "Genel bilgi — Sipariş ve safha maliyet sistemleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Genel üretim giderlerinin yüklenmesi"
    madde: "-"
  - mevzuat: "Muhasebe Sistemi Uygulama Genel Tebliği, Tek Düzen Hesap Planı"
    madde: "7. grup maliyet hesapları"
    alinti: "7/A seçeneğinde giderler defter-i kebirde fonksiyon esasına göre, 7/B seçeneğinde ise çeşit esasına göre belirlenmiştir"
  - mevzuat: "Muhasebe Sistemi Uygulama Genel Tebliği, Tek Düzen Hesap Planı"
    madde: "798 ve 799 hesaplarının işleyişi"
    alinti: "Dönem sonlarında \"799- Üretim Maliyet Hesabı\", üretim işletmelerinde 151- Yarı Mamüller Üretim\" ve \"152- Mamüller\" hesaplarına"
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 275"
    alinti: "Mükellefler, imal ettikleri emtianın maliyet bedellerini yukarıki unsurları ihtiva etmek şartiyle diledikleri usulde tayin edebilirler"
---
## Bu konuda neler öğreneceksin

- Sipariş maliyet sisteminde maliyetin iş emri bazında toplanmasını
- Safha maliyet sisteminde eşdeğer birim, normal ve anormal fire hesabını
- Üretilen mamul maliyeti tablosunu ve satılan mamul maliyetine geçişi
- Genel üretim giderlerinin önceden belirlenmiş oranla yüklenmesini ve eksik/fazla yükleme farkını
- Tek Düzen Hesap Planındaki 7/A ve 7/B maliyet hesaplarının işleyişini

## 1. Maliyet unsurları ve maliyet akışı

Üretim maliyeti üç unsurdan oluşur: **direkt ilk madde ve malzeme (DİMM)**, **direkt işçilik (Dİ)** ve **genel üretim giderleri (GÜG)**. Dİ ile GÜG'ün toplamına **dönüştürme maliyeti** denir. Vergi Usul Kanunu (VUK) md. 275 de imal edilen malın maliyetini ham madde, işçilik, genel imal giderlerinden düşen pay ve isteğe bağlı olarak genel idare giderlerinden düşen pay olarak sayar; bu unsurlar korunduğu sürece maliyet yöntemi serbesttir.

Maliyet akışı hesap planında şöyle izlenir: 150 İlk Madde ve Malzeme → üretim maliyeti hesapları (7. grup) → 151 Yarı Mamuller-Üretim → 152 Mamuller → 620 Satılan Mamuller Maliyeti.

## 2. Sipariş maliyet sistemi

**Sipariş (iş emri) maliyet sistemi**, birbirinden farklı ve müşteri isteğine göre üretilen işlerde maliyetin her sipariş için ayrı **sipariş maliyet kartında** toplanmasıdır. Mobilya, matbaa, makine imalatı ve inşaat tipik örneklerdir.

Kurallar:

- DİMM ve Dİ, malzeme çekme fişi ve işçilik zaman kartıyla doğrudan siparişe yazılır.
- GÜG siparişe doğrudan izlenemediğinden önceden belirlenmiş oranla yüklenir (Bölüm 4).
- Tamamlanan siparişin maliyeti 152'ye, teslim edilen siparişin maliyeti 620'ye aktarılır; tamamlanmayan siparişler dönem sonunda 151'de kalır.

Örnek: GÜG yükleme oranı 30 TL / Dİ saati. Dönemde üç sipariş vardır:

| | S-101 | S-102 | S-103 |
|---|---|---|---|
| DİMM | 50.000 | 40.000 | 20.000 |
| Dİ | 30.000 | 25.000 | 10.000 |
| Dİ saati | 1.000 | 800 | 400 |
| GÜG (saat × 30) | 30.000 | 24.000 | 12.000 |
| Toplam | 110.000 | 89.000 | 42.000 |
| Durum | Tamamlandı, satıldı | Tamamlandı, depoda | Devam ediyor |

Sonuç: Satılan mamul maliyeti 110.000 TL, mamul stoku 89.000 TL, yarı mamul stoku 42.000 TL.

## 3. Safha maliyet sistemi ve fire

**Safha (süreç) maliyet sistemi**, aynı türden mamulün kesintisiz ve seri üretildiği işletmelerde (çimento, kimya, tekstil, gıda) maliyetin gider yerleri, yani safhalar itibarıyla toplanıp o safhanın **eşdeğer birim** sayısına bölünmesidir.

**Eşdeğer birim**, yarı mamullerin tamamlanma derecesine göre tam mamul cinsinden ifadesidir. Malzeme çoğu zaman sürecin başında tamamen eklenir; dönüştürme maliyeti süreç boyunca oluşur. Bu yüzden eşdeğer birim unsur bazında ayrı hesaplanır.

**Fire**, üretim sürecinde kaybolan miktardır:

- **Normal fire**: üretimin doğal sonucudur ve önlenemez. Maliyeti sağlam birimlere yüklenir; vergi uygulamasında da maliyet unsurudur.
- **Anormal fire**: dikkatsizlik, arıza gibi önlenebilir nedenlerden doğar. Maliyeti stoklara yüklenmez, dönem gideri (689 Diğer Olağandışı Gider ve Zararlar) olarak yazılır.

Fire sürecin sonunda tespit ediliyorsa tam mamul gibi eşdeğer birime katılır ve maliyeti tamamlanan birimlere yüklenir.

Çözümlü örnek (ağırlıklı ortalama, dönem başı stok yok): Karışım safhasına 10.000 birim girmiştir. 8.000 birim tamamlanmış, 500 birim süreç sonunda normal fire olarak tespit edilmiş, 1.500 birim dönem sonunda yarı mamul kalmıştır (malzeme %100, dönüştürme %40). Maliyetler: DİMM 200.000 TL, dönüştürme 182.000 TL.

| Eşdeğer birim | Malzeme | Dönüştürme |
|---|---|---|
| Tamamlanan | 8.000 | 8.000 |
| Normal fire | 500 | 500 |
| Dönem sonu yarı mamul | 1.500 | 600 |
| Toplam | 10.000 | 9.100 |
| Birim maliyet | 20 TL | 20 TL |

- Tamamlanan: 8.000 × 40 = 320.000 TL; fire payı 500 × 40 = 20.000 TL; tamamlananlara yüklenen toplam **340.000 TL**, birim maliyet 340.000 / 8.000 = **42,50 TL**.
- Dönem sonu yarı mamul: 1.500 × 20 + 600 × 20 = **42.000 TL**.
- Sağlama: 340.000 + 42.000 = 382.000 = 200.000 + 182.000.

> **Sık yapılan hata:** Fire noktasını okumadan dağıtım yapmak. Fire sürecin sonunda tespit ediliyorsa maliyeti yalnız tamamlanan birimlere yüklenir; dönem sonu yarı mamul o noktaya ulaşmamışsa fireden pay almaz. Anormal fireyi stok maliyetinde bırakmak da hatadır.

## 4. Genel üretim giderlerinin yüklenmesi

GÜG, dolaylı malzeme, dolaylı işçilik, amortisman, enerji ve bakım gibi mamule doğrudan izlenemeyen giderlerdir. Fiili tutarı dönem sonunda belli olduğundan dönem içinde **önceden belirlenmiş yükleme oranı** kullanılır:

Yükleme oranı = Tahmini GÜG / Tahmini faaliyet hacmi (Dİ saati, makine saati veya Dİ tutarı)

Örnek: Tahmini GÜG 600.000 TL, tahmini Dİ saati 20.000 saat; oran 30 TL/saat. Fiili çalışma 20.000 saat olduğundan yüklenen GÜG 600.000 TL'dir. Fiili GÜG 630.000 TL çıkmıştır. **Eksik yüklenen GÜG** 30.000 TL'dir.

Farkın kapatılması:

- Önemsizse tamamı satılan mamul maliyetine eklenir.
- Önemliyse yarı mamul, mamul ve satılan mamul maliyeti arasında yüklenen GÜG oranında dağıtılır.
- Fazla yüklemede işlem tersine yapılır.

Birden çok gider yeri varsa önce yardımcı gider yerlerinin giderleri esas üretim yerlerine dağıtılır (birinci ve ikinci dağıtım), sonra her esas gider yeri için ayrı oran hesaplanır.

## 5. Üretilen mamul maliyeti tablosu

Tablo, dönemin üretim maliyetinden satılan mamul maliyetine geçişi gösterir:

| Kalem | TL |
|---|---|
| Dönem başı ilk madde stoku | 40.000 |
| + Dönem içi alış | 300.000 |
| − Dönem sonu ilk madde stoku | 50.000 |
| = Kullanılan DİMM | 290.000 |
| + Direkt işçilik | 180.000 |
| + Genel üretim giderleri | 230.000 |
| = Dönem üretim maliyeti | 700.000 |
| + Dönem başı yarı mamul | 60.000 |
| − Dönem sonu yarı mamul | 80.000 |
| = Üretilen mamul maliyeti | 680.000 |
| + Dönem başı mamul | 100.000 |
| − Dönem sonu mamul | 120.000 |
| = Satılan mamul maliyeti | 660.000 |

> **Sınav ipucu:** "Dönem üretim maliyeti" ile "üretilen mamul maliyeti" farklıdır; aradaki fark yarı mamul stok değişimidir. Soru stok değişiminden geriye hesap isterse tabloyu sondan başa çöz.

## 6. Tek Düzen Hesap Planında 7/A ve 7/B

Tek Düzen Hesap Planı (THP), maliyet hesaplarını iki seçenekle sunar: 7/A'da giderler defter-i kebirde **fonksiyon esasına**, 7/B'de **çeşit esasına** göre izlenir. THP'ye göre 7/A, belirli büyüklüğü aşan üretim ve hizmet işletmeleri için zorunludur; ticaret işletmeleri ve küçük işletmeler 7/B'yi seçebilir.

**7/A işleyişi**: 710 Direkt İlk Madde ve Malzeme Giderleri, 720 Direkt İşçilik Giderleri, 730 Genel Üretim Giderleri borçlanır. Dönem sonunda maliyet unsurları yansıtma hesapları (711, 721, 731) alacağı karşılığında 151'e aktarılır; ana hesaplar yansıtma hesaplarıyla karşılaştırılarak kapatılır. Standart maliyette farklar 712–713, 722–723, 732–734 hesaplarında izlenir.

Kayıt sırası (Bölüm 5 tutarlarıyla, fiili maliyet):

1. 710 borç / 150 alacak 290.000; 720 borç / 335 Personele Borçlar alacak 180.000; 730 borç / çeşitli hesaplar alacak 230.000.
2. 151 borç 700.000 / 711 alacak 290.000, 721 alacak 180.000, 731 alacak 230.000; sonra 711, 721, 731 borç / 710, 720, 730 alacak (kapanış).
3. 152 borç / 151 alacak 680.000.
4. 620 borç / 152 alacak 660.000.

**7/B işleyişi**: giderler 790–797 çeşit hesaplarına borç yazılır. Maliyet döneminde gider dağıtım tablosuna göre 798 Gider Çeşitleri Yansıtma Hesabı alacağı karşılığında üretimle ilgili kısım 799 Üretim Maliyet Hesabına, diğerleri 630, 631, 632 ve 66 grubuna borç yazılır. Dönem sonunda 799, 151 ve 152'ye devredilerek kapatılır.

## 7. YMM uygulama notu

Tam tasdikte maliyet tablosu, yevmiye kayıtları ve stok sayım listeleriyle karşılaştırılır. Kontrol noktaları: GÜG'ün dağıtım anahtarının tutarlılığı, eksik yüklenen GÜG'ün tamamının dönem giderine yazılıp stoklara pay verilmemesi, anormal firenin stok maliyetinde bırakılması ve VUK md. 275'e göre genel idare gideri payının yıllar arasında tutarlı uygulanması. Fire oranının sektör ortalamasını aşması, takdir veya inceleme riskini artırdığı için raporda belgelendirilir.

## Özet

- Maliyet unsurları DİMM, Dİ ve GÜG'dür; Dİ ile GÜG dönüştürme maliyetidir.
- Sipariş sisteminde maliyet iş emri kartında, safha sisteminde gider yeri bazında toplanır.
- Safhada birim maliyet, unsur bazında eşdeğer birime bölünerek bulunur.
- Normal fire sağlam birimlere yüklenir, anormal fire dönem gideridir.
- GÜG önceden belirlenmiş oranla yüklenir; eksik veya fazla yükleme farkı önemliliğe göre kapatılır.
- Üretilen mamul maliyeti tablosu dönem üretim maliyetinden yarı mamul ve mamul stok değişimleriyle satılan mamul maliyetine ulaşır.
- 7/A fonksiyon esaslı, 7/B çeşit esaslıdır; 7/B'de 798 yansıtma ve 799 üretim maliyet hesabı kullanılır.
