---
ders: YNM
konu: KRV
baslik: Karar verme ve ilgili maliyetler
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Karar verme ve ilgili maliyetler"
    madde: "-"
  - mevzuat: "Genel bilgi — Fark analizi ve kısa dönemli kararlar"
    madde: "-"
  - mevzuat: "Genel bilgi — Kıt kaynak kullanımı"
    madde: "-"
  - mevzuat: "Genel bilgi — Ortak ürünler ve ek işlem kararı"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- İlgili maliyeti ilgisiz maliyetten ayırmayı ve fark analizi kurmayı
- Üret veya satın al kararını kaçınılabilir maliyet ve fırsat maliyetiyle vermeyi
- Özel sipariş kararında boş kapasite ve kaybedilen katkı payını hesaba katmayı
- Ürün hattını kapatma kararında ortak sabit maliyetleri doğru yorumlamayı
- Kıt kaynak kullanımında ürünleri kısıt birimi başına katkı payına göre sıralamayı
- Ortak ürünlerde ayrılma noktasında satma veya ek işlem kararını ve kayıtsızlık fiyatını

## 1. İlgili maliyet ve fark analizi

**İlgili maliyet**, (1) geleceğe ait olan ve (2) seçenekler arasında farklılaşan maliyettir. İki şarttan biri yoksa maliyet karar için ilgisizdir.

İlgisiz maliyetlerin başlıcaları:

- **Batık maliyet**: Geçmişte katlanılmış, hiçbir kararla geri alınamayan maliyet (ör. eski makinenin defter değeri).
- Seçeneklerde aynı kalan gelecek maliyetler (ör. her durumda ödenecek kira).
- Dağıtılmış ortak sabit maliyetler (karar sonucunda toplamı değişmiyorsa).

Karara mutlaka katılması gerekenler ise **kaçınılabilir maliyet** (seçenek bırakıldığında ortadan kalkan maliyet) ve **fırsat maliyeti**dir (bir kaynağın en iyi alternatif kullanımından vazgeçilen net getiri).

**Fark analizi** (diferansiyel analiz), seçenekler arasında yalnız farklılaşan gelir ve maliyetleri karşılaştırarak kâra net etkiyi bulan yöntemdir. Kural: Fark gelir − Fark maliyet > 0 ise seçenek kârı artırır.

### Örnek: Makine değiştirme fark analizi

Mevcut makineyle yıllık satış 900.000 TL, değişken maliyet 540.000 TL, sabit maliyet 200.000 TL'dir. Yeni makineyle satış aynı kalır, değişken maliyet 480.000 TL'ye düşer, sabit maliyet (amortisman dâhil) 250.000 TL'ye çıkar.

1. Satış farkı = 0 TL (ilgisiz).
2. Değişken maliyet farkı = 480.000 − 540.000 = −60.000 TL (tasarruf).
3. Sabit maliyet farkı = 250.000 − 200.000 = +50.000 TL.
4. Net fark = 60.000 − 50.000 = 10.000 TL lehine; kontrol: kâr 160.000 TL'den 170.000 TL'ye çıkar.

İstisna: Eski makinenin defter değeri batık maliyettir; ancak eski makinenin bugünkü satış bedeli geleceğe ait ve seçeneğe göre farklılaştığı için ilgilidir.

> **Sık yapılan hata:** Eski varlığın defter değerini karar tablosuna koymak. Defter değeri geçmiş bir harcamanın kalıntısıdır; soruda vergi etkisi ayrıca verilmedikçe nakit akışı ve seçenek farkı yaratmaz.

## 2. Üret veya satın al

**Üret veya satın al** kararı, bir parçanın ya da hizmetin işletme içinde üretilmesi ile dışarıdan tedarik edilmesi arasındaki seçimdir.

Kural: Üretimin ilgili maliyeti = Değişken üretim maliyetleri + Kaçınılabilir sabit maliyetler + Tesisin alternatif kullanımından vazgeçilen getiri (fırsat maliyeti). Bu toplam satın alma fiyatıyla karşılaştırılır. Kaçınılamayan, dağıtılmış sabit maliyet karara katılmaz.

