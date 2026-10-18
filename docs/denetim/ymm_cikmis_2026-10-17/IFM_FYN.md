# YMM Çıkmış Soru Analizi — IFM (01) ve FYN (02), 2022/1–2026/1 (13 dönem)

Kaynak: `content/kaynaklar/cikmis/ymm/ymm_<YIL>_<DONEM>_0{1,2}.txt` (26 dosya, hepsi okundu). Karşılaştırma: `content/mufredat/ymm.yaml`, `content/anlatim/ymm/{IFM,FYN}/*.md`.

## 0. Veri hakkında önemli uyarılar

- Dosyaların çoğu **yalnız "Sınav Komisyonu Cevapları"**dır. Soru metni ya cevabın içinde tekrarlanmış (2022/2-02, 2023/1-01, 2023/2-01, 2024/1-01, 2024/2-01, 2024/3-01, 2025/1-01) ya da **hiç yoktur**. Soru metni olmayanlarda konu cevaptan çıkarılmıştır: 2022/1-01 S2, 2022/3-01 S2-S3 (kısmen), 2025/2-01 S1-S4, 2025/3-01 tümü, 2026/1-01 tümü, FYN'de 2022/1, 2022/3, 2023/1, 2023/2, 2023/3, 2024/2, 2024/3, 2025/1-3, 2026/1 (soru verileri büyük ölçüde cevaptan anlaşılıyor).
- **Puan görünmeyenler:** IFM 2022/1 S2, 2022/3 S1-S2 (S2'de dağınık "8 puan" ibareleri var, toplam belirsiz), 2025/2 S1-S2, 2025/3 tümü, 2026/1 S2 (yalnız 2.(5) = 5 puan). FYN 2022/3, 2023/1, 2023/2 tamamen puansız; 2023/3, 2024/1, 2024/2, 2024/3, 2026/1'de yalnız mikro puanlar var, soru toplamlarını bunları toplayarak buldum (≈ ile gösterildi).
- pdftotext düzeni bozuk tablolar: 2026/1-01 C1 (13-15. maddelerin açıklamaları kaymış), 2025/2-02 C3 bilanço, 2022/3-02 C7c ve C8 tabloları. Bunlarda tutarlar okunabiliyor, sütun eşleşmesi kesin değil.
- Cevap anahtarında iç tutarsızlıklar var. Pratik soru yazarken bunları örnek alma: 2024/3-01'de ertelenmiş vergi geliri için 685 kullanılmış, başka yıllarda 696. 2024/1-01 S7'de "648 Parasal kayıplar" yazıyor, ek listede 648 kazanç / 658 kayıp. 2023/3-01'de NPP için 669/679 kullanılmış. 2023/2-02 C1'de "0,02 (%20)" yazıyor, doğrusu %2. 2023/3-01 S3 (30 puan) cevabında yalnız iki kayıt var; cevap eksik görünüyor.

---

## 1. Soru bazında döküm

Kısaltmalar: KÇ = Finansal Raporlamaya İlişkin Kavramsal Çerçeve; EV = ertelenmiş vergi; "Konu" = en iyi eşleşen yaml konu kodu / kazanım; YOK = yaml'da karşılığı yok.

### 1A. IFM — İleri Düzeyde Finansal Muhasebe

| Dönem | Soru | Konu özeti | Dayanak | Puan | Konu (yaml) |
|---|---|---|---|---|---|
| 2022/1 | 1 a-e | Cari değer, kullanım/ifa değeri, toplulaştırma, finansal/fiziki sermaye, netleştirme | KÇ | 25 (5×5) | YOK |
| 2022/1 | 2 | 10 kalemli VUK→TFRS dönüşüm: kasa kur farkı, çek→alacak senedi sınıflaması, vadeli mevduat, alıcı/satıcı reeskontu (devir hızı→gün), şüpheli alacak, Ar-Ge giderleştirme, stok değer düşüklüğü, iştirak GUD farkı (DKG 564-01/09), arsa→YAG; her kalemde EV; TFRS kârı ve gelir tablosu | TFRS 9, TMS 12, TMS 2, TMS 38, TMS 40, TMS 21 | görünmüyor | VRG+FAR (karma), dönüşüm iş akışı YOK |
| 2022/2 | 1 a-b | Maden araştırma ve değerlendirme varlıklarının ölçümü ve sunumu | TFRS 6 | 30 (20+10) | YOK |
| 2022/2 | 2 a-b | Ar-Ge projesi: tamamlanma %40'a göre hasılat düzeltmesi (163 sözleşme varlığı); avans alınan projede maliyetin 156'ya alınması; EV | TFRS 15, TMS 12 | 30 (15+15) | KIR / TFRS 15 |
| 2022/2 | 3 a-c | TFRS düzeltme mizanından EV: bilanço kalemi (564-09), gelir tablosu kalemleri (9 kayıt), 289/489 mahsubu | TMS 12, TMS 16 (yeniden değerleme) | 40 (10+20+10) | VRG / TMS 12 |
| 2022/3 | 1 a-e | Destekleyici niteliksel özellikler, ekonomik fayda potansiyeli, sözleşmeye dayalı hakların özü, sunum ve açıklama, ekonomik kaynaklar ve talep hakları | KÇ | görünmüyor | YOK |
| 2022/3 | 2 | Konsolidasyon eliminasyonları: sermaye/bağlı ortaklık, grup içi alacak-borç, grup içi satış-maliyet | TFRS 10 | belirsiz ("8 puan" ibareleri) | KON / grup içi eliminasyon |
| 2022/3 | 3 | Haklar (MODV): TFRS faydalı ömür ve kalıntı değerle amortisman, VUK fazlasının iptali (geçmiş yıl kârı ayrımı), EV | TMS 38, TMS 12 | 30 (20+10) | YOK (TMS 38) + VRG |
| 2023/1 | 1 a-d | İlk ölçüme özgü faktörler, temel niteliksel özelliklerin uygulanması, destekleyici özellikler ve maliyet kısıtı, ekonomik fayda potansiyeli | KÇ | 20 (4×5) | YOK |
| 2023/1 | 2.1 | Alıcı/satıcı itfa edilmiş maliyeti (iç iskonto, devir hızı→gün), 122/322, EV (%23) | TFRS 9, TMS 12 | 20 | FAR / etkin faiz |
| 2023/1 | 2.2 | Bina yeniden değerlemesinin TFRS'ye uyarlanması, arsa payının ayrılması, amortisman düzeltmesi, EV | TMS 16, TMS 12 | 25 | YOK (TMS 16) |
| 2023/1 | 2.3 | Üretimden çekilen makinenin satış amaçlı sınıflanması (194/195/199), değer düşüklüğü, EV | TFRS 5 | 20 | YOK |
| 2023/1 | 2.4 | Banka kredisinin iskonto edilmiş değerle gösterilmesi (KV/UV), EV | TFRS 9 | 15 | FAR / etkin faiz |
| 2023/2 | 1 a-d | Mevcudiyet belirsizliği, ölçüm belirsizliği, benimsenen bakış açısı, hesap birimi | KÇ | 20 | YOK |
| 2023/2 | 2 | Yıllara yaygın inşaat (170/350): tamamlanma %30'a göre hasılat ve maliyet düzeltmesi, 352 sözleşme yükümlülüğü, EV | TFRS 15, TMS 12 | 30 | KIR / TFRS 15 |
| 2023/2 | 3 | Binanın YAG'a sınıflanması, GUD değerlemesi (cari dönem 649 / geçmiş 570), amortisman iptali, EV | TMS 40, TMS 12 | 30 | YOK |
| 2023/2 | 4 | Yarı mamulde NGD, 158 karşılığı, EV | TMS 2 | 20 | YOK |
| 2023/3 | 1 a-d | Faaliyet bölümü birleştirme kriterleri; edim yükümlülüğünün belirlenmesi; düzeltme gerektirmeyen olaylar; tahakkuk esaslı muhasebenin yansıttığı performans | TFRS 8, TFRS 15, TMS 10, KÇ | 20 (4×5) | KIR 5 / YOK 15 |
| 2023/3 | 2 | Bilançonun endekslerle düzeltilmesi: sermaye, stok (devir hızı), makine ve amortisman, avans, yedek, MDV yeniden değerleme artışı iptali, NPP, düzeltilmiş bilanço | TMS 29 | 50 | ENF / TMS 29 |
| 2023/3 | 3 | Grup içi yazılım lisans satışında konsolidasyon eliminasyonu (alacak-borç, satış-maliyet, haklarda gerçekleşmemiş kâr) | TFRS 10 | 30 | KON / grup içi |
| 2024/1 | 1 a-d | Durdurulan faaliyet, kapsamlı gelir tablosu, YAG, geçici farklar | TFRS 5, TMS 1, TMS 40, TMS 12 | 20 (4×5) | VRG 5 / YOK 15 |
| 2024/1 | 2 | Demirbaş: TFRS ömrü ve kalıntı değerle kıst amortisman, fazlanın fonksiyonel dağılımı (622/632), EV | TMS 16, TMS 12 | 15 | YOK + VRG |
| 2024/1 | 3 | Hareketsiz stok değer düşüklüğü, EV | TMS 2 | 10 | YOK |
| 2024/1 | 4 | Satıcı reeskontu (iç iskonto formülü), EV | TFRS 9 | 10 | FAR |
| 2024/1 | 5 | Kullanılmayan izin karşılığı (374), EV | TMS 19 (kısa vadeli) | 10 | VRG (TMS 19, kıdem değil) |
| 2024/1 | 6 | Arsanın YAG olarak GUD ile değerlenmesi, EV | TMS 40 | 10 | YOK |
| 2024/1 | 7 | Sermayenin katsayılarla düzeltilmesi; ikinci kısım: "geçici fark yok, EV yok" | TMS 29 | 15 (10+5) | ENF / TMS 29 |
| 2024/1 | 8 | Aktifleştirilmiş kuruluş giderinin giderleştirilmesi, EV | TMS 38 | 10 | YOK |
| 2024/2 | 1 | GUD hiyerarşisi Seviye 1-2-3; bağlantılı bilgi; metrik ve hedefler | TFRS 13, TSRS 1 | 15 (9+6) | YOK |
| 2024/2 | 2 | IPARD devlet teşviki 2020-22: gelir yaklaşımı (480) ve sermaye yaklaşımı (549/564-09) kayıtları, EV | TMS 20, TMS 12 | 25 (15+10) | YOK |
| 2024/2 | 3 a-c | Doğrudan yöntemle nakit akış tablosu (esas, yatırım, finansman) | TMS 7 | 35 (15+10+10) | YOK |
| 2024/2 | 4 a-b | Taksitli kredinin itfa edilmiş maliyeti, 2022 ve 2023 faiz farkı ve KV sınıflaması, EV | TFRS 9 | 25 (15+10) | FAR / etkin faiz |
| 2024/3 | 1 a-d | Müşterek kontrol, sözleşme varlığı, kontrol gücü olmayan paylar, ilişkili taraf işlemi | TFRS 11, TFRS 15, TFRS 10, TMS 24 | 20 (4×5) | KON 10 / KIR 5 / YOK 5 |
| 2024/3 | 2 | 3 yıllık inşaat 1. yıl kayıtları (740/741/622, 350/125/600), EV (%20) | TFRS 15 | 30 | KIR / TFRS 15 |
| 2024/3 | 3 | Makinelerin yeniden değerlemesi, brüt ve net yöntem (522), amortisman, VUK-TFRS ömür farkından EV ("İstenen" metni dosyada yok) | TMS 16, TMS 12 | 25 (10+5+10) | YOK + VRG |
| 2024/3 | 4 | İthal malın maliyeti (vade farkı ayrılır, depolar arası nakliye gider) | TMS 2 | 25 | YOK |
| 2025/1 | 1 | Sürdürülebilirlikle ilgili finansal açıklamalar | TSRS 1 | 20 | YOK |
| 2025/1 | 2 | Sermayenin korunması ve kârın belirlenmesi | KÇ bölüm 8 | 20 | YOK |
| 2025/1 | 3 a-d | Süt çiftliği vakası: canlı varlıklar (biyolojik dönüşüm/fiyat farkı), süt tozu stoku, devlet teşviki (alacak hale gelme), satış amaçlı sınıflama | TMS 41, TMS 2, TMS 20, TFRS 5 | 60 (20+20+10+10) | YOK |
| 2025/2 | 1 | 10 maddelik boşluk doldurma (BKZ, Seviye 3, aktüeryal, EV, kalıntı değer, özkaynak yöntemi, ertelenmiş gelir, düzeltme gerektiren olaylar, diğer faaliyet geliri, aktifleştirme). Soru metni yok | TFRS 9/13, TMS 19/12/16/28/20/10/1/23 | görünmüyor | karma |
| 2025/2 | 2 | 10 maddelik doğru/yanlış ve gerekçe (maliyet modeli, GUD tanımı, YAG GUD, NGD, geri kazanılabilir tutar, araştırma gideri, yeniden değerleme) | TMS 16/40/2/36/38, TFRS 13 | görünmüyor | YOK |
| 2025/2 | 3 A-B | Peşin tahsilatlı proje: sözleşme yükümlülüğü, makine, finansman faizi; 20x1 kayıtları ve 4 tabloya etkisi (bilanço, kapsamlı gelir, özkaynak değişim, nakit akış) | TFRS 15, TMS 16, TMS 23, TMS 1, TMS 7 | 20 (10+10) | KIR + YOK |
| 2025/2 | 4 | Ticari kârdan mali kâra geçiş, geçici ve kalıcı fark ayrımı, cari ve ertelenmiş vergi, toplam vergi gideri kaydı, tablolara yansıma (dolaylı nakit akış dahil) | TMS 12, TMS 1, TMS 7 | 40 (10+10+20) | VRG / TMS 12 |
| 2025/3 | 1 | 10 maddelik boşluk doldurma (GUD, temel özellikler, önemlilik, toplulaştırma, varlık, defter değeri, konsolide tablo, finansal tablo dışı bırakma, destekleyici özellikler) | KÇ, TFRS 13 | görünmüyor | YOK |
| 2025/3 | 2 | 10 maddelik doğru/yanlış | KÇ | görünmüyor | YOK |
| 2025/3 | 3.1-3.10 | TFRS'ye ilk geçiş vakası: tahmini maliyet, YAG, iştirakte özkaynak yöntemi, durdurulan faaliyet, HBK (seyreltilmiş), LIFO→FIFO, TFRS 15 bakım sözleşmesi, değer düşüklüğü, üç bilanço, politika seçimi | TFRS 1, TMS 16/40/28, TFRS 5, TMS 33/2, TFRS 15, TMS 36, TMS 1 | görünmüyor | çoğu YOK (KON: TMS 28 maddesi) |
| 2026/1 | 1 | 15 maddelik boşluk doldurma (pazarlıklı satın alma kazancı, GUD-DKG, kapanış kuru, TFRS 16 faydalı ömür, EV yükümlülüğü, edim, parasal kazanç/kayıp, özkaynak işlemi, restorasyon karşılığı, TFRS 5 ölçümü, MODV koşulu, itfa edilmiş maliyet, değer düşüklüğü, iş ortaklığı, TMS 23 aktifleştirme) | TFRS 3/9/16/15/10/5/11, TMS 21/12/29/16/38/36/23 | 15 | karma (KON 3, FAR 2, KUR 1, KIR 2, VRG 1, ENF 1, YOK 5) |
| 2026/1 | 2 (1)-(5) | 8 işlemli düzeltme vakası: erken hasılatın iptali (340), stok NGD, MDV değer düşüklüğü, faiz ve kur farkının TFRS 18 finansman kategorisine taşınması, kiralamanın aktifleştirilmesi, BKZ %5, dava karşılığı, TMS 29 artışı; TFRS 18 gelir tablosu; analitik yorum | TFRS 15, TMS 2, TMS 36, TFRS 18, TFRS 16, TFRS 9, TMS 37, TMS 29 | yalnız (5) = 5 görünüyor | karma (KIR, FAR, VRG/TMS 37, ENF + YOK) |

### 1B. FYN — Finansal Yönetim

| Dönem | Soru | Konu özeti | Dayanak / yöntem | Puan | Konu (yaml) |
|---|---|---|---|---|---|
| 2022/1 | 1 a-c | SP araçları (alacak, ortaklık ve karma), halka arzın faydaları, derecelendirme ile CDS karşılaştırması | SPK kavramları, finansal piyasalar | 25 | YOK |
| 2022/1 | 2 a-b | Fon akım tablosu ve yorumu; etkinlik süresi, NİS/dönen varlık, borç servis oranı, özsermaye kârlılığı | fon akım, oran analizi | 25 (15+10) | FPA / oran analizi (fon akım YOK) |
| 2022/1 | 3 a-b | Tahvil değeri, Macaulay ve düzeltilmiş durasyon; ertelenmiş kredinin eşit taksiti | tahvil, anüite | 25 (15+10) | ZDP |
| 2022/1 | 4 a-c | Varlık ağırlıklı sermaye maliyeti ve beta; risk primi; yeni tahvil ihracında özkaynak maliyeti ve betasının geri hesaplanması | AOSM, CAPM, beta | 25 (10+5+10) | SMR |
| 2022/2 | 1 a-c | Ödünleşme kuramı, geleneksel yaklaşım, sermaye yapısını etkileyen iç ve dış faktörler | sermaye yapısı teorileri | 25 (7,5+7,5+10) | SMR / optimal yapı |
| 2022/2 | 2 a-d | Faizi de karşılayan başabaş, FVÖK ve HBK, ortak getirisini sağlayan satış miktarı, kaldıraç dereceleri | başabaş, kaldıraç | 20 (4×5) | FPA (başabaş kazanımı YOK) |
| 2022/2 | 3 a-d | NBD, İVO (enterpolasyon), yıllık eşdeğer net hasıla, iskontolu geri ödeme süresi | sermaye bütçelemesi | 25 | SBT |
| 2022/2 | 4 a-b | %20 bedelsiz hissenin özkaynak etkisi; hisse geri alım fiyatı | kâr payı politikası | 20 (10+10) | FPA / kâr payı |
| 2022/2 | 5 | Kira: aylık ödemenin bugünkü değeri ile peşin ödemenin karşılaştırılması | anüite | 10 | ZDP |
| 2022/3 | 1 | Bileşik faizle gelecek değer ve faiz geliri | BD/GD | – | ZDP |
| 2022/3 | 2 | Üç aylık bileşikte nominal faiz oranının bulunması | GD | – | ZDP |
| 2022/3 | 3 | Hazine bonosunun piyasa değeri (basit iskonto) | iskonto | – | ZDP |
| 2022/3 | 4 | Ertelenmiş (3 ay sonra başlayan) anüite taksiti | anüite | – | ZDP |
| 2022/3 | 5 | Sipariş verme noktası ve tarih bazlı stok seviyesi | stok yönetimi | – | ISY |
| 2022/3 | 6 | Kredi değerliliğinde 5K | alacak ve kredi politikası | – | ISY |
| 2022/3 | 7 a-c | Maliyet artışlarıyla 2 yıllık başabaş; azalan talepte gerekli birim değişken maliyet; 3 yıllık kâr payı NBD ile hisse devri tekliflerinin karşılaştırılması | başabaş, NBD | – | FPA (başabaş YOK) + SBT |
| 2022/3 | 8 a-d | Doğrudan yöntemle nakit akım tablosu (18 kalem) | nakit akım tablosu | – | YOK (FPA'da yok) |
| 2023/1 | 1 | Eşit taksitli kredi ödeme planı | anüite | – | ZDP |
| 2023/1 | 2 | Vergi sonrası AOSM | AOSM | – | SMR |
| 2023/1 | 3 a-b | EUR/JPY çapraz alış-satış kuru; yen yerine euro tahsilatının kâr/zararı | döviz piyasası, kur riski | – | YOK |
| 2023/1 | 4 a-b | EOQ; miktar indirimli sipariş seçimi | stok yönetimi | – | ISY / EOQ |
| 2023/1 | 5 | Senetlerin ortak vadeli tek senede dönüştürülmesi (iç iskonto) | iskonto | – | ZDP |
| 2023/2 | 1 | Miller-Orr modelinde fırsat maliyetinin geri hesaplanması | nakit yönetimi | – | ISY |
| 2023/2 | 2 A-C | İki hissenin beklenen getirisi, standart sapması ve değişim katsayısıyla seçimi | risk-getiri | – | RGT |
| 2023/2 | 3 A-C | NBD (anüite tablosu verilmiş), ikame zinciri (farklı ömürler), yıllık eşdeğer gider | sermaye bütçelemesi | – | SBT |
| 2023/2 | 4 A-B | Sektör oranlarından proforma bilanço ve fon ihtiyacı | finansal planlama | – | FPA (oran analizi; proforma YOK) |
| 2023/3 | 1 | Faiz swapı: sabit ve değişken maliyetler, banka kazancı | türev, swap | ≈20 | YOK |
| 2023/3 | 2 | İki projenin personel ve makine başına günlük hasılatla karşılaştırılması | proje karşılaştırma | ≈10 | YOK (SBT ile zayıf ilişki) |
| 2023/3 | 3 | Döviz satım opsiyonu, iki senaryo | opsiyon, kur riski | ≈20 | YOK |
| 2023/3 | 4 a-d | Tahvil değeri, Macaulay ve düzeltilmiş durasyon, konveksite açıklaması | tahvil | ≈25 | ZDP (durasyon kazanımda yok) |
| 2023/3 | 5 a-b | Portföy: Gordon, farklı büyüme oranlı model, F/K, PD/DD ile gerçek değer; likidite için satılacak hisse | hisse değerleme | ≈25 | ZDP / Gordon |
| 2024/1 | 1 | İçsel ve sürdürülebilir büyüme oranlarından özkaynak ve finansal kaldıraç oranı | büyüme oranları | 25 | FPA (kazanımda yok) |
| 2024/1 | 2 | Artık kâr ve eldeki kuş kuramına göre proje bazında optimal dağıtım oranı | kâr payı politikası | 25 | FPA / kâr payı |
| 2024/1 | 3 | Reel faizden enflasyon; temettü ve sermaye kazancıyla satış fiyatı | Fisher, HS getirisi | 20 | ZDP |
| 2024/1 | 4 a-c | FAVÖK-HBK analizi: finansman ihtiyacının çözülmesi, %25 borçta HBK, kayıtsızlık FAVÖK'ü | sermaye yapısı, EBIT-EPS | 30 | SMR / finansal kaldıraç |
| 2024/2 | 1 | Oranlardan (nakit oranı, stok bağımlılık, KVYK/aktif, ROA, ROE, DV/devamlı sermaye, devir hızları) bilanço ve gelir tablosu türetme | oran analizi | ≈25 | FPA / oran analizi |
| 2024/2 | 2 | PERT ile satış tahmini ve standart sapma; uzman tablosundaki eksiklerin bulunması | satış tahmini | ≈30 | YOK |
| 2024/2 | 3 a-b | Kovaryans ve varyansla beta; yorum | beta | ≈30 | RGT / SMR (beta) |
| 2024/2 | 4 | Baumol modelinde dönemsel nakit ihtiyacı değişimi (geri hesap) | nakit yönetimi | ≈15 | ISY |
| 2024/3 | 1 a-b | İki işletmenin başabaş ilişkisinden satış fiyatı; reklam artışı sonrası başabaş değişimi | başabaş | 30 | FPA (başabaş YOK) |
| 2024/3 | 2 | Mevsimsel satışta brüt işletme sermayesi gereksinimi (yıllık satışın çözülmesi) | işletme sermayesi | 30 | ISY |
| 2024/3 | 3 | Vergi artışında AOSM'nin %5 düşmesinden başlangıç vergi oranının bulunması | AOSM | 25 | SMR |
| 2024/3 | 4 | Sabit ve azalan faizli mevduatlarda faiz gelirlerinin eşitliğinden A/B oranı | bileşik faiz | 15 | ZDP |
| 2025/1 | 1 a-d | Menkul kıymetleştirme, acenta sorunu ve maliyeti, CDS, Altman Z | finansal piyasalar, iflas tahmini | 25 | YOK (Altman YOK) |
| 2025/1 | 2 a-d | Gelir tablosu, FKD, FiKD, BKD | kaldıraç | 15 | FPA / kaldıraç |
| 2025/1 | 3 | İki projede NBD ve karlılık endeksi (çok dönemli çıkış) | sermaye bütçelemesi | 10 | SBT |
| 2025/1 | 4 | Üç ürünlü başabaş, miktar ve tutar olarak | başabaş | 20 | FPA (başabaş YOK) |
| 2025/1 | 5 | Senetlerin bugünkü değeri ve yeni senedin nominali | iskonto | 10 | ZDP |
| 2025/1 | 6 | Satış yüzdesi yöntemiyle proforma bilanço, finansman açığı ve oran kısıtlarıyla kaynak dağılımı | finansal planlama | 20 | FPA (proforma YOK) |
| 2025/2 | 1 | Opsiyon sözleşmesi ve primi etkileyen faktörler | türev | 15 | YOK |
| 2025/2 | 2 | Nakit iskontosundan vazgeçmenin yıllık bileşik maliyeti | ticari kredi maliyeti | 10 | ISY / kısa vadeli finansman |
| 2025/2 | 3 | Oranlardan bilanço türetme | oran analizi | ≈15 | FPA |
| 2025/2 | 4 | Makine yenileme: başlangıç akışı (eski makine satışı ve vergi etkisi), 10 yıllık artımsal akışlar, hurda, NBD | sermaye bütçelemesi | 30 | SBT / nakit akışı tahmini |
| 2025/2 | 5 | Doğrudan yöntemle nakit akım tablosu | nakit akım tablosu | 30 | YOK |
| 2025/3 | 1 a-e | Finansal sürdürülebilirlik, muhasebe ve ekonomik kâr, piyasa faiz oranı bileşenleri, piyasa kapitalizasyonu, nakit süpürme | kavramlar | 20 (5×4) | YOK |
| 2025/3 | 2 | Farklı vadeli yatırımların yıllıklandırılmış getirisi | bileşik getiri | 10 | ZDP |
| 2025/3 | 3 | Emeklilik birikimi: büyüyen anüitenin bugünkü değeri, yıllık birikim tutarı | anüite | 25 | ZDP |
| 2025/3 | 4 | Halka arz fiyatı: F/K, PD/DD, F/NA çarpanları | göreli değerleme | 20 | ZDP (FPA M&A çarpanlarına yakın) |
| 2025/3 | 5 | Oranlardan bilanço kalemleri ve Altman Z | oran analizi, iflas | 25 | FPA (Altman YOK) |
| 2026/1 | 1 | Proforma gelir tablosu ve bilanço (tahsil ve ödeme süreleri, devir hızları) | finansal planlama | ≈25 | FPA (proforma YOK) |
| 2026/1 | 2 | İki ürünlü başabaş (tutar), satış karması değişimiyle karar | başabaş | ≈25 | FPA (başabaş YOK) |
| 2026/1 | 3 | Kredi politikası alternatifleri: şüpheli alacak, tahsilat gideri, alacak fon maliyeti, vergi sonrası kâr | alacak yönetimi | ≈25 | ISY / kredi politikası |
| 2026/1 | 4 a-d | NBD, KE, MIRR, İVO ve karar tablosu | sermaye bütçelemesi | 25 (5×5) | SBT |

---

## 2. Frekans tabloları

### 2A. IFM: görünen puanlar (935 puan; 2022/1 S2, 2022/3 S1-S2, 2025/2 S1-S2, 2025/3 ve 2026/1 S2'nin çoğu puansız)

| yaml konu | agirlik | Görünen puan | Pay (/935) | Geçtiği dönem (puansızlar dahil) | Yorum |
|---|---|---|---|---|---|
| KON | 18 | 40 | %4 | 2022/3, 2023/3, 2024/3, 2025/2*, 2025/3*, 2026/1* | Hep eliminasyon kaydı ya da tanım. TFRS 3 şerefiye hesabı hiç sorulmadı. **Ağırlık fazla** |
| ENF | 14 | 65 | %7 | 2023/3, 2024/1, 2026/1 | Yalnız TMS 29. VUK mük. 298 ve 698 hiç sorulmadı |
| FAR | 14 | 70 | %7,5 | 2022/1, 2023/1, 2024/1, 2024/2, 2025/2*, 2026/1 | Reeskont / itfa edilmiş maliyet ağırlıklı. BKZ boşluk düzeyinde, riskten korunma hiç yok |
| KUR | 10 | 0 | %0 | 2026/1* (1 boşluk maddesi) | **Ağırlık fazla** |
| KIR | 14 | 110 | %12 | 2022/2, 2023/2, 2023/3, 2024/3, 2025/2, 2025/3*, 2026/1 | Ağırlık neredeyse tamamen TFRS 15 inşaat/proje. TFRS 16 yalnız 2026/1'de |
| VRG | 14 | 95 doğrudan; EV kaydı vakaların neredeyse hepsinde | %10 (+gömülü) | 13 dönemin ≥10'u | **Fiilen en kritik beceri** |
| BDB | 16 | 0 | %0 | hiç | **Hiç sorulmadı** |
| YOK toplamı | – | ≈555 | ≈%59 | her dönem | aşağıda kırılım |

*: yalnız puansız boşluk, D/Y veya alt madde düzeyinde.

YOK kırılımı (görünen puan): KÇ 90 (ayrıca puansız 2022/3 S1, 2025/3 S1-S2: 13 dönemin 8'inde var); TMS 16/38/36 MDV-MODV 105; TMS 2 75; TMS 40 45; TFRS 5 35; TMS 7 35 (+2025/2 içinde); TMS 20 35; TFRS 6 30; TSRS 1 26; TMS 41 20; TFRS 13 9; TFRS 8, TMS 10, TMS 24 ve TMS 1 tanımları 20; TFRS 1 (2025/3 S3, puansız); TFRS 18 (2026/1, puansız); TMS 23 ve TMS 33 madde düzeyinde.

### 2B. FYN: görünen ve türetilmiş puanlar (10 dönem × 100 = 1.000; 2022/3, 2023/1 ve 2023/2 puansız, yalnız soru sayısına girdi)

| yaml konu | agirlik | Soru sayısı (63) | Puan (/1000) | Pay | Yorum |
|---|---|---|---|---|---|
| ZDP | 15 | 16 | 185 | %18,5 (sayıca %25) | Durasyon, iskonto/senet, ertelenmiş ve büyüyen anüite, göreli değerleme dahil. **Biraz artırılabilir** |
| SBT | 20 | 5 (+2 kısmi) | 90 (+≈10) | %9-10 | **Ağırlık fazla** |
| SMR | 17 | 5 | 105 | %10,5 | AOSM ve FAVÖK-HBK. Biraz fazla |
| ISY | 15 | 8 | 80 | %8 (sayıca %13) | Uygun |
| RGT | 13 | 2 | 30 | %3 | **Ağırlık çok fazla** |
| FPA | 20 | 19 | 375 | %37,5 (sayıca %30) | **Ağırlık çok az.** İçinde başabaş (5 soru), oranlardan tablo türetme (4), proforma (3), nakit akış/fon akım tablosu (3), Altman (2) var; bunların çoğu kazanımlarda yok |
| YOK (finansal piyasalar ve türevler, kavramlar) | – | 7 | 125 | %12,5 | swap, opsiyon, CDS, çapraz kur, menkul kıymetleştirme, acenta, SP araçları |
| YOK (2023/3 S2) | – | 1 | ≈10 | %1 | |

---

## 3. Sorulan ama yaml'da eksik veya zayıf konular

### IFM
1. **Kavramsal Çerçeve**: 8 dönemde, çoğunlukla 1. soru (20-25 puan, son dönemlerde boşluk doldurma ve D/Y). Örnekler: 2022/1 S1, 2022/3 S1, 2023/1 S1, 2023/2 S1, 2023/3 S1d, 2025/1 S2, 2025/3 S1-S2. yaml'da `kaynak_dosyalari: kavramsal_cerceve` var ama konusu yok. **Yeni konu önerisi (≈%12-15).**
2. **VUK→TFRS dönüşüm iş akışı ve her kaydın ertelenmiş vergi etkisi**: 2022/1 S2, 2022/2 S3, 2023/1 S2, 2024/1 S2-8, 2024/2 S2/S4, 2024/3 S2-3, 2025/2 S4. Sınav, 289/489/695/696 ve 564-09 hesaplarını ayrı kayıtla ister. VRG kazanımları teorik; "dönüşüm kaydı ve EV kaydı" ile "EV varlık-yükümlülük mahsubu" eklenmeli.
3. **Maddi ve maddi olmayan duran varlıklar (TMS 16, 38, 36)**: amortismanda VUK-TFRS ömür ve kalıntı değer farkı, yeniden değerleme (brüt/net), kuruluş gideri, değer düşüklüğü. Örnekler: 2022/3 S3, 2023/1 S2.2, 2024/1 S2/S8, 2024/3 S3, 2026/1 S2. **Yeni konu önerisi.**
4. **TMS 2 Stoklar** (NGD, maliyet unsurları, hareketsiz stok, LIFO yasağı): 2022/1 S2, 2023/2 S4, 2024/1 S3, 2024/3 S4, 2025/1 S3b, 2025/3 S3.6, 2026/1 S2.
5. **TMS 40 YAG**: 2022/1 S2(9), 2023/2 S3, 2024/1 S1c/S6, 2025/3 S3.2.
6. **TFRS 5 satış amaçlı varlıklar ve durdurulan faaliyetler**: 2023/1 S2.3, 2024/1 S1a, 2025/1 S3d, 2025/3 S3.4, 2026/1 S1-10.
7. **TMS 7 nakit akış tablosu**: 2024/2 S3 (35), 2025/2 S3B ve S4.3.
8. **TMS 20 devlet teşvikleri**: 2024/2 S2, 2025/1 S3c.
9. **Sunum, yeni ve özel standartlar**: TMS 1, TFRS 18 (2026/1), TFRS 1 ilk uygulama (2025/3 tamamen), TSRS 1 (2024/2, 2025/1), TFRS 13 (2024/2, 2025/2-3), TMS 41, TFRS 6, TFRS 8, TMS 10, TMS 24, TMS 33.
10. **KIR içinde zayıf olan**: yıllara yaygın inşaat (170/350, tamamlanma oranı, sözleşme varlığı/yükümlülüğü 163/352). Bu, KIR'in fiilen sorulan çekirdeği. Ayrıca TMS 19 kısa vadeli izin karşılığı (2024/1 S5) VRG'de yok (kazanımda yalnız kıdem var).

### FYN
1. **Başabaş analizi** (faiz dahil, hedef kâr, çok ürünlü, satış karması): 2022/2 S2, 2022/3 S7, 2024/3 S1, 2025/1 S4, 2026/1 S2. yaml'da yalnız YNM/MHK altında; FYN'ye eklenmeli.
2. **Oranlardan finansal tablo türetme** (tersine oran analizi): 2023/2 S4, 2024/2 S1, 2025/2 S3, 2025/3 S5.
3. **Proforma tablolar ve dış finansman ihtiyacı** (satış yüzdesi yöntemi): 2023/2 S4, 2025/1 S6, 2026/1 S1.
4. **Nakit akım tablosu (dolaysız) ve fon akım tablosu**: 2022/1 S2, 2022/3 S8, 2025/2 S5 (30 puan).
5. **İflas tahmini, Altman Z**: 2025/1 S1d, 2025/3 S5.
6. **Finansal piyasalar ve türevler** (swap, opsiyon, CDS, çapraz kur, kur riski, menkul kıymetleştirme, SP araçları, halka arz): 2022/1 S1, 2023/1 S3, 2023/3 S1/S3, 2025/1 S1, 2025/2 S1. **Yeni konu önerisi (≈%10-12).**
7. **Finans kavramları** (acenta sorunu, ekonomik kâr, piyasa faiz oranı bileşenleri, nakit süpürme, piyasa kapitalizasyonu, finansal sürdürülebilirlik): 2025/1 S1b, 2025/3 S1.
8. **ZDP içinde eksik**: durasyon ve konveksite (2022/1 S3, 2023/3 S4), iskonto ve senet değişimi (2023/1 S5, 2025/1 S5), hazine bonosu, ertelenmiş ve büyüyen anüite, reel faiz (Fisher), yıllıklandırma, F/K-PD/DD-F/NA ile göreli değerleme (2023/3 S5, 2025/3 S4).
9. **SBT içinde eksik**: MIRR hesabı, yıllık eşdeğer hasıla/gider, ikame zinciri, makine yenileme kararı (2025/2 S4).
10. **SMR içinde eksik**: FAVÖK-HBK ve kayıtsızlık noktası (2024/1 S4), sermaye yapısı teorileri (2022/2 S1; "optimal sermaye yapısı" kazanımı kısmen karşılıyor).
11. **ISY içinde eksik**: Miller-Orr ve Baumol (ters çözüm), sipariş noktası, miktar indirimi, BİSG, nakit iskontosu maliyeti.
12. **Diğer**: içsel ve sürdürülebilir büyüme oranı (2024/1 S1), PERT satış tahmini (2024/2 S2), bedelsiz hisse ve geri alım hesabı (2022/2 S4).

---

## 4. Hiç (ya da yalnız boşluk/D-Y düzeyinde) sorulmayan yaml konuları ve kazanımları

**IFM**
- **BDB tamamen**: birleşme-devir kayıtları, bölünme ve hisse değişimi, tasfiye, kayıtlı/rayiç değer. 13 dönemde hiç yok. Bu konu muhtemelen VTK/BDB'ye aittir; IFM'de ağırlık 16 → ≈3-5 önerilir.
- **KUR**: işlevsel para birimi, yabancı işletmenin çevrimi, VUK md. 280 hiç yok (yalnız 2026/1'de "kapanış kuru" boşluğu). 10 → ≈3.
- **ENF**: VUK mük. 298, VUK düzeltme katsayıları, 698 hesabı hiç yok. Sorulan yalnız TMS 29 (NPP 648/658 veya 669/679).
- **FAR**: riskten korunma muhasebesi hiç yok. TFRS 9 sınıflandırma ve BKZ yalnız boşluk ve 2026/1'de bir madde.
- **KON**: TFRS 3 satın alma yöntemi ve şerefiye hesabı (yalnız "pazarlıklı satın alma" boşluğu), kontrol gücü olmayan pay hesabı (yalnız tanım), TMS 28 özkaynak yöntemi (yalnız boşluk ve TFRS 1 maddesi).
- **KIR**: TFRS 16 yalnız 2026/1'de (bir vaka maddesi ve bir boşluk).
- **VRG**: TMS 19 kıdem tazminatı ölçümü hiç yok (yalnız "aktüeryal kazanç ve kayıplar" boşluğu). TMS 37 yalnız 2026/1 dava karşılığı ve 2022/1 şüpheli alacak.

**FYN**
- RGT: portföy çeşitlendirmesi, iki varlıklı portföy varyansı, sistematik/sistematik olmayan risk ayrımı hiç sorulmadı (beta ve tek hisse risk-getirisi soruldu).
- FPA: DuPont, nakit bütçesi (ISY'deki BİSG dışında), birleşme ve satın alma değerlemesi hiç sorulmadı.
- ISY: nakit dönüşüm süresi hiç sorulmadı (yalnız 2022/1'de "etkinlik süresi").
- SBT: klasik (iskontosuz) geri ödeme süresi tek başına sorulmadı; iskontolusu 2022/2'de var.

---

## 5. Soru stili

### IFM
- **Süre ve yapı**: 2 saat, 100 puan, 3-8 soru. 2025/1'de "Bu sınav 3 adet sorudan oluşmaktadır" uyarısı var.
- **1. soru neredeyse her zaman tanım ve kavram**: Kavramsal Çerçeve'den veya bir standarttan 4-5 kavram, 5'er puan. Beklenen cevap standart metninin özü; anahtar neredeyse kelimesi kelimesine standart metni. 2025/2'den itibaren format değişti: 10-15 maddelik **boşluk doldurma** ve gerekçeli **doğru/yanlış**.
- **Vaka soruları (çekirdek)**: Kalıp şu: "(A) AŞ'nin yasal defter kayıtları VUK'a göre yapılmıştır; TMS/TFRS düzeltme ve sınıflandırma kayıtlarını vergi etkisini de dikkate alarak yapınız (KV oranı %20/23/25)". Veriler kısa: bir paragraf ve 3-6 satırlık tablo (maliyet, birikmiş amortisman, faydalı ömür, devir hızı, faiz oranı, endeks).
- **Cevap biçimi**: yevmiye kayıtları THP/MSUGT kodlarıyla (255/257, 122/322, 158/654, 194/195/199, 210/211, 374, 522, 564-xx, 163/352, 170/350, 740/741/622, 300/303/400). Her düzeltmenin ardından **ayrı EV kaydı** gelir: 289 Ertelenmiş vergi varlığı / 696 Ertelenmiş vergi geliri ya da 695 Ertelenmiş vergi gideri / 489 Ertelenmiş vergi yükümlülüğü; DKG kalemlerinde 564-09. Hesap tabloları küçük: reeskont (tutar, devir hızı, gün = 365/devir hızı, iç iskonto formülü T×n×t / (36500 + n×t)), amortisman farkı (kıst ay), endeks katsayısı tablosu.
- **Büyük vakalar**: TMS 29 bilanço düzeltmesi (her kalem 5-10 puan, düzeltilmiş bilanço 10); TMS 7 doğrudan yöntem (bölüm başına 10-15); 2025'ten itibaren **çok standartlı anlatı vakaları** (TMS 41+2+20+TFRS 5; TFRS 1 10 alt madde; 2026/1'de 8 işlem için "ölçüm / tanıma / sunum" tablosu, düzeltme kayıtları, TFRS 18 gelir tablosu ve 5 puanlık analitik yorum).
- **Puanlama**: kayıt başına puan (ör. 5/10/5/5), yıl başına puan (TMS 20: 5+5+5), hesap ve kayıt ayrımı (TMS 2: maliyet 5, kayıt 10+10). Esneklik notları var: "vergi ödemelerini nakit çıkışı kabul etmeyenlere de tam puan" (2024/2), "Puan verilmedi, soruda net istenmedi" (2024/3), "geçici fark çıkmadığı için EV yok" kısmına 5 puan (2024/1 S7). Yani "EV doğmaz" demek de puanlı bir cevaptır.

### FYN
- **Süre ve yapı**: 2 saat, 100 puan, 4-8 soru. Neredeyse tamamı hesaplamalı; 1 soru kavramsal olabilir (3-7 puanlık kısa tanımlar).
- **Mikro puanlama (2023/3'ten itibaren açıkça)**: doğru formülün yazılması ayrı puan alır (ör. "formül 2, hesaplama 8"; "katkı payı oranının yazılması 3, tam formül 7"). Ara sonuçlar 1-5 puan, nihai karar cümlesi 1-2 puan ("proje yapılabilir", "B hissesi tercih edilir"). 2024/1 notu: istenmeyen tanımlar puanlamaya girmez; yanlış yaklaşım (getiri tutarına göre karar) yanlış sayılır.
- **Ters çözüm soruları çok yaygın**: bilinmeyeni sonuçtan geri bulma. Örnekler: reel faizden enflasyon, AOSM'nin %5 düşmesinden vergi oranı, Baumol'da T değişimi, Miller-Orr'da fırsat maliyeti, başabaş ilişkisinden satış fiyatı, HBK=20 koşulundan finansman ihtiyacı F, BİSG farkından yıllık satış, PERT'te eksik uzman tahmini. Pratik sorularda bu tip ağırlıklı olmalı.
- **Tablo üretme**: oranlardan bilanço, proforma bilanço ve gelir tablosu ile finansman açığı, 18 kalemlik dolaysız nakit akım tablosu, Altman Z bileşenleri.
- **Sayısal üslup**: yüksek oranlar (%35-%80 faiz, %46 iskonto), 2-4 ondalık yuvarlama, İVO için %5 veya %10 aralıklı doğrusal enterpolasyon, bazen anüite faktör tablosu verilir (2023/2).

---

## 6. Anlatım dosyası kontrolleri (sınavın en çok sorduğu konulara göre)

### IFM/VRG.md (TMS 12, 37, 19)
- İyi: geçici fark tanımı ve vergiye tabi/indirilebilir ayrımı (2024/1 S1d tanımını karşılar), TMS 37 tanıma koşulları, oran ve iskonto yasağı.
- **Eksik 1: hesap kodları çelişkisi.** Dosya "THP'de ertelenmiş vergiye ayrılmış hesap kodu bulunmaz" diyor. Cevap anahtarları 289/489/695/696 ve 564-09 kullanıyor; 2024/1 bunları "MSUGT'ne ilave hesaplar" olarak listeliyor. Bu kodlar ders anlatımına eklenmeli.
- **Eksik 2:** VUK→TFRS dönüşümünde kalem kalem EV tablosu yok (reeskont, amortisman farkı, stok değer düşüklüğü, kuruluş gideri, YAG değer artışı). 289/489 mahsup kaydı (2022/2 S3c) da yok.
- **Eksik 3:** Ticari kârdan mali kâra geçişte geçici ve kalıcı fark ayrımı ile "cari vergi + ertelenmiş vergi = toplam vergi gideri" kaydı (691/370/489) çalışılmış örnek olarak yok. 2025/2 S4 bunu 40 puanla sordu.
- **Eksik 4:** TMS 19 kısa vadeli izin karşılığı (374) yok. Dosyanın büyük kısmı kıdem tazminatına ayrılmış; kıdem hesabı hiç sorulmadı.

### IFM/KIR.md (TFRS 16, TFRS 15)
- İyi: beş adım, edim yükümlülüğü ve sözleşme varlığı tanımları (2023/3 S1b, 2024/3 S1b), TFRS 16 ölçümü (2026/1 S2.5 ile uyumlu).
- **Eksik 1:** sınavın asıl kalıbı olan **yıllara yaygın inşaat ve proje** işlenmemiş. Eksik başlıklar: 170/350 bakiyelerinden tamamlanma oranına göre hasılat ve maliyet düzeltmesi, hakediş fazlasının sözleşme yükümlülüğüne, eksiğinin sözleşme varlığına alınması, maliyetin 156'ya ertelenmesi, 740/741/622 akışı, her kayıtta EV (2022/2 S2, 2023/2 S2, 2024/3 S2).
- **Eksik 2:** dosya "THP'de sözleşme varlığı veya yükümlülüğü hesabı yok, 340 model tercihi" diyor. Anahtarlar 163 "Mal ve hizmet satışlarından doğan sözleşme varlıkları" ve 352 "Sözleşme yükümlülükleri" kullanıyor (2026/1'de 340). En az alternatif kodlar olarak gösterilmeli.
- **Eksik 3:** erken kaydedilmiş hasılatın iptali (600 → 340, 2026/1) örneği yok.
- **Not:** TFRS 16 kısmı soru sıklığına göre fazla uzun.

### FYN/SBT.md
- İyi: NBD, enterpolasyonla İVO (sınav yöntemiyle aynı), iskontolu geri ödeme, KE ve artımsal nakit akışı ilkeleri.
- **Eksik:**
  - MIRR yalnız kavram olarak geçiyor; hesap örneği yok (2026/1 S4c).
  - Yıllık eşdeğer hasıla/gider ve ikame zinciri yok (2022/2 S3c, 2023/2 S3).
  - Makine yenileme kararı yok: eski makinenin defter değeri ve satış zararının vergi etkisi, amortisman vergi kalkanı farkı, kaybedilen eski amortisman, hurda değeri vergisi (2025/2 S4, 30 puan).
  - Çok dönemli yatırımda KE paydasının bugünkü değeri işlenmemiş (2025/1 S3).

### FYN/FPA.md
- İyi: kaldıraç dereceleri (2022/2 S2d, 2025/1 S2 ile birebir), kâr payı teorileri.
- **Eksik, en çok sorulan bloklar:**
  1. Oranlardan bilanço türetme tekniği (4 soru). Sınavın kullandığı nakit oranı, stok bağımlılık oranı, DV/devamlı sermaye ve özkaynak devir hızı yok.
  2. Satış yüzdesi yöntemiyle proforma bilanço ve dış finansman ihtiyacı (3 soru).
  3. Başabaş analizi: faiz dahil, hedef kâr, çok ürünlü (5 soru). Dosyada yalnız bir parantez içinde geçiyor.
  4. Dolaysız nakit akım tablosu ve fon akım tablosu (3 soru, 2025/2'de 30 puan).
  5. Altman Z (2 soru).
  6. İçsel ve sürdürülebilir büyüme oranı (2024/1 S1).
  7. Bedelsiz hisse ve geri alım fiyatı hesabı (2022/2 S4).
- **Uyumsuzluk:** dosyadaki artık kâr örneği hedef sermaye yapısı yöntemine dayanıyor. 2024/1 S2 ise proje getirisini ortakların alternatif getirisiyle karşılaştırıyor ve eşitlikte eldeki kuş kuralını uyguluyor. Bu sınav varyantı ayrıca anlatılmalı.
- **Fazla:** DuPont, nakit bütçesi ve M&A değerlemesi hiç sorulmadı; yer kısaltılabilir.

---

## Önerilen yaml ağırlık revizyonu (taslak)

- **IFM**: KC (Kavramsal Çerçeve, yeni) 13, DON (VUK→TFRS dönüşüm ve EV, VRG'den ayrılabilir) 18, VRG 8, MDV (TMS 16/38/36/40/2, yeni) 18, KIR 12 (TFRS 15 ağırlıklı), FAR 7, ENF 7 (TMS 29), KON 6, TAB (TMS 1/7/TFRS 5/TMS 20/TFRS 18/TFRS 1/TSRS 1, yeni) 9, KUR 1, BDB 1. Toplam 100.
- **FYN**: ZDP 20, SBT 11, SMR 11, ISY 12, RGT 4, FPA 30 (başabaş, proforma, oranlardan tablo, nakit akış tablosu ve Altman eklenerek), PIY (finansal piyasalar ve türevler, yeni) 12. Toplam 100.
