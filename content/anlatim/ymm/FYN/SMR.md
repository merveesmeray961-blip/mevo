---
ders: FYN
konu: SMR
baslik: Sermaye maliyeti ve sermaye yapısı
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Ağırlıklı ortalama sermaye maliyeti"
    madde: "-"
  - mevzuat: "Genel bilgi — Sermaye varlıklarını fiyatlama modeli (CAPM) ve beta"
    madde: "-"
  - mevzuat: "Genel bilgi — Finansal kaldıraç"
    madde: "-"
  - mevzuat: "Genel bilgi — Optimal sermaye yapısı ve sermaye yapısı teorileri"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Borç ve özkaynak maliyetinden ağırlıklı ortalama sermaye maliyetini hesaplamak
- CAPM ile özkaynak maliyetini bulmak ve betayı yorumlamak
- Finansal kaldıracın hisse başına kâr üzerindeki etkisini ölçmek
- Optimal sermaye yapısını ve temel sermaye yapısı teorilerini açıklamak

## 1. Ağırlıklı ortalama sermaye maliyeti

**Sermaye maliyeti**, işletmenin kullandığı fonlar için fon sağlayıcılarının istediği asgari getiridir. Yatırım projelerinin değerlendirilmesinde iskonto oranı olarak kullanılır. İşletme fonlarını farklı kaynaklardan sağladığı için her kaynağın maliyeti ayrı bulunur, sonra ağırlıklandırılır.

**Ağırlıklı ortalama sermaye maliyeti (AOSM)**, her finansman kaynağının maliyetinin sermaye yapısındaki payıyla çarpılıp toplanmasıyla bulunur:

- AOSM = (E / V) × ke + (D / V) × kd × (1 − t)

E özkaynağın, D faizli borcun değeri, V = E + D toplam sermaye, ke özkaynak maliyeti, kd borcun vergi öncesi maliyeti, t vergi oranıdır. İmtiyazlı hisse varsa formüle (P / V) × kp terimi eklenir.

Formülün iki kuralı sınavda belirleyicidir. Birincisi, faiz vergi matrahından indirilebildiği için borç maliyeti **vergi sonrası** alınır: kd × (1 − t). Özkaynağa ödenen kâr payı vergiden düşülmediği için ke'ye böyle bir düzeltme yapılmaz. İkincisi, ağırlıklar literatürdeki yaygın kabulle **piyasa değerleriyle** hesaplanır; yönetimin hedef sermaye yapısı ağırlıkları da yaygın kabul görür; defter değeri ağırlıkları en zayıf seçenektir. Bu konu ekole bağlıdır; bu anlatımda piyasa değeri ağırlıkları esas alınmıştır.

Özkaynak maliyeti iki yaygın yolla bulunur: Gordon modelinden ke = D1 / P0 + g ya da aşağıda anlatılan CAPM ile. Borç maliyeti ise mevcut borçların piyasa getirisinden (yeni borçlanma faizi) hesaplanır; kayıtlı eski faiz oranı değil, bugünkü borçlanma maliyeti esastır.

### Örnek: AOSM hesabı

Bir işletmenin özkaynağının piyasa değeri 6.000.000 TL, faizli borçlarının piyasa değeri 4.000.000 TL'dir. Risksiz faiz oranı yüzde 10, piyasa portföyünün beklenen getirisi yüzde 18, hissenin betası 1,2'dir. Borcun vergi öncesi maliyeti yüzde 15'tir. Vergi oranı **yalnız hesap amacıyla varsayılan yüzde 30**'dur; yürürlükteki bir oranı göstermez. Ara sonuçlar yuvarlanmadan kullanılmıştır.

1. Ağırlıklar: V = 10.000.000 TL; E / V = 0,60; D / V = 0,40.
2. Özkaynak maliyeti (CAPM): ke = 0,10 + 1,2 × (0,18 − 0,10) = 0,196, yani yüzde 19,6.
3. Vergi sonrası borç maliyeti: 0,15 × (1 − 0,30) = 0,105, yani yüzde 10,5.
4. Ağırlıklı katkılar: 0,60 × 19,6 = 11,76 puan; 0,40 × 10,5 = 4,20 puan.
5. AOSM = 11,76 + 4,20 = yüzde 15,96.

