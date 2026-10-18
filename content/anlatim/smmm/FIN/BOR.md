---
ders: "FIN"
konu: "BOR"
baslik: "Yabancı kaynaklar ve mali borçlar"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "30. Mali Borçlar"
    alinti: "vadesine bir yıldan daha az bir süre kalan uzun vadeli mali borçların ana para taksit ve faizlerini kapsar"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "303. Uzun Vadeli Kredilerin Anapara Taksitleri ve Faizleri"
    alinti: "bilanço tarihinden itibaren bir yıl içinde ödenecek anapara taksitleri ile vadesi bir yılın altına düşenleri"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "305. Çıkarılmış Bonolar ve Senetler"
    alinti: "ihraç edildiğinde nominal bedel üzerinden bu hesaba alacak, ilgili hesaplara borç kaydedilir"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "408. Menkul Kıymetler İhraç Farkı (-)"
    alinti: "gelecek dönemde itfa edilecek kısmı bilanço tarihinde \"308. Menkul Kıymetler İhraç Farkı Hesabı\"na aktarılarak"
  - mevzuat: "MSUGT 1 Sıra No'lu Tebliğ Ek 5 (Tek Düzen Hesap Planı)"
    madde: "656. Kambiyo Zararları (-)"
    alinti: "Borçlanma ile ilgili kur farkları bu hesaba alınmaz, finansman gideri olarak muhasebeleştirilir."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 285"
    alinti: "Mevduat veya kredi sözleşmelerine müstenit borçlar değerleme gününe kadar hesaplanacak faizleriyle birlikte dikkate alınır."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 286"
    alinti: "çıkardıkları tahvilleri itibari değerleriyle değerlemeye mecburdurlar"
  - mevzuat: "193 sayılı Gelir Vergisi Kanunu"
    madde: "Geçici md. 67/2"
    alinti: "ödemeyi yapanlarca, banka veya aracı kurumlara veya bunlar aracılığıyla diğer gerçek ve tüzel kişilere ödenenler hariç"
---
## Bu konuda neler öğreneceksin

- Kısa vadeli (30) ve uzun vadeli (40) mali borçları ticari borçlardan (32/42) ayırmayı
- Banka kredisi kullanımı ve dönem sonu faiz tahakkuku kayıtlarını (VUK md. 285)
- Bono ve tahvil ihracında 305, 308, 405 ve 408 hesaplarının işleyişini, ihraç farkının itfasını
- Uzun vadeli kredi ve tahvillerin kısa vadeye aktarılmasını (400 → 303, 405 → 304)
- Döviz kredilerinde kur farkının hangi hesaba yazılacağını
- Tahvil faizi ödemesinde stopajın (vergi tevkifatı) kaydını

## 1. Yabancı kaynakların sınıflandırılması

Yabancı kaynaklar, işletmenin üçüncü kişilere olan borçlarıdır. Tek Düzen Hesap Planı'nda vadesi bilanço gününden itibaren bir yıla kadar olanlar **3 Kısa Vadeli Yabancı Kaynaklar**, bir yılı aşanlar **4 Uzun Vadeli Yabancı Kaynaklar** sınıfında izlenir. Borcun **kaynağı** da önemlidir:

- **Mali borçlar (30/40):** Kredi kurumlarından veya para ve sermaye piyasasından (bono, tahvil) sağlanan finansman.
- **Ticari borçlar (32/42):** Faaliyet konusu mal ve hizmet alımlarından doğan borçlar: 320 Satıcılar (senetsiz), 321 Borç Senetleri (senetli), 322 Borç Senetleri Reeskontu (-), 326 Alınan Depozito ve Teminatlar, 329 Diğer Ticari Borçlar.

| Hesap | Ne izlenir? |
|---|---|
| 300 Banka Kredileri | Kısa vadeli banka ve finans kuruluşu kredileri |
| 303 Uzun Vadeli Kredilerin Anapara Taksitleri ve Faizleri | Uzun vadeli kredinin bir yıl içinde ödenecek taksitleri ve tahakkuk etmiş faizleri |
| 304 Tahvil Anapara Borç, Taksit ve Faizleri | Tahvilin bir yıl içinde ödenecek anaparası ve tahakkuk etmiş faizleri |
| 305 Çıkarılmış Bonolar ve Senetler | Finansman bonosu, banka bonosu gibi kısa vadeli araçlar (nominal değerle) |
| 308 Menkul Kıymetler İhraç Farkı (-) | İskontolu ihraç farkının gelecek 12 aya düşen kısmı |
| 400 Banka Kredileri | Uzun vadeli banka kredileri |
| 405 Çıkarılmış Tahviller | Vadesi bir yılı aşan tahviller (nominal değerle) |
| 408 Menkul Kıymetler İhraç Farkı (-) | İskontolu ihraç farkının gelecek yıllara ait kısmı |

