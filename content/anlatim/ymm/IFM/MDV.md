---
ders: IFM
konu: MDV
baslik: "Maddi ve maddi olmayan duran varlıklar ve yatırım amaçlı gayrimenkuller"
durum: "taslak"
yazar: Claude
kaynaklar:
  - mevzuat: "TMS 16 Maddi Duran Varlıklar"
    madde: "par. 35"
    alinti: "Birikmiş amortisman varlığın brüt defter değeri ile netleştirilir."
  - mevzuat: "TMS 16 Maddi Duran Varlıklar"
    madde: "par. 39"
    alinti: "Eğer bir varlığın defter değeri yeniden değerleme sonucunda artmışsa, bu artış diğer kapsamlı gelirde muhasebeleştirilmelidir"
  - mevzuat: "TMS 38 Maddi Olmayan Duran Varlıklar"
    madde: "par. 54"
    alinti: "harcamaları gerçekleştiğinde gider olarak muhasebeleştirilir."
  - mevzuat: "TMS 36 Varlıklarda Değer Düşüklüğü"
    madde: "par. 18"
    alinti: "satış maliyetleri düşülmüş gerçeğe uygun değer ile kullanım değerinden yüksek olanı olarak tanımlar"
  - mevzuat: "TMS 40 Yatırım Amaçlı Gayrimenkuller"
    madde: "par. 35"
    alinti: "Yatırım amaçlı gayrimenkulün gerçeğe uygun değer değişiminden kaynaklanan kazanç veya kayıp, oluştuğu dönemde kâr veya zarar olarak finansal tablolara yansıtılır."
  - mevzuat: "TMS 23 Borçlanma Maliyetleri"
    madde: "par. 8"
    alinti: "borçlanma maliyetleri, ilgili özellikli varlığın maliyetinin bir parçası olarak aktifleştirilir."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 326"
    alinti: "Kurumların aktifleştirdikleri ilk tesis ve taazzuv giderleri ile peştemallıklar mukayyet değerleri üzerinden eşit miktarlarda ve beş yıl içinde itfa olunur."
  - mevzuat: "5520 sayılı Kurumlar Vergisi Kanunu"
    madde: "md. 8/1-b"
    alinti: "Kuruluş ve örgütlenme giderleri."
---
## Bu konuda neler öğreneceksin

- TMS 16'ya göre maddi duran varlığın (MDV) maliyetini, amortismanını ve VUK'tan farkını
- Yeniden değerleme modelinde brüt ve net yöntemi, değer artışının ve vergisinin özkaynakta izlenmesini
- TMS 38'e göre maddi olmayan duran varlık (MODV) koşullarını, araştırma-geliştirme ayrımını ve kuruluş giderlerinin giderleştirilmesini
- TMS 36 değer düşüklüğü testini ve TMS 40 yatırım amaçlı gayrimenkulün (YAG) gerçeğe uygun değerle ölçümünü
- TMS 23'e göre borçlanma maliyetlerinin aktifleştirilmesini

YMM sınavında bu konu "VUK'a göre yapılmış kaydı TFRS'ye uyarlayın ve ertelenmiş vergi (EV) etkisini kaydedin" kalıbıyla gelir. Örneklerde 2026 kurumlar vergisi oranı %25'tir (KVK md. 32/1).

## 1. TMS 16 maddi duran varlıklar ve amortisman

**Maddi duran varlık**, üretimde, kiraya vermede veya idari amaçla kullanılan ve bir dönemden uzun kullanılması beklenen fiziki varlıktır. Maliyeti; ekonomik fayda girişi muhtemel ve maliyet güvenilir ölçülebiliyorsa varlık olarak alınır (TMS 16.7). **Maliyet** satın alma fiyatını (iade edilmeyen vergiler dahil, iskontolar hariç), varlığı çalışır hale getirme maliyetlerini ve söküm-restorasyon yükümlülüğünün tahmini tutarını içerir (TMS 16.16).

**Amortisman** kuralları:

- Önemli maliyetli her parça ayrı amortismana tabi tutulur (TMS 16.43).
- Amortisman varlık kullanılabilir olduğunda başlar (TMS 16.55); bu yüzden TFRS'de **kıst (ay esaslı)** amortisman olağandır.
- Amortismana tabi tutar = maliyet − **kalıntı değer**. Kalıntı değer ve yararlı ömür en az her dönem sonunda gözden geçirilir; değişiklik tahmin değişikliğidir (TMS 16.51).

