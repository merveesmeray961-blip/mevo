---
ders: "FIN"
konu: "HAZ"
baslik: "Hazır değerler"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "100. Kasa"
    alinti: "Hesap daima borç bakiyesi verir veya sıfır olur. Hiçbir şekilde alacak bakiyesi vermez."
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "103. Verilen Çekler ve Ödeme Emirleri (-)"
    alinti: "çek ve ödeme emirlerinin bankadan tahsil edildiği anlaşıldığında bu hesaba borç, bankalar hesabına alacak kaydedilir"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "391. Hesaplanan KDV"
    alinti: "vadesinde ödenmek üzere \"360-ÖDENECEK VERGİ VE FONLAR\" hesabına aktarılarak kapatılır"
  - mevzuat: "3065 sayılı Katma Değer Vergisi Kanunu"
    madde: "md. 29/2"
    alinti: "aradaki fark sonraki dönemlere devrolunur ve iade edilmez"
  - mevzuat: "3065 sayılı Katma Değer Vergisi Kanunu"
    madde: "md. 29/3"
    alinti: "İndirim hakkı vergiyi doğuran olayın vuku bulduğu takvim yılını takip eden takvim yılı aşılmamak şartıyla"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 1 (Muhasebenin Temel Kavramları)"
    madde: "Dönemsellik Kavramı"
    alinti: "Gelir ve giderlerin tahakkuk esasına göre muhasebeleştirilmesi, hasılat, gelir ve kârların aynı döneme ait maliyet, gider ve zararlarla karşılaştırılması"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 1 (Muhasebenin Temel Kavramları)"
    madde: "İhtiyatlılık Kavramı"
    alinti: "Ancak bu kavram gizli yedekler veya gereğinden fazla karşılıklar ayrılmasına gerekçe oluşturamaz."
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "690. Dönem Kârı veya Zararı"
    alinti: "Gelir hesapları bu hesabın alacağına, gider hesapları borcuna kaydedilir. Hesabın kalanı vergiden önceki dönem kârı veya zararını gösterir."
---
## Bu konuda neler öğreneceksin

- 10 Hazır Değerler grubunun hesaplarını ve kasa, banka, çek kayıtlarını
- Mevduat faizinde stopaj ve kasa sayım farklarının kaydını
- KDV mahsubunu: 191 İndirilecek KDV, 391 Hesaplanan KDV, 190 Devreden KDV ve 360 ilişkisi (KDVK md. 29)
- Muhasebenin 12 temel kavramını ve sınavda nasıl sorulduklarını
- Düzenleyici hesapların mantığını ve mizanın neyi kontrol edip neyi edemediğini
- Gelir tablosu hesaplarının 690 → 691 → 692 → 590 zinciriyle kapanışını

## 1. Hazır değerler grubu (10)

THP'ye göre bu grup, nakit olarak elde veya bankada bulunan varlıklar ile istenildiği zaman değer kaybına uğramadan paraya çevrilebilen varlıkları (menkul kıymetler hariç) kapsar.

| Hesap | Ne izlenir? |
|---|---|
| 100 Kasa | Elde bulunan TL ve yabancı paraların TL karşılığı |
| 101 Alınan Çekler | Henüz tahsile verilmemiş veya ciro edilmemiş çekler |
| 102 Bankalar | Vadesiz ve vadeli mevduat hareketleri |
| 103 Verilen Çekler ve Ödeme Emirleri (-) | İşletmenin keşide ettiği, bankadan henüz ödenmemiş çek ve ödeme emirleri |
| 108 Diğer Hazır Değerler | Pullar, vadesi gelmiş kuponlar, yoldaki paralar |

Hazır değerler aktif (varlık) hesaplarıdır: **artış borç, azalış alacak** yönünde kaydedilir.

## 2. Kasa ve banka işlemleri

### Kasa

- Tahsilat: 100 (B) / ilgili hesap (A). Ödeme: ilgili hesap (B) / 100 (A).
- Kasa hiçbir şekilde **alacak bakiyesi vermez**; vermişse ya kayıt hatası ya da kayda geçmemiş tahsilat vardır.
- Yabancı paralar kasaya TL karşılığıyla girer; VUK md. 284'e göre kasa mevcutları itibari kıymetle, yabancı paralar md. 280'e göre değerlenir. Döviz kasasındaki kur artışı 100 (B) / 646 Kambiyo Kârları (A), azalışı 656 Kambiyo Zararları (B) / 100 (A) kaydedilir.

