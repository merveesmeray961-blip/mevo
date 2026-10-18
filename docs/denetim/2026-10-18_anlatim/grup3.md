# Grup 3 — SMMM VER + YMM DRM, DTK, FYN, GUV, HSV (2026-10-18)

Dört alt iş raporu birleştirildi. Hakem notları: DRM/YMM'de 'VUK md. 227' atfı 'mük. md. 227' olarak düzeltildi; 9160/11257 CBK oranları kaynakta doğrulandı.

---

# Grup 3 — VER (Vergi Mevzuatı ve Uygulaması) denetim raporu

Kapsam: `content/anlatim/smmm/VER/` altındaki 6 dosya. Ölçüt: `docs/devir/ANLATIM_EDITOR_TALIMATI.md`, müfredat `content/mufredat/smmm.yaml` (kod: VER), mevzuat `content/kaynaklar/mevzuat/*.txt`. Mevzuat metinleri 2026 ortasına kadarki değişiklikleri içeriyor (7566, 7577, 7578, 7582, 7587, 7590 sayılı Kanunlar); kontroller bunlara göre yapıldı.

Ortak değişiklik: Gövde metnindeki bütün para tutarları "TL" yerine "₺" biçimine çevrildi (ör. "58.000 ₺", "5 milyon ₺"). Ön bilgideki alıntılara dokunulmadı; kaynakta "TL" geçtiği için orada aynen kaldı. `durum` alanı hiçbir dosyada değiştirilmedi. Bütün alıntılar `pipeline.anlatim` alıntı denetiminden geçiyor; ayrıca elle Grep ile örneklendi.

Doğrulama: `PYTHONIOENCODING=utf-8 python -m pipeline.anlatim` çıktısında 6 dosyanın hepsi "tamam".

### VER/AAT.md

- Olgu kontrolü: 6183 md. 13 (7 sebep), 14, 15 (15 gün, 7061 ile 7'den 15'e çıkmış), 16, 17–18, 51 (gecikme zammı %3,7, 13.11.2025 tarihli ve 10556 sayılı CK), 55, 58, 60, 102–104 metinle karşılaştırıldı. Olgu hatası bulunmadı.
- Düzeltme: Çözümlü örneğin 4. adımı belirsizdi ("son gün ileri kayar"). Yerine md. 104'e göre süre kaldığı yerden devam eder ve bir yıllık durmayla son gün **31.12.2033** olur hesabı yazıldı.
- Ekleme: Kesilme (md. 103) ile durma (md. 104) ayrımını anlatan yeni bir "Sınav ipucu" kutusu eklendi. Tarhiyat ihbarnamesi tebliği, uzlaşma talebi ve dava açılmasının md. 103'te sayılmadığı vurgulandı. Kesilmede önceki sürenin silindiği de açıkça yazıldı.
- Müfredat: ihtiyati haciz, ödeme emri, tahsil zamanaşımı ve kesen haller işlenmiş; eksik kazanım yok.
- Emin olunamayan: Yok.
- Son kelime sayısı: 1.515. Doğrulama: tamam.

### VER/DIG.md

- Olgu düzeltmeleri:
  - Damga vergisi: "2026 tarifesinde binde 9,48 / 1,89 / 7,59" ifadesi yanlış anlamaya açıktı. Bu nispi oranlar yıllık güncellenmez. Metin şöyle düzeltildi: her yıl yeniden değerleme oranında artırılan, maktu tutarlar ile kâğıt başına azami vergi tutarıdır (DVK md. 14). Özetteki "2026'da sözleşmelerde binde 9,48" ifadesi de buna göre düzeltildi.
  - ÖTV engelli istisnası: Eski metin "2.873.900 ₺ sınırı (c) alt bendi için" diyordu. Doğrusu "(a) ve (c) alt bentleri için": ÖTV (II) sayılı liste tebliği, 2026 için (a) bendine de 2.873.900 TL uyguluyor. Ayrıca (c) bendinin 7577 sayılı Kanunla (2.4.2026) yeniden düzenlendiği eklendi (özel tertibat yaptıranlar ile ortopedik engelliliği %40 ve üzeri olup sürücü belgesi alamayanlar).
  - Doğrulanamayan bir cümle çıkarıldı: "Emlak vergisi borcu bulunan binanın devri tapuda yapılmaz." Yerine EVK Geçici md. 23 (7566 sayılı Kanun) eklendi: 2026 vergi değeri, 2025 değerinin iki kat fazlasını geçemez.
- Eklemeler: VİV'de şans oyunları, yarışma ve çekiliş ikramiyelerine düz **%20** oran uygulandığı eklendi (VİVK md. 16).
- Sıkılaştırma: Uzunluk sınırını korumak için ÖTV "diğer istisnalar", MTV kamu idareleri istisnası ve bina tanımı kısaltıldı.
- Hesaplar elle yeniden yapıldı ve doğru çıktı: damga 18.960 ₺; VİV 20.928,64 ₺ ve 50.000 ₺; bina vergisi 6.000 ₺.
- Emin olunamayan noktalar:
  - Damga vergisi 2026 azami tutarı mevzuat dosyasında yok; dosyada yalnız 2023 tutarı (10.732.371,80 TL) var. Bu yüzden metne rakam yazılmadı.
  - EVK Geçici md. 23'teki "iki kat fazlasını geçemez" ifadesi kanun lafzıyla aktarıldı ve yorumlanmadı (2 kat mı, 3 kat mı tartışmalı).
  - 7582 sayılı Kanunla VİVK md. 16'ya eklenen fıkra (GVK mükerrer 20/D kapsamındakilere veraset oranı %1) metne alınmadı. İstenirse eklenebilir.
- Son kelime sayısı: 2.216. Doğrulama: tamam.

### VER/GVK.md

- Olgu kontrolü: GV Genel Tebliği Seri No: 332 ile karşılaştırıldı. 2026 tarifesi (190.000 / 400.000 / 1.000.000, ücrette 1.500.000 / 5.300.000), mesken kira istisnası 58.000 ₺, md. 86/1-d sınırı 22.000 ₺, değer artışı istisnası 150.000 ₺ ve uyum indirimi üst sınırı 12.000.000 ₺ doğru. Şunlar da metinle teyit edildi: md. 18 ve 21 şartları, md. 74/4 (7566, konut borç faizi), mükerrer md. 120 (7566 ile dördüncü dönem, 14/17 günleri), md. 121 ve mükerrer md. 121 şartları.
- Hesaplar elle yeniden yapıldı ve doğru çıktı: konut değer artışı 1.150.000 ₺; Ayşe'nin ödenecek vergisi 172.500 ₺ (vergi 442.500 ₺); Mehmet'in ödenecek vergisi 285.875 ₺.
- Düzeltme: "Satış Nisan 2028'den sonra yapılsaydı" ifadesi düzeltildi. Mart 2023'te edinilen konutta beş yıl Mart 2028'de dolar. İvazsız edinimde değer artışı doğmadığı notu eklendi.
- Müfredat: md. 18 ve 21 istisnaları, ücret ve kira beyan sınırları, menkul sermaye iradı, değer artışı, md. 89 indirimleri, mahsuplar, geçici vergi ve uyum indirimi işlenmiş; eksik yok.
- Emin olunamayan: 7578 sayılı Kanunla md. 89'a Darülaceze eklendi; metin bununla zaten uyumlu. GVK md. 23'teki 7582 değişiklikleri konu kapsamı dışında kaldığı için işlenmedi.
- Son kelime sayısı: 1.980. Doğrulama: tamam.

### VER/KDV.md

