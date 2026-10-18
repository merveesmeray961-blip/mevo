---
ders: "MAL"
konu: "TBL"
baslik: "Maliyet tabloları ve geri hesaplar"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "1 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği, Ek 4 (Mali Tabloların Düzenlenmesi)"
    madde: "Satışların Maliyeti Tablosu"
    alinti: "işletmenin dönem içindeki stok hareketleri ile satılan mamül, ilk madde ve malzeme ile ticari mal gibi maddelerin"
  - mevzuat: "1 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği, Ek 4 (Mali Tabloların Düzenlenmesi)"
    madde: "Satışların Maliyeti Tablosu, E - Mamül Stoklarında Değişim"
    alinti: "Direkt ilk madde ve malzeme, direkt işçilik, genel üretim giderleri ve yarı mamül kullanım tutarlarının toplamı üretim maliyetini verir."
  - mevzuat: "1 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği, Ek 4 (Mali Tabloların Düzenlenmesi)"
    madde: "Satışların Maliyeti Tablosu, E - Mamül Stoklarında Değişim"
    alinti: "mamül stok farkının üretim maliyetine eklenmesiyle satılan mamülün maliyetine ulaşılır"
  - mevzuat: "1 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği, Ek 4 (Mali Tabloların Düzenlenmesi)"
    madde: "Satışların Maliyeti Tablosu, A - Direkt İlk Madde ve Malzeme Giderleri"
    alinti: "Üretimde kullanılmayan ve satılan ilk madde ve malzemenin maliyeti, tablonun ticari faaliyete ilişkin bölümünde dikkate alınır."
  - mevzuat: "1 Sıra No.lu Muhasebe Sistemi Uygulama Genel Tebliği, Ek 4 (Mali Tabloların Düzenlenmesi)"
    madde: "Satışların Maliyeti Tablosu"
    alinti: "İşletmenin satılan mamul maliyeti, satılan ticari mal maliyeti ve satılan hizmet maliyetinin toplamı"
  - mevzuat: "TMS 2 Stoklar"
    madde: "paragraf 16 (c)"
    alinti: "Stokların mevcut konumuna ve durumuna getirilmesinde katkısı olmayan genel yönetim giderleri"
---
## Bu konuda neler öğreneceksin

- Satışların maliyeti tablosunun (MSUGT Ek 4) bölümlerini ve tutarların bir aşamadan diğerine nasıl aktığını
- **İlk madde ve malzeme giderini** stok hareketinden bulmayı; direkt ve endirekt kullanımı ayırmayı
- **Dönemin üretim giderlerini**, **üretim maliyetini** ve **satılan mamul maliyetini** birbirinden ayırmayı
- **Satılan ticari mal maliyetini** hesaplamayı ve satışların maliyeti toplamına ulaşmayı
- Eksik bir kalemi tablonun sonundan başına doğru **geri hesaplamayı** (brüt kâr bilgisinden alış tutarına kadar)
- Birden fazla dönemi kapsayan **zincirleme tabloları** kurmayı

## 1. Satışların maliyeti tablosu ve stok akışı

**Satışların maliyeti tablosu**, gelir tablosundaki "Satışların Maliyeti" satırını ayrıntılandıran ek mali tablodur. MSUGT Ek 4'e göre tablo, işletmenin dönem içindeki stok hareketleri ile satılan mamul, ilk madde ve malzeme, ticari mal ve hizmetlerin maliyetini gösterir. Üretim işletmesinde maliyet, stok hesapları arasında şu sırayla akar:

1. **150 İlk Madde ve Malzeme**: satın alınan malzeme stoğa girer, üretime verilince çıkar.
2. **151 Yarı Mamuller - Üretim**: direkt ilk madde, direkt işçilik ve GÜG burada toplanır; tamamlanan kısım çıkar.
3. **152 Mamuller**: tamamlanan ürün stoğa girer, satılınca çıkar.
4. **620 Satılan Mamuller Maliyeti**: satılan mamulün maliyeti gider olur.

Her stok hesabı için aynı denge geçerlidir: **Dönem başı stok + Girişler − Dönem sonu stok = Çıkışlar**. Maliyet tablosu sorularının tamamı bu dengenin art arda uygulanmasıdır.