**Kasa sayım farkları:** Sayımda eksik çıkan tutar önce **197 Sayım ve Tesellüm Noksanları**'na borç, kasaya alacak yazılır. Sorumlusu belli olursa 135 Personelden Alacaklar'a, olmazsa 689 Diğer Olağandışı Gider ve Zararlar'a aktarılır. Fazla çıkan tutar 100 (B) / **397 Sayım ve Tesellüm Fazlaları** (A) ile kaydedilir ve nedeni araştırılır.

### Bankalar

- Bankaya para yatırma: 102 (B) / 100 (A). Bankadan çekme: 100 (B) / 102 (A).
- Havale ile tahsilat: 102 (B) / 120 (A). EFT ile ödeme: 320 (B) / 102 (A); masraf 653 Komisyon Giderleri'ne.

**Mevduat faizi ve stopaj:** Banka, mevduat faizinden stopaj keser ve kalan net tutarı hesaba yatırır. Kesilen vergi işletmenin kurumlar (gelir) vergisinden mahsup edilebileceği için 193 Peşin Ödenen Vergiler ve Fonlar'a yazılır. Örnek: brüt faiz 40.000 TL, soruda verilen stopaj oranı %15 ise:

- 102 Bankalar (B) 34.000
- 193 Peşin Ödenen Vergiler ve Fonlar (B) 6.000
- 642 Faiz Gelirleri (A) 40.000

> **Sık yapılan hata:** Gelir hesabına net tutarı (34.000) yazmak. Gelir **brüt** faizdir; stopaj gelirden indirilmez, vergi alacağı olarak 193'te izlenir.

### Çekler

| İşlem | Kayıt |
|---|---|
| Müşteriden çek alındı | 101 (B) / 120 (A) |
| Çek bankaya tahsil edildi | 102 (B) / 101 (A) |
| Alınan çek satıcıya ciro edildi | 320 (B) / 101 (A) |
| Satıcıya işletme çeki verildi | 320 (B) / 103 (A) |
| Verilen çek bankadan ödendi | 103 (B) / 102 (A) |

103, 102'yi düzenler: banka bakiyesi 500.000 TL, ödenmemiş verilen çekler 80.000 TL ise bilançoda kullanılabilir banka değeri 420.000 TL olarak sunulur.

> **Sınav ipucu:** Alınan çeki satıcıya ciro etmek 101'i alacaklandırır, 103'ü değil. 103 yalnızca işletmenin **kendi** bankası üzerine keşide ettiği çekler içindir.

## 3. KDV mahsubu (191 / 391 / 190 / 360)

KDVK md. 29'a göre mükellefler, vergiye tabi işlemleri üzerinden hesaplanan KDV'den, kendilerine yapılan teslim ve hizmetler dolayısıyla faturada gösterilen KDV'yi ve ithalde ödenen KDV'yi indirebilir.

- Alışta: **191 İndirilecek KDV** (B). Satışta: **391 Hesaplanan KDV** (A).
- Dönem sonu (aylık) karşılaştırma: 391 bakiyesi 191 ve 190 toplamından fazlaysa fark **360 Ödenecek Vergi ve Fonlar**'a alacak yazılır.
- 191 daha büyükse fark sonraki dönemlere devreder ve iade edilmez (md. 29/2); bu tutar **190 Devreden KDV**'ye borç yazılır.
- İndirim hakkı, vergiyi doğuran olayın olduğu takvim yılını izleyen yıl aşılmamak şartıyla, belgenin kanuni defterlere kaydedildiği dönemde kullanılabilir (md. 29/3).

**Çözümlü örnek (KDV %20):**

Ocak: 900.000 TL + KDV mal alındı, 600.000 TL + KDV satış yapıldı.

- 191 bakiyesi 180.000; 391 bakiyesi 120.000 → 191 büyük, fark 60.000 TL devreder.
- Kayıt: 391 (B) 120.000, 190 (B) 60.000 / 191 (A) 180.000

Şubat: 400.000 TL + KDV alış, 1.000.000 TL + KDV satış.

- 191: 80.000; 391: 200.000; indirimler toplamı 80.000 + 60.000 (190) = 140.000.
- Ödenecek KDV: 200.000 − 140.000 = **60.000 TL**
- Kayıt: 391 (B) 200.000 / 191 (A) 80.000, 190 (A) 60.000, 360 (A) 60.000
- Ödeme: 360 (B) 60.000 / 102 (A) 60.000

