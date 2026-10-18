---
ders: "MAL"
konu: "SIP"
baslik: "Sipariş maliyeti ve GÜG yükleme/dağıtım"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 24"
    alinti: "Bu yöntem, satın alınmış veya üretilmiş olmasına bakılmaksızın, belirli bir proje için ayrılmış olan stok kalemleri için uygun yöntemdir."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 275"
    alinti: "Genel idare giderlerinden mamule düşen hisse; (Bu hissenin mamulün maliyetine katılması ihtiyaridir.)"
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "730 Genel Üretim Giderleri"
    alinti: "Çeşit ve değer yönü ile doğrudan doğruya değil ancak dağıtım yoluyla üretim ve hizmet maliyetlerine yansıtılabilir nitelikte olması"
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "732 Genel Üretim Giderleri Bütçe Farkları"
    alinti: "Olumsuz farklar hesabın borcuna olumlu farklar ise alacağına kaydedilir."
  - mevzuat: "MSUGT Sıra No: 1, Tek Düzen Hesap Planı"
    madde: "10-99 Gider Yerleri"
    alinti: "Gider yeri, üretim ve hizmetlerin yapıldığı ve maliyetlerin oluştuğu, örgütün bir birimini ya da birim içindeki bir yeri ifade eder."
---
## Bu konuda neler öğreneceksin

- **Sipariş maliyeti** sisteminde sipariş maliyet kartını ve maliyet unsurlarını
- **GÜG yükleme oranını** hesaplamayı ve siparişlere GÜG yüklemeyi
- **Fazla ve eksik yüklemeyi** bulmayı, kaydetmeyi ve yükleme oranını geri hesaplamayı
- **I., II. ve III. gider dağıtımını**; II. dağıtımda doğrudan, kademeli ve matematiksel yöntemleri
- **Gider yeri katsayısı** (yükleme oranı) ile esas gider yerlerinden siparişlere pay vermeyi
- **Faaliyet tabanlı maliyetleme** mantığını ve geleneksel yöntemden farkını

## 1. Sipariş maliyeti sistemi

**Sipariş maliyeti**, birbirinden farklı mamullerin müşteri siparişine göre ve ayrı partiler halinde üretildiği işletmelerde kullanılır: matbaa, mobilya, gemi ve makine imalatı, inşaat, kalıp üretimi. Her sipariş (iş emri) için bir **sipariş maliyet kartı** açılır; kartta siparişe ait direkt ilk madde ve malzeme (DİMM), direkt işçilik (DİŞ) ve yüklenen genel üretim giderleri (GÜG) toplanır. TMS 2 paragraf 23-24'e göre özel projeler için üretilen malların maliyeti, her kalemin kendi özel maliyeti belirlenerek tespit edilir; sipariş maliyeti bu mantığın uygulamasıdır.

- **DİMM ve DİŞ** malzeme çekme fişi ve işçi zaman kartıyla doğrudan siparişe yazılır.
- **GÜG** (endirekt malzeme, endirekt işçilik, amortisman, enerji, bakım vb.) doğrudan izlenemez; Tek Düzen Hesap Planı 730 hesap açıklamasına göre ancak **dağıtım yoluyla** maliyetlere yansıtılır.
- Siparişin maliyeti dönem sonunu beklemeden, sipariş bitince belli olmak zorundadır. Fiili GÜG ise dönem sonunda kesinleşir. Bu nedenle GÜG siparişlere **önceden belirlenmiş yükleme oranıyla** yüklenir.

> **Sınav ipucu:** Çeldirici kalemlere dikkat: pazarlama-satış giderleri, finansman giderleri ve genel yönetim giderleri GÜG değildir. VUK md. 275'e göre genel idare giderlerinden mamule pay verilmesi ihtiyaridir; soruda aksi söylenmedikçe bunları sipariş maliyetine katma.

## 2. GÜG yükleme oranı

**GÜG yükleme oranı = Tahmini (bütçelenen) GÜG / Tahmini faaliyet ölçüsü**

