---
ders: "TAB"
konu: "DVR"
baslik: "Devir hızları ve süreleri"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar: []
---
## Bu konuda neler öğreneceksin

- Devir hızı ile devir süresi arasındaki ilişkiyi ve sınavın gün sayısı kurallarını
- Stok türlerine göre (ilk madde, yarı mamul, mamul, ticari mal) doğru pay ve paydayı seçmeyi
- Alacak tahsil süresini ve borç ödeme süresini hesaplamayı
- Faaliyet dönemi ve nakit dönüşüm süresini bulmayı
- Hedef süreden veya verilen orandan geriye doğru tutar (dönem sonu stok, alacak, satış) hesaplamayı

## 1. Temel mantık

**Devir hızı**, bir varlık veya borç kaleminin dönem içinde kaç kez "yenilendiğini" gösterir. Paya dönem içindeki **akış** (satış, maliyet, tüketim), paydaya dönem boyunca bağlanan **ortalama bakiye** yazılır:

- Devir hızı = Dönem içi akış / Ortalama bakiye
- Ortalama bakiye = (Dönem başı + Dönem sonu) / 2
- Devir süresi (gün) = Dönem gün sayısı / Devir hızı = Ortalama bakiye × Gün sayısı / Akış

Sınavda kabul edilen gün sayıları: **yıl 360, ay 30, çeyrek 90, altı ay 180 gün**. Soruda yalnız dönem sonu bakiyesi verilmişse ya da "dönem sonu tutarı esas alınacaktır" denmişse ortalama alınmaz.

Devir hızı ile süre ters orantılıdır: hız arttıkça süre kısalır. Hızın artması genellikle kalemin daha çabuk paraya dönüştüğünü, yani likiditenin iyileştiğini gösterir.

> **Sık yapılan hata:** Altı aylık verilerle hesaplanan devir hızından süreyi 360 güne bölerek bulmak. Akış altı aylıksa süre 180 gün üzerinden bulunur. Örnek: 6 aylık satışların maliyeti 300.000 ₺, ortalama stok 100.000 ₺ ise hız 3, süre 180 / 3 = **60 gün**dür (360 / 3 = 120 değil).

## 2. Stok devir hızları

Pay ile payda **aynı ölçü temelinde** olmalıdır. Stoklar bilançoda maliyetle gösterildiği için pay da maliyet olur; satış hasılatı stok devir hızında kullanılmaz.

| Stok türü | Pay (akış) | Payda |
|---|---|---|
| Ticari mal (veya toplam stok) | Satılan ticari mallar maliyeti / satışların maliyeti | Ortalama ticari mal (stok) |
| İlk madde ve malzeme | Kullanılan (üretime verilen) ilk madde ve malzeme maliyeti | Ortalama ilk madde ve malzeme stoku |
| Yarı mamul | Tamamlanan üretim maliyeti (üretilen mamul maliyeti) | Ortalama yarı mamul stoku |
| Mamul | Satılan mamul maliyeti | Ortalama mamul stoku |

Bu akışlar soruda doğrudan verilmeyebilir; maliyet akışından türetilir:

- Kullanılan ilk madde = Dönem başı ilk madde + Alışlar − Dönem sonu ilk madde
- Dönemin üretim giderleri = Direkt ilk madde + Direkt işçilik + Genel üretim giderleri
- Üretilen mamul maliyeti (MSUGT'deki "üretim maliyeti") = Dönem başı yarı mamul + Dönemin üretim giderleri − Dönem sonu yarı mamul
- Satılan mamul maliyeti = Dönem başı mamul + Üretilen mamul maliyeti − Dönem sonu mamul

### Çözümlü örnek: üretim işletmesi

| Kalem | Dönem başı | Dönem sonu |
|---|---|---|
| İlk madde ve malzeme | 80.000 | 120.000 |
| Yarı mamul | 100.000 | 140.000 |
| Mamul | 150.000 | 90.000 |

Dönem içinde 440.000 ₺ ilk madde alınmış; direkt işçilik 70.000 ₺, genel üretim gideri 50.000 ₺'dir.

1. Kullanılan ilk madde: 80.000 + 440.000 − 120.000 = 400.000 ₺. Ortalama ilk madde (80.000 + 120.000) / 2 = 100.000. Hız 400.000 / 100.000 = **4**; süre 360 / 4 = **90 gün**.
2. Dönemin üretim giderleri: 400.000 + 70.000 + 50.000 = 520.000 ₺. Üretilen mamul maliyeti: 100.000 + 520.000 − 140.000 = 480.000 ₺. Ortalama yarı mamul 120.000; hız 480.000 / 120.000 = **4**; süre **90 gün**.
3. Satılan mamul maliyeti: 150.000 + 480.000 − 90.000 = 540.000 ₺. Ortalama mamul 120.000; hız 540.000 / 120.000 = **4,5**; süre 360 / 4,5 = **80 gün**.

Yorum: hammadde ortalama 90 gün depoda bekliyor, üretim süreci ortalama 90 gün sürüyor, bitmiş ürün ortalama 80 günde satılıyor.

> **Sınav ipucu:** Yarı mamul devir hızında pay "dönemin üretim giderleri" (520.000) değil, **tamamlanıp mamule aktarılan** üretim maliyetidir (480.000). Şıklarda 520.000 / 120.000 ≈ 4,33 genellikle çeldiricidir. Soru kökü formülü tanımlıyorsa daima kökteki tanımı kullan.

## 3. Alacak tahsil süresi

**Alacak devir hızı** = Net satışlar (kredili satışlar verilmişse kredili satışlar) / Ortalama ticari alacaklar

**Alacak tahsil süresi** = 360 / Alacak devir hızı = Ortalama ticari alacaklar × 360 / Net satışlar

Ticari alacaklar, 120 Alıcılar ve 121 Alacak Senetleri toplamından düzenleyici hesaplar (122 Reeskont, 129 Şüpheli Alacak Karşılığı) düşülerek bulunan net tutardır. Pay olarak satışların maliyeti değil **net satışlar** kullanılır; çünkü alacak, satış fiyatıyla doğar.

Örnek: Net satışlar 900.000 ₺; ticari alacaklar dönem başı 90.000, dönem sonu 110.000 ₺. Ortalama 100.000; hız 900.000 / 100.000 = **9**; tahsil süresi 360 / 9 = **40 gün**.

Yorum: İşletmenin müşterilerine tanıdığı vade 30 gün ise 40 günlük tahsil süresi, alacakların ortalama 10 gün geciktiğini gösterir. Tahsil süresinin uzaması işletme sermayesi ihtiyacını ve şüpheli alacak riskini artırır.

## 4. Borç ödeme süresi

**Ticari borç devir hızı** = Satışların maliyeti / Ortalama ticari borçlar

**Borç ödeme süresi** = 360 / Borç devir hızı = Ortalama ticari borçlar × 360 / Satışların maliyeti

Teoride en doğru pay kredili alışlardır; ancak finansal tablolarda alış tutarı genellikle yer almadığından sınavda aksi belirtilmedikçe **satışların maliyeti** kullanılır. Ticari borçlar 320 Satıcılar ve 321 Borç Senetleri toplamından 322 Borç Senetleri Reeskontu düşülerek alınır.

Örnek: Satışların maliyeti 540.000 ₺; ticari borçlar dönem başı 50.000, dönem sonu 70.000 ₺. Ortalama 60.000; hız 540.000 / 60.000 = **9**; ödeme süresi **40 gün**.

> **Sık yapılan hata:** Borç ödeme süresinde net satışları kullanmak. Alacak süresi **net satışlarla**, stok ve borç süreleri **satışların maliyetiyle** hesaplanır; şıklardaki yanlış cevapların çoğu bu karışıklıktan üretilir.

## 5. Faaliyet dönemi ve nakit dönüşüm süresi

- **Faaliyet dönemi (işletme devresi)** = Stok devir süresi + Alacak tahsil süresi. Malın alınmasından satış bedelinin tahsiline kadar geçen süredir.
- **Nakit dönüşüm süresi** = Stok devir süresi + Alacak tahsil süresi − Borç ödeme süresi. İşletmenin kendi kaynağıyla finanse etmek zorunda kaldığı süredir.

**Çözümlü örnek (ticari işletme):** Net satışlar 1.440.000 ₺, satışların maliyeti 960.000 ₺.

| Kalem | Dönem başı | Dönem sonu | Ortalama |
|---|---|---|---|
| Ticari mal | 140.000 | 180.000 | 160.000 |
| Ticari alacaklar | 100.000 | 140.000 | 120.000 |
| Ticari borçlar | 70.000 | 90.000 | 80.000 |

1. Stok devir hızı 960.000 / 160.000 = 6 → süre **60 gün**
2. Alacak devir hızı 1.440.000 / 120.000 = 12 → süre **30 gün**
3. Borç devir hızı 960.000 / 80.000 = 12 → süre **30 gün**
4. Faaliyet dönemi 60 + 30 = **90 gün**; nakit dönüşüm süresi 90 − 30 = **60 gün**

Nakit dönüşüm süresinin kısalması iyidir; işletme tedarikçi kredisini daha etkin kullanıyor ya da stok ve alacaklarını daha hızlı paraya çeviriyor demektir.

## 6. Hedef süreden ve orandan geri hesap

Geri hesapta formül tersine çevrilir. Adımlar her zaman aynıdır:

1. Hedef süreden gerekli hızı bul: Hız = Gün sayısı / Hedef süre
2. Gerekli ortalama bakiyeyi bul: Ortalama = Akış / Hız
3. Dönem sonu isteniyorsa: Dönem sonu = 2 × Ortalama − Dönem başı

**Örnek 1 (stok):** Yukarıdaki işletme, satışların maliyeti değişmeden stok süresini 45 güne indirmek istiyor; dönem başı stok 140.000 ₺.

- Gerekli hız 360 / 45 = 8
- Gerekli ortalama stok 960.000 / 8 = 120.000 ₺
- Gerekli dönem sonu stok 2 × 120.000 − 140.000 = **100.000 ₺**

**Örnek 2 (alacak):** Hedef tahsil süresi 24 gün, net satışlar 1.440.000 ₺, dönem başı alacak 100.000 ₺.

- Gerekli hız 360 / 24 = 15; ortalama alacak 1.440.000 / 15 = 96.000 ₺
- Dönem sonu alacak 2 × 96.000 − 100.000 = **92.000 ₺**

**Örnek 3 (oranlardan satış bulma):** Stok devir hızı 5, ortalama stok 300.000 ₺, brüt satış kârı oranı %25, alacak tahsil süresi 36 gündür.

- Satışların maliyeti = 5 × 300.000 = 1.500.000 ₺
- Net satışlar = SMM / (1 − brüt kâr oranı) = 1.500.000 / 0,75 = 2.000.000 ₺
- Ortalama ticari alacak = 2.000.000 × 36 / 360 = **200.000 ₺**

> **Sınav ipucu:** Brüt kâr oranı satışlar üzerinden tanımlıdır. Net satışı bulmak için SMM'yi (1 − oran) ile böl; SMM'yi 1,25 ile çarpmak (1.875.000) yanlış sonuç verir.

Geri hesapta akışın (satış veya maliyet) sabit kaldığı varsayılır. Satış hacmi artarken aynı süreyi korumak için ortalama stok ve alacak da aynı oranda artmalıdır.

## 7. Yorumlama ölçütleri

- Yüksek stok devir hızı stokların çabuk satıldığını gösterir; aşırı yüksekse stoksuz kalma ve satış kaçırma riski vardır.
- Düşük stok devir hızı atıl, eskimiş veya fazla stok işaretidir; değer düşüklüğü riski taşır.
- Alacak tahsil süresi işletmenin vade politikasıyla karşılaştırılır; sektör ortalaması ve önceki yıllar da dikkate alınır.
- Alacak tahsil süresinin borç ödeme süresinden belirgin uzun olması, işletmenin tedarikçilerine ödeme yaparken müşterilerinden henüz tahsilat yapamadığını, dolayısıyla ek finansman ihtiyacını gösterir.

## Özet

- Devir hızı = Akış / Ortalama bakiye; süre = Gün sayısı / Hız. Yıl 360, ay 30, çeyrek 90, altı ay 180 gün.
- Ortalama bakiye (dönem başı + dönem sonu) / 2'dir; yalnız bir bakiye verilmişse o kullanılır.
- İlk madde: kullanılan ilk madde; yarı mamul: tamamlanan üretim maliyeti; mamul: satılan mamul maliyeti; ticari mal: satılan ticari mal maliyeti.
- Alacak tahsil süresi net satışlarla; stok ve borç ödeme süreleri satışların maliyetiyle hesaplanır.
- Faaliyet dönemi = stok süresi + tahsil süresi; nakit dönüşüm süresi = faaliyet dönemi − borç ödeme süresi.
- Geri hesap: hedef süre → gerekli hız → gerekli ortalama → dönem sonu = 2 × ortalama − dönem başı.
- Brüt kâr oranından satış bulurken SMM / (1 − oran) formülünü kullan.