> **Sık yapılan hata:** Önceki aydan devreden KDV'yi unutup 200.000 − 80.000 = 120.000 TL ödenecek bulmak. Devreden KDV (190) indirim toplamına eklenir.

## 4. Muhasebenin temel kavramları

MSUGT Ek 1'de 12 temel kavram sayılır:

1. **Sosyal sorumluluk:** Bilgi üretiminde belli kişilerin değil, tüm toplumun çıkarı gözetilir.
2. **Kişilik:** İşletme, sahiplerinden ayrı bir kişiliktir. Ortağın kişisel harcaması işletme gideri değil, 131 Ortaklardan Alacaklar'dır.
3. **İşletmenin sürekliliği:** İşletmenin ömrü sınırsız kabul edilir; maliyet esasının temelidir.
4. **Dönemsellik:** Ömür dönemlere bölünür; gelir ve giderler tahakkuk esasına göre ait oldukları döneme yazılır (180/280, 380/480, 181/381 hesaplarının dayanağı).
5. **Parayla ölçülme:** Olaylar ortak ölçü olarak ulusal para birimiyle kaydedilir.
6. **Maliyet esası:** Varlıklar elde etme maliyetiyle kaydedilir; para mevcudu ve alacaklar bunun dışındadır.
7. **Tarafsızlık ve belgelendirme:** Kayıtlar objektif belgelere dayanır.
8. **Tutarlılık:** Seçilen politikalar dönemler arasında değiştirilmez; geçerli nedenle değiştirilirse etkisi dipnotta açıklanır.
9. **Tam açıklama:** Tablolar karar alıcılar için yeterli, açık ve anlaşılır olur; gerçekleşmesi muhtemel olaylara da yer verilir.
10. **İhtiyatlılık:** Muhtemel gider ve zararlar için karşılık ayrılır, muhtemel gelirler gerçekleşmeden kaydedilmez; ancak gizli yedek ayrılmasına gerekçe olamaz.
11. **Önemlilik:** Kararları etkileyecek ağırlıktaki kalemler tablolarda yer almak zorundadır.
12. **Özün önceliği:** İşlemin biçiminden çok özü esas alınır.

> **Sınav ipucu:** Kavram soruları genellikle bir örnekten kavramı buldurur: "şüpheli alacak karşılığı" → ihtiyatlılık; "peşin ödenen kiranın 180'e alınması" → dönemsellik; "politika değişikliğinin dipnotta açıklanması" → tutarlılık; "ortağın özel harcamasının gider yazılmaması" → kişilik.

## 5. Düzenleyici hesaplar

**Düzenleyici hesap**, bir ana hesabın bakiyesini azaltarak onun bilançodaki gerçek değerini göstermek için kullanılan hesaptır. THP'de adının yanında **(-)** işareti bulunur ve ilişkili olduğu hesabın **ters** yönünde bakiye verir.

- Aktifi düzenleyenler (alacak bakiyeli): 103, 119, 122, 129, 137, 158, 257, 268.
- Pasifi düzenleyenler (borç bakiyeli): 302, 308, 322, 337, 371, 408, 501, 580.
- Gelir tablosunda: 610 Satıştan İadeler, 611 Satış İskontoları, 612 Diğer İndirimler brüt satışları azaltır.

Örneğin 253 Tesis, Makine ve Cihazlar 600.000 TL, 257 Birikmiş Amortismanlar 240.000 TL ise makinenin net defter değeri 360.000 TL'dir.

## 6. Mizan

**Mizan**, büyük defterdeki hesapların borç ve alacak toplamlarını ve bakiyelerini bir arada gösteren kontrol çizelgesidir. Çift taraflı kayıt nedeniyle denk mizanda:

- Borç toplamları = Alacak toplamları
- Borç bakiyeleri toplamı = Alacak bakiyeleri toplamı

Dönem sonu envanter (düzeltme) kayıtlarından önce düzenlenen mizan **geçici mizan**, bu kayıtlardan sonra ve kapanış kayıtlarından önce düzenlenen mizan **kesin mizan** olarak adlandırılır; bilanço ve gelir tablosu kesin mizandan hazırlanır.

Mizan denkliği her hatayı göstermez. Denklik bozulmadan kalan hatalar:

- Bir işlemin hiç kaydedilmemesi veya iki kez kaydedilmesi
- Doğru tutarın yanlış hesaba yazılması (ör. 120 yerine 121)
- Borç ve alacak taraflarının yer değiştirmesi (ters kayıt)
- Birbirini götüren (dengeleyen) hatalar

