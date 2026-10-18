# YMM anlatım denetimi — Grup 4 (IFM, REV, SPM, VTK, YNM)

Tarih: 2026-10-18. Kapsam: `content/anlatim/ymm/{IFM,REV,SPM,VTK,YNM}/*.md` (30 dosya). Ölçüt: `docs/devir/ANLATIM_EDITOR_TALIMATI.md`, `docs/uretici/YMM_ANLATIM_KURALLARI.md`, `content/mufredat/ymm.yaml` (güncel kazanımlar), `docs/denetim/ymm_cikmis_2026-10-17/` raporlarındaki "anlatım açıkları".

**Doğrulama:** Her dosya `pipeline.anlatim.denetle` + `siki_denetle` (YMM müfredatı, `_dersler('ymm')`) ile denetlendi; 30 dosyanın tamamı hatasız (A01 900–1.800 kelime, A02–A07, alıntılar mevzuat metninde birebir). `durum` alanlarına dokunulmadı (hepsi `taslak`). Yeni eklenen bütün alıntılar Grep ile mevzuat dosyasında bulunarak yazıldı. Komut: proje kökünde `python <scratchpad>/dog.py` (denetle + siki_denetle, `--sinav ymm` eşdeğeri; `python -m pipeline.anlatim` ana komutu yalnız SMMM klasörünü taradığından ayrı betik kullanıldı).

**Genel bulgu:** Birçok dosya ymm.yaml'ın eski kazanım listesine göre yazılmıştı. Yaml güncellenmiş (ör. VRG'ye 289/489, KIR'a yıllara yaygın inşaat, AKT'ye VUK 279/280/328, DEG'e 280/A, 322-324 ve mük. 298/A, CEZ'e tekerrür ve zamanaşımı, HAO'ya SPKn md. 21, BTC'ye nakit bütçesi, KRV'ye ortak ürün kararı eklenmiş); eksik kazanımlar tamamlandı. Kelime sınırı (1.800) nedeniyle eklemeler yapılırken sınavda sorulmayan veya müfredattan çıkmış kısımlar kısaltıldı.

---

## IFM

### IFM/VRG — VUK'tan TFRS'ye dönüşüm, ertelenmiş vergi ve karşılıklar (yeniden yazıldı)
- **Olgu hatası düzeltildi:** "THP'de ertelenmiş vergiye ayrılmış hesap kodu bulunmaz" ifadesi tek başına bırakılmıştı; sınav anahtarlarının kullandığı ilave hesaplar (289, 489, 695, 696, DKG için 564-09) tabloyla eklendi (THP'de 289/489/374 kodlarının boş olduğu `msugt_1_ek5_thp_guncel.txt` ile doğrulandı).
- Eklenen: dört adımlı VUK→TFRS dönüşüm iş akışı; kalem kalem EV tablosu (reeskont, amortisman farkı, stok değer düşüklüğü, izin karşılığı); TMS 12.74 mahsup kaydı (489/289); cari vergi (691/370, 371 mahsubu) + ertelenmiş vergi = toplam vergi gideri ve etkili oran mutabakatı (kalıcı fark etkisiyle sağlama); kalıcı farkta "EV doğmaz" cevabının puan aldığı notu; TMS 19.13/16 kullanılmamış izin karşılığı (374 ilave hesap); dava karşılığı örneği; 2026 KV oranı %25 (KVK 32/1, finans kuruluşlarında %30). Kıdem bölümü kısaltıldı.
- Hesaplar elle doğrulandı: iç iskonto 1.100.000×3.650/40.150 = 100.000; toplam vergi gideri 515.000 − 17.500 = 497.500 = 1.930.000×%25 + 60.000×%25.
- Kapatılan açıklar: Eksik 1–4 (IFM_FYN §6).
- Emin olunamayan: 564-09'un DKG vergi etkisi alt hesabı olarak kullanımı yalnız çıkmış sınav raporundan alındı (resmî THP'de yok); metinde "sınav anahtarlarının kullandığı ilave hesap" olarak sunuldu.
- **Terfi: evet.** Çekirdek sınav becerisi uçtan uca işleniyor, rakamlar tutarlı.

