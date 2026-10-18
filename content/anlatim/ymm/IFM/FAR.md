---
ders: IFM
konu: FAR
baslik: Finansal araçlar
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: TFRS 9 Finansal Araçlar
    madde: par. 4.1.2
    alinti: "Bir finansal varlık aşağıdaki her iki şartın birden sağlanması durumunda itfa edilmiş maliyeti"
  - mevzuat: TFRS 9 Finansal Araçlar
    madde: par. 5.4.1
    alinti: "gelir, aşağıdakiler dışında, finansal varlığın brüt defter değerine etkin faiz oranı uygulanarak hesaplanır:"
  - mevzuat: TFRS 9 Finansal Araçlar
    madde: par. 5.5.5
    alinti: "meydana gelmemiş olması durumunda işletme söz konusu finansal araca ilişkin zarar karşılığını 12"
  - mevzuat: TFRS 9 Finansal Araçlar
    madde: par. 6.4.1
    alinti: "Bir korunma ilişkisine, sadece aşağıdaki tüm kıstaslar karşılandığında korunma muhasebesi"
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 279
    alinti: "dışında kalan her türlü menkul kıymet borsa rayici ile değerlenir. Borsa rayici yoksa veya"
---
## Bu konuda neler öğreneceksin

- Finansal varlıkların üç ölçüm kategorisini ve sınıflandırmada kullanılan iki testi
- Etkin faiz oranını hesaplamayı ve itfa edilmiş maliyet tablosu kurmayı
- Beklenen kredi zararında 12 aylık ve ömür boyu ölçüm ayrımını, basitleştirilmiş yaklaşımı
- Korunma muhasebesinin uygulanma kıstaslarını ve üç korunma türünü
- Türkiye Finansal Raporlama Standardı (TFRS) 9 ile Vergi Usul Kanunu (VUK) değerlemesi arasındaki farkların tasdikte nasıl izlendiğini

## 1. TFRS 9 sınıflandırma ve ölçüm

**Finansal varlık sınıflandırması**, varlığın ilk kayıttan sonra hangi esasla ölçüleceğinin belirlenmesidir. TFRS 9.4.1.1'e göre sınıflandırma iki hususa dayanır: işletmenin finansal varlıkları yönetmek için kullandığı **iş modeli** ve varlığın **sözleşmeye bağlı nakit akışlarının özellikleri**. İkinci test uygulamada "yalnızca anapara ve faiz ödemesi" testi olarak bilinir.

### Üç ölçüm kategorisi

| Kategori | Şartlar | Değer değişimi |
|---|---|---|
| İtfa edilmiş maliyet (TFRS 9.4.1.2) | Nakit akışlarını tahsil amaçlı iş modeli + yalnızca anapara ve faiz | Değer değişimi yok; faiz etkin faiz yöntemiyle kâr veya zarara |
| Gerçeğe uygun değer değişimi diğer kapsamlı gelire yansıtılan (TFRS 9.4.1.2A) | Tahsil ve satış amaçlı iş modeli + yalnızca anapara ve faiz | Diğer kapsamlı gelir (DKG); faiz ve değer düşüklüğü kâr veya zarara |
| Gerçeğe uygun değer değişimi kâr veya zarara yansıtılan (TFRS 9.4.1.4) | İlk iki kategoriye girmeyen her varlık | Kâr veya zarar |

**Anapara**, varlığın ilk kayıttaki gerçeğe uygun değeridir; **faiz** ise paranın zaman değeri, kredi riski, diğer temel borç verme risk ve maliyetleri ile kâr marjından oluşur (TFRS 9.4.1.3).

### İlk ölçüm

İşletme finansal varlık veya yükümlülüğü ilk kayıtta gerçeğe uygun değerinden ölçer. Gerçeğe uygun değer değişimi kâr veya zarara yansıtılanlar dışındaki kalemlerde doğrudan ilişkilendirilebilen işlem maliyetleri gerçeğe uygun değere eklenir veya ondan düşülür (TFRS 9.5.1.1). Önemli finansman bileşeni olmayan ticari alacaklar ise TFRS 15'e göre belirlenen tutardan ölçülür (TFRS 9.5.1.3).

### İstisnalar ve tercihler

