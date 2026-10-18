---
ders: FYN
konu: FPA
baslik: Finansal planlama analiz ve kâr dağıtımı
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Oran analizi ve DuPont"
    madde: "-"
  - mevzuat: "Genel bilgi — Nakit bütçesi"
    madde: "-"
  - mevzuat: "Genel bilgi — Kaldıraç dereceleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Kâr payı politikası"
    madde: "-"
  - mevzuat: "Genel bilgi — Birleşme ve satın alma değerlemesi"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Oran analizi ve DuPont: temel oran grupları ve özkaynak kârlılığının ayrıştırılması
- Nakit bütçesi hazırlama ve finansman ihtiyacının belirlenmesi
- Kaldıraç dereceleri (faaliyet; finansal; birleşik) ve satış değişiminin kâra etkisi
- Kâr payı politikası teorileri ve artık kâr payı yaklaşımı
- Birleşme ve satın alma değerlemesi: sinerji, prim ve indirgenmiş nakit akışı

## 1. Oran analizi ve DuPont

**Oran analizi**, finansal tablo kalemleri arasındaki anlamlı ilişkilerin oranlarla ölçülüp geçmiş dönemler ve sektörle karşılaştırılmasıdır. Dört ana grup vardır:

| Grup | Başlıca oranlar |
|---|---|
| Likidite | Cari oran = Dönen varlıklar / KVYK; asit-test oranı = (Dönen varlıklar − Stoklar) / KVYK; nakit oran |
| Faaliyet | Stok, alacak ve aktif devir hızları |
| Finansal yapı | Borç oranı = Toplam borç / Toplam aktif; borç / özkaynak |
| Kârlılık | Net kâr marjı, aktif kârlılığı (ROA), özkaynak kârlılığı (ROE) |

KVYK, kısa vadeli yabancı kaynakları ifade eder. **DuPont analizi**, kârlılığı bileşenlerine ayırır:

- ROA = Net kâr marjı × Aktif devir hızı = (Net kâr / Satışlar) × (Satışlar / Toplam aktif)
- ROE = Net kâr marjı × Aktif devir hızı × Özkaynak çarpanı; özkaynak çarpanı = Toplam aktif / Özkaynak = 1 / (1 − Borç oranı)

Bu anlatımda dönem sonu bakiyeler kullanılmıştır; bazı kaynaklar aktif ve özkaynak için dönem başı ve sonu ortalamasını alır.

### Örnek: DuPont ayrıştırması

Satışlar 10.000.000 TL, net kâr 800.000 TL, toplam aktif 8.000.000 TL, özkaynak 3.200.000 TL'dir.

1. Net kâr marjı = 800.000 / 10.000.000 = %8.
2. Aktif devir hızı = 10.000.000 / 8.000.000 = 1,25.
3. Özkaynak çarpanı = 8.000.000 / 3.200.000 = 2,5 (borç oranı %60).
4. ROA = %8 × 1,25 = %10; ROE = %10 × 2,5 = %25. Kontrol: 800.000 / 3.200.000 = %25.

> **Sınav ipucu:** ROE = ROA × Özkaynak çarpanı olduğundan, ROE'si yüksek ama ROA'sı düşük işletmede yüksek ROE'nin kaynağı borçlanmadır (yüksek özkaynak çarpanı). DuPont, kârlılığın marjdan mı, verimlilikten mi, kaldıraçtan mı geldiğini gösterir.

İstisna: Oranlar tek başına yorumlanmaz; enflasyon, farklı muhasebe politikaları ve mevsimsellik karşılaştırmayı bozabilir.

## 2. Nakit bütçesi

**Nakit bütçesi**, gelecek dönemlerin nakit giriş ve çıkışlarının dönemler itibarıyla tahminidir. Kuruluş sırası: dönem başı nakit + nakit girişleri (tahsilatlar) − nakit çıkışları = finansman öncesi nakit; bu tutar **asgari nakit** düzeyinin altındaysa kredi kullanılır, üstündeyse fazla ile önce kredi geri ödenir. Amortisman nakit çıkışı değildir, bütçeye girmez.

### Örnek: Üç aylık nakit bütçesi

Satışlar: Aralık 900.000, Ocak 1.000.000, Şubat 1.200.000, Mart 1.500.000 TL. Satışların %40'ı peşin, %60'ı bir ay sonra tahsil edilir. Ödemeler: Ocak 1.100.000, Şubat 1.000.000, Mart 1.300.000 TL. Ocak başı nakit 150.000 TL, asgari nakit 100.000 TL; kredi faizi basitlik için ihmal edilmiştir.

