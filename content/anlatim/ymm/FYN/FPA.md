---
ders: FYN
konu: FPA
baslik: Finansal analiz planlama ve kâr dağıtımı
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Oran analizi ve oranlardan finansal tablo türetme"
    madde: "-"
  - mevzuat: "Genel bilgi — Başabaş analizi ve kaldıraç dereceleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Proforma tablolar, dış finansman ihtiyacı ve büyüme oranları"
    madde: "-"
  - mevzuat: "Genel bilgi — Nakit akım tablosu, fon akım tablosu ve Altman Z"
    madde: "-"
  - mevzuat: "Genel bilgi — Kâr payı politikası"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Oran analizi yapmak ve verilen oranlardan bilanço türetmek
- Faiz dahil ve çok ürünlü başabaş noktasını, kaldıraç derecelerini hesaplamak
- Satış yüzdesi yöntemiyle proforma tablo ve dış finansman ihtiyacını, içsel ve sürdürülebilir büyüme oranını bulmak
- Dolaysız nakit akım tablosu ile fon akım tablosunu kurmak, Altman Z ile iflas riskini ölçmek
- Kâr payı politikası teorilerini, artık kâr yaklaşımını, bedelsiz hisse ve hisse geri alımını uygulamak

## 1. Oran analizi

**Oran analizi**, tablo kalemleri arasındaki ilişkilerin oranlarla ölçülüp geçmiş ve sektörle karşılaştırılmasıdır. KVYK kısa vadeli, UVYK uzun vadeli yabancı kaynaktır; aksi söylenmedikçe yıl 360 gün alınır.

| Grup | Oran |
|---|---|
| Likidite | Cari oran = Dönen varlık / KVYK; asit-test = (Dönen varlık − Stok) / KVYK; nakit oranı = (Hazır değerler + Menkul kıymetler) / KVYK; stoklara bağımlılık = [KVYK − (Hazır değerler + Menkul kıymetler + Kısa vadeli alacaklar)] / Stok |
| Faaliyet | Stok devir hızı = SMM / Ortalama stok; alacak devir hızı = Kredili satış / Ortalama alacak; tahsil süresi = 360 / Alacak devir hızı; aktif, özkaynak ve net işletme sermayesi (NİS) devir hızı = Satış / ilgili tutar |
| Finansal yapı | Borç (kaldıraç) oranı = Toplam borç / Aktif; Özkaynak / Aktif; KVYK / Aktif; Duran varlık / Devamlı sermaye (Özkaynak + UVYK); faiz karşılama = FVÖK / Faiz |
| Kârlılık | Net kâr marjı; aktif kârlılığı (ROA) = Net kâr / Aktif; özkaynak kârlılığı (ROE) = Net kâr / Özkaynak = ROA × Aktif / Özkaynak |

### Örnek: Oranlardan bilanço türetme

Satışlar 6.000.000 TL; aktif devir hızı 2; özkaynak / aktif 0,40; KVYK / aktif 0,30; cari oran 2; asit-test oranı 1,2; nakit oranı 0,4 (menkul kıymet yok).

1. Aktif = 6.000.000 / 2 = 3.000.000 TL; özkaynak 1.200.000; KVYK 900.000; UVYK 3.000.000 − 1.200.000 − 900.000 = 900.000 TL.
2. Dönen varlık = 2 × 900.000 = 1.800.000; duran varlık 1.200.000 TL.
3. Dönen varlık − Stok = 1,2 × 900.000 = 1.080.000; stok 720.000 TL.
4. Hazır değerler = 0,4 × 900.000 = 360.000; alacaklar 1.080.000 − 360.000 = 720.000 TL.
5. Kontrol oranları: DV / devamlı sermaye = 1.200.000 / 2.100.000 ≈ 0,57; tahsil süresi = 720.000 / (6.000.000 / 360) = 43,2 gün; stoklara bağımlılık = (900.000 − 1.080.000) / 720.000 = −0,25 (negatif: KVYK stok satılmadan ödenebilir).

> **Sınav ipucu:** Tersine oran sorusunda hep "toplamdan parçaya" git: önce satış ve devir hızından aktifi, sonra yapı oranlarından pasifi, en son likidite oranlarından dönen varlık kalemlerini bul.

## 2. Başabaş analizi ve kaldıraç dereceleri

Katkı payı (KP) = Satış − Değişken gider; p birim fiyat, v birim değişken gider, SM sabit faaliyet gideri, F faiz, t vergi oranıdır.

- Faaliyet başabaşı Q = SM / (p − v); faiz dahil başabaş Q = (SM + F) / (p − v)
- Hedef net kârı sağlayan miktar Q = [SM + F + Hedef net kâr / (1 − t)] / (p − v)
- Çok ürünlü başabaş tutarı = SM / Ağırlıklı katkı payı oranı (KPO); ağırlıklar satış karmasıdır
- FAKD = KP / FVÖK; FİKD = FVÖK / (FVÖK − F); BKD = FAKD × FİKD = KP / (FVÖK − F)