- Ticari amaçla elde tutulmayan özkaynak aracı yatırımları için, ilk kayıtta geri dönülemez biçimde, gerçeğe uygun değer değişimlerinin DKG'de sunulması seçilebilir; temettüler yine kâr veya zarara alınır (TFRS 9.5.7.5–5.7.6).
- Muhasebe uyumsuzluğunu ortadan kaldırıyor veya önemli ölçüde azaltıyorsa, bir varlık ilk kayıtta geri dönülemez biçimde gerçeğe uygun değer değişimi kâr veya zarara yansıtılan olarak tanımlanabilir (TFRS 9.4.1.5).
- Finansal yükümlülükler, sayılan istisnalar dışında itfa edilmiş maliyetinden ölçülür (TFRS 9.4.2.1).
- Finansal varlıklar yalnız iş modeli değiştiğinde yeniden sınıflandırılır; finansal yükümlülükler hiç yeniden sınıflandırılmaz (TFRS 9.4.4.1–4.4.2).

Ağustos 2025'te yayımlanan sınıflandırma ve ölçüme ilişkin değişiklikler 1 Ocak 2026 veya sonrasında başlayan yıllık hesap dönemlerinde uygulanır (TFRS 9.7.1.12).

> **Sık yapılan hata:** Borçlanma aracını "satılmaya hazır" diye sınıflandırmak. TFRS 9'da böyle bir kategori yoktur; tahsil ve satış amaçlı iş modelindeki borçlanma aracı TFRS 9.4.1.2A kategorisine girer.

## 2. Etkin faiz yöntemi

**Etkin faiz yöntemi**, itfa edilmiş maliyetin hesaplanmasında ve faiz gelir veya giderinin ilgili dönemlere dağıtılmasında kullanılan yöntemdir. **Etkin faiz oranı**, beklenen ömür boyunca tahmin edilen gelecekteki nakit akışlarını finansal varlığın brüt defter değerine veya finansal yükümlülüğün itfa edilmiş maliyetine indirgeyen orandır; hesaplamada beklenen kredi zararları dikkate alınmaz, ama ücretler, işlem maliyetleri, prim ve iskontolar dâhil edilir (TFRS 9 Ek A).

Kural olarak faiz geliri, **brüt defter değerine** (zarar karşılığı düşülmeden önceki itfa edilmiş maliyet) etkin faiz oranı uygulanarak hesaplanır. İki istisna vardır (TFRS 9.5.4.1):

- Satın alındığında veya oluşturulduğunda kredi-değer düşüklüğü bulunan varlıklarda, itfa edilmiş maliyete **krediye göre düzeltilmiş etkin faiz oranı** uygulanır.
- Sonradan kredi-değer düşüklüğüne uğrayan varlıklarda, sonraki dönemlerde itfa edilmiş maliyete etkin faiz oranı uygulanır.

Formül düz metinle: Fiyat = Σ Kupon / (1 + r)^t + Nominal / (1 + r)^n. Buradaki r etkin faiz oranıdır ve deneme yanılma ile bulunur.

### Örnek: İtfa edilmiş maliyetle ölçülen tahvil

A AŞ 01.01.2026'da 3 yıl vadeli, nominal değeri 100.000 TL, yıllık kupon faizi %10 (her yıl sonunda 10.000 TL) olan bir tahvili, işlem maliyetleri dâhil 95.000 TL ödeyerek alıyor. İş modeli nakit akışlarını tahsil etmektir. Tutarlar varsayımsaldır.

1. Sınıflandırma: tahsil amaçlı iş modeli ve yalnızca anapara ve faiz ödemesi olduğundan varlık itfa edilmiş maliyetle ölçülür.
2. Etkin faiz oranı: 95.000 = 10.000 / (1 + r) + 10.000 / (1 + r)^2 + 110.000 / (1 + r)^3 denklemini sağlayan oran yaklaşık %12,085'tir.
3. İtfa tablosu (yuvarlatılmamış oranla hesaplanmıştır):

| Yıl | Dönem başı | Etkin faiz geliri | Tahsil edilen kupon | İtfa (iskonto) | Dönem sonu |
|---|---|---|---|---|---|
| 2026 | 95.000,00 | 11.480,54 | 10.000 | 1.480,54 | 96.480,54 |
| 2027 | 96.480,54 | 11.659,46 | 10.000 | 1.659,46 | 98.140,00 |
| 2028 | 98.140,00 | 11.860,00 | 10.000 | 1.860,00 | 100.000,00 |

