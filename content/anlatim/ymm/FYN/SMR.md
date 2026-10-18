---
ders: FYN
konu: SMR
baslik: Sermaye maliyeti ve sermaye yapısı
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Ağırlıklı ortalama sermaye maliyeti"
    madde: "-"
  - mevzuat: "Genel bilgi — Sermaye varlıklarını fiyatlama modeli (CAPM) ve beta"
    madde: "-"
  - mevzuat: "Genel bilgi — Finansal kaldıraç ve FAVÖK-HBK analizi"
    madde: "-"
  - mevzuat: "Genel bilgi — Optimal sermaye yapısı ve sermaye yapısı teorileri"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Borç ve özkaynak maliyetinden ağırlıklı ortalama sermaye maliyetini hesaplamak ve ters çözmek
- CAPM ile özkaynak maliyetini bulmak; varlık betası ile özkaynak betası arasında geçiş yapmak
- FAVÖK-HBK analiziyle finansman planlarını karşılaştırmak ve kayıtsızlık noktasını bulmak
- Optimal sermaye yapısını, sermaye yapısı teorilerini ve sermaye yapısını etkileyen faktörleri açıklamak

## 1. Ağırlıklı ortalama sermaye maliyeti

**Sermaye maliyeti**, fon sağlayıcıların istediği asgari getiridir ve proje değerlendirmede iskonto oranıdır. **Ağırlıklı ortalama sermaye maliyeti (AOSM)**, her kaynağın maliyetinin sermaye yapısındaki payıyla çarpılıp toplanmasıdır:

- AOSM = (E / V) × ke + (D / V) × kd × (1 − t) [+ (P / V) × kp]

E özkaynak, D faizli borç, P imtiyazlı hisse, V toplam sermaye; ke, kd, kp ilgili maliyetler; t vergi oranıdır. Faiz vergi matrahından indirildiği için borç maliyeti **vergi sonrası** alınır; kâr payı indirilemediğinden ke'ye düzeltme yapılmaz. Ağırlıklar tercihen **piyasa değeriyle** (ya da hedef yapıyla) alınır; borç maliyeti kayıtlı eski faiz değil, bugünkü borçlanma maliyetidir. Özkaynak maliyeti Gordon modeliyle (ke = D1 / P0 + g) ya da CAPM ile bulunur.

### Örnek: AOSM hesabı

Özkaynağın piyasa değeri 6.000.000 TL, borcun 4.000.000 TL; risksiz faiz %10, piyasa getirisi %18, beta 1,2; borcun vergi öncesi maliyeti %15; vergi oranı hesap amacıyla %30 varsayılmıştır.

1. Ağırlıklar: E / V = 0,60; D / V = 0,40.
2. ke = 0,10 + 1,2 × (0,18 − 0,10) = %19,6.
3. Vergi sonrası borç maliyeti: 15 × 0,70 = %10,5.
4. AOSM = 0,60 × 19,6 + 0,40 × 10,5 = 11,76 + 4,20 = %15,96.

Ortalama riskli bir projenin kabulü için İVO'su %15,96'yı aşmalıdır; riski farklı projede riske göre düzeltilmiş oran kullanılır.

### Örnek: Ters çözüm, vergi oranının bulunması

E / V = D / V = 0,5; ke = %24; kd = %20. Vergi oranı 10 puan artınca AOSM %5 düşmektedir; başlangıç vergi oranı nedir?

1. AOSM(t) = 12 + 10 × (1 − t) puan.
2. 12 + 10 × (1 − t − 0,10) = 0,95 × [12 + 10 × (1 − t)] → 21 − 10t = 20,9 − 9,5t → t = 0,20.
3. Kontrol: t = %20'de AOSM %20; t = %30'da AOSM %19 = 0,95 × 20.

> **Sık yapılan hata:** AOSM'de borç maliyetini (1 − t) ile çarpmayı unutmak ya da vergi düzeltmesini özkaynak maliyetine de uygulamak.

## 2. CAPM ve beta