### Örnek: Başabaş ve kaldıraç

p = 100 TL, v = 60 TL, SM = 500.000 TL, F = 100.000 TL, satış 20.000 adet, t = %25.

1. Faaliyet başabaşı 500.000 / 40 = 12.500 adet; faiz dahil 600.000 / 40 = 15.000 adet.
2. 210.000 TL net kâr için: [600.000 + 210.000 / 0,75] / 40 = 880.000 / 40 = 22.000 adet.
3. 20.000 adette KP 800.000; FVÖK 300.000; VÖK 200.000 TL. FAKD ≈ 2,67; FİKD = 1,5; BKD = 4. Satış %10 artarsa FVÖK %26,67, hisse başına kâr %40 artar.

Çok ürünlü örnek: A'nın KPO'su %40, B'nin %60; satış karması tutar olarak %60 A, %40 B; SM 960.000 TL. Ağırlıklı KPO = 0,6 × 0,4 + 0,4 × 0,6 = 0,48; başabaş satış 960.000 / 0,48 = 2.000.000 TL (A 1.200.000, B 800.000 TL). Karma KPO'su yüksek ürüne kayarsa başabaş düşer.

> **Sık yapılan hata:** Faizi faaliyet kaldıracına katmak. Faiz yalnız FİKD, BKD ve faiz dahil başabaşı etkiler.

## 3. Proforma tablolar, dış finansman ihtiyacı ve büyüme

**Satış yüzdesi yönteminde** satışla orantılı değişen aktif ve kendiliğinden artan borçlar (ticari borç, tahakkuklar) gelecek satışa göre büyütülür; banka kredisi, sermaye gibi kararla değişen kalemler sabit tutulur. Aradaki açık **dış finansman ihtiyacıdır (DFİ)**:

- DFİ = (A / S0) × ΔS − (L / S0) × ΔS − m × S1 × (1 − d)

m net kâr marjı, d dağıtım oranıdır. Örnek: S0 = 10.000.000, S1 = 12.000.000 TL; satışa bağlı aktif 6.000.000, kendiliğinden artan borç 1.500.000 TL; m = %5; d = %40. DFİ = 0,60 × 2.000.000 − 0,15 × 2.000.000 − 0,05 × 12.000.000 × 0,60 = 1.200.000 − 300.000 − 360.000 = 540.000 TL. Soruda borç/özkaynak gibi oran kısıtı varsa açık bu orana göre kredi ve sermaye arasında bölünür.

Dış kaynak kullanmadan ulaşılabilecek **içsel büyüme oranı** = ROA × b / (1 − ROA × b); borç/özkaynak oranını sabit tutarak yeni hisse çıkarmadan ulaşılan **sürdürülebilir büyüme oranı** = ROE × b / (1 − ROE × b); b = 1 − d. ROA %10, ROE %20, b = 0,6 ise içsel büyüme 0,06 / 0,94 ≈ %6,38; sürdürülebilir büyüme 0,12 / 0,88 ≈ %13,64. Ters çözümde her oran için g / (1 + g) = ROA × b (ya da ROE × b) yazılır; ROE × b'nin ROA × b'ye bölümü özkaynak çarpanını (Aktif / Özkaynak; örnekte 0,12 / 0,06 = 2) verir.

## 4. Nakit akım tablosu, fon akım tablosu ve Altman Z

**Dolaysız yöntemde** faaliyet nakit akışı tahsilat ve ödemelerden kurulur:

- Müşterilerden tahsilat = Satışlar − Ticari alacak artışı
- Satıcılara ödeme = SMM + Stok artışı − Ticari borç artışı
- Faaliyet gideri ödemesi = Faaliyet giderleri − Amortisman (± peşin gider ve tahakkuk değişimi)
- Vergi ödemesi = Vergi gideri − Ödenecek vergi artışı

Örnek: satış 5.000.000, alacak artışı 400.000; SMM 3.000.000, stok artışı 200.000, ticari borç artışı 300.000; faaliyet giderleri 800.000 (150.000 amortisman dahil); vergi gideri 250.000, ödenecek vergi artışı 50.000 TL. Tahsilat 4.600.000; satıcılara 2.900.000; giderlere 650.000; vergiye 200.000 TL; faaliyet nakit akışı 850.000 TL. Dolaylı kontrol: net kâr 950.000 + 150.000 − 400.000 − 200.000 + 300.000 + 50.000 = 850.000 TL. Yatırım (duran varlık alım-satımı) ve finansman (kredi, sermaye, kâr payı) akışları ayrı bölümlerde gösterilir.

