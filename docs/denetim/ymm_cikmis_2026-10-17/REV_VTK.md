# YMM Çıkmış Sorular Analizi: Revizyon (05 → REV) ve Vergi Tekniği (06 → VTK)

Kapsam: `content/kaynaklar/cikmis/ymm/ymm_<YIL>_<DÖNEM>_05|06.txt`, 2022/1–2026/1 (13 dönem × 2 ders = 26 dosya). Hepsi okunabildi (UTF-8). Müfredat: `content/mufredat/ymm.yaml` (REV, VTK). Anlatım: `content/anlatim/ymm/REV|VTK/*.md`.

## 0. Yöntem ve sınırlar (önce okuyun)

- **Dosyaların hepsi "SINAV KOMİSYONU CEVAPLARI", yani cevap anahtarı.** REV dosyalarının hiçbirinde soru metni yok. Olay, cevaptaki "Soruda yer verilen…" cümlelerinden ve atıf yapılan mevzuattan çıkarıldı. VTK'da soru metni yalnız **2025/1** dosyasında var. 2025/2, 2025/3 ve 2026/1'de ise "İstenenler" bentleri cevabın içinde tekrar ediliyor.
- Soru sınırları "YANIT n", "Cevap n", "CEVAP n" ve "n. Sorunun cevapları" başlıklarından otomatik ayrıldı, sonra elle kontrol edildi. Her soru için mevzuat atıfları regex ile sayıldı. Özetler, cevabın ilk paragrafından ve atıf sıklığından çıkarıldı. **Uzun cevapların her satırı okunmadı.** Bu yüzden tek satırlık özetler, sorunun ana konusunu verir. Alt işlemlerin hepsini listelemez.
- Puanlar:
  - REV 2022/1–2023/1: soru puanı yok.
  - REV 2023/2–2024/3: her yanıtın başında "(x puan)" var. Toplamlar 100'ü tutuyor.
  - REV 2025/1–2025/3: soru puanı yok. Tek istisna 2025/2 C10, "(Puan değeri 23)".
  - REV 2026/1: yalnız mikro puanlar var. Soru toplamları bunlardan türetildi ve **yaklaşıktır**: başlık puanları ile alt puanlar çift sayılmış olabilir.
  - VTK 2022/1–2023/2: puan yok.
  - VTK 2023/3, 2024/1, 2024/2 ve 2025/1 (soru metnindeki puanlar): kesin puan var.
  - VTK 2024/3, 2025/2, 2025/3 ve 2026/1: mikro puan toplamı (**≈**, yaklaşık).
- Belirsiz noktalar, ilgili satırda **[belirsiz]** ile işaretlendi.
- Eşleştirme sütunu: yaml'daki konu kodu ve kazanım. "YOK" = yaml'da karşılığı yok. "(p)" = kısmi karşılık. Parantez içindeki önerilen etiketler (IST, ULU vb.) bölüm 3'te tanımlı.

---

## 1. Soru soru döküm

### 1A. REVİZYON (05) — yaml REV

Kısaltmalar: IST = KV istisnaları (KVK 5), ULU = dar mükellef, ÇVÖA ve tevkifat, IND = KVK 10 indirimleri ve teşvikler, ORT = örtülü sermaye ve TF, GEC = geçici ve af düzenlemeleri, BDB = devir ve bölünme, MTR = matrah hesabı.

**2022/1** (7 soru, puan yok; cevaplar çok uzun, 30–100 bin karakter)

