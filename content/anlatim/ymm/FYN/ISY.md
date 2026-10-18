---
ders: FYN
konu: ISY
baslik: İşletme sermayesi yönetimi
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Nakit dönüşüm süresi"
    madde: "-"
  - mevzuat: "Genel bilgi — Nakit yönetimi (Baumol ve Miller-Orr)"
    madde: "-"
  - mevzuat: "Genel bilgi — Stok yönetimi (EOQ)"
    madde: "-"
  - mevzuat: "Genel bilgi — Alacak yönetimi ve kredi politikası"
    madde: "-"
  - mevzuat: "Genel bilgi — Kısa vadeli finansman"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Faaliyet döngüsü, nakit dönüşüm süresi ve işletme sermayesi gereksinimi hesabı
- Baumol ve Miller-Orr nakit modelleri, ters çözüm soruları
- Ekonomik sipariş miktarı (EOQ), sipariş noktası ve miktar indirimi kararı
- Kredi politikası değişikliğinin kâra etkisi ve nakit iskontosundan vazgeçmenin maliyeti
- Kısa vadeli finansman kaynakları ve finansman politikaları

## 1. Nakit dönüşüm süresi

**Brüt işletme sermayesi** dönen varlıkların toplamıdır; kısa vadeli yabancı kaynaklar düşülünce **net işletme sermayesi** bulunur. Dönen varlık arttıkça likidite artar, bağlanan fonun maliyeti nedeniyle kârlılık düşer.

**Faaliyet döngüsü** hammadde alımından hasılatın tahsiline kadar geçen süredir. **Nakit dönüşüm süresi (NDS)** nakdin çıkışından geri dönüşüne kadar geçen süredir:

- Stokta kalma süresi (SKS) = Ortalama stok / Satışların maliyeti × 365
- Alacak tahsil süresi (ATS) = Ortalama ticari alacak / Net satışlar × 365
- Borç ödeme süresi (BÖS) = Ortalama ticari borç / Satışların maliyeti (veya kredili alışlar) × 365
- Faaliyet döngüsü = SKS + ATS; NDS = SKS + ATS − BÖS

Her süre 365'in ilgili devir hızına bölünmesiyle de bulunur. Soruda 360 gün verilmişse onu kullan.

### Örnek 1: NDS ve işletme sermayesi gereksinimi

Net satışlar 7.300.000 TL, satışların maliyeti 5.475.000 TL; ortalama stok 900.000 TL, ticari alacak 1.200.000 TL, ticari borç 600.000 TL (365 gün).

1. SKS = 900.000 / 5.475.000 × 365 = 60 gün; ATS = 1.200.000 / 7.300.000 × 365 = 60 gün; BÖS = 600.000 / 5.475.000 × 365 = 40 gün.
2. Faaliyet döngüsü 120 gün; NDS = 120 − 40 = 80 gün.
3. Günlük nakit faaliyet gideri ≈ 5.475.000 / 365 = 15.000 TL; finanse edilmesi gereken işletme sermayesi ≈ 15.000 × 80 = 1.200.000 TL.

Ters çözümde bilinmeyen geri bulunur: gereksinim 1.500.000 TL ve NDS 100 gün verilmişse günlük gider 15.000 TL, yıllık gider 5.475.000 TL çıkar. Mevsimsel satışta gereksinim aylara göre hesaplanır; sürekli kısım uzun, geçici kısım kısa vadeli kaynakla karşılanır.

> **Sık yapılan hata:** ATS'de satışların maliyetini, SKS'de net satışları kullanmak. Alacak satış fiyatıyla, stok maliyetle izlenir.

Bazı perakendecilerde BÖS, SKS + ATS'yi aşar; NDS **negatif** olur ve faaliyet tedarikçi kaynağıyla finanse edilir.

## 2. Nakit yönetimi (Baumol ve Miller-Orr)

Nakit **işlem**, **ihtiyat** ve **spekülasyon** güdüsüyle tutulur. Fazla nakit fırsat maliyeti, eksik nakit likidite riski doğurur.

