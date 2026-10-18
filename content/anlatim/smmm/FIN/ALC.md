---
ders: "FIN"
konu: "ALC"
baslik: "Alacaklar ve senetler"
durum: kontrolde
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 323"
    alinti: "Dava veya icra safhasında bulunan alacaklar"
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 323"
    alinti: "Şüpheli alacakların sonradan tahsil edilen miktarları tahsil edildikleri dönemde kar-"
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 322"
    alinti: "Kazai bir hükme veya kanaat verici bir vesikaya göre tahsiline artık"
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 281"
    alinti: "Vadesi gelmemiş olan senede bağlı alacaklar değerleme gününün kıymetine irca"
  - mevzuat: "6102 sayılı Türk Ticaret Kanunu"
    madde: "md. 795"
    alinti: "Düzenlenme günü olarak gösterilen günden önce ödenmek için ibraz olunan çek,"
---
## Bu konuda neler öğreneceksin

- Ticari alacakların Tek Düzen Hesap Planı'ndaki yeri (12 ve 22 grupları)
- Alacak senedinin tahsile ve iskontoya verilmesi, protesto ve senet yenileme kayıtları
- Şüpheli alacak şartları (VUK md. 323), karşılık ayırma ve sonradan tahsil
- Değersiz alacak (VUK md. 322) ve alacak senedi reeskontu (VUK md. 281)
- Verilen depozito ve teminatlar, ileri tarihli çek ve akreditif

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

Parantez içindeki **(-)** işareti hesabın düzenleyici (aktifi azaltan) hesap olduğunu gösterir; bilançoda ilgili alacaktan düşülerek sunulur. 122 ve 129 alacak kalanı verir.

> **Sınav ipucu:** Ana faaliyet dışı alacaklar (ortaklardan, iştiraklerden, personelden alacaklar) 12 grubunda değil, 13 Diğer Alacaklar grubunda izlenir. Şıklarda 120 ile 131/135/136'yı karıştırtan sorulara dikkat et.

## 2. Alacak senetleri

### Tahsile verme

Senet vadesinde tahsil edilmek üzere bankaya verildiğinde alacak henüz tahsil edilmemiştir; senet **121 hesabının "tahsildeki senetler" alt hesabına** aktarılır (121 borç / 121 alacak, alt hesaplar arasında). Banka tahsil edip hesaba yatırdığında **102 Bankalar** borçlandırılır, **121** alacaklandırılır; tahsil masrafı **653 Komisyon Giderleri**'ne yazılır.

Teminat olarak bankaya verilen senetler de aynı mantıkla "teminattaki senetler" alt hesabında izlenir; mülkiyet el değiştirmediği için 121'den çıkmaz.

### İskontoya verme (vadeden önce paraya çevirme)

Senet vadesinden önce bankaya kırdırıldığında banka, vadeye kalan süre için faiz (iskonto) ve masraf keser. Bankalar senet kırdırmada **dış iskonto** uygular: faiz, senedin nominal (vade) değeri üzerinden hesaplanır.

İskonto tutarı = Nominal değer × yıllık oran × gün / 360

Kayıt:

- **102 Bankalar** (borç) — eline geçen net tutar
- **780 Finansman Giderleri** (borç) — iskonto faizi
- **653 Komisyon Giderleri** (borç) — banka masrafı
- **121 Alacak Senetleri** (alacak) — senedin nominal değeri

> **Sık yapılan hata:** İskonto faizini 656 Kambiyo Zararları'na ya da 642 Faiz Gelirleri'ne yazmak. İskonto, işletmenin katlandığı bir **finansman maliyetidir** (780; 7/A seçeneğinde). 7/B seçeneğini kullanan ya da yalnız 6 grubunu kullanan işletmede doğrudan **660 Kısa Vadeli Borçlanma Giderleri**'ne yazılır.

### Protesto

Vadesinde ödenmeyen senet protesto edilirse senet 121'de kalır, "protestolu senetler" alt hesabına alınır. Protesto masrafı borçluya yansıtılacaksa alacağa eklenir (ör. 120 veya 121), yansıtılmayacaksa genel yönetim gideri olur. Protestolu senet, VUK md. 323'e göre şüpheli alacak sayılmanın da yolunu açar (bkz. bölüm 3).

### Senet yenileme

Borçlu vadesinde ödeyemez ve yeni vadeli bir senet verirse eski senet kapatılır, yeni senet kaydedilir. Yeni vadeye kadar istenen vade farkı işletme için **faiz gelirdir (642)**. Vade farkı, satılan malın bedelini artıran bir unsur olduğundan **KDV'ye tabidir** (391 Hesaplanan KDV).

## 3. Çözümlü örnek: iskonto ve yenileme

**Örnek 1 — İskonto.** İşletme 100.000 ₺ nominal değerli, vadesine 90 gün kalan senedi yıllık %40 iskonto oranıyla bankaya kırdırıyor. Banka ayrıca 500 ₺ masraf kesiyor (BSMV gibi ayrıntılar ihmal edilmiştir).