4. Toplam iskonto itfası 1.480,54 + 1.659,46 + 1.860,00 = 5.000 TL'dir; bu tutar nominal değer ile alış bedeli arasındaki farka eşittir.
5. 01.01.2026 kaydı: 240 Bağlı Menkul Kıymetler (borç) 95.000; 102 Bankalar (alacak) 95.000.
6. 31.12.2026 kaydı: 102 Bankalar (borç) 10.000 ve 240 Bağlı Menkul Kıymetler (borç) 1.480,54; 642 Faiz Gelirleri (alacak) 11.480,54. Borç toplamı 11.480,54 = alacak toplamı.

> **Sınav ipucu:** Kupon oranı etkin faiz oranının altındaysa varlık iskontolu alınmıştır ve defter değeri her yıl artarak vadede nominal değere ulaşır; primli alımda tersi olur.

## 3. Beklenen kredi zararı

**Kredi zararı**, sözleşmeye göre alınacak nakit akışları ile tahsil edilmesi beklenen nakit akışları arasındaki farkın başlangıçtaki etkin faiz oranıyla hesaplanan bugünkü değeridir. **Beklenen kredi zararları** ise kredi zararlarının temerrüt risklerine göre ağırlıklandırılmış ortalamasıdır (TFRS 9 Ek A).

### Genel yaklaşım

İtfa edilmiş maliyetle ve gerçeğe uygun değer değişimi DKG'ye yansıtılarak ölçülen varlıklar, kira alacakları, sözleşme varlıkları, kredi taahhütleri ve finansal teminat sözleşmeleri için zarar karşılığı ayrılır (TFRS 9.5.5.1).

- Kredi riskinde ilk kayıttan bu yana önemli artış yoksa: **12 aylık beklenen kredi zararı** (TFRS 9.5.5.5).
- Önemli artış varsa: **ömür boyu beklenen kredi zararı** (TFRS 9.5.5.3).
- Sözleşmeye bağlı ödemeler vadeyi 30 günden fazla aşmışsa kredi riskinin önemli ölçüde arttığına dair aksi ispat edilebilir bir ön kabul vardır (TFRS 9.5.5.11).
- Karşılıktaki değişim değer düşüklüğü kazancı veya kaybı olarak kâr veya zarara alınır (TFRS 9.5.5.8).

Ölçüm; olasılıklarla ağırlıklandırılmış tarafsız bir tutarı, paranın zaman değerini ve aşırı maliyete katlanmadan elde edilebilen makul ve desteklenebilir bilgiyi yansıtır (TFRS 9.5.5.17).

Örnekteki tahvilde 31.12.2026'da kredi riskinde önemli artış olmadığını, 12 ay içinde temerrüt olasılığının %2 ve temerrüt hâlinde bugünkü değerle nakit açığının 40.000 TL olduğunu varsay. Beklenen kredi zararı 0,02 x 40.000 = 800 TL'dir. Kayıt: 654 Karşılık Giderleri (borç) 800; 241 Bağlı Menkul Kıymetler Değer Düşüklüğü Karşılığı (alacak) 800. Faiz geliri yine brüt defter değeri üzerinden hesaplanmaya devam eder.

### İstisnalar

- Ticari alacaklar ve sözleşme varlıkları (önemli finansman bileşeni içermeyenler) için zarar karşılığı her zaman ömür boyu beklenen kredi zararına eşit ölçülür; buna **basitleştirilmiş yaklaşım** denir (TFRS 9.5.5.15).
- Gerçeğe uygun değer değişimi DKG'ye yansıtılan varlıklarda zarar karşılığı DKG'ye yansıtılır ve varlığın defter değerini azaltmaz (TFRS 9.5.5.2).

## 4. Riskten korunma muhasebesi temel ilkeleri

**Korunma muhasebesi**, belirli riskleri yönetmek için finansal araçlarla yürütülen risk yönetimi faaliyetlerinin etkisini finansal tablolarda göstermeyi amaçlar (TFRS 9.6.1.1). Uygulama isteğe bağlıdır; işletme korunma aracı ile korunan kalem arasında ilişki tanımlamayı seçebilir (TFRS 9.6.1.2).