**Baumol modeli** nakit ihtiyacının sabit ve kesin olduğunu varsayar: C* = √(2TF / i). T yıllık nakit ihtiyacı, F menkul kıymeti nakde çevirmenin işlem başı maliyeti, i yıllık faizdir. Toplam maliyet = (T / C) × F + (C / 2) × i; optimumda iki kalem eşittir. Ters çözüm: T = C*² × i / (2F).

**Örnek 2:** T = 9.000.000 TL, F = 500 TL, i = %10. C* = √(2 × 9.000.000 × 500 / 0,10) = √90.000.000.000 = 300.000 TL. İşlem maliyeti 30 × 500 = 15.000 TL, fırsat maliyeti 150.000 × 0,10 = 15.000 TL, toplam 30.000 TL. T dört katına çıkarsa C* iki katına (600.000 TL) çıkar.

**Miller-Orr modeli** nakit akışı rastgele dalgalanan işletme içindir. Alt sınır L yönetimce belirlenir:

- Aralık = 3 × (3Fσ² / 4i)^(1/3); σ² günlük nakit akışı varyansı, i günlük faiz
- Dönüş noktası Z = L + Aralık / 3; üst sınır H = L + Aralık = 3Z − 2L
- Ortalama nakit = (4Z − L) / 3

Nakit H'ye ulaşınca H − Z kadar menkul kıymet alınır; L'ye düşünce Z − L kadar satılır.

**Örnek 3:** L = 100.000 TL, F = 600 TL, günlük σ = 6.000 TL (σ² = 36.000.000), günlük faiz %0,06.

1. 3Fσ² / 4i = 3 × 600 × 36.000.000 / (4 × 0,0006) = 27.000.000.000.000; küp kökü 30.000 TL.
2. Aralık = 90.000 TL; Z = 130.000 TL; H = 190.000 TL.
3. Ortalama nakit = (520.000 − 100.000) / 3 = 140.000 TL.

**Ters çözüm:** Aralık 90.000 TL verilip faiz soruluyorsa (90.000 / 3)³ = 3 × 600 × 36.000.000 / 4i eşitliğinden i = 64.800.000.000 / 108.000.000.000.000 = %0,06 bulunur.

## 3. Stok yönetimi (EOQ)

**Ekonomik sipariş miktarı (EOQ)**, sipariş ve taşıma maliyeti toplamını en aza indiren miktardır: EOQ = √(2DS / H). D yıllık talep, S sipariş başı maliyet, H birim başı yıllık taşıma maliyeti. Toplam maliyet = (D / Q) × S + (Q / 2) × H. **Sipariş noktası** = günlük kullanım × tedarik süresi (+ güvenlik stoku). Varsayımlar: talep ve tedarik süresi sabit, teslim anında, stoksuzluk yok.

**Örnek 4:** D = 40.000 adet, S = 800 TL, H = 16 TL, 250 iş günü, tedarik süresi 5 gün.

1. EOQ = √(2 × 40.000 × 800 / 16) = 2.000 adet; yılda 20 sipariş.
2. Sipariş maliyeti 16.000 TL = taşıma maliyeti 16.000 TL; toplam 32.000 TL.
3. Günlük kullanım 160 adet; sipariş noktası 160 × 5 = 800 adet.
4. Stok seviyesi: 2.000 adet geldikten sonra stok (2.000 − 800) / 160 = 7,5 iş günü sonra 800 adete iner; sipariş o gün verilir.

**Miktar indirimi:** Birim fiyat 50 TL'dir; 4.000 adet ve üzeri siparişte %2 indirim vardır (H sabit kabul). EOQ'da toplam = 40.000 × 50 + 32.000 = 2.032.000 TL. 4.000 adette sipariş maliyeti 10 × 800 = 8.000 TL, taşıma 2.000 × 16 = 32.000 TL, alış 40.000 × 49 = 1.960.000 TL; toplam 2.000.000 TL. İndirimli miktar seçilir.

> **Sınav ipucu:** Taşıma maliyeti birim fiyatın yüzdesi verilirse H = yüzde × birim fiyat olur ve indirimle H de değişir; her eşikte toplam maliyeti yeniden hesapla.

## 4. Alacak yönetimi ve kredi politikası