Bu işletmenin ortalama riskli bir projeyi kabul etmesi için projenin İVO'su yüzde 15,96'dan yüksek olmalıdır. İstisna olarak, riski işletmenin ortalamasından farklı projelerde AOSM yerine projeye özgü, riske göre düzeltilmiş iskonto oranı kullanılır.

> **Sık yapılan hata:** AOSM'de borç maliyetini (1 − t) ile çarpmayı unutmak ya da vergi düzeltmesini özkaynak maliyetine de uygulamak.

## 2. CAPM ve beta

**Sermaye varlıklarını fiyatlama modeli (CAPM)**, bir menkul kıymetin beklenen getirisini yalnız sistematik riskine bağlar:

- ke = rf + β × (rm − rf)

rf risksiz faiz oranı, rm piyasa portföyünün beklenen getirisi, (rm − rf) **piyasa risk primi**, β ise hissenin betasıdır. Örnekte piyasa risk primi yüzde 8, hissenin risk primi 1,2 × 8 = yüzde 9,6'dır.

**Beta**, hisse getirisinin piyasa getirisindeki değişime duyarlılığıdır ve hissenin **sistematik (çeşitlendirmeyle giderilemeyen) riskini** ölçer:

- β = Kov(ri, rm) / Var(rm)

Örneğin hisse getirisi ile piyasa getirisi arasındaki kovaryans 0,024, piyasa getirisinin varyansı 0,020 ise β = 0,024 / 0,020 = 1,2 olur. Yorum: β = 1 hisse piyasayla aynı ölçüde dalgalanır; β > 1 piyasadan daha oynaktır (agresif); β < 1 daha az oynaktır (defansif). Risksiz varlığın betası sıfırdır.

Beta, borç kullanımıyla artar. Borçsuz (varlık) beta ile borçlu beta arasındaki ilişki yaygın olarak **Hamada denklemiyle** kurulur: βL = βU × [1 + (1 − t) × D / E]. Örneğin borçsuz beta 0,9, D / E = 0,5 ve varsayılan t = 0,30 ise βL = 0,9 × 1,35 = 1,215'tir. Halka açık olmayan işletmenin betası, benzer halka açık şirketlerin betasından bu yolla türetilir.

> **Sınav ipucu:** CAPM'de beta piyasa getirisi ile değil, **piyasa risk primi** (rm − rf) ile çarpılır. Soruda doğrudan "piyasa risk primi" verilmişse ayrıca rf çıkarma.

## 3. Finansal kaldıraç

**Finansal kaldıraç**, sabit maliyetli fonların (borç, imtiyazlı hisse) kullanılmasıyla faiz ve vergi öncesi kârdaki (FVÖK) değişimin hisse başına kâra (HBK) büyütülerek yansımasıdır. Kaldıraç, varlık getirisi borç maliyetini aştığında ortakların getirisini artırır; altında kaldığında azaltır. Bu nedenle finansal kaldıraç aynı zamanda **finansal riskin** ölçüsüdür.

Etkinin büyüklüğü **finansal kaldıraç derecesiyle (FKD)** ölçülür:

- FKD = HBK'deki yüzde değişim / FVÖK'teki yüzde değişim = FVÖK / (FVÖK − Faiz)

### Örnek: İki finansman planının karşılaştırılması

Toplam sermayesi 5.000.000 TL olan bir işletmenin FVÖK'ü 1.000.000 TL'dir. A planında tamamı özkaynak (500.000 hisse), B planında yarısı yüzde 15 faizli borç (yıllık faiz 375.000 TL), yarısı özkaynaktır (250.000 hisse). Varsayılan vergi oranı yüzde 30'dur.

1. A planı: vergi sonrası kâr 1.000.000 × 0,70 = 700.000 TL; HBK = 700.000 / 500.000 = 1,40 TL; FKD = 1,0.
2. B planı: vergi öncesi kâr 625.000 TL; vergi sonrası kâr 437.500 TL; HBK = 437.500 / 250.000 = 1,75 TL.
3. B planının FKD'si: 1.000.000 / 625.000 = 1,6.
4. FVÖK yüzde 20 artıp 1.200.000 TL olursa B'de HBK = 825.000 × 0,70 / 250.000 = 2,31 TL olur; artış yüzde 32'dir (1,6 × yüzde 20).
5. **Kayıtsızlık noktası**: iki planın HBK'si FVÖK = 750.000 TL'de eşittir (her ikisinde 1,05 TL). Bu FVÖK'te varlık getirisi (750.000 / 5.000.000 = yüzde 15) borç faizine eşittir.