| # | Konu (tek satır) | Yasal dayanak | yaml eşleşme |
|---|---|---|---|
| 1 | Vergi sorumlusunun kestiği verginin mahsup ve iadesi; dar mükellefe lisans ve temettü ödemesinde tevkifat (ÇVÖA Finlandiya); fazla ödeme ve vergi hatası | VUK 8, 11, 116–126; KVK 30; GVK 94, mük.120 | YOK (ULU) |
| 2 | Tahvil ihracı ve iskonto: peşin faiz mi finansman gideri mi; menkul kıymet değerlemesi | TTK 504; VUK 279, 285; GVK 75, geç.67 | YOK (değerleme); GLR (p) |
| 3 | Varlık barışı: yurt dışı varlıkların bildirimi, ortaklar cari hesabı ile çıkış | GVK geç.93; KVK 20 | YOK (GEC) |
| 4 | Serbest bölge şube kazancı istisnası; merkez–şube transferleri; TF | 3218 SBK; KVK 13; KDVK 11–12 | YOK (IST/ORT) |
| 5 | Bağış ve yardım indirimi; ücret tevkifatı; emsal kira ve dar mükellefe kiralama faturası | KVK 10; GVK 61, 94, 103; VUK 236 | YOK (IND); GLR (p) |
| 6 | Birleşme, devir, bölünme ve hisse değişimi şartları | KVK 19, 20; KDVK 17/4-c | YOK (REV'de yok; yaml VTK.BDB) |
| 7 | Yurt dışı şube kazancı istisnası; ABD mukimi hizmet ödemesi, ÇVÖA; yurt dışı vergi mahsubu | KVK 5/1-g, 15, 30, 33 | YOK (IST/ULU) |

**2022/2** (7 soru, puan yok)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Örtülü sermaye: faiz ve kur farkı; borç verenin tam ya da dar mükellef olması; KDV | KVK 12; KDVK 4, 11 | PSF (p) "örtülü kazanç" / VTK.TFR |
| 2 | Foreks işlemleri kazancının vergilendirilmesi | GVK geç.67; KVK 6 | YOK |
| 3 | Dernek ve vakıf iktisadi işletmesi; kâr aktarımı ve tevkifat | GVK 94; KVK 2, geç.2 | YOK |
| 4 | Yurt dışı kurumlara ödemeler (ticari kazanç, serbest meslek, GMH, ücret): KV ve KDV tevkifatı, ÇVÖA | KVK 30; KDVK 9; GVK 40 | YOK (ULU) |
| 5 | Yurt dışından bedelsiz finansman temini; örtülü sermaye faizi ve kur farkının KDV ve KV'deki durumu | KVK 6, 12; KDVK 1, 9; VUK 324 | PSF/GLR (p) |
| 6 | Sponsorluk ve bağış indirimleri; KDV 17/2-b; damga vergisi | KVK 10/1-b,c,ç; KDVK 17/2-b | YOK (IND) |
| 7 | Özel okul kazanç istisnası (eski KVK 5/1-ı) | KVK 5 | YOK (IST) |

**2022/3** (7 soru, puan yok)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Varlık barışı (yurt dışı ve yurt içi varlıklar) | GVK geç.93; KVK geç.15 | YOK (GEC) |
| 2 | Yurt dışına ödemelerde tevkifat ve ÇVÖA | KVK 3, 15, 30; KDVK 9 | YOK (ULU) |
| 3 | Hizmet ihracatı indirimi; KDV ihracat istisnası ve iade | KVK 10/1-ğ; KDVK 11–13, 28–29; KDV tebliğleri | YOK; TAS (p, KDV iade) |
| 4 | Sayım fazlası ve noksanı; kıymeti düşen mallar | VUK 185–196, 267, 274, 278; KDVK | **AKT** ✓ stok sayımı ve değerlemesi |
| 5 | Ar-Ge ve tasarım indirimi; 5/B patent istisnası | KVK 5/B, 10/1-a; 5746 | YOK (yaml VTK.TSV) |
| 6 | Yabancı para avansların değerlemesi ve kur farkı | VUK 263, 272, 280 | AKT/GLR (p) |
| 7 | Royalti ve lisans ödemeleri ilişkili kişi TF; gümrük kıymeti; KDV | KVK 13; GVK 70 | PSF (p) / VTK.TFR |

**2023/1** (7 soru, puan yok)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Hisse senedi ihraç (emisyon) primi istisnası; yedek akçeler | KVK 5/1-ç; TTK 519 | PSF (p) sermaye |
| 2 | Kâr payı avansı dağıtımı; tevkifat | Kâr payı avansı tebliği; GVK 94 | PSF (p) |
| 3 | Yurt dışına ödemelerde tevkifat ve ÇVÖA | KVK 3, 30; GVK 18, 94 | YOK (ULU) |
| 4 | Stok sayım farkları ve kıymeti düşen mallar | VUK 274, 278; KDVK 17/4-g | **AKT** ✓ |
| 5 | Finansman gider kısıtlaması; yabancı para değerleme | KVK 11/1-i; VUK 280 | **GLR** ✓ kur farkı ve finansman giderleri |
| 6 | Kur korumalı TL'ye dönüşüm istisnası | KVK geç.14 | YOK (GEC) |
| 7 | 7326 sayılı Kanunla işletme kayıtlarının düzeltilmesi (kasa, ortaklardan alacak) | 7326; 346 VUK GT | AKT (p) kasa / YOK |

**2023/2** (puanlı; toplam 100)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 10 | Vergi hatası ve düzeltme; 7326 kapsamında yapılan işlem | VUK 116–126 | YOK |
| 2 | 15 | Binek otomobil gider ve amortisman kısıtlaması; KDV indirimi | GVK 40/1,5,7; KDVK 30; 163, 334 VUK GT | **GLR** ✓ KKEG |
| 3 | 10 | Yurt dışına ödemelerde tevkifat; damga vergisi | KVK 30; KDVK 9 | YOK (ULU) |
| 4 | 20 | İştirak kazancı istisnaları ve devir | KVK 5/1-a,b,c,e; KVK 19 | YOK (IST) |
| 5 | 10 | Grup içi vade farkı ve iştirak kazancı; örtülü sermaye | KVK 5/1-a, 12 | PSF (p) |
| 6 | 20 | Yurt dışı inşaat ve şube kazancı istisnaları; yurt dışı vergi mahsubu; zarar | KVK 5/1-g,h, 9, 33 | YOK (IST) |
| 7 | 15 | Şüpheli ve değersiz alacak; karşılık; KDV düzeltmesi | VUK 322–324; KDVK 29 | **AKT** ✓ alacak karşılıkları |

**2023/3** (puanlı; anahtar kısa: önce dayanak listesi, sonra sonuç)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 15 | Finansman gider kısıtlaması (CK 2019/1950); maliyete ekleme | KVK 11/1-i, 32, geç.9; VUK 262, 269 | **GLR** ✓ |
| 2 | 10 | Kazanç tespiti, fatura ve yabancı para değerleme; KDV matrahı | KVK 6; VUK 229–231, 280, 283; KDVK 24 | GLR (p) |
| 3 | 15 | Sponsorluk ve bağış indirimleri; sporcu ücreti (GVK geç.72) | KVK 10/1-b,c,ç,d; GVK 29, geç.72; KDVK 17/2 | YOK (IND) |
| 4 | 10 | Dar mükellef KV kesintisi; KDV sorumluluğu; damga vergisi | KVK 30; KDVK 9; DVK | YOK (ULU) |
| 5 | 10 | Varlık barışı; VUK 298/A-5 ve geç.25 kapsamındaki işlem **[belirsiz: alt işlem okunmadı]** | KVK geç.15, 5/1-j; VUK 298, geç.25 | YOK (GEC) |
| 6 | 20 | Taşınmaz yeniden değerlemesi; satış istisnası; KDV 17/4-r | VUK mük.298/Ç, geç.31, geç.32; KVK 5/1-e | AKT (p) duran varlık / VTK.DEG |
| 7 | 20 | TF ve örtülü sermaye; ücret ve kâr payı tevkifatı | KVK 12, 13, 11/1-i; GVK 94, 103 | PSF (p) |

**2024/1** (puanlı)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 15 | Dar mükellefe kira ve GMH ödemesi; ÇVÖA 12–14; TF | GVK 70, 75, 94; KVK 30; ÇVÖA | YOK (ULU) |
| 2 | 10 | Dar mükellef kesintisi; değerleme | KVK 30; VUK 262, 269, 274, 280; KDVK | YOK (ULU) / AKT (p) |
| 3 | 15 | İnternet reklam hizmeti ve sosyal içerik üreticisi ödemeleri: kesinti; şüpheli alacak | KVK 15, 30; GVK 94; VUK 323 | YOK (ULU) |
| 4 | 10 | Forward işlemleri; ilişkili kişiyle TF; damga vergisi | KVK 6, 13; DVK | YOK / PSF (p) |
| 5 | 10 | Ücret ve kâr payı vergilendirmesi | GVK 61, 75, 94/6, 103 | YOK |
| 6 | 10 | Değeri düşen mallar; KDV indirimi | VUK 278, 329; KDVK 17/4-g, 30/c | **AKT** ✓ |
| 7 | 30 | Taşınmaz ve iştirak satış istisnası (geç.16); yeniden değerleme; amortismanlı mal satışı; KDV geç.43 | KVK 5/1-e, geç.16; VUK 279, mük.298/Ç, 328, geç.32 | YOK (IST) / AKT (p) |

**2024/2** (puanlı)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 15 | Şirketin kendi paylarını iktisabı: kâr payı sayılması ve %0/%10 tevkifat | TTK 379–389; GVK 94; KVK 5/1-e | PSF (p) sermaye |
| 2 | 10 | Kısmi bölünme; KDV 17/4-c,r | KVK 19/3-b, 5/1-e | YOK (yaml VTK.BDB) |
| 3 | 15 | Spor kulübü iktisadi işletmesi; sponsorluk; reklam gideri | KVK 4/j, 10/1-b, 11; GVK geç.72 | YOK (IND) / GLR (p) |
| 4 | 10 | Taşınmaz satış istisnası geçiş hükmü; KDV geç.43 | KVK 5/1-e, geç.16; KDVK 17/4-r | YOK (IST) |
| 5 | 20 | Sporcu ücretleri; sponsorluk | GVK 61, geç.72; KVK 10/1-b | YOK |
| 6 | 20 | Yurt dışı kulüp ve sporcu ödemeleri: dar mükellef; KDV; damga vergisi | KVK 30; KDVK 9; GVK 96 | YOK (ULU) |
| 7 | 10 | Yurt dışı iştirak kazancı istisnası; yurt dışı vergi mahsubu | KVK 5/1-b, 33 | YOK (IST) |

**2024/3** (puanlı)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 15 | Bedelsiz hisse; menkul kıymet değerlemesi; satış istisnası; TF | VUK 279, 288; GVK geç.67; KVK 5/1-e, 13 | AKT (p) / YOK |
| 2 | 10 | Girişim sermayesi fonu indirimi | KVK 10/1-g, 5/1-a; VUK 325/A | YOK (IND) |
| 3 | 20 | Yabancı çalışan ücreti; dar mükellef; KDV sorumlusu | GVK 61, 94, 96, 103; KVK 30 | YOK (ULU) |
| 4 | 10 | Taşınmaz satış istisnası; KDV; BSMV | KVK 5/1-e, geç.16; KDVK 17/4-r; GiderVK 28 | YOK (IST) |
| 5 | 15 | Dar mükellef hizmet ödemesi; hizmet ihracı; KDV matrah değişikliği | KVK 30; KDVK 6, 9, 11, 35 | YOK (ULU) |
| 6 | 10 | Personel giderleri ve dönemsellik | GVK 61–63; VUK 179; MSUGT kavramları | GLR (p) dönemsellik |
| 7 | 20 | Holding iştirak satışı; bankaya borçlu kurum istisnası; grup TF; 7440 | KVK 5/1-e, 5/1-f, 13 | YOK (IST) |

**2025/1** (tek şirket, 15 kısa soru; puan görünmüyor; her cevap ilgili maddeyi alıntılayıp somut sonuca gidiyor)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Zarar mahsubu (devir ve bölünme) | KVK 9 | YOK (yaml VTK.MTR) |
| 2 | Yurt dışı şube kazancı istisnası | KVK 5/1-g, 33 | YOK (IST) |
| 3 | Kıymeti düşen mallar | VUK 278, 267; KDVK 30 | **AKT** ✓ |
| 4 | Menkul kıymet değerlemesi | VUK 279 | AKT (p) |
| 5 | Dar mükellef; KDV sorumlusu | KVK 3, 30; KDVK 9 | YOK (ULU) |
| 6 | Sponsorluk indirimi | KVK 10 | YOK (IND) |
| 7 | Sponsorluk indirimi ve KKEG | KVK 10 | YOK (IND) |
| 8 | Bağış indirimi | KVK 10 | YOK (IND) |
| 9 | Yurt dışı iştirak kazancı istisnası | KVK 5/1-b; 7491 | YOK (IST) |
| 10 | Ticari kazanç ve KKEG | KVK 6 | GLR (p) |
| 11 | Taşınmaz satış istisnasının kaldırılması (7456); geçiş hükmü | KVK 5/1-e, geç.16 | YOK (IST) |
| 12 | Nakdi sermaye artırımı indirimi | KVK 10/1-ı | YOK (yaml VTK.TSV) |
| 13 | Şüpheli alacak | VUK 323 | **AKT** ✓ |
| 14 | Gider kabul edilmeyen ödemeler | GVK 41; KVK 11 | **GLR** ✓ |
| 15 | Girişim sermayesi fonu; geçmiş yıl zararı | KVK 10/1-g | YOK (IND) |

**2025/2** (tek şirket, 10 soru; yalnız C10 puanı görünüyor: 23)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Geçmiş yıl zararı mahsubu (7491 değişikliği) | KVK 9 | YOK (VTK.MTR) |
| 2 | Kur korumalı dönüşüm istisnası | KVK geç.14 | YOK (GEC) |
| 3 | Örtülü sermaye faizi ve kur farkı; kâr payı tevkifatı | KVK 11, 12; GVK 94 | PSF (p) |
| 4 | Bağışlar (2828, vakıf, dernek) ve KKEG (yat kirası) | KVK 10; GVK 40 | YOK (IND) / GLR (p) |
| 5 | Emisyon primi istisnası; ihraç giderinin istisnaya isabet eden kısmı | KVK 5/1-ç | PSF (p) |
| 6 | Bankaya borçlu kurumun taşınmaz devri istisnası | KVK 5/1-f; KDVK 17/4-r | YOK (IST) |
| 7 | Yabancı para değerleme; reeskont | VUK 280, 281, 285 | AKT/GLR (p) |
| 8 | Amortismana tabi mal satışı | VUK 328 | **AKT** ✓ duran varlık |
| 9 | Teknoloji geliştirme bölgesi istisnası; TÜBİTAK hibesi | 4691 geç.2 | YOK (VTK.TSV) |
| 10 | **KV matrah hesap tablosu** (ilaveler, istisnalar, zarar, indirimler) — 23 puan | Tüm yukarıdakiler | YOK (VTK.MTR) |

**2025/3** (tek şirket, 10 soru; puan görünmüyor)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Zarar mahsubu ve nakdi sermaye artırımı | KVK 9, 10 | YOK |
| 2 | KKEG (KV, cezalar ve benzeri) | KVK 11/1-d | **GLR** ✓ |
| 3 | Ücret ve temettü tevkifatı | GVK 40, 61, 75, 94, 96 | YOK |
| 4 | Dar mükellef; ücret; KDV | KVK 3; GVK 7; KDVK 9 | YOK (ULU) |
| 5 | KVK 5 istisnası, kiralama ağırlıklı **[belirsiz: bent tespit edilemedi]** | KVK 5 | YOK (IST) |
| 6 | Bağış indirimi | KVK 10; GVK 40 | YOK (IND) |
| 7 | Ar-Ge ve tasarım indirimi (7491) | KVK 10/1-a | YOK (VTK.TSV) |
| 8 | Örtülü sermaye ve TF | KVK 12, 13 | PSF (p) |
| 9 | Opsiyon sözleşmeleri | 1 Seri KVK GT 6.1.3 | YOK |
| 10 | Değersiz ve şüpheli alacak; KDV düzeltmesi | VUK 322, 323; KDVK 29 | **AKT** ✓ |

**2026/1** (8 soru, alt bentli: 5/a, 6/a, 7/a…; mikro puanlı, toplamlar ≈. Dosya notu: 5/b cevabı 27.07.2026'da güncellenmiş)

| # | ≈Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 5 | Örtülü sermayede düzeltme işlemleri | KVK 12/7 | PSF (p) / VTK.TFR |
| 2 | 10 | İştirak satış istisnası; döviz alacak kur farkı (646 hesap); damga vergisi; KDV | KVK 5/1-e; VUK 280 | YOK (IST) |
| 3 | 10 | Yurt dışı iştirak kazancı; vergi yükü testi; kur | KVK 5/1-b, 33 | YOK (IST) |
| 4 | 10 | TF yoluyla örtülü kazanç | KVK 13; DVK | PSF (p) / VTK.TFR |
| 5 | 20 | Dar mükellef: KV ve KDV; ÇVÖA | KVK 3, 30; 4 ÇVÖA GT | YOK (ULU) |
| 6 | 15 | Şüpheli alacak + binek oto giderleri | VUK 323; GVK 40; 311 GVT | **AKT** ✓ + **GLR** ✓ |
| 7 | 20 | Nakdi sermaye artırımı indirimi; Ar-Ge | KVK 10/1-ı; GVK 89 | YOK (VTK.TSV) |
| 8 | 10 | Yurt içi asgari kurumlar vergisi | KVK 32/C | YOK (VTK.MTR) |

### 1B. VERGİ TEKNİĞİ (06) — yaml VTK

**2022/1** (4 soru, puan yok)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Mücbir sebep ve sürelerin uzaması; tarh zamanaşımı ve ödeme süresi | VUK 13, 15, mük.28; 6183 48 | YOK (usul) |
| 2 | Kanun yolundan vazgeçme | VUK 379 | YOK (yargı); CEZ (p) |
| 3 | Kanun yararına temyiz | İYUK 51 | YOK |
| 4 | Karşılıklı anlaşma usulü | VUK Ek 14–16 | YOK; TFR (p) |

**2022/2** (5 soru)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Kavramlar: verginin kapitalizasyonu; inceleme başlama tarihi | VUK 140 civarı | YOK |
| 2 | Maliyet bedeli; arsa ve bina; amortisman | VUK 262, 272, 314, 327 | **DEG** ✓ |
| 3 | Uzlaşma (tarhiyat öncesi ve sonrası) | VUK Ek 1, 377 | **CEZ** ✓ uzlaşma |
| 4 | Ceza indirimi | VUK 376 | **CEZ** ✓ |
| 5 | Haciz işlemlerinde istihkak iddiaları | 6183 66 | YOK (tahsilat) |

**2022/3** (4 soru)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | İhtiyati haciz ve ihtiyati tahakkuk | 6183 9, 13–19; VUK 344, 359 | YOK |
| 2 | Kaçakçılık; e-defter | VUK 359 | **CEZ** ✓ |
| 3 | 7326 vergi artırımından sonra inceleme; sahte belge | 7326; VUK 359; 7338 | CEZ (p) |
| 4 | Davadan feragat | İYUK 30, 31; HMK 307 | YOK |

**2023/1** (5 soru)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | İzaha davet | VUK 370; 519 VUK GT | **CEZ** ✓ |
| 2 | Vergi tekniği raporunun ihbarnameye eklenmemesi; tebliğ | VUK 108 | YOK (inceleme/tebliğ) |
| 3 | İspat (VUK 3/B) ve idari yargıda delil | VUK 3/B; İYUK 20 | YOK |
| 4 | Ödeme emrine itiraz sebepleri | 6183 58 | YOK |
| 5 | Tekerrür | VUK 339 | **CEZ** ✓ (kazanımda açıkça yok) |

**2023/2** (5 soru)

| # | Konu | Dayanak | yaml |
|---|---|---|---|
| 1 | Takdirde beyana bağlılık; defter ibrazı; cezalar | VUK 76, 13, 352, 353, 359 | CEZ (p) / YOK |
| 2 | Temyiz parasal sınırları | İYUK 46 | YOK |
| 3 | Düzeltme talebi ve AYM iptal kararının sonuçları | VUK 120–126 | YOK |
| 4 | Özelge ve izahat | Yönetmelik; VUK 413 | YOK |
| 5 | Ödemelerin mahsup sırası | 6183 47; Tahsilat GT | YOK |

**2023/3** (puanlı: 15, 15, 15, 20, 35)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 15 | Afet nedeniyle terkin | VUK 115; 6183 | YOK |
| 2 | 15 | Vergi kanunlarının yorumu ve kıyas yasağı | VUK 3 | YOK |
| 3 | 15 | Deprem: kıymeti düşen mallar | VUK 278; 253 VUK GT | **DEG** ✓ |
| 4 | 20 | Dilekçelerin ilk incelemesi | İYUK 14/3 | YOK |
| 5 | 35 | Vergi davası açma ehliyeti, süresi, yetki | İYUK 5, 7, 11, 43 | YOK |

**2024/1** (puanlı: 10, 15, 20, 25, 30)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 10 | Vergi ödev mi hak mı (kavramsal deneme) | — | YOK |
| 2 | 15 | Sermaye tamamlama fonu ve enflasyon düzeltmesi | 555 VUK GT | DEG (p) |
| 3 | 20 | Amme alacağının iflas yoluyla takibi | 6183 100–101 | YOK |
| 4 | 25 | Davaya katılma ve müdahale | İYUK 31; HMK | YOK |
| 5 | 30 | Vergi hatalarının ortaya çıkarılması ve düzeltilmesi | VUK 116–126 | YOK |

**2024/2** (puanlı: 35, 30, 35)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 35 | **Enflasyon düzeltmesi**: stok kalemleri, taşıma katsayısı, hesaplama tablosu | VUK mük.298/A; 555 VUK GT | DEG (p) — yaml'da enflasyon düzeltmesi yok |
| 2 | 30 | Akaryakıt ve LPG lisans sahiplerinin teminatı | VUK mük.257; 531, 553 VUK GT | YOK |
| 3 | 35 | Bazı hallerde haczin kaldırılması | 6183 74/A; Tahsilat GT | YOK |

**2024/3** (3 soru; mikro toplam ≈32 / 33 / 30)

| # | ≈Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1 | 32 | Yurt dışından sermaye olarak getirilen döviz: kur farkı fonu (teşvik belgesi) | VUK 280/A; 495, 130 VUK GT; 217 GVT | **DEG** ✓ / TSV (p) |
| 2 | 33 | Şüpheli alacak ve konkordato | VUK 323; VUK sirküleri | DEG (p) (322–324 kazanımda yok) |
| 3 | 30 | Tecil şartları, faiz ve teminat | 6183 48; Tahsilat GT | YOK |

**2025/1** (soru metni dosyada; Soru 1 = 88, Soru 2 = 12)

| # | Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1a | 8 | Vergi ziyaı cezası; 7524 ile 344'e eklenen hüküm | VUK 344 | **CEZ** ✓ |
| 1b | 5 | Memur eliyle tebliğ; ihbarnamenin ekleri | VUK 107–108 | YOK |
| 1c | 7 | Takdir komisyonu görevi ve beyana bağlılık; idarenin başvuru yolları | VUK 72–76 | YOK |
| 1d | 34 | Kesintinin mahsubu; vergi hatası düzeltmesi; uzlaşma, dava, 376 başvuru yolları ve süreleri | VUK 116–126, 376, Ek 1; GVK 94, 121 | YOK / CEZ (p) |
| 1e | 14 | Takdire sevkten önce kendiliğinden beyan: pişmanlık ve ıslah | VUK 371 | **CEZ** ✓ |
| 1f | 4 | Tevsik zorunluluğu özel usulsüzlük cezası | VUK mük.355 | **CEZ** ✓ |
| 1g | 16 | Davada ölüm; mirasçılar; kanun yolundan vazgeçme | VUK 372, 379; İYUK | YOK |
| 2 | 12 | Takdirde teminat, ihtiyati haciz ve tahakkuk; zamanaşımı | 6183 9–19, 102 | YOK |

**2025/2** (tek olay; mikro toplam ≈100)

| # | ≈Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1a | 30 | Vergi kesenlerin sorumluluğu; KDV müteselsil sorumluluk; tevkifat | VUK 8, 11; KDVK 9; GVK 94; 6183 35 | YOK |
| 1b | 26 | Değersiz, şüpheli, vazgeçilen alacak; alacak ve borç değerlemesi; enflasyon düzeltmesi | VUK 322–324, 280, mük.298 | DEG (p) |
| 1c | 46 | Tam tasdik raporuna esas randıman, SMM, dönem sonu stok, brüt kâr (enflasyon düzeltmesi dahil) | VUK 186, 191–192, 258, 274–275, mük.298 | **DEG** ✓; REV.TAS (p) |

**2025/3** (Soru 1 ≈66–75, Soru 2 ≈24–25)

| # | ≈Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1a | 17 | Tarh, tebliğ, ceza ve düzeltme zamanaşımı | VUK 114, 126, 374 | YOK |
| 1b | 14 | Defter tutmanın amacı; bilanço esası; yabancı para ile kayıt | VUK 171 vd. | YOK |
| 1c | 35 | Tarhiyat türü ve vergi; usulsüzlük, özel usulsüzlük ve ziyaı cezaları; fiil birleşmesi, tekerrür, zamanaşımı; emsal, KKEG ve TF tespitleri | VUK 336–339, 344, 352–353; GVK 40–41; KVK 13 | **CEZ** ✓; TFR (p) |
| 2 | 24 | Sürelerin uzaması ve kısalması: mücbir sebep, mali tatil | VUK 13–17; 5604 | YOK |

**2026/1** (Soru 1 ≈78, Soru 2 ≈22)

| # | ≈Puan | Konu | Dayanak | yaml |
|---|---|---|---|---|
| 1a | 24 | Kazada hasar gören emtia ve kamyon: kıymeti düşen mal; sigorta tazminatı; maliyet; KDV | VUK 262, 278, 315, 328 | **DEG** ✓ |
| 1b | 7 | Kiralık arsaya inşa edilen depo (özel maliyet) amortismanı | VUK 315, 320, 327 | **DEG** ✓ amortisman |
| 1c | 15 | Hisse senedi, yabancı fon ve külçe altın değerlemesi | VUK 274, 279 | **DEG** ✓ |
| 1d | 32 | Sahte fatura; KDV indirimi; kaçakçılık | VUK 359; KDVK | **CEZ** ✓ |
| 2a–c | 22 | Tapu harcı matrahı: pişmanlık ve ıslah; (b) VUK 378 ve İYUK 7/27 atıfları **[belirsiz: b'nin soru satırı bulunamadı]**; (c) tecil ve vergiye uyumlu mükellef tecili | VUK 371, 378; 6183 48, 51; Harçlar K. 63 | CEZ (p) / YOK |

---

## 2. Frekans tabloları ve yaml ağırlığıyla karşılaştırma

### 2A. REV (106 soru birimi; puanlı dönemler 2023/2–2024/3 = 5 × 100 = 500 puan)

| yaml konu | yaml ağırlık | Birincil eşleşen soru (13 dönem) | Kısmi | Puanlı 5 dönem (500) | Pay |
|---|---|---|---|---|---|
| GNL Revizyon teknikleri | 14 | 0 | 0 | 0 | 0% |
| AKT Aktif hesaplar | 22 | 9 (2022/3-4, 2023/1-4, 2023/2-7, 2024/1-6, 2025/1-3, 2025/1-13, 2025/2-8, 2025/3-10, 2026/1-6) | ~6 | 25 | 5% |
| PSF Pasif ve özkaynak | 16 | 0 tam (vergisel örtülü sermaye, TF, sermaye işlemleri) | ~12 | 55 (TF ve sermaye) | 11% |
| GLR Gelir tablosu | 18 | 5 (2023/1-5, 2023/2-2, 2023/3-1, 2025/1-14, 2025/3-2) + 2026/1-6 | ~6 | 50 | 10% |
| VIN Vergi incelemesi ve hile | 16 | 0 | 0 | 0 (vergi hatası 10 puan VIN kazanımında yok) | 0% |
| TAS Tasdik çalışmaları | 14 | 0 | 1 (2022/3-3 KDV iade) | 0 | 0% |
| **yaml'da YOK** | — | ≈75–80 | — | ≈370 | ≈74% |

Puanlı 500'ün gerçek dağılımı: dar mükellef, ÇVÖA ve tevkifat (ücret dahil) **145**; KV istisnaları ve bölünme **130**; TF, örtülü sermaye ve sermaye işlemleri **55**; KKEG, finansman ve binek **50**; değerleme, yeniden değerleme ve varlık barışı **45**; KVK 10 indirimleri **40**; alacak ve stok **25**; vergi hatası **10**.

Sonuç: REV sınavı denetim tekniği değil, **kurumlar vergisi revizyonu**. Bir kurumun işlemleri KV, KDV, GV stopajı, DV ve VUK değerleme açısından "doğru mu, olması gereken ne" sorusuyla değerlendiriliyor. Yaml'daki GNL, VIN ve TAS (toplam 44 ağırlık) 13 dönemde hiç sorulmamış. AKT 22 ağırlığa karşılık puanın yaklaşık %5'ini alıyor. Buna karşılık en çok puan getiren iki alanın (ULU ve IST, yaklaşık %55) yaml REV'de karşılığı yok.

### 2B. VTK (61 soru ya da bent birimi; kesin puanlı 4 dönem 2023/3, 2024/1, 2024/2, 2025/1 = 400 puan)

| yaml konu | yaml ağırlık | Birincil eşleşen birim | Kısmi | Kesin puanlı 400 | ≈ 2024/3, 2025/2, 2025/3, 2026/1 (≈400) |
|---|---|---|---|---|---|
| DEG Değerleme | 18 | 8 (2022/2-2, 2023/3-3, 2024/3-1, 2025/2-1c, 2026/1-1a,b,c) | 4 (2024/1-2, 2024/2-1, 2024/3-2, 2025/2-1b) | 65 (15 tam + 50 kısmi enflasyon) | ≈ 32+33 + 72 + 0 + 46 ≈ 183 |
| TFR Transfer fiyatlandırması | 18 | 0 | 2 (2022/1-4 KAU, 2025/3-1c) | 0 | ≈ 0 (2025/3-1c içinde) |
| BDB Birleşme, devir, bölünme | 18 | 0 | 0 | 0 | 0 |
| MTR Matrah ve beyan | 18 | 0 | 0 | 0 | 0 |
| TSV Teşvikler | 14 | 0 | 1 (2024/3-1 VUK 280/A) | 0 | ≈ 0 |
| CEZ Cezalar ve uzlaşma | 14 | 11 | 4 | 26 (+34 kısmi 1d) | ≈ 35 + 32 + ~10 ≈ 77 |
| **yaml'da YOK** | — | ≈36 | — | ≈275–310 | ≈ 30 + 30 + 41 + ~12 ≈ 113 |

Sonuç: VTK sınavı **vergi usul hukuku ve uygulaması**: VUK usul, ceza, düzeltme, takdir, tebliğ, zamanaşımı ve süreler; 6183 tahsilat; İYUK vergi yargısı; VUK değerleme ve enflasyon düzeltmesi. Yaml VTK'daki TFR, BDB, MTR ve TSV (toplam 68 ağırlık) 13 dönemde VTK'da hiç sorulmamış. Bu konular aslında **REV** sınavında soruluyor. CEZ (14) gerçekte yaklaşık %10–20 ile örtüşüyor. DEG (18) gerçekte yaklaşık %15–45 alıyor (2024/2'den beri artıyor).

**Ana bulgu:** yaml'da VTK altına konan DEG, TFR, BDB, MTR ve TSV içeriği, gerçek sınavda REV'in çekirdeği. VTK'nın gerçek çekirdeği olan usul, 6183 ve İYUK ise yaml'da hiçbir derste yok.

---

## 3. Sorulan ama yaml'da eksik ya da zayıf konular

### REV için eklenmesi gereken konular (önerilen kod: kanıt)
1. **IST – KV istisnaları (KVK 5/1-a,b,ç,e,f,g,h; 5/B; geç.16)**: 2023/2-4, 2023/2-6, 2024/1-7 (30p), 2024/2-4, 2024/2-7, 2024/3-4, 2024/3-7, 2025/1-2, 9, 11, 2025/2-6, 2026/1-2, 2026/1-3, 2022/1-4, 2022/1-7. En sık sorulan iki alandan biri.
2. **ULU – Dar mükellef, ÇVÖA, KV/GV kesintisi ve KDV sorumluluğu (KVK 3, 30; GVK 94; KDVK 9; DVK)**: neredeyse her dönem 1–3 soru (2022/1-1, 2022/2-4, 2022/3-2, 2023/1-3, 2023/2-3, 2023/3-4, 2024/1-1, 2, 3, 2024/2-6, 2024/3-3, 5, 2025/1-5, 2025/3-4, 2026/1-5).
3. **IND – KVK 10 indirimleri (bağış, sponsorluk, Ar-Ge ve tasarım, nakdi sermaye artırımı, girişim sermayesi fonu, hizmet ihracatı) ve TGB istisnası**: 2022/2-6, 2022/3-3, 2022/3-5, 2023/3-3, 2024/2-3, 2024/3-2, 2025/1-6, 7, 8, 12, 15, 2025/2-4, 9, 2025/3-6, 7, 2026/1-7.
4. **ORT – Örtülü sermaye (KVK 12) ve TF (KVK 13), düzeltme işlemleri**: 2022/2-1, 5, 2022/3-7, 2023/3-7, 2024/1-4, 2025/2-3, 2025/3-8, 2026/1-1, 2026/1-4. Yaml'da yalnız PSF'de "örtülü kazanç belirtileri" ifadesi var; vergisel hesap yok.
5. **Ücret ve kâr payı stopajı (GVK 61, 75, 94, 103; kendi pay iktisabı)**: 2024/1-5, 2024/2-1, 5, 2025/3-3, 2023/1-2.
6. **Değerleme (VUK 279, 280, 278, 323, 328, mük.298/Ç)**: AKT'de kısmen var. Menkul kıymet (279), yabancı para (280), amortismanlı mal satışı (328) ve yeniden değerleme eksik.
7. **GEC – Geçici ve af düzenlemeleri** (varlık barışı GVK geç.93 ve KVK geç.15; KKM KVK geç.14; 7326 matrah artırımı ve kayıt düzeltme): 2022/1-3, 2022/3-1, 2023/1-6, 7, 2023/3-5, 2025/2-2.
8. **MTR – KV matrah hesap tablosu, zarar mahsubu, YAKV 32/C**: 2025/1-1, 2025/2-1, 2025/2-10 (23p), 2025/3-1, 2026/1-8 (yaml'da VTK altında).
9. **BDB – Devir ve kısmi bölünme**: 2022/1-6, 2024/2-2 (yaml'da VTK altında).
10. Zayıf kapsanan GLR alt konuları: binek oto kısıtlaması (2023/2-2, 2026/1-6), GVK 41 (2025/1-14), finansal türevler (foreks 2022/2-2, forward 2024/1-4, opsiyon 2025/3-9).

### VTK için eklenmesi gereken konular
1. **Vergi usul genel**: süreler, mücbir sebep ve mali tatil (2022/1-1, 2025/3-2); zamanaşımı (2025/3-1a); tebliğ (2023/1-2, 2025/1-1b); defter tutma esasları (2025/3-1b); kıyas ve yorum (2023/3-2); kavramlar (2022/2-1, 2024/1-1).
2. **Takdir, inceleme, beyana bağlılık, özelge**: 2023/2-1, 2023/2-4, 2025/1-1c.
3. **Vergi hataları ve düzeltme (VUK 116–126), terkin (VUK 115)**: 2023/2-3, 2024/1-5 (30p), 2025/1-1d (34p), 2023/3-1.
4. **Vergi yargısı (İYUK)**: dava açma, ilk inceleme, temyiz sınırları, kanun yararına temyiz, davaya katılma, davadan feragat, kanun yolundan vazgeçme (VUK 379): 2022/1-2, 3, 2022/3-4, 2023/2-2, 2023/3-4, 5 (35p), 2024/1-4, 2025/1-1g.
5. **6183 tahsilat**: ihtiyati haciz ve tahakkuk, teminat, tecil, haczin kaldırılması, istihkak, iflas, ödeme emri, mahsup sırası: 2022/2-5, 2022/3-1, 2023/1-4, 2023/2-5, 2024/1-3, 2024/2-3, 2024/3-3, 2025/1-2, 2026/1-2c.
6. **Vergi sorumluluğu ve müteselsil sorumluluk (VUK 8, 11; KDVK 9; 6183 35)**: 2025/2-1a (≈30p).
7. **Teminat (VUK mük.257)**: 2024/2-2 (30p).
8. **Enflasyon düzeltmesi (VUK mük.298/A, 555 VUK GT)**: 2024/1-2, 2024/2-1 (35p), 2025/2-1b, 1c. DEG kazanımlarında yok.
9. **VUK 280/A ve 322–324 alacak değerlemesi**: 2024/3-1, 2, 2025/2-1b. DEG kazanımı "258–298" ile sınırlı.
10. CEZ içinde zayıf kalanlar: tekerrür (2023/1-5), ceza zamanaşımı (2025/3-1a), fiil birleşmesi (2025/3-1c), sahte belge (2026/1-1d), ölüm halinde ceza (2025/1-1g).

## 4. Yaml'da olup 13 dönemde hiç sorulmayan konu ve kazanımlar (ağırlık düşürme adayı)

REV:
- **GNL** (tamamı): revizyonun amacı, belge incelemesi, karşılaştırma ve teyit, örnekleme, çalışma kâğıtları. Hiç sorulmadı.
- **AKT**: "hazır değerler ve kasa sayımı" (yalnız 2023/1-7'de 7326 kasa düzeltmesi var; sayım tekniği yok), "alacakların teyidi". Sorulmadı.
- **PSF**: "borçların tamlığı ve teyidi", "karşılıklar" (kıdem ve benzeri). Sorulmadı.
- **GLR**: "hasılatın dönemselliği" yalnız kısmen sorulmuş (2024/3-6).
- **VIN** (tamamı): VUK 134–141 inceleme, sahte belge, defter ibrazı, ziyaı ve usulsüzlük. REV'de sorulmadı. Bu konular VTK'da soruluyor (CEZ).
- **TAS** (tamamı): kontrol listeleri, KDV iade incelemesi, tespit ve eleştiri yazımı. Sorulmadı. Tek istisna 2025/2 VTK-1c'de "tam tasdik raporuna esas randıman" ifadesi.

VTK:
- **TFR**: KVK 13 yöntemleri, KVK 12 örtülü sermaye, düzeltme işlemleri. VTK'da hiç sorulmadı (REV'de sık).
- **BDB** (tamamı): VTK'da hiç sorulmadı (REV'de 2 kez).
- **MTR** (tamamı): ticari kârdan mali kâra geçiş, istisna sırası, geçmiş yıl zararı, geçici vergi, YAKV. VTK'da hiç sorulmadı (REV 2025–2026'da sık).
- **TSV** (tamamı): yatırım teşviki ve İKV, Ar-Ge, nakdi sermaye, ihracat indirimi. VTK'da hiç sorulmadı (REV'de sık).
- **DEG**: "yeniden değerleme (mük.298/ç)" VTK'da doğrudan sorulmadı (REV 2023/3-6 ve 2024/1-7'de var).

Öneri: 4 konuyu (TFR, BDB, MTR, TSV) VTK'dan **REV'e taşıyın**. REV'den GNL, VIN ve TAS'ı çıkarın ya da yaklaşık %5'e düşürün. VTK'ya şu konuları açın: Usul genel; Takdir, inceleme ve düzeltme; Vergi yargısı; 6183 Tahsilat; Sorumluluk ve teminat. Mevcut DEG'e enflasyon düzeltmesini, 280/A'yı ve 322–324'ü ekleyin; CEZ'i koruyun.

## 5. Soru stili (gerçekçi deneme sorusu yazmak için)

### Genel puanlama ilkeleri (her REV anahtarının başında tekrar ediyor)
- Sonuç tek başına puan almaz. "İstisnadır", "tabidir", "eleştiri yoktur", "gerek yoktur" gibi gerekçesiz ifadeler 0 puan alır. **Yasal dayanak + somut olaya bağlama + sonuç** üçlüsü gerekir.
- Kanun metnini kitapçıktan aynen kopyalamak, ihtimalli cevap vermek ve olaydan kopuk genel bilgi vermek puan almaz.
- Aynı işlem için çelişen iki cevap verilirse cevap yanlış sayılır.
- "Farklı Değerlendirme ve Açıklamalar": iç tutarlılığı olan alternatif yorumlara kısmi puan verilir.
- Hesaplamaların gösterilmesi beklenir; sınavda kanun kitapçığı ve hesap makinesi serbest.

### REV
- **Format evrimi**:
  - 2022/1–2023/2: 7 soru. Anahtarlar aşırı uzun (soru başına 20–120 bin karakter) ve GİB özelgelerinden geniş alıntı içeriyor. Önceki dönem anahtarlarına atıf yapılıyor ("2018/1… dönem anahtarları").
  - 2023/2'den itibaren her yanıtta "(10/15/20/30 puan)" var.
  - 2023/3–2024/3: kompakt format. Önce "Soruda yer verilen işlemlerin vergilendirilmesine yönelik olarak; 1- … 2- …" diye dayanak listesi, sonra numaralı sonuç cümleleri ve somut tutarlar (örnek: "600.000 TL üzerinden %10 tevkifat hatalıdır").
  - 2025/1–2025/3: tek şirket ve 10–15 kısa soru. Her cevap maddeyi alıntılayıp kısa sonuca gidiyor. Son soru çoğu zaman **KV matrahı hesap tablosu** (2025/2-C10: ticari kâr → ilaveler → istisnalar → zarar → indirimler → matrah, 23 puan).
  - 2026/1: 8 soru, alt bentli (5/a, 6/a…). Cevap vergi türlerine ayrılmış ("1- KV yönünden (6 Puan) / 2- VUK yönünden (1) / 3- Damga V. (1) / 4- KDV (2)"). Her doğru cümleye 1–2 mikro puan.
- **Olay tipi**: hayali adlı mükellef kurum (Tiamat A.Ş., Ishtar Holding PLC, Ardiles A.Ş., Spinoza Holding…). Kurumun yaptığı kayıt ya da beyan verilir. Aday her işlem için **"yapılan doğru mu, değilse olması gereken vergisel sonuç ve tutar"** sorusuna cevap verir. Bir soruda 3–6 alt işlem (i, ii, iii…) olur. Tarihler, kurlar ve CK oranları (%0/%10/%15 tevkifat) önemlidir.
- **Hesaplama türleri**: tevkifat (brütleştirme dahil), yurt dışı iştirakte vergi yükü testi (örnek: "141.750/(141.750+858.250) = %14,175"), istisna tutarı (%50 taşınmaz), finansman gider kısıtlaması, örtülü sermaye faizi, kur farkı, matrah tablosu.
- **Yevmiye ve düzeltme kaydı neredeyse hiç yok**: REV dosyalarında "yevmiye" geçişi 0–1, "düzeltme kaydı" 0. Hesap kodları yalnız metin içinde geçiyor (646, 689, 128 vb.). Deneme sorularında tam yevmiye istemek gerçekçi olmaz. "Hangi hesapta izlenmeli ve vergisel sonucu ne" kalıbı daha gerçekçi.

### VTK
- 2022/1–2023/2: 4–5 soru, her biri a/b şıklı, kavram ve usul ağırlıklı (kanun maddesini açıklayıp olaya uygulama). Puan görünmüyor.
- 2023/3–2024/3: 3–5 soru (100 puan). Her şart ve unsur için "(1 Puan)" mikro puanlama var. Anahtar, şartları madde madde sayıp her birine puan veriyor. 2024/2'de 35 puanlık enflasyon düzeltmesi hesap tablosu var.
- 2025/1'den beri: **1–2 uzun örnek olay**. Yaklaşık 1 sayfa veri, ardından "Diğer Veriler ve Belirlemeler" (10 civarı varsayım: gecikme faizi %4,5, sürelerin işgünü sayılması, 7524 yürürlük tarihi vb.), ardından a–g arası "İstenenler", her birinin puanı yanında (örnek: 8, 5, 7, 34, 14, 4, 16). Kalıp fiiller: "değerlendiriniz / gerekçeleriyle açıklayınız / tutarını belirleyiniz". Cevaplar 90–130 bin karakter. **Süre ve tarih hesabı** (tebliğ + 30 gün, zamanaşımının uzaması, mali tatil), **ceza hesabı** (ziyaı 1 kat ve 1,5 kat, mük.355 %5/%10 ve üst sınır, 376 indirimi) ve **değerleme hesabı** (randıman, SMM, stok) birlikte isteniyor.
- Olaylar gerçekçi Türk adlarıyla kuruluyor (Ahmet GÖZÜKARA, Yörükoğlu Yonga Levha Ltd., Duman Yapı–Ahmet TEMİZYOL İş Ortaklığı). Mükellef türleri karışık: gerçek kişi, Ltd., iş ortaklığı, özel okul.

## 6. Anlatım dosyalarının çıkmış sorularla karşılaştırması

### REV/AKT.md (aktif hesaplar)
- Var: VUK 323 şüpheli alacak (2026 sınırı 25.000 TL), 322 değersiz alacak (128/654 kaydıyla), sayım, değerleme ve amortisman örneği. Sınavda sık çıkan şüpheli alacakla örtüşüyor.
- Eksikler:
  - **VUK 324** (karşılık tahsili ve iptali) yok.
  - **Değersiz alacakta KDV düzeltmesi (KDVK 29)** yok: 2023/2-7 ve 2025/3-10'da soruldu. Dosyada "KDV" hiç geçmiyor.
  - **Kıymeti düşen malda KDV indirimi (KDVK 30/c)** yok: 2024/1-6.
  - **Konkordato–şüpheli alacak** ilişkisi yok: 2024/3 VTK-2.
  - **VUK 279 menkul kıymet** (2024/3-1, 2025/1-4) yok.
  - **VUK 328 amortismanlı mal satışı ve yenileme fonu** (2025/2-8) yok.
  - Yeniden değerleme (2023/3-6, 2024/1-7) yok.
- Hiç sorulmayan "kasa sayımı" ve "teyit" bölümleri derste yer kaplıyor.

### REV/GLR.md (gelir tablosu)
- Var: KVK 11 KKEG, finansman gider kısıtlaması (çok iyi, 13 geçiş), kur farkı. 2023/1-5 ve 2023/3-1 ile örtüşüyor.
- Eksikler:
  - **Binek oto gider ve amortisman kısıtlaması** (GVK 40/1-5-7, KDVK 30/b) yok. 2023/2-2 (15p) ve 2026/1-6'da soruldu.
  - **GVK 41** (2025/1-14) yok.
  - **Bağış ve sponsorluk** yok: KKEG olarak eklenip KVK 10'dan indirilmesi; 2025 matrah tablolarının temel kalemi.
  - **Reeskont** (2025/2-7, matrah tablosu) yok.
  - **KKM geç.14** yok.
  - **YAKV** yok.
  - Finansal türevler (foreks, forward, opsiyon) yok.
- Örtülü sermaye ve TF yalnız birer kez anılıyor; sınavda 9 soru var.

### VTK/CEZ.md (cezalar)
- En iyi örtüşen ders. 344 (7524 dahil), 352–353, mük.355, 359, 370 izaha davet, 371 pişmanlık, 376 indirim, uzlaşma ve sayısal ceza örneği var.
- Eksikler:
  - **Tekerrür (VUK 339)** yok: 2023/1-5. Dosyada "tekerrür" ve "339" 0 kez geçiyor.
  - **Ceza zamanaşımı (VUK 374)** yok ("zamanaşımı" 0 geçiş): 2025/3-1a.
  - **Kanun yolundan vazgeçme (VUK 379)** yok: 2022/1-2, 2025/1-1g.
  - **Ölüm halinde ceza ve mirasçılar (VUK 372)** yok.
  - Tecil, ihtiyati haciz, 6183 ve İYUK yok. Bunlar CEZ kazanımı değil, ama sınavda aynı olayın içinde birlikte soruluyor.
- Örnekler tek fiilli. 2025/3-1c tarzı fiil birleşmesi (336–338) ve tarhiyat türü seçimi çalışılmalı.

### VTK/DEG.md (değerleme)
- Var: VUK 258–298 ölçüleri, maliyet bedeli, borsa rayici, mük.298/ç yeniden değerleme örneği, amortisman. 2022/2-2 ve 2026/1-1b,c ile kısmen örtüşüyor.
- Eksikler:
  - **Enflasyon düzeltmesi (mük.298/A, 555 VUK GT)** neredeyse yok: "taşıma katsayısı" ve "555" 0 geçiş; "enflasyon" yalnız yeniden değerleme bağlamında 3 kez. Oysa 2024/1-2, **2024/2-1 (35p)** ve 2025/2-1b,c'de soruldu. En büyük açık bu.
  - **VUK 280/A** (2024/3-1, ≈32p) yok.
  - **322–324 alacak değerlemesi ve konkordato** (2024/3-2, 2025/2-1b) yok.
  - **Kıymeti düşen mallar (278)** yalnız 1 geçiş: 2023/3-3 ve 2026/1-1a'da soruldu.
  - **Sigorta tazminatı ve yenileme fonu (VUK 328/mük.315)**, **özel maliyet itfası**, **randıman ve SMM hesabı** (2025/2-1c, ≈46p) yok.
- Not: DEG.md'deki "VUK geç.37 nedeniyle 2025–2027'de enflasyon düzeltmesi yapılmıyor" iddiası bu analizde doğrulanmadı. Sınav anahtarları 2025/2'de enflasyon düzeltmesi hesabı istiyor. Mevzuat ayrıca kontrol edilmeli.

## 7. Belirsizlikler ve tekrar kontrol listesi
- REV dosyalarında soru metni yok; konu özetleri cevaplardan çıkarıldı.
- 2023/3 REV-5, 2025/3 REV-5 ve 2026/1 VTK-2b alt konuları kesinleştirilemedi.
- 2024/3, 2025/2, 2025/3 ve 2026/1 (VTK) ile 2026/1 (REV) puan toplamları mikro puanlardan türetildi; başlık ve alt puan çift sayımı nedeniyle ±5 sapabilir.
- Eşleştirmede "(p)" kısmi kabul edildi. Yaml kazanımları denetim odaklı yazıldığı için vergisel sorular çoğunlukla "YOK" sayıldı. Bu, kasıtlı olarak katı bir yorum.