**Sermaye varlıklarını fiyatlama modeli (CAPM)** beklenen getiriyi yalnız sistematik riske bağlar: ke = rf + β × (rm − rf). (rm − rf) **piyasa risk primi**dir; örnekte %8, hissenin risk primi 1,2 × 8 = %9,6'dır.

**Beta**, hisse getirisinin piyasa getirisine duyarlılığıdır ve **sistematik riski** ölçer: β = Kov(ri, rm) / Var(rm). Kovaryans 0,024, piyasa varyansı 0,020 ise β = 1,2. β > 1 agresif, β < 1 defansif hissedir; risksiz varlığın betası sıfırdır.

**Varlık betası** (işletmenin faaliyet riski), borç ve özkaynak betalarının ağırlıklı ortalamasıdır: βA = (E / V) βE + (D / V) βD. Vergisiz Modigliani-Miller (MM) çerçevesinde varlık getirisi ra sermaye yapısından bağımsızdır; borç artınca özkaynak maliyeti ve betası şöyle yükselir:

- ke = ra + (ra − kd) × D / E; βE = βA + (βA − βD) × D / E

Örnek: rf %10, piyasa risk primi %8, βA = 1,0 (ra = %18), βD = 0,25 (kd = %12). İşletme tahvil ihraç ederek D / E = 0,5'e geçerse ke = 18 + (18 − 12) × 0,5 = %21 ve βE = 1 + 0,75 × 0,5 = 1,375 olur; CAPM ile kontrol: 10 + 1,375 × 8 = %21. Vergi varsa yaygın olarak **Hamada denklemi** kullanılır: βL = βU × [1 + (1 − t) × D / E]; βU = 0,9, D / E = 0,5, t = 0,30 ise βL = 1,215.

> **Sınav ipucu:** CAPM'de beta piyasa getirisiyle değil, piyasa risk primiyle çarpılır. Soru doğrudan "risk primi" veriyorsa ayrıca rf çıkarma.

## 3. Finansal kaldıraç ve FAVÖK-HBK analizi

**Finansal kaldıraç**, sabit maliyetli fonların kullanılmasıyla faiz ve vergi öncesi kârdaki (FVÖK) değişimin hisse başına kâra (HBK) büyüyerek yansımasıdır. HBK = (FVÖK − Faiz) × (1 − t) / Hisse sayısı; finansal kaldıraç derecesi FKD = FVÖK / (FVÖK − Faiz). Sınavda bu karşılaştırma "FAVÖK-HBK analizi" adıyla sorulur; kullanılan kâr ölçüsü faiz ve vergi öncesi kârdır.

**Kayıtsızlık noktası**, iki finansman planının HBK'sini eşitleyen FVÖK'tür: (FVÖK* − F1) × (1 − t) / N1 = (FVÖK* − F2) × (1 − t) / N2.

### Örnek: İki finansman planı

Toplam sermaye 5.000.000 TL, FVÖK 1.000.000 TL, varsayılan t = %30. A planı tamamen özkaynak (500.000 hisse); B planı yarı %15 faizli borç (faiz 375.000 TL), yarı özkaynak (250.000 hisse).

1. A: HBK = 1.000.000 × 0,70 / 500.000 = 1,40 TL.
2. B: HBK = 625.000 × 0,70 / 250.000 = 1,75 TL; FKD = 1.000.000 / 625.000 = 1,6.
3. FVÖK %20 artıp 1.200.000 TL olursa B'de HBK 2,31 TL'ye çıkar (%32 = 1,6 × %20).
4. Kayıtsızlık: FVÖK* / 500.000 = (FVÖK* − 375.000) / 250.000 → FVÖK* = 750.000 TL; iki planda HBK 1,05 TL.

FVÖK 750.000 TL'nin üzerindeyse borçlu plan daha yüksek HBK verir. Ters çözüm sorularında (ör. "HBK'nin belirli bir tutar olması için gereken borç tutarı") bilinmeyen faiz ya da hisse sayısı HBK denkleminde yalnız bırakılır.

## 4. Optimal sermaye yapısı ve teoriler