VUK'ta ise amortisman Hazine ve Maliye Bakanlığının ilan ettiği ömürle, kalıntı değer düşülmeden ayrılır. Süre aktife girilen yıldan başlar; binek otomobilleri dışında tam yıl ayrılır, ancak mükellef gün esasını seçebilir (VUK md. 320).

**Çözümlü örnek 1:** (A) AŞ 1 Nisan 2026'da 600.000 TL'ye demirbaş aldı. VUK'ta 5 yıl ömürle (%20) tam yıl amortisman ayrıldı: 120.000 TL. TFRS'ye göre ömür 8 yıl, kalıntı değer 120.000 TL.

- TFRS amortismanı = (600.000 − 120.000) / 8 × 9/12 = 45.000 TL
- Fazla ayrılan = 120.000 − 45.000 = 75.000 TL
- Düzeltme: 257 Birikmiş Amortismanlar borç 75.000 / 770 Genel Yönetim Giderleri alacak 75.000 (demirbaş üretimde kullanılıyorsa alacak 730 veya maliyet hesaplarına dağıtılır)
- TFRS defter değeri 555.000 TL, vergiye esas değer 480.000 TL; vergiye tabi geçici fark 75.000 TL × %25 = 18.750 TL: 695 Ertelenmiş Vergi Gideri borç / 489 Ertelenmiş Vergi Yükümlülüğü alacak 18.750

## 2. Yeniden değerleme modeli

İşletme her MDV sınıfı için **maliyet modeli** ya da **yeniden değerleme modeli** seçer (TMS 16.29-31). Yeniden değerleme modelinde varlık, GUD'den sonraki birikmiş amortisman ve değer düşüklüğü düşülerek izlenir; değerlemeler düzenli yapılır ve sınıfın tamamı değerlenir (TMS 16.36).

- **Artış** diğer kapsamlı gelirde (DKG) muhasebeleştirilir ve özkaynakta "yeniden değerleme değer artışı" olarak birikir; aynı varlığın daha önce kâr veya zarara yazılan azalışını tersine çeviren kısmı gelirdir (TMS 16.39).
- **Azalış** gider yazılır; ancak önce aynı varlığın özkaynaktaki artış bakiyesinden düşülür (TMS 16.40).
- Özkaynaktaki artış, varlık elden çıkınca veya kullanıldıkça (yeni amortisman ile eski amortisman farkı kadar) doğrudan geçmiş yıllar kârına aktarılabilir; kâr veya zarardan geçmez (TMS 16.41).

**Çözümlü örnek 2:** Binanın maliyeti 2.000.000, birikmiş amortismanı 400.000, defter değeri 1.600.000 TL; 2026 sonu GUD 2.400.000 TL. Artış 800.000 TL'dir. VUK'ta değerleme yapılmadığı varsayılmıştır.

| Yöntem (TMS 16.35) | Kayıt |
|---|---|
| Net yöntem | 257 borç 400.000 / 252 Binalar alacak 400.000; sonra 252 borç 800.000 / 522 M.D.V. Yeniden Değerleme Artışları alacak 800.000 |
| Brüt yöntem (oran 2.400/1.600 = 1,5) | 252 borç 1.000.000 / 257 alacak 200.000, 522 alacak 800.000 (brüt 3.000.000, BA 600.000) |

EV: 800.000 × %25 = 200.000 TL vergiye tabi fark; kalem DKG'de olduğundan vergisi de DKG'dedir (TMS 12.61A): 522 borç 200.000 / 489 alacak 200.000. Net değer artışı 600.000 TL'dir.

> **Sık yapılan hata:** Yeniden değerleme artışını 649 gibi bir gelir hesabına almak. Artış kâr veya zarara girmez; yalnız aynı varlığın önceki gider yazılmış azalışını ters çeviren kısmı gelirdir.

## 3. TMS 38 maddi olmayan duran varlıklar ve kuruluş giderleri