| Kalem | Ocak | Şubat | Mart |
|---|---|---|---|
| Dönem başı nakit | 150.000 | 100.000 | 100.000 |
| Tahsilat | 940.000 | 1.080.000 | 1.320.000 |
| Ödemeler | 1.100.000 | 1.000.000 | 1.300.000 |
| Finansman öncesi nakit | −10.000 | 180.000 | 120.000 |
| Kredi kullanımı (+) / geri ödeme (−) | 110.000 | −80.000 | −20.000 |
| Dönem sonu nakit | 100.000 | 100.000 | 100.000 |
| Kredi bakiyesi | 110.000 | 30.000 | 10.000 |

1. Ocak tahsilatı = 0,40 × 1.000.000 + 0,60 × 900.000 = 940.000 TL.
2. Ocak sonu 150.000 + 940.000 − 1.100.000 = −10.000 TL; asgari düzey için 110.000 TL kredi gerekir.
3. Şubat tahsilatı = 480.000 + 600.000 = 1.080.000 TL; 180.000 TL'nin 80.000 TL'si krediyi öder.
4. Mart tahsilatı = 600.000 + 720.000 = 1.320.000 TL; 20.000 TL geri ödenir, 10.000 TL kredi kalır.

## 3. Kaldıraç dereceleri (faaliyet; finansal; birleşik)

Kaldıraç, sabit maliyetlerin kârdaki değişimi büyütmesidir. Bu anlatımda katkı payı (KP) = Satışlar − Değişken giderler, FVÖK = faiz ve vergi öncesi kâr, VÖK = vergi öncesi kâr olarak alınmıştır:

- **Faaliyet kaldıracı derecesi (FAKD)** = % değişim FVÖK / % değişim satış = KP / FVÖK
- **Finansal kaldıraç derecesi (FİKD)** = % değişim hisse başına kâr / % değişim FVÖK = FVÖK / (FVÖK − Faiz)
- **Birleşik kaldıraç derecesi (BKD)** = FAKD × FİKD = KP / (FVÖK − Faiz)

İmtiyazlı hisse varsa FİKD paydasından ayrıca imtiyazlı kâr payının vergi öncesi karşılığı, yani İmtiyazlı kâr payı / (1 − vergi oranı) düşülür. Formüller belirli bir satış düzeyine göre hesaplanır; satış düzeyi değişince dereceler de değişir.

### Örnek: Kaldıraç dereceleri

20.000 adet, birim fiyat 100 TL, birim değişken gider 60 TL, sabit faaliyet gideri 500.000 TL, faiz 100.000 TL.

1. KP = 20.000 × 40 = 800.000 TL; FVÖK = 300.000 TL; VÖK = 200.000 TL.
2. FAKD = 800.000 / 300.000 ≈ 2,67; FİKD = 300.000 / 200.000 = 1,5; BKD = 800.000 / 200.000 = 4 (FAKD × FİKD ile aynı sonuç).
3. Satışlar %10 artarsa FVÖK %26,67 (380.000 TL), VÖK ve hisse başına kâr %40 (280.000 TL) artar.

> **Sık yapılan hata:** Faizi FAKD hesabına katmak. Faiz finansman giderdir; yalnız FİKD ve BKD'yi etkiler. Başabaş noktasına (burada 12.500 adet) yaklaştıkça FAKD sınırsız büyür.

## 4. Kâr payı politikası

**Kâr payı politikası**, net kârın ne kadarının dağıtılıp ne kadarının işletmede tutulacağına ilişkin karardır. Başlıca görüşler:

- **İlgisizlik görüşü (Modigliani-Miller)**: Vergisiz ve kusursuz piyasada, yatırım politikası veri iken kâr payı politikası firma değerini etkilemez.
- **Eldeki kuş görüşü (Gordon, Lintner)**: Yatırımcı belirsiz sermaye kazancı yerine kesin kâr payını tercih eder.
- **Vergi farkı görüşü**: Kâr payı sermaye kazancından ağır vergileniyorsa düşük dağıtım tercih edilir.
- **Sinyal ve müşteri (yatırımcı kitlesi) etkisi**: Kâr payı değişikliği yönetimin beklentisini duyurur; her politika kendi yatırımcı kitlesini çeker.