Faaliyet ölçüsü; makine saati, direkt işçilik saati, direkt işçilik tutarı, DİMM tutarı veya üretim miktarı olabilir. Seçilen ölçü, GÜG'nin oluşumuyla en güçlü nedensellik ilişkisine sahip olmalıdır (makine yoğun üretimde makine saati gibi).

**Siparişe yüklenen GÜG = Yükleme oranı × Siparişin fiili faaliyet ölçüsü**

### Çözümlü örnek

Bütçelenen GÜG 600.000 ₺, bütçelenen makine saati (MS) 30.000'dir. Yükleme oranı = 600.000 / 30.000 = **20 ₺/MS**.

| Sipariş | DİMM | DİŞ | Makine saati | Yüklenen GÜG | Sipariş maliyeti |
|---|---:|---:|---:|---:|---:|
| A | 40.000 | 24.000 | 800 | 16.000 | 80.000 |
| B | 65.000 | 30.000 | 1.200 | 24.000 | 119.000 |

A siparişi 400 adetse birim maliyeti 80.000 / 400 = **200 ₺**'dir.

## 3. Fazla ve eksik yükleme

Dönem sonunda fiili GÜG ile siparişlere yüklenen GÜG karşılaştırılır:

- **Eksik yükleme (olumsuz fark):** Fiili GÜG, yüklenen GÜG'den büyüktür.
- **Fazla yükleme (olumlu fark):** Yüklenen GÜG, fiili GÜG'den büyüktür.

Örnek: Dönemde fiilen 29.000 MS çalışılmış, fiili GÜG 610.000 ₺ gerçekleşmiştir. Yüklenen GÜG = 29.000 × 20 = 580.000 ₺. Fark = 610.000 − 580.000 = **30.000 ₺ eksik yükleme**.

7/A seçeneğinde kayıtlar:

1. Fiili giderler tahakkuk ettikçe: **730 Genel Üretim Giderleri** borç 610.000 / ilgili hesaplar alacak.
2. Siparişlere yükleme: **151 Yarı Mamuller-Üretim** borç 580.000 / **731 GÜG Yansıtma** alacak 580.000.
3. Dönem sonu: **731** borç 580.000 ve **732 GÜG Bütçe Farkları** borç 30.000 / **730** alacak 610.000.

THP'ye göre 732'de olumsuz farklar borca, olumlu farklar alacağa yazılır; hesap dönem sonunda ilgili stok (151, 152) ve satış maliyeti hesaplarına aktarılarak kapatılır. Fark önemsizse uygulamada tamamı satılan mamuller maliyetine verilir. Fazla yüklemede fark 732'nin alacağına yazılır ve maliyetler azaltılır.

**Geri hesap örneği:** Fiili GÜG 450.000 ₺, fazla yükleme 30.000 ₺, fiili DİŞ saati 24.000 ise yüklenen GÜG = 450.000 + 30.000 = 480.000 ₺; yükleme oranı = 480.000 / 24.000 = **20 ₺/saat**.

> **Sık yapılan hata:** Fazla yüklemeyi "fiili GÜG fazla" diye okumak. Fazla/eksik kelimesi **yüklenen** tutarı niteler: yüklenen fiiliden fazlaysa fazla yükleme, azsa eksik yüklemedir.

## 4. Gider dağıtımı: I., II. ve III. dağıtım

THP'ye göre **gider yeri**, üretim ve hizmetlerin yapıldığı ve maliyetlerin oluştuğu birimdir. Üretim işletmesinde gider yerleri temel olarak **esas üretim** (mamul üzerinde doğrudan çalışan: kesim, montaj), **yardımcı üretim** ve **yardımcı hizmet** (bakım, enerji, ambar) gider yerleridir.

1. **I. dağıtım:** Gider çeşitleri (malzeme, işçilik, amortisman, enerji vb.) gider yerlerine dağıtılır. Doğrudan izlenebilen gider ilgili yere yazılır; ortak giderler uygun anahtarla (kira için m², enerji için kWh, yemek için personel sayısı) paylaştırılır.
2. **II. dağıtım:** Yardımcı gider yerlerinde toplanan giderler esas üretim gider yerlerine aktarılır.
3. **III. dağıtım:** Esas üretim gider yerlerinin GÜG'si, gider yeri katsayısıyla mamullere (siparişlere) yüklenir.

