---
ders: YNM
konu: FDM
baslik: Faaliyete dayalı ve stratejik maliyetleme
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Faaliyete dayalı maliyetleme"
    madde: "-"
  - mevzuat: "Genel bilgi — Hedef maliyetleme"
    madde: "-"
  - mevzuat: "Genel bilgi — Yaşam boyu maliyetleme"
    madde: "-"
  - mevzuat: "Genel bilgi — Kalite maliyetleri"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Faaliyete dayalı maliyetlemede faaliyet havuzu, maliyet etkeni ve faaliyet oranı kavramlarını
- Geleneksel yükleme ile faaliyete dayalı yükleme arasındaki farkı sayısal örnekle
- Hedef maliyetlemede hedef maliyeti ve maliyet açığını hesaplamayı
- Yaşam boyu maliyetlemede ürünün bütün aşamalarındaki maliyetleri toplamayı
- Kalite maliyetlerini dört gruba ayırmayı ve uygunluk ile uygunsuzluk maliyetini ölçmeyi

## 1. Faaliyete dayalı maliyetleme

### Tanım

**Faaliyete dayalı maliyetleme** (FDM; İngilizce Activity-Based Costing, kısaca ABC), genel üretim giderlerini (GÜG) önce bu giderlere yol açan faaliyetlere, sonra her faaliyetten yararlanma ölçüsüne göre ürünlere yükleyen maliyetleme yöntemidir. Temel varsayım şudur: ürünler faaliyetleri tüketir, faaliyetler de kaynakları tüketir.

- **Faaliyet havuzu**: Aynı nedene bağlı giderlerin toplandığı grup (ör. makine hazırlığı, kalite kontrol, satın alma).
- **Maliyet etkeni**: Bir faaliyetin maliyetini doğuran ve ürünlere yüklemede ölçü olarak kullanılan büyüklük (ör. hazırlık sayısı, muayene sayısı, makine saati).
- **Faaliyet oranı** = Faaliyet havuzunun maliyeti / Maliyet etkeninin toplam miktarı.

### Kural

Geleneksel yöntemde GÜG tek bir hacim ölçüsüyle (genellikle direkt işçilik saati) yüklenir. Bu durumda yüksek hacimli ürünler, düşük hacimli ve karmaşık ürünlerin yol açtığı giderlerin bir kısmını üstlenir; buna **çapraz sübvansiyon** denir. FDM'de hacme bağlı olmayan giderler (hazırlık, muayene gibi parti düzeyi giderler) kendi etkeniyle yüklendiğinden bu çarpıklık azalır.

Faaliyetler genellikle dört düzeyde sınıflandırılır: birim düzeyi (her birimde tekrarlanır), parti düzeyi (her partide bir kez), ürün düzeyi (ürünü sürdürmek için) ve tesis düzeyi (işletmenin tamamı için). Tesis düzeyi giderler ürünlerle nedensel bağ taşımadığından birçok uygulamada ürünlere yüklenmez.

### Örnek: Geleneksel yöntem ile FDM karşılaştırması

İşletme A ve B ürünlerini üretmektedir. Toplam GÜG 600.000 TL'dir. A'dan 10.000 birim, B'den 2.000 birim üretilir. Direkt işçilik saati A için 20.000, B için 4.000 saattir.

| Faaliyet havuzu | Maliyet | Maliyet etkeni | A | B |
|---|---|---|---|---|
| Makine hazırlığı | 240.000 TL | Hazırlık sayısı | 20 | 40 |
| Makine çalıştırma | 300.000 TL | Makine saati | 10.000 | 5.000 |
| Kalite kontrol | 60.000 TL | Muayene sayısı | 100 | 200 |

1. Geleneksel oran = 600.000 / 24.000 saat = 25 TL/saat. A'ya 20.000 × 25 = 500.000 TL (birim 50 TL), B'ye 4.000 × 25 = 100.000 TL (birim 50 TL) yüklenir.
2. Faaliyet oranları: hazırlık 240.000 / 60 = 4.000 TL/hazırlık; makine 300.000 / 15.000 = 20 TL/saat; kalite kontrol 60.000 / 300 = 200 TL/muayene.
3. A'nın payı = 20 × 4.000 + 10.000 × 20 + 100 × 200 = 80.000 + 200.000 + 20.000 = 300.000 TL; birim GÜG = 30 TL.
4. B'nin payı = 40 × 4.000 + 5.000 × 20 + 200 × 200 = 160.000 + 100.000 + 40.000 = 300.000 TL; birim GÜG = 150 TL.
5. Kontrol: 300.000 + 300.000 = 600.000 TL; toplam GÜG değişmez, yalnız ürünler arasındaki dağılım değişir.