| Bölüm | Hesaplama |
|---|---|
| A. Direkt ilk madde ve malzeme | DB ilk madde + Net alışlar − DS ilk madde − Endirekt malzeme kullanımı (− satılan ilk madde) |
| B. Direkt işçilik | Soruda verilen tutar |
| C. Genel üretim giderleri | Endirekt malzeme + endirekt işçilik + fabrika amortismanı, enerji, bakım vb. |
| Dönemin üretim giderleri | A + B + C |
| D. Yarı mamul kullanımı | + DB yarı mamul − DS yarı mamul |
| Üretim maliyeti (üretilen mamul maliyeti) | A + B + C + D |
| E. Mamul stoklarında değişim | + DB mamul − DS mamul |
| Satılan mamul maliyeti | Üretim maliyeti + E |
| Satılan ticari mal maliyeti | DB ticari mal + Net alışlar − DS ticari mal |
| Satılan hizmet maliyeti | 622 tutarı |
| **Satışların maliyeti** | SMM + STMM + SHM |

> **Sık yapılan hata:** "Üretim maliyeti" ile "dönemin üretim giderleri"ni aynı sanmak. MSUGT'ye göre üretim maliyeti, A + B + C toplamına yarı mamul stok değişiminin de eklenmesiyle bulunur. A + B + C toplamına ders kitaplarında "dönemin üretim (imalat) giderleri" denir. Şıklarda iki tutar da bulunur; soru kökündeki terime dikkat et.

## 2. İlk madde ve malzeme gideri

**İlk madde ve malzeme kullanımı**, dönem içinde ambardan çekilen malzemenin maliyetidir; satın alınan tutarla aynı değildir.

- **Net alışlar** = Brüt alışlar + alışla ilgili nakliye, sigorta gibi giderler − alış iadeleri − alış iskontoları
- **Toplam kullanım** = DB ilk madde stoku + Net alışlar − DS ilk madde stoku
- **Direkt ilk madde gideri** = Toplam kullanım − Endirekt (yardımcı) malzeme kullanımı − Üretimde kullanılmayıp satılan ilk madde

Endirekt malzeme (yağlama yağı, temizlik malzemesi, küçük bağlantı elemanları) kaybolmaz, **GÜG içine** girer. Üretimde kullanılmayıp satılan ilk maddenin maliyeti ise MSUGT Ek 4'e göre tablonun **ticari faaliyete ilişkin bölümünde** dikkate alınır; direkt ilk madde giderine girmez.

Stok hareketinin yönünü şöyle yorumla: ilk madde stoku dönem içinde **artmışsa** kullanım alıştan **az**, **azalmışsa** kullanım alıştan **fazladır**.

## 3. Üretim maliyeti ve satılan mamul maliyeti

**Yarı mamul**, ilk madde, işçilik ve GÜG'den pay almış fakat henüz tamamlanmamış üründür. Dönem başındaki yarı mamul bu dönemde tamamlanacağı için **eklenir**, dönem sonunda hâlâ üretimde olan yarı mamul **çıkarılır**:

**Üretim maliyeti = Dönemin üretim giderleri + DB yarı mamul − DS yarı mamul**

Tamamlanan ürünler 152'ye girer. Satılan mamul maliyeti, mamul stok farkının üretim maliyetine eklenmesiyle bulunur. Mamul stok farkı "dönem başı eksi dönem sonu" olarak tanımlandığı için:

**Satılan mamul maliyeti = Üretim maliyeti + DB mamul − DS mamul**

Mamul stoku artarsa (DS büyükse) fark negatiftir ve SMM, üretim maliyetinden küçük çıkar. Stok azalırsa önceki dönemde üretilen ürünler de satılmış demektir; SMM üretim maliyetinden büyük olur.

## 4. Satılan ticari mal maliyeti

**Ticari mal**, değişikliğe uğratılmadan satılmak üzere alınan maldır (153). Üretim aşaması olmadığı için işçilik ve GÜG burada yer almaz:

**Satılan ticari mal maliyeti = DB ticari mal + Net alışlar − DS ticari mal**

Satılan ticari malın maliyeti 153'ün alacağına, 621'in borcuna kaydedilir. Üretim yapan bir işletme ayrıca ticari mal da satıyorsa iki maliyet ayrı hesaplanıp satışların maliyeti satırında toplanır.

