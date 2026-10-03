# Ana Plan — SMMM Sınav Hazırlık Uygulaması

> Sürüm: 1.0 · 3 Ekim 2026
> Durum: Taslak. Resmî belgeler okunduğunda §3 (müfredat) kesinleşecek.
> Bağlı belge: [`ARASTIRMA.md`](ARASTIRMA.md)

---

## 0. Temel ilkeler

1. **Doğruluk hızdan önce gelir.** Kalite kapılarının hepsinden geçmeyen soru yayına girmez. Takvim kayarsa kapsam daraltılır, kalite düşürülmez.
2. **Her soru bir kaynağa bağlıdır.** Kanun maddesi, standart paragrafı veya tebliğ bölümü. Kaynağı gösterilemeyen soru yazılmaz.
3. **Çıkmış sorular kopyalanmaz.** Yalnızca konu, ağırlık ve tarz analizi için kullanılır. Telif ve marka riski sıfıra yakın tutulur.
4. **Her şey kayıt altındadır.** Her sorunun kim tarafından (model veya insan), hangi kaynaktan, hangi kontrollerden geçerek üretildiği izlenebilir.
5. **Mevzuat değişir.** Yürürlük tarihi ve yıla bağlı tutarlar (had, oran, tutar) her soruda etiketlenir ve takip edilir.

## 1. Kesinleşen kararlar

| # | Karar |
|---|---|
| K1 | Tek uygulama, içinde sınav seçimi (çok sınavlı altyapı) |
| K2 | Önce Türkiye; işe yaradığı görülünce Azerbaycan → Özbekistan |
| K3 | İlk sınav: **SMMM** (SGS + Yeterlilik) |
| K4 | Sonraki sınavlar: MYK (önce Emlak) → İSG |
| K5 | Özgün soru; mevzuata dayalı yapay zekâ üretimi + çok aşamalı otomatik kontrol + muhasebeci denetimi |
| K6 | Hedef: 2000 soru; yayına 1000 soruyla çıkılır |
| K7 | Kodu birlikte yazıyoruz (Claude yazar, Merve yönlendirir ve test eder) |

**Önerilen, onay bekleyenler:**
- Teknik altyapı: Flutter + Supabase + RevenueCat
- Gelir modeli: ücretsiz katman + sınav dönemi aboneliği
- Satış: Şirketsiz, GVK 20/B istisnasıyla, yalnızca mağaza üzerinden
- Hedef tarih: 2027/1 sınav dönemi

## 2. Hedef takvim

2027 takvimi henüz açıklanmadı. 2026'daki düzene göre **2027/1 SGS ve Yeterlilik büyük ihtimalle Nisan 2027'de**, başvurular Ocak–Şubat'ta. Adaylar çalışmaya Ocak'ta yoğun başlıyor. Bu yüzden:

- **Yayın hedefi: 11 Ocak 2027** (en geç 25 Ocak)
- Google kapalı test (14 gün) için beta en geç **14 Aralık 2026**'da başlamalı

| Faz | Tarih | İş | Çıkış kapısı |
|---|---|---|---|
| F0 Hazırlık | 5–18 Eki | Resmî belgeler, kaynak arşivi, muhasebeci görüşmesi, marka adı, hesaplar, repo | Kaynak arşivi tam |
| F1 Müfredat haritası | 12–25 Eki | Ders → ünite → konu → kazanım ağacı; çıkmış soru analizi; ağırlıklar | **Kapı M:** Muhasebeci onayı |
| F2 Soru standardı + pilot | 19 Eki – 1 Kas | Soru şablonu, üretim hattı v1, **100 pilot soru**, %100 uzman denetimi, kalibrasyon | **Kapı P:** Pilot hata oranı hedefte |
| F3 Uygulama MVP | 19 Eki – 13 Ara | Flutter uygulama, içerik altyapısı, ödeme, analitik | Özellik listesi tamam |
| F4 Seri üretim | 2 Kas – 6 Ara | 200'lük partiler halinde 1000 soru (yayın seti) | Her parti kapılardan geçer |
| F5 Kapalı beta | 7–27 Ara | 12+ gerçek aday, 14+ gün; hata bildirimleri | **Kapı B:** Kritik hata yok |
| F6 Yayın | 28 Ara – 11 Oca | Mağaza incelemesi, SEO sitesi, yayın | Mağazalarda canlı |
| F7 Büyüme ve tamamlama | Oca – Nis 2027 | 2000 soruya tamamlama, deneme sınavları, sınav sonrası analiz | 2027/1 sonrası değerlendirme |
| F8 Sonraki sınav | Mar 2027 → | MYK Emlak hazırlığı | — |