- İskonto = 100.000 × 0,40 × 90 / 360 = **10.000 ₺**
- Bankaya geçen = 100.000 − 10.000 − 500 = **89.500 ₺**

| Hesap | Borç | Alacak |
|---|---|---|
| 102 Bankalar | 89.500 ₺ | |
| 780 Finansman Giderleri | 10.000 ₺ | |
| 653 Komisyon Giderleri | 500 ₺ | |
| 121 Alacak Senetleri | | 100.000 ₺ |

**Örnek 2 — Yenileme.** Vadesi gelen 50.000 ₺ tutarlı senet için müşteri yeni senet veriyor; 4.000 ₺ vade farkı ve bunun %20 KDV'si (800 ₺) yeni senede ekleniyor. Yeni senet: 54.800 ₺.

| Hesap | Borç | Alacak |
|---|---|---|
| 121 Alacak Senetleri (yeni) | 54.800 ₺ | |
| 121 Alacak Senetleri (eski) | | 50.000 ₺ |
| 642 Faiz Gelirleri | | 4.000 ₺ |
| 391 Hesaplanan KDV | | 800 ₺ |

## 4. Şüpheli ticari alacaklar (VUK md. 323)

Vergi Usul Kanunu'na göre ticari ve zirai kazancın elde edilmesi ve idame ettirilmesiyle ilgili olmak şartıyla iki tür alacak şüpheli alacak sayılır:

1. **Dava veya icra safhasında bulunan alacaklar** (tutar sınırı yok),
2. **Protesto edilmiş ya da yazıyla bir defadan fazla istenmiş** olmasına rağmen ödenmemiş **küçük tutarlı** alacaklar. Bu tutar sınırı her yıl yeniden değerleme oranında güncellenir; 2026 yılı için **25.000 ₺**'dir (588 sıra no.lu VUK Genel Tebliği).

Şartların ikisi de alacağın "tahsil edilemeyebileceğine" dair somut bir olaya bağlanmıştır. Yalnızca vadesinin geçmiş olması alacağı şüpheli yapmaz. Karşılık, alacağın ticari faaliyetle ilgili olmasını da gerektirir; ortağa verilen borç gibi ticari olmayan alacaklar için VUK'a göre karşılık ayrılmaz.

### Kayıtlar

1. Alacak şüpheli hâle geldiğinde normal alacaklardan çıkarılır: **128** borç, **120** veya **121** alacak.
2. Değerleme gününde karşılık ayrılabilir (zorunlu değil, "ayrılabilir"): **654 Karşılık Giderleri** borç, **129 Şüpheli Ticari Alacaklar Karşılığı** alacak.
3. **Teminatlı alacaklarda** karşılık, teminattan geri kalan miktarla sınırlıdır. 60.000 ₺ alacağın 20.000 ₺'si ipotekle teminat altındaysa karşılık en çok 40.000 ₺ ayrılır.
4. Karşılık, hangi alacaklara ait olduğu gösterilerek ayrılır (alacak bazında).

### Sonradan tahsil

Kanun, sonradan tahsil edilen tutarların **tahsil edildikleri dönemde** kâr-zarar hesabına alınmasını ister:

| Durum | Karşılığın kapatılması |
|---|---|
| Karşılık ayrılan **aynı dönem** içinde tahsil | 129 borç / **654 Karşılık Giderleri** alacak (gider geri alınır) |
| Karşılık ayrıldıktan **sonraki bir dönemde** tahsil | 129 borç / **644 Konusu Kalmayan Karşılıklar** alacak |

Her iki durumda tahsilat ayrıca 100 Kasa veya 102 Bankalar borç, 128 alacak olarak kaydedilir.

**Örnek 3 — Şüpheli alacak.** 2025'te 80.000 ₺'lik (KDV dâhil) senetsiz alacak için dava açıldı ve yıl sonunda tamamı için karşılık ayrıldı. 2026'da 30.000 ₺ tahsil edildi; kalan kısım için mahkeme kararıyla tahsil imkânı kalmadı.

- 2025, dava açılınca: 128 borç 80.000 ₺ / 120 alacak 80.000 ₺
- 2025, değerleme: 654 borç 80.000 ₺ / 129 alacak 80.000 ₺
- 2026, tahsilat: 102 borç 30.000 ₺ / 128 alacak 30.000 ₺; ayrıca 129 borç 30.000 ₺ / 644 alacak 30.000 ₺
- 2026, değersiz hâle gelen kısım: 129 borç 50.000 ₺ / 128 alacak 50.000 ₺

> **Sınav ipucu:** "Geçen yıl karşılık ayrılan alacağın bir kısmı bu yıl tahsil edildi" ifadesini görünce 644 hesabını düşün. Aynı yıl içindeki tahsilatlarda 644 kullanılmaz.

## 5. Değersiz alacaklar (VUK md. 322)

