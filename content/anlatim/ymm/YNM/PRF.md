---
ders: YNM
konu: PRF
baslik: Performans ölçümü ve transfer fiyatı
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Sorumluluk merkezleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Yatırımın kârlılığı ve artık kâr"
    madde: "-"
  - mevzuat: "Genel bilgi — Dengeli başarı kartı"
    madde: "-"
  - mevzuat: "Genel bilgi — İşletme içi transfer fiyatlaması"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Sorumluluk merkezlerinin türlerini ve her birinin hangi ölçüyle değerlendirildiğini
- Yatırımın kârlılığını DuPont ayrıştırmasıyla hesaplamayı ve artık kârla karşılaştırmayı
- Dengeli başarı kartının dört boyutunu ve neden-sonuç zincirini
- İşletme içi transfer fiyatının alt ve üst sınırını boş ve dolu kapasitede belirlemeyi

## 1. Sorumluluk merkezleri

### Tanım ve kural

**Sorumluluk merkezi**, yöneticisinin belirli gelir, maliyet ya da yatırım kararları üzerinde yetki taşıdığı ve bu kararlardan hesap verdiği örgüt birimidir. **Sorumluluk muhasebesi**, sonuçları bu birimler bazında raporlayan sistemdir. Temel ilke **kontrol edilebilirlik**tir: yönetici yalnız etkileyebildiği kalemlerden sorumlu tutulur.

Sorumluluk merkezleri dört türdür:

| Merkez | Yöneticinin yetkisi | Başlıca performans ölçüsü |
|---|---|---|
| Maliyet merkezi | Yalnız maliyetler | Bütçe ve standarttan sapmalar |
| Gelir merkezi | Satış gelirleri | Satış bütçesine ulaşma, satış fiyat ve miktar sapmaları |
| Kâr merkezi | Gelir ve maliyetler | Katkı payı, bölüm kârı |
| Yatırım merkezi | Gelir, maliyet ve yatırılan varlıklar | Yatırımın kârlılığı, artık kâr |

Kâr merkezi raporlamasında katkı payından yöneticinin kontrol edebildiği sabit maliyetler düşülerek **kontrol edilebilir kâr**, ardından bölüme özgü ama yöneticinin kontrol edemediği sabit maliyetler düşülerek **bölüm kârı** bulunur. Yönetici kontrol edilebilir kâra, bölümün kendisi ise bölüm kârına göre değerlendirilir.

İstisna: Genel merkez giderlerinin bölümlere dağıtılan payı yöneticinin kontrolünde değildir; yöneticinin performansı ölçülürken dışarıda bırakılır.

## 2. Yatırımın karlılığı ve artık kâr

### Yatırımın kârlılığı (ROI)

**Yatırımın kârlılığı** (ROI; Return on Investment), bir yatırım merkezinin kullandığı varlıklara göre ne kadar kâr ürettiğini gösterir. Bu anlatımda en yaygın kabul gören tanım kullanılır: pay olarak **faaliyet kârı** (faiz ve vergi öncesi), payda olarak bölümün **ortalama faaliyet varlıkları** alınır.

- ROI = Faaliyet kârı / Faaliyet varlıkları
- DuPont ayrıştırması: ROI = Kâr marjı × Varlık devir hızı = (Faaliyet kârı / Satışlar) × (Satışlar / Faaliyet varlıkları)

DuPont ayrıştırması, ROI'nin iki yoldan artırılabileceğini gösterir: satış başına kârı yükseltmek ya da aynı varlıkla daha çok satış yapmak.

### Artık kâr (RI)

**Artık kâr** (RI; Residual Income), bölümün faaliyet kârından yatırılan varlıkların asgari getirisi düşüldükten sonra kalan tutardır:

- Artık kâr = Faaliyet kârı − (Faaliyet varlıkları × Asgari kabul edilebilir getiri oranı)

Artık kâr mutlak tutar verdiğinden büyüklükleri farklı bölümleri karşılaştırmada zayıftır; buna karşılık ROI'nin yol açtığı hedef uyumsuzluğunu büyük ölçüde azaltır. **Ekonomik katma değer** (EVA; Economic Value Added), artık kârın vergi sonrası faaliyet kârı ve ağırlıklı ortalama sermaye maliyetiyle hesaplanan bir türevidir.

### Örnek: ROI, artık kâr ve hedef uyumsuzluğu