## 3. Müfredat haritası (F1)

### 3.1 Kaynak katmanları

| Katman | İçerik | Kullanım |
|---|---|---|
| **A, birincil (bağlayıcı)** | 3568 s. Kanun; SMMM Staj Yönetmeliği; YMM ve SMMM Sınav Yönetmeliği (md.14 ders kapsamı); TESMER Yönergesi 2026; TÜRMOB 14.01.2026 kararı; 2026 takvimi | Sınav kuralları ve konu kapsamı |
| **B, içerik mevzuatı** | Her dersin dayandığı kanun, yönetmelik, tebliğ ve standartlar (§3.2) | Soruların doğruluk kaynağı |
| **C, analiz** | 2026/1–2026/2 Yeterlilik ve son 6+ dönem SGS soru kitapçıkları | Yalnızca konu, ağırlık ve tarz analizi; **kopyalanmaz** |
| **D, referans** | Ders kitapları, akademik kaynaklar | Yalnızca kavram kontrolü; metin alınmaz |

### 3.2 Ders → kaynak eşlemesi (taslak, resmî kapsamla teyit edilecek)

| Ders | Sınav | Başlıca kaynaklar |
|---|---|---|
| Finansal Muhasebe | SGS 18 + Yet. 20 | Muhasebe Sistemi Uygulama Genel Tebliğleri (Tekdüzen Hesap Planı), VUK değerleme hükümleri (md. 258–330), BOBİ FRS, TMS/TFRS (özet) |
| Muhasebe Standartları | SGS 8 | TMS/TFRS, BOBİ FRS, KÜMİ FRS (KGK) |
| Finansal Tablolar ve Analizi | SGS 8 + Yet. 20 | MSUGT mali tablo ilkeleri, TMS 1, TMS 7, oran ve trend analizi |
| Maliyet Muhasebesi | SGS 8 + Yet. 20 | MSUGT 7/A–7/B, maliyet sistemleri ve yöntemleri |
| Muhasebe Denetimi | SGS 16 + Yet. 20 | Bağımsız Denetim Standartları (KGK), iç kontrol, denetim raporlama |
| Vergi Mevzuatı ve Uygulaması | SGS (Hukuk grubu) + Yet. 20 | VUK 213, GVK 193, KVK 5520, KDVK 3065, ÖTVK 4760, AATUHK 6183, Harçlar 492, Damga 488, MTV 197, VİK 7338 |
| Hukuk | SGS 30 (grup) + Yet. 20 | TTK 6102, TBK 6098, İş K. 4857, SGK 5510, İİK 2004, İYUK 2577 |
| Sermaye Piyasası Mevzuatı | Yet. 20 | SPKn 6362 ve temel tebliğler |
| Meslek Hukuku | SGS (grup) + Yet. 20 | 3568 s. Kanun ve yönetmelikleri, Meslek Ahlakı Yönetmeliği |
| Ekonomi | SGS 6 | Mikro ve makro temel kavramlar |
| Maliye | SGS 6 | Kamu maliyesi, bütçe, vergi teorisi |
| Genel kültür / yetenek / yabancı dil | SGS 30 | **Yayın setine dahil değil**, F7'de değerlendirilecek |

### 3.3 Çıktılar

- `content/mufredat/` altında makinece okunabilir konu ağacı (YAML/JSON): `ders → ünite → konu → kazanım`
- Her kazanım için: kaynak madde(ler), yürürlük tarihi, sınav ağırlığı (çıkmış soru analizinden), zorluk dağılımı
- **Kapı M:** Muhasebeci tüm ağacı inceler ve onaylar

## 4. Soru standardı (F2)

### 4.1 Soru kaydı alanları

| Alan | Açıklama |
|---|---|
| `id` | Kalıcı kimlik (ör. `SMMM-VER-KDV-0042`) |
| `sinav` | SGS / YET / ikisi |
| `ders`, `unite`, `konu`, `kazanim` | Müfredat ağacına bağlantı |
| `tip` | bilgi · kavrama · uygulama · hesaplama |
| `zorluk` | 1 (kolay) · 2 (orta) · 3 (zor), hedef ve ölçülen olarak ayrı |
| `kok` | Soru metni |
| `secenekler` | A–E, tam 5 şık |
| `dogru` | Tek doğru şık |
| `aciklama` | Doğru şık neden doğru + **her çeldirici neden yanlış** |
| `kaynaklar` | Kanun/standart + madde/paragraf + kısa alıntı |
| `gecerlilik` | Yürürlük başlangıcı, varsa bitişi, yıla bağlı tutar etiketi |
| `durum` | taslak → kontrolde → onaylı → yayında → geri çekildi |
| `surum`, `gecmis` | Her değişikliğin kaydı (kim, ne, neden) |
| `uretim` | Model, istem sürümü, kaynak parçası, kontrol sonuçları |

