# Yeni anlatımlar 1 — IFM/KCV, IFM/MDV, IFM/STK, IFM/TAB, FYN/PIY (2026-10-18)

Hepsi sıfırdan yazıldı, `durum: "taslak"`, `yazar: Claude`. Doğrulama: `anlatim.denetle` ve `anlatim.siki_denetle` (ymm müfredatı, `_kaynakli` ders ayarına göre) beş dosyada da boş liste döndü. Bütün `alinti` alanları kaynak metinde Grep ile birebir bulundu ve `alinti_sorunlari` denetiminden geçti.

| Dosya | Kelime (gövde) | denetle | siki_denetle |
|---|---|---|---|
| content/anlatim/ymm/IFM/KCV.md | 1559 | [] | [] |
| content/anlatim/ymm/IFM/MDV.md | 1468 | [] | [] |
| content/anlatim/ymm/IFM/STK.md | 1433 | [] | [] |
| content/anlatim/ymm/IFM/TAB.md | 1517 | [] | [] |
| content/anlatim/ymm/FYN/PIY.md | 1562 | [] | [] |

## IFM/KCV — Kavramsal Çerçeve ve finansal tabloların sunuluşu

İşlenen kazanımlar (her biri ayrı bölümde):
1. Amaç ve niteliksel özellikler (KÇ 1.2, 2.5, 2.6, 2.11, 2.13, 2.16, 2.23, 2.39)
2. Unsurların tanımı ve tablolara alınması (KÇ 4.3, 4.4, 4.26, 4.27, 4.63, 4.68, 4.69, 5.6, 5.7)
3. Ölçüm esasları (KÇ 6.4, 6.11, 6.12, 6.17, 6.21), sayısal örnekle; sermayenin korunması (KÇ 8.1, 8.3)
4. TMS 1 (10, 25, 32, 66, 69) ve TFRS 18 (47, 59, 69, 117, C1), TFRS 18 sınıflandırma tablosu örneği
5. TMS 8 (5, 14, 19, 22, 36, 42), tahmin değişikliği sayısal örneği
6. TMS 10 (3, 8, 9, 10, 12, 14, 21) ve TMS 24 (9, 13, 18)

Emin olunamayan veya kaynakta olmayan noktalar:
- Paragraf numaraları KÇ ve TMS metinlerinden kontrol edildi. "Yükümlülükte kaçınma imkânının olmaması" ifadesi KÇ'nin mükellefiyet açıklamasının özetidir; paragrafı ayrıca doğrulanmadığından numara verilmedi.
- Tasdik notundaki "VUK md. 116 vergi hatası" bağlantısı genel bir yönlendirmedir; düzeltme usulüne (pişmanlık, düzeltme beyannamesi) girilmedi.

## IFM/MDV — Maddi ve maddi olmayan duran varlıklar ve YAG

İşlenen kazanımlar: TMS 16 maliyet ve amortisman (VUK md. 320 farkı, kıst amortisman, kalıntı değer; EV'li örnek), yeniden değerleme modeli (TMS 16.35 brüt ve net yöntem, 16.39-41; 522 ve EV), TMS 38 ve kuruluş giderleri (38.54, 57, 69, 75, 97, 107; KVK md. 8/1-b, VUK md. 326; EV'li örnek), TMS 36 (9, 10, 18, 59-61, 117, 124; örnek), TMS 40 (5, 30, 35, 57, 61-62; 570/649 ayrımlı örnek), TMS 23 (5, 8, 12, 14, 17, 20, 22; örnek).

Emin olunamayan noktalar:
- MDV değer düşüklüğü için THP'de ayrı hesap yok; "257 değer düşüklüğü alt hesabı" sınav anahtarı uygulamasına dayanır. YAG için "25X", canlı varlık için "25X/15X", satış amaçlı varlık için "19X" ilave hesap olarak yazıldı (sınav anahtarları 194/195/199 gibi farklı kodlar kullanmış olabilir; belirli bir kod verilmedi).
- TMS 23 örneğinde VUK'taki faiz kaydı (aktifleştirme/gider seçimi) kaynakta doğrulanamadığından EV hesaplanmadı; yalnız TFRS düzeltmesi verildi.
- VUK'ta yeniden değerleme (mük. 298/Ç) yapılmadığı varsayıldı.

## IFM/STK — Stoklar, canlı varlıklar ve devlet teşvikleri

İşlenen kazanımlar: TMS 2 maliyet ve NGD (2.6, 9-13, 16, 18, 23, 25), stok değer düşüklüğü ve iptal (2.29, 2.32, 2.33; VUK md. 274 ve 278; ithal mal + NGD + EV örneği ve yarı mamul örneği), TMS 41 (5, 12, 13, 26, 28, 30, 34, 35; süt çiftliği örneği), TMS 20 (3, 7, 10A, 12, 13, 20, 24-27, 32; iki sunum yöntemli örnek).

