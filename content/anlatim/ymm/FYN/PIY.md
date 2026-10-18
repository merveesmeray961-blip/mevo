---
ders: FYN
konu: PIY
baslik: "Finansal piyasalar ve türev ürünler"
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Para ve sermaye piyasası araçları, halka arz"
    madde: "-"
  - mevzuat: "Genel bilgi — Vadeli işlem, forward ve opsiyon sözleşmeleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Faiz swapı ve kredi temerrüt swabı"
    madde: "-"
  - mevzuat: "Genel bilgi — Kur riski, çapraz kur ve korunma yöntemleri"
    madde: "-"
  - mevzuat: "Genel bilgi — Menkul kıymetleştirme"
    madde: "-"
  - mevzuat: "Genel bilgi — Finansal yönetimin amacı, acenta sorunu ve ekonomik kâr"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Para ve sermaye piyasası araçlarını alacak, ortaklık ve karma araç olarak sınıflamayı
- Forward, vadeli işlem (futures) ve opsiyonun işleyişini, opsiyon primini etkileyen faktörleri
- Faiz swapında karşılaştırmalı üstünlük hesabını ve kredi temerrüt swabını (CDS)
- Kur riskini, çapraz kur hesabını ve korunma yöntemlerini
- Menkul kıymetleştirmeyi, acenta sorununu ve ekonomik kâr kavramını

Bu konu YMM Finansal Yönetim sınavında iki biçimde gelir: 4-5 puanlık kavram soruları (CDS, menkul kıymetleştirme, acenta sorunu, opsiyon primi) ve 20 puanlık hesaplı sorular (faiz swapı, döviz opsiyonu, çapraz kur). Örneklerdeki kur ve faizler varsayımsaldır.

## 1. Finansal yönetimin temel kavramları

Finansal yönetimin amacı **kâr maksimizasyonu** değil, **firma değerinin** (pay başına piyasa değerinin) maksimizasyonudur. Kâr; nakit akışlarının zamanlamasını ve riskini dikkate almaz, değer ise ikisini de içerir. **Piyasa kapitalizasyonu** = dolaşımdaki pay sayısı × pay piyasa fiyatıdır.

**Acenta (vekâlet) sorunu**, yöneticinin (vekil) ortakların (asil) yerine kendi çıkarını gözetmesidir. İkinci tür çatışma ortaklar ile alacaklılar arasındadır: ortaklar alacaklının parasıyla riskli projeye girebilir. **Acenta maliyetleri** üç türlüdür: izleme maliyeti (bağımsız denetim, raporlama), bağlama maliyeti (yöneticinin kendini sınırlayan taahhütleri) ve kalıntı kayıp (önlemlere rağmen kaybedilen değer). Çözüm araçları: performansa bağlı ücret ve pay opsiyonu, bağımsız yönetim kurulu üyeleri, kredi sözleşmesindeki kısıtlayıcı koşullar ve şirketin ele geçirilme tehdidi.

**Ekonomik kâr**, muhasebe kârından özkaynak dahil tüm sermayenin fırsat maliyeti düşülerek bulunur. Uygulamadaki ölçüsü **ekonomik katma değerdir (EVA)**: EVA = vergi sonrası faaliyet kârı − AOSM × yatırılan sermaye.

**Örnek:** Faiz ve vergi öncesi kâr 10.000.000 TL, vergi oranı %25, yatırılan sermaye 40.000.000 TL, ağırlıklı ortalama sermaye maliyeti (AOSM) %15. Vergi sonrası faaliyet kârı 7.500.000 TL, sermaye maliyeti 6.000.000 TL, EVA = 1.500.000 TL. Muhasebe kârı pozitif olsa da EVA negatifse işletme değer yok eder.

**Piyasa faiz oranının bileşenleri:** nominal faiz = reel risksiz faiz + enflasyon primi + temerrüt riski primi + likidite primi + vade riski primi. **Nakit süpürme** (cash sweep), belirlenen tutarı aşan nakdin bir kurala göre otomatik olarak borcun erken ödenmesine veya getirili hesaba aktarılmasıdır.

## 2. Para ve sermaye piyasası araçları

**Para piyasası** vadesi bir yıla kadar olan fonların, **sermaye piyasası** bir yıldan uzun vadeli fonların el değiştirdiği piyasadır.

| Grup | Araçlar |
|---|---|
| Para piyasası | Hazine bonosu, repo ve ters repo, banka bonosu, finansman bonosu, ticari senet, mevduat sertifikası |
| Alacak (borçlanma) aracı | Devlet tahvili, özel sektör tahvili, eurobond, kira sertifikası (sukuk) |
| Ortaklık aracı | Pay (hisse) senedi |
| Karma araç | Paya dönüştürülebilir tahvil, değiştirilebilir tahvil, kâr-zarar ortaklığı belgesi, varant |

**Repo**, menkul kıymetin geri alım vaadiyle satılmasıdır; satan için borçlanma, karşı taraf için (ters repo) kısa vadeli yatırımdır. **Halka arzın faydaları:** uzun vadeli özkaynak finansmanı, payların likidite kazanması, şirket değerinin piyasada belirlenmesi, kurumsallaşma ve şeffaflık, mevcut ortakların kısmen çıkış imkânı.