**MODV**, fiziki niteliği olmayan, **tanımlanabilir** parasal olmayan varlıktır (haklar, yazılım, lisans, marka). Kontrol ve gelecekteki ekonomik fayda şartları aranır.

- **Araştırma** safhası harcamaları her zaman giderdir (TMS 38.54).
- **Geliştirme** harcamaları ancak altı koşulun tamamı ispatlanırsa aktifleştirilir (TMS 38.57): teknik olarak tamamlanabilirlik, tamamlama ve kullanma/satma niyeti, kullanma/satma imkânı, gelecekte fayda sağlayacağının gösterilmesi, yeterli teknik ve finansal kaynak, harcamanın güvenilir ölçümü.
- **Kuruluş (başlangıç) giderleri**, eğitim, reklam ve yeniden yapılanma harcamaları varlık doğurmaz; oluştuklarında giderdir (TMS 38.69).
- Sınırlı ömürlü MODV ömrü boyunca itfa edilir (TMS 38.97); sınırsız ömürlü MODV itfa edilmez (TMS 38.107), yıllık değer düşüklüğü testine tabidir. Yeniden değerleme modeli yalnız aktif piyasası olan MODV için uygulanabilir (TMS 38.75).

VUK'ta kuruluş ve örgütlenme giderleri ya doğrudan gider yazılır (KVK md. 8/1-b) ya da 262 Kuruluş ve Örgütlenme Giderleri hesabında aktifleştirilip beş yılda eşit itfa edilir (VUK md. 326).

**Çözümlü örnek 3:** 2026'da yapılan 150.000 TL kuruluş gideri 262'de aktifleştirilmiş ve 30.000 TL itfa edilmiştir.

- Düzeltme: 770 Genel Yönetim Giderleri borç 120.000, 268 Birikmiş Amortismanlar borç 30.000 / 262 alacak 150.000
- TFRS defter değeri 0, vergiye esas değer 120.000 TL; indirilebilir fark 120.000 × %25 = 30.000 TL: 289 Ertelenmiş Vergi Varlığı borç / 696 Ertelenmiş Vergi Geliri alacak 30.000

## 4. TMS 36 varlıklarda değer düşüklüğü

İşletme her raporlama dönemi sonunda değer düşüklüğü **belirtisi** olup olmadığını değerlendirir (TMS 36.9). Sınırsız ömürlü MODV, henüz kullanılmayan MODV ve şerefiye belirti aranmadan yıllık test edilir (TMS 36.10).

**Geri kazanılabilir tutar**, satış maliyetleri düşülmüş GUD ile kullanım değerinden **yüksek olanıdır** (TMS 36.18). Defter değeri bundan yüksekse aradaki fark değer düşüklüğü zararıdır (TMS 36.59). Zarar kâr veya zarara yazılır; yeniden değerlenmiş varlıkta önce özkaynaktaki artıştan düşülür (TMS 36.60-61). Şerefiye dışındaki varlıklarda zarar iptal edilebilir; ama iptal, zarar hiç kaydedilmeseydi ulaşılacak amortismanlı defter değerini aşamaz (TMS 36.117). Şerefiyede iptal yoktur (TMS 36.124).

**Örnek:** Makinenin defter değeri 800.000 TL; satış maliyetleri düşülmüş GUD 620.000, kullanım değeri 680.000 TL. Geri kazanılabilir tutar 680.000 TL, zarar 120.000 TL: 654 Karşılık Giderleri borç / 257 Birikmiş Amortismanlar (değer düşüklüğü alt hesabı) alacak 120.000. VUK'ta bu zarar indirilemediğinden 289 borç / 696 alacak 30.000.

> **Sınav ipucu:** "Geri kazanılabilir tutar küçük olandır" şıkkı klasik tuzaktır; doğru cevap yüksek olanıdır. Stokta ise karşılaştırma maliyet ile net gerçekleşebilir değerin düşüğüdür (TMS 2); iki ölçütü karıştırma.

## 5. TMS 40 yatırım amaçlı gayrimenkuller