Sonuç: Geleneksel yöntem A'yı birim başına 20 TL fazla, B'yi 100 TL eksik maliyetlendirmiştir. Düşük hacimli ve sık hazırlık isteyen B, A tarafından sübvanse edilmektedir.

İstisna: Ürünler benzer hacimde ve benzer karmaşıklıktaysa ya da GÜG'nin büyük kısmı birim düzeyindeyse FDM ile geleneksel yöntem birbirine yakın sonuç verir; bu durumda FDM'nin kurulum ve veri toplama maliyeti faydasını aşabilir.

> **Sık yapılan hata:** FDM'nin toplam maliyeti düşürdüğünü sanmak. FDM toplam GÜG'yü değiştirmez; yalnız ürünler arasındaki paylaşımı daha doğru yapar.

## 2. Hedef maliyetleme

### Tanım ve kural

**Hedef maliyetleme**, ürünün maliyetini piyasanın kabul edeceği fiyattan geriye doğru belirleyen, ürün henüz tasarım aşamasındayken uygulanan stratejik maliyet yönetimi yaklaşımıdır. Formül:

- Hedef maliyet = Hedef satış fiyatı − Hedef kâr
- Maliyet açığı = Tahmini (mevcut tasarımla) maliyet − Hedef maliyet

Klasik "maliyet artı kâr" yaklaşımında fiyat maliyetten türetilir; hedef maliyetlemede ise fiyat piyasadan alınır, maliyet ona uydurulur. Maliyet açığı tasarım değişikliği, değer mühendisliği (işlevi korurken maliyeti düşürme) ve tedarikçilerle iş birliği yoluyla kapatılır.

### Örnek: Hedef maliyet ve maliyet açığı

Yeni bir cihaz için piyasa araştırması hedef satış fiyatını 2.000 TL olarak belirlemiştir. İşletme satışlar üzerinden %20 kâr hedeflemektedir. Mevcut tasarımla tahmini birim maliyet 1.750 TL'dir.

1. Hedef kâr = 2.000 × 0,20 = 400 TL.
2. Hedef maliyet = 2.000 − 400 = 1.600 TL.
3. Maliyet açığı = 1.750 − 1.600 = 150 TL; tasarım bu tutar kadar ucuzlatılmadan üretime geçilmez.

İstisna: Pazarda fiyatı belirleyecek benzer ürün yoksa (tamamen yeni bir ürün) hedef fiyatın tahmini güçleşir; yöntemin etkinliği azalır.

> **Sınav ipucu:** Hedef kâr satış üzerinden mi maliyet üzerinden mi verilmiş, dikkat et. Satışın %20'si 400 TL eder; maliyet üzerinden %20 kâr istenirse hedef maliyet 2.000 / 1,20 olarak bulunur.

## 3. Yaşam boyu maliyetleme

### Tanım ve kural

**Yaşam boyu maliyetleme**, bir ürünün araştırma-geliştirme (Ar-Ge) ve tasarımdan üretime, pazarlama ve dağıtıma, satış sonrası hizmetten piyasadan çekilmesine kadar bütün aşamalarında katlanılan maliyetlerin toplanmasıdır. Geleneksel maliyet muhasebesi yalnız üretim aşamasını ürün maliyetine alır; Ar-Ge ve satış sonrası maliyetler dönem gideri olarak kalır.

Kural: Ürünün kârlılığı, yaşam boyu toplam gelir ile yaşam boyu toplam maliyet karşılaştırılarak değerlendirilir. Maliyetlerin büyük kısmının tasarım aşamasında belirlendiği (taahhüt edildiği) kabul edilir; bu yüzden yöntem hedef maliyetlemeyle birlikte kullanılır.

### Örnek: Yaşam boyu birim maliyet

Ürünün ömrü boyunca 20.000 birim satılması beklenmektedir.

| Aşama | Maliyet |
|---|---|
| Ar-Ge | 400.000 TL |
| Tasarım | 200.000 TL |
| Üretim (20.000 × 50 TL) | 1.000.000 TL |
| Pazarlama ve dağıtım | 300.000 TL |
| Satış sonrası hizmet ve piyasadan çekme | 100.000 TL |
| Toplam | 2.000.000 TL |

1. Yaşam boyu toplam maliyet = 400.000 + 200.000 + 1.000.000 + 300.000 + 100.000 = 2.000.000 TL.
2. Yaşam boyu birim maliyet = 2.000.000 / 20.000 = 100 TL.
3. Yalnız üretim maliyetine (50 TL) bakan yönetici fiyatı 60 TL'ye düşürmeyi kârlı sanabilir; oysa ürünün ömrü boyunca kâr etmesi için ortalama fiyatın 100 TL'yi aşması gerekir.

İstisna: Ömrü çok uzun ürünlerde aşamalar arasında yıllar geçtiğinden paranın zaman değeri önem kazanır; bu durumda maliyetler bugünkü değere indirgenerek karşılaştırılır.