308 ve 408 **düzenleyici (pasifi azaltan)** hesaplardır; borç bakiyesi verirler ve bilançoda ilgili borçtan düşülerek gösterilirler.

> **Sınav ipucu:** "Satıcıya verilen bono" 321 Borç Senetleri'ne, "işletmenin piyasaya ihraç ettiği finansman bonosu" 305'e yazılır. İkisi de "bono"dur ama biri ticari, diğeri mali borçtur. Sınıflandırmada belirleyici olan bilanço gününden itibaren **kalan** vadedir, kredinin ilk vadesi değildir.

## 2. Banka kredileri ve faiz tahakkuku

### Kredi kullanımı

Kredi hesaba geçtiğinde vade bir yıla kadarsa 300, bir yılı aşıyorsa 400 alacaklandırılır:

- **102 Bankalar** (B) — hesaba geçen tutar
- **300 / 400 Banka Kredileri** (A) — anapara

Bankanın kestiği tahsis komisyonu ve masraflar borçlanma maliyetidir; 780 Finansman Giderleri'ne (maliyet hesapları kullanılmıyorsa doğrudan 660/661'e) yazılır. Banka kredisi faizinden işletme stopaj yapmaz; bankanın faiz üzerinden tahsil ettiği BSMV de borçlanma maliyetinin bir parçasıdır.

### Faiz gideri hangi hesaba?

- 7/A seçeneğini uygulayan işletme faizi **780 Finansman Giderleri**'ne yazar; dönem sonunda 781 Finansman Giderleri Yansıtma Hesabı aracılığıyla 66 grubuna aktarır.
- 66 grubunda ayrım borcun vadesine göredir: **660 Kısa Vadeli Borçlanma Giderleri** (bir yıla kadar vadeli borçlanmalar), **661 Uzun Vadeli Borçlanma Giderleri** (bir yılı aşan borçlanmalar).
- Özellikli bir varlığın (ör. inşa edilen fabrika) edinimi için kullanılan kredinin faizi, varlık kullanıma hazır hâle gelinceye kadar varlığın maliyetine eklenir (TMS 23); bu nedenle 66 grubu "varlıkların maliyetine eklenmemiş" finansman giderlerini kapsar.

### Dönem sonu tahakkuku

VUK md. 285'e göre kredi sözleşmesine dayanan borçlar, değerleme gününe kadar hesaplanacak faizleriyle birlikte dikkate alınır. Yani vadesi gelmemiş olsa da dönemin faizi gider yazılır (dönemsellik kavramı):

- Kısa vadeli kredi faizi: **780** (B) / **300 Banka Kredileri** (A) — uygulamada 381 Gider Tahakkukları da kullanılır.
- Uzun vadeli kredi faizi: **780** (B) / **303** (A); çünkü 303 tahakkuk edip henüz ödenmemiş faizleri de kapsar.

**Sayısal örnek:** 1 Ekim 2026'da 6 ay vadeli, yıllık %36 faizli 400.000 ₺ kredi kullanıldı; anapara ve faiz vadede ödenecek.

- Kullanım: 102 (B) 400.000 / 300 (A) 400.000
- 31.12.2026 tahakkuk: 400.000 × 0,36 × 3/12 = **36.000 ₺** → 780 (B) 36.000 / 300 (A) 36.000
- 1 Nisan 2027 ödeme: toplam faiz 400.000 × 0,36 × 6/12 = 72.000 ₺; 2027'ye düşen 36.000 ₺. Kayıt: 300 (B) 436.000, 780 (B) 36.000 / 102 (A) 472.000

> **Sık yapılan hata:** Ödeme tarihinde 72.000 ₺ faizin tamamını 2027 gideri yazmak. 36.000 ₺ zaten 2026'da gider yazılıp borca eklendiği için ödemede yalnız kalan 36.000 ₺ gider olur; aksi hâlde aynı faiz iki kez gider yazılır.

## 3. Bono ve tahvil ihracı (305/308/405/408)

**Bono (finansman bonosu)** vadesi bir yıla kadar, **tahvil** vadesi bir yılı aşan borçlanma aracıdır. THP'ye göre çıkarılan menkul kıymet her zaman **nominal (itibari) değeriyle** 305 veya 405'e alacak yazılır; VUK md. 286 da şirketlerin çıkardıkları tahvilleri itibari değerleriyle değerlemesini zorunlu tutar.