### IFM/KIR — Hasılat ve kiralamalar (yeniden yazıldı)
- **Olgu/yanlış yönlendirme düzeltildi:** "THP'de sözleşme varlığı/yükümlülüğü hesabı yok; 340 model tercihi" ifadesi yerine anahtarların kullandığı 163/352 (ve 2026/1'de 340) gösterildi.
- Eklenen: TFRS 15.35 zamana yayılı devir şartları, 15.41 girdi/çıktı yöntemi, tamamlanma oranı formülü; GVK md. 42 (kâr işin bittiği yıl) ile fark; 170/350 bakiyelerinden hasılat-maliyet düzeltmesi, hakediş fazlasının 352'ye, eksiğinin 163'e alınması ve EV (489/695) çözümlü örneği; erken kaydedilmiş hasılatın iptali (600→340, 153/621, 289/696); VUK mük. 290 ölçütleri (metinden doğrulandı). TFRS 16 kısmı kısaltıldı (sınav sıklığına göre).
- Emin olunamayan: sözleşme maliyetlerinin 156'ya ertelenmesi yalnız sınav raporundaki anahtar kullanımına dayanıyor; "boş stok kodu ilave hesap" olarak not edildi. Ekonomik açıdan dezavantajlı sözleşmede TMS 37'ye atıf yapıldı.
- **Terfi: evet.**

### IFM/FAR — Finansal araçlar
- Eklenen: VUK md. 281/285 (reeskont isteğe bağlı, yalnız senetli; alacakta yapılırsa borçta zorunlu) ile TFRS 9 farkı; devir hızından gün (365/devir hızı) ve iç iskonto formülüyle alıcı/satıcı reeskontu çözümlü örneği (657/122, 322/647) ve EV kayıtları; banka kredisinde işlem maliyeti farkı.
- Düzeltme: BKZ karşılığının VUK'ta KKEG olduğu ve EV varlığı doğurduğu açıkça yazıldı; riskten korunma kısmı kısaltıldı. Etkin faiz tablosu yeniden hesaplandı (r ≈ %12,085; tutarlı).
- **Terfi: evet.**

### IFM/ENF — Enflasyon muhasebesi
- Doğrulandı: mük. 298/A şartları ve Cumhurbaşkanı yetkisi, VUK geçici md. 37 (7571 s. Kanun) metni birebir; 698→648/658 kapanış örneği doğru.
- Eklenen: TMS 29 çözümlü örneği (makine ve sermaye düzeltmesi, NPP kaybı 300.000 TL) ve 2026'da VUK düzeltmesi yapılmadığından TMS 29 farkının ertelenmiş vergi doğurması (EVY 100.000 TL; sermayede EV yok — 2024/1 anahtarıyla uyumlu); 2025-2027 sınav ipucu. 588 Tebliğ'e ilişkin gereksiz paragraf çıkarıldı.
- Emin olunamayan: Anahtarların NPP için kullandığı kod (648/658 dışında "669/679" geçiyor; 669 THP'de yok) — metinde kod dayatılmadı.
- **Terfi: evet.**

### IFM/KON — Konsolidasyon ve işletme birleşmeleri
- Hesaplar doğrulandı (şerefiye, eliminasyon, özkaynak yöntemi).
- Eklenen: grup içi alacak-borç eliminasyonu; grup içi duran varlık (yazılım lisansı) satışında gerçekleşmemiş kâr ve fazla itfa düzeltmesi (679/260, 268/770; 2023/3 S3 kalıbı); TFRS 11 müşterek kontrol, iş ortaklığı/müşterek faaliyet ayrımı (2024/3, 2026/1).
- **Terfi: evet.**

### IFM/KUR — Kur değişimi
- VUK md. 280 metni ve THP 646/656/780 açıklamaları doğrulandı; değişiklik gerekmedi (kazanımlar tam, sınav ağırlığı düşük).
- **Terfi: evet.**

### IFM/BDB — Birleşme, devir ve bölünme muhasebesi
- **Olgu hatası düzeltildi:** "TTK ve KVK hükümleri kaynak setinde yer almaz" ifadeleri yanlıştı (`kvk.txt`, `ttk.txt` mevcut). KVK md. 17 (tasfiye dönemi, tasfiye kârı, 30 günlük beyan), md. 18-20 (devir şartı, bilanço değerlerinin aynen devri, kayıtlı değerle bölünme, %10 nakit sınırı, iki tam yıl şartı) eklendi; vergiden muaf devirde yasal defterde rayiç değer/şerefiye kaydı yapılmayacağı, farkın yalnız TFRS'de izleneceği açıklandı. İki yeni alıntı doğrulandı.
- **Terfi: evet.**

---

## REV

### REV/AKT — Aktif hesapların revizyonu ve değerleme (yeniden yazıldı)
- **Olgu açığı kapatıldı:** Değersiz alacakta KDV (KDVK md. 29/4: zarar yazıldığı dönemde indirim; karşılıkla gider yazılmışsa gelir kaydı şartı; alıcıda 30/e) — metinden doğrulandı ve çözümlü örnekle eklendi.
- Eklenen: VUK 324 (vazgeçilen alacak, borçluda özel karşılık, 3 yıl), konkordato bağlantısı, VUK 279 menkul kıymet, VUK 280 döviz, VUK 328 amortismanlı kıymet satışı ve yenileme fonu (549, üç yıl, amortismana mahsup) çözümlü örneği, KDVK 30/c zayi mal, 2026 tutarları (25.000 TL; 12.000 TL — 588 Tebliğ). Müfredattan çıkan kasa sayımı ve teyit kısaltıldı.
- Emin olunamayan: "Konkordatonun tasdikiyle vazgeçilen kısmın alacaklıda değersiz alacak sayılması" idarenin uygulamasına dayanıyor (kaynak klasöründe sirküler yok); hakem kontrol etmeli. "Şartların oluştuğu dönemde ayrılmayan karşılık sonraki döneme kaydırılamaz" da idari görüştür.
- **Terfi: evet (konkordato cümlesi hakemce teyit edilerek).**

### REV/GLR — Gider ve gelir hesaplarının revizyonu (yeniden yazıldı)
- **Olgu hatası düzeltildi:** Finansman gider kısıtlamasında "Cumhurbaşkanınca kararlaştırılan oran kaynaklarda yok, %10 varsayım" deniyordu; `fgk_cbk_3490.txt` (3490 s. CBK) ile oranın %10 olduğu doğrulanıp kesin hüküm olarak yazıldı.
- Eklenen: binek otomobil kısıtlamaları (GVK 40/5 %70; 40/7 amortisman sınırı 1.380.000/2.600.000 TL; ÖTV+KDV 1.200.000 TL; aylık kira 46.000 TL — GV Tebliği 332, 2026; KDVK 30/b) çözümlü örneği; KVK 11/1-k (7577 s. Kanun, 2026: şans oyunu reklamları); bağış/sponsorluk KKEG→KVK 10 akışı; kur farkı ve türev işlemler.
- Emin olunamayan: türev işlemlerde "gerçekleşme esası" idarenin uygulamadaki görüşü olarak yazıldı; kanun metni yok.
- **Terfi: evet.**

### REV/MTR — Matrah ve beyan teknikleri
- **Olgu hatası düzeltildi:** YAKV'de düşülebilecek kalemler listesi eksik/yanlış tarihliydi; KVK 32/C/2 metnine göre 5/1-a, ç, i, j, k, taşınmaz hariç 5/1-d, 10/1-g,h,i,j (7582 s. Kanun, 21/5/2026), gemi sicili/serbest bölge, TGB ve Ar-Ge, 7412 İFM indirimi; 32/C/3 indirimi eklendi.
- **Kayıt hatası düzeltildi:** Geçici vergi mahsubu 370/193 yerine 371/193 ve ödeme kaydı (370/371/102) yazıldı.
- Hesaplar (matrah 1.950.000; KV 487.500; YAKV 275.000; varyant 93.750) doğrulandı.
- **Terfi: evet.**

### REV/TFR — Transfer fiyatlandırması ve örtülü sermaye
- KVK 12-13 metniyle karşılaştırıldı; yöntemler, %10 ilişki şartı, %50 banka kuralı ve örnek hesap (170.000 TL KKEG) doğru. Değişiklik gerekmedi.
- **Terfi: evet.**

### REV/TSV — Teşvikler ve özel uygulamalar
- **Olgu hatası düzeltildi:** Hizmet ihracatı indirimi 2026 için %80 hesaplanıyordu; 11257 s. CBK (RG 30/4/2026, 1/1/2026'dan itibaren) ile oran **%100**; örnek 1.000.000 TL olarak düzeltildi.
- Eklenen: KVK 10/1-i ve j (%95; 7582 s. Kanun) ve YAKV ilişkisi; bağış ve sponsorluk indirimleri tablosu (10/1-b, c, ç, e), %5 sınır matrahı (Tebliğ 10.3.2.1) örneği, ayni bağış (10/2), devretmeme kuralı. 32/8 %12,5 oranının 2027'den başladığı Tebliğ'den doğrulandı.
- **Terfi: evet.**

### REV/BDB — Birleşme, devir, bölünme ve tür değişikliği
- KVK 17-20 ve 9 metniyle tek tek doğrulandı; zarar mahsubu örneği doğru. Değişiklik gerekmedi.
- **Terfi: evet.**

### REV/PSF — Pasif ve özkaynak hesapları
- Eklenen: ticari karşılıkların (kıdem, dava, garanti) vergide KKEG olduğu, ödendiği yıl gider yazılacağı ve TFRS'de EV doğurduğu. Diğer hükümler (VUK 285, 288; Tasdik Yön. md. 14) doğrulandı.
- **Terfi: evet.**

### REV/GNL, REV/VIN, REV/TAS
- Tasdik Yönetmeliği md. 4, 8, 14, 15, 16, 17 (10 yıl saklama), VUK 134-141 süreleri (1 yıl+6 ay, 6+6, 3+2), md. 344, 352 (II-6 defter tasdiki), 359 cezaları, 376 ve Ek md. 1 (%50 artırımlı indirim), mük. 227 (60 gün), 353/11 (400.000–4.000.000 TL, 2026) ve 588 tutarları kaynakla doğrulandı. Olgu hatası bulunmadı; değişiklik yapılmadı. (Bu üç konu müfredatta ağırlık 1'dir ve sınavda REV'de sorulmamıştır.)
- **Terfi: evet (üçü de).**

---

## VTK

### VTK/CEZ — Vergi cezaları ve uzlaşma
- Eklenen (kapatılan açıklar): fiil birleşmesi (md. 336), fiil ayrılığı (337), suçlarda birleşme (340), **tekerrür** (339; %50/5 yıl, %25/2 yıl, artırım sınırı) çözümlü örneği, ölüm (372), mücbir sebep (373), **ceza zamanaşımı** (374; 5/5/2 yıl) örneği, olay sorusu çözüm sırası. Tüm metinler VUK'tan doğrulandı; iki yeni alıntı eklendi.
- Mevcut hükümler (344, 352 tutarları, 353/1, 370/b 870.000 TL, 371, 376, Ek md. 1, 9) doğrulandı.
- Açık kalan: VUK 379 kanun yolundan vazgeçme ve 6183/İYUK konuları YRG/THS konusudur (dosyaları yok).
- **Terfi: evet.**

### VTK/DEG — Değerleme ve enflasyon düzeltmesi (yeniden yazıldı)
- **Kapatılan en büyük açık:** Enflasyon düzeltmesi (mük. 298/A) — düzeltme ve taşıma katsayısı tanımları (metinden), düzeltmeye esas tarihler, 698→648/658 ve matraha etkisi, çözümlü örnek; geçici md. 37 nedeniyle 2025-2027'de düzeltme yapılmadığı (Grep ile doğrulandı; REV_VTK raporundaki "doğrulanmadı" notu kapandı: hüküm 7571 s. Kanunla yürürlükte).
- Eklenen: VUK 280/A (metinden), 281/285 reeskont kuralları, 322-324 alacaklar, konkordato ipucu. Ölçüler tablosu sadeleştirildi.
- Emin olunamayan: konkordato mühleti dönemindeki şüpheli alacak uygulaması idari sirküler konusu; metinde sirküler kontrolü önerildi. Randıman/SMM hesabı ve sigorta tazminatı (2025/2) bu dosyada işlenmedi (kelime sınırı; VUK 328 REV/AKT'de).
- **Terfi: evet.**

---

## SPM

### SPM/HAO — Halka açık ortaklıklar
- Eklenen (kapatılan açık): **örtülü kazanç aktarımı (SPKn md. 21)** — tanım, faaliyetin yapılmaması yoluyla aktarım, 8 yıl saklama, kanuni faizle iade, md. 110 bağlantısı; **zorunlu pay alım teklifi (II-26.1)** — yönetim kontrolü (%50'den fazla oy / YK çoğunluğu imtiyazı), 6 iş günü, 2 ay, 10-20 iş günü, fiyat kuralı; **geri alınan paylar (II-22.1)** — program süresi 3 yıl/1 yıl, %10 nominal sınır, dağıtılabilir kaynak sınırı, kısıtlanmış yedek. Kelime sınırı için kâr payı avansı tablosu ve bazı ayrıntılar kısaltıldı.
- Mevcut eşikler (II-15.1 %5…%95; II-17.1 %5/%10; II-23.3 %75/%50) doğrulandı.
- **Terfi: evet.**

### SPM/SUC — Suçlar ve yaptırımlar
- Eklenen: **VI-103.1 yönetici net alım satım kazancı** (altı aylık dönem, LIFO, komisyon düşümü, 30 gün, 2 kat ceza, istisnalar) çözümlü örneği (2024/2 C4, 30 puan); md. 104–107 ayrımı; md. 111/2, 112, 113.
- **Olgu düzeltmesi:** md. 103/104'teki 20.000–250.000 / 500.000 TL tutarlarının kanuni (maktu) tutar olduğu ve Kabahatler Kanunu md. 17/7 gereği her yıl yeniden değerlendiği belirtildi; 2026 güncel tutarı kaynaklarda yok (uydurulmadı).
- Örtülü kazanç aktarımı başlığı HAO'ya eklendi (çapraz atıf). Tedrici tasfiye (md. 86) PAL konusudur.
- **Terfi: evet.**

### SPM/YKF — Yatırım kuruluşları ve kolektif yatırım
- Eklenen: aracı kurum kuruluş şartları (III-39.1 md. 5) ve kurucu şartları (md. 6); GYO yatırım sınırlamaları/yapamayacağı işler (III-48.1 md. 22) ve **borçlanma sınırı (md. 31, özkaynağın 5 katı, finansal kiralama ve gayrinakdi krediler dahil)** çözümlü örneği (2026/1 C3). Fon örneği kısaltıldı.
- Açık kalan: md. 46-47 teminatlar ve md. 56 portföy saklama, yatırımcı tazmini (md. 82-85) — müfredatta PAL konusuna taşınmış; PAL dosyası yok.
- Emin olunamayan: 2023/3 C2'de geçen "getiri garantisi ve ticari gayrimenkul alım satımı yasağı" kaynak metinde aranmadı, eklenmedi.
- **Terfi: evet.**

### SPM/IHR — İhraç ve halka arz
- Eklenen: **konut ve varlık finansmanı (SPKn md. 57-61/B)** tablosu (fonlar, teminatlı menkul kıymetler, ipotek finansmanı kuruluşu, kira sertifikası, gayrimenkul sertifikası, PDMK), koruma kuralı, "dayalı/teminatlı" ayrımı; **BASK** (md. 31/A: yarı nisap, nitelikli çoğunluk kararlarının bağlayıcılığı, temerrüt sonrası takiplerin durması) ve teminat yöneticisi ayrıntıları (metinden doğrulandı). İki önemsiz süre satırı ve tertip ihraç belgesi cümlesi kısaltıldı.
- **Terfi: evet.**

### SPM/GEN — SPKn genel hükümler ve Kurul
- Eklenen (yeni kazanım): **kanun kapsamına girme ve çıkma** — SPKn md. 16/1-3 (500 pay sahibi, kooperatif kontrolündeki ortaklık, 2 yıllık borsa başvurusu) ve II-16.1 çıkış yolları tablosu (genel kurul kararı nisabı, ortaklık yapısı, ortak sayısı, finansal büyüklük — tutarların yeniden değerlemesi, faaliyetin sona ermesi, resen çıkarma).
- **Terfi: evet.**

### SPM/DNT — Finansal raporlama ve bağımsız denetim
- Eklenen: II-14.1 md. 10 bildirim süreleri (60/70 gün, genel kuruldan 3 hafta önce, üçüncü ay sonu) ve alıntı.
- **Terfi: evet.**

---

## YNM

### YNM/BTC — Bütçeleme ve standart maliyet
- **Olgu hatası (cevap anahtarıyla çelişki) düzeltildi:** Varsayılan GÜG modeli "Türk modeli" idi (verimlilik × toplam oran; kapasite (NK − FS) × sabit oran). Resmî anahtarın kullandığı Anglosakson modeline çevrildi: verimlilik = (FS − SS) × değişken oran, kapasite = (NK − SS) × sabit oran; Türk modeli alternatif olarak kaldı. Örnek yeniden hesaplandı: harcama 5.000 A, verimlilik 3.000 A, kapasite 8.000 A (toplam 16.000); ikili ayrımla mutabakat gösterildi.
- Eklenen: **nakit bütçesi ve finansman ihtiyacı** çözümlü tablo (tahsilat/ödeme vadeleri, asgari kasa, 10.000'in katı borçlanma, faiz ve geri ödeme; 85.200 TL kapanış kasa), ticari mal alım bütçesi, bilinmeyeni geri bulma notu.
- Açık kalan: DBYM/711-721-731 yansıtma kayıtlarıyla sapma, ortalama maliyetle stok ve çok dönemli tablo (A6 madde 4-6) — kelime sınırı nedeniyle eklenmedi; MSS konusu (dosyası yok) için uygundur.
- **Terfi: evet** (asıl çelişki giderildi).

### YNM/KRV — Karar verme ve ilgili maliyetler
- Eklenen (en büyük açık): **ortak ürünlerde ayrılma noktası ve ek işlem kararı** çözümlü örneği ve **ayrılma noktasında kayıtsızlık fiyatı** (p = 22 TL; 2026/1, 30 puan); özel siparişte mevcut müşterilere indirim kaybı; üret/satın al nitel faktörler listesi ve adım sabit maliyet uyarısı.
- **Terfi: evet.**

### YNM/MHK — Maliyet hacim kâr analizi
- Hesaplar doğrulandı. Eklenen: "değişiklik olursa" senaryosu (yeni başabaş, güvenlik marjı, kaldıraç 13) ve ters çözümle fiyat bulma (≈203,08 TL).
- **Terfi: evet.**

### YNM/FDM, YNM/DEG, YNM/PRF
- Tüm sayısal örnekler yeniden hesaplandı ve doğru bulundu (FDM 300.000/300.000; DEG iki yıl toplamı 2.400.000, üçüncü yıl 870.000; PRF ROI %15 → %14,6, RI 130.000). PRF'de proje sonrası ROI paydası açıkça gösterildi. Olgu hatası yok.
- **Terfi: evet (üçü de).**

---

## Kapsam dışı kalan / hakeme not

1. **Dosyası olmayan müfredat konuları** (yaml'da var, klasörde .md yok; görev "yalnız mevcut dosyalar" olduğundan oluşturulmadı): IFM/KCV, IFM/MDV, IFM/STK, IFM/TAB; REV/IST, REV/ULU, REV/GEC; VTK/UGN, VTK/YRG, VTK/THS, VTK/DUZ, VTK/SRM; SPM/PAL; YNM/MSS. Çıkmış sınav raporlarına göre bunların çoğu yüksek ağırlıklıdır (ör. IFM KCV/MDV, REV IST/ULU, VTK YRG/THS); öncelikle yazılmaları gerekir.
2. **İdari görüşe dayanan ve hakemce teyit edilmesi önerilen cümleler:** konkordatoda alacaklı tarafı (REV/AKT, VTK/DEG), türev işlemlerde gerçekleşme esası (REV/GLR), karşılığın sonraki döneme kaydırılamaması (REV/AKT).
3. **Sınav anahtarı kaynaklı hesap kodları** (resmî THP'de boş/yok): 289, 489, 695, 696, 374, 163, 352, 156, 564-09 — metinde "ilave hesap" olarak açıkça belirtildi.
4. SPKn idari para cezalarının 2026 güncel alt/üst sınırları kaynak klasöründe yok; metinde kanuni tutar + yeniden değerleme kuralı verildi.
5. `yazar: Claude` alanları ve `durum: taslak` olduğu gibi bırakıldı.