### 4.2 Yazım kuralları

- Kök tek başına anlaşılır olmalı; olumsuz kökte "değildir / yanlıştır" **kalın** yazılır.
- Tam olarak bir doğru şık; diğer dördü makul ama kesinlikle yanlış.
- "Hepsi / hiçbiri" şıkları en fazla %5 oranında.
- Şık uzunlukları dengeli; doğru şık en uzun olmamalı (istatistikle izlenir).
- Doğru şıkkın harfi tüm bankada A–E arasında dengeli dağılır.
- **Hesaplama soruları hesap makinesi olmadan çözülebilmeli** (Yeterlilik'te yasak). Sayılar yuvarlak, işlem adımları makul.
- Yıla bağlı tutar ve oranlar ya güncel yılın değeriyle kullanılır ya da soru içinde verilir.
- Dil: resmî, sade, yazım kılavuzuna uygun Türkçe.

## 5. Üretim hattı ve kalite kapıları

Her soru aşağıdaki kapılardan **sırayla** geçer. Bir kapıdan kalan soru düzeltilir ve **baştan** kontrol edilir.

| Kapı | Ad | Ne yapılır | Kalma ölçütü |
|---|---|---|---|
| **G0** | Kaynak | Kazanımın kaynak metni arşivden çekilir, yürürlükte olduğu doğrulanır | Kaynak yok veya mülga |
| **G1** | Üretim | Model yalnızca verilen kaynak parçasıyla ve §4 kurallarıyla soru yazar | — |
| **G2** | Yapı | Şema, 5 şık, tek doğru, uzunluk, yasaklı kalıplar, yazım denetimi (otomatik) | Herhangi bir ihlal |
| **G3** | Bağımsız çözüm | **İki farklı model** cevap anahtarını görmeden çözer | Biri bile anahtarla uyuşmazsa |
| **G4** | Hesap doğrulama | Hesaplama sorularında sonuç kodla (Python) yeniden hesaplanır | Fark varsa |
| **G5** | Düşman denetimi | Bir model "başka bir şık da doğru" veya "soru belirsiz" diye savunma kurmaya çalışır | İnandırıcı itiraz varsa |
| **G6** | Kaynak uyumu | Açıklamadaki her iddia kaynak metinle karşılaştırılır | Kaynakta olmayan iddia |
| **G7** | Özgünlük | Çıkmış soru arşivi ve kendi bankamızla benzerlik taraması (metin + anlam) | Eşik üstü benzerlik |
| **G8** | Uzman denetimi | §6'daki örnekleme planına göre muhasebeci inceler | Kritik hata |
| **G9** | Yayın sonrası | Kullanıcı hata bildirimi + istatistik izleme (§7) | Bildirim doğrulanırsa geri çekilir |

## 6. Uzman denetimi planı

| Aşama | Örneklem | Kural |
|---|---|---|
| Pilot (100 soru) | **%100** | Hata türleri sınıflandırılır, istemler ve kurallar düzeltilir |
| Seri üretim, sözel sorular | Her 200'lük partiden rastgele **20** + otomatik kapılarda işaretlenen tüm sorular | Örneklemde 1 kritik hata → partinin tamamı incelenir |
| Seri üretim, hesaplama soruları | **%25** + işaretlenenler | Aynı kural |
| Yayın sonrası | Doğrulanan tüm kullanıcı bildirimleri | 48 saat içinde karar |

**Hata sınıfları:**
- **Kritik:** Yanlış cevap anahtarı, birden fazla doğru şık, yanlış mevzuat bilgisi.
- **Önemli:** Eksik veya yanıltıcı açıklama, belirsiz ifade.
- **Küçük:** Yazım, üslup.

**Kabul ölçütü:** Yayın öncesi uzman örnekleminde kritik hata oranı **≤ %1**, önemli hata oranı **≤ %3**. Pilot bu ölçütü karşılamazsa seri üretime geçilmez (**Kapı P**).

**Uzman zaman bütçesi (tahmini):** Pilot 100 soru için yaklaşık 4–5 saat. Seri üretimde parti başına yaklaşık 1,5–2 saat. 1000 soruluk yayın seti için toplam yaklaşık **15–20 saat**, 5 haftaya yayılmış.

## 7. Yayın sonrası kalite döngüsü

- Uygulamada her soruda **"Hata bildir"** düğmesi: kategori seçimi + serbest metin.
- **İstatistik alarmları:**
  - Doğru cevaplanma oranı < %15 veya > %95 olan sorular
  - Hiç seçilmeyen çeldiriciler
  - Güçlü kullanıcıların yanlış, zayıfların doğru yaptığı sorular (ters ayırt edicilik)
- **Mevzuat takibi:** Resmî Gazete'de ilgili kanunlarda değişiklik → etkilenen sorular otomatik "kontrolde" durumuna alınır.
- **Yıl başı güncellemesi:** Her Ocak'ta yeniden değerleme oranı, vergi dilimleri, had ve tutarlar güncellenir; yıla bağlı etiketli tüm sorular gözden geçirilir. **Kritik:** 2027 tutarları Aralık 2026 sonunda açıklanacak, yayın seti buna göre son kez kontrol edilmeli.
- Her sınavdan sonra yeni soru kitapçıkları analiz edilir ve konu ağırlıkları güncellenir.

## 8. Soru dağılımı (taslak, Kapı M'de kesinleşecek)

| Ders | Yayın seti (1000) | Hedef (2000) |
|---|---|---|
| Finansal Muhasebe (+ Standartlar) | 170 | 340 |
| Finansal Tablolar ve Analizi | 100 | 200 |
| Maliyet Muhasebesi | 110 | 220 |
| Muhasebe Denetimi | 110 | 220 |
| Vergi Mevzuatı ve Uygulaması | 150 | 300 |
| Hukuk | 150 | 300 |
| Sermaye Piyasası Mevzuatı | 70 | 140 |
| Meslek Hukuku | 70 | 140 |
| Ekonomi + Maliye (SGS) | 70 | 140 |
| **Toplam** | **1000** | **2000** |

Zorluk hedefi: %30 kolay · %50 orta · %20 zor. Her ders hem SGS hem Yeterlilik düzeyini kapsar.

## 9. Uygulama özellikleri

### 9.1 İlk sürüm (MVP)

- Sınav seçimi (SGS / Yeterlilik), çok sınavlı altyapıya hazır
- Ders ve konu bazlı çalışma
- **Gerçek sınav simülasyonu:**
  - Yeterlilik: ders başına 20 soru, 45 dk, 0,25 ceza, ders ≥50 / ortalama ≥60 değerlendirmesi
  - SGS: 130 soru, 165 dk, ceza yok
- Ayrıntılı açıklama ve kaynak madde gösterimi
- Yanlış defteri ve aralıklı tekrar
- İlerleme istatistikleri: ders bazında başarı, zayıf konular
- Sınav tarihine geri sayım
- "Hata bildir"
- İnternetsiz çalışma (içerik paketleri cihazda)
- Ücretsiz katman (günlük soru limiti) + abonelik
- KVKK aydınlatma metni, gizlilik politikası, "TÜRMOB/TESMER ile resmî bağlantımız yoktur" ibaresi

### 9.2 Sonraki sürümler

- Kişiselleştirilmiş çalışma planı
- Yapay zekâ ile "bu soruyu bana tekrar anlat"
- SGS genel kültür / yetenek / yabancı dil bölümleri
- Sıralama ve deneme sonuç karşılaştırması
- Kurumsal (oda, kurs) toplu lisans
- Web sürümü ve SEO sitesi entegrasyonu

## 10. Teknik mimari (öneri)

| Katman | Seçim | Gerekçe |
|---|---|---|
| Mobil + web | **Flutter** | Tek kodla iOS, Android ve web |
| Yerel veri | SQLite (Drift) | İnternetsiz çalışma |
| Sunucu | **Supabase** (Postgres) | İlişkisel içerik yapısı, SEO sitesiyle ortak veri |
| Ödeme | **RevenueCat** | Mağaza aboneliklerini tek yerden yönetir |
| Analitik | PostHog | Soru istatistikleri ve kullanıcı davranışı |
| İçerik hattı | Python araçları + repo içinde YAML/JSON | Sürüm kontrolü, inceleme ve geri alma kolaylığı |
| SEO sitesi | Statik site (F6) | Aynı soru bankasından üretilen örnek sayfalar |

**Depo yapısı (taslak):**

```
mevo/
  docs/          planlar ve araştırmalar
  content/       müfredat ağacı, kaynak arşivi, soru bankası (YAML)
  pipeline/      üretim ve kalite kapıları (Python)
  app/           Flutter uygulaması
  web/           SEO sitesi
```

## 11. Hukuk ve operasyon kontrol listesi

| # | İş | Sorumlu | Faz |
|---|---|---|---|
| 1 | Muhasebeciyle 20/B istisnasını teyit et, istisna belgesi ve özel banka hesabı | Merve + muhasebeci | F0 |
| 2 | Ayırt edici marka adı seç, TÜRKPATENT'te 9. ve 41. sınıf araması | Merve | F0 |
| 3 | Apple Developer (bireysel, 99 $/yıl) + Small Business Program | Merve | F0 |
| 4 | Google Play geliştirici hesabı (25 $); adres görünürlüğü için iş adresi kararı | Merve | F0 |
| 5 | Muhasebeciyle iş birliği, telif devri ve gizlilik sözleşmesi (yazılı) | Merve | F0 |
| 6 | KVKK aydınlatma metni, gizlilik politikası, kullanım koşulları | Claude taslak + Merve onay | F3 |
| 7 | Supabase veri bölgesi; yurt dışı aktarım varsa standart sözleşme + 5 iş günü içinde bildirim | Claude + Merve | F3 |
| 8 | 12+ beta test kullanıcısı bul (gerçek adaylar) | Merve + muhasebeci | F4 |
| 9 | Mağaza metinleri, ekran görüntüleri, "resmî bağlantı yoktur" ibaresi | Claude + Merve | F6 |

## 12. Riskler

| Risk | Olasılık | Etki | Önlem |
|---|---|---|---|
| Yanlış soru yayına girer, güven kaybı | Orta | Yüksek | 10 kapı + uzman örneklemi + 48 saatlik düzeltme |
| Uzmanın zamanı yetmez | Orta | Yüksek | Örneklem planı; gerekirse ikinci uzman; takvim değil kapsam daraltılır |
| Mevzuat veya yıla bağlı tutarlar değişir | Kesin | Orta | Geçerlilik etiketleri + yıl başı güncellemesi |
| Sınav formatı yeniden değişir | Düşük | Yüksek | Format ayarları koddan bağımsız yapılandırma dosyasında |
| Müşavirler Kulübü mobile geçer | Orta | Orta | Kalite, uzman onayı ve birebir simülasyonla ayrışma |
| Talep beklenenden düşük | Orta | Orta | Erken beta ile ölçüm; MYK hızla eklenebilir |
| Telif veya marka şikâyeti | Düşük | Yüksek | Özgün içerik, logo yok, "resmî bağlantı yok" ibaresi, G7 benzerlik kapısı |
| Mağaza reddi | Düşük | Orta | Yönergelere uygun metinler, tek uygulama yapısı |

## 13. Açık sorular

| # | Soru | Kime |
|---|---|---|
| A1 | Yeterlilik derslerinin oturum dağılımı | Muhasebeci / resmî duyuru |
| A2 | SGS dönem başı aday sayısı | Muhasebeci / oda |
| A3 | Yeni format başarı durumu ve aday geri bildirimi | Muhasebeci |
| A4 | 20/B uygunluğu | Muhasebeci |
| A5 | En zor dersler | Muhasebeci |
| A6 | Sınav Yönetmeliği md.14'teki resmî ders kapsamları | Resmî belge |
| A7 | 2027 sınav takvimi | TÜRMOB (genellikle Ocak'ta) |
| A8 | Muhasebecinin rolü ve karşılığı (ücret, gelir payı, isim kullanımı) | Merve |

## 14. Hemen sıradaki adımlar

**Merve:**
1. Resmî belgeleri yükle (liste: konuşma geçmişindeki 6 belge) **veya** ağ erişimini aç
2. Muhasebeciyle görüş (A1–A5, A8)
3. Marka adı önerileri düşün

**Claude:**
1. Repo iskeletini kur (`content/`, `pipeline/`, `app/`)
2. Soru şablonunu (şema) ve G2 otomatik yapı kontrolünü yaz
3. Müfredat ağacının ilk taslağını hazırla; resmî kapsamla teyit için bekletilecek kısımları işaretle