### İskontolu (nominalin altında) ihraç

Fiilen toplanan para ile nominal değer arasındaki fark, işletmenin vade boyunca katlanacağı ek finansman maliyetidir. Bu fark ihraç anında gider yazılmaz; 308/408'e borç yazılır ve vadeye paralel **itfa** edilir:

- Gelecek 12 aya ait itfa payı → **308** (B)
- Daha sonraki yıllara ait kısım → **408** (B)
- Her bilanço gününde, izleyen yıl itfa edilecek kısım 408'den 308'e aktarılır: 308 (B) / 408 (A)
- İtfa kaydı: 780 (veya 66 grubu) (B) / 308 (A)

Kısa vadeli bono iskontolu çıkarılırsa farkın tamamı doğrudan 308'e yazılır.

THP'de 308/408 yalnızca nominalin **altında** ihraç için düzenlenmiştir. Nominal değerle ihraçta fark doğmaz; 102 (B) / 305 veya 405 (A) kaydı yeterlidir.

### Faiz (kupon) tahakkuku ve stopaj

Tahvil faizi dönem sonunda **780** (B) / **304** (A) ile tahakkuk ettirilir. Ödemede stopaj gündeme gelir:

**Stopaj (vergi tevkifatı)**, vergiyi gelir sahibinin yerine ödemeyi yapanın keserek vergi dairesine yatırmasıdır. GVK geçici md. 67/2'ye göre tahvil faizlerinden ödemeyi yapanlarca %15 oranında tevkifat yapılır; ancak banka veya aracı kurumlara ya da bunlar aracılığıyla yapılan ödemeler hariçtir (bu durumda tevkifatı ödemeye aracılık eden banka veya aracı kurum yapar). Sınavda stopaj oranı genellikle soruda verilir; verilen oranı kullan, oran uydurma.

Stopajlı ödeme kaydı:

- **304** (B) — brüt faiz
- **360 Ödenecek Vergi ve Fonlar** (A) — kesilen vergi
- **102 Bankalar** (A) — tahvil sahibine ödenen net tutar

Kesilen vergi muhtasar beyannameyle beyan edilip ödendiğinde 360 (B) / 102 (A) kaydı yapılır. Stopaj işletmenin gideri **değildir**: gider brüt faizdir; işletme yalnızca vergiyi tahvil sahibi adına keser.

> **Sınav ipucu:** Şıklarda stopaj tutarını 780'e borç yazan kayıt yanlıştır. 780'e yazılan tutar brüt faizdir; stopaj 360'ın alacağına, net tutar 102'nin alacağına gider.

## 4. Uzun vadeli borcun kısa vadeye aktarılması

Bilanço gününde, uzun vadeli borçların izleyen 12 ay içinde ödenecek kısmı kısa vadeli yabancı kaynaklara aktarılır. Bu bir **sınıflandırma** kaydıdır; toplam borç, gelir ve gider değişmez.

| Borç | Aktarım kaydı |
|---|---|
| Uzun vadeli banka kredisi | 400 (B) / 303 (A) |
| Çıkarılmış tahvil | 405 (B) / 304 (A) |
| Çıkarılmış diğer menkul kıymet | 407 (B) / 306 (A) |
| İhraç farkının gelecek yıla düşen kısmı | 308 (B) / 408 (A) |

Örnek: 400 hesabında 900.000 ₺ bakiye var; 300.000 ₺'si izleyen yıl ödenecek. Kayıt: 400 (B) 300.000 / 303 (A) 300.000. Bilançoda 303'te 300.000 ₺, 400'de 600.000 ₺ görünür.

## 5. Yabancı para borçlar ve kur farkı

Yabancı para kredi kullanıldığı gün kuruyla TL'ye çevrilerek kaydedilir. Dönem sonunda VUK md. 280'e göre yabancı paraya bağlı borçlar da değerlenir (uygulamada TCMB döviz alış kuru), TMS 21'e göre ise parasal kalemler kapanış kurundan çevrilir ve kur farkı oluştuğu dönemde kâr veya zararda gösterilir.

**Hesap seçimi:** THP 656 Kambiyo Zararları hesabının açıklamasına göre borçlanmayla ilgili kur farkları bu hesaba alınmaz, **finansman gideri** olarak muhasebeleştirilir. Bu nedenle:

- Kur artışı (aleyhte fark): **780 Finansman Giderleri** (veya 660/661) (B) / ilgili kredi hesabı (A)
- Kur düşüşü (lehte fark): ilgili kredi hesabı (B) / **646 Kambiyo Kârları** (A)

