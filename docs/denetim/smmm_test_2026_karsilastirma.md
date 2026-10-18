# SMMM 2026 resmî TESMER testleri (yeni test formatı) ile müfredat ve soru bankası karşılaştırması

Tarih: 2026-10-18 | Kapsam: smmm_2026_1 ve smmm_2026_2 (dönem 1 ve 2), 8 ders x 20 soru x 2 dönem = 320 soru | Salt okunur analiz; repoda başka dosya değiştirilmedi.

## 0. Yöntem, sınırlar, okunamayanlar

- Kaynak metinler PDF'ten iki sütunlu düz metne çevrilmiş. Soru ayrıştırması otomatik yapıldı; tablo/öncül içeren sayfalarda numaralar kaymış. 320 sorunun **5'inin kökü okunamadı** (konu atanmadı, tablolarda "okunamadı"): FIN 2.6, VER 1.18, VER 2.1, HUK 1.18, SPK 2.19. Bunlardan ayrı olarak 13 soru **(k)** işaretiyle "kısmen okunabildi" olarak konuya atandı (öncül/tablo parçasından): MAL 1.4, 1.9, 2.8; DEN 2.18; HUK 1.16; MES 2.18; SPK 1.3, 1.7, 1.9, 1.16, 2.1, 2.3, 2.7 (haritada (k) ile işaretli). Bunların konu ataması yüksek olasılıklı ama kesin değildir. (Not: sayım aşağıda tablolarda 40 üzerinden verilir; okunamayan soru sayısı satırda "okunamadı" olarak ayrıca yazılır.)
- Konu ataması soru kökünün içeriğine göre benim yaptığım yargıdır; sınırdaki sorular açıkça not edildi (ör. SPK 2.11 kripto varlık zimmet suçu: SUC'a yazıldı, YEN de olabilir; FIN 2.5 mevduat faizi + stopaj: HAZ'a yazıldı).
- "Banka" = content/sorular/smmm/<DERS>/*.yaml içinde `durum: kontrolde` ve `bolum` listesinde YET olan sorular. Toplam: FIN 305, TAB 107, MAL 225, DEN 419, VER 459, HUK 424, MES 357, SPK 192 (= 2.488).
- Resmî pay = adet / 40. 40 soruda 1 soru = 2,5 puan; yani "uyumlu" eşiği ±2,5, "sınırda" ±5, üstü "belirgin fark" alındı. Yalnız iki dönemlik örneklem olduğundan 1-2 sorunun farkı gürültüdür.
- Şık uzunluğu, olumsuz kök, boşluk doldurma, mutlak ifade oranları regex ile ölçüldü; resmî metindeki sütun birleşmeleri nedeniyle şık uzunlukları yaklaşıktır. Resmî ölçümlerde ayrıştırılabilen soru sayısı (n) tabloda yazılıdır.

## 1. Genel bulgular (özet)

1. **Ağırlık tablosu (agirlik.yet) büyük ölçüde resmî dağılımla örtüşüyor**: FIN, HUK, MES, SPK, VER'de her konuda fark ≤2,5 puan. Belirgin sapmalar: TAB `TMS` (yaml 14, resmî 7,5), MAL `TBL` (22 / 15) ve `KAV` (17 / 22,5), DEN `RSK` (15 / 22,5), `RAP` (8 / 2,5), `KNT` (8 / 5), `KAL` (8 / 12,5).
2. **Banka dağılımı** konu bazında yaml'dan daha çok sapıyor: MAL `TBL` bankada 31,6% (resmî 15%), MAL `SIP+ORT+SAF` bankada 12,4% (resmî 30%); DEN `PRG` bankada 27 soru (yaml ve resmî 0); TAB `TMS` bankada 24,3% (resmî 7,5%), TAB `KAR` 7,5% ve `DVR` 18,7% (resmî 10 / 25); FIN `ALC` bankada 22 soru (7,2%, resmî 10%).
3. **YOK (müfredatta karşılığı olmayan konu): yok.** Okunabilen 315 sorunun hepsi mevcut konu kodlarına oturdu. Alt kazanım eksikleri 3. bölümde.
4. **Stil farkları (en önemlileri)**: (a) bankada doğru şık çok sık **en uzun şık** (kontrolde+YET: 998/1.607 = %62; resmîde 40/170 = %24 ≈ şans); (b) bankada yanlış şıkların %31'i mutlak ifade içeriyor (hiçbir, yalnızca, sadece, her durumda...), resmîde %1,5; (c) **olumsuz kök** sözel derslerde bankada %12-18, resmîde %36-56; (d) resmî sınavda `BDS nnn` numarası kökte hiç yok, bankada DEN köklerinin %35'inde var; (e) VER/HUK bankada köklerin yaklaşık %30'unda madde numarası var, resmîde çok nadir; (f) sayısal şıklarda resmî sınav neredeyse hep **artan sırada ve eşit aralıksız**, bankada sıra bozuk ve sıklıkla aritmetik dizi (TAB %19); (g) öncüllü soru FIN/TAB'da resmîde yok, MAL'de en fazla 1, bankada %7-15; SPK'da resmîde %20, bankada %9,9; (h) TAB resmîde ortak veri tablosuna dayanan 17-20 soruluk set, bankada tek tek mini hesaplar; (i) para birimi: resmî ₺, bankada FIN/MAL/VER köklerinde ağırlıkla "TL".
5. **Cevap anahtarı**: resmî testlerin her birinde A-E dağılımı 3-5 aralığında (toplam A71 B63 C64 D59 E63), bankanın genel toplamı dengeli (A488 B530 C490 D499 E481, chi2=3,0) ama **ders bazında belirgin çarpık**: FIN (A %31,8 / D %12,1), VER (B %28,1 / E %12,0), TAB (C %35,5 / A %8,4), MES (E %26,6 / C %12,9), DEN (E %25,8 / A %18,9; chi2=13,6). Ayrıntı 6. bölümde.

## 2. 1) Finansal Muhasebe (FIN)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: STK — ticari mal alış taşıma gideri (satıcı adına nakit ödeme) yevmiye kaydı
- S1.2: ALC — alacak senedi yenileme kaydı
- S1.3: MDV — kamyonet satış kârı (yedek) + yeni araç amortisman kaydı
- S1.4: MKY — iştirak kâr payı geliri kaydı
- S1.5: MKY — karşılık ayrılmış hisse senedi satışı kaydı
- S1.6: BOR — borçlanma senedi ihracı (iskonto + masraf) tek kayıt
- S1.7: ALC — karşılık ayrılmış şüpheli alacağın tahsil edilemezliği
- S1.8: HAZ — ödenen/tahsil edilen KDV farkının mahsubu (hesap)
- S1.9: OZK — primli hisse satışı ile sermaye artırımı kaydı
- S1.10: ALC — dayanıklı ambalaj depozitosu (alacaktan düşme/iade)
- S1.11: DON — vadeli mevduat faiz tahakkuku (borçlandırılan hesap)
- S1.12: STK — FIFO ile satılan ticari mal maliyeti (hesap)
- S1.13: ALC — ileri tarihli çek, bilanço tarihinde temel kavramlar gereği kayıt
- S1.14: HAZ — kasa sayım farkı kaydı
- S1.15: MKY — hisse senedi alımı kaydı
- S1.16: STK — sürekli envanter, normal fire kaydı
- S1.17: DON — gelecek aylara ait gider (kira) dönem sonu işlemi
- S1.18: MDV — TMS 16 yeniden değerleme (taşıt) kaydı
- S1.19: STK — TMS 2 net gerçekleşebilir değer / değer düşüklüğü
- S1.20: MDV — Ar-Ge giderlerinin muhasebeleştirilmesi (kökte "TMS 36" yazıyor)
- S2.1: MDV — bina dış cephe yenileme maliyeti hangi hesapta
- S2.2: BOR — uzun vadeli borç hesabı tanıma (hesap planı)
- S2.3: OZK — nominal üstü hisse satışı farkı (ihraç primi) hesabı
- S2.4: DON — borç senedi reeskontu kaydı
- S2.5: HAZ — mevduat faizi tahakkuku + vergi kesintisi tek kayıt
- S2.6: YOK — OKUNAMADI: kök metin çıkarılamadı (yevmiye kaydı görseli/tablosu)
- S2.7: OZK — sermaye artırımı + primli hisse satışı, yanlış kayıt
- S2.8: STK — sürekli envanterde sayım noksanı araştırma kaydı
- S2.9: STK — yangın hasarlı mal karşılığı + satış, kullanılmayan hesap
- S2.10: MKY — 119 karşılığı / 110 hisse kaydı hangi işlemin karşılığı
- S2.11: BOR — para ve sermaye piyasası borçları hesap grubu (hesap planı)
- S2.12: MKY — ortaklık payı %45'ten %60'a (iştirak-bağlı ortaklık)
- S2.13: MDV — kamyonet için verilen avans hesabı
- S2.14: BOR — banka kredisi faiz tahakkuku (360 gün) dönem sonu kaydı
- S2.15: STK — vadeden önce ödemede alış iskontosu (120 ₺ + KDV) kaydı
- S2.16: DON — elektrik gider tahakkuku ve ertesi dönem fatura kaydı
- S2.17: DON — kurumlar vergisi karşılığı kaydı
- S2.18: MDV — TMS 40 arsanın yatırım amaçlı gayrimenkule sınıflanması
- S2.19: STK — TMS 2 normal kapasite altı üretimde sabit GÜG, birim maliyet
- S2.20: MDV — üretim miktarı yöntemiyle amortisman (hurda değerli cihaz)

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| STK Stoklar ve ticari mallar | 8 | 20.0% | 20 | 59 (19.3%) | yaml uyumlu; banka uyumlu |
| MDV Maddi ve maddi olmayan duran varlıklar | 7 | 17.5% | 18 | 56 (18.4%) | yaml uyumlu; banka uyumlu |
| MKY Menkul kıymetler ve ortaklık payları | 5 | 12.5% | 13 | 45 (14.8%) | yaml uyumlu; banka uyumlu |
| DON Dönem sonu tahakkuk/erteleme/reeskont/karşılık | 5 | 12.5% | 13 | 33 (10.8%) | yaml uyumlu; banka uyumlu |
| ALC Alacaklar ve senetler | 4 | 10.0% | 10 | 22 (7.2%) | yaml uyumlu; banka uyumlu |
| BOR Yabancı kaynaklar ve mali borçlar | 4 | 10.0% | 10 | 36 (11.8%) | yaml uyumlu; banka uyumlu |
| OZK Özkaynak işlemleri | 3 | 7.5% | 8 | 29 (9.5%) | yaml uyumlu; banka uyumlu |
| HAZ Hazır değerler, KDV, kavramlar | 3 | 7.5% | 8 | 25 (8.2%) | yaml uyumlu; banka uyumlu |
| okunamadı | 1 | 2.5% | - | - | konu atanamadı |
| **toplam** | 40 | 100% | 100 | 305 | |

Yorum: yaml ağırlıkları resmî dağılımla birebir örtüşüyor (STK 8/MDV 7/MKY 5/DON 5/ALC 4/BOR 4/OZK 3/HAZ 3, +1 okunamadı). Bankada DON %10,8 (resmî 12,5), ALC %7,2 (resmî 10) hafif az; ALC için bankada yalnız 22 soru var (stok az).

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım eksikleri: **hesap planı bilgisi** soruları (hangi hesap / hesap grubu: S2.2 "uzun vadeli borç hesabı", S2.11 "para ve sermaye piyasası borçları hesap grubu", S2.13 "verilen avans hesabı") yaml kazanımlarında ayrı kazanım olarak yok; **TMS 40 yatırım amaçlı gayrimenkule sınıflama** MDV'de var; **mevduat faizi + stopaj tek kayıt** (S2.5) HAZ/DON kazanımlarında açık yazmıyor; **iştirak → bağlı ortaklık yeniden sınıflama** (S2.12, %45→%60) MKY kazanımında (242/245) sınırda kapsanıyor.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=38 ayrıştırılan soru): kök karakter medyan/ort/p90 = 285/290/435; şık ort. 60; olumsuz kök %5; sayısal vaka (kökte ≥2 tutar) %53.

**Resmî format**: 38/40 okunabildi; hemen hepsi tek bir işlem/olay üzerine kurulu, tutarlı vaka ve "Bu işleme ilişkin günlük defter kaydı aşağıdakilerden hangisidir?" ya da "... aşağıdakilerden hangisi doğrudur?" kalıbında. Seçenekler çoğunlukla THP kodlu **borç/alacak yevmiye tablosu** (sütunlu). Saf kavram/hesap planı sorusu yaklaşık 8/40 (S1.8, 1.13, 1.20, S2.1, 2.2, 2.3, 2.11, 2.13). TMS dayanaklı sorular 6/40 (TMS 2 x2, TMS 16 x2, TMS 40, Ar-Ge/TMS 38). Olumsuz kök yalnız %5 (2 soru), öncüllü 0, boşluk doldurma 0. Zorluk: 2 etkili işlemler (FIFO tablolu hesap S1.12, bono ihracı + masraf S1.6, 360 günlük faiz tahakkuku S2.14, TMS 2 normal kapasite S2.19, yeniden değerleme S1.18). Kök medyanı 285 karakter (p90 435).

**Banka (305 soru)**: kök medyanı 237 (p90 435) yani uzunluk uyumlu; olumsuz kök %11 (resmî %5); öncüllü A-şıkkı romen rakamlı soru %7,2 (22 soru, resmîde 0); `tip` dağılımı kavrama 115 + bilgi 25 = %46, hesaplama 54 (%17,7), uygulama 111; zorluk 1/2/3 = 62/144/99.

**Farklar / düzeltilecekler**
- Resmî sınav neredeyse saf "uygulama (yevmiye)" odaklı; bankada kavrama+bilgi payı %46 çok yüksek. Hedef: kavrama/hesap planı en fazla %20, kalan tutarlı vaka (yevmiye / hesap bulma / tutar hesabı).
- Öncüllü kurgu FIN'de kullanılmasın (resmî 0/40; bankada 22 soru, ör. SMMM-FIN-BOR-0034 "I-300, II-303..." eşleştirme türü).
- Para birimi: resmîde ₺, bankada köklerin 108/305'inde "TL" (34'ünde ₺). **"BOBİ FRS" geçen 37 soru** var; resmî kökte hep TMS/MSUGT dili (BOBİ FRS yok) — Yeterlilik için kaldırın/yeniden yazın.
- Markdown kalıntısı: 30 kökte `**yanlıştır**` biçimli kalın işaret; resmîde düz metin.
- Sayısal şıkların resmîde yalnız 13 soruda ayrıştırılabildi (4'ü artan sırada; kayıt tutarları); bankada aritmetik dizi şıkları 13/158 (%8), ör. SMMM-FIN-ALC-0029: 18.000-20.000-22.000-24.000-26.000 (cevap tam ortada; "2.000 TL faiz eklenir" gibi tek adımlı, resmî düzeyin çok altı).
- Doğru şık en uzun şık: bankada 78/157 (%50), resmîde 7/30 (%23). "Doğru kayıt" şıkkı kısa, çeldirici ayrıntılı tutulmalı ya da şık uzunlukları dengelenmeli.
- Açıklama alanı: 12 soruda `celdiriciler` şablon cümle (ör. "ilgili hesabın işlevini yanlış geneller...") ve `dogru_neden` kök metnini tekrar ediyor (SMMM-FIN-ALC-0029); düzeltme listesine alın.
- Eksik tip: resmîde sık olan "işlem sonrası dönem sonunda yapılması gerekenler / hangisi doğrudur (kayıt + yorum)" ve iki aşamalı, tek kayıtlı işlemler ("tek bir günlük defter kaydı yapılmışsa", S1.6, S2.5, S2.7); bankada az.

## 3. 2) Finansal Tablolar ve Analizi (TAB)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: LIK — net işletme sermayesi
- S1.2: LIK — cari oran
- S1.3: LIK — likidite oranı
- S1.4: DVR — stok devir süresi
- S1.5: DVR — alacak tahsil süresi
- S1.6: DVR — borç ödeme süresi
- S1.7: KAR — satış kârlılığı
- S1.8: KAR — faaliyet kârlılığı
- S1.9: KAR — varlık kârlılığı
- S1.10: DIK — dikey yüzde (brüt satışlar)
- S1.11: DIK — dikey yüzde (KV mali borçlar / toplam kaynak)
- S1.12: DIK — trend yüzdesi (dönen varlıklar)
- S1.13: DIK — trend yüzdesi (net satışlar)
- S1.14: TMS — satışlardan nakit girişi
- S1.15: DIK — karşılaştırmalı tablo, değişim yüzdesi sonrası değer
- S1.16: DVR — hedef tahsil süresinden geri hesap (öngörü tablosu)
- S1.17: LIK — hedef cari/likidite oranından stok tutarı geri hesabı
- S1.18: DIK — GRAFİK yorumu (net satış/satış maliyeti), İPTAL edildi
- S1.19: TMS — TMS 1 tam set finansal tablolar, hangisi yer almaz
- S1.20: TMS — toplam kapsamlı gelir tanımı
- S2.1: DIK — trend analizi (stoklar)
- S2.2: DIK — trend analizi (net satışlar)
- S2.3: DVR — hedef borç ödeme süresinden borç tutarı geri hesabı
- S2.4: LIK — kaldıraç oranı (devamlı sermaye + UVYK oranından)
- S2.5: DIK — dikey yüzde ile faaliyet kârı hesabı
- S2.6: DIK — GRAFİK yorumu (satışlar/alacaklar trendi), İPTAL edildi
- S2.7: DIK — GRAFİK yorumu (dönen varlık/KVYK/stok trendi), geçerli
- S2.8: DVR — DİMM stok devir süresi
- S2.9: DVR — yarı mamul stok devir süresi
- S2.10: DVR — mamul stok devir hızı
- S2.11: DVR — ticari mal stok devir süresi
- S2.12: LIK — brüt işletme sermayesi
- S2.13: LIK — cari oran
- S2.14: DVR — alacak tahsil süresi
- S2.15: KAR — brüt satış kârlılığı
- S2.16: DIK — dikey yüzde (dönem kârı)
- S2.17: DIK — dikey yüzde (mali borçlar)
- S2.18: DIK — dikey yüzde (satış indirimleri)
- S2.19: DIK — karşılaştırmalı analiz (ticari borçlar)
- S2.20: DIK — karşılaştırmalı analiz (KV mali borçlar)

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| DVR Devir hızları ve süreleri | 10 | 25.0% | 25 | 20 (18.7%) | yaml uyumlu; banka belirgin fark (-6.3) |
| LIK Likidite ve finansal yapı oranları | 7 | 17.5% | 18 | 19 (17.8%) | yaml uyumlu; banka uyumlu ; stok az (<20) |
| DIK Dikey, yatay ve trend analizi | 16 | 40.0% | 33 | 34 (31.8%) | yaml belirgin fark (-7.0); banka belirgin fark (-8.2) |
| KAR Kârlılık oranları | 4 | 10.0% | 10 | 8 (7.5%) | yaml uyumlu; banka uyumlu ; stok az (<20) |
| TMS Finansal tablolar, TMS 1, nakit akışı | 3 | 7.5% | 14 | 26 (24.3%) | yaml belirgin fark (+6.5); banka belirgin fark (+16.8) |
| **toplam** | 40 | 100% | 100 | 107 | |

Yorum: En büyük sapma TMS: yaml 14, resmî 3/40 (%7,5); bankada 26 soru (%24,3). DIK resmî %40, yaml 33, banka %31,8. DVR resmî %25 (yaml 25) ama bankada %18,7. KAR resmî 4 soru (%10) bankada 8 soru, stok az.

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: **grafik yorumu** (3 soru) yaml notunda "üretme" deniyor; **kaldıraç oranı** (S2.4, devamlı sermaye + UVYK'dan) LIK'te var; **çeyrek/ara dönem devir süreleri (90 gün)** yaml notunda var; **brüt işletme sermayesi** LIK'te var. TMS konusu kazanımında **"satışlardan nakit girişi"** var.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=40 ayrıştırılan soru): kök karakter medyan/ort/p90 = 92.5/139/264; şık ort. 10; olumsuz kök %2; sayısal vaka (kökte ≥2 tutar) %30.

**Resmî format**: Dönem 1'de 2023-2025 (Q1-Q17), dönem 2'de 31.12.2025 + 31.03.2026 ara dönem tabloları; tek ortak bilanço + gelir tablosu 17-20 soruyu besliyor. Kök çok kısa (medyan 92 karakter: "2025 yılının cari oranı aşağıdakilerden hangisidir?"), veri ortak tabloda. Şıklar kısa sayı/yüzde (ortalama ~10 karakter), **23/26 soruda artan sırada**, **0/26'sında aritmetik dizi**. Hesaplama payı yaklaşık 35/40 (%88); kavram 2 (S1.19, S1.20), grafik yorumu 3 (S1.18, S2.6, S2.7). Geri hesap/hedef soruları 4/40 (S1.16, S1.17, S2.3, S2.4), brüt/net işletme sermayesi ayrımı, ara dönem (çeyrek) devir süreleri (yıl 360, çeyrek 90). Olumsuz kök %2.

**Grafik soruları**: 2026'da 3 grafik sorusu var (S1.18, S2.6, S2.7); **2'si İPTAL** (1_02 S18, 2_02 S6), **S2.7 iptal edilmedi** (doğru: A). yaml notundaki "üçü de iptal edildi" ifadesi 2026 verisiyle güncellenmeli (riskli ama 2026'da 1/3 geçerli).

**Banka (107 soru, 20 soru geri_cekildi)**: kök medyanı 255 (ortalama 445, p90 1.650: tabloyu köke gömüyor); 14 kökte markdown tablo (`|---|`) var; hesaplama %64,5 (resmî ~%88); olumsuz %9 (resmî %2); öncüllü %7,5 (resmî 0); "kaynak metne göre" ifadesi 3 kökte; birim "bin TL" (resmî tam ₺). Sayısal şık: 67 soruda ayrıştırıldı, 13'ü (%19) aritmetik dizi (ör. TAB-LIK-0017: 248-249-250-251-252, cevap C=250; TAB-DIK-0033: 480-490-500-510-520), artan sıralı 62/67 (%93, resmî %88). TMS konusu 26 soru (%24,3) ve ağırlıkla MSUGT Ek-4 gelir tablosu düzenleme **kavram** soruları ("yanlıştır"); resmî TMS payı 3 soru (nakit girişi hesabı, TMS 1 tam set, toplam kapsamlı gelir). Doğru şık en uzun: 17/27 (%63) (resmî 0/4 ölçülebilir).

**Farklar / düzeltilecekler**
- **Ortak veri seti formatı**: 3 yıllık bilanço+gelir tablosu verip 15-17 soru üretin (kök tek cümle); mevcut banka tek-soru mini hesap ağırlıklı ve gerçekçi olmayan sayılar (700/450 bin TL → 250). Şıklar gerçek analist hatalarından türetilmeli (yanlış baz, ortalama yerine dönem sonu, 360/365 gün karışıklığı, brüt/net satış karışıklığı).
- Aritmetik dizi şıklarını kaldırın; çeldiriciler tipik hata yollarından (yanlış payda/baz) üretilsin.
- TMS payı 24% → ~7,5%; DVR %18,7 → ~25%; KAR zaten az (8 soru, %7,5; resmî 4 soru %10). DIK banka %31,8 (resmî %40).
- Grafik sorusu: üretilirse resmî gibi 1-3 adet, görsel veri tanımlı; yaml notu güncellenmeli.
- Markdown tablo/kalın işaret köklerini resmî gibi sade tabloya çevirin; "bin TL" yerine ₺ ve tam sayı.

## 4. 3) Maliyet Muhasebesi (MAL)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: KAV — asal maliyet ve dönüştürme maliyeti hesabı
- S1.2: STD — yüklenen/gerçekleşen GÜG: değişken-sabit sapmaları
- S1.3: SAF — eşdeğer ürün birimleri tablosunun amacı
- S1.4: SIP — (k) faaliyet tabanlı maliyetleme / GÜG yükleme tablosu (tablo kısmen okunabildi)
- S1.5: ORT — satış değeri yöntemiyle ortak maliyet payları
- S1.6: 7AB — 7/A eşzamanlı kayıt yöntemi tanımı
- S1.7: DIG — MHK analizi varsayımları (hangisi değildir)
- S1.8: TBL — üretim/satılan mamul maliyeti hesabı (stok verileriyle)
- S1.9: 7AB — (k) 7/A eşzamanlı kayıt yöntemi + stok tablosu (tablo kısmen okunabildi)
- S1.10: KAV — maliyet muhasebesinin amaçları (hangisi değildir)
- S1.11: KAV — mamul maliyeti formülü
- S1.12: KAV — GÜG kapsamındaki kalemler
- S1.13: DIG — hareketli ortalama stok değerleme yöntemi
- S1.14: 7AB — 740 Hizmet Üretim Maliyeti dönem sonu kaydı
- S1.15: SAF — FIFO ile dönemde tamamlanan eşdeğer birim
- S1.16: SIP — GÜG dağıtım tablosu II, yükleme anahtarları
- S1.17: ORT — yan ürün maliyeti (satış fiyatından geri hesap)
- S1.18: ORT — katsayılı bölme yöntemi
- S1.19: TBL — satılan ticari malların maliyeti
- S1.20: ORT — net satış değeri yöntemi, birim maliyetler
- S2.1: KAV — GÜG'i oluşturan kalemler
- S2.2: DIG — üretim kayıpları (ek işlemle 1. kaliteye dönüşen)
- S2.3: STD — direkt işçilik zaman ve ücret sapması
- S2.4: STD — standart maliyet sistemi (yanlış olan)
- S2.5: TBL — üretim maliyeti tablosundan işçilik geri hesabı
- S2.6: KAV — muhasebe bilgi sistemi (yanlış olan)
- S2.7: KAV — üretim giderlerinin unsurlara ayrımı, birim maliyet (hesap)
- S2.8: 7AB — (k) 732 bütçe farkları hesabı (kısmen okunabildi)
- S2.9: 7AB — 7/A seçeneği genel hükümleri
- S2.10: 7AB — 732 GÜG bütçe farkları hesabı
- S2.11: KAV — gider yerleri (MSUGT)
- S2.12: SIP — sipariş maliyeti, GÜG yükleme/dağıtım (A ve X siparişi)
- S2.13: KAV — üretim maliyet kalemleri ayrımı (memur ücreti, amortisman, enerji...) hesap
- S2.14: TBL — üretim maliyeti ve satılan mamul maliyeti, stok değeri
- S2.15: ORT — satış değeri yöntemi ortak maliyet (X, Y, Z)
- S2.16: TBL — zincirleme dönem tabloları (Mayıs-Haziran)
- S2.17: TBL — zincirleme dönem tabloları, eksik veri geri hesabı (Mart-Nisan)
- S2.18: SAF — FIFO safha maliyeti
- S2.19: SAF — FIFO safha maliyeti, tamamlanma dereceleri
- S2.20: 7AB — 78 Finansman Giderleri hesap grubu

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| TBL Maliyet tabloları ve geri hesaplar | 6 | 15.0% | 22 | 71 (31.6%) | yaml belirgin fark (+7.0); banka belirgin fark (+16.6) |
| KAV Temel kavramlar ve GÜG kalemleri | 9 | 22.5% | 17 | 48 (21.3%) | yaml belirgin fark (-5.5); banka uyumlu |
| 7AB 7/A-7/B ve hesap akışı | 7 | 17.5% | 15 | 46 (20.4%) | yaml uyumlu; banka uyumlu |
| ORT Ortak ve yan ürün | 5 | 12.5% | 12 | 9 (4.0%) | yaml uyumlu; banka belirgin fark (-8.5) ; stok az (<20) |
| SAF Safha maliyeti, eşdeğer birim | 4 | 10.0% | 10 | 10 (4.4%) | yaml uyumlu; banka sınırda (-5.6) ; stok az (<20) |
| SIP Sipariş maliyeti, GÜG yükleme/dağıtım | 3 | 7.5% | 10 | 9 (4.0%) | yaml uyumlu; banka sınırda (-3.5) ; stok az (<20) |
| STD Standart maliyet ve sapmalar | 3 | 7.5% | 7 | 20 (8.9%) | yaml uyumlu; banka uyumlu |
| DIG Değişken/tam maliyet, MHK, kayıplar, stok değerleme | 3 | 7.5% | 7 | 12 (5.3%) | yaml uyumlu; banka uyumlu ; stok az (<20) |
| **toplam** | 40 | 100% | 100 | 225 | |

Yorum: yaml TBL=22 ve KAV=17 resmîden sapıyor (resmî 6/9 soru); SIP yaml 10, resmî 3 (7,5), banka 9 soru. Resmî dönem 1'de TBL yalnız 2 soru, dönem 2'de 4. Bu iki dönemde KAV sorularının birçoğu aslında GÜG kalemleri/gider yeri/MBS kavram sorusu. Banka etiketleri (TBL) tutarsız olduğundan banka `TBL` sayısı gerçek tablo soru sayısını yansıtmıyor.

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: **faaliyet tabanlı maliyetleme (ABC)** SIP kazanımında yazılı (S1.4); **muhasebe bilgi sistemi** KAV kazanımında yazılı (S2.6); **740 Hizmet Üretim Maliyeti dönem sonu kaydı** (S1.14) 7AB'de "740/741/622 kapanışı" olarak var.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=37 ayrıştırılan soru): kök karakter medyan/ort/p90 = 297/295/545; şık ort. 54; olumsuz kök %11; sayısal vaka (kökte ≥2 tutar) %59.

**Resmî format**: Harf kodlu işletme adları (A, B, AB, AC, AX, AY, AZ...), "... kaç ₺'dir", çok adımlı hesaplar; uzun tablolu vakalar (zincirleme dönem tabloları S2.16-2.17, FIFO safha S2.18-2.19, GÜG dağıtım II S1.16, ABC/faaliyet tabanlı S1.4). Hesaplama ~22/40 (%55). Kavram/7/A hesap akışı ~18/40. Kök medyanı 297 (p90 545). Olumsuz kök %11, öncüllü ≥1, sayısal şıklar 17/17 ayrıştırılan soruda **artan sırada**, aritmetik dizi 1/17.

**Banka (225 soru)**: kök medyanı 290 (uyumlu); hesaplama 72 (%32), kavrama 82, bilgi 27, uygulama 44; öncüllü (A şıkkı romen) %14,7 (33 soru) — resmî ≥1/40; olumsuz %10 (uyumlu); sayısal şıklarda artan sıra 83/119 (%70; resmî %100), aritmetik dizi 6/119 (%5); TL 91 kökte, ₺ yalnız 9; doğru şık en uzun 36/89 (%40; resmî 7/19 = %37, uyumlu).

**Farklar / düzeltilecekler**
- **Konu dağılımı**: banka `TBL` 71 soru (%31,6) ama örneklemde `TBL` etiketli soruların çoğu aslında 7/A hesap akışı kavramı (SMMM-MAL-TBL-0067: 710/150 kaydı; TBL-0066 kavram). `konu` etiketleri tutarsız; yeniden etiketlenmeli. Resmî `TBL` yalnız 6/40 (zincirleme tablo ve satılan mamul/ticari mal maliyeti).
- **Yetersiz stok**: SIP 9, ORT 9, SAF 10, DIG 12, STD 20 (toplam 60/225 = %26,7) — resmî 18/40 (%45): ORT 5, SAF 4, SIP 3, DIG 3, STD 3. Özellikle ORT (resmî 5 soru = %12,5, bankada 9) ve SAF'da (4 soru; bankada 10) hesaplamalı tablo soruları üretilmeli.
- Hesaplama payı %32 → ~%55 çıkarılmalı; uzun tablolu zincirleme dönem ve FIFO safha soruları artırılmalı.
- Öncüllü kurguyu çok azaltın (%14,7 → ≤%3). Sayısal şıkları her zaman artan sırada verin.
- Para birimi ₺; markdown kalın işaret 23 kökte.
- Bankada 7/A-7/B sorularında çeldirici üretimi (ör. TBL-0025/7AB-0005) iyi: "732 borç/alacak + hangi hesaba kapanır" kalıbı resmî S2.8-S2.10 ile uyumlu.

## 5. 4) Muhasebe Denetimi (DEN)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: BDY — denetim kıstası tanımı ((i)(ii) boşluk doldurma)
- S1.2: BDY — KAYİK denetimini kim yapar
- S1.3: BDY — denetim kanıtı tanımı ((i)(ii) boşluk)
- S1.4: BDY — yetkilendirme esasları (yanlış olan)
- S1.5: KAL — KYS 1 kalite yönetim sistemi unsurları (hangisi değildir)
- S1.6: BDY — uyulacak etik ilkeler
- S1.7: BDY — bağımsızlığı bozan haller (hangisi değildir)
- S1.8: BDY — faaliyet kısıtlaması hükmü (alıntı)
- S1.9: KAL — KYS 1 nihai sorumluluk kimde
- S1.10: KNT — denetim kanıtı (yanlış olan)
- S1.11: RSK — önemlilik (yanlış olan)
- S1.12: RSK — mesleki muhakeme (doğru ifade)
- S1.13: BDY — denetim ekipleri (yanlış olan)
- S1.14: BDY — uygulamalı mesleki eğitim süresi
- S1.15: BDY — kısıtlamalar (yanlış olan)
- S1.16: BDY — sözleşme asgari şartları (hangisi değildir)
- S1.17: RSK — ön kabul: kapsam sınırlaması, görüş etkisi
- S1.18: RSK — kontrol riski tanımı (yönetim beyanı, kontrollerin önleyememesi)
- S1.19: RSK — tespit edememe riskini azaltan prosedür
- S1.20: RSK — ön kabul sorumlulukları (hangisi değildir)
- S2.1: BDY — kilit yönetici tanımı
- S2.2: BDY — denetimin amacı ve kapsamı (yanlış olan)
- S2.3: BDY — denetim kıstasını belirleme (yanlış olan)
- S2.4: BDY — kendi adına denetim şartları (yanlış olan)
- S2.5: BDY — uygulamalı eğitim süreleri ((i)(ii) boşluk)
- S2.6: BDY — uygulamalı mesleki eğitim
- S2.7: BDY — denetim raporu tanımı (boşluk doldurma)
- S2.8: BDY — Resmi Sicil'e kayıt (yanlış olan)
- S2.9: BDY — BDY genel hüküm (doğru olan)
- S2.10: RAP — olumsuz/görüş bildirmeme koşulu (alıntı, rapor ve görüş)
- S2.11: BDY — Şeffaflık Raporu
- S2.12: KAL — KYS 2 denetim kalitesinin gözden geçirilmesi
- S2.13: KAL — Etik Kuralları'nın mevzuatla ilişkisi
- S2.14: KAL — dürüstlük ilkesi tanımı (boşluk doldurma)
- S2.15: RSK — makul güvence nedir (BDS 200)
- S2.16: RSK — ön kabul sorumlulukları (hangisi değildir)
- S2.17: RSK — denetim riski (yanlış olan)
- S2.18: KNT — (k) yazılı beyan (BDS 580) öncüllü, kısmen okunabildi
- S2.19: ICK — hile sorumlulukları (yanlış olan)
- S2.20: ICK — kontrol eksikliği tanımı (boşluk doldurma)

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| BDY Bağımsız Denetim Yönetmeliği | 21 | 52.5% | 55 | 217 (51.8%) | yaml uyumlu; banka uyumlu |
| RAP Raporlama ve görüş türleri | 1 | 2.5% | 8 | 29 (6.9%) | yaml belirgin fark (+5.5); banka sınırda (+4.4) |
| KNT Denetim kanıtı | 2 | 5.0% | 8 | 30 (7.2%) | yaml sınırda (+3.0); banka uyumlu |
| RSK Risk, önemlilik, planlama | 9 | 22.5% | 15 | 58 (13.8%) | yaml belirgin fark (-7.5); banka belirgin fark (-8.7) |
| ICK İç kontrol ve hile | 2 | 5.0% | 6 | 25 (6.0%) | yaml uyumlu; banka uyumlu |
| KAL Kalite yönetimi ve etik | 5 | 12.5% | 8 | 33 (7.9%) | yaml sınırda (-4.5); banka sınırda (-4.6) |
| PRG Hesap bazlı denetim programları | 0 | 0.0% | 0 | 27 (6.4%) | yaml uyumlu; banka belirgin fark (+6.4) ; yaml 0 ama bankada YET soru var |
| **toplam** | 40 | 100% | 100 | 419 | |

Yorum: BDY dağılımı doğru; RSK resmî 9 soru (%22,5) ve yaml 15 düşük; KAL resmî 5 (yaml 8); RAP resmî 1 (yaml 8) çok yüksek; KNT 2 (yaml 8) yüksek; PRG 0 (yaml 0) ama bankada 27 YET soru.

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: BDS 580 (yazılı beyan, S2.18) KNT'de var; mesleki muhakeme/makul güvence (BDS 200) RSK'de var; KYS 2 KAL'de var. Eksik görünen: **bağımsız denetim tanımlarının (kıstas, kanıt, rapor) boşluk doldurma formatı** (6-7 soru) ayrı bir kazanım değil; BDY altında zaten tanımlar var.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=39 ayrıştırılan soru): kök karakter medyan/ort/p90 = 179/248/440; şık ort. 122; olumsuz kök %44; sayısal vaka (kökte ≥2 tutar) %0.

**Resmî format**: Tamamen sözel. **Olumsuz kök %44** (17/39: "yanlıştır" / "değildir"). **(i)(ii)(iii) boşluk doldurma** ~6-7/40 (S1.1, 1.3, S2.5, 2.7, 2.14, 2.20: tanım metinleri boşluklu). Yönetmelik/standart alıntısı + "... ifade hangisini tanımlar/açıklar" ~7/40. **Kökte BDS numarası hiç geçmiyor** (0 kez `BDS nnn`; "Türkiye Denetim Standartları'na göre" 11 kez; "KGK Bağımsız Denetim Yönetmeliği'ne göre" sık). Madde numarası da yok. Kök kısa-orta (medyan 179), **şıklar uzun** (ortalama ~122 karakter; cümle düzeyi). Öncüllü (Yalnız I / I ve II) yalnız ≥1. Sayısal hiç yok (yalnız eğitim süresi, yıl gibi süre soruları). Çeldiriciler tek unsuru değiştirilmiş sayısal/şart ifadeleri ve hangisi değildir listeleri. **Mutlak ifade** çeldiricilerde neredeyse yok (yanlış şıklarda %0,7).

**Banka (419 soru)**: kök medyanı 259 (daha uzun), şıklar kısa (ortalama 78; resmî 122); olumsuz kök %14 (resmî %44); boşluk doldurma %2; **köklerin %35'inde (148/419) `BDS nnn`**, 16'sında md./madde; öncüllü %12,6 (53); eşleştirme (I-1, II-2, III-3) ve sıralama (I-II-III-IV) gibi **resmîde hiç görülmeyen formatlar** var (SMMM-DEN-BDY-0124, BDY-0215); senaryolu soru ("Bir kişi Kurumda 8 yıl çalışmıştır...") resmî tarzı değil; yanlış şıkların %42,3'ü mutlak ifade (hiçbir, yalnızca, doğrudan Kurum atar, vb.) — resmî %0,7 → bu "mutlak = yanlış" ipucunu verir. Doğru şık en uzun: **254/329 (%77)**, resmî 10/33 (%30). Örneklemde 10 sorunun 5'i aynı tema (sorumlu denetçi görevlendirme md.28: BDY-0180, 0124, 0148, 0199, 0203 — tekrar/aşırı örnekleme). BDY 217 soru (%51,8) yaml 55 ile uyumlu ama resmîde 21/40 (%52,5).

**Farklar / düzeltilecekler**
- Olumsuz kök %14 → ~%45; boşluk doldurma (i)(ii)(iii) %2 → ~%15; BDS numarasını kökten çıkarıp "Türkiye Denetim Standartları'na göre" kalıbına; yaml notu "Kökte BDS numarası ve adı açıkça yazılır (2026 eğilimi)" bu 2026 verisiyle ÇELİŞİYOR (0 numara) → notu düzeltin.
- Şıklar tam cümle olmalı (ortalama 120 karakter); doğru şık uzunluk ipucu kaldırılmalı; mutlak ifadeli çeldirici üretimi bırakılmalı (hiçbir/yalnızca → makul görünen tek unsurlu değişiklikler).
- Eşleştirme/sıralama/senaryo formatlarını bırakın; tanım, hangisi değildir, tek unsuru değiştirilmiş şart/süre/yüzde formatına odaklanın.
- Ağırlık: RSK %13,8 → %22,5 (özellikle BDS 200/210/315 tanımları, ön kabul sorumlulukları, denetim riski bileşenleri), KAL %7,9 → %12,5 (KYS 1, KYS 2, Etik Kurallar); RAP %6,9 → ~%2,5 (resmî 1), KNT %7,2 → %5, PRG (27 soru) YET'te kullanılmamalı.

## 6. 5) Vergi Mevzuatı ve Uygulaması (VER)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: GVK — senaryo yazarlığı kazancı + temettü, GV matrahı (hesap, tarife verilmiş)
- S1.2: GVK — iki işveren ücreti + kira, beyan kapsamı (hesap/yorum)
- S1.3: GVK — ticari kazanç, BES/Bağ-Kur/eğitim indirimi sonrası matrah
- S1.4: GVK — vergiye uyumlu mükellef indirimi şartları (hangisi değildir)
- S1.5: AAT — ihtiyati haciz halleri (hangisi değildir)
- S1.6: AAT — ihtiyati haciz sebeplerine karşı dava süresi (boşluk)
- S1.7: DIG — damga vergisi (yanlış olan)
- S1.8: KDV — KDV istisnaları (hangisi değildir)
- S1.9: KDV — ihraç kaydıyla teslim, tecil-terkin (yanlış olan)
- S1.10: KDV — KDV'nin konusuna girmeyen
- S1.11: KDV — ilaç A.Ş. aylık KDV hesabı (uzun vaka)
- S1.12: KVK — kurumlar vergisi mükellefi olmayan
- S1.13: KVK — sermaye artırımı/azaltımı vakası (nakdi + iç kaynak)
- S1.14: KVK — iştirak kazancı istisnası, KV hesabı
- S1.15: KVK — binek otomobil giderleri KKEG
- S1.16: DIG — ÖTV listelerindeki malların ihracı (yanlış olan)
- S1.17: VUK — kaçakçılık suçu fiilleri (hangisi değildir)
- S1.18: YOK — OKUNAMADI: kök çıkarılamadı (sayfa düzeni)
- S1.19: VUK — değerleme ölçüleri (yanlış verilen)
- S1.20: DIG — VİV beyanname verme (yurt dışında ölüm, öncüllü olabilir)
- S2.1: YOK — OKUNAMADI: kök kesik ("İstanbul'da ikamet eden Bay (...")
- S2.2: GVK — yurt dışı ticari kazanç, geçici vergi mahsubu (hesap)
- S2.3: GVK — Eurobond faizi, emekli maaşı vb. beyan/matrah (hesap)
- S2.4: KDV — XYZ A.Ş. Aralık ayı KDV hesabı (uzun vaka)
- S2.5: VUK — emsal bedel
- S2.6: KVK — tasfiye beyannamesi süresi
- S2.7: VUK — vergi ziyaı cezası zamanaşımı
- S2.8: AAT — ödeme emrine karşı dava süresi
- S2.9: AAT — tahsil zamanaşımını kesen haller (hangisi değildir)
- S2.10: KVK — 5/1-h yurt dışı iştirak istisnası + KKEG, KV hesabı
- S2.11: KVK — örtülü sermaye (ortaktan/bankadan borç)
- S2.12: KVK — finansman gider kısıtlaması hesabı
- S2.13: KVK — dar mükellef iş yeri / şube vergilendirmesi
- S2.14: GVK — geçici vergi (yanlış olan)
- S2.15: KDV — ihraç kaydıyla teslim, indirim, iade hesabı
- S2.16: DIG — MTV istisnası (hangisi değildir)
- S2.17: DIG — ÖTV (II) sayılı liste ilk iktisap
- S2.18: VUK — izaha davet, yetersiz izah
- S2.19: KDV — KDV'nin konusuna giren hizmet
- S2.20: DIG — Emlak Vergisi, yeni yapılan konut

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| KVK Kurumlar vergisi | 9 | 22.5% | 22 | 103 (22.4%) | yaml uyumlu; banka uyumlu |
| GVK Gelir vergisi | 7 | 17.5% | 20 | 85 (18.5%) | yaml uyumlu; banka uyumlu |
| KDV KDV | 7 | 17.5% | 18 | 86 (18.7%) | yaml uyumlu; banka uyumlu |
| VUK Vergi usul | 5 | 12.5% | 15 | 73 (15.9%) | yaml uyumlu; banka sınırda (+3.4) |
| AAT 6183 Amme alacakları | 4 | 10.0% | 10 | 48 (10.5%) | yaml uyumlu; banka uyumlu |
| DIG ÖTV, Damga, VİV, MTV, Emlak | 6 | 15.0% | 15 | 64 (13.9%) | yaml uyumlu; banka uyumlu |
| okunamadı | 2 | 5.0% | - | - | konu atanamadı |
| **toplam** | 40 | 100% | 100 | 459 | |

Yorum: yaml ve resmî dağılım örtüşüyor; 2 sorunun kökü okunamadı (VER 1.18, 2.1). Bankada GVK %18,5, KVK %22,4, KDV %18,7, VUK %15,9, AAT %10,5, DIG %13,9: dağılım dengeli. Sorun içerik/format düzeyinde.

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: **fikir ve sanat eseri (GVK 18/ senaryo yazarlığı) + temettü tevkifat/beyan** (S1.1), **dar mükellef iş yeri/şube vergilendirmesi** (S2.13, KVK dar mükellefiyet), **yurt dışı kazanç mahsubu** (S2.2) yaml kazanımlarında açık yok ama GVK/KVK içinde değerlendirilebilir; **MTV istisnası ve Emlak (yapı kullanma izni)** DIG kazanımında yazılı.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=39 ayrıştırılan soru): kök karakter medyan/ort/p90 = 289/366/649; şık ort. 64; olumsuz kök %36; sayısal vaka (kökte ≥2 tutar) %46.

**Resmî format**: Hesaplama yaklaşık 15/40 (%37): uzun vaka (kök p90 649, bir KDV vakası 983 karakter), ortak gelir vergisi tarifesi sayfa başında verilip birden çok soruya kullanılıyor (S1.1-S1.3). Şıklar sayısal sorularda **tümü artan sırada** (14/14), aritmetik dizi 0/14. Teorik sorular "NNNN sayılı X Kanunu'na göre ... hangisi yanlıştır/değildir" kalıbında; **olumsuz kök %36**; boşluk doldurma (süreler) 1-2; **madde numarası kökte neredeyse yok** (1 kez, "5520 KVK 5/1-h"). Para birimi ₺, kuruş yok. Konu dağılımı yaml ile aynı (KVK 9, GVK 7, KDV 7, DIG 6, VUK 5, AAT 4).

**Banka (459 soru)**: kök medyanı 233 (resmî 289); hesaplama 55 (%12; resmî ~%37); olumsuz %12 (resmî %36); madde numarası **138/459 (%30)** köklerde (ör. "6183 md. 102", "KVK md. 32/B"); "TL" 108 kök, ₺ yok; öncüllü %7,8; sayısal şık 97 soruda: artan 79 (%81, resmî %100), aritmetik dizi 10 (%10); doğru şık en uzun **178/288 (%62)** (resmî 1/23 = %4); yanlış şıkların %26,3'ü mutlak ifade (resmî %2,7); örnekte absürt çeldiriciler ("KDV'yi belediye öder", "ÖTV'de kanuna ekli listeler bulunmaz"); yakın kopya sorular (VER-KVK-0045 ve VER-KVK-0062: aynı KVK 32/B sermaye azaltımı sorusu).

**Farklar / düzeltilecekler**
- Hesaplama payı %12 → ~%35; uzun vaka + tarife/parametre verilmiş format (GVK tarife, KV asgari %10, finansman gider kısıtlaması, 5/1-h, KDV aylık hesap, örtülü sermaye) artırılmalı. Mevcut hesaplama soruları çoğunlukla kısa.
- Kökte madde numarası yazılmasın (kanun numarası + adı yeterli); "TL" yerine ₺.
- Olumsuz kök %12 → ~%35; sayısal şıklar mutlaka artan sırada, eşit aralıksız.
- Çeldiriciler makul olmalı (gerçek ikinci olasılık: yanlış oran, yanlış süre, yanlış madde kapsamı); mutlak ifade ve absürt şık kaldırılmalı.
- 4 `hesaplama` türü vaka kalıbı: tarife-tabanlı GVK (ücret + kira + temettü, istisna), KV (iştirak, binek oto, finansman gideri, sermaye artırımı), KDV (ihraç kaydı + iade), emlak/MTV nadir.

## 7. 6) Hukuk (HUK)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: SGK — GSS bakmakla yükümlü olunan kişiler (hangisi değildir)
- S1.2: ISH — deneme süresi TİS ile uzatma
- S1.3: BRC — borcu sona erdiren haller (hangisi değildir)
- S1.4: BRC — haksız fiil/ sebepsiz zenginleşme zamanaşımı
- S1.5: IYU — ilk inceleme (hangisine bakılmaz)
- S1.6: IYU — kararın uygulanma süresi
- S1.7: SGK — ilk işyeri bildirgesi, sigortalı bildirimi süresi
- S1.8: SGK — iş kazası/hastalık/analık hakları (hangisi değildir)
- S1.9: ISH — toplu işçi çıkarma bildirimi (kime)
- S1.10: TIC — ticari davalarda görevli mahkeme (TTK md.5)
- S1.11: ISH — farklı zamanaşımına tabi alacak
- S1.12: ISH — süt izni
- S1.13: SGK — sigortasız çalıştırma yaptırımı (boşluk)
- S1.14: SGK — idari para cezaları (yanlış olan)
- S1.15: SGK — denetim ve kontrole engel olamama (alıntı) / öncüllü olabilir
- S1.16: BRC — (k) borç kaynakları öncüllü (I-IV), kök kısmen okunabildi
- S1.17: BRC — taksitle satış (yanlış olan)
- S1.18: YOK — OKUNAMADI: öncüllü (I-V şirket türleri?), kök çıkarılamadı
- S1.19: TIC — zayi kıymetli evrakta başvuru mercii
- S1.20: IYU — kanun yolları (hangisi yer almaz)
- S2.1: ISH — yeni iş arama izni (yanlış olan)
- S2.2: ISH — altıncı gün çalışma süresi (md.63)
- S2.3: ISH — telafi çalışması (yanlış olan)
- S2.4: ISH — yönetmelik çıkarma yetkisi
- S2.5: BRC — 5 yıllık zamanaşımı alacaklar (hangisi değildir)
- S2.6: BRC — açıklamada yanılma (md.31)
- S2.7: BRC — müteselsil borç
- S2.8: BRC — genel zamanaşımı süresi
- S2.9: TIC — elektronik imza ile düzenlenemeyen evrak
- S2.10: TIC — emre yazılı kıymetli evrak devri
- S2.11: TIC — taşıma işi geç teslim zamanaşımı
- S2.12: TIC — haksız rekabet / ticari uygulamalar
- S2.13: SGK — ücret tanımı (3/12, 4/a ve 4/c)
- S2.14: SGK — 4. ve 5. maddeye göre sigortalı sayılanlar
- S2.15: SGK — 4/a kapsamı dışı
- S2.16: SGK — sigorta kolları (hangisi değildir)
- S2.17: IYU — dava açma süreleri
- S2.18: IYU — posta ücretinin tamamlanması (vergi mahkemesi)
- S2.19: IYU — kararların sonuçları (Danıştay, BİM, yürütmenin durdurulması)
- S2.20: IYU — MEB/ÖSYM sınavlarına dava açma süresi

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| SGK Sosyal güvenlik (5510) | 10 | 25.0% | 25 | 105 (24.8%) | yaml uyumlu; banka uyumlu |
| ISH İş hukuku | 8 | 20.0% | 20 | 81 (19.1%) | yaml uyumlu; banka uyumlu |
| BRC Borçlar hukuku | 8 | 20.0% | 20 | 85 (20.0%) | yaml uyumlu; banka uyumlu |
| TIC Ticaret hukuku | 6 | 15.0% | 17.5 | 78 (18.4%) | yaml uyumlu; banka sınırda (+3.4) |
| IYU İdari yargılama | 7 | 17.5% | 17.5 | 75 (17.7%) | yaml uyumlu; banka uyumlu |
| okunamadı | 1 | 2.5% | - | - | konu atanamadı |
| **toplam** | 40 | 100% | 100 | 424 | |

Yorum: yaml ve banka resmîyle uyumlu (SGK en büyük; dönem 2'de her konudan tam 4 soru). 1 soru okunamadı.

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: 5510 md.3/12 ücret tanımı, md.8 bildirim süreleri SGK'de var; **süt izni, yeni iş arama izni** ISH'ta (izinler) var; **kıymetli evrakta zayi, elektronik imza ile düzenlenemeyen evrak** TIC'de var; **taşıma işi zamanaşımı** TIC kazanımında "taşıma" olarak var.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=38 ayrıştırılan soru): kök karakter medyan/ort/p90 = 162.5/186/268; şık ort. 45; olumsuz kök %37; sayısal vaka (kökte ≥2 tutar) %3.

**Resmî format**: Hesaplama yok (S2.2 süre hesabı hariç). Köklerde "NNNN sayılı X Kanunu'na göre" ön eki, kısa kök (medyan 163, p90 268), **olumsuz kök %37**, süre/sayı soruları ("kaç ay/yıl/gün"), öncüllü ≥2 (S1.16, S1.18), boşluk doldurma 1 (S1.13), alıntı + "hangisi" 2-3. Madde numarası kökte 6 yerde (md.14, md.8/b, md.63 vb.; ~%15). Dönem 2 tam 4x5 dengeli (ISH, BRC, TIC, SGK, IYU hepsi 4). Şıklarda mutlak ifade yok (%3,4).

**Banka (424 soru)**: kök medyanı 230 (resmî 163: bankanınki daha uzun); olumsuz %15 (resmî %37); hesaplama yok (uyumlu); öncüllü %9,9 (≥2/40=5%); madde numarası **129/424 (%30)**; senaryolu "Bay (İ) ... işçi" vakaları (uzun); doğru şık en uzun **156/279 (%56)** (resmî 4/21 = %19); yanlış şıkların %22,4'ü mutlak ifade (resmî %3,4). Konu dağılımı resmî ile uyumlu (SGK 105 = %24,8; yaml 25).

**Farklar / düzeltilecekler**
- Olumsuz kök %15 → ~%37; süre/sayı ("kaç gün/yıl/ay/saat") soruları artırılmalı (resmî ~12/40), her şıkta sade süre; kök kısaltılmalı (medyan ~160).
- Madde numarası %30 → ≤%10; senaryo ağırlığı azaltılmalı (resmî neredeyse yalnız mevzuat bilgisi).
- Doğru şık uzunluğu ve mutlak ifade ipuçları giderilmeli; İdari Yargılama ve Borçlar'da zamanaşımı/süre sorularının çeldiricileri gerçek yasal süreler (30/60/15 gün) olmalı.

## 8. 7) Muhasebecilik ve Mali Müşavirlik Meslek Hukuku (MES)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: ETK — kişisel çıkar tehdidi örneği (Ek-1)
- S1.2: CUE — meslek onuru ile bağdaşmayan haller (hangisi değildir)
- S1.3: KAN — Odaların gelirleri (hangisi değildir)
- S1.4: DIS — Oda Disiplin Kurulu kararına itiraz süresi
- S1.5: ETK — temel etik ilkeler (hangisi değildir)
- S1.6: HRK — reklam yoluyla haksız rekabet halleri
- S1.7: KAN — Odaların organları (hangisi değildir)
- S1.8: CUE — sözleşme asgari bilgileri (hangisi değildir)
- S1.9: ETK — 5 temel tehdit sınıflaması
- S1.10: ETK — önlemlerin iki büyük grubu
- S1.11: KAN — meslek mensubu olma genel şartları (hangisi değildir)
- S1.12: HRK — ücret ve mali uygulamalarda haksız rekabet
- S1.13: DGR — Sınav Yönetmeliği (sınav hakkı süreleri, boşluk)
- S1.14: DGR — SMGE Yönetmeliği (kredi şartları, öncüllü)
- S1.15: DIS — uyarma cezası uygulanan haller
- S1.16: DGR — TÜRMOB Birliği Yönetmeliği: gelirler
- S1.17: DGR — TÜRMOB Genel Kurulu görevleri
- S1.18: DGR — Odalar Yönetmeliği: oda kurma asgari üye sayısı
- S1.19: CUE — ticari faaliyette bulunamama (yanlış olan)
- S1.20: DGR — Odalar Yönetmeliği: Yönetim Kurulu üye sayısı
- S2.1: DGR — Ücretlerin Esasları Yönetmeliği (yanlış olan)
- S2.2: CUE — işyeri açılış/kapanış bildirimi (boşluk)
- S2.3: CUE — ruhsat sonrası staj yaptırma yasağı süresi
- S2.4: CUE — sözleşme feshinde defter-belge iadesi süresi
- S2.5: DGR — Oda Genel Kurulu toplanma
- S2.6: DGR — Birliğin organları (hangisi değildir)
- S2.7: DGR — Staj Yönetmeliği: stajdan sayılan haller (yanlış olan)
- S2.8: HRK — meslek mensupları/iş sahipleri ilişkisinde haksız rekabet
- S2.9: HRK — reklam kuralları (öncüllü I-III)
- S2.10: ETK — tehditler (hangisi değildir)
- S2.11: ETK — tarafsızlık ilkesi tanımı
- S2.12: DIS — geçici olarak faaliyetten alıkoyma süresi
- S2.13: DIS — asgari ücret tarifesi altı iş kabulü cezası
- S2.14: KAN — özel şartlar (hangisi değildir)
- S2.15: DGR — Sınav Yönetmeliği: not şartları (boşluk)
- S2.16: DGR — SMGE yükümlülüğü
- S2.17: KAN — Birlik Yönetim Kurulu üye sayısı
- S2.18: DIS — (k) disiplin cezaları, hangileri Bakanlığa bildirilir (öncüllü I-IV, kısmen okunabildi)
- S2.19: KAN — ilçede oda kurma asgari üye
- S2.20: KAN — giriş ücreti/aidat tespiti, hangi organın görevi

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| KAN 3568 sayılı Kanun | 7 | 17.5% | 17.5 | 67 (18.8%) | yaml uyumlu; banka uyumlu |
| ETK Etik İlkeler Yön. | 6 | 15.0% | 15 | 55 (15.4%) | yaml uyumlu; banka uyumlu |
| CUE Çalışma Usul ve Esasları | 6 | 15.0% | 15 | 56 (15.7%) | yaml uyumlu; banka uyumlu |
| DIS Disiplin Yön. | 5 | 12.5% | 12.5 | 38 (10.6%) | yaml uyumlu; banka uyumlu |
| HRK Haksız Rekabet ve Reklam | 4 | 10.0% | 10 | 36 (10.1%) | yaml uyumlu; banka uyumlu |
| DGR Diğer yönetmelikler | 12 | 30.0% | 30 | 105 (29.4%) | yaml uyumlu; banka uyumlu |
| **toplam** | 40 | 100% | 100 | 357 | |

Yorum: yaml ve banka resmîyle uyumlu (DGR en büyük %30). DIS resmî 5 (%12,5; yaml 12,5; S2.18 kısmen okunabildi).

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: SMGE kredisi (S1.14, S2.16), Sınav not şartları (S1.13, S2.15), Staj Yönetmeliği stajdan sayılan haller (S2.7) DGR'de yazılı. Disiplin cezalarının duyurulması/bildirimi (S2.18) DIS'te yazılı.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=39 ayrıştırılan soru): kök karakter medyan/ort/p90 = 239/262/434; şık ort. 40; olumsuz kök %54; sayısal vaka (kökte ≥2 tutar) %0.

**Resmî format**: Tamamen ezber; **olumsuz kök %54**; "hangisi ... değildir" listeleri, süre/sayı, kurul adı; boşluk doldurma ~4-5 (S1.13, S1.14 öncüllü sürelerle, S2.3, S2.4, S2.15); öncüllü ≥4 (S1.14, S2.9, S2.18, S1.13). Madde numarası yok. Kök orta (medyan 239), şıklar kısa (ortalama ~40). Yönetmelik adları kökte tam yazılıyor ("Serbest Muhasebeci Mali Müşavirlik ve Yeminli Mali Müşavirlik Kanunu Disiplin Yönetmeliği'ne göre"). Mutlak ifade yok.

**Banka (357 soru)**: kök medyanı 209 (resmî 239); **şıklar uzun** (ortalama 66 vs resmî 40; bankada tam cümle/senaryo); olumsuz %18 (resmî %54); boşluk doldurma %1 (resmî %10); öncüllü %11,5 (uyumlu); senaryolu vakalar ("Bir SMMM'nin işyeri adresi 5 Mart 2026'da değişmiş...") resmîde yok; doğru şık en uzun 161/280 (%58) (resmî 7/19 = %37); yanlış şıkların %25,3'ü mutlak ifade (resmî %0). 82 kökte markdown kalın işaret.

**Farklar / düzeltilecekler**
- Olumsuz kök %18 → ~%50; boşluk doldurma (süre, sayı) %1 → ~%10; sade ezber formatı (süre/sayı/kurul adı/hangisi değildir listesi); senaryolu vakaları azaltın (özellikle DGR, CUE).
- Şıkları kısaltın (ortalama ~40 karakter), Etik tehdit/önlem sorularında liste mantığını koruyun.
- `DGR` (Odalar/TÜRMOB/Sınav/Staj/SMGE/Ücret) banka %29,4 ve resmî %30: uygun; DGR içinde Odalar Yönetmeliği ve Birlik Yönetmeliği ağırlıklı (resmî 6/12) — alt dağılım izlenmeli.

## 9. 8) Sermaye Piyasası Mevzuatı (SPK)

### 1) Soru-konu eşlemesi (S<dönem>.<soru no>)

- S1.1: IZA — izahnamede değişiklik/yeni husus bildirimi
- S1.2: HAO — ilişkili taraf işlemleri tevsik
- S1.3: HAO — (k) yatırım ortaklığı niteliği/bağlı ortaklık payı satışı, ayrılma hakkı (öncüllü, kısmen okunabildi)
- S1.4: ALT — teminat yönetim sözleşmesi ve teminat yöneticisi (yanlış olan)
- S1.5: IZA — kamuyu aydınlatma belgelerinden doğan sorumluluk (yanlış olan)
- S1.6: YEN — kripto varlık hizmet sağlayıcı yönetim kurulu şartları
- S1.7: HAO — (k) kâr payı avansı (öncüllü, kısmen okunabildi)
- S1.8: KYK — yatırım ortaklıklarının kuruluş şartları (yanlış olan)
- S1.9: YHZ — (k) yatırım hizmet/faaliyetleri sınıflaması (öncüllü I-V, kısmen okunabildi)
- S1.10: KYK — yatırım fonları (yanlış olan)
- S1.11: SUC — SPK suçlarına bakacak ihtisas mahkemesi (boşluk)
- S1.12: KYK — fon mal varlığının ayrılığı (yanlış olan)
- S1.13: KYK — portföy saklama kapsamı dışı
- S1.14: YHZ — yükümlülüğü yerine getirememe, Kurul tedbiri/tazmin (alıntı)
- S1.15: KYK — para piyasası fonu tanımı (Yatırım Fonları Tebliği)
- S1.16: SUC — (k) piyasa bozucu eylem (öncüllü, kısmen okunabildi)
- S1.17: SUC — inceleme sırasında Kurulun tedbirleri
- S1.18: IZA — izahname muafiyetleri (yanlış olan)
- S1.19: YEN — kira sertifikası tanımı
- S1.20: ALT — sistemik risk, veri depolama/bilgi talebi (alıntı)
- S2.1: IZA — (k) izahname sorumluluğu (öncüllü, kısmen okunabildi)
- S2.2: HAO — kayıtlı sermaye sistemi (alıntı)
- S2.3: YHZ — (k) yatırım hizmet/faaliyetleri sınıflaması (öncüllü I-IV, kısmen okunabildi)
- S2.4: HAO — halka açık ortaklığın borsaya başvuru süresi
- S2.5: HAO — genel kurul çağrı süresi
- S2.6: YEN — kitle fonlaması (yanlış olan)
- S2.7: YHZ — (k) müşteri nakitlerinin korunması (öncüllü, kısmen okunabildi)
- S2.8: KYK — değişken sermayeli yatırım ortaklıkları (yanlış olan)
- S2.9: HAO — Özel Durumlar Tebliği: içsel bilgi erteleme (yanlış olan)
- S2.10: SUC — Kurul personeli denetimi (yanlış olan)
- S2.11: SUC — kripto varlık zimmet suçu, görevli mahkeme (sınırda: YEN de olabilir)
- S2.12: SUC — idari para cezaları (yanlış olan)
- S2.13: ALT — borsa ve piyasa işleticileri (yanlış olan)
- S2.14: YHZ — tazmin talebi zamanaşımı
- S2.15: HAO — Birleşme ve Bölünme Tebliği: bölünme tanımı
- S2.16: SUC — piyasa dolandırıcılığı (işlem bazlı)
- S2.17: SUC — Kurul tedbirleri (aykırı durum tespiti)
- S2.18: IZA — halka arz satış yöntemleri (hangisi değildir)
- S2.19: YOK — OKUNAMADI: kök çıkarılamadı (öncüllü, I. Çıkarılmış sermaye... parçası görüldü)
- S2.20: ALT — takas/merkezi saklama kuruluşu (alıntı)

### 2) Ağırlık tablosu

| konu | resmî adet (40) | resmî pay | yaml agirlik.yet | banka YET kontrolde (pay) | hüküm |
|---|---|---|---|---|---|
| HAO Halka açık ortaklıklar | 8 | 20.0% | 20 | 37 (19.3%) | yaml uyumlu; banka uyumlu |
| SUC Suçlar, idari yaptırımlar, tedbirler | 8 | 20.0% | 20 | 34 (17.7%) | yaml uyumlu; banka uyumlu |
| KYK Kolektif yatırım kuruluşları | 6 | 15.0% | 15 | 30 (15.6%) | yaml uyumlu; banka uyumlu |
| IZA İzahname ve halka arz | 5 | 12.5% | 12.5 | 23 (12.0%) | yaml uyumlu; banka uyumlu |
| ALT Piyasa altyapıları | 4 | 10.0% | 10 | 22 (11.5%) | yaml uyumlu; banka uyumlu |
| YEN Kripto, kitle fonlaması, tanımlar | 3 | 7.5% | 10 | 19 (9.9%) | yaml uyumlu; banka uyumlu ; stok az (<20) |
| YHZ Yatırım hizmetleri ve tazmin | 5 | 12.5% | 12.5 | 27 (14.1%) | yaml uyumlu; banka uyumlu |
| okunamadı | 1 | 2.5% | - | - | konu atanamadı |
| **toplam** | 40 | 100% | 100 | 192 | |

Yorum: yaml ağırlıkları resmî dağılımı yansıtıyor (HAO 8, SUC 8, KYK 6, IZA 5, YHZ 5, ALT 4, YEN 3, +1 okunamadı). YEN yaml 10 / resmî 7,5 (2,5 puan fark, gürültü).

### 3) YOK (müfredatta karşılığı olmayan) konular

Konu düzeyinde YOK yok. Alt kazanım: **Özel Durumlar Tebliği içsel bilgi erteleme** (S2.9) HAO'da "özel durumlar" olarak var; **Birleşme ve Bölünme Tebliği** HAO'da var; **Yatırım Fonlarına İlişkin Esaslar (para piyasası fonu tanımı)** KYK'da var; **kripto varlıkta zimmet suçu** (S2.11) SUC/YEN sınırı.

### 4) Stil karşılaştırması

Ölçüm özeti (resmî n=32 ayrıştırılan soru): kök karakter medyan/ort/p90 = 190/243/409; şık ort. 84; olumsuz kök %56; sayısal vaka (kökte ≥2 tutar) %3.

**Resmî format**: En yüksek öncüllü oran: SPK **8/40 (%20)** ve boşluk doldurma ~4/32 (%12); **olumsuz kök %56**; uzun şıklar (ortalama ~84 karakter), alıntı-cümle tamamlama ("... ihtisas mahkemesi ... yetkilidir"), sayı/süre soruları (kaç yıl/gün/ne kadar süre) ~6/40; tebliğ adları (Özel Durumlar, İzahname ve İhraç Belgesi, Birleşme ve Bölünme, Satışı Tebliği, Yatırım Fonları Esasları) 6-7 soruda. Mutlak ifade yok (%0,8). Kök medyanı 190.

**Banka (192 soru)**: kök medyanı 213, şık ortalaması 78 (uyumlu); olumsuz %17 (resmî %56); öncüllü %9,9 (resmî %20); boşluk doldurma %0 (resmî ~%12); doğru şık en uzun **118/158 (%75)** (resmî 4/21 = %19); yanlış şıkların %47,8'i mutlak ifade (resmî %0,8) — en yüksek oran; senaryolu vakalar ("Bir portföy yönetim şirketinin üçüncü kişiye olan borcu...") resmîde yok. Konu dağılımı resmî ile uyumlu. Cevap anahtarı: bankada C/D %22,9, E %24,5, A %15,1.

**Farklar / düzeltilecekler**
- Olumsuz kök %17 → ~%55; öncüllü %10 → ~%20 (I/II/III + "Yalnız I, I ve III..."); boşluk doldurma ~%12 (Kanun alıntısı + "----"); tebliğ adı kökte tam yazılsın.
- Mutlak ifade ve en uzun doğru şık sorunu en şiddetli burada; çeldiriciler aynı cümle yapısında tek unsuru (süre, oran, merci) değiştirilmiş olmalı.
- Stok: toplam 192 (düşük), özellikle ALT (22), YEN (19), IZA (23), YHZ (27) konuları zayıf; resmî ALT 4, YEN 3, IZA 5, YHZ 5 soru.

## 10. Cevap anahtarı (A-E) dağılımı

**Resmî (A kitapçığı), ders x 2 dönem = 40 soru:**

| ders | A | B | C | D | E |
|---|---|---|---|---|---|
| FIN | 10 | 8 | 8 | 7 | 7 |
| TAB | 7 | 9 | 9 | 9 | 6 |
| MAL | 7 | 8 | 9 | 7 | 9 |
| DEN | 10 | 7 | 7 | 8 | 8 |
| VER | 10 | 8 | 7 | 7 | 8 |
| HUK | 9 | 8 | 8 | 7 | 8 |
| MES | 9 | 8 | 8 | 7 | 8 |
| SPK | 9 | 7 | 8 | 7 | 9 |
| **toplam (320)** | 71 | 63 | 64 | 59 | 63 |

Her testte (20 soru) harf başına 3-5 doğru cevap var (örn. FIN 1: A5 B4 C4 D4 E3; 16 testin hepsi 3-5 aralığında); yani resmî testler **kitapçık içinde dengelenmiş**. 6 soru İPTAL edildi: 1_02 S18, 1_06 S7, 1_07 S1, 2_02 S6, 2_04 S11, 2_06 S7 (TAB 2 [iki grafik sorusu], HUK 2, DEN 1, MES 1).

**Banka (durum: kontrolde, bolum YET):**

| ders | n | A | B | C | D | E | chi2 (df=4) | değerlendirme |
|---|---|---|---|---|---|---|---|---|
| FIN | 305 | 97 | 72 | 58 | 37 | 41 | 39.4 | p<0,001 (çarpık) |
| TAB | 107 | 9 | 20 | 38 | 26 | 14 | 23.7 | p<0,001 (çarpık) |
| MAL | 225 | 52 | 53 | 52 | 32 | 36 | 9.2 | dengeli |
| DEN | 419 | 79 | 74 | 65 | 93 | 108 | 13.6 | p<0,01 (çarpık) |
| VER | 459 | 84 | 129 | 109 | 82 | 55 | 34.8 | p<0,001 (çarpık) |
| HUK | 424 | 67 | 95 | 78 | 99 | 85 | 7.9 | dengeli |
| MES | 357 | 71 | 59 | 46 | 86 | 95 | 22.0 | p<0,001 (çarpık) |
| SPK | 192 | 29 | 28 | 44 | 44 | 47 | 8.7 | dengeli |
| **toplam** | 2488 | 488 | 530 | 490 | 499 | 481 | 3.0 | genel dengeli |

Not: Genel toplam dengeli ama **ders içinde** FIN (A %31,8; D %12,1), VER (B %28,1; E %12,0), TAB (C %35,5; A %8,4), MES (E %26,6; C %12,9) belirgin çarpık; kritik değerler df=4 için 9,49 (p=0,05), 13,28 (p=0,01), 18,47 (p=0,001). Konu düzeyinde de çarpıklık var (FIN-DON: A16 B9 C3 D2 E3; FIN-MKY: A19 B13 C5 D3 E5; TAB-DIK: C16/34; DEN-KNT: E12/30; MES-ETK: E22/55). Öğrenci "A/E'ye eğilim" veya "ortada C" ezberi yapabilir; sayısal sıralı şıklarda doğru şık yerleşimi (ör. TAB'da C) sistematik. Düzeltme: üretim sonrası şık permütasyonu (sayısal şıklar artan sırada kalmak kaydıyla yanlış şıkları rastgele ortalayan dağıtım) ve test başına 4x5 dengesi.

## 11. Düzeltme öncelikleri (somut)

1. **Uzunluk/mutlak ifade ipuçları**: Bankada doğru şık en uzun %62 (resmî %24); yanlış şıkların %31'i mutlak ifade (resmî %1,5). Tüm sözel derslerde (DEN %77/%42, SPK %75/%48, HUK, MES, VER) yeniden yazım veya otomatik şık uzunluk dengeleme + mutlak ifade temizliği.
2. **Olumsuz kök oranı**: DEN %14→44, VER %12→36, HUK %15→37, MES %18→54, SPK %17→56 (FIN %11→5, TAB %9→2 azaltılmalı).
3. **Sözel derslerde resmî kalıp**: DEN: BDS numarasız, (i)(ii)(iii) boşluk, uzun cümle şıkları; SPK: öncüllü %20 + boşluk doldurma + alıntı; MES: sade süre/sayı/kurul ezberi; HUK/VER: madde numarasız, "NNNN sayılı ... Kanunu'na göre" ön eki. Eşleştirme, sıralama ve uzun senaryo formatlarını bırakın.
4. **Hesaplama dersleri**: TAB ortak veri setli sorular (17-20); MAL hesaplama %32→%55 ve ORT/SAF/SIP/ZincirTablo; VER hesaplama %12→%35 uzun vaka+tarife. Sayısal şıklar artan sırada, aritmetik dizi yok, ₺ kullan.
5. **Biçim temizliği**: ** kalın işaret (FIN 30, TAB 25, MAL 23, DEN 48, VER 40, HUK 43, MES 82, SPK 19 kök), markdown tablo (TAB 14), "TL" yerine ₺, "BOBİ FRS" (FIN 37), "kaynak metne göre" (5).
6. **Konu dengesi**: MAL TBL/SIP/ORT/SAF yeniden etiket+üretim; TAB TMS fazlası dengelenmeli, DVR ve KAR artırılmalı; DEN RSK, KAL artırılmalı, PRG YET'ten çıkarılmalı; FIN ALC artırılmalı.
7. **Cevap harfi dağılımı**: FIN, VER, TAB, MES, DEN'de ders içi permütasyonla düzelt.
8. **yaml notları**: DEN notu ("BDS numarası ve adı açıkça yazılır") 2026'da 0 sorudur; TAB grafik notu ("üçü de iptal") 2026'da 2/3; VER/HUK/SPK notları (hesaplama %30, SPK öncüllü %20) doğrulandı.