**Kredi politikası** kredi standartları, kredi süresi, nakit iskontosu ve tahsilat politikasından oluşur. Kredi değerliliği **5K (5C)** ile ölçülür: karakter, kapasite, sermaye, teminat, koşullar. Gevşetme satışı artırır ama alacağa bağlanan fonun maliyeti, şüpheli alacak ve tahsilat giderleri de artar.

**Örnek 5 (360 gün):** Satış 9.000.000 TL, ATS 40 gün, şüpheli alacak %1'dir. Yeni politikada satış 12.000.000 TL, ATS 60 gün, şüpheli alacak %2 olacak; tahsilat gideri 60.000 TL artacaktır. Değişken maliyet oranı %70, fon maliyeti %20, vergi %25'tir.

1. Ek katkı payı: 3.000.000 × 0,30 = 900.000 TL.
2. Ortalama alacak 1.000.000 TL'den 2.000.000 TL'ye çıkar; bağlanan fon (× 0,70) 700.000 TL'den 1.400.000 TL'ye; ek fon maliyeti 700.000 × 0,20 = 140.000 TL.
3. Şüpheli alacak 90.000 TL'den 240.000 TL'ye; artış 150.000 TL.
4. Vergi öncesi ek kâr 900.000 − 140.000 − 150.000 − 60.000 = 550.000 TL; vergi sonrası 412.500 TL. Politika kabul edilir.

**Nakit iskontosu:** "2/10, net 30" koşulunda iskontodan vazgeçen alıcı 20 gün ek kredi için %2 öder:

- Yaklaşık maliyet = 2 / 98 × 365 / 20 ≈ %37,24
- Bileşik maliyet = (1 + 2/98)^(365/20) − 1 ≈ %44,59

Banka kredisi bundan ucuzsa krediyle borçlanıp iskonto alınmalıdır.

> **Sık yapılan hata:** Paydada 98 yerine 100 ya da 20 yerine 30 gün kullanmak.

## 5. Kısa vadeli finansman

- **Ticari kredi**: İskonto kaçırılmadıkça maliyetsizdir.
- **Banka kredileri**: rotatif, spot, iskontolu kredi. Peşin faizli 1.000.000 TL'lik bir yıllık kredide %40 faiz kesilirse efektif faiz 400.000 / 600.000 ≈ %66,67'dir.
- **Faktoring**, **senet iskontosu** ve **finansman bonosu**.

**Uyumlu politikada** sürekli dönen varlıklar uzun, geçici olanlar kısa vadeli kaynakla; **atak politikada** sürekli ihtiyacın bir kısmı da kısa vadeli kaynakla (düşük maliyet, yüksek risk); **muhafazakâr politikada** geçici ihtiyacın bir kısmı da uzun vadeli kaynakla finanse edilir.

### Tasdik uygulama notu

Tam tasdikte YMM, ATS ve BÖS'ü önceki dönemler ve sektörle karşılaştırır. Ani uzama tahsil edilemeyen alacak, kayıt dışı tahsilat veya fiktif satış riskine işaret eder; alacak mutabakatı ve banka hareketleri incelenir. İlişkili kişilere tanınan olağan dışı vadeler örtülü kazanç yönünden değerlendirilir; faktoring ve iskontoda faiz-komisyon ayrımı belgeyle kontrol edilir.

## Özet

- NDS = SKS + ATS − BÖS; işletme sermayesi gereksinimi ≈ günlük nakit gider × NDS.
- Baumol: C* = √(2TF/i); optimumda işlem ve fırsat maliyetleri eşittir.
- Miller-Orr: Aralık = 3(3Fσ²/4i)^(1/3), Z = L + Aralık/3, H = 3Z − 2L, ortalama nakit = (4Z − L)/3.
- EOQ = √(2DS/H); sipariş noktası = günlük kullanım × tedarik süresi; miktar indiriminde alış bedeli dahil toplam maliyet karşılaştırılır.
- Kredi politikası, ek katkı payı ek fon maliyeti, şüpheli alacak ve tahsilat giderini aşıyorsa kabul edilir.
- İskontodan vazgeçmenin yaklaşık maliyeti: İskonto / (100 − İskonto) × 365 / (Kredi süresi − İskonto süresi).
- Finansman politikaları: uyumlu, atak, muhafazakâr.