Emin olunamayan noktalar:
- "Depolar arası nakliye gider" sonucu TMS 2.10 ve 2.16'nın yorumuna ve çıkmış soru analizindeki 2024/3 anahtarına dayanır; standartta bu örnek açıkça yazmaz.
- Vade farkının VUK'ta maliyete eklendiği örnek varsayımıdır; VUK'un vade farkı hükmü ayrıca doğrulanmadı.
- TMS 41 örneğinde canlı varlıkların VUK'ta maliyetle izlendiği varsayıldı (amortisman ayrılıp ayrılmadığı ele alınmadı).

## IFM/TAB — Nakit akış tablosu ve özel raporlama konuları

İşlenen kazanımlar: TMS 7 (6, 7, 10, 14, 16, 17, 18, 31, 34, 35, 43; doğrudan ve dolaylı yöntemli tam örnek), TFRS 5 (3, 6, 7, 8, 15, 25, 32, 33, 38; amortisman iptali + sınıflama + değer düşüklüğü + EV örneği), TFRS 1 (açılış tablosu, zorunlu istisna, tahmini maliyet, üç bilanço), TFRS 13 (tanım, asıl/en avantajlı piyasa, en yüksek ve en iyi kullanım, Seviye 1-2-3), TSRS 1 (1-3, 21, 25, 64, E3, E5; 2026 KGK eşik kararı).

Kaynak bulunamayan noktalar (hakem dikkatine):
- **TFRS 1 ve TFRS 13 metinleri content/kaynaklar/mevzuat altında yok.** Bu bölümler genel standart bilgisine dayanır; paragraf numarası verilmedi. GUD tanımı için TMS 40.5, "Seviye 1 girdisi" için TFRS 9.7.2.12 alıntılandı. Üç bilanço kuralı, tahmini maliyet muafiyeti, işlem maliyeti/nakliye ayrımı ve en düşük seviyeli girdi kuralı kaynakla doğrulanamadı.
- TFRS 18'in TMS 7'de yaptığı değişiklikler (faiz ve temettü sınıflamasının sabitlenmesi, dolaylı yöntemin başlangıç noktası) kaynak metinde bulunamadığından anlatımdan çıkarıldı.
- TSRS kapsam ölçütlerinin nasıl uygulandığı (kaç ölçütün kaç dönem aşılacağı) 2023 tarihli 21634 sayılı ana kararda; o metin kaynaklarda olmadığından yalnız eşik tutarları yazıldı.
- 2024/2 puanlama notuna yapılan atıf (vergi ödemesini farklı ele alana tam puan) çıkmış soru analizindeki notun özetidir.

## FYN/PIY — Finansal piyasalar ve türev ürünler

İşlenen kazanımlar: para ve sermaye piyasası araçları (tablo, repo, halka arz faydaları), vadeli işlem ve opsiyon (forward/futures farkı, faiz paritesi örneği, prim faktörleri tablosu, döviz satım opsiyonu iki senaryolu örnek), swap ve CDS (karşılaştırmalı üstünlük ve banka kazancı örneği, CDS prim/ödeme örneği, derecelendirme farkı), kur riski ve korunma (risk türleri, para piyasası korunması, çapraz kur örneği), menkul kıymetleştirme (VDMK, İDMK, teminatlı menkul kıymet, dilimler), temel kavramlar (değer maksimizasyonu, acenta sorunu ve maliyetleri, ekonomik kâr ve EVA örneği, piyasa faiz bileşenleri, piyasa kapitalizasyonu, nakit süpürme).

Kaynaklar YMM kuralına uygun olarak "Genel bilgi" biçiminde (alıntısız) yazıldı. Emin olunamayan noktalar:
- Kur ve faiz rakamları varsayımsaldır. İDMK'yı ihraç eden kuruluş türü (ipotek finansmanı kuruluşu / konut finansmanı fonu) doğrulanamadığından adı verilmedi.
- "Nakit süpürme" için iki yaygın anlam (borç sözleşmesindeki zorunlu erken ödeme ve hesaplar arası otomatik aktarım) tek tanımda birleştirildi; sınav anahtarının hangisini beklediği analiz dosyasında yok.

## Genel

- Yalnız bu beş anlatım dosyası ve bu rapor yazıldı; başka dosya değiştirilmedi, git çalıştırılmadı, alt ajan başlatılmadı.
- 2026 KV oranı %25 (KVK md. 32/1) kaynakta doğrulandı ve bütün EV hesaplarında kullanıldı.