Bir yatırım merkezinin satışları 5.000.000 TL, faaliyet kârı 600.000 TL, ortalama faaliyet varlıkları 4.000.000 TL'dir. Asgari getiri oranı %12'dir. Bölüme 1.000.000 TL yatırımla yıllık 130.000 TL faaliyet kârı getirecek bir proje önerilmiştir.

1. Kâr marjı = 600.000 / 5.000.000 = %12; varlık devir hızı = 5.000.000 / 4.000.000 = 1,25.
2. ROI = %12 × 1,25 = %15 (kontrol: 600.000 / 4.000.000 = %15).
3. Mevcut artık kâr = 600.000 − 4.000.000 × 0,12 = 600.000 − 480.000 = 120.000 TL.
4. Projenin ROI'si = 130.000 / 1.000.000 = %13; asgari oran olan %12'nin üzerindedir, işletme açısından kabul edilmelidir.
5. Proje sonrası bölüm ROI'si = (600.000 + 130.000) / (4.000.000 + 1.000.000) = 730.000 / 5.000.000 = %14,6; %15'ten düşer. ROI ile değerlendirilen yönetici projeyi reddetmeye yönelir.
6. Projenin artık kârı = 130.000 − 1.000.000 × 0,12 = 10.000 TL; bölümün artık kârı 120.000 TL'den 130.000 TL'ye çıkar. Artık kârla değerlendirilen yönetici projeyi kabul eder.

Bu durum **hedef uyumsuzluğu** olarak adlandırılır: ROI, işletmenin yararına olan bir yatırımı yöneticinin gözünde çekici olmaktan çıkarmıştır.

İstisna: Varlıklar net defter değeriyle ölçülürse amortisman ilerledikçe payda küçülür ve ROI kendiliğinden yükselir; eski varlıklarla çalışan bölüm yapay olarak başarılı görünür.

> **Sınav ipucu:** Proje ROI'si asgari orandan yüksek, bölümün mevcut ROI'sinden düşükse ROI yöneticiyi reddetmeye, artık kâr kabul etmeye yöneltir. Soruda "işletme açısından" ve "yönetici açısından" ayrımına dikkat et.

## 3. Dengeli başarı kartı

### Tanım ve kural

**Dengeli başarı kartı** (Balanced Scorecard), Kaplan ve Norton tarafından geliştirilen, işletme stratejisini finansal ve finansal olmayan ölçülere dönüştüren performans ölçüm sistemidir. Yalnız finansal ölçülerin geçmişe dönük ve kısa vadeli olması sorununa karşı dört boyutu birlikte izler:

| Boyut | Temel soru | Örnek ölçü |
|---|---|---|
| Finansal | İşletme ortaklara nasıl görünür? | ROI, artık kâr, satış büyümesi |
| Müşteri | Müşteri işletmeyi nasıl görür? | Müşteri memnuniyeti, pazar payı, müşteri elde tutma |
| İç süreçler | Hangi süreçlerde üstün olunmalı? | Hata oranı, çevrim süresi, zamanında teslim |
| Öğrenme ve gelişme | Gelişme nasıl sürdürülür? | Çalışan eğitimi, çalışan devir oranı, öneri sayısı |

Kural: Boyutlar **neden-sonuç zinciriyle** bağlıdır. Eğitimli çalışan (öğrenme ve gelişme) süreç hatasını azaltır (iç süreçler); bu, zamanında ve hatasız teslimle müşteri memnuniyetini artırır (müşteri); memnun müşteri de satış ve kârı büyütür (finansal). Her boyutta hedef, ölçü, hedef değer ve girişim belirlenir.

Kartta **öncü göstergeler** (gelecekteki sonucu önceden haber veren, ör. eğitim saati) ile **gecikmeli göstergeler** (sonucu gösteren, ör. kâr) dengelenir.

İstisna: Ölçü sayısı çok artırılırsa odak kaybolur; stratejiyle bağı olmayan ölçüler karta konmamalıdır.

## 4. İşletme içi transfer fiyatlaması

### Tanım

**İşletme içi transfer fiyatlaması**, aynı işletmenin bir bölümünün diğer bölümüne sattığı mal ya da hizmete fiyat biçilmesidir. **Transfer fiyatı** satan bölüm için gelir, alan bölüm için maliyettir; işletmenin toplam kârını değiştirmez, kârın bölümler arasındaki dağılımını belirler. Yaygın yöntemler: piyasa fiyatı esası, maliyet esası (değişken maliyet, tam maliyet ya da maliyet artı kâr payı), müzakere edilmiş fiyat ve ikili fiyatlama.