II. dağıtımda üç yöntem vardır:

- **Doğrudan dağıtım:** Yardımcı gider yerlerinin birbirine verdiği hizmet yok sayılır; giderler yalnız esas gider yerlerine, oranlar yeniden ölçeklenerek dağıtılır.
- **Kademeli (basamaklı) dağıtım:** Yardımcı gider yerleri sıraya konur (genellikle en çok hizmet veren veya gideri en büyük olan önce). İlk sıradaki, sonra gelen yardımcı yerlere de pay verir. **Dağıtımı yapılmış bir gider yerine sonradan pay verilmez**; bu yüzden sonraki yardımcı yerin öndekine verdiği hizmet yok sayılır.
- **Matematiksel (cebirsel, karşılıklı) dağıtım:** Yardımcı gider yerlerinin karşılıklı hizmetleri denklemlerle tam olarak dikkate alınır. En doğru sonucu verir.

### Çözümlü örnek

I. dağıtım sonrası: Bakım (Y1) 42.000 ₺, Enerji (Y2) 30.000 ₺, Kesim (E1) 128.000 ₺, Montaj (E2) 88.000 ₺.

| Hizmet veren | Y1 | Y2 | E1 | E2 |
|---|---:|---:|---:|---:|
| Bakım (Y1) | | %20 | %40 | %40 |
| Enerji (Y2) | %20 | | %50 | %30 |

**Kademeli (önce Bakım):**

1. Bakım 42.000: Y2'ye 8.400, E1'e 16.800, E2'ye 16.800.
2. Enerji yeni toplam = 30.000 + 8.400 = 38.400. Bakım'a geri pay verilmez; oranlar 50:30 olarak yeniden ölçeklenir: E1'e 38.400 × 5/8 = 24.000, E2'ye 38.400 × 3/8 = 14.400.
3. E1 = 128.000 + 16.800 + 24.000 = **168.800**; E2 = 88.000 + 16.800 + 14.400 = **119.200**.

**Matematiksel:**

1. Y1 = 42.000 + 0,20 Y2 ve Y2 = 30.000 + 0,20 Y1
2. Y1 = 42.000 + 0,20 × (30.000 + 0,20 Y1) = 48.000 + 0,04 Y1 → 0,96 Y1 = 48.000 → **Y1 = 50.000**
3. Y2 = 30.000 + 0,20 × 50.000 = **40.000**
4. E1 payı = 50.000 × %40 + 40.000 × %50 = 20.000 + 20.000 = 40.000 → E1 = **168.000**
5. E2 payı = 50.000 × %40 + 40.000 × %30 = 20.000 + 12.000 = 32.000 → E2 = **120.000**

Kontrol: Her iki yöntemde esas gider yerlerine geçen toplam 72.000 ₺'dir (42.000 + 30.000). Matematiksel yöntemde bulunan 50.000 ve 40.000, gider yerlerinin "karşılıklı hizmet dahil" toplamlarıdır; dağıtılan net tutar yine 72.000'dir.

> **Sınav ipucu:** Kademeli yöntemde dağıtım sırası sonucu değiştirir; soru sırayı vermiyorsa genellikle diğer yardımcı yerlere en çok hizmet veren ilk sıraya konur. Matematiksel yöntemde iki bilinmeyenli denklemi kurduktan sonra yalnızca esas gider yerlerine düşen payları topla.

## 5. Gider yeri katsayısı

**Gider yeri katsayısı (yükleme oranı) = Gider yerinin toplam gideri / Gider yerinin faaliyet (hizmet) ölçüsü**

Katsayı II. dağıtımda yardımcı gider yerinin birim hizmet maliyetini (örneğin bakım saati başına maliyet), III. dağıtımda ise esas gider yerinin mamullere yükleme oranını verir.

Örneğe devam (matematiksel sonuçlarla): Kesim'de 8.400 makine saati, Montaj'da 4.800 DİŞ saati çalışılmıştır.