**Optimal sermaye yapısı**, AOSM'yi en düşük, işletme değerini en yüksek yapan borç-özkaynak bileşimidir. Borç arttıkça önce ucuz borç AOSM'yi düşürür; sonra finansal risk ke ve kd'yi yükseltir. Varsayımsal tabloda (t = %30) optimum %40 borçtadır:

| Borç / Toplam sermaye | kd | ke | AOSM |
|---|---|---|---|
| %0 | - | %16 | %16,00 |
| %20 | %10 | %17 | %15,00 |
| %40 | %12 | %19 | %14,76 |
| %60 | %16 | %25 | %16,72 |

### Sermaye yapısı teorileri

- **Net kâr yaklaşımı**: ke ve kd sabittir; borç arttıkça AOSM düşer, en çok borç en iyisidir.
- **Net faaliyet kârı yaklaşımı**: AOSM sabittir; borç arttıkça ke yükselir, sermaye yapısı değeri etkilemez.
- **Geleneksel yaklaşım**: makul borç düzeyine kadar AOSM düşer, sonra yükselir; U biçimli AOSM eğrisinin dibinde optimum vardır.
- **MM vergisiz**: kusursuz piyasada değer sermaye yapısından bağımsızdır. **MM kurumlar vergili**: VL = VU + t × D (VU = 10.000.000, D = 4.000.000, t = 0,30 ise VL = 11.200.000 TL).
- **Dengeleme (ödünleşme, trade-off) kuramı**: vergi kalkanının faydası finansal sıkıntı ve iflas maliyetleriyle dengelenir; optimum marjinal fayda ile marjinal maliyetin eşitlendiği yerdedir.
- **Finansman hiyerarşisi**: bilgi asimetrisi nedeniyle önce iç kaynak, sonra borç, en son yeni hisse tercih edilir; tek bir optimum öngörmez.

**Sermaye yapısını etkileyen faktörler**: iç faktörler olarak kârlılık ve iç fon yaratma gücü, satış ve faaliyet riski (faaliyet kaldıracı), varlık yapısı (teminata uygun duran varlık), büyüme hızı, yönetimin risk tutumu ve kontrolü kaybetme kaygısı; dış faktörler olarak faiz düzeyi ve kredi bulunabilirliği, vergi düzenlemeleri, sermaye piyasası koşulları, kredi derecelendirme notu ve sektör normları sayılır.

> **Sınav ipucu:** Vergili MM'de borç arttıkça değer sürekli artar; iç bir optimum için iflas maliyetlerini ekleyen dengeleme kuramı ya da geleneksel yaklaşım gerekir.

### Tasdik uygulama notu

YMM, sermaye maliyetiyle en çok birleşme, devir ve sermaye artırımlarında düzenlenen değerleme raporlarında karşılaşır. İndirgenmiş nakit akışında kullanılan AOSM'nin bileşenleri (risksiz oran, risk primi, betanın türetildiği benzer şirketler, vergi sonrası borç maliyeti, ağırlıklar) çalışma kâğıdında yeniden hesaplanır; nakit akışının özkaynağa mı işletmeye mi ait olduğu ile iskonto oranının (ke ya da AOSM) uyumu kontrol edilir.

## Özet

- AOSM = (E / V) ke + (D / V) kd (1 − t); ağırlıklar piyasa değeri ya da hedef yapıyla alınır.
- Ters çözümde AOSM denklemi bilinmeyen (vergi oranı, ağırlık, maliyet) için çözülür ve sonuç kontrol edilir.
- CAPM: ke = rf + β (rm − rf); β = Kov / Var; βA = (E / V) βE + (D / V) βD.
- Vergisiz MM'de ke = ra + (ra − kd) D / E; vergili durumda Hamada denklemi kullanılır.
- HBK = (FVÖK − Faiz)(1 − t) / N; kayıtsızlık noktasının üstünde borçlu plan HBK'yi artırır.
- Optimal yapı AOSM'yi en düşük yapan bileşimdir; geleneksel yaklaşım ve dengeleme kuramı iç optimum öngörür.
- Sermaye yapısı kârlılık, risk, varlık yapısı, büyüme, kontrol gibi iç; faiz, vergi, piyasa ve sektör gibi dış faktörlerden etkilenir.
