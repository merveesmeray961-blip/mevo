---
ders: FYN
konu: ISY
baslik: İşletme sermayesi yönetimi
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Nakit dönüşüm süresi"
    madde: "-"
  - mevzuat: "Genel bilgi — Nakit ve stok yönetimi (EOQ)"
    madde: "-"
  - mevzuat: "Genel bilgi — Alacak yönetimi ve kredi politikası"
    madde: "-"
  - mevzuat: "Genel bilgi — Kısa vadeli finansman"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Faaliyet döngüsü ve nakit dönüşüm süresi hesabı, devir hızlarıyla bağlantısı
- Nakit tutma güdüleri ve Baumol nakit modeli
- Ekonomik sipariş miktarı (EOQ), toplam stok maliyeti ve yeniden sipariş noktası
- Alacak yönetimi ve kredi politikası, nakit iskontosundan vazgeçmenin maliyeti
- Kısa vadeli finansman kaynakları ve işletme sermayesi finansman politikaları

## 1. Nakit dönüşüm süresi

**İşletme sermayesi**, dönen varlıkların toplamıdır (brüt işletme sermayesi); dönen varlıklardan kısa vadeli yabancı kaynaklar düşülünce **net işletme sermayesi** bulunur. **İşletme sermayesi yönetimi**, bu kalemlerin düzeyini likidite ile kârlılık arasında denge kuracak biçimde belirlemektir. Dönen varlık arttıkça likidite artar, ancak bağlanan fonun maliyeti nedeniyle kârlılık düşer.

**Faaliyet döngüsü**, hammaddenin alınmasından satış hasılatının tahsil edilmesine kadar geçen süredir. **Nakit dönüşüm süresi (NDS)** ise nakdin işletmeden çıkışından geri dönüşüne kadar geçen süredir; tedarikçilere yapılan ödemenin ertelendiği süre faaliyet döngüsünden düşülür:

- Stokta kalma süresi (SKS) = Ortalama stok / Satışların maliyeti × 365
- Alacak tahsil süresi (ATS) = Ortalama ticari alacak / Net satışlar × 365
- Borç ödeme süresi (BÖS) = Ortalama ticari borç / Satışların maliyeti × 365
- Faaliyet döngüsü = SKS + ATS
- NDS = SKS + ATS − BÖS

Bu anlatımda yıl **365 gün** alınmıştır; bazı kaynaklar 360 gün kullanır, sınavda soruda hangi gün sayısı verilmişse onu kullan. BÖS'te payda olarak bazı kaynaklar satışların maliyeti yerine yıllık **kredili alışları** kullanır; alış tutarı verilmişse alışları esas al. Her süre, 365'in ilgili devir hızına bölünmesiyle de bulunur (ör. SKS = 365 / Stok devir hızı).

### Örnek: Nakit dönüşüm süresi

Bir işletmenin yıllık net satışları 7.300.000 TL, satışların maliyeti 5.475.000 TL; ortalama stok 900.000 TL, ortalama ticari alacak 1.200.000 TL, ortalama ticari borç 600.000 TL'dir (yıl 365 gün).

1. SKS = 900.000 / 5.475.000 × 365 = 60 gün.
2. ATS = 1.200.000 / 7.300.000 × 365 = 60 gün.
3. BÖS = 600.000 / 5.475.000 × 365 = 40 gün.
4. Faaliyet döngüsü = 60 + 60 = 120 gün.
5. NDS = 120 − 40 = 80 gün.

Aynı veriyle 360 gün kullanılsaydı NDS yaklaşık 78,9 gün çıkardı; bu nedenle gün esası sonucu değiştirir.

> **Sık yapılan hata:** Alacak tahsil süresinde satışların maliyetini, stokta kalma süresinde net satışları kullanmak. Alacaklar satış fiyatıyla, stoklar maliyetle izlendiği için paydalar farklıdır.

NDS'nin kısalması, işletmenin dışarıdan finanse etmesi gereken işletme sermayesi ihtiyacını azaltır. İstisna olarak bazı perakende işletmelerde BÖS, SKS ile ATS toplamını aşar; bu durumda NDS **negatif** olur ve işletme faaliyetlerini kısmen tedarikçi kaynağıyla finanse eder.

## 2. Nakit ve stok yönetimi (EOQ)

