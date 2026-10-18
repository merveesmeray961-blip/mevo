---
ders: FYN
konu: RGT
baslik: Risk getiri ve portföy
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Beklenen getiri ve varyans"
    madde: "-"
  - mevzuat: "Genel bilgi — Portföy çeşitlendirmesi"
    madde: "-"
  - mevzuat: "Genel bilgi — Sistematik ve sistematik olmayan risk"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Tek bir varlığın beklenen getirisini, varyansını, standart sapmasını ve değişim katsayısını hesaplamayı
- Kovaryans ve korelasyon katsayısının portföy riskine etkisini
- İki varlıklı portföyün beklenen getirisini ve standart sapmasını bulmayı
- Toplam riskin sistematik ve sistematik olmayan risk olarak ayrıştırılmasını
- Beta katsayısının hesaplanmasını ve portföy betasını

## 1. Beklenen getiri ve varyans

**Getiri**, bir yatırımın dönem içinde sağladığı fiyat değişimi ile nakit dağıtımlarının (kâr payı, faiz) başlangıç değerine oranıdır. **Risk**, gerçekleşecek getirinin beklenen getiriden sapma olasılığıdır ve finansal yönetimde getirilerin dağılımıyla ölçülür.

Getirinin olasılık dağılımı biliniyorsa:

- **Beklenen getiri**: E(R) = Σ pi × Ri (pi: i durumunun olasılığı, Ri: o durumdaki getiri)
- **Varyans**: σ² = Σ pi × (Ri − E(R))²
- **Standart sapma**: σ = √σ²
- **Değişim katsayısı**: DK = σ / E(R)

Finansal yönetimde yatırımcının **riskten kaçınan** olduğu varsayılır: beklenen getirileri eşit iki yatırımdan riski düşük olanı seçer ve daha fazla risk üstlenmek için daha yüksek beklenen getiri ister. Bu ek getiriye **risk primi** denir. Riskten kaçınma, risk ile getirinin aynı yönde hareket etmesini açıklar; aynı risk düzeyinde daha düşük getiri sunan bir varlık rasyonel yatırımcı tarafından tercih edilmez.

Olasılıklar toplamı 1 olmalıdır. Değişim katsayısı, birim beklenen getiri başına düşen riski gösterir; beklenen getirileri farklı yatırımlar karşılaştırılırken standart sapma yerine DK kullanılır ve DK'si düşük olan tercih edilir.

Getiriler geçmiş gözlemlerden hesaplanıyorsa ortalama, gözlemlerin basit aritmetik ortalamasıdır. Bu durumda **örneklem varyansı** kullanılır ve sapma kareleri toplamı (n − 1)'e bölünür; ana kütle varyansında n'e bölünür. Sınav sorusu hangisini istediğini belirtmiyorsa ders kitaplarında yaygın olan (n − 1) yöntemi esas alınır.

### Örnek: Beklenen getiri, varyans ve standart sapma

İki hisse senedi için ekonominin üç durumuna ait getiriler aşağıdadır:

| Ekonomi | Olasılık | A getirisi | B getirisi |
|---|---|---|---|
| Durgunluk | 0,25 | −%10 | %20 |
| Normal | 0,50 | %15 | %8 |
| Canlı | 0,25 | %35 | −%4 |

1. E(RA) = 0,25 × (−10) + 0,50 × 15 + 0,25 × 35 = −2,5 + 7,5 + 8,75 = %13,75.
2. σA² = 0,25 × (−23,75)² + 0,50 × (1,25)² + 0,25 × (21,25)² = 141,0156 + 0,7813 + 112,8906 = 254,6875 (%²); σA ≈ %15,96.
3. E(RB) = 0,25 × 20 + 0,50 × 8 + 0,25 × (−4) = %8; σB² = 0,25 × 12² + 0,50 × 0² + 0,25 × (−12)² = 72 (%²); σB ≈ %8,49.
4. DKA = 15,96 / 13,75 ≈ 1,16; DKB = 8,49 / 8 ≈ 1,06. Birim getiri başına riski daha düşük olan B'dir.