- Kesim katsayısı = 168.000 / 8.400 = **20 ₺/MS**
- Montaj katsayısı = 120.000 / 4.800 = **25 ₺/DİŞ saati**

C siparişi Kesim'de 300 MS, Montaj'da 200 DİŞ saati kullanmışsa yüklenen GÜG = 300 × 20 + 200 × 25 = 6.000 + 5.000 = **11.000 ₺**. Gider yeri bazında katsayı kullanmak, tek fabrika oranına göre daha doğru sonuç verir; çünkü her bölümün maliyet yapısı farklıdır.

## 6. Faaliyet tabanlı maliyetleme (FTM)

**Faaliyet tabanlı maliyetleme**, GÜG'yi tek bir hacim ölçüsüyle dağıtmak yerine önce **faaliyetlere** (kurulum, kalite kontrol, malzeme taşıma, sipariş işleme), sonra faaliyetlerin **maliyet sürücüleri** (kurulum sayısı, kontrol sayısı, taşıma sayısı) aracılığıyla mamullere yükler. Mantığı: "Mamuller faaliyetleri, faaliyetler kaynakları tüketir." Adımlar:

1. Faaliyetleri ve faaliyet maliyet havuzlarını belirle.
2. Her havuz için maliyet sürücüsünü seç.
3. **Faaliyet oranı = Havuz maliyeti / Toplam sürücü miktarı** hesapla.
4. Siparişe yüklenen GÜG = Σ (faaliyet oranı × siparişin kullandığı sürücü miktarı).

| Faaliyet | Maliyet | Toplam sürücü | Faaliyet oranı |
|---|---:|---:|---:|
| Kurulum | 120.000 ₺ | 600 kurulum | 200 ₺ |
| Kalite kontrol | 90.000 ₺ | 300 kontrol | 300 ₺ |
| Taşıma | 60.000 ₺ | 1.200 taşıma | 50 ₺ |

D siparişi 8 kurulum, 5 kontrol, 20 taşıma ve 100 MS kullanmıştır. FTM ile GÜG = 8 × 200 + 5 × 300 + 20 × 50 = 1.600 + 1.500 + 1.000 = **4.100 ₺**. Toplam 270.000 ₺ GÜG fabrika genelinde 9.000 MS ile tek orandan (30 ₺/MS) yüklenseydi D'ye 3.000 ₺ düşerdi. Küçük partili, karmaşık siparişler geleneksel yöntemde **eksik**, büyük hacimli basit siparişler **fazla** maliyetlenir; FTM bu çapraz sübvansiyonu giderir.

> **Sık yapılan hata:** FTM'de bütün GÜG'yi tek bir sürücüye bölmek ya da havuz maliyetini toplam sürücü miktarı yerine siparişin sürücü miktarına bölmek. Her havuzun kendi oranı vardır.

## Özet

- **Sipariş maliyeti** farklı, müşteriye özel üretimde kullanılır; maliyet sipariş maliyet kartında toplanır.
- **GÜG yükleme oranı = tahmini GÜG / tahmini faaliyet ölçüsü**; siparişe yüklenen GÜG = oran × fiili ölçü.
- Fiili GÜG yüklenenden büyükse **eksik**, küçükse **fazla yükleme**; olumsuz fark 732'nin borcuna, olumlu fark alacağına yazılır; dönem sonunda stoklara ve satış maliyetine aktarılır.
- **I. dağıtım** gider çeşitlerini gider yerlerine, **II. dağıtım** yardımcı yerleri esas yerlere, **III. dağıtım** esas yerleri mamullere aktarır.
- **Kademeli** yöntemde dağıtılmış yere geri pay verilmez ve sıra önemlidir; **matematiksel** yöntemde karşılıklı hizmetler denklemle çözülür.
- **Gider yeri katsayısı = gider yeri gideri / faaliyet ölçüsü**.
- **FTM**, GÜG'yi faaliyet havuzları ve maliyet sürücüleriyle yükler; karmaşık, küçük siparişlerin maliyetini daha doğru gösterir.
- Pazarlama, finansman ve genel yönetim giderleri sipariş maliyetine girmez.