### Kural

Bu anlatımda yaygın kabul gören genel kural kullanılır:

- Asgari transfer fiyatı (satan bölüm) = Birim değişken maliyet + Birim fırsat maliyeti
- Azami transfer fiyatı (alan bölüm) = Dış piyasadan satın alma fiyatı

**Fırsat maliyeti**, satan bölüm iç transfer nedeniyle dış satıştan vazgeçiyorsa kaybedilen birim katkı payıdır. Boş kapasite varsa fırsat maliyeti sıfırdır.

### Örnek: Boş ve dolu kapasitede transfer fiyatı aralığı

A bölümü bir parçayı birim 40 TL değişken üretim maliyetiyle üretip dış piyasaya 70 TL'den satmaktadır; dış satışta birim başına 5 TL değişken satış gideri vardır, iç transferde bu gider doğmaz. B bölümü yılda 10.000 parçaya ihtiyaç duymakta ve dışarıdan 70 TL'ye alabilmektedir.

1. Boş kapasite yeterliyse: fırsat maliyeti 0; asgari fiyat = 40 TL. Fiyat aralığı 40–70 TL'dir.
2. A tam kapasitede çalışıyorsa: kaybedilen birim katkı = 70 − 40 − 5 = 25 TL; asgari fiyat = 40 + 25 = 65 TL. Aralık 65–70 TL'dir.
3. İşletme bütünü (dolu kapasite): dış alımdan kaçınılan tutar 70 × 10.000 = 700.000 TL; A'nın değişken maliyeti 40 × 10.000 = 400.000 TL; kaybedilen dış katkı 25 × 10.000 = 250.000 TL.
4. Net etki = 700.000 − 400.000 − 250.000 = +50.000 TL; bu tutar iç transferde kaçınılan 5 TL satış giderinin (5 × 10.000) karşılığıdır. İç transfer işletmenin yararınadır.

İstisna: Asgari fiyat azami fiyatı aşıyorsa iç transfer işletme bütününün aleyhinedir; bu durumda B'nin dışarıdan alması doğru karardır.

> **Sık yapılan hata:** Dolu kapasitede asgari fiyatı yalnız değişken maliyet olarak almak. Dış satıştan vazgeçiliyorsa kaybedilen katkı payı (dış satışta kaçınılan giderler düşülerek) mutlaka eklenir.

### Tasdik uygulama notu

Aynı tüzel kişilik içindeki bölümler arası transfer fiyatı yalnız iç raporlamayı etkiler; işletmenin vergi matrahını değiştirmez. Bölümler ayrı şirketlerse durum farklıdır: ilişkili kişilerle yapılan işlemlerde fiyatın emsallere uygun olması gerekir. 5520 sayılı Kurumlar Vergisi Kanunu (KVK) md. 13/1 uyarınca kurumlar ilişkili kişilerle emsallere uygunluk ilkesine aykırı fiyat üzerinden mal veya hizmet alım-satımı yaparsa kazanç tamamen veya kısmen transfer fiyatlandırması yoluyla örtülü olarak dağıtılmış sayılır. Tam tasdikte grup içi satışlarda uygulanan yöntem, dayanak belgeler ve fiyatın emsal fiyatlarla karşılaştırması kontrol edilir; iç yönetim için seçilen maliyet esaslı fiyatın vergi açısından emsale uygun olduğu kendiliğinden varsayılmaz.

## Özet

- Sorumluluk merkezleri maliyet, gelir, kâr ve yatırım merkezi olarak ayrılır; yönetici yalnız kontrol edebildiği kalemlerden sorumludur.
- ROI = faaliyet kârı / faaliyet varlıkları = kâr marjı × varlık devir hızı (DuPont).
- Artık kâr = faaliyet kârı − faaliyet varlıkları × asgari getiri oranı; ROI'nin yol açtığı hedef uyumsuzluğunu azaltır.
- Dengeli başarı kartı finansal, müşteri, iç süreçler ve öğrenme ve gelişme boyutlarını neden-sonuç zinciriyle bağlar.
- Asgari transfer fiyatı = birim değişken maliyet + birim fırsat maliyeti; azami fiyat dış piyasadan alış fiyatıdır.
- Boş kapasitede fırsat maliyeti sıfırdır; dolu kapasitede kaybedilen katkı payı eklenir.
- Ayrı şirketler (ilişkili kişiler) arası transferlerde emsallere uygunluk aranır (KVK md. 13).