> **Sık yapılan hata:** Varyansı yüzde cinsinden hesaplayıp (254,69) ondalık cinsten bir standart sapmayla karıştırmak. Getiriyi %15 olarak alırsan varyansın birimi %² olur; ondalık (0,15) alırsan A'nın varyansı 0,0255 çıkar. Tek bir birim seçip sonuna kadar onu kullan.

## 2. Portföy çeşitlendirmesi

**Portföy**, birden fazla varlıktan oluşan yatırım bütünüdür. **Portföy çeşitlendirmesi**, birbirleriyle tam pozitif ilişkili olmayan varlıkları bir araya getirerek getiri düzeyini korurken riski azaltmaktır.

Portföyün beklenen getirisi, varlık getirilerinin ağırlıklı ortalamasıdır: E(Rp) = Σ wi × E(Ri), wi varlığın portföydeki ağırlığıdır (ağırlıklar toplamı 1). Portföy riski ise ağırlıklı ortalama değildir; varlıkların birlikte hareketine bağlıdır:

- **Kovaryans**: Kov(A,B) = Σ pi × (RA,i − E(RA)) × (RB,i − E(RB))
- **Korelasyon katsayısı**: ρAB = Kov(A,B) / (σA × σB), −1 ile +1 arasında
- **İki varlıklı portföy varyansı**: σp² = wA² × σA² + wB² × σB² + 2 × wA × wB × Kov(A,B), ya da kovaryans yerine ρAB × σA × σB

Kurallar şöyledir. ρ = +1 ise portföyün standart sapması, standart sapmaların ağırlıklı ortalamasına eşittir; çeşitlendirme yararı yoktur. ρ < +1 ise portföy riski ağırlıklı ortalamanın altına düşer. ρ = −1 ise wA = σB / (σA + σB) ağırlığıyla risksiz portföy kurulabilir.

### Örnek: İki varlıklı portföy

Yukarıdaki A ve B hisselerine eşit ağırlıkla (wA = wB = 0,50) yatırım yapılıyor.

1. Kov(A,B) = 0,25 × (−23,75) × 12 + 0,50 × 1,25 × 0 + 0,25 × 21,25 × (−12) = −71,25 + 0 − 63,75 = −135 (%²).
2. ρAB = −135 / (15,96 × 8,49) ≈ −0,997.
3. E(Rp) = 0,50 × 13,75 + 0,50 × 8 = %10,875.
4. σp² = 0,25 × 254,6875 + 0,25 × 72 + 2 × 0,25 × (−135) = 63,6719 + 18 − 67,5 = 14,1719 (%²); σp ≈ %3,76.
5. Ağırlıklı ortalama standart sapma 0,50 × 15,96 + 0,50 × 8,49 ≈ %12,22 olurdu. Neredeyse tam negatif korelasyon nedeniyle portföy riski %3,76'ya inmiştir.

Kontrol: Portföyün durumlara göre getirileri %5, %11,5 ve %15,5'tir; bunlardan doğrudan hesaplanan varyans da 14,1719 (%²) çıkar.

> **Sınav ipucu:** Soruda korelasyon verilip kovaryans istenmiyorsa formülde Kov(A,B) yerine doğrudan ρ × σA × σB yaz. ρ = +1 sorularında hesap yapmadan σp = wA × σA + wB × σB yazabilirsin.

**Etkin portföy**, aynı risk düzeyinde en yüksek beklenen getiriyi (ya da aynı getiride en düşük riski) sunan portföydür; bu portföylerin oluşturduğu eğriye **etkin sınır** denir (Markowitz yaklaşımı). Eşit ağırlıklı portföyde varlık sayısı arttıkça tek tek varyansların etkisi azalır ve portföy varyansı, varlıklar arasındaki **ortalama kovaryansa** yaklaşır. İstisna: Varlıklar arasında yüksek pozitif korelasyon varsa (ör. aynı sektörden hisseler) varlık sayısını artırmak riski anlamlı ölçüde düşürmez.

## 3. Sistematik ve sistematik olmayan risk

Bir varlığın **toplam riski** (σ²) iki bileşenden oluşur:

- **Sistematik risk (pazar riski)**: Faiz, enflasyon, kur, ekonomik büyüme ve siyasi gelişmeler gibi tüm piyasayı etkileyen faktörlerden doğar. Çeşitlendirmeyle giderilemez.
- **Sistematik olmayan risk (firmaya özgü risk)**: Grev, yönetim hatası, dava, ürün başarısızlığı gibi tek bir firmaya ya da sektöre özgü olaylardan doğar. İyi çeşitlendirilmiş portföyde büyük ölçüde ortadan kalkar.

Çeşitlendirmeyle giderilebilen risk için piyasa ek getiri ödemez; bu nedenle beklenen getiriyi belirleyen yalnız sistematik risktir. Sistematik risk **beta katsayısı** (β) ile ölçülür:

- β = Kov(Ri, Rm) / σm² = ρim × σi / σm
- Tek endeks modeline göre ayrıştırma: σi² = βi² × σm² + σε² (ilk terim sistematik, ikinci terim sistematik olmayan risk)
- Portföy betası: βp = Σ wi × βi (betalar ağırlıklı ortalamayla toplanır)

β = 1 olan varlık piyasayla aynı oranda hareket eder; β > 1 olan agresif, β < 1 olan defansif varlıktır. Risksiz varlığın betası sıfırdır. Betanın beklenen getiriye dönüştürülmesi Sermaye Varlıklarını Fiyatlama Modeli (CAPM) ile yapılır; bu model sermaye maliyeti konusunda işlenir.

### Örnek: Beta ve risk ayrıştırması

X hissesinin piyasa getirisiyle kovaryansı 0,0216, piyasa getirisinin standart sapması 0,12, X'in standart sapması 0,25'tir.

1. σm² = 0,12² = 0,0144.
2. β = 0,0216 / 0,0144 = 1,5.
3. Toplam risk = 0,25² = 0,0625.
4. Sistematik risk = 1,5² × 0,0144 = 0,0324; sistematik olmayan risk = 0,0625 − 0,0324 = 0,0301.
5. Toplam riskin %51,84'ü sistematiktir (0,0324 / 0,0625). Bu oran ρim²'ye eşittir: ρim = 0,0216 / (0,25 × 0,12) = 0,72 ve 0,72² = 0,5184.
6. Portföyün %40'ı X'e (β = 1,5), %60'ı betası 0,8 olan Y'ye yatırılırsa βp = 0,4 × 1,5 + 0,6 × 0,8 = 1,08 olur.

İstisna: Beta geçmiş verilerle tahmin edildiği için firmanın faaliyet ya da sermaye yapısı değiştiğinde geçmiş beta geleceği yansıtmayabilir.

### Tasdik uygulama notu

Tam tasdik ve incelemede risk-getiri bilgisi özellikle işletmenin finansal yatırımları ve riskten korunma işlemlerinde karşına çıkar. Menkul kıymet portföyünün alım-satım kayıtları aracı kurum ekstreleriyle, türev ürün sözleşmeleri banka teyitleriyle karşılaştırılır. Kur veya faiz riskinden korunma amacıyla yapıldığı söylenen türev işlemlerinde, korunan kalemin gerçekten var olup olmadığı ve işlemin belgeleri incelenir; ilişkili kişilerle piyasa koşullarından farklı getiri sağlayan işlemler ilgili vergi mevzuatı yönünden ayrıca değerlendirilir. Yüksek riskli yatırımlarda oluşan zararların işletmenin faaliyetiyle ilgisi ve belgelendirilmesi ayrıca kontrol edilir.

## Özet

- E(R) = Σ pi × Ri; σ² = Σ pi × (Ri − E(R))²; DK = σ / E(R). Geçmiş veride örneklem varyansı (n − 1) ile hesaplanır.
- Portföyün beklenen getirisi ağırlıklı ortalamadır; portföy riski ise kovaryansa (korelasyona) bağlıdır.
- σp² = wA²σA² + wB²σB² + 2wAwBρσAσB; ρ = +1'de çeşitlendirme yararı yoktur, ρ = −1'de risksiz portföy kurulabilir.
- Varlık sayısı arttıkça portföy varyansı ortalama kovaryansa yaklaşır.
- Toplam risk = sistematik (çeşitlendirilemez) + sistematik olmayan (çeşitlendirilebilir) risk.
- β = Kov(Ri, Rm) / σm²; portföy betası ağırlıklı ortalamadır; piyasa yalnız sistematik riski ödüllendirir.