**YAG**, kira geliri veya sermaye kazancı ya da ikisi için elde tutulan arsa ve binadır; üretimde, idari amaçla kullanılan veya olağan faaliyette satılacak gayrimenkul YAG değildir (TMS 40.5). İşletme **GUD yöntemi** ile **maliyet yöntemi** arasında seçim yapar (TMS 40.30). GUD yönteminde amortisman ayrılmaz ve GUD değişimi oluştuğu dönemin kâr veya zararına yansır (TMS 40.35). Sınıf değişikliği yalnız kullanım değişikliği kanıtlanınca yapılır (TMS 40.57); kullanılan bina GUD'li YAG'a dönüşürse o tarihe kadar TMS 16 uygulanır ve aradaki fark yeniden değerleme gibi işlenir (TMS 40.61-62).

**Çözümlü örnek 4:** 2024'te 1.000.000 TL'ye alınan ve değer artışı için tutulan arsa VUK'ta 250 Arazi ve Arsalar hesabındadır. GUD 2025 sonu 1.300.000, 2026 sonu 1.600.000 TL'dir. İşletme GUD yöntemini seçmiştir; THP'de YAG hesabı olmadığından 25 grubunda ilave hesap açılır.

- 25X Yatırım Amaçlı Gayrimenkuller borç 1.600.000 / 250 alacak 1.000.000, 570 Geçmiş Yıllar Kârları alacak 300.000, 649 Diğer Olağan Gelir ve Kârlar alacak 300.000
- EV (600.000 × %25 = 150.000 TL vergiye tabi fark): 570 borç 75.000 ve 695 borç 75.000 / 489 alacak 150.000

## 6. TMS 23 borçlanma maliyetleri

**Özellikli varlık**, kullanıma veya satışa hazır hale gelmesi zorunlu olarak uzun süre gerektiren varlıktır (TMS 23.5). Özellikli varlıkla doğrudan ilişkili borçlanma maliyeti aktifleştirilir, diğerleri giderdir (TMS 23.8). Özel borçlanmada, fonların geçici nemalandırılmasından elde edilen gelir düşülür (TMS 23.12); genel borçlanmada harcamaya ağırlıklı ortalama **aktifleştirme oranı** uygulanır (TMS 23.14). Aktifleştirme harcama, borçlanma maliyeti ve hazırlık faaliyetleri başlayınca başlar (TMS 23.17), faaliyetler uzun süre durursa askıya alınır (TMS 23.20), varlık hazır olunca sona erer (TMS 23.22).

**Örnek:** Fabrika inşaatı için 2026 başında 4.000.000 TL özel kredi alındı; yıllık faiz %45 (1.800.000 TL). Kullanılmayan kısım mevduatta 150.000 TL faiz getirdi. Aktifleştirilecek tutar 1.800.000 − 150.000 = 1.650.000 TL'dir. Faiz 780 Finansman Giderlerine, mevduat faizi 642 Faiz Gelirlerine yazılmışsa düzeltme: 258 Yapılmakta Olan Yatırımlar borç 1.800.000 / 780 alacak 1.800.000; 642 borç 150.000 / 258 alacak 150.000.

## 7. Tasdik uygulama notu

Tam tasdikte 25 ve 26 grubu hareketlerini faturalarla, amortisman oranlarını ilan edilen ömürlerle ve 262'deki itfanın beş yıla bölündüğünü kontrol et. TFRS raporu da inceleniyorsa her MDV ve MODV için TFRS defter değeri ile VUK değerini yan yana listeleyen tablo iste; amortisman farkları, değer düşüklükleri ve YAG değerlemelerinin tamamı geçici fark doğurur.

## Özet

- TFRS'de amortisman kullanılabilir olunca başlar, kalıntı değer düşülür; VUK ile ömür ve kıst farkı vergiye tabi veya indirilebilir geçici fark yaratır.
- Yeniden değerleme artışı DKG'de (522) ve vergisiyle birlikte izlenir; brüt veya net yöntem seçilir.
- Araştırma gideri, kuruluş gideri ve reklam her zaman giderdir; geliştirme altı koşulla aktifleştirilir.
- Geri kazanılabilir tutar, satış maliyetleri düşülmüş GUD ile kullanım değerinin yüksek olanıdır; şerefiyede değer düşüklüğü iptal edilmez.
- GUD yöntemindeki YAG amortismana tabi değildir; GUD değişimi kâr veya zarardadır.
- Özellikli varlığın borçlanma maliyeti, geçici yatırım geliri düşülerek aktifleştirilir.