## 3. Forward, vadeli işlem ve opsiyon

**Forward**, iki tarafın bir varlığı ileri tarihte bugünden belirlenen fiyatla alıp satmak için yaptığı tezgâh üstü sözleşmedir; karşı taraf riski taşır. **Vadeli işlem (futures)** aynı ekonomik içeriğin borsada (VİOP) standart sözleşmeyle yapılanıdır: takas kurumu karşı taraf olur, teminat yatırılır ve kâr-zarar her gün uzlaştırılır.

Döviz forward kuru **faiz paritesiyle** bulunur: F = S × (1 + i_TL × t) / (1 + i_döviz × t). Spot USD/TL 42,00, TL faizi %36, USD faizi %4 ise 3 aylık forward = 42 × 1,09 / 1,01 = **45,33 TL**.

**Opsiyon**, alıcısına prim karşılığında bir varlığı belirli fiyattan (**kullanım fiyatı**) alma (**alım/call**) ya da satma (**satım/put**) **hakkı**; satıcısına ise yükümlülük verir. Avrupa tipi yalnız vadede, Amerikan tipi vadeye kadar her an kullanılır. Alıcının en büyük zararı primle sınırlıdır. Prim = **içsel değer** + **zaman değeri**; içsel değeri pozitif opsiyon "kârda", sıfır olan "başabaşta" veya "zararda"dır.

| Faktör artarsa | Alım primi | Satım primi |
|---|---|---|
| Dayanak varlık fiyatı | Artar | Azalır |
| Kullanım fiyatı | Azalır | Artar |
| Volatilite | Artar | Artar |
| Vadeye kalan süre (Amerikan tipi) | Artar | Artar |
| Risksiz faiz oranı | Artar | Azalır |
| Beklenen temettü | Azalır | Artar |

> **Sınav ipucu:** Opsiyon primi sorusunda tabloyu yönleriyle birlikte yaz; volatilitenin her iki primi de artırdığını mutlaka belirt. Hesaplı sorularda kullanım kararını her senaryo için ayrı cümleyle ver ("opsiyon kullanılır / kullanılmaz"); puanlama bu karar cümlesine ayrıca puan veriyor.

**Çözümlü örnek 1 (döviz satım opsiyonu):** İhracatçı 3 ay sonra 100.000 USD tahsil edecektir. Kullanım fiyatı 42,00 TL, prim USD başına 0,50 TL (toplam 50.000 TL, zaman değeri ihmal).

- Senaryo 1, vadede spot 40,00: Opsiyon kullanılır. Tahsilat 4.200.000 − 50.000 = **4.150.000 TL** (net kur 41,50).
- Senaryo 2, vadede spot 44,00: Opsiyon kullanılmaz, döviz spotta satılır. 4.400.000 − 50.000 = **4.350.000 TL** (net kur 43,50).

Opsiyon kur düştüğünde tabanı korur, kur yükseldiğinde kazancı bırakmaz; bedeli primdir. Forward ise kazancı da kaybı da 45,33 kurunda sabitler.

## 4. Swap ve kredi temerrüt swabı

**Faiz swapı**, tarafların aynı anapara üzerinden faiz ödemelerini (sabit ile değişken) değiştirmesidir; anapara el değiştirmez. Kaynağı **karşılaştırmalı üstünlüktür**.

**Çözümlü örnek 2:** A ve B şirketlerinin 100.000.000 TL'lik borçlanma maliyetleri:

| | Sabit | Değişken |
|---|---|---|
| A | %30 | TLREF + %2 |
| B | %34 | TLREF + %3 |
| Fark | 4 puan | 1 puan |

A değişken, B sabit faizli borç istemektedir. A her iki piyasada da ucuzdur, ama sabitte üstünlüğü daha büyüktür.

1. Swapsız toplam maliyet: A değişken (TLREF + 2) + B sabit (34) = TLREF + 36
2. Swaplı: A sabitten (30), B değişkenden (TLREF + 3) borçlanır: TLREF + 33
3. Toplam kazanç 3 puandır. Aracı banka 0,5 puan alır; kalan 2,5 puan eşit bölünür, her biri 1,25 puan kazanır.
4. A'nın net maliyeti TLREF + 0,75; B'nin net maliyeti %32,75 olur.
5. Yapı: A bankaya TLREF öder, bankadan %29,25 alır (30 + TLREF − 29,25 = TLREF + 0,75). B bankaya %29,75 öder, bankadan TLREF alır (TLREF + 3 + 29,75 − TLREF = 32,75).
6. Banka kazancı: 29,75 − 29,25 = 0,5 puan; 100.000.000 × %0,5 = **500.000 TL/yıl**.