### Nakit yönetimi

İşletmeler nakdi üç güdüyle tutar: **işlem güdüsü** (günlük ödemeler), **ihtiyat güdüsü** (beklenmeyen ödemeler) ve **spekülasyon güdüsü** (fırsatları değerlendirme). Nakit faiz getirmediği için fazlası fırsat maliyeti doğurur, eksikliği ise likidite riskine yol açar.

**Baumol modeli**, EOQ mantığını nakde uygular: Optimal nakit çekme tutarı C = √(2 × T × F / i). Burada T yıllık nakit ihtiyacı, F menkul kıymetin nakde çevrilmesinin işlem başına sabit maliyeti, i ise menkul kıymet faiz oranıdır (nakit tutmanın fırsat maliyeti). Model nakit ihtiyacının yıl boyunca sabit ve kesin olduğunu varsayar; nakit akışları dalgalıysa alt ve üst sınır kullanan Miller-Orr modeli tercih edilir.

### Stok yönetimi

**Ekonomik sipariş miktarı (EOQ)**, sipariş maliyeti ile taşıma maliyetinin toplamını en aza indiren sipariş büyüklüğüdür:

- EOQ = √(2 × D × S / H)
- Toplam stok maliyeti = (D / Q) × S + (Q / 2) × H
- Yeniden sipariş noktası = Günlük kullanım × Tedarik süresi (+ güvenlik stoku)

D yıllık talep (adet), S sipariş başına sabit maliyet, H birim başına yıllık taşıma maliyetidir. Bu anlatımda EOQ'nun klasik varsayımları kullanılır: talep yıl boyunca sabit ve bilinir, tedarik süresi sabittir, sipariş tek seferde ve anında teslim edilir, miktar iskontosu yoktur, stoksuzluğa izin verilmez. EOQ noktasında yıllık sipariş maliyeti yıllık taşıma maliyetine eşittir.

### Örnek: EOQ ve yeniden sipariş noktası

Yıllık talep 40.000 adet, sipariş başına maliyet 800 TL, birim başına yıllık taşıma maliyeti 16 TL'dir. İşletme yılda 250 iş günü çalışır, tedarik süresi 5 gündür, güvenlik stoku tutulmaz.

1. EOQ = √(2 × 40.000 × 800 / 16) = √4.000.000 = 2.000 adet.
2. Yıllık sipariş sayısı = 40.000 / 2.000 = 20.
3. Sipariş maliyeti = 20 × 800 = 16.000 TL; taşıma maliyeti = (2.000 / 2) × 16 = 16.000 TL.
4. Toplam maliyet = 32.000 TL. Kontrol: Q = 1.000 ya da Q = 4.000 alınırsa toplam maliyet 40.000 TL'ye çıkar.
5. Günlük kullanım = 40.000 / 250 = 160 adet; yeniden sipariş noktası = 160 × 5 = 800 adet.

> **Sınav ipucu:** Taşıma maliyeti birim fiyatın yüzdesi olarak verilirse önce H'yi bul (H = yüzde × birim fiyat). EOQ formülündeki D ve H aynı döneme (yıllık) ait olmalıdır.

İstisna: Tedarikçi belirli miktarın üzerindeki siparişe iskonto veriyorsa EOQ tek başına yeterli değildir; iskonto eşiklerindeki toplam maliyet (satın alma bedeli dâhil) ayrıca karşılaştırılır.

## 3. Alacak yönetimi ve kredi politikası

**Kredi politikası**; kredi standartları, kredi süresi, nakit iskontosu ve tahsilat politikasından oluşur. Müşterinin kredi değerliliği geleneksel olarak **5K (5C)** ölçütüyle değerlendirilir: karakter, kapasite, sermaye, teminat ve koşullar. Kredi koşullarını gevşetmek satışları artırır; ancak alacağa bağlanan fonun maliyeti, şüpheli alacak kaybı ve tahsilat giderleri de artar. Politika değişikliği, ek katkı payı bu ek maliyetleri aşıyorsa kabul edilir.

"2/10, net 30" koşulu, faturanın 10 gün içinde ödenmesi hâlinde %2 iskonto yapılacağını, aksi hâlde tutarın 30. günde ödeneceğini gösterir. İskontodan vazgeçen alıcı, fazladan 20 gün kredi kullanmanın bedelini öder:

- Yaklaşık yıllık maliyet = İskonto % / (100 − İskonto %) × 365 / (Kredi süresi − İskonto süresi)
- 2/10, net 30 için: 2 / 98 × 365 / 20 ≈ %37,24
- Bileşik (efektif) maliyet = (1 + 2/98)^(365/20) − 1 ≈ %44,59

Bu hesapta da 365 gün esası kullanılmıştır. Banka kredisinin maliyeti bu orandan düşükse alıcı krediyle borçlanıp iskontodan yararlanmalıdır.

> **Sık yapılan hata:** Paydada 98 yerine 100 kullanmak ya da gün farkı yerine toplam kredi süresini (30) kullanmak. Doğru hesapta payda, iskonto sonrası ödenen tutar (98) ve ek kredi süresi (30 − 10 = 20 gün) olur.

## 4. Kısa vadeli finansman

Kısa vadeli finansmanın başlıca kaynakları şunlardır:

- **Ticari kredi**: Tedarikçinin tanıdığı vade; faaliyetle kendiliğinden doğar, iskonto kaçırılmadıkça maliyetsizdir.
- **Banka kredileri**: Rotatif, spot ve iskontolu krediler.
- **Faktoring**: Alacakların bir faktoring şirketine devriyle peşin finansman sağlanması.
- **Senet iskontosu** (vadeli senedin vadesinden önce bankaya kırdırılması) ve bir para piyasası aracı olan **finansman bonosu** ihracı.

Faizin peşin kesildiği (iskontolu) kredide efektif faiz, faizin kullanılabilir tutara bölünmesiyle bulunur: 1.000.000 TL'lik bir yıllık kredide %40 peşin faiz kesilirse efektif faiz = 400.000 / 600.000 ≈ %66,67'dir.

Dönen varlıkların finansmanında üç politika vardır. **Uyumlu (vade eşleştirme) politikada** sürekli dönen varlıklar uzun vadeli, geçici dönen varlıklar kısa vadeli kaynakla finanse edilir. **Atak politikada** sürekli ihtiyacın bir bölümü de kısa vadeli kaynakla karşılanır; maliyet düşer ama yenileme riski artar. **Muhafazakâr politikada** geçici ihtiyacın bir bölümü de uzun vadeli kaynakla karşılanır; risk azalır ama maliyet artar.

### Tasdik uygulama notu

Tam tasdikte YMM, alacak tahsil ve borç ödeme sürelerini önceki dönemlerle ve sektörle karşılaştırarak analitik inceleme yapar. Süredeki ani uzama; tahsil edilemeyen alacak, kayıt dışı tahsilat ya da fiktif satış riskine işaret edebilir ve alacak mutabakatlarının, cari hesap ekstrelerinin ve banka hareketlerinin ayrıntılı incelenmesini gerektirir. Ortaklara veya ilişkili kişilere tanınan alışılmışın dışında uzun vadeler, ilişkili kişi işlemlerine ilişkin vergi mevzuatı yönünden ayrıca değerlendirilir. Faktoring ve iskonto işlemlerinde sözleşme, dekont ve faiz-komisyon ayrımı belgeyle kontrol edilir; stoklarda sayım tutanakları ve stok devir hızı birlikte değerlendirilir.

## Özet

- NDS = Stokta kalma süresi + Alacak tahsil süresi − Borç ödeme süresi; faaliyet döngüsünden BÖS düşülür.
- Gün esası (365 veya 360) ve BÖS paydası (satışların maliyeti veya alışlar) soruda belirtilene göre seçilir.
- EOQ = √(2DS/H); bu noktada sipariş maliyeti taşıma maliyetine eşittir. Yeniden sipariş noktası = günlük kullanım × tedarik süresi.
- Baumol modeli optimal nakit çekme tutarını C = √(2TF/i) ile bulur.
- İskontodan vazgeçmenin yaklaşık maliyeti: İskonto / (100 − İskonto) × 365 / (Kredi süresi − İskonto süresi).
- Peşin faizli kredide efektif faiz = Faiz / (Anapara − Faiz).
- Finansman politikaları: uyumlu, atak (düşük maliyet, yüksek risk), muhafazakâr (yüksek maliyet, düşük risk).
