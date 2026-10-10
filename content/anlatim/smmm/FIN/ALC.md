---
ders: FIN
konu: ALC
baslik: Alacaklar ve senetler
durum: kontrolde
yazar: mevo-ornek
kaynaklar:
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 323
    alinti: "Dava veya icra safhasında bulunan alacaklar"
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 323
    alinti: "Şüpheli alacakların sonradan tahsil edilen miktarları tahsil edildikleri dönemde kar-"
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 322
    alinti: "Kazai bir hükme veya kanaat verici bir vesikaya göre tahsiline artık"
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 281
    alinti: "Vadesi gelmemiş olan senede bağlı alacaklar değerleme gününün kıymetine irca"
  - mevzuat: 6102 sayılı Türk Ticaret Kanunu
    madde: md. 795
    alinti: "Düzenlenme günü olarak gösterilen günden önce ödenmek için ibraz olunan çek,"
---
## Bu konuda neler öğreneceksin

- Ticari alacakların Tek Düzen Hesap Planı'ndaki yeri (12 ve 22 grupları)
- Alacak senedinin tahsile ve iskontoya verilmesi, senet yenileme kayıtları
- Şüpheli alacak şartları, karşılık ayırma ve sonradan tahsil
- Değersiz alacak, alacak senedi reeskontu
- Verilen depozito ve teminatlar, ileri tarihli çek

## 1. Ticari alacaklar hangi hesaplarda izlenir?

Ana faaliyet konusu mal ve hizmet satışlarından doğan alacaklar **12 Ticari Alacaklar** grubunda (vadesi bir yıla kadar), vadesi bir yılı aşanlar ise **22 Ticari Alacaklar** grubunda izlenir. Sınavda en çok karşına çıkacak hesaplar:

| Hesap | Ne izlenir? |
|---|---|
| 120 Alıcılar | Senetsiz (açık hesap) satışlardan doğan alacaklar |
| 121 Alacak Senetleri | Poliçe, bono gibi senede bağlanmış ticari alacaklar |
| 122 Alacak Senetleri Reeskontu (-) | Senetli alacakların değerleme günü değerine indirilmesi |
| 126 Verilen Depozito ve Teminatlar | Kısa vadeli olarak verilen depozito ve teminatlar |
| 128 Şüpheli Ticari Alacaklar | Tahsili şüpheli hâle gelen ticari alacaklar |
| 129 Şüpheli Ticari Alacaklar Karşılığı (-) | Şüpheli alacaklar için ayrılan karşılık |

Parantez içindeki **(-)** işareti hesabın düzenleyici (aktifi azaltan) hesap olduğunu gösterir; bilançoda ilgili alacaktan düşülerek sunulur.

> **Sınav ipucu:** Ana faaliyet dışı alacaklar (ortaklardan, iştiraklerden, personelden alacaklar) 12 grubunda değil, 13 Diğer Alacaklar grubunda izlenir. Şıklarda 120 ile 136'yı karıştırtan sorulara dikkat et.

## 2. Alacak senetleri

### Tahsile verme

Senet vadesinde tahsil edilmek üzere bankaya verildiğinde alacak henüz tahsil edilmemiştir; işletme senedi genellikle **121 hesabının "tahsildeki senetler" alt hesabında** izler. Banka tahsil edip hesaba yatırdığında 102 Bankalar borçlandırılır, 121 alacaklandırılır; tahsil masrafı 653 Komisyon Giderleri'ne yazılır.

### İskontoya verme (vadeden önce paraya çevirme)

Senet vadesinden önce bankaya kırdırıldığında banka, vadeye kalan süre için faiz (iskonto) ve masraf keser. Kayıt:

- **102 Bankalar** (borç) — eline geçen net tutar
- **780 Finansman Giderleri** (borç) — iskonto faizi
- **653 Komisyon Giderleri** (borç) — banka masrafı
- **121 Alacak Senetleri** (alacak) — senedin nominal değeri

> **Sık yapılan hata:** İskonto faizini 656 Kambiyo Zararları'na ya da 642 Faiz Gelirleri'ne yazmak. İskonto, işletmenin katlandığı bir **finansman maliyetidir** (780; 7/A seçeneğinde). Gelir tablosunda 660 Kısa Vadeli Borçlanma Giderleri olarak görünür.

### Senet yenileme

Borçlu vadesinde ödeyemez ve yeni vadeli bir senet verirse eski senet kapatılır, yeni senet kaydedilir. Yeni vadeye kadar istenen vade farkı işletme için **faiz gelirdir**: 121 Alacak Senetleri (yeni senet, vade farkı dâhil) borç; 121 (eski senet) alacak; 642 Faiz Gelirleri alacak. Vade farkı KDV'ye tabi olduğundan 391 Hesaplanan KDV de alacaklandırılır.

## 3. Şüpheli ticari alacaklar (VUK md. 323)

Vergi Usul Kanunu'na göre ticari ve zirai kazancın elde edilmesi ve idame ettirilmesiyle ilgili olmak şartıyla iki tür alacak şüpheli alacak sayılır:

1. **Dava veya icra safhasında bulunan alacaklar** (tutar sınırı yok),
2. **Protesto edilmiş ya da yazıyla bir defadan fazla istenmiş** olmasına rağmen ödenmemiş **küçük tutarlı** alacaklar. Bu tutar sınırı her yıl yeniden değerleme oranında güncellenir; 2026 yılı için **25.000 TL**'dir (Gelir İdaresi 588 sıra no.lu VUK Genel Tebliği).

Şartların ikisi de alacağın "tahsil edilemeyebileceğine" dair somut bir olaya bağlanmıştır. Yalnızca vadesinin geçmiş olması alacağı şüpheli yapmaz.

### Kayıtlar

1. Alacak şüpheli hâle geldiğinde normal alacaklardan çıkarılır: **128** borç, **120** veya **121** alacak.
2. Değerleme gününde karşılık ayrılabilir (zorunlu değil, "ayrılabilir"): **654 Karşılık Giderleri** borç, **129 Şüpheli Ticari Alacaklar Karşılığı** alacak. Teminatlı alacaklarda karşılık, teminattan kalan tutarla sınırlıdır.

### Sonradan tahsil

Kanun, sonradan tahsil edilen tutarların **tahsil edildikleri dönemde** gelir yazılmasını ister:

| Durum | Karşılığın kapatılması |
|---|---|
| Karşılık ayrılan **aynı dönem** içinde tahsil | 129 borç / **654 Karşılık Giderleri** alacak (gider kısmen geri alınır) |
| Karşılık ayrıldıktan **sonraki bir dönemde** tahsil | 129 borç / **644 Konusu Kalmayan Karşılıklar** alacak |

Her iki durumda tahsilat ayrıca 100 Kasa veya 102 Bankalar borç, 128 alacak olarak kaydedilir.

> **Sınav ipucu:** "Geçen yıl karşılık ayrılan alacağın bir kısmı bu yıl tahsil edildi" ifadesini görünce 644 hesabını düşün. Aynı yıl içindeki tahsilatlarda 644 kullanılmaz.

## 4. Değersiz alacaklar (VUK md. 322)

Mahkeme kararı ya da kanaat verici bir belgeyle (ör. borçlunun ölümü ve mirasçısının kalmaması) tahsil imkânı tamamen kalmayan alacaklar **değersiz alacaktır**. Değersiz alacak, kayıtlı değeriyle doğrudan zarara yazılarak yok edilir:

- Daha önce karşılık ayrılmışsa: **129** borç, **128** alacak.
- Karşılık ayrılmamışsa: **689 Diğer Olağandışı Gider ve Zararlar** borç, **128** (veya 120/121) alacak.

Şüpheli alacakta "tahsil edilemeyebilir" ihtimali, değersiz alacakta ise "tahsil edilemez" kesinliği vardır.

## 5. Alacak senedi reeskontu (VUK md. 281)

Vadesi gelmemiş senede bağlı alacaklar, değerleme gününün değerine indirilebilir (reeskont isteğe bağlıdır). Senette faiz oranı yazılıysa o oran, yazılı değilse Merkez Bankası'nın iskonto oranı kullanılır.

- Dönem sonu: **657 Reeskont Faiz Giderleri** borç, **122 Alacak Senetleri Reeskontu** alacak.
- Yeni dönemin başında ters kayıt yapılır: **122** borç, **647 Reeskont Faiz Gelirleri** alacak.

> **Hatırlatma:** Alacak senedi reeskontu işletme için **gider** (657), borç senedi reeskontu ise **gelir** (647) doğurur. Bu ikisini ters kurmak, sınavda en çok puan kaybettiren hatalardan biridir.

## 6. Depozito, teminat ve ileri tarihli çek

**Verilen depozito ve teminatlar** (ör. kiralanan iş yeri için verilen depozito) işletmenin geri alacağı tutarlardır. Geri alınma beklenen süre bir yıla kadarsa **126**, bir yılı aşıyorsa **226 Verilen Depozito ve Teminatlar** hesabında izlenir. Sınıflandırma, bilanço gününden itibaren **kalan süreye** göre yapılır. Alınan depozito ve teminatlar ise borçtur (326 / 426).

**İleri tarihli çek:** Türk Ticaret Kanunu'na göre çek görüldüğünde ödenir. Üzerinde yazan tarihten önce bankaya ibraz edilen çek de ibraz günü ödenir (TTK md. 795/2). Bu nedenle çek, üzerindeki tarihe bakılmaksızın bir ödeme aracıdır. Muhasebe uygulamasında alınan çekler 101 Alınan Çekler hesabında izlenir.

## Özet

- 120 senetsiz, 121 senetli ticari alacak; ana faaliyet dışı alacaklar 13 grubunda.
- İskonto faizi finansman gideridir (780), senet yenilemedeki vade farkı faiz gelirdir (642).
- Şüpheli alacak: dava/icra safhası **veya** protesto/birden fazla yazılı talep + tutar sınırı (2026: 25.000 TL). Karşılık 654/129.
- Sonradan tahsil: aynı dönemde 654, sonraki dönemde 644.
- Değersiz alacak: karşılık yoksa 689, varsa 129 kullanılarak kapatılır.
- Alacak senedi reeskontu 657/122, ertesi dönem ters kayıt 122/647.