Mahkeme kararı ya da kanaat verici bir belgeyle (ör. borçlunun ölümü ve mirasçısının kalmaması, konkordato ile vazgeçilen kısım) tahsil imkânı tamamen kalmayan alacaklar **değersiz alacaktır**. Değersiz alacak, kayıtlı değeriyle doğrudan zarara yazılarak yok edilir:

- Daha önce karşılık ayrılmışsa: **129** borç, **128** alacak.
- Karşılık ayrılmamışsa: **689 Diğer Olağandışı Gider ve Zararlar** borç, **128** (veya 120/121) alacak.

Şüpheli alacakta "tahsil edilemeyebilir" ihtimali, değersiz alacakta ise "tahsil edilemez" kesinliği vardır.

## 6. Alacak senedi reeskontu (VUK md. 281)

Vadesi gelmemiş senede bağlı alacaklar, değerleme gününün değerine indirilebilir (reeskont isteğe bağlıdır; ancak alacak senetleri için reeskont yapılıyorsa borç senetleri için de yapılması zorunludur, VUK md. 285). Senette faiz oranı yazılıysa o oran, yazılı değilse Merkez Bankası'nın resmî iskonto haddi kullanılır.

- Dönem sonu: **657 Reeskont Faiz Giderleri** borç, **122 Alacak Senetleri Reeskontu** alacak.
- Yeni dönemin başında ters kayıt yapılır: **122** borç, **647 Reeskont Faiz Gelirleri** alacak.

> **Hatırlatma:** Alacak senedi reeskontu işletme için **gider** (657), borç senedi reeskontu ise **gelir** (647) doğurur. Bu ikisini ters kurmak, sınavda en çok puan kaybettiren hatalardan biridir.

## 7. Depozito, teminat, ileri tarihli çek ve akreditif

**Verilen depozito ve teminatlar** (ör. kiralanan iş yeri için verilen depozito, ihaleye girerken yatırılan nakit teminat) işletmenin geri alacağı tutarlardır. Geri alınma beklenen süre bir yıla kadarsa **126**, bir yılı aşıyorsa **226 Verilen Depozito ve Teminatlar** hesabında izlenir. Sınıflandırma, bilanço gününden itibaren **kalan süreye** göre yapılır. Alınan depozito ve teminatlar ise borçtur (326 / 426). Depozito verildiğinde 126 borç / 100 veya 102 alacak; iade alındığında tersi yapılır.

**İleri tarihli çek:** Türk Ticaret Kanunu'na göre çek görüldüğünde ödenir. Üzerinde yazan düzenleme tarihinden önce bankaya ibraz edilen çek de ibraz günü ödenir (TTK md. 795). Bu nedenle çek, üzerindeki tarihe bakılmaksızın bir ödeme aracıdır. Muhasebe uygulamasında alınan çekler, keşide tarihi ileri olsa da **101 Alınan Çekler** hesabında izlenir; verilen çekler **103 Verilen Çekler ve Ödeme Emirleri (-)** hesabında izlenir.

**Akreditif:** İthalatçı, satıcıya ödemenin garanti altına alınması için bankasına akreditif açtırır; banka, belgeler şartlara uygun ibraz edildiğinde ödemeyi yapar. Ders kitaplarındaki yaygın uygulamada akreditif için bankaya yatırılan (bloke edilen) tutar ve açılış masrafları, mal henüz gelmediği için **159 Verilen Sipariş Avansları** hesabının ilgili ithalat alt hesabında izlenir: 159 borç / 102 alacak. Mal teslim alınınca biriken tutar maliyete aktarılır: 153 Ticari Mallar borç / 159 alacak. Akreditif banka kredisiyle açılmışsa karşı hesap 300 Banka Kredileri olur. İhracatçı açısından akreditifli satış, malın tesliminde **120 Alıcılar** (ya da peşin tahsilde 102) ile kaydedilir.

> **Sık yapılan hata:** Akreditif için bloke edilen tutarı doğrudan 153 veya 770'e yazmak. Mal gelmeden stok oluşmaz; tutar sipariş avansı (159) olarak bekler.

## Özet

- 120 senetsiz, 121 senetli ticari alacak; ana faaliyet dışı alacaklar 13 grubunda.
- İskonto: dış iskonto (nominal × oran × gün/360); iskonto faizi finansman gideridir (780), banka masrafı 653.
- Senet yenilemede vade farkı faiz gelirdir (642) ve KDV'ye tabidir (391).
- Şüpheli alacak: dava/icra safhası **veya** protesto/birden fazla yazılı talep + tutar sınırı (2026: 25.000 ₺). Karşılık 654/129; teminatlı kısma karşılık ayrılmaz.
- Sonradan tahsil: aynı dönemde 654, sonraki dönemde 644.
- Değersiz alacak: karşılık yoksa 689, varsa 129 kullanılarak kapatılır.
- Alacak senedi reeskontu 657/122, ertesi dönem ters kayıt 122/647.
- Depozito: 126/226 (verilen), 326/426 (alınan); ileri tarihli çek 101'de izlenir; akreditif 159'da bekler, mal gelince 153'e aktarılır.