### Örnek: Parça için üret veya satın al

Yılda 10.000 birim parça gerekir. Birim maliyet: direkt malzeme 12 TL, direkt işçilik 8 TL, değişken genel üretim gideri 5 TL, dağıtılmış sabit genel üretim gideri 10 TL (bunun 4 TL'si parça dışarıdan alınırsa ortadan kalkar). Tedarikçi fiyatı 30 TL'dir.

1. Birim tam maliyet 35 TL'dir; bu tutar 30 TL'lik fiyatla karşılaştırılmaz.
2. İlgili üretim maliyeti = 12 + 8 + 5 + 4 = 29 TL; toplam 290.000 TL.
3. Satın alma maliyeti = 30 × 10.000 = 300.000 TL.
4. Üretmek 10.000 TL avantajlıdır.
5. Parça dışarıdan alınınca boşalan alan yıllık 25.000 TL'ye kiralanabiliyorsa: net satın alma maliyeti = 300.000 − 25.000 = 275.000 TL; bu kez satın almak 15.000 TL avantajlıdır.

İstisna: Nitel etkenler sayısal sonucu değiştirebilir: tedarikçinin kalite düzeyi ve teslim güvenilirliği, tedarikçiye bağımlılık ve ileride fiyat artırma riski, know-how ve gizli bilgi kaybı, boşalan işgücünün durumu, kapasitenin gelecekteki kullanımı. Sınav anahtarları bu listeyi madde madde ister; sayısal sonuca ek olarak en az birkaçını yaz. Talep miktarı değişiyorsa, ekipman kirası gibi **adım sabit maliyetleri** her hacim için ayrı hesapla; kararın yönü hacme göre değişebilir.

## 3. Özel sipariş

**Özel sipariş**, normal satış kanalı dışında, genellikle normal fiyatın altında gelen tek seferlik siparişin kabul edilip edilmeyeceği kararıdır.

Kural:

- Boş kapasite yeterliyse: sipariş fiyatı birim ilgili maliyetten (değişken maliyet + siparişe özgü ek maliyetler) yüksekse kabul edilir. Sabit maliyetler zaten katlanıldığından ilgisizdir.
- Boş kapasite yetersizse: normal satışlardan vazgeçilen katkı payı fırsat maliyeti olarak eklenir.

### Örnek: Özel sipariş

Kapasite 50.000 birim, mevcut satış 40.000 birimdir. Normal fiyat 50 TL, birim değişken maliyet 30 TL'dir. Bir müşteri birim fiyatı 36 TL olan sipariş verir; sipariş birim başına 1 TL ek ambalaj gerektirir.

1. Birim ilgili maliyet = 30 + 1 = 31 TL; birim ek katkı = 36 − 31 = 5 TL.
2. Sipariş 8.000 birim ise boş kapasite (10.000 birim) yeterlidir: ek kâr = 8.000 × 5 = 40.000 TL; kabul edilir.
3. Sipariş 15.000 birim ise 5.000 birim normal satıştan vazgeçilir: kaybedilen katkı = 5.000 × (50 − 30) = 100.000 TL.
4. Siparişin katkısı = 15.000 × 5 = 75.000 TL; net etki = 75.000 − 100.000 = −25.000 TL; reddedilir.

İstisna: Sipariş kabul edilince **mevcut müşterilere de fiyat indirimi** yapılması gerekiyorsa, mevcut satış miktarı × indirim tutarı fırsat maliyetidir. Yukarıdaki 8.000 birimlik sipariş, mevcut 40.000 birimde 2 TL indirim gerektirseydi kayıp 80.000 TL olur, 40.000 TL'lik ek katkıyı aşar ve sipariş reddedilirdi. Rekabet ve fiyat ayrımcılığı kuralları da değerlendirilir.

> **Sınav ipucu:** Özel sipariş sorusunda ilk iş boş kapasiteyi hesaplamaktır. Sipariş boş kapasiteyi aşıyorsa aşan kısım için normal satışların birim katkı payı ilgili maliyete eklenir.

## 4. Ürün hattını kapatma

**Ürün hattını kapatma** kararı, zarar gösteren bir ürün, bölüm ya da şubenin faaliyetine son verilip verilmeyeceğidir.

Kural: Kapatma ile kaybedilen katkı payı, kapatma ile kaçınılabilen sabit maliyetlerden büyükse hat sürdürülür. Dağıtılmış ortak sabit maliyetler kapatmayla ortadan kalkmaz; diğer hatlara yüklenir. Hattın kaçınılabilir sabit maliyetler düşüldükten sonra kalan tutarına **bölüm marjı** denir; kararın ölçüsü bu marjdır.

### Örnek: Zarar gösteren hattın kapatılması

Ortak sabit maliyet 120.000 TL'dir ve satışlara göre dağıtılmıştır.

| Kalem | X | Y | Z | Toplam |
|---|---|---|---|---|
| Satış | 500.000 | 300.000 | 200.000 | 1.000.000 |
| Değişken maliyet | 300.000 | 180.000 | 150.000 | 630.000 |
| Katkı payı | 200.000 | 120.000 | 50.000 | 370.000 |
| Kaçınılabilir sabit maliyet | 80.000 | 50.000 | 30.000 | 160.000 |
| Bölüm marjı | 120.000 | 70.000 | 20.000 | 210.000 |
| Dağıtılmış ortak sabit maliyet | 60.000 | 36.000 | 24.000 | 120.000 |
| Faaliyet kârı | 60.000 | 34.000 | −4.000 | 90.000 |

1. Z, 4.000 TL zarar gösteriyor görünür.
2. Z kapatılırsa kaybedilen katkı payı 50.000 TL, kaçınılan sabit maliyet 30.000 TL'dir.
3. Net etki = −50.000 + 30.000 = −20.000 TL.
4. Kontrol: kapatma sonrası kâr = 320.000 − 130.000 − 120.000 = 70.000 TL; 90.000 TL'den 20.000 TL düşer. Z sürdürülmelidir.

İstisna: Z'nin boşalttığı kapasite başka bir üründe 20.000 TL'den fazla ek katkı payı yaratabiliyorsa ya da Z diğer ürünlerin satışını destekliyorsa (tamamlayıcı ürün) bu etkiler de hesaba katılır.

## 5. Kıt kaynak kullanımı

**Kıt kaynak kullanımı** kararı, makine saati, işçilik saati ya da hammadde gibi bir kaynağın talebi karşılamaya yetmediği durumda üretim karmasının belirlenmesidir.

Kural: Ürünler birim katkı payına göre değil, **kısıtlayıcı kaynak birimi başına katkı payına** göre sıralanır. En yüksekten başlanarak talep karşılanır, kalan kaynak sıradaki ürüne verilir. Bu kural tek kısıt varken geçerlidir.

### Örnek: Makine saati kısıtı

Kullanılabilir makine saati 4.000'dir.

| Ürün | Birim katkı payı | Birim makine saati | Saat başına katkı | Talep (birim) |
|---|---|---|---|---|
| P | 60 TL | 2,5 | 24 TL | 1.000 |
| R | 40 TL | 1,25 | 32 TL | 2.000 |
| S | 30 TL | 2 | 15 TL | 1.500 |

1. Sıralama: R (32 TL), P (24 TL), S (15 TL).
2. R'nin talebi: 2.000 × 1,25 = 2.500 saat; kalan 1.500 saat.
3. P: 1.500 / 2,5 = 600 birim; S üretilmez.
4. Toplam katkı = 2.000 × 40 + 600 × 60 = 116.000 TL.
5. Birim katkıya göre (önce P) sıralansaydı: P 1.000 birim (2.500 saat), R 1.500 / 1,25 = 1.200 birim; katkı = 60.000 + 48.000 = 108.000 TL. Doğru sıralama 8.000 TL daha fazla katkı sağlar.

İstisna: Birden fazla kısıt aynı anda bağlayıcıysa sıralama yöntemi yetmez; doğrusal programlama gerekir.

## 6. Ortak ürünlerde ayrılma noktası ve ek işlem kararı

**Ortak ürünler**, aynı üretim sürecinden aynı anda çıkan ürünlerdir; ayrı ayrı tanınabildikleri yer **ayrılma noktasıdır**. Ayrılma noktasına kadarki **ortak maliyet**, ürünü ayrılmada satsan da işlesen de değişmediği için ek işlem kararında **ilgisizdir** (batık niteliktedir).

Kural: Ek işlemden doğan **ek gelir** (işlenmiş satış değeri − ayrılma noktası satış değeri) **ek işlem maliyetinden** büyükse ürün işlenir; küçükse ayrılma noktasında satılır.

### Örnek: Ek işlem kararı

Ortak maliyet 300.000 TL. A ürünü: 10.000 kg, ayrılma noktasında 20 TL/kg; 60.000 TL ek işlemle 28 TL/kg'a satılır. B ürünü: 5.000 kg, ayrılma noktasında 30 TL/kg; 50.000 TL ek işlemle 38 TL/kg'a satılır.

1. A: ek gelir = 10.000 × (28 − 20) = 80.000 TL; ek maliyet 60.000 TL; fark +20.000 TL. **İşlenmeli.**
2. B: ek gelir = 5.000 × (38 − 30) = 40.000 TL; ek maliyet 50.000 TL; fark −10.000 TL. **Ayrılma noktasında satılmalı.**
3. Ortak maliyet 300.000 TL iki kararda da yer almaz; dağıtım yöntemi (fiziki miktar, satış değeri) kararı değiştirmez.
4. **Kayıtsızlık (başabaş) fiyatı:** A'nın ayrılma noktası fiyatı p olsun. 10.000 × (28 − p) = 60.000 eşitliğinden p = 22 TL. Ayrılma noktası fiyatı 22 TL'yi aşarsa A da ayrılmada satılmalıdır.

> **Sık yapılan hata:** Ortak maliyeti ürünlere dağıtıp "A ürünü zararda, işlemeyelim" demek. Ortak maliyet her iki seçenekte aynıdır; yalnız ek gelir ile ek maliyet karşılaştırılır.

### Tasdik uygulama notu

Kısa dönemli kararlar vergi beyanına doğrudan girmez; ancak sonuçları inceleme ve tasdikte sorgulanır. Tam maliyetin altında yapılan özel sipariş satışlarında ya da ilişkili kişiden yapılan "satın al" tedarikinde fiyatın emsale uygunluğu araştırılır; işletmenin fark analizini, boş kapasite ve maliyet hesaplarını belgelemesi istenir. Kapatılan ürün hatlarında elden çıkarılan ya da atıl kalan duran varlıkların ve stokların kayıtlardan çıkışı ayrıca kontrol edilir.

## Özet

- İlgili maliyet geleceğe ait ve seçenekler arasında farklılaşan maliyettir; batık maliyet ilgisizdir.
- Fark analizi yalnız farklılaşan gelir ve maliyetleri karşılaştırır; fırsat maliyeti de karara girer.
- Üret veya satın al: değişken maliyet + kaçınılabilir sabit maliyet + fırsat maliyeti, satın alma fiyatıyla karşılaştırılır.
- Özel sipariş: boş kapasite varsa sabit maliyet ilgisizdir; yoksa vazgeçilen katkı payı eklenir.
- Ürün hattını kapatma: kaybedilen katkı payı ile kaçınılan sabit maliyet karşılaştırılır; dağıtılmış ortak maliyet ilgisizdir.
- Kıt kaynakta ölçü, kısıt birimi başına katkı payıdır.
- Ortak üründe ortak maliyet ilgisizdir; ek gelir ek işlem maliyetini aşarsa ürün işlenir, aksi hâlde ayrılma noktasında satılır.