- Olgu kontrolü:
  - KDVK md. 1, 6, 9, 11/1-c, 12, 29 (1-ç; 7491 ile 2024'ten itibaren), 29/2, 29/3, 30 (a parantezi 17/2-b, c, d ve 17/4-ı, ö; c zayi), 32 ve 35 metinle teyit edildi.
  - KDV GUT tevkifat oranları kontrol edildi: temizlik, çevre ve bahçe bakımı 9/10 (dipnotla değişmiş), makine bakım-onarım 7/10, yapım işleri 4/10 ve KDV mükelleflerine 5 milyon ₺ eşiği doğru.
  - VUK 588'e göre md. 232 fatura sınırı 2026'da 12.000 ₺; doğru.
- Hesaplar elle yeniden yapıldı ve doğru çıktı: devreden KDV 50.000 ₺; yevmiye kaydı (391 B 390.000 / 191 A 260.000 / 190 A 130.000) dengeli; alternatif durumda ödenecek tutar 150.000 ₺.
- Olgu hatası bulunmadı; yalnız para birimi biçimi düzeltildi.
- Not: 2026 tarihli yeni hükümler (md. 17/4-ğ kamulaştırma devri, 7577; Geçici md. 46 UEFA, 7566; Geçici md. 47 nükleer, 7590) müfredat kazanımı olmadığı için eklenmedi.
- Son kelime sayısı: 1.863. Doğrulama: tamam.

### VER/KVK.md

- Olgu kontrolü:
  - KVK md. 3 ve 5/1-a, b (7491 ile eklenen %50 / %50 kuralı dahil) ve 5/1-e (%75) teyit edildi.
  - md. 9, 11 (h %50, j, k: 7577 ile şans oyunu reklamı) ve 11/1-i (%10, 3490 sayılı CK) teyit edildi.
  - md. 12, 17 (30 gün, vazgeçme) ve 32 teyit edildi. 7582 ile değişen md. 32/8 üretim kazancında %12,5 oranı 2027 ve sonrasındaki kazançlara uygulanır; 2026'da 1 puan indirim sürer (değişiklik cetveli ve KVK GT 1 alıntısı).
  - md. 32/B ve 32/C (7582 ile eklenen d bendi ve 10/g-j) teyit edildi.
- Hesaplar elle yeniden yapıldı ve doğru çıktı: örtülü sermaye nedeniyle KKEG 600.000 ₺; finansman gider kısıtlaması nedeniyle KKEG 60.000 ₺; asgari KV 113.000 ₺, normal hesapla bulunan 57.500 ₺'nin üzerinde.
- Eklemeler:
  - md. 32/C-3: indirimli oranlar (halka arz, ihracat, üretim) ve 32/C'den önce alınmış teşvik belgelerindeki yatırıma katkı nedeniyle alınmayan vergi, asgari vergiden indirilir.
  - Sermaye azaltımı için çözümlü örnek eklendi: beş yıl dolmadan sıralama, beş yıl dolduktan sonra oranlama (2.000.000 ₺ × 4/10 = 800.000 ₺ stopaja tabi). Stopaj matrahının, hesaplanan KV düşüldükten sonra kalan tutar olduğu eklendi.
- Müfredat: tam ve dar mükellefiyet, iştirak kazancı, KKEG, geçmiş yıl zararı, örtülü sermaye, finansman gider kısıtlaması, asgari KV, tasfiye ve sermaye azaltımı işlenmiş; eksik yok.
- Emin olunamayan: 32/C-2-d bendindeki 7412 sayılı Kanun indirimi metinde ayrıca adlandırılmadı.
- Son kelime sayısı: 1.817. Doğrulama: tamam.

### VER/VUK.md

- Olgu kontrolü:
  - VUK md. 258–268/A, 267 (sıra, %25 şartı, %5 / %10, takdir ve dava), 274 ve 279 teyit edildi.
  - md. 341 ve 344 teyit edildi (7524 ile mükellefiyetsiz faaliyette %50 artırım).
  - md. 359 teyit edildi: (a) 18 ay–5 yıl, (b) ve (ç) 3–8 yıl, (c) 2–8 yıl; ödeme halinde 1/2 ve 1/3 indirim.
  - md. 370 teyit edildi; 2026 sınırı 870.000 ₺ (VUK 588). Bu cezanın uzlaşmaya konu edilemeyeceği Ek md. 1'de var.
  - md. 371 (5 şart, emlak vergisi hariç), 374 ve 376 (7524 ile 2. bent mülga), 114 teyit edildi.
- Hesaplar elle yeniden yapıldı ve doğru çıktı: emsal bedeli 1.900.000 ₺, 1.680.000 ₺ ve 1.760.000 ₺; pişmanlık 114.800 ₺; izaha davet 134.800 ₺.
- Olgu hatası bulunmadı; yalnız para birimi biçimi düzeltildi.
- Not: 7587 sayılı Kanunla değişen md. 107/A (elektronik tebligat) konu kapsamı dışında kaldı.
- Son kelime sayısı: 1.759. Doğrulama: tamam.

---

# Grup 3 — DRM ve DTK anlatım denetimi (2026-10-18)

Doğrulama: `python -m pipeline.anlatim on_eleme content/anlatim/ymm/DRM --sinav ymm` → 5/5 geçti; DTK → 5/5 geçti (GMR [A05] reddi kapatıldı). Tüm `alinti` alanları otomatik aramadan geçti. `durum: taslak` hiçbir dosyada değiştirilmedi. Git çalıştırılmadı; soru YAML'larına dokunulmadı.

Genel not: `content/mufredat/ymm.yaml` yeniden yapılandırılmış. DRM'de disiplin, çalışma usul, çalışanlar listesinden silinme ve haksız rekabet **DSP** konusuna; SMGE, etik, 5549, 5510, defter-kayıt ve mesleki şirketler **DGY** konusuna taşınmış. DTK'da muafiyetler, tasfiye, kaçakçılık ve damping **TKP** konusuna ayrılmış. Bu konuların anlatım dosyaları bu grubun kapsamında değil; ilgili rapor maddeleri aşağıda "başka konuya taşındı" diye işaretlendi.

Kaynak notu: Birçok bilgi TÜRMOB sınav komisyonu cevap anahtarından (content/kaynaklar/cikmis/ymm/*.txt) alındı, çünkü ilgili tebliğ veya yönetmelik mevzuat klasöründe yok. Metinde bu yerler "metni bu klasörde yok, TÜRMOB 20xx cevabına göre" diye açıkça işaretlendi; bunlar için `alinti` yazılmadı.

---

### DRM/MHK.md

Baştan yazıldı. Başlık yeni müfredat adına çekildi ("3568 sayılı Kanun, odalar ve TÜRMOB"). Yeni kazanımlar: şartlar ve yasaklar; unvanın korunması ve ruhsat; odalar ve TÜRMOB; organlar ve görevleri; oda ve Birlik gelirleri; meslek sırları; ücret tarifesi.

Önemli düzeltmeler:
- Sınav komisyonu: "biri YÖK'ün, ikisi Birliğin önerdiği adaylar arasından" → "biri YÖK'ün önerdiği **iki aday** arasından, ikisi Birliğin önerdiği **dört aday** arasından, **Bakan tarafından** seçilir" (3568 md. 10). Aday nitelikleri ve üç kişilik bilirkişi heyeti eklendi.
- Genel şartlar (md. 4) bent bent (a–f) verildi; eski metindeki eksik suç listesi düzeltildi.
- md. 45/2'nin ikinci yarısı eklendi: bu yakınlıktaki SMMM'lerin baktığı işleri tasdik edemez.
- 2026 ücret tarifesinin sayısal hesabı (KV tasdik ücreti örneği) çıkarıldı (rapor B6-MHK madde 11). Yerine md. 46'daki dört adımlı süreç kondu.

Kapatılan "somut eksikler" (YNM_DRM.md B6, MHK):
- 1: md. 16 oda gelirleri ve %50 indirim, md. 30 Birlik gelirleri (YMM Odaları Yön. md. 15–16 ayrıntısıyla).
- 3: md. 31 dört organ ve md. 39 Birlik Denetleme Kurulu (tablo halinde).
- 4: Oda Disiplin Kurulunun oluşumu (md. 25: 3/5 üye, 1/3 yedek, üç yıl kıdem, toplantı ve karar yeter sayısı, 30 gün itiraz) ve görevi (md. 26).
- 5: Oda Genel Kurulu (md. 19), Oda Yönetim Kurulu (md. 23 ve YMM Odaları Yön. md. 12), Birlik (md. 29), Birlik Genel Kurulu (md. 33) ve Birlik Yönetim Kurulu (md. 36) görev listeleri; Birlik Genel Kurulunun oluşumu (md. 32).
- 7: md. 1 amaç, md. 50 yönetmeliklerle düzenlenecek hususlar (a–n), md. 3 ve md. 49 unvanın haksız kullanılması, md. 10 aday nitelikleri ve bilirkişi heyeti.
- 8: Meslek sırları (md. 43) dört istisna, personel kapsamı ve md. 49/2 yaptırımıyla ayrı bölümde işlendi.
- Ek: ruhsat verilmesi ve ret kararına itiraz süreci (2024/3 S4; Birlik YK, 60 gün tebliğ, 30 gün içinde Bakana itiraz, Birlik 15 gün içinde gönderir), ruhsat iptali (Çalışma Usul Yön. md. 63/A, 2025 eki).

Başka konuya taşınanlar (bu dosyada yalnız bağlantı cümlesi var): 2 (çalışanlar listesinden silinme, DSP), 6 (md. 48'e 7546 ile eklenen "başka meslek mensubunun adıyla beyanname" fiili, DSP), 9 (HRMK ve şikâyet süreci, DSP), 10 (SMGE, Etik İlkeler, Meslek Ahlak MMK, DGY; Disiplin Yön. md. 30, DSP).

Emin olunamayan ve kapatılamayan noktalar:
- Ruhsat süreci "Başvurular Hakkında Yönetmelik"e dayanıyor; yönetmelik klasörde yok, süreç TÜRMOB 2024/3 cevabından alındı.
- 1.800 kelime sınırı nedeniyle oda genel kurulu toplantı usulü (md. 20'deki 1/5 talep, ilan süresi, yeter sayı) ve md. 40 seçim esasları işlenmedi.

Son kelime sayısı: 1.798 (ön eleme sayımı).
Kontrolde'ye terfi edilebilir mi: **Evet.** Sınavda sorulan bütün MHK maddeleri madde numarası ve bent bent işlendi; olgular 3568 ve YMM Odaları Yönetmeliği metniyle doğrulandı. Şartı: DSP ve DGY dosyalarının taşınan maddeleri kapsadığı ayrıca kontrol edilmeli.

### DRM/YMM.md

Baştan yazıldı.

Önemli düzeltmeler ve eklenenler:
- Eski metindeki "VUK md. 227 kaynak setinde yok" ifadesi yanlıştı (vuk.txt'de mük. md. 227 var) → maddenin içeriği eklendi: Bakanlığın üç yetkisi, vergi, ceza ve gecikme faizinden müteselsil sorumluluk, 60 günlük mühlet ve iki aya kadar uzatma, KİT istisnası.
- Sözleşme örneğinde olgu hatası düzeltildi. Eski metin fesih yasağını beyan ayı kontrolüne bırakıyordu. Yeni metinde 2026 dönemine ait sözleşmenin beyan ayının Nisan 2027 olduğu, yasağın Ocak–Mart 2027'yi kapsadığı ve 4 Mart 2026 feshinin geçerli olduğu gösterildi.
- Fazla işlenen KDV iade ücret tarifesi rakamları (17.005 TL vb.) çıkarıldı (B6-YMM madde 8).

Kapatılan "somut eksikler" (B6-YMM):
- 1: VUK mük. 227.
- 2: Karşıt inceleme: tanım, amaç, %80 kuralı, tutanaktaki 15 bilgi, teyit yazısı, zorunlu olmayan haller (65.000 / 195.000 TL, kamu alımları).
- 3: Denetim teknikleri md. 15 (a–f), analitik inceleme, tekniklerin uygulanacağı dönem; kanıt toplama md. 14; planlama md. 13.
- 4: İnceleme yeri md. 11, yetkiler md. 12, çalışma kâğıtlarının içeriği md. 17 (a–e, mülkiyet, 10 yıl).
- 5: md. 7 tasdik konularının tam listesi (A–G).
- 6: Tam tasdik raporunun "III-Hesap İncelemeleri" ve "IV-Sonuç" bölümleri, ticari kârdan mali kâra geçiş.
- 7: 46 SN tebliğ hadleri (2.600.000 / 1.300.000 / 350.000 TL; karşıt inceleme 65.000 / 195.000 TL) ve 1 SN e-gönderim tebliği esasları eklendi; tebliğ metinleri klasörde olmadığı için kaynak TÜRMOB 2023/3 cevabı. 18 SN tebliğe göre müteselsil sorumluluk takibatı (2022/1 S4b) tebliğ olmadığı için işlenmedi; yalnız müteselsil sorumluluğun tanımı verildi.
- KDV iade tasdiki: KDV GUT'tan 50.000 TL raporsuz iade sınırı, YMM raporunun geçerlik tarihi ve birden fazla dönem için tek rapor eklendi. Çözümlü sayısal örnek (900.000 TL iade) eklendi.

Emin olunamayanlar:
- 46 SN hadleri 2023 için belirlenmiş ve "özel belirleme yapılmadıkça artışsız uygulanır" denmiş. 2024–2026 için yeni bir tebliğ çıkıp çıkmadığı klasörden doğrulanamadı; metinde uyarı var.
- Tam tasdik raporu bölüm içeriklerinin dayandığı tebliğin seri numarası cevap anahtarında yok.

Son kelime sayısı: 1.766.
Kontrolde'ye terfi edilebilir mi: **Evet.** Altı kazanımın hepsi ayrı bölümde ve sınavda sorulan bütün maddeler işlendi. Tebliğe dayalı hadler hakem tarafından güncel tebliğle bir kez karşılaştırılmalı.

### DRM/RAP.md

Düzeltmeler: "Tam tasdik ifadesi kaynaklarda yalnız tarifede geçer" ifadesi eksikti (KDV GUT'ta "tam tasdik sözleşmesi" sık geçer). Yerine md. 7/A-a ve 7/B-a eşleşmesi ve rapor bölümleri yazıldı.

Eklenenler: meslek mevzuatına göre dört rapor türü (Defter ve Kayıtlar ile Bildirim Mecburiyeti Yön. md. 13: özet standart denetim, tasdik, özel amaçlı, yardımcı rapor; 2023/3 S4a) ve görüşe göre olumlu, şartlı ve olumsuz rapor ayrımı (2022/2 S2b). Bu ayrımın BDS 705 terimlerinden farkını anlatan not eklendi. Yönetmelik klasörde yok; kaynak TÜRMOB cevabı.

BDS 700/705/706/701 bölümleri kontrol edildi; hata bulunmadı.
Son kelime sayısı: 1.636.
Kontrolde'ye terfi edilebilir mi: **Evet.**

### DRM/BDS.md

Değişiklik yapılmadı. Paragraf numaraları ve görüş tablosu (BDS 570.21–23) kontrol edildi; hata bulunmadı. Alıntılar geçti, tasdik uygulama notu var. Konu 13 dönemde hiç sorulmadı (yaml ağırlığı 5), bu yüzden genişletilmedi.
Son kelime sayısı: 1.276.
Kontrolde'ye terfi edilebilir mi: **Evet.**

### DRM/KGK.md

Düzeltme: inceleme notundaki bozuk cümle ("tasdiki yasaklanan denetim dışı hizmetlerin dışında tutar") Yönetmelik md. 22/5'in gerçek içeriğine göre yeniden yazıldı: tasdik, vergi danışmanlığı ve vergi denetimi yasak hizmetlerin dışındadır. Kurul yapısı (9 üye, iki haftada bir, 6/5 yeter sayı), md. 28 sorumlu denetçi tecrübesi (15/10 yıl), 60 gün, 20 gün ve 30 gün süreleri kaynakta doğrulandı.
Son kelime sayısı: 1.330.
Kontrolde'ye terfi edilebilir mi: **Evet.**

### DTK/GMR.md

Baştan düzenlendi. [A05] reddi kapatıldı: "Kararlar, bilgi ve süreler" ayrı bölüm oldu.

Eklenenler (DTK_SPM.md bölüm 7 "Somut eksikler"):
- md. 6–7 kararlar: 30 gün, yazılı tebliğ, gerekçe, md. 7/1'deki üç şartın birlikte bulunması, md. 7/2 ve yürürlük tarihleri.
- md. 8 bilgi talebi; md. 9 bağlayıcı bilgi; geçerliliğini yitiren bilginin altı ay daha kullanılması (md. 9/7).
- md. 14 süreler ve Gümrük Yönetmeliği md. 31'deki mücbir sebep listesi (a–ğ).
- Geri verme ve kaldırma md. 210–217 tamamı (tablo). md. 216/1'in AYM'ce 22/7/2025'te iptal edildiği ve 216/2'deki dört ay ile kanuni faiz yazıldı.
- Zamanaşımı ve kesinleşme: md. 197/2 üç yıl ve davanın durdurucu etkisi, 197/4 TCK süreleri, 197/5 kesinleşme, md. 231/2.
- md. 208 sona erme halleri tamamlandı. Eski metinde (e) bendi (kanuna aykırı girişte müsadere) eksikti. md. 209 eklendi.
- Gümrük Yönetmeliği md. 38–39 menşe şahadetnamesi: altı ay süre, 30 gün uzatma, 430 Avro.
- md. 3/24–25 risk ve risk yönetimi.
- Zamanaşımı ve süre hesabı için iki kısa örnek eklendi.

Kısaltılanlar: muhasebe kaydı satırı, md. 46/2 özet beyan süresi, md. 69 ve md. 4 ayrıntıları.

Kapatılamayanlar:
- md. 57 fikri mülkiyet önlemleri hiçbir DTK kazanımında yok.
- md. 167 muafiyetler TKP konusuna ait.
- Gümrük Yönetmeliğindeki indirgeme yöntemi ayrıntısı, istisnai kıymetle beyan, royalti beyanı (GGT Seri 2), bölünmüş beyanname, özet beyan eksiklik/fazlalık ve yükümlülük doğurmayan ihmaller (GY md. 486) 1.800 kelime sınırı nedeniyle eklenmedi. Gümrük Yönetmeliği artık klasörde var (gumruk_yonetmeligi.txt); bu başlıklar ayrı bir "GY uygulama" konusu ya da REJ ve VRG'ye dağıtım için önerilir.

Son kelime sayısı: 1.763.
Kontrolde'ye terfi edilebilir mi: **Evet.** Yedi kazanımın hepsi işlendi. Yalnız GY uygulama ayrıntıları için yaml'da ayrı kazanım veya konu açılması düşünülmeli.

### DTK/KMB.md

Baştan düzenlendi.

Olgu hatası:
- Eski: "İhracat bedeli süresi Kararda yok, kaynaklarda yer almaz; Karar düzeyinde kural tasarruf serbestliğidir." Yeni: Tebliğ 2018-32/48 md. 3–8 süreleri. Bunlar 180 gün; peşin dövizde 24 ay; müteahhitte 365 gün; konsinye ve fuarda 180 gün; geçici ihracatta 90 gün; kredili ihracatta 90 gün; 180 günden uzun vadede vade sonrası 90 gün; ihbar için 5 iş günü, ihtarname için 10 iş günü ve 90 gün. Sınavı yanlış yönlendiren hata giderildi.
- Döviz cinsinden sözleşme istisnaları için eski metin "Bakanlık düzenlemeleri kaynaklarda yok" diyordu. Tebliğ 2008-32/34 md. 8 klasörde var; başlıca istisnalar eklendi.

Kapatılan eksikler: yetkili müesseseler (Tebliğ 2018-32/45 md. 4 A ve B grubu faaliyet konuları, md. 6 kuruluş şartları: 10 ve 5 milyon TL), md. 17/A-3 yurt içi döviz kredisi halleri (a–ğ), md. 18 gayrinakdi krediler, md. 6 dövize ilişkin işlemler, md. 7/4 kıymetli madenlerin yurt içi alım satımı. Rafineri kuruluş şartları (Tebliğ 2023/1 md. 7, 35 milyon TL) ve KMB aracı kuruluş yasakları (yönetmelik md. 13) da eklendi; bu ikisinin metni klasörde yok, kaynak TÜRMOB 2026/1 ve 2022/1 cevapları.

Kısaltılanlar: hiç sorulmamış döviz cinsinden sözleşme bölümü, kur farkı muhasebe kaydı örneği (yerine 180, 365 ve 90 gün hesap örneği kondu).

Emin olunamayanlar:
- KMB aracı kuruluş yasakları 2022 cevabına dayanıyor; yönetmeliğin 2026 metni doğrulanamadı.
- Sürelerde "işlem günü sayılmaz" kuralı Karar md. 22'den tebliğe uygulandı.

Son kelime sayısı: 1.708.
Kontrolde'ye terfi edilebilir mi: **Evet.** Rafineri ve aracı kuruluş tebliğ ve yönetmelikleri klasöre eklenince bir kez daha doğrulanmalı.

### DTK/REJ.md

Eklenenler:
- Gümrük kontrolü altında işleme (md. 123–126) ve izin şartları (2023/3 C3).
- Hariçte işleme uygulanmayan haller (md. 136), izin şartları (md. 137–138) ve sürenin uzatılması (2024/3 C3).

Kısaltılan: geçici ithalat örneğindeki muhasebe kaydı.

Kapatılamayanlar: ekonomik etkili rejimlerde ekonomik koşullar ve ticaret politikası önlemleri (GY md. 116, 149; 2024/1 C3); geçici ithalatta 2009/15481 BKK cezası (2022/3 C4; BKK klasörde yok). Geri gelen eşya ve muafiyetler TKP konusunda.
Son kelime sayısı: 1.676.
Kontrolde'ye terfi edilebilir mi: **Evet.**

### DTK/VRG.md

Düzeltme: İthalde KDV örneği oran yerine "x" ile çözülmüştü; "her sayısal örnek tek sonuca bağlanmalı" kuralına aykırıydı. Genel oran %20 ile (2007/13033 Kararı, 7346 sayılı Kararla değişik; 10/7/2023'ten beri) 235.000 TL KDV ve 1.410.000 TL toplam olarak yeniden hesaplandı.

Eklenen: 3218 sayılı Kanun md. 8 (dış ticaret rejiminin uygulanması, 5.000 ABD doları altı Türkiye mahreçli mal) ve md. 9 (dövizle ödeme) (2025/1 C4).

Doğrulanan: usulsüzlük cezasının 2026 tutarı 1.494,00 TL ve AYM'nin 26/3/2026 tarihli iptali (gumruk.txt dipnotları).

Kapatılamayan: serbest bölgeden AB'ye A.TR ile eşya gönderme (GY md. 432; 2024/3 C4), yer sınırı nedeniyle.
Son kelime sayısı: 1.520.
Kontrolde'ye terfi edilebilir mi: **Evet.**

### DTK/IHI.md

Eklenen: İthalat Genelgesi 2020/1 md. 2'deki dokuz ödeme şekli ve işlenmemiş kıymetli madende yalnız peşin, mal mukabili ve bedelsiz (2025/3 C5; genelge klasörde yok, kaynak TÜRMOB cevabı). İhracat bedeli ödeme şekilleri Tebliğ 2018-32/48 md. 3'e bağlandı.

Kısaltılan: muhasebe kaydı listesi tek cümleye indirildi.

Kapatılamayan: İhracat Sayılan Satış ve Teslimler Tebliği (İhracat 2005/2) md. 5 (2024/1 C5); tebliğ klasörde yok.
Son kelime sayısı: 1.559.
Kontrolde'ye terfi edilebilir mi: **Evet.**

---

## Klasöre eklenmesi önerilen metinler

Bu metinler eklenmeden ilgili bilgiler yalnız cevap anahtarına dayanıyor:
- 3568 sayılı Kanun genel tebliğleri: 18, 46 ve diğer seri numaraları; karşıt inceleme ve hadler.
- 1 Sıra No.lu YMM Tasdik Raporlarının Elektronik Ortamda Gönderilmesi Genel Tebliği.
- Başvurular Hakkında Yönetmelik (ruhsat).
- Defter ve Kayıtlar ile Bildirim Mecburiyeti Yönetmeliği.
- Kıymetli Maden Standartları ve Rafinerileri Tebliği 2023/1.
- KMB Aracı Kuruluşları Yönetmeliği.
- İthalat Genelgesi 2020/1.
- İhracat 2005/2 Tebliği.

---

# Grup 3 — GUV (6 dosya) ve FYN (SBT, FPA, SMR) baş editör denetimi

Doğrulama: `python -m pipeline.anlatim on_eleme content/anlatim/ymm/GUV --sinav ymm` → 6/6 geçti; aynı komut FYN için → 6/6 geçti (`--al` kullanılmadı). `durum: taslak` hiçbir dosyada değiştirilmedi. Git çalıştırılmadı; yalnız 9 dosya ve bu rapor yazıldı.

Genel kaynak notu: Kaynak klasöründe 2009/14592 ve 2009/14593 sayılı BKK'lar ile 9286 sayılı CBK'nın metni **yok** (yalnız GVK değişiklik cetvelinde adları geçiyor). Kira ve serbest meslek için %20, GVK 18 telifi için %17, kâr payı için %15 kesinti oranları bu nedenle "uygulamada" diye ve karar numarasıyla yazıldı. Bu metinler klasöre eklenip teyit edilmeli. 9707 sayılı CBK (yıllara yaygın inşaatta %5 ve %1) klasörde var ve doğrulandı.

### GUV/GVM.md
- **Olgu ve güncellik düzeltmeleri:**
  - GMSİ gerçek giderlerinde faiz: eski metinde sınırlama yoktu. 7566 sayılı Kanun md. 1 ile GVK 74/4 değişti ("Konutlar hariç"); 1/1/2025'ten başlayan dönemlerde konut faizi indirilemiyor. Bu eklendi (gvk.txt dipnot 75 ve değişiklik cetveli).
  - "Götürü gider %15" ifadesi tek başına bırakılmıştı; hakları kiraya verenlerin bu usulü seçemeyeceği eklendi.
  - Endeks adı Kanundaki ifadeye çevrildi: "toptan eşya fiyat endeksi (bugün Yİ-ÜFE)".
- **Eklenen konular (GUV_HSV.md 6. bölüm, GVM eksikleri):**
  - Ortaklıkların vergilendirilmesi: adi ortaklık, kollektif şirket, komandite ve komanditer (GVK 37, 66, 75/2-2). GVK 41'in son fıkrasıyla teşebbüs sahibi sayılma ve ortağa ya da eşine ödenen ücret ve faizin KKEG olması. Kollektif şirketten sayısal örnek.
  - Komanditere ödenen ücretin gider olması.
  - Emsal kira (GVK 73, vergi değerinin %5'i ve istisnaları).
  - Gerçek gider kalemleri: %5 iktisap bedeli, amortisman, sigorta, vergi.
  - Konut istisnası ve ticari kazanç sahiplerinin yararlanamaması (GVI'ya atıfla).
  - %20 stopajlı kiranın brüte iblağı.
  - Üründen pay ve ayın kiranın emsal bedeli (GVK 72).
  - Serbest meslekte GVK 68 giderleri (ikametgâh, binek otomobil için 2026 tutarları 1.380.000 / 46.000 TL) ve gider avansı (GVK 67).
  - Dar mükellef gerçek kişinin münferit beyanı (GVK 101, 15 gün).
  - Değer artışında endeksleme örneği, ivazsız iktisap, kat karşılığı daire, yabancı paralı payda kur çevrimi.
  - Kişi bazlı "gelir unsuru → beyan → matrah → vergi → mahsup" tablosu. 2026 tarifesiyle hesaplandı: 1.960.000 TL gelir, 568.500 TL vergi, 120.000 TL stopaj mahsubu, 448.500 TL ödenecek.
- **Kapatılan açıklar:** GUV_HSV.md 6. bölüm GVM listesinin tamamı; 3. bölüm madde 8 (ortaklıklar, GVK 101).
- **Kapatılamayan ve emin olunamayan noktalar:**
  - Satın alınmış telif hakkı için "%6,66 amortisman" oranı yazılmadı. Amortisman listesi kaynak klasöründe yok.
  - Kat karşılığında iktisap tarihi kuralı "idarenin görüşü" olarak yazıldı; kaynak klasöründe özelge yok.
  - Kira kesinti oranı %20, BKK metni klasörde olmadığı için doğrulanamadı.
- **Kelime:** 1.554
- **Kontrolde'ye terfi:** Hayır, şimdilik. Örnek, kaynak klasöründe metni bulunmayan %20 kira kesinti oranına dayanıyor; 2009/14592 sayılı BKK eklenip teyit edilince evet.

### GUV/GVI.md
- **Olgu ve güncellik düzeltmeleri:**
  - Kazanım "geçici vergi ve mahsup" dosyada **hiç yoktu**. Yeni bölüm eklendi (GVK mükerrer 120, 121):
    - oran %15;
    - matraha girmeyenler: GVK 42 kazançları ve noterlik;
    - beyan ikinci ayın 14'ünde, ödeme 17'sinde;
    - %10'u aşan eksik beyanda ikmalen ya da re'sen tarhiyat;
    - yıllık vergiden mahsup, kalanın diğer borçlara mahsubu, yıl sonuna kadar yazılı talep hâlinde iade;
    - GVK 121'e göre bir yıllık iade başvurusu ve YMM raporu yetkisi.
  - 7566 sayılı Kanunla "ilk dokuz ayı için belirlenen" ibaresi çıkarıldı. Değişiklik cetveline göre 1/1/2025'ten başlayan dönemlere ilişkin beyannamelere uygulanıyor; böylece dördüncü dönemde de geçici vergi var. Bu eklendi.
  - Muhtasar beyanname: Kanundaki 23'ü korundu. md. 98/A yetkisi ve uygulamadaki 26'sı açıklandı.
- **Eklenen konular:**
  - Kâr payında yarı istisna (GVK 22/3).
  - Yurt dışı kâr payı istisnası (GVK 22/4): 11257 sayılı CBK ile 2026'dan itibaren sahiplik eşiği %20.
  - Yeni mükerrer md. 20/D (7582): Türkiye'ye 1/1/2026'dan itibaren yerleşenlerin yurt dışı kazançlarına 20 yıllık istisna.
  - GVK 89/13 indirimi: Kanunda %80; 11257 sayılı CBK ile 2026'dan itibaren %100.
  - Uygulamadaki md. 94 kesinti oranları ve brüte iblağ formülü.
  - Kümülatif geçici vergi ve yıllık mahsup örneği: 270.000 TL geçici vergi, 512.500 TL yıllık vergi, 242.500 TL ödenecek.
- **Kapatılan açıklar:** GUV_HSV.md 3. bölüm madde 8 (geçici vergi ve GVK 121 mahsup ile iade).
- **Emin olunamayan noktalar:**
  - md. 94 oranları (%20, %17, %15): BKK ve 9286 sayılı CBK metinleri klasörde yok.
  - Dördüncü dönem geçici vergisinin yürürlük tarihi değişiklik cetvelinden okundu; 7566 sayılı Kanun metni ayrıca kontrol edilmeli.
- **Kelime:** 1.600
- **Kontrolde'ye terfi:** Hayır, şimdilik. Kesinti oranları kaynakta yok ve 7566 sayılı Kanunun yürürlük maddesi doğrulanmalı; ikisi teyit edilince evet.

### GUV/KVI.md
- **Olgu hatası düzeltmeleri:**
  - **5/1-e iştirak hissesi satış istisnası**
    - Eski: örnek %75 ile hesaplanıyordu ve "Kanun metnindeki oran esas alınmıştır" deniyordu.
    - Yeni: 9160 sayılı CBK (RG 27/11/2024) oranı %50 olarak belirliyor; örnek %50 ile yeniden hesaplandı (kvk_cbk_9160.txt).
  - **5/1-b, 7491 paragrafı**
    - Eski: "Oran Kanun metnindekinden farklı olabilir" deniyor, oran verilmiyordu.
    - Yeni: 11257 sayılı CBK md. 2/1 açıkça yazıldı: 1/1/2026'dan başlayan dönemlerde ödenmiş sermayenin en az %20'sine sahiplik ve transfer şartıyla istisna %80 (kvk_cbk_11257.txt).
- **Eklenen konular:**
  - **5/1-h** (önceden hiç yoktu), Tebliğ 5.9'a göre: şartsız; transfer gerekmiyor; teknik hizmetin bağlılık şartı yok ama iş yeri şartı var; KVK 5/3 gereği zarar indirilemiyor; Tebliğ 5.18'e göre faaliyet esaslı.
  - **5/1-f**: Kanun metnine göre taşınmazda %50, diğer kıymetlerde %75; süre ve fon şartı yok. Tebliğ 5.7.1'deki eski "tamamı" ifadesine itibar edilmedi.
  - **5/1-i, 5/1-j, 5/1-k.**
  - Vergi yükü formülü ve %11,25 sayısal testi (2025/3 sınavındaki Alman iştiraki).
  - 5/1-c %75 aktif testi örneği.
  - Enflasyon düzeltmeli maliyet ve kur çevrimi notu.
  - 2026 matrah örneği: 6.300.000 TL kâr, 3.080.000 TL istisna, 805.000 TL KV. Asgari KV kontrolü 492.000 TL, Tebliğ 32.5.6 Örnek 8'e göre yapıldı.
- **Kapatılan açıklar (GUV_HSV.md 6. bölüm, KVI):**
  - 5/1-h;
  - 5/1-f, j, k, i;
  - 5/1-e oranı;
  - vergi yükü örneği;
  - 5/1-c aktif testi;
  - kur farkı ve enflasyon düzeltmeli maliyet (kısmen; ayrıntılı VUK 555 hesabı bu konunun kapsamı dışında).
- **Kelime:** 1.514
- **Kontrolde'ye terfi:** Evet. Bütün oranlar kanun, CBK ve Tebliğ metinleriyle doğrulandı ve alıntılar birebir.

### GUV/KVM.md
- **Olgu kontrolü:**
  - Hata bulunmadı. Kontrol edilenler: KVK 11 bent sırası (j ve k dahil, k = 7577 şans oyunları), %25/%30 oranları, md. 14 ve 21 süreleri, zarar mahsubu örneği.
- **Eklenen konular:**
  - Örtülü sermaye (KVK 12): üç kat ve %50 kuralları, istisnalar, faizin dağıtılmış kâr payı sayılması, sayısal örnek.
  - Finansman gider kısıtlaması (KVK 11/1-i): 3490 sayılı CBK ile %10; sayısal örnek (60.000 TL).
  - Tebliğ 11.13'e göre örtülü sermayenin önce ayrılması.
  - KVK 8/ç: komandite kâr payının indirilmesi.
  - Tahakkuk esası.
  - Geçici verginin KV oranında ve dört dönem için ödenmesi.
- **Kapatılan açıklar:** GUV_HSV.md 3. bölüm madde 6'nın örtülü sermaye kısmı (2026/1 2/A-2). Transfer fiyatlandırması OZL konusuna ait olduğundan yalnız KKEG kalemi olarak bırakıldı.
- **Emin olunamayan noktalar:** İhracat hasılatının tahakkuk anı (2024/1 4b, 2026/1 2/A-5) kaynakta bulunamadığı için yazılmadı.
- **Kelime:** 1.771 (sınıra yakın)
- **Kontrolde'ye terfi:** Evet.

### GUV/DAR.md
- **Olgu ve güncellik düzeltmeleri:**
  - 9707 sayılı CBK'nın yalnız yıllara yaygın inşaat oranını (%5 ve %1) değiştirdiği açıkça yazıldı. Eski metin, maddedeki bütün oranlar için bu Karara atıf yapıyor gibiydi.
  - Uygulamadaki oranlar eklendi: serbest meslek ve kira %20, kâr payı %15.
- **Eklenen konular:** ÇVÖA oranının iç mevzuat oranıyla ilişkisi, mukimlik belgesi, sayısal örnek (%10 ile %15 karşılaştırması). Gerçek faydalanıcı ve "conduit company" (2022/1 III).
- **Kapatılan açıklar:** GUV_HSV.md 3. ve 4. bölümdeki ÇVÖA ve gerçek faydalanıcı eksikliği. KEYK hesabı zaten vardı; Tebliğ 7.3 "vergi öncesi kazanç" ifadesi doğrulandı.
- **Emin olunamayan noktalar:**
  - 2009/14593 sayılı BKK oranları (%20) ve 9286 sayılı CBK'nın KVK 30/3'e uygulanması klasörde doğrulanamadı.
  - Mukimlik belgesi ve gerçek faydalanıcı kaynak klasöründe geçmiyor; genel uluslararası vergi bilgisi olarak yazıldı.
- **Kelime:** 1.636
- **Kontrolde'ye terfi:** Hayır, şimdilik. BKK ve CBK oranları ile mukimlik belgesi şartının resmî metinle teyidi gerekiyor.

### GUV/ASG.md
- **Olgu kontrolü:**
  - Hata bulunmadı. Doğrulananlar: 32/C/2 listesi (7582 ile 10/1-i, j ve 7412 md. 6), geçici md. 17 oranları (2026 için %9,4 ve %7,4), örnek hesapları (5.580.000 / 5.665.200 TL), Tebliğ 32.5.4–32.5.6.
  - Eski metindeki "liste ile Örnek 8 arasında gerilim var" ifadesi yeniden yazıldı. Örnek 8 bir istisna kuralı olarak anlatılıyor: yurt dışında en az %10 vergi yükü varsa tamamı düşülür, değilse vergi / 0,10 kadar kısım.
- **Eklenen konular:**
  - Düşülmeyen istisnaların tam listesi: 5/1-c, f, h, 5/B, 10/1-ğ, ı (2024/3 S3).
  - Kurumlar vergisi ile asgari kurumlar vergisinin karşılaştırmalı matrah tablosu (2026/1 2/A-8).
- **Kelime:** 1.458
- **Kontrolde'ye terfi:** Evet.

### FYN/SBT.md
- **Hesap kontrolü:** NBD 11.556,59; %15'te 643,58, %16'da −1.332,71; İVO ≈ %15,33 (kesin %15,32); iskontolu geri ödeme 3,15 yıl. Hepsi Python ile yeniden hesaplandı ve doğru.
- **Eklenen konular (IFM_FYN.md 6. bölüm, SBT eksikleri):**
  - MIRR hesap örneği: gelecek değer 163.330 TL, MIRR %13,05.
  - Yıllık eşdeğer gider ve ikame zinciri: A 60.211,48 TL, B 54.569,62 TL; ortak ömür 15 yıl.
  - Makine yenileme: eski makine satışı ve satış zararının vergi tasarrufu, amortisman farkı vergi kalkanı (kaybedilen eski amortisman), hurda vergisi. NBD 9.086,98 TL.
  - Çok dönemli yatırımda KE paydasının iskonto edilmesi.
  - Sınavdaki %5 veya %10 aralıklı enterpolasyon notu ve karar tablosu notu.
- **Kapatılan açıklar:** 6. bölüm SBT listesinin 4 maddesinin tamamı.
- **Kelime:** 1.249
- **Kontrolde'ye terfi:** Evet.

### FYN/FPA.md
- **Yapı:** Dosya baştan yazıldı. Sınavda hiç sorulmayan DuPont ayrı bölümü, nakit bütçesi ve M&A değerlemesi çıkarıldı (IFM_FYN.md "Fazla" notu). Yerine kazanımlardaki 9 blok kondu.
- **Eklenen konular:**
  - Oran tablosu (6. bölüm FPA madde 1): nakit oranı, stoklara bağımlılık, DV/devamlı sermaye, özkaynak ve NİS devir hızı.
  - Oranlardan bilanço türetme örneği: 6.000.000 TL satıştan bütün kalemler.
  - Başabaş (madde 3): faiz dahil (15.000 adet), hedef net kâr (22.000 adet), çok ürünlü (2.000.000 TL).
  - Satış yüzdesi yöntemi ve DFİ (madde 2): 540.000 TL.
  - Dolaysız nakit akım tablosu (madde 4): 850.000 TL, dolaylı yöntemle kontrol edildi. Fon akım tablosu.
  - Altman Z (madde 5): 3,255.
  - İçsel ve sürdürülebilir büyüme (madde 6): %6,38 ve %13,64, ters çözüm yöntemiyle.
  - Bedelsiz hisse ve geri alım fiyatı (madde 7): 42 TL, 47.619 hisse, HBK 5,25.
  - Artık kârın sınav varyantı (proje getirisi ile ortakların alternatif getirisinin karşılaştırılması ve eşitlikte eldeki kuş kuralı), "Uyumsuzluk" maddesi.
  - Kaldıraç örneği korundu ve yeniden hesaplandı.
- **Kapatılan açıklar:** 6. bölüm FPA madde 1–7, uyumsuzluk notu ve "fazla" notu.
- **Emin olunamayan noktalar:** Altman katsayıları ve eşikleri orijinal (1968, halka açık imalat) modele göre yazıldı. Sınav farklı bir sürüm (Z′, Z″) verirse soru verisi esas alınır.
- **Kelime:** 1.646
- **Kontrolde'ye terfi:** Evet.

### FYN/SMR.md
- **Hesap kontrolü:** AOSM %15,96; optimal yapı tablosu (%15,00 / %14,76 / %16,72); HBK ve kayıtsızlık (750.000 TL, 1,05 TL); Hamada (1,215). Hepsi doğru.
- **Olgu ve terim düzeltmesi:** Formüllerde FVÖK (faiz ve vergi öncesi kâr) kullanıldı. Sınavın "FAVÖK-HBK analizi" adının bu karşılaştırmayı anlattığı açıklandı.
- **Eklenen konular:**
  - AOSM ters çözümü: vergi oranının bulunması, t = %20 (2024/3 S3).
  - Varlık betası ile özkaynak betası arasındaki geçiş; vergisiz MM'de ke = ra + (ra − kd) D/E (2022/1 S4). Örnek %21 ve βE 1,375; CAPM ile çapraz kontrol yapıldı.
  - HBK ve kayıtsızlık denklemi, ters çözüm notu (2024/1 S4).
  - Net kâr, net faaliyet kârı ve geleneksel yaklaşımlar; ödünleşme kuramı; sermaye yapısını etkileyen iç ve dış faktörler (2022/2 S1).
- **Kapatılan açıklar:** IFM_FYN.md 3. bölüm madde 10 (SMR'de FAVÖK-HBK ve kayıtsızlık, teoriler).
- **Kelime:** 1.372
- **Kontrolde'ye terfi:** Evet.

---

# Grup 3 — HSV (6 dosya) ve FYN (ISY, RGT, ZDP) editör denetimi

Tarih: 18.10.2026. Bu dokuz dosya yerinde düzeltildi. `durum: taslak` hiçbir dosyada değişmedi.
Doğrulama (proje kökünde, `--al` kullanılmadı):
- `on_eleme content/anlatim/ymm/HSV --sinav ymm`: 6/6 geçti.
- `on_eleme content/anlatim/ymm/FYN --sinav ymm`: 6/6 geçti.

Yeni alıntıların hepsi pipeline'ın otomatik alıntı denetiminden geçti. Git çalıştırılmadı. Başka dosyaya dokunulmadı.

Kaynak raporlar ve kısaltmalar:
- "GUV_HSV §x": `docs/denetim/ymm_cikmis_2026-10-17/GUV_HSV.md`
- "IFM_FYN §x": `docs/denetim/ymm_cikmis_2026-10-17/IFM_FYN.md`
- Madde numaraları raporlardaki numaralardır (§3 HSV 1–8, §6 HSV/KIS ve HSV/SRV maddeleri, §3 FYN 1–12).

---

### HSV/KIS.md

Dosya yeniden kuruldu. Eski metnin doğru kısımları korundu, eksikler eklendi. Son kelime sayısı: **1.771**.

**Olgu düzeltmeleri**
- Ihracatın beyan dönemi.
  - Eski: "malın fiilen çıktığı dönem".
  - Yeni: gümrük beyannamesinin "kapanma tarihi"nin dahil olduğu dönem.
  - Kaynak: KDVGUT II/A-1.1.1.
- 17/4-r istisnası.
  - Eski tabloda kapsam olarak yalnız "iştirak hisseleri" vardı; taşınmazın neden çıktığı yazmıyordu.
  - Eklenen: 7456 sayılı Kanunla taşınmazlar 15/7/2023'ten itibaren bentten çıkarıldı. Bu tarihten önce aktifte olan taşınmazlara eski hüküm uygulanır (KDVK geç. md. 43).
- Azami iade sınırı.
  - Tebliğ metninde parantez içinde eski "%18" yazılıdır.
  - Metne "atıf genel orana; genel oran 10/7/2023'ten beri %20" notu eklendi (KDVGUT IV/A3-1.1; Oran Kararı md. 1/1-a).
- Tevkifat oranlarında yük taşımacılığı oranı korundu (2/10). Servis taşımacılığı (5/10) eklendi (KDVGUT I/C-2.1.3.2.11).

**Eklenen konular**
- Bavul ticareti ile yolcu beraberi eşya karşılaştırma tablosu (KDVGUT II/A-1.2, II/A-5). Tabloda şunlar var:
  - satıcının belgesi;
  - asgari tutarlar (10.000 TL / 1.000 TL);
  - 3 ay içinde çıkış şartı, 10 gün içinde iade, avans ödeme;
  - 4 nüsha fatura;
  - ÖTV (I) sayılı listedeki mallar ile hizmetlerin kapsam dışı olması.
- Hizmet ihracında "faydalanma" ölçütü için 7 mini vaka tablosu. Vakalar KDVGUT II/A-2.1 örneklerinden alındı: aracılık, Türkiye'de müşteri bulma, yurt dışı tur payı, iş makinesi kiralama, yabancı uçak bakımı, serbest bölge.
- Geri gelen eşyanın üç senaryosu (KDVGUT II/A-1.1.3): iade alınmamış, iade istenmiş ama yapılmamış (103 no.lu satır), iade alınmış.
- Tecil-terkin kuralları ve hesap tablosu (KDVGUT II/A-8.5, 8.6, 8.7). Örnek 2026 rakamlarıyla, %20 oranla kuruldu.
  - Sayılar: ödenmesi gereken 50.000 TL tecil edilir; ihracatta 30.000 TL iade edilir.
  - İşlenen kurallar: malın aynı olması şartı; 15 günde ek süre başvurusu ve en çok 3 ay ek süre; 6183 md. 51 gecikme zammı ve md. 48 tecil faizi; rücu edilen KDV'nin indirimi; ihracatçının genel gider ve ATİK iade sınırı.
- Yüklenilen KDV listesi ve iade hesabı (KDVGUT IV/A3-1.1, 1.2, 1.3; 4/9/2025 eklemeleri).
  - Sıra: doğrudan girdi → genel gider payı → ATİK payı. Azami iade sınırı uygulandı.
  - Kalan ATİK payının sonraki döneme oranlama yapılmadan aktarılamayacağı yazıldı.
  - Örnek: 1.000.000 TL ihracat, 200.000 TL yurt içi satış. Yüklenilen KDV 200.000 TL, devreden 20.000 TL. Elle yeniden hesaplandı.
- 13/1-n basılı yayın istisnasının sınırları (KDVGUT II/B-17). Kapsam dışı: poşetli yayın, e-kitap, CD ile satılan eğitim setleri, yaprak test. Kapsam içi: çizgi roman ve soru bankası.
- 17/2-b bedelsiz teslim: 1/1/2019'dan beri yüklenilen KDV indirilebilir, ama iade edilmez (KDVK md. 30/a parantezi; KDVGUT II/E-2.3, 2.4).
- Önbilgiye 3 yeni alıntı eklendi: II/A-5.5, II/A-8.5, IV/A3-1.2.

**Kapatılan anlatım açıkları (GUV_HSV §6 HSV/KIS ve §3 HSV-8)**
- Yolcu beraberi eşya: kapatıldı.
- Tecil-terkin hesap tablosu: kapatıldı. Bir tablo ve "indirim hesaplananı aşarsa" varyantı var. Sınavda istenen üç tablonun mantığı bu ikisiyle kurulabiliyor.
- İhracat iadesi ve yüklenim listesi: kapatıldı.
- Geri gelen eşya senaryoları: kapatıldı.
- Hizmet ihracında faydalanma mini vakaları: kapatıldı.
- 13/1-n ve 17/2-b: kapatıldı.

**Kapatılamayanlar ve emin olunamayanlar**
- 2023/3'te sorulan "üç özel fatura"nın hangi üç belge olduğu kaynakta adıyla geçmiyor. İki tür (bavul ticareti özel faturası ve yolcu beraberi faturası) karşılaştırıldı; üçüncüsü uydurulmadı.
- 2022/2 1b'deki promosyon (13/1-n, oran farkı formülü) ayrıca işlenmedi; kelime sınırı yetmedi.

**Kontrolde'ye terfi:** Evet.
- Bütün zorunlu açıklar kapandı.
- Rakamlar KDVK ve KDVGUT'tan Grep ile doğrulandı.
- Hesaplar elle kontrol edildi.

---

### HSV/SRV.md

Dosya yeniden kuruldu. Son kelime sayısı: **1.665**.

**Olgu kontrolleri**
- Aşağıdaki tutarlar kaynak metinlerin dipnotlarında doğrulandı:

| Kalem | 2026 tutarı | Dayanak |
|---|---|---|
| VİV füruğ ve eş istisnası | 2.907.136 TL | 57 Seri No.lu VİV Genel Tebliği |
| VİV eş istisnası (füruğ yoksa) | 5.817.845 TL | 57 Seri No.lu VİV Genel Tebliği |
| VİV ivazsız intikal ve ikramiye istisnası | 66.935 TL | 57 Seri No.lu VİV Genel Tebliği |
| VİV dilimleri | 3.000.000 / 7.000.000 / 15.000.000 / 30.000.000 / 55.000.000 TL | 57 Seri No.lu VİV Genel Tebliği |
| DKV sınırı | 17.711.000 TL | EVK Genel Tebliği Seri No: 88 |
| DKV dilim sınırları | 26.567.000 / 35.425.000 TL | EVK Genel Tebliği Seri No: 88 |
| DKV sabit vergi tutarları | 26.568 / 79.716 TL | EVK Genel Tebliği Seri No: 88 |
| MTV yeniden değerleme oranı | %18,95 | 10783 sayılı CBK |

- GUV_HSV §6'daki "doğrulanamadı" notu böylece kapandı.
- Yeni olgu: 7582 sayılı Kanunla (21/5/2026) VİVK md. 16'ya eklenen fıkra metne girdi. GVK mük. md. 20/D istisnasından yararlananlara, istisna süresi içinde veraset yoluyla intikalde oran %1'dir.
- Eski metindeki ifade düzeltildi: "Kamu idareleri ve kamu yararına çalışan dernekler muaftır (md. 3)". Muafiyet ayrıntısı çıkarıldı, yerine md. 4/g eklendi.

**Eklenen konular**
- VİV:
  - tarh yeri (md. 6) ve değerleme günü (md. 11);
  - md. 9'daki 8 beyan süresinin tamamı (yurt dışında ölüm ve gaiplik dahil);
  - değerleme ölçüleri (md. 10);
  - md. 12'deki borç ve masraf indirimlerinin dört bendi;
  - md. 13 ihtilaflı borçlar (10 yıl tecil, 6 ayda bir bildirim);
  - md. 17 teminat ve tevkifat (%5 / %15, bir hafta içinde yatırma, %10 ceza);
  - md. 21 gaip mirasçı ve gaip murisin zuhuru;
  - md. 19 tescil ve devir-ferağ kuralı;
  - md. 4/g emekli ikramiyesi istisnası.
- Borç ve cenaze masrafı düşülen mirasçı payları örneği. Tereke 10.000.000 TL, net 9.000.000 TL. Eşin payında vergi çıkmıyor; her çocuk için 4.678,64 TL. Elle hesaplandı.
- Emlak vergisi:
  - mükellefiyetin başlaması (md. 9, md. 33);
  - yıkılan binada mükellefiyetin olayı izleyen taksitten itibaren bitmesi (2024/3 1a);
  - bildirim zorunluluğu (md. 23).
- DKV: tarife tablosu ve muafiyetler (md. 46). Müteahhit konutu muafiyeti (46/ç) eklendi (2024/2 1b).
- MTV:
  - mirasçıya intikal dahil devir ve temlikte mükellefiyetin geçişi (md. 7/b);
  - sona erme (md. 8);
  - tahakkuk ve tebliğ (md. 9);
  - devir sırasında ödeme kuralı;
  - (II) sayılı tarifenin gider yasağı dışında kalması.

**Kapatılan anlatım açıkları (GUV_HSV §6 HSV/SRV ve §3 HSV-5)**
- Gaibin zuhuru: kapatıldı.
- İhtilaflı borçlar: kapatıldı.
- md. 17 teminat ve tevkifat: kapatıldı.
- md. 12'nin ayrıntısı: kapatıldı.
- Beyan sürelerinin tamamı: kapatıldı.
- MTV'de ölüm hali: kapatıldı. Kanunda ayrı hüküm yok; md. 7/b'deki devir ve temlik kuralıyla açıklandı.
- Doğrulama notu: kapatıldı.

**Kapatılamayanlar**
- Sirküler ve iç genelge vakaları eklenemedi: banka promosyonu, kooperatif hissesi, kat karşılığı inşaat halindeki bina, yurt dışındaki mal, mevduat faizi, sigorta tazminatı ve BES ödemeleri (3 sayılı VİV Sirküleri).
  - Neden: Bu sirküler ve özelgeler `content/kaynaklar/mevzuat` klasöründe yok. Ayrıntı uydurulmadı.
  - Metinde yalnız md. 17'nin sigorta şirketlerini de kapsadığı yazıldı.
- 2026 MTV tarife tutarları verilmedi. Seri 58 Genel Tebliğ metni kaynakta yok.

**Kontrolde'ye terfi:** Hayır.
- Sınavda üst üste sorulan sirküler vakaları (2025/2 S2, 2026/1 S4 a-e, 20 puan) anlatılmıyor.
- Önce 3 sayılı VİV Sirküleri ile ilgili özelge ve iç genelgeler kaynak klasörüne eklenmeli ve bu bölüm yazılmalı.
- Geri kalan içerik doğrulandı.

---

### HSV/OTV.md

Dosya yeniden kuruldu. Son kelime sayısı: **1.498**.

**Olgu düzeltmeleri ve güncellemeler (2026)**
- Engelli istisnası (ÖTVK md. 7/2):
  - Eski: istisna ayrıntısı yoktu.
  - Yeni: istisna **on yılda bir** kullanılabilir (7537 sayılı Kanunla "beş" ibaresi "on" oldu). Kanunda yerli katkı şartı en az %20'dir; 9321 sayılı CBK ile %40'tır.
  - 7577 sayılı Kanunla (2/4/2026) yeniden düzenlenen (c) alt bendinde bedel sınırı 2.873.900 TL'dir.
  - 15/2-a'daki **5 yıl** kuralı aynen kaldı. Sınavda bu iki süre (10 yıl ve 5 yıl) karıştırılabilir; metne ayrı ayrı yazıldı.
- 87.03 taşıtlarda asgari maktu vergi: 7590 sayılı Kanunla (24/7/2026) md. 12/1'e eklendi. (L) sınıfı için 30.000 TL, diğerleri için 100.000 TL.
- (III-B) cetveli formülü: md. 11/5'e göre maktu vergi + asgari maktudan az olmamak üzere nispi vergi. Önbilgiye alıntı eklendi.

**Eklenen konular**
- ÖTV beyan dönemleri ve süreleri tablosu (md. 14).
- Müteselsil sorumluluk (md. 13/3).
- md. 13/2: (I) sayılı listedeki mal daha yüksek vergili bir mal olarak kullanılırsa VUK md. 344 cezası uygulanır. Kayıt dışı akaryakıt satışında VUK md. 359 atfı (2023/2 3b-c).
- Belgesiz mal (md. 4/3).
- Bayilikte muvazaa ve ilk iktisap tuzağı (2022/3 3a).
- md. 15/2-b vasıf değişikliği. Hesap örneği varsayımsal oranlarla kuruldu: ödenen 100.000 TL mahsup edilir, fark ÖTV 500.000 TL (2025/1 S1).
- Haczedilen araçların müzayedesi (2024/2 S4).
- (I) sayılı listenin (B) cetvelindeki malların imalatta kullanılmasında iade: 2012/3792 sayılı BKK ve ÖTV (I) UGT. Sanayi sicil belgesi şartı, 12 ay süresi, madeni yağ istisnası ve örnek hesap.
- Sigara ÖTV hesap örneği (varsayımsal oranlarla).
- (IV) sayılı listede kolonyanın hariç olduğu GTİP notu (2023/3 3a-c).

**Kapatılan açıklar (GUV_HSV §3 HSV-7, 1B'deki OTV soruları)**
- (II) sayılı listede ilk iktisap, müzayede, vasıf değişikliği, engelli istisnası ve 5 yıl kuralı: kapatıldı.
- (I-B) cetveli iadesi: kapatıldı.
- (III) sigara hesabı: kapatıldı.
- Kazanım "(II) sayılı listede ilk iktisap ve istisnalar": ayrı bölüm olarak işlendi.
- Kazanım "(I) sayılı listede iade": ayrı bölüm olarak işlendi.

**Emin olunamayanlar ve kapatılamayanlar**
- 2026 sigara oranları ve maktu tutarlar verilmedi. ÖTVK ekli (III) sayılı listenin metni pdftotext çıktısında bozuk; sütunlar okunamıyor. Örnek varsayımla kuruldu.
- md. 7/2-a'daki "200.000 TL"nin 2026 güncel değeri kaynakta yok; yazılmadı.
- 2022/1 ve 2024/1'de sorulan "6 ay" süresinin (LPG ve aerosol, 2014/6881 BKK) ayrıntısı eklenmedi.
- 15/2-b dönüşümünde KDV boyutu (2025/1) kaynakta net bulunamadı; yazılmadı.

**Kontrolde'ye terfi:** Evet.
- Kazanımlar tam.
- Varsayımlı oranlar açıkça "varsayım" diye işaretli.

---

### HSV/KDV.md

Dosya yeniden kuruldu. Son kelime sayısı: **1.343**. Tablolar ağırlıklı olduğu için sayı düşük.

**Olgu düzeltmesi**
- Eski: "Örnek için varsayım %20".
- Yeni: 2007/13033 sayılı Karara göre 10/7/2023'ten beri gerçek oranlar %20, %10 ve %1. Bu yazıldı ve önbilgiye alıntı eklendi.
- Kur farkında ve matrah düzeltmesinde ilk işlem tarihindeki oranın esas alınacağı eklendi (KDVGUT III/B-1.2).

**Eklenen konular**
- Kap ve ambalaj (md. 2/4).
- Yurt dışı turlar (KDVGUT I/B-9).
- Müzayede satışları: mükellef, vergiyi doğuran olay, kesin satış bedeli, izale-i şüyuda hissenin düşülmesi, icra dairesinin ödeme süresi (md. 1/3-d, 8, 23/d; KDVGUT I/B-6).
- Kur farkının 4 durumu ve sayısal örnek (KDVGUT III/A-5.3). Matraha giren kur farkı 20.000 TL, KDV 4.000 TL.
- Arsa karşılığı inşaatta iki teslim ve VUK md. 267/2 maliyet bedeli esası (md. 27/6; KDVGUT I/B-8).
- Özel matrah tablosu: md. 23/d, 23/e (altın), 23/f (ikinci el araç ve taşınmaz).
- İkinci el araç özel matrah örneği (2026): özel matrah 200.000 TL, KDV 40.000 TL.

**Kapatılan açıklar (GUV_HSV §3 HSV-8, 1B'deki KDV soruları)**
- Kur farkı: kapatıldı (2023/2, 2026/1).
- İkinci el araç: kapatıldı (2024/3, 2026/1).
- Müzayede: kapatıldı (2025/1).
- Yurt dışı turlar: kapatıldı.
- Arsa karşılığı inşaat: kapatıldı (2023/1).
- Altın ziynet matrahı: kapatıldı (2022/3).
- Kap ve ambalaj: kapatıldı (2022/3).

**Kapatılamayanlar:** Yok.

**Kontrolde'ye terfi:** Evet.

---

### HSV/DMG.md

Yerinde düzeltme yapıldı. Son kelime sayısı: **1.772**.

**Olgu kontrolleri**
- 71 Seri No.lu Tebliğle gelen 2026 tutarları DVK metninde tek tek doğrulandı:
  - binde 9,48; 1,89; 5,69; 7,59;
  - 616,30 TL, 294,20 TL, 1.605,80 TL ve 791,00 TL.
- Örnek hesap (27.037,90 TL) yeniden hesaplandı; doğru.

**Eklenen konular**
- Azami tutar (md. 14): son doğrulanabilen tutar 2023 için 10.732.371,80 TL'dir. Değiştirilen sözleşmede yalnız artan kısım vergilenir.
- Yabancı para (md. 12).
- İstihkaktan kesinti (md. 19), basılı damga (md. 17), beyan ve ödeme süreleri (md. 22).
- Sorumluluk (md. 24, md. 25), 2023/3 4b'de sorulan.
- 2026'da eklenen istisnalar:
  - TOKİ ihaleleri (geçici md. 5, 7579 sayılı Kanun);
  - nükleer enerji santrali yatırımları ((2) sayılı tablo IV-56, 7590 sayılı Kanun).
- Harç tarifelerinin içerikleri. 98 Seri No.lu Tebliğle 2026 meslek ruhsat harçları:
  - YMM ruhsatı 62.919,90 TL;
  - bağımsız denetçi yetkilendirme belgesi 31.454,30 TL;
  - SMMM ruhsatı 15.724,70 TL (2024/3 2c).
- Gereksiz bir "istisnai durum" paragrafı çıkarıldı. Tasdik notu kısaltıldı; kelime sınırı için.

**Kapatılan açıklar (GUV_HSV §3 HSV-6)**
- Damga vergisinde sorumluluk: kapatıldı.
- Ruhsat harcı: kapatıldı.
- Yurt dışında düzenlenen kağıt: zaten vardı.

**Emin olunamayanlar**
- 2026 azami damga vergisi tutarı kaynakta yok (yalnız 2023 tutarı var). 2026 tutarı yazılmadı.
- Dövizli ve KDV dahil sözleşmede matrah (30 ve 35 Seri DV Genel Tebliği, 2022/1 4a-b) işlenmedi. Bu tebliğler kaynakta yok.
- Geçici teminat iadesinin damgası (2022/2 4a) işlenmedi; kaynak doğrulaması yapılamadı.

**Kontrolde'ye terfi:** Evet.
- Kazanımlar tam.
- Tutarlar 2026'ya göre doğrulandı.
- Eksik kalan iki ayrıntı ağırlığı düşük konular.

---

### HSV/USL.md

Yerinde düzeltme yapıldı. Son kelime sayısı: **1.792**.

**Olgu kontrolleri**
- Teminat katları tablosu KDVGUT IV/A2-6 ve IV/A2-7 ile birebir doğrulandı:
  - düzenleme raporu 5 / 4 kat;
  - kullanma raporu 4 / 3 kat;
  - düzenleme tespiti 4 / 3 kat;
  - kullanma tespiti 3 / 2 kat.
- Tam tasdikte %5 kuralı doğrulandı.

**Eklenen konular**
- Genel esaslara dönüş süreleri (5/4, 4/3, 4/3, 3/2 yıl) ve dönüş halleri (2022/1 S2).
- VUK md. 153/A teminatı. 2026 tutarları 1.200.000 TL ve 17.000.000 TL (588 Sıra No.lu VUK Genel Tebliği; vuk.txt dipnotu ile doğrulandı).
- VUK md. 344: bir kat ceza; md. 359 fiillerinde üç kat (2023/2 3b-c).
- Tecil edilen vergide 6183 md. 51 gecikme zammı ve md. 48 tecil faizi (2025/3 2d).

**Emin olunamayan**
- Metne şu cümle eklendi: "uygulamada KDV beyan ve ödeme günü izleyen ayın 28'idir".
- Bu bilgi meslek pratiğinden bilinir, ama dayanak düzenleme `kaynaklar/mevzuat` içinde bulunamadı. Kanun süreleri (24/26 ve 21/23) korunarak iki bilgi birlikte verildi.
- **Hakem bu cümleyi teyit etmeli; teyit edilemezse cümle silinmeli.**

**Kapatılan açıklar (GUV_HSV §1B USL soruları, §4)**
- 2022/1 S2: kapatıldı.
- 2022/2 S2'nin rapor türleri kısmı: kapatıldı.
- 2023/2 ceza kısmı: kapatıldı.

**Kontrolde'ye terfi:** Evet, koşullu. Yukarıdaki "28" cümlesi hakem tarafından teyit edilmeli.

---

### FYN/ISY.md

Dosya yeniden kuruldu. Son kelime sayısı: **1.354**. Formül ağırlıklı olduğu için sayı düşük.

**Doğruluk kontrolü**
- Eski örneklerin hepsi elle yeniden hesaplandı; hata yok:
  - NDS 80 gün (360 gün esasıyla 78,9);
  - EOQ 2.000 adet, toplam maliyet 32.000 TL;
  - iskonto maliyeti %37,24 (bileşik %44,59);
  - peşin faizli kredinin efektif faizi %66,67.

**Eklenen konular (IFM_FYN §3 FYN-11 ve §1B soruları)**
- İşletme sermayesi gereksinimi (günlük nakit gider × NDS) ve ters çözüm (2024/3 S2).
- Baumol örneği (C* = 300.000 TL) ve T değişince ters çözüm (2024/2 S4).
- Miller-Orr formülleri ve örneği: Z = 130.000 TL, H = 190.000 TL, ortalama nakit 140.000 TL.
- Miller-Orr'da fırsat maliyetinin geri hesaplanması (2023/2 S1).
- Sipariş noktası ve tarihe göre stok seviyesi (2022/3 S5).
- Miktar indirimi kararı (2023/1 S4b).
- Kredi politikası alternatifinin vergi sonrası kâra etkisi (2026/1 S3): vergi öncesi ek kâr 550.000 TL, vergi sonrası 412.500 TL.
- Bütün sayılar elle (python ile) doğrulandı.

**Kapatılan açıklar**
- FYN-11'in tamamı: Miller-Orr, Baumol ters çözüm, sipariş noktası, miktar indirimi, BİSG, nakit iskontosu.

**Kapatılamayanlar:** Yok.

**Kontrolde'ye terfi:** Evet.

---

### FYN/RGT.md

Yerinde düzeltme yapıldı. Son kelime sayısı: **1.503**.

**Doğruluk kontrolü**
- Bütün örnek hesaplar elle doğrulandı; hata yok:
  - E(RA) %13,75, σA %15,96;
  - Kov(A,B) −135;
  - σp %3,76;
  - β 1,5 ve sistematik risk payı %51,84.

**Eklenen konular**
- Minimum varyanslı portföy ağırlığı: wA ≈ 0,347.
- Geçmiş getirilerden kovaryans ve varyansla beta hesabı ve yorumu (2024/2 S3): β ≈ 1,67, α = −2.
- Tasdik notu kısaltıldı; örtülü kazanç atfı eklendi.

**Kapatılan açıklar**
- 2024/2 S3 (beta ve yorum): kapatıldı.
- 2023/2 S2 (beklenen getiri, standart sapma, DK ile seçim): zaten vardı.

**Kapatılamayanlar:** Yok.

**Kontrolde'ye terfi:** Evet.

---

### FYN/ZDP.md

Dosya yeniden kuruldu. Son kelime sayısı: **1.295**. Formül ağırlıklı olduğu için sayı düşük.

**Doğruluk kontrolü**
- Eski örnekler elle doğrulandı; hata yok:
  - anüite BD 72.095,52 TL, GD 127.056,95 TL;
  - tahvil fiyatı 951,96 TL (%8 getiride 1.051,54 TL);
  - Gordon modelinde değer 21 TL.

**Eklenen konular (IFM_FYN §3 FYN-8 ve §1B soruları)**
- Efektif faiz ve yıllıklandırma: %48 nominal, aylık bileşikte efektif %60,10 (2025/3 S2).
- Fisher eşitliği ve ters çözüm (2024/1 S3): reel faiz %7,14; ters çözümde enflasyon %40.
- Eşit taksitli kredi formülü (2023/1 S1).
- Ertelenmiş anüite örneği (2022/3 S4): taksit 54.888,82 TL.
- Büyüyen anüite örneği (2025/3 S3): BD 743.981,21 TL.
- Durasyon (2022/1 S3, 2023/3 S4):
  - Macaulay 2,7287 yıl, düzeltilmiş 2,4363;
  - tahmini fiyat değişimi −23,19 TL, gerçek değişim −22,80 TL;
  - aradaki fark konveksiteyle açıklandı.
- Dış ve iç iskonto (2023/1 S5, 2025/1 S5):
  - 90.000 / 90.909,09 TL;
  - senet değişimiyle yeni nominal 129.272,24 TL.
- Hazine bonosu fiyatı (2022/3 S3): 84,78 TL.
- Tek dönem getirisinden satış fiyatı (2024/1 S3): 56 TL.
- Değişken büyüme modeli.
- F/K, PD/DD ve FD/FAVÖK ile göreli değerleme (2023/3 S5, 2025/3 S4).
- Bütün yeni sayılar python ile yeniden hesaplandı. Yuvarlama kuruşa; ara değerler yuvarlanmadan kullanıldı ve bu metinde belirtildi.

**Kapatılan açıklar:** FYN-8'in tamamı.

**Emin olunamayan**
- 2025/3 S4'teki "F/NA" çarpanının tam karşılığı raporda açık değil. "Net aktif değer" çarpanı olduğu varsayımıyla ayrıca yazılmadı. Yerine yaygın FD/FAVÖK çarpanı verildi.

**Kontrolde'ye terfi:** Evet.

---

## Genel notlar

**Yıl tutarları**
- Kullanılan bütün 2026 tutarları kaynak metinlerin dipnotlarında doğrulandı: VİV 57 Seri, EVK 88 Seri, DVK 71 Seri, Harçlar 98 Seri, VUK 588, MTV için 10783 sayılı CBK.
- Doğrulanamayan tutarlar yazılmadı:
  - 2026 damga vergisi azami tutarı;
  - 2026 MTV tarife tutarları;
  - 2026 sigara ÖTV tutarları;
  - ÖTVK md. 7/2-a'daki bedel sınırının 2026 değeri.

**Kaynak klasörüne eklenmesi önerilenler**
- 3 sayılı VİV Sirküleri ve VİV iç genelgeleri ile özelgeleri.
- Damga Vergisi Genel Tebliği Seri No 30 ve 35.
- Beyanname sürelerini 28'ine uzatan düzenleme.
- ÖTV (III) sayılı listenin okunabilir sürümü.