**Kredi temerrüt swabı (CDS)**, kredi riskini transfer eden türevdir: koruma alıcısı nominal tutar üzerinden periyodik prim (baz puan) öder, borçlu temerrüde düşerse koruma satıcısı zararı karşılar. Örneğin 10.000.000 USD nominalli, 250 baz puanlık CDS'in yıllık primi 250.000 USD'dir; temerrütte geri kazanım oranı %40 ise satıcı 6.000.000 USD öder. **Derecelendirme notu** ile farkı: not, kuruluşun dönemsel görüşüdür ve seyrek değişir; CDS primi piyasanın anlık temerrüt riski fiyatıdır ve ülke riskinin göstergesi olarak her gün izlenir.

## 5. Kur riski ve korunma

Kur riski üç türlüdür:

- **İşlem riski:** Döviz cinsinden alacak ve borçların tahsil veya ödeme anındaki kur değişimi.
- **Çevrim (muhasebe) riski:** Yabancı para kalemlerin ve yurt dışı işletmenin tablolarının raporlama para birimine çevrilmesinden doğan değişim.
- **Ekonomik risk:** Kur değişiminin uzun vadeli rekabet gücünü ve nakit akışlarını etkilemesi.

Korunma yolları: forward ve futures, opsiyon, döviz swapı, **para piyasası korunması** ve doğal korunma (aynı döviz cinsinden alacak ile borcu eşleştirme, TL faturalama). Para piyasası korunmasında ihracatçı, vadedeki dövizin bugünkü değerini borçlanır, TL'ye çevirir ve TL faizle değerlendirir: 100.000 / 1,01 = 99.009,90 USD × 42 = 4.158.416 TL; 3 ay sonra × 1,09 = 4.532.673 TL. Sonuç forwardla aynıdır; faiz paritesi geçerliyse iki yol eşdeğerdir.

**Çözümlü örnek 3 (çapraz kur):** Banka kotasyonları EUR/USD 1,1000 – 1,1020 ve USD/JPY 150,00 – 150,40'tır (alış – satış).

- EUR/JPY alış (banka EUR alıp JPY verir): 1,1000 × 150,00 = **165,00**
- EUR/JPY satış (banka EUR satıp JPY alır): 1,1020 × 150,40 = **165,74**

Yen yerine euro ile tahsilat yapacak firma, euroyu bankaya alış kurundan satacağını hesaba katmalıdır.

> **Sık yapılan hata:** Çapraz kurda alış kuru ile satış kurunu çarpmak. Kural: banka her iki bacakta da kendisi için lehte olan kuru uygular; ortak para birimi (burada USD) iki kotasyonda farklı taraflarda olduğundan alış kurları kendi aralarında, satış kurları kendi aralarında çarpılır.

## 6. Menkul kıymetleştirme

**Menkul kıymetleştirme**, konut kredisi, taşıt kredisi veya ticari alacak gibi nakit akışı yaratan varlıkların bir havuzda toplanıp bu havuza dayalı menkul kıymet ihraç edilmesidir. Türkiye'de varlık finansman fonu tarafından **varlığa dayalı menkul kıymet (VDMK)**, konut kredilerine dayalı olarak **ipoteğe dayalı menkul kıymet (İDMK)** ihraç edilir. **Teminatlı menkul kıymette** ise varlıklar ihraççının bilançosunda kalır.

İşleyiş: kaynak kuruluş (banka) alacakları özel amaçlı yapıya devreder, yapı farklı risk dilimlerinde (kıdemli, ara, en alt) menkul kıymet çıkarır ve alacak tahsilatıyla yatırımcıya öder. Faydaları: kaynak kuruluşa likidite ve yeni kredi kapasitesi, kredi riskinin transferi, daha düşük finansman maliyeti, yatırımcıya farklı risk-getiri seçenekleri. Riskleri: havuz kalitesinin izlenememesi ve erken ödeme riski.

## 7. Uygulama notu

YMM incelemesinde türev sözleşmeleri banka teyitleri ve sözleşme metniyle karşılaştır: opsiyon primi, swap faiz farkı ve vadeli işlem uzlaşma tutarlarının hangi dönemde gelir veya gider yazıldığını kontrol et. Riskten korunma amacı iddia ediliyorsa korunan kalem ile türevin nominal ve vade uyumuna bak; uyumsuzluk spekülatif pozisyona işaret eder.

## Özet

- Amaç firma değerinin maksimizasyonudur; acenta maliyetleri izleme, bağlama ve kalıntı kayıptır; EVA = vergi sonrası faaliyet kârı − AOSM × sermaye.
- Para piyasası bir yıla kadar, sermaye piyasası bir yıldan uzun vadelidir; araçlar alacak, ortaklık ve karma diye ayrılır.
- Forward tezgâh üstü, vadeli işlem borsada ve günlük uzlaşmalıdır; forward kuru faiz paritesiyle bulunur.
- Opsiyon alıcısının zararı primle sınırlıdır; volatilite ve vade her iki primi artırır.
- Faiz swapı karşılaştırmalı üstünlükten doğan kazancı taraflar ve aracı arasında paylaştırır; CDS kredi riskini transfer eder.
- Kur riski işlem, çevrim ve ekonomik risktir; çapraz kurda alışlar ve satışlar kendi aralarında çarpılır.
- Menkul kıymetleştirme alacak havuzunu menkul kıymete dönüştürerek likidite ve risk transferi sağlar.