**Sayısal örnek:** 1 Kasım 2026'da 6 ay vadeli 50.000 USD kredi kullanıldı, kur 40,00 ₺.

- Kullanım: 102 (B) 2.000.000 / 300 (A) 2.000.000
- 31.12.2026 kur 42,00: borç 2.100.000 ₺; fark **100.000 ₺ aleyhte** → 780 (B) 100.000 / 300 (A) 100.000
- Kur 38,50 olsaydı: borç 1.925.000 ₺; 75.000 ₺ lehte fark → 300 (B) 75.000 / 646 (A) 75.000

> **Sık yapılan hata:** Döviz kredisinin kur zararını 656 Kambiyo Zararları'na yazmak. 656 ticari işlemlerden (ör. döviz alacak, döviz kasası) doğan kur farkları içindir; kredi gibi borçlanmalardan doğan kur farkı finansman gideridir. Kur farkı olağandışı gider (68 grubu) de değildir.

## 6. Kapsamlı örnek: tahvil ihracından vadeye

1 Ocak 2026'da 31.12.2028 vadeli (3 yıl), nominal değeri 1.200.000 ₺ olan tahviller 1.110.000 ₺'ye ihraç edildi. Yıllık %20 faiz her yıl sonunda tahakkuk ettirilip izleyen gün ödenecek; tahvil sahiplerine doğrudan ödeme yapıldığı ve stopaj oranının %15 olduğu varsayılıyor. İhraç farkı doğrusal itfa ediliyor.

1. İhraç farkı: 1.200.000 − 1.110.000 = 90.000 ₺; yıllık itfa 90.000 / 3 = 30.000 ₺.
2. İhraç kaydı: 102 (B) 1.110.000, 308 (B) 30.000, 408 (B) 60.000 / 405 (A) 1.200.000
3. 31.12.2026 faiz tahakkuku: 1.200.000 × %20 = 240.000 → 780 (B) 240.000 / 304 (A) 240.000
4. İhraç farkı itfası: 780 (B) 30.000 / 308 (A) 30.000
5. Gelecek yılın itfa payının aktarımı: 308 (B) 30.000 / 408 (A) 30.000
6. Faiz ödemesi: stopaj 240.000 × %15 = 36.000; net 204.000 → 304 (B) 240.000 / 360 (A) 36.000, 102 (A) 204.000
7. 31.12.2027'de anapara izleyen 12 ay içinde (31.12.2028) ödeneceğinden: 405 (B) 1.200.000 / 304 (A) 1.200.000; 408'de kalan 30.000 ₺ de 308'e aktarılır.

2026 yılının toplam tahvil finansman gideri 240.000 + 30.000 = **270.000 ₺**'dir. 31.12.2026 bilançosunda tahvilin net defter değeri 1.200.000 − 30.000 (308) − 30.000 (408) = 1.140.000 ₺'dir.

## 7. Ticari borçlarda değerleme notu (32 grubu)

VUK md. 285'e göre borçlar mukayyet (kayıtlı) değeriyle değerlenir; vadesi gelmemiş senede bağlı borçlar değerleme günü değerine indirgenebilir (reeskont, isteğe bağlı). Ancak alacak senetlerini reeskonta tabi tutan mükellef, borç senetlerini de reeskonta tabi tutmak zorundadır. Borç senedi reeskontu dönem sonunda 322 (B) / 647 Reeskont Faiz Gelirleri (A) ile kaydedilir; izleyen dönem başında iptal edilir ve fark 657 Reeskont Faiz Giderleri'ne yazılır: 657 (B) / 322 (A).

## Özet

- Mali borçlar 30 (kısa) ve 40 (uzun) grubunda; ticari borçlar 32/42'de izlenir. Sınıflandırma bilanço gününden itibaren kalan vadeye göredir.
- Kredi kullanımı: 102 (B) / 300 veya 400 (A). Faiz 780'e (66 grubuna aktarılır), kısa vadelide 300'e, uzun vadelide 303'e tahakkuk ettirilir.
- Bono 305'e, tahvil 405'e daima nominal değerle alacak yazılır; iskontolu ihraç farkı 308 (12 ay) ve 408'de (sonraki yıllar) izlenip 780/66 karşılığında itfa edilir.
- Bir yıl içinde ödenecek kısım: 400 → 303, 405 → 304; bu kayıt yalnız sınıflandırmayı değiştirir.
- Borçlanma kaynaklı kur farkı 656'ya değil finansman giderine (780/66) yazılır; lehte fark 646'dır.
- Tahvil faizi ödemesinde stopaj 360'ın alacağına yazılır; gider brüt faizdir. Banka kredisi faizinden işletme stopaj yapmaz.