### Kıstaslar (TFRS 9.6.4.1)

1. İlişki yalnız uygun korunma araçlarını ve uygun korunan kalemleri içerir.
2. Başlangıçta risk yönetimi amacı ve stratejisi resmi olarak tanımlanır ve belgelendirilir.
3. Etkinlik hükümleri karşılanır: ekonomik ilişki vardır, kredi riski etkisi baskın değildir ve korunma oranı fiilen kullanılan miktarlara göre belirlenir.

### Üç korunma türü (TFRS 9.6.5.2)

| Tür | Muhasebeleştirme |
|---|---|
| Gerçeğe uygun değer değişiminden korunma | Korunma aracındaki ve korunan kalemdeki kazanç veya kayıp kâr veya zarara; korunan kalemin defter değeri düzeltilir (TFRS 9.6.5.8) |
| Nakit akış değişkenliğinden korunma | Etkin kısım DKG'ye ve nakit akış değişkenliğinden korunma fonuna, etkin olmayan kısım kâr veya zarara (TFRS 9.6.5.11) |
| Yurtdışı işletmedeki net yatırım riskinden korunma | Türkiye Muhasebe Standardı (TMS) 21'de tanımlanan net yatırımın korunması |

İstisna niteliğindeki kural: işletme korunma muhasebesine yalnız ilişki, yeniden dengeleme dikkate alındıktan sonra kıstasları artık karşılamadığında, ileriye yönelik olarak son verir; korunma aracının süresinin dolması, satılması, feshedilmesi veya kullanılması da bu kapsamdadır (TFRS 9.6.5.6).

> **Sınav ipucu:** Nakit akış korunmasında fon, korunma aracındaki toplam kazanç veya kayıp ile korunan kalemin gerçeğe uygun değerindeki toplam değişimden mutlak değerce düşük olanına göre düzeltilir; aşan kısım etkinsizliktir.

### Tasdik uygulama notu

Tam tasdikte TFRS 9 ile hazırlanmış tablolar ile VUK kayıtları arasındaki farklar ayrıca izlenir. VUK md.279'a göre hisse senetleri ile fon portföyünün en az %51'i Türkiye'de kurulmuş şirketlerin hisse senetlerinden oluşan yatırım fonu katılma belgeleri alış bedeliyle, bunlar dışındaki menkul kıymetler borsa rayici ile değerlenir; borsa rayici yoksa alış bedeline vadede elde edilecek gelirin (kur farkları dâhil) iktisaptan değerleme gününe kadar geçen süreye isabet eden kısmı eklenir; bu, etkin faiz tablosundan farklı sonuç verebilir. Beklenen kredi zararı karşılığı ise VUK md.323'teki şüpheli alacak şartlarına dayanmaz; tasdikte bu karşılığın vergi matrahına etkisi ayrıca kontrol edilir. Korunma muhasebesinde belgelendirmenin ilişkinin başlangıcında yapılıp yapılmadığı incelenir.

## Özet

- Sınıflandırma iş modeli ve sözleşmeye bağlı nakit akışı testine dayanır (TFRS 9.4.1.1); üç kategori vardır.
- İlk ölçüm gerçeğe uygun değerdir; kâr veya zarara yansıtılmayanlarda işlem maliyeti dâhil edilir (TFRS 9.5.1.1).
- Faiz geliri, kural olarak brüt defter değerine etkin faiz oranı uygulanarak bulunur (TFRS 9.5.4.1).
- Kredi riskinde önemli artış yoksa 12 aylık, varsa ömür boyu beklenen kredi zararı ayrılır; 30 günü aşan gecikme önemli artış ön kabulü doğurur.
- Ticari alacak ve sözleşme varlıklarında basitleştirilmiş yaklaşımla ömür boyu ölçüm yapılır (TFRS 9.5.5.15).
- Korunma muhasebesi TFRS 9.6.4.1 kıstaslarına bağlıdır; üç korunma türü vardır.
- Tasdikte TFRS 9 tutarları VUK md.279 ve md.323 hükümleriyle karşılaştırılır.