> **Sınav ipucu:** SMMM sorularında genel yönetim, pazarlama-satış-dağıtım ve finansman giderleri sıklıkla **çeldirici** olarak verilir. Bunlar dönem gideridir (630, 631, 632, 66 grubu); TMS 2'ye göre stokların mevcut konumuna ve durumuna getirilmesine katkısı olmayan genel yönetim giderleri ve satış maliyetleri stok maliyetine girmez. Soru aksini açıkça söylemedikçe bu tutarları tabloya katma. Kökteki "KDV dikkate alınmayacaktır" ifadesi de alış tutarlarını KDV'siz kullanacağın anlamına gelir.

## 5. Çözümlü kapsamlı örnek

KDV dikkate alınmayacaktır. Bir üretim işletmesinin dönem verileri (₺):

| Kalem | Tutar |
|---|---:|
| DB ilk madde ve malzeme | 40.000 |
| İlk madde alışları | 300.000 |
| Alış iadeleri | 10.000 |
| Alış nakliye gideri | 6.000 |
| DS ilk madde ve malzeme | 56.000 |
| Kullanılan endirekt malzeme | 20.000 |
| Direkt işçilik | 150.000 |
| Endirekt işçilik | 30.000 |
| Fabrika amortismanı | 25.000 |
| Fabrika enerji gideri | 15.000 |
| DB / DS yarı mamul | 30.000 / 50.000 |
| DB / DS mamul | 60.000 / 45.000 |
| DB ticari mal / alış / DS ticari mal | 20.000 / 80.000 / 25.000 |
| Genel yönetim gideri | 40.000 |
| Pazarlama gideri | 35.000 |
| Kredi faizi | 12.000 |

Çözüm:

1. Net alışlar = 300.000 + 6.000 − 10.000 = 296.000 ₺.
2. Toplam ilk madde kullanımı = 40.000 + 296.000 − 56.000 = 280.000 ₺.
3. Direkt ilk madde gideri = 280.000 − 20.000 = **260.000 ₺**.
4. GÜG = 20.000 + 30.000 + 25.000 + 15.000 = **90.000 ₺**.
5. Dönemin üretim giderleri = 260.000 + 150.000 + 90.000 = **500.000 ₺**.
6. Üretim maliyeti = 500.000 + 30.000 − 50.000 = **480.000 ₺**.
7. Satılan mamul maliyeti = 480.000 + 60.000 − 45.000 = **495.000 ₺**.
8. Satılan ticari mal maliyeti = 20.000 + 80.000 − 25.000 = **75.000 ₺**.
9. Satışların maliyeti = 495.000 + 75.000 = **570.000 ₺**.

Genel yönetim (40.000), pazarlama (35.000) ve faiz (12.000) tutarlarının hiçbiri tabloya girmedi. Aynı verilerle asal maliyet 260.000 + 150.000 = 410.000 ₺, dönüştürme maliyeti 150.000 + 90.000 = 240.000 ₺ olur.

## 6. Geri hesap teknikleri

**Geri hesap**, tablonun sonunda yer alan bir tutar verilip başındaki bilinmeyenin istenmesidir. Yöntem, her eşitliği bilinmeyen için çözmek ve tablonun sonundan başına doğru yürümektir.

### Brüt satış kârından satışların maliyetine

Net satışlar 760.000 ₺ ve brüt satış kârı **satışların %25'i** ise:

- Brüt kâr = 760.000 × 0,25 = 190.000 ₺; satışların maliyeti = 760.000 − 190.000 = **570.000 ₺**.

Aynı soruda kâr **maliyetin %25'i** olarak verilseydi:

- Satışlar = Maliyet × 1,25 olduğundan maliyet = 760.000 / 1,25 = **608.000 ₺** olurdu.

> **Sınav ipucu:** "Satışlar üzerinden kâr oranı" ile "maliyet üzerinden kâr oranı" (kâr marjı ile kâr yüzdesi) en sık kurulan tuzaklardandır. İlkinde maliyet = satış × (1 − oran), ikincisinde maliyet = satış / (1 + oran).

### Satılan mamul maliyetinden ilk madde alışına

Yukarıdaki örnekte SMM'nin 495.000 ₺ olduğu biliniyor, ilk madde net alışları isteniyor olsun:

1. Üretim maliyeti = SMM − DB mamul + DS mamul = 495.000 − 60.000 + 45.000 = 480.000 ₺.
2. Dönemin üretim giderleri = Üretim maliyeti − DB yarı mamul + DS yarı mamul = 480.000 − 30.000 + 50.000 = 500.000 ₺.
3. Direkt ilk madde = 500.000 − 150.000 − 90.000 = 260.000 ₺.
4. Toplam kullanım = 260.000 + 20.000 = 280.000 ₺.
5. Net alışlar = Kullanım + DS ilk madde − DB ilk madde = 280.000 + 56.000 − 40.000 = **296.000 ₺**.

Geri giderken işaretler tersine döner: ileri yönde çıkarılan dönem sonu stokları geri yönde **eklenir**, eklenen dönem başı stokları **çıkarılır**.

## 7. Zincirleme dönem tabloları

**Zincirleme tablo**, birden fazla dönemin aynı soruda verildiği tablodur. Temel bağ şudur: bir dönemin **dönem sonu stoku**, izleyen dönemin **dönem başı stokudur**. Soru çoğu zaman yalnızca bir dönemin stokunu verir; diğerini bu bağdan bulman beklenir.

| Kalem | 1. dönem | 2. dönem |
|---|---:|---:|
| Dönemin üretim giderleri | 400.000 | 450.000 |
| DB yarı mamul | 20.000 | 30.000 |
| DS yarı mamul | (30.000) | (25.000) |
| Üretim maliyeti | 390.000 | 455.000 |
| DB mamul | 50.000 | 70.000 |
| DS mamul | (70.000) | ? |
| Satılan mamul maliyeti | 370.000 | 480.000 |

1. 1. dönem üretim maliyeti = 400.000 + 20.000 − 30.000 = 390.000 ₺; SMM = 390.000 + 50.000 − 70.000 = 370.000 ₺.
2. 2. dönemin DB yarı mamulü 30.000 ₺ ve DB mamulü 70.000 ₺'dir; ikisi de 1. dönemin dönem sonu stoklarıdır.
3. 2. dönem üretim maliyeti = 450.000 + 30.000 − 25.000 = 455.000 ₺.
4. 2. dönem DS mamul = DB mamul + Üretim maliyeti − SMM = 70.000 + 455.000 − 480.000 = **45.000 ₺**.

Çözerken şu sırayı izle: her stok türünü (ilk madde, yarı mamul, mamul, ticari mal) ayrı satırda takip et; dönem sonu stoklarını bir sonraki sütuna taşı; tek bilinmeyeni olan eşitlikten başla; sonucu "başlangıç + giriş − çıkış = bitiş" dengesiyle kontrol et.

> **Sık yapılan hata:** Dönem sonu yarı mamul stokunu mamul stokuyla karıştırmak. Yarı mamul farkı üretim maliyetine, mamul farkı satılan mamul maliyetine giden basamakta kullanılır; ikisini aynı basamakta uygulamak tüm zinciri bozar.

## Özet

- Satışların maliyeti tablosu, gelir tablosundaki satışların maliyetini stok hareketleriyle ayrıntılandırır; satılan mamul, ticari mal ve hizmet maliyetlerinin toplamı satışların maliyetidir.
- İlk madde kullanımı = DB + net alışlar − DS; bundan endirekt malzeme (GÜG'e gider) ve satılan ilk madde (ticari bölüme gider) düşülünce direkt ilk madde gideri kalır.
- Direkt ilk madde + direkt işçilik + GÜG = dönemin üretim giderleri; buna yarı mamul farkı (DB − DS) eklenince MSUGT anlamında üretim maliyeti bulunur.
- Satılan mamul maliyeti = üretim maliyeti + DB mamul − DS mamul; satılan ticari mal maliyeti = DB + net alışlar − DS.
- Genel yönetim, pazarlama ve finansman giderleri dönem gideridir; maliyet tablosuna katılmaz.
- Geri hesapta tablonun sonundan başına yürünür ve stokların işaretleri tersine döner; satış üzerinden ve maliyet üzerinden kâr oranını ayırt et.
- Zincirleme tablolarda önceki dönemin dönem sonu stoku, sonraki dönemin dönem başı stokudur.