FVÖK 750.000 TL'nin üzerindeyse borçlu plan, altındaysa özkaynak planı daha yüksek HBK sağlar. Faaliyet ve birleşik kaldıraç dereceleri finansal planlama konusunda ayrıca işlenir.

## 4. Optimal sermaye yapısı

**Sermaye yapısı**, işletmenin uzun vadeli fonlarının borç ve özkaynak arasındaki dağılımıdır. **Optimal sermaye yapısı**, AOSM'yi en düşük, dolayısıyla işletme değerini en yüksek yapan borç-özkaynak bileşimidir.

Borç oranı arttıkça başlangıçta ucuz borç pahalı özkaynağın yerini aldığı için AOSM düşer. Belli bir noktadan sonra finansal risk arttığından hem ke hem kd yükselir ve AOSM yeniden artar. Aşağıdaki varsayımsal tabloda (t = yüzde 30 varsayımıyla) optimum yüzde 40 borç oranındadır:

| Borç / Toplam sermaye | kd (vergi öncesi) | ke | AOSM |
|---|---|---|---|
| %0 | - | %16 | %16,00 |
| %20 | %10 | %17 | %15,00 |
| %40 | %12 | %19 | %14,76 |
| %60 | %16 | %25 | %16,72 |

### Sermaye yapısı teorileri

- **Modigliani-Miller (vergisiz)**: kusursuz piyasada işletme değeri sermaye yapısından bağımsızdır; borç arttıkça ke, AOSM sabit kalacak şekilde yükselir.
- **Modigliani-Miller (kurumlar vergili)**: faizin vergi kalkanı nedeniyle borçlu işletmenin değeri artar: VL = VU + t × D. Örneğin VU = 10.000.000 TL, D = 4.000.000 TL ve varsayılan t = 0,30 ise VL = 11.200.000 TL'dir.
- **Dengeleme (trade-off) teorisi**: vergi kalkanının faydası, finansal sıkıntı ve iflas maliyetleriyle dengelenir; optimum bu ikisinin eşitlendiği noktadadır.
- **Finansman hiyerarşisi (pecking order) teorisi**: işletmeler bilgi asimetrisi nedeniyle önce iç kaynak, sonra borç, en son yeni hisse ihracını tercih eder; bu teori tek bir optimum öngörmez.

> **Sınav ipucu:** "Vergili MM" sorusunda borç arttıkça değer sürekli artar; optimumun iç bir noktada çıkması için iflas maliyetlerini ekleyen dengeleme teorisi gerekir.

### Tasdik uygulama notu

YMM'ler sermaye maliyeti hesabıyla en çok sermaye artırımı, birleşme ve devirlerde düzenlenen değerleme raporlarında karşılaşır. İndirgenmiş nakit akışı yönteminde iskonto oranı olarak kullanılan AOSM'nin bileşenleri kontrol edilir: risksiz oranın ve piyasa risk priminin dayanağı, betanın hangi benzer şirketlerden ve hangi dönemden türetildiği, borç maliyetinin vergi sonrasına çevrilmesi ve ağırlıkların piyasa değeri ya da hedef yapıya dayanması. Bu bileşenler çalışma kâğıtlarında yeniden hesaplanır; nakit akışının özkaynağa mı yoksa işletmeye mi ait olduğuyla iskonto oranının (ke ya da AOSM) uyumu ayrıca incelenir.

## Özet

- AOSM = (E / V) × ke + (D / V) × kd × (1 − t); ağırlıklar tercihen piyasa değeriyle alınır.
- Borç maliyeti vergi sonrası alınır; özkaynak maliyetine vergi düzeltmesi yapılmaz.
- CAPM: ke = rf + β × (rm − rf); beta = Kov(ri, rm) / Var(rm) ve yalnız sistematik riski ölçer.
- Borç kullanımı betayı artırır (Hamada: βL = βU × [1 + (1 − t) × D / E]).
- FKD = FVÖK / (FVÖK − Faiz); kayıtsızlık noktasının üzerinde borçlu finansman HBK'yi artırır.
- Optimal sermaye yapısı AOSM'yi en düşük, işletme değerini en yüksek yapan bileşimdir.
- Vergili MM'de VL = VU + t × D; dengeleme teorisi iflas maliyetlerini, finansman hiyerarşisi bilgi asimetrisini öne çıkarır.