**Fon akım tablosu** iki bilanço arasındaki değişimi kaynak ve kullanım olarak gösterir. Kaynaklar: faaliyetlerden sağlanan fon (net kâr + amortisman), aktif azalışları, borç ve sermaye artışları. Kullanımlar: aktif artışları, borç azalışları, kâr dağıtımı. Kaynak ve kullanım toplamları eşittir.

**Altman Z** (halka açık imalat işletmesi): Z = 1,2 X1 + 1,4 X2 + 3,3 X3 + 0,6 X4 + 1,0 X5. X1 = NİS / Aktif, X2 = Dağıtılmamış kârlar / Aktif, X3 = FVÖK / Aktif, X4 = Özkaynak piyasa değeri / Toplam borç, X5 = Satışlar / Aktif. Z > 2,99 güvenli, 1,81–2,99 gri bölge, Z < 1,81 yüksek iflas riski. Oranlar 0,20; 0,30; 0,15; 1,0 ve 1,5 ise Z = 0,24 + 0,42 + 0,495 + 0,60 + 1,50 = 3,255; işletme güvenli bölgededir.

## 5. Kâr payı politikası

- **İlgisizlik (Modigliani-Miller)**: kusursuz piyasada kâr payı politikası değeri etkilemez.
- **Eldeki kuş (Gordon, Lintner)**: yatırımcı belirsiz sermaye kazancı yerine kesin kâr payını tercih eder.
- **Vergi farkı**, **sinyal** ve **yatırımcı kitlesi** görüşleri dağıtım tercihini vergi yüküne, bilgi etkisine ve ortak yapısına bağlar.

**Artık kâr payı** yaklaşımında kâr önce kârlı yatırımlara ayrılır, kalan dağıtılır. Hedef yapı varyantı: net kâr 5.000.000 TL, yatırım 4.000.000 TL, hedef özkaynak payı %60 ise dağıtım 5.000.000 − 2.400.000 = 2.600.000 TL. Sınav varyantı: projeler getirisine göre sıralanır; getirisi ortakların alternatif getirisini aşan proje iç kaynakla finanse edilir, eşit olanda eldeki kuş kuralıyla dağıtım seçilir. Net kâr 1.000.000 TL; A (%30, 500.000 TL), B (%22, 300.000 TL), C (%20, 400.000 TL); ortakların alternatif getirisi %20 ise A ve B için 800.000 TL tutulur, 200.000 TL dağıtılır (dağıtım oranı %20).

**Bedelsiz hisse** özkaynak toplamını değiştirmez, yalnız özkaynak kalemleri arasında aktarım yapar; %20 bedelsizde hisse sayısı 1,2 katına çıkar, teorik fiyat P / 1,2 olur (24 TL → 20 TL). **Hisse geri alımı** nakit kâr payının alternatifidir: 1.000.000 hisse, net kâr 5.000.000 TL (hisse başına 5 TL), F/K 8 (fiyat 40 TL) iken dağıtılacak 2.000.000 TL ile hisse başına 2 TL ödenecekse geri alım fiyatı 40 + 2 = 42 TL'dir. 2.000.000 / 42 ≈ 47.619 hisse alınır; kalan 952.381 hissede hisse başına kâr 5,25 TL, fiyat 8 × 5,25 = 42 TL olur ve ortak iki yolda aynı servete ulaşır.

### Tasdik uygulama notu

Tam tasdikte YMM oran analizini analitik inceleme aracı olarak kullanır: brüt kâr marjı, tahsil süresi ve stok devir hızındaki olağandışı sapmalar ayrıntılı incelemeyi yönlendirir. Nakit akım tablosundaki tahsilat ve ödemeler mizan değişimleriyle mutabık kılınır; kâr dağıtımında genel kurul kararı, yedek akçe ayrımı, bedelsiz sermaye artırımının kaynağı ve kâr payı ödemelerindeki vergi kesintisi belgelerle kontrol edilir.

## Özet

- Oranlardan tablo türetmede satış ve devir hızından aktife, yapı oranlarından pasife, likidite oranlarından dönen varlık kalemlerine gidilir.
- Başabaş = SM / (p − v); faiz dahil (SM + F) / (p − v); çok ürünlüde SM / ağırlıklı KPO.
- FAKD = KP / FVÖK; FİKD = FVÖK / (FVÖK − F); BKD = FAKD × FİKD.
- DFİ = (A / S0) ΔS − (L / S0) ΔS − m S1 (1 − d).
- İçsel büyüme ROA × b / (1 − ROA × b); sürdürülebilir büyüme ROE × b / (1 − ROE × b).
- Dolaysız nakit akışı tahsilat ve ödemelerden kurulur; dolaylı yöntemle aynı sonucu verir.
- Altman Z 1,81'in altında yüksek, 2,99'un üstünde düşük iflas riski gösterir.
- Artık kâr payında kârlı yatırımlar önce finanse edilir; geri alım fiyatı = fiyat + hisse başına kâr payı.