Tek taraflı kayıt, tutarın bir tarafa farklı yazılması veya bakiye hesaplama hatası ise denkliği bozar.

## 7. Gelir tablosu hesaplarının kapanışı (690/692)

7/A seçeneğinde 7 grubu maliyet hesapları (ör. 760, 770, 780) dönem içinde yansıtma hesapları (761, 771, 781) aracılığıyla 6 grubundaki ilgili hesaplara (631, 632, 660) aktarılır. Bu yüzden 690'a doğrudan 7 grubu hesap kapatılmaz; yalnız 6 grubu hesaplar kapatılır.

Kapanış sırası:

1. Gelir hesapları (60, 64, 67 grupları) borçlandırılarak **690 Dönem Kârı veya Zararı**'na alacak yazılır.
2. Gider ve indirim hesapları (61, 62, 63, 65, 66, 68 grupları) alacaklandırılarak 690'a borç yazılır. 690'ın kalanı **vergiden önceki** dönem kârıdır.
3. Vergi karşılığı: **691 Dönem Kârı Vergi ve Diğer Yasal Yükümlülük Karşılıkları** (B) / **370** (A).
4. 690 ile 691 karşılıklı kapatılarak fark **692 Dönem Net Kârı veya Zararı**'na alınır.
5. 692, **590 Dönem Net Kârı** (zarar ise 591) hesabına devredilir.
6. Yıl içinde ödenen geçici vergiler (193), 371 Dönem Kârının Peşin Ödenen Vergi ve Diğer Yükümlülükleri hesabına aktarılır: 371 (B) / 193 (A).

**Çözümlü örnek:** Dönem sonu bakiyeleri: 600 Yurtiçi Satışlar 1.500.000; 610 Satıştan İadeler 50.000; 621 Satılan Ticari Mallar Maliyeti 800.000; 632 Genel Yönetim Giderleri 150.000; 642 Faiz Gelirleri 30.000; 660 Kısa Vadeli Borçlanma Giderleri 60.000; 689 Diğer Olağandışı Gider ve Zararlar 20.000. Kurumlar vergisi %25 (KVK md. 32); kanunen kabul edilmeyen gider ve istisna yok; yıl içinde ödenen geçici vergi 80.000 TL.

1. 600 (B) 1.500.000, 642 (B) 30.000 / 690 (A) 1.530.000
2. 690 (B) 1.080.000 / 610 (A) 50.000, 621 (A) 800.000, 632 (A) 150.000, 660 (A) 60.000, 689 (A) 20.000
3. Vergi öncesi kâr: 1.530.000 − 1.080.000 = **450.000 TL**; vergi 450.000 × %25 = 112.500 → 691 (B) 112.500 / 370 (A) 112.500
4. 690 (B) 450.000 / 692 (A) 450.000 ve 692 (B) 112.500 / 691 (A) 112.500 → net kâr **337.500 TL**
5. 692 (B) 337.500 / 590 (A) 337.500
6. 371 (B) 80.000 / 193 (A) 80.000 → bilançoda ödenecek kurumlar vergisi 112.500 − 80.000 = 32.500 TL

> **Sık yapılan hata:** 690'ı "net kâr" sanmak. 690 vergiden **önceki** kârı, 692 vergiden **sonraki** net kârı gösterir; bilançoya geçen tutar 590'daki net kârdır.

## Özet

- 10 grubu: 100 Kasa, 101 Alınan Çekler, 102 Bankalar, 103 Verilen Çekler (-), 108 Diğer Hazır Değerler. Kasa alacak bakiyesi vermez.
- Kasa noksanı 197'ye, fazlası 397'ye geçici olarak alınır. Mevduat faizinde gelir brüttür; stopaj 193'e yazılır.
- Alınan çekin cirosu 101'i, işletmenin kendi çeki 103'ü alacaklandırır; çek bankadan ödenince 103 (B) / 102 (A).
- KDV: 391 > 191 + 190 ise fark 360'a; tersi hâlde 190'a devreder ve iade edilmez (KDVK md. 29/2).
- 12 temel kavram MSUGT Ek 1'dedir; sınavda örnekten kavram buldurulur.
- Düzenleyici hesaplar (-) işaretlidir ve ana hesabın tersi yönde bakiye verir.
- Mizan denkliği kayıtların aritmetik dengesini gösterir; kayıt unutma, yanlış hesap ve ters kayıt hatalarını yakalamaz.
- Kapanış: 6 grubu → 690 (vergi öncesi) → 691 vergi karşılığı → 692 (net) → 590.