Uygulamada istikrarlı kâr payı, sabit dağıtım oranı, düşük düzenli artı ek kâr payı ve **artık kâr payı** politikaları görülür. Artık politikada önce kârlı yatırımların hedef sermaye yapısına göre özkaynak payı ayrılır, kalan dağıtılır. Ör. net kâr 5.000.000 TL, yatırım bütçesi 4.000.000 TL, hedef yapı %40 borç, %60 özkaynak ise özkaynak ihtiyacı 2.400.000 TL, dağıtılabilir tutar 2.600.000 TL'dir (dağıtım oranı %52). Hisse geri alımı nakit dağıtımın alternatifidir; bedelsiz hisse ve hisse bölünmesi ise özkaynak toplamını değiştirmez.

## 5. Birleşme ve satın alma değerlemesi

Birleşme yatay (aynı sektör), dikey (tedarik zinciri) ya da karma olabilir. Temel gerekçe **sinerjidir**: Sinerji = V(AB) − (V(A) + V(B)). Ödenen bedelin hedefin bağımsız değerini aşan kısmı **primdir**; alıcı açısından NBD = Sinerji − Prim. Hedefin değeri genellikle **indirgenmiş nakit akışları** (serbest nakit akışının AOSM ile indirgenmesi; sabit büyümede değer = gelecek yılın serbest nakit akışı / (AOSM − g)), **çarpanlar** (F/K, FD/FAVÖK) ve **net aktif değeri** yöntemleriyle bulunur. AOSM, ağırlıklı ortalama sermaye maliyetidir; FD firma değeri, FAVÖK faiz, amortisman ve vergi öncesi kârdır.

### Örnek: Satın alma değerlemesi

Hedef firmanın gelecek yıl serbest nakit akışı 10.000.000 TL, AOSM %12, sürekli büyüme %4, net borcu 25.000.000 TL, 10.000.000 hissesi vardır. Sinerjinin bugünkü değeri 20.000.000 TL, teklif 115.000.000 TL'dir.

1. Firma değeri = 10.000.000 / (0,12 − 0,04) = 125.000.000 TL.
2. Özkaynak değeri = 125.000.000 − 25.000.000 = 100.000.000 TL; hisse başına 10 TL.
3. Prim = 115.000.000 − 100.000.000 = 15.000.000 TL.
4. Alıcı NBD = 20.000.000 − 15.000.000 = 5.000.000 TL; teklif kabul edilebilir.
5. Ödeme hisseyle yapılacak ve alıcının hisse fiyatı 25 TL ise teklif hisse başına 115.000.000 / 10.000.000 = 11,5 TL; değişim oranı = 11,5 / 25 = 0,46 (hedefin her hissesine 0,46 alıcı hissesi).

İstisna: Ödeme hisseyle yapılırsa sinerjinin bir bölümü hedef ortaklarına geçer; prim nakit ödemedeki gibi sabit kalmaz.

### Tasdik uygulama notu

Tam tasdikte YMM oran analizini analitik inceleme aracı olarak kullanır: brüt kâr marjı ve devir hızlarındaki olağandışı sapmalar ayrıntılı incelemeyi yönlendirir. Kâr dağıtımında yedek akçe ayrımı, genel kurul kararı ve kâr payı ödemelerine ilişkin vergi kesintisi yükümlülükleri belgelerle kontrol edilir. Birleşme ve devirlerde ilgili ticaret ve vergi mevzuatındaki şartlar, değerleme dayanakları ve devredilen değerlerin kayıtlara aktarımı incelenir.

## Özet

- DuPont: ROE = Net kâr marjı × Aktif devir hızı × Özkaynak çarpanı.
- Nakit bütçesi: dönem başı nakit + tahsilat − ödemeler; asgari nakit altına düşülürse kredi, fazla varsa geri ödeme.
- FAKD = KP / FVÖK; FİKD = FVÖK / (FVÖK − Faiz); BKD = FAKD × FİKD.
- Faiz yalnız finansal kaldıracı etkiler; başabaş noktasına yaklaştıkça FAKD büyür.
- MM'ye göre kâr payı politikası ilgisizdir; eldeki kuş, vergi farkı ve sinyal görüşleri farklı sonuç verir.
- Artık politikada dağıtılabilir kâr = Net kâr − Yatırım × Hedef özkaynak oranı.
- Satın almada alıcı NBD = Sinerji − Prim; değer indirgenmiş nakit akışı, çarpanlar veya net aktif değeriyle bulunur.