## 4. Kalite maliyetleri

### Tanım ve sınıflandırma

**Kalite maliyetleri**, ürünün kalite gereklerine uygun üretilmesini sağlamak ya da uygun olmayan üretimin sonuçlarını karşılamak için katlanılan maliyetlerdir. Yaygın kabul gören sınıflandırma dört gruptur:

| Grup | Tanım | Örnek |
|---|---|---|
| Önleme maliyetleri | Hata oluşmadan engellemek için | Eğitim, tedarikçi değerlendirme, süreç tasarımı |
| Değerleme (ölçme) maliyetleri | Hatayı müşteriye ulaşmadan tespit etmek için | Muayene, test, kalite denetimi |
| İçsel başarısızlık maliyetleri | Hatalı ürün teslimden önce bulunduğunda | Fire, yeniden işleme, hurda |
| Dışsal başarısızlık maliyetleri | Hatalı ürün müşteriye ulaştıktan sonra | Garanti, iade, şikâyet, itibar kaybı |

Önleme ve değerleme maliyetleri birlikte **uygunluk maliyeti**, içsel ve dışsal başarısızlık maliyetleri birlikte **uygunsuzluk maliyeti** olarak adlandırılır.

### Kural

Önleme harcaması arttıkça başarısızlık maliyetleri azalır. Geleneksel görüş, uygunluk ve uygunsuzluk maliyetlerinin toplamının belirli bir kabul edilebilir hata düzeyinde en düşük olduğunu kabul eder. Modern yaklaşım (toplam kalite yönetimi ve sıfır hata anlayışı) ise önlemeye yapılan harcamanın başarısızlık maliyetlerinde daha büyük tasarruf sağladığını ve toplam kalite maliyetinin sıfır hataya yaklaşıldıkça düştüğünü savunur. Dışsal başarısızlık genellikle en pahalı gruptur; çünkü müşteri kaybı gibi ölçülmesi güç maliyetler doğurur.

### Örnek: Kalite maliyet raporu

Yıllık satışı 5.000.000 TL olan işletmede: eğitim 30.000 TL, tedarikçi değerlendirme 20.000 TL, muayene 70.000 TL, yeniden işleme ve fire 120.000 TL, garanti ve iade 160.000 TL'dir.

1. Önleme = 30.000 + 20.000 = 50.000 TL; değerleme = 70.000 TL.
2. Uygunluk maliyeti = 50.000 + 70.000 = 120.000 TL.
3. Uygunsuzluk maliyeti = 120.000 + 160.000 = 280.000 TL.
4. Toplam kalite maliyeti = 400.000 TL; satışlara oranı = 400.000 / 5.000.000 = %8.

Uygunsuzluk maliyetinin toplamın %70'ini oluşturması, önleme yatırımının artırılması gerektiğine işaret eder.

İstisna: Kaybedilen satış ve itibar kaybı gibi fırsat maliyetleri muhasebe kayıtlarında yer almaz; raporda tahminle gösterilir ya da dışarıda kalır.

### Tasdik uygulama notu

FDM, hedef ve yaşam boyu maliyetleme iç yönetim araçlarıdır; vergi matrahını kendi başına belirlemez. Tam tasdikte FDM kullanan işletmenin dağıtım anahtarlarının belgeli ve tutarlı olması, toplam GÜG'nin eksiksiz olarak stok ve satılan mamul maliyetine yansıması kontrol edilir. Ar-Ge giderlerinin maliyete mi gidere mi alındığı ayrıca incelenir. Kalite maliyetlerinde fire ve hurdanın belgelendirilmesi, garanti giderlerinin gerçekleşmiş tutarlara dayanması ve iadelerin kayıtlara doğru yansıması aranır.

## Özet

- Faaliyete dayalı maliyetleme GÜG'yü faaliyet havuzlarına, oradan maliyet etkenleriyle ürünlere yükler; faaliyet oranı = havuz maliyeti / etken miktarı.
- Geleneksel tek oranlı yükleme, yüksek hacimli ürünlerin düşük hacimli karmaşık ürünleri sübvanse etmesine yol açar; FDM toplam maliyeti değiştirmez.
- Hedef maliyet = hedef satış fiyatı − hedef kâr; maliyet açığı tasarım aşamasında kapatılır.
- Yaşam boyu maliyetleme Ar-Ge'den piyasadan çekilmeye kadar bütün maliyetleri toplar; kârlılık ürünün ömrü boyunca ölçülür.
- Kalite maliyetleri: önleme, değerleme, içsel başarısızlık, dışsal başarısızlık; ilk ikisi uygunluk, son ikisi uygunsuzluk maliyetidir.
- Önlemeye yapılan harcama, en pahalı grup olan dışsal başarısızlık maliyetlerini azaltır.
