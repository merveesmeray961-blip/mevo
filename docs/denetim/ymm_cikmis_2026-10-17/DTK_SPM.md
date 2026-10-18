# YMM çıkmış sorular analizi: DTK (09) ve SPM (10), 2022/1–2026/1 (13 dönem)

Kaynak: `content/kaynaklar/cikmis/ymm/ymm_<YIL>_<DÖNEM>_09|10.txt` (26 dosya, hepsi okunabildi).
Yöntem: Her dosya "Cevap N" başlıklarına bölündü. Konu, ilk satırlardan ve puanlı cümlelerden çıkarıldı. Atıflar regex ile sayıldı, sonra elle kontrol edildi.

**Sınırlar (tahmin yürütülmedi):**
- 2022/1 ve 2022/2 dosyalarında yalnız cevap anahtarı var. Soru metni ve puan yok; bu iki dönemde her soruya 100/n puan varsayıldı.
- `ymm_2022_1_09` 4 cevap içeriyor. Sınavın gerçekten 4 soru olup olmadığı doğrulanamadı (önsöz yok).
- 4 soruluk sınavlar şunlar: 2023/3-09, 2024/2-09, 2026/1-09, 2025/2-10, 2025/3-10. 2025/3-10 önsözünde "4 sorudan oluşmaktadır" yazıyor.
- Puanlar şöyle elde edildi: soru metninde yazıyorsa oradan alındı. Yazmıyorsa cevap anahtarındaki "(x puan)" parantezleri toplandı ("≈" ile işaretli). Alt maddeler bazen çift sayıldığı için toplamlar 96–109 arasında çıkıyor; konu payları her sınav 100'e normalize edilerek hesaplandı.
- Bir soruya birden çok konu karışıyorsa **asıl** konu yazıldı, ikincil konu parantezde verildi.

---

## 1. Soru bazında döküm

### 1A. DTK – Dış Ticaret ve Kambiyo Mevzuatı (09)

| Dönem/Soru | Konu (tek satır) | Hukuki dayanak | Puan | yaml konu / kazanım |
|---|---|---|---|---|
| 2022/1 C1 | Tümüyle bir ülkede elde edilen eşya (menşe) | 4458 md. 18 | – | GMR / menşe |
| 2022/1 C2 | Uzlaşmanın kapsamı | 4458 md. 244 | – | VRG / gümrük cezaları ve uzlaşma |
| 2022/1 C3 | Kaçak akaryakıtın tasfiyesi | 5607 KMK md. 16/A | – | **YOK** (kaçakçılık/tasfiye) |
| 2022/1 C4 | Kıymetli madenler aracı kuruluşlarının yasakları | 32 s. Karar'a dayalı KMB Aracı Kuruluşları Yönetmeliği md. 13 | – | KMB (kıymetli maden kazanımı yok; zayıf) |
| 2022/2 C1 | Gümrük tarifesinin kapsamı | 4458 md. 15 | – | GMR / gümrük vergisi |
| 2022/2 C2 | "Gümrükçe onaylanmış işlem veya kullanım" ve ilgili hükümler | 4458 md. 3 (md. 46, 35/B atfı) | – | GMR / kapsam-tanımlar |
| 2022/2 C3 | Gümrük kıymetine dahil edilmeyen giderler | 4458 md. 28 | – | GMR / gümrük kıymeti |
| 2022/2 C4 | GTS tavizlerinin geri çekilme halleri | GTS'ye İlişkin Tebliğ (İthalat: 2022/6) md. 7 | – | **YOK** (ticaret politikası/tercihli tarife) |
| 2022/2 C5 | Dövize ilişkin işlemler, döviz ithali ve ihracı | 32 s. Karar md. 4, 5, 6 | – | KMB / genel esaslar, döviz ithal-ihracı |
| 2022/3 C1 | İthalatta menşe şahadetnamesi aranacak haller | Gümrük Yönetmeliği (GY) md. 38 | ≈10 | GMR / menşe |
| 2022/3 C2 | Royalti ve lisans ücretinin beyanı | Gümrük Genel Tebliği (Gümrük Kıymeti) Seri 2 md. 11; 4458 md. 241 | ≈25 | GMR / gümrük kıymeti |
| 2022/3 C3 | Dahilde işleme: tanım, şartlı muafiyet, geri ödeme | 4458 md. 108; GY | ≈24 | REJ / dahilde işleme |
| 2022/3 C4 | Geçici ithalat: tanım, azami 24 ay, olay, ceza | 4458 md. 128, 130/2; 2009/15481 BKK (5481); GY | ≈30 | REJ / geçici ithalat |
| 2022/3 C5 | İhracat bedellerinin yurda getirilmesi (süreler) | 32 s. Karar'a İlişkin Tebliğ 2018-32/48 md. 3, 5 | ≈15 | KMB / ihracat bedelleri |
| 2023/1 S1 | Süreler, süre uzatımı, mücbir sebep halleri | 4458 md. 14/1; GY md. 31 | 10 | **YOK** (yaml'da "süreler" yok) |
| 2023/1 S2 | Hesaplamalı olay: ithal demirde kıymet, vergi, yükümlülük doğuşu, sorumlular, fire | 4458 md. 24, 27, 28, 183; GY | 38 (18+7+7+3+3) | GMR / kıymet ve gümrük borcu |
| 2023/1 S3 | Gümrük yükümlülüğü doğmuş sayılmayan ihmaller | GY md. 486; 4458 | 17 | GMR / gümrük borcu |
| 2023/1 S4 | Vergilerin geri verilmesi ve kaldırılması | 4458 md. 211–215 | 20 | GMR / gümrük borcu (zayıf) |
| 2023/1 S5 | Doğru/yanlış: kıymetli maden, ziynet, döviz kredisi | 32 s. Karar md. 7, 17, 17/A; Tebliğ 2008-32/34; Harç İstisnası Tebliği (İhracat 2017/4); DİR Kararı | 15 | KMB |
| 2023/2 S1 | Fikri ve sınai haklarda alıkoyma ve işlemlerin durdurulması | 4458 md. 57; GY | 15 | **YOK** |
| 2023/2 S2 | Bölünmüş beyanname; sözlü beyan ve beyan sayılan haller | GY md. 121–122, 175–177 | 21 (10+11) | GMR / gümrük beyanı |
| 2023/2 S3 | Ulusal transit, eksiklik, sorumlular, kaçakçılık | 4458 md. 84, 92; GY; 5607 md. 3 | 40 (3+8+19+10) | REJ / transit (+YOK kaçakçılık) |
| 2023/2 S4 | Tahakkuk zamanaşımı ve vergilerin kesinleşmesi | 4458 md. 197, 198, 242, 244; GGT (Tahsilat İşlemleri) Seri 2; 2577 İYUK | 17 | GMR / gümrük borcu (zayıf) |
| 2023/2 S5 | Menkul kıymet alım satımı ve transferleri | 32 s. Karar md. 15 | 7 | KMB / sermaye hareketleri |
| 2023/3 C1 | Olay: özet beyan, boşaltma, eksiklik/fazlalık | 4458 md. 35/A-B, 237; GY md. 60–75 | ≈25 | GMR / beyan (özet beyan kazanımı yok) |
| 2023/3 C2 | Geri gelen eşyada muafiyet | 4458 md. 168–170; 2009/15481 BKK | ≈22 | REJ (kazanım yok; zayıf) |
| 2023/3 C3 | Gümrük kontrolü altında işleme olayı + ithalde KDV hesabı | 4458 md. 123–126; GY md. 361–375; GGT (GKAİ); 3065 KDVK md. 21 | ≈47 | REJ (+VRG ithalde KDV) |
| 2023/3 C4 | Kıymetli maden ve taşların yurt içi alım satımı | 32 s. Karar md. 7/4 | ≈15 | KMB |
| 2024/1 C1 | Tanımlar: kayıt yoluyla rejime geçiş, onaylanmış kişi vb.; menşe olayı | GY md. 3/1-d, n, r; 4458 md. 19–20 | ≈12 | GMR / tanımlar, menşe |
| 2024/1 C2 | İndirgeme yöntemi (Türkiye'deki satış birim fiyatı) | 4458 md. 25; GY | ≈18 | GMR / gümrük kıymeti |
| 2024/1 C3 | Ekonomik etkili rejimlerde ekonomik koşullar ve ticaret politikası önlemleri | GY md. 116, 149 vd. | ≈32 | REJ |
| 2024/1 C4 | Serbest bölgelerin tanımı ve eşyanın konulması | 4458 md. 152–155 | ≈18 | VRG / serbest bölgeler |
| 2024/1 C5 | İhracat sayılan satış ve teslimler | İhracat Sayılan Satış ve Teslimler Tebliği (İhracat: 2005/2) md. 5 | ≈20 | IHI / ihracat türleri (zayıf) |
| 2024/2 C1 | Menşe şahadetnamesinin aranmayacağı haller | GY md. 38–39; İthalat Rejimi Kararı | ≈10 | GMR / menşe |
| 2024/2 C2 | Büyük olay: yanlış GTİP, düzeltme, ceza, sorumluluk, zamanaşımı, KDV | 4458 md. 181–234, 241; GY; 6183; 3065; GGT (Gümrük İşlemleri) | ≈52 | GMR / beyan ve borç (+VRG cezalar) |
| 2024/2 C3 | Damping: normal değer, zarar, önlemler | 3577 s. Kanun; 99/13482 s. Karar; İHRÖ Yönetmeliği | ≈29 | **YOK** |
| 2024/2 C4 | Yurt içinden döviz kredisi temin halleri | 32 s. Karar md. 17/A-3 | ≈9 | KMB / sermaye hareketleri |
| 2024/3 C1 | Gümrük mevzuatına ilişkin kararlar, iptal ve değiştirme | 4458 md. 6–7; GY | ≈15 | **YOK** |
| 2024/3 C2 | İstisnai kıymetle beyan (basitleştirilmiş usul) | 4458 md. 23–24, 241; GY | ≈18 | GMR / gümrük kıymeti |
| 2024/3 C3 | Hariçte işleme: kapsam, izin şartları, hesap | 4458 md. 135–148; GY md. 402–414 | ≈48 | REJ / hariçte işleme |
| 2024/3 C4 | Serbest bölgeden AB'ye A.TR ile eşya gönderme | 4458 md. 152; GY md. 432 | ≈10 | VRG / serbest bölgeler (zayıf) |
| 2024/3 C5 | Dövize ilişkin işlemler ve yetkili kuruluşlar | 32 s. Karar md. 6 | ≈5 | KMB |
| 2025/1 C1 | Tanımlar: tercihli tarife, serbest dolaşım, zarar türleri, fikri hak ihlali eşyası | GY md. 3/1-a, 32/m; 5846 FSEK | ≈15 | GMR (+YOK damping/fikri) |
| 2025/1 C2 | Bilgi talebi; bağlayıcı tarife ve menşe bilgisi | 4458 md. 8–9 | ≈21 | GMR / menşe-tarife |
| 2025/1 C3 | Normal değer: piyasa ekonomisi uygulamayan ülkeler | İHRÖ Yönetmeliği md. 7–8 | ≈12 | **YOK** |
| 2025/1 C4 | Bölgedeki mallar; kambiyo ve hizmetler | 3218 SBK md. 8–9 | ≈16 | VRG / serbest bölgeler |
| 2025/1 C5 | Kişisel sermaye hareketleri; gayrinakdi krediler | 32 s. Karar md. 14, 18 | ≈16 | KMB / sermaye hareketleri |
| 2025/1 C6 | B grubu yetkili müesseselerin faaliyet konuları | Tebliğ 2018-32/45 md. 4 | ≈20 | KMB (yetkili müessese kazanımı yok) |
| 2025/2 C1 | Gümrük vergileri / ithalat vergileri tanımı ve ithalatta alınan vergiler | 4458 md. 3/8–10 | 20 | GMR (+VRG ithalde KDV/ÖTV) |
| 2025/2 C2 | Tasfiye usulleri ve imha | 4458 md. 177–178; Tasfiye Yönetmeliği md. 61 | 20 | **YOK** |
| 2025/2 C3 | Özelliği olan ihracatta bedel getirme süreleri | Tebliğ 2018-32/48 md. 5; İhracat Genelgesi | 20 | KMB / ihracat bedelleri |
| 2025/2 C4 | Tebliğ zamanaşımı ve ceza zamanaşımı | 4458 md. 197/2, 231, 235; 5326 Kabahatler | 20 | GMR / gümrük borcu (+VRG cezalar) |
| 2025/2 C5 | Kaçak akaryakıtın tasfiyesi (eski ve yeni metne verilen cevap da kabul edildi) | 5607 md. 16/A | 20 | **YOK** |
| 2025/3 C1 | Gümrük yükümlülüğünün sona ermesi | 4458 md. 208–209 | 12 | GMR / gümrük borcu |
| 2025/3 C2 | "Risk" ve "risk yönetimi" tanımları | 4458 md. 3/24–25 | 15 | **YOK** |
| 2025/3 C3 | Geri verme ve kaldırma (md. 210–217 tamamı) | 4458 md. 210–217 | 25 | GMR / gümrük borcu (zayıf) |
| 2025/3 C4 | Tercihli olmayan menşe | 4458 md. 17–21 | 20 | GMR / menşe |
| 2025/3 C5 | İthalatta ödeme şekilleri | İthalat Genelgesi (2020/1) md. 2 | 13 | IHI / ödeme yöntemleri |
| 2025/3 C6 | Yetkili müessese kuruluş şartları | Tebliğ 2018-32/45 md. 6 | 15 | KMB (kazanım yok) |
| 2026/1 C1 | Gümrük mevzuatına ilişkin kararlar | 4458 md. 6–7 | ≈34 | **YOK** |
| 2026/1 C2 | Süreler ve mücbir sebep halleri | 4458 md. 14 | ≈24 | **YOK** |
| 2026/1 C3 | Muafiyetler: yolcu, ev eşyası, hediyelik (430 €) | 4458 md. 167/5–6 | ≈22 | **YOK** (VRG'de yalnız 1 atıf) |
| 2026/1 C4 | Rafineri kuruluş izni şartları | Kıymetli Maden Standartları ve Rafinerileri Hakkında Tebliğ (2023/1) md. 7 | ≈20 | KMB (zayıf) |

### 1B. SPM – Sermaye Piyasası Mevzuatı (10)

| Dönem/Soru | Konu | Hukuki dayanak | Puan | yaml konu / kazanım |
|---|---|---|---|---|
| 2022/1 C1 | Portföy saklama hizmeti ve sorumluluk | SPKn md. 56 | – | YKF (saklama kazanımı yok) |
| 2022/1 C2 | Takas kesinliği ve rehin hakkı | SPKn md. 79 | – | **YOK** (piyasa altyapısı) |
| 2022/1 C3 | Bilgi suistimali failleri | SPKn md. 106 | – | SUC / bilgi suistimali |
| 2022/1 C4 | Halka arza aracılık | III-37.1 md. 51 | – | YKF / yatırım hizmetleri |
| 2022/1 C5 | Kanun kapsamından çıkarılma şartları | II-16.1 md. 6 (cevapta numara yok, yalnız adı) | – | HAO (kazanım yok) |
| 2022/2 C1 | Teminat sözleşmeleri; temerrütte teminattan alacağın karşılanması | SPKn md. 47/4 | – | YKF (zayıf) |
| 2022/2 C2 | Bağımsız denetim kuruluşlarının sorumluluğu | SPKn md. 63–64 | – | DNT / bağımsız denetim |
| 2022/2 C3 | Mali durumun bozulmasında tedbirler | SPKn md. 97 | – | SUC / tedbirler |
| 2022/2 C4 | Kredili alımda özel işlem sınırı | Kredili Alım, Açığa Satış ve Ödünç İşlemleri Tebliği md. 8 (numara cevapta yok) | – | **YOK** |
| 2022/2 C5 | İlk halka arzda aracı kurumun yüklenimi | Pay Tebliği (VII-128.1) md. 5/7 | – | IHR / satış yöntemleri |
| 2022/3 C1 | İhraç tanımı; izahnameye aykırılıkta Kurul yetkileri | SPKn md. 3/1-ğ, 11, 91 | ≈20 | IHR / izahname |
| 2022/3 C2 | Kayıtlı sermaye sistemi | SPKn md. 3/1-l, 18; II-18.1; TTK | ≈20 | HAO / kayıtlı sermaye |
| 2022/3 C3 | Yatırım ortaklıkları | SPKn md. 48–51 | ≈15 | YKF |
| 2022/3 C4 | Geri alınan paylar | II-22.1 md. 4, 6, 8, 10 | ≈30 | HAO (kazanım yok) |
| 2022/3 C5 | Kitle fonlaması | SPKn md. 3/1-z; III-35/A.2 | ≈15 | YKF / kitle fonlaması |
| 2023/1 S1 | İpotekli SPA tanımı; satış işlemleri esasları | SPKn md. 3/1-i, 12; II-5.2; TTK | 15 (3+12) | IHR |
| 2023/1 S2 | Örtülü kazanç aktarımı olayı: idari tedbir ve ceza | SPKn md. 21, 92, 94, 110, 115 | 25 (15+10) | HAO (kazanım yok; +SUC) |
| 2023/1 S3 | Borçlanma aracı ihraç limiti hesabı; paya dönüştürülebilir tahvil | VII-128.8 md. 9, 17–22 | 30 | IHR / borçlanma araçları |
| 2023/1 S4 | Birleşmenin yapılamayacağı haller | II-23.2 md. 12 | 15 | HAO / birleşme |
| 2023/1 S5 | Kotasyon; tek fiyat ve çok fiyat yöntemleri | BİST Borsacılık Faaliyetlerine İlişkin Esaslar Yönetmeliği md. 4/1-l, 31, 39 | 15 (4+5+…) | **YOK** |
| 2023/2 C1 | Tasarruf finansman şirketinin ortak sayısı 550'ye çıkınca halka açık sayılması | SPKn md. 1–4, 16, 32–40; VII-128.1 | ≈26 | HAO (+GEN) |
| 2023/2 C2 | Pay alım teklifi zorunluluğu | SPKn md. 26; II-26.1 | ≈12 | **YOK** |
| 2023/2 C3 | Proje finansmanı ve PDMK | SPKn md. 61/B (cevapta); III-61/B.1 | ≈22 | IHR (zayıf) |
| 2023/2 C4 | GYO'da mali durumun bozulması; finansal raporlama ve kamuya açıklama | II-14.1; SPKn md. 97 | ≈25 | DNT / finansal raporlama |
| 2023/2 C5 | İzinsiz yatırım danışmanlığı: dava, erişim engeli, ceza | SPKn md. 96, 99, 109, 115 | ≈15 | SUC |
| 2023/3 C1 | Teminat yönetim sözleşmesi ve teminat yöneticisi | SPKn md. 31/B; II-31/B.1 | ≈20 | IHR / borçlanma araçları (zayıf) |
| 2023/3 C2 | Aracı kurum kuruluş şartları ve yasaklar | SPKn md. 37–43; III-39.1 | ≈25 | YKF |
| 2023/3 C3 | Finansal tablo sorumluluğu ve bağımsız denetim sorumluluğu | SPKn md. 14, 63; Seri X No 22 | ≈30 | DNT |
| 2023/3 C4 | Yatırımcı tazmini ve sorumlular | SPKn md. 82–85 | ≈14 | **YOK** |
| 2023/3 C5 | Yabancı SPA'nın halka arz ön şartları | VII-128.4 md. 5 | ≈11 | IHR |
| 2024/1 C1 | Kooperatif kontrolündeki AO; ilişkili taraf işlemleri ve KAP | SPKn md. 16–17; II-17.1; II-16.2; 1163 s. K. | ≈21 | HAO / kurumsal yönetim |
| 2024/1 C2 | Sermaye piyasası kurumları; bankalar ve halka açık ortaklıkların konumu | SPKn md. 1–3, 35–39 | ≈15 | GEN / sermaye piyasası kurumları |
| 2024/1 C3 | Kâr payı hesabı (imtiyazlı paylar, stopaj) | II-19.1; TTK md. 519; VUK; KVK | ≈25 | HAO / kâr payı |
| 2024/1 C4 | Piyasa bozucu eylem mi, piyasa dolandırıcılığı mı; tedbirler | SPKn md. 101, 104, 107, 114; V-101.1 | ≈17 | SUC |
| 2024/1 C5 | İçsel bilgi açıklama ve erteleme | II-15.1 md. 5–6; SPKn md. 15 | ≈22 | HAO / özel durumlar |
| 2024/2 C1 | Menkul kıymet, türev araç vb. tanımları | SPKn md. 3/1-o, u, bb | ≈12 | GEN / tanımlar |
| 2024/2 C2 | Kripto varlık SPA mı; kaydileştirme | SPKn md. 13, 35/B–C, 99/B | ≈15 | YKF / kripto |
| 2024/2 C3 | Merkezî karşı taraf | SPKn md. 73, 78, 79 | ≈28 | **YOK** |
| 2024/2 C4 | Yöneticilerin net alım satım kazancı hesabı ve ceza | VI-103.1 md. 5–6; SPKn md. 103 | ≈30 | SUC (zayıf) |
| 2024/2 C5 | Kripto varlık hizmet sağlayıcılarda zimmet | SPKn md. 110/A | ≈15 | SUC |
| 2024/3 C1 | SPA'nın kaydileştirilmesi | SPKn md. 13 | ≈12 | **YOK** |
| 2024/3 C2 | Yatırım hizmetleri ve faaliyetleri; yetkilendirme | SPKn md. 37, 39 | ≈22 | YKF |
| 2024/3 C3 | İpotek ve varlık teminatlı menkul kıymetler | SPKn md. 59 | ≈9 | **YOK** |
| 2024/3 C4 | İlk halka arz olayı: özkaynak, sermaye ve ilişkili taraf alacakları şartları | VII-128.1; II-16.1; VUK md. 298 | ≈49 | IHR |
| 2024/3 C5 | Suç türlerini sayma ve olay değerlendirmesi | SPKn md. 104, 106–113 | ≈12 | SUC |
| 2025/1 S1 | Borçlanma aracı sahipleri kurulu (BASK) | SPKn md. 31/A; II-31/A.1 | 22 | IHR / borçlanma araçları (zayıf) |
| 2025/1 S2 | Bankanın portföy şirketi fonu üzerinden örtülü kazanç aktarımı | SPKn md. 21, 52–56, 103, 110 | 28 (21+7) | HAO (kazanım yok; +YKF) |
| 2025/1 S3 | Teminatlar, yatırımcı varlıkları ve kullanım esasları | SPKn md. 46 | 15 | YKF (zayıf) |
| 2025/1 S4 | Talep toplama yoluyla satış | II-5.2 | 20 | IHR / satış yöntemleri |
| 2025/1 S5 | Yönetici işlemi: bilgi suistimali ve piyasa bozucu eylem değerlendirmesi | SPKn md. 104, 106, 107 | 15 | SUC |
| 2025/2 C1 | İzahname ve ihraç belgesi hazırlama yükümlülüğü | SPKn md. 4–6, 10–11; II-5.1 | ≈23 | IHR / izahname |
| 2025/2 C2 | Kripto varlık hizmet sağlayıcı faaliyetleri, transfer ve saklama | SPKn md. 35/C | ≈24 | YKF / kripto |
| 2025/2 C3 | Yatırımcı tazmini olayı (aracı kurum, MKYO, faktoring) | SPKn md. 82–85; III-39.1; III-37.1; III-48.5 | ≈30 | **YOK** |
| 2025/2 C4 | Birleşme hesabı: düzeltilmiş özkaynak, birleşme oranı, pay adedi | II-23.2; II-23.3; II-17.1 | ≈23 | HAO / birleşme |
| 2025/3 S1 | Ayrılma hakkı ve kullanım fiyatı hesabı | SPKn md. 23–24; II-23.3 | 33 (15+18) | HAO / önemli işlemler ve ayrılma hakkı |
| 2025/3 S2 | Portföy saklama hizmeti ve sorumluluk | SPKn md. 56 | 21 | YKF (zayıf) |
| 2025/3 S3 | Borsaların kuruluşu, faaliyet ve yönetimi | SPKn md. 65 vd.; Borsalar ve Piyasa İşleticileri Yönetmeliği; BİST Borsacılık Yönetmeliği | 35 (23+12) | **YOK** |
| 2025/3 S4 | Güveni kötüye kullanma ve sahtecilik | SPKn md. 110; TCK md. 155 | 11 | SUC |
| 2026/1 C1 | Yatırım ortaklıkları: tanım, kuruluş ve faaliyet şartları | SPKn md. 48 | ≈17 | YKF |
| 2026/1 C2 | Konut ve varlık finansmanı | SPKn md. 57 | ≈12 | **YOK** |
| 2026/1 C3 | GYO'nun yapamayacağı işler; kredi limiti hesabı | III-48.1; VII-128.8 | ≈34 | YKF / GYO |
| 2026/1 C4 | Tedricî tasfiye | SPKn md. 86; İİK | ≈27 | **YOK** |
| 2026/1 C5 | Kurul başkan, üye ve personelinin sorumluluğu | SPKn md. 133 | ≈9 | GEN |

---

## 2. Frekans tablosu ve ağırlık karşılaştırması

Puan payı, her sınav 100'e normalize edilerek 13 dönem (1300 puan) üzerinden hesaplandı.

### DTK (63 soru)

| yaml konu | Soru | ≈Puan / 1300 | Gerçek pay | yaml `agirlik` | Değerlendirme |
|---|---|---|---|---|---|
| GMR Gümrük mevzuatı temelleri | 24 | 498 | **%38** | 22 | **Çok düşük kalmış** |
| (YOK – yaml dışı) | 13 | 262 | **%20** | – | Yeni konu gerekli |
| REJ Gümrük rejimleri | 7 | 237 | %18 | 20 | Uygun |
| KMB Kambiyo mevzuatı | 13 | 200 | %15 | 24 | Soru sayısı yüksek ama puanı düşük; ağırlık fazla |
| VRG Dış ticaretin vergisel boyutu | 4 (+3 ikincil) | 69 | %5 (ikincillerle ≈%8) | 18 | **Fazla** |
| IHI İhracat ve ithalat işlemleri | 2 | 33 | %3 | 16 | **Çok fazla** |

### SPM (63 soru)

| yaml konu | Soru | ≈Puan / 1300 | Gerçek pay | yaml `agirlik` | Değerlendirme |
|---|---|---|---|---|---|
| HAO Halka açık ortaklıklar | 12 | 288 | %22 | 22 | Uygun |
| YKF Yatırım kuruluşları ve kolektif yatırım | 13 | 263 | %20 | 18 | Uygun / az artırılabilir |
| IHR İhraç ve halka arz | 11 | 250 | %19 | 18 | Uygun |
| (YOK – yaml dışı) | 12 | 234 | **%18** | – | Yeni konu gerekli |
| SUC Suçlar ve yaptırımlar | 9 | 155 | %12 | 16 | Biraz fazla |
| DNT Finansal raporlama ve bağımsız denetim | 3 | 75 | %6 | 12 | Fazla |
| GEN SPKn genel hükümler ve Kurul | 3 | 36 | %3 | 14 | **Çok fazla** (yalnız tanımlar sorulmuş) |

---

## 3. Sorulan ama yaml'da olmayan veya zayıf kapsanan konular

### DTK

1. **Gümrük Kanunu genel hükümleri (md. 6–9, 14)** – 5 soru, ≈108 puan.
   - Kararlar: 2024/3 C1, 2026/1 C1.
   - Süreler ve mücbir sebep: 2023/1 S1, 2026/1 C2.
   - Bilgi ve bağlayıcı bilgi: 2025/1 C2.
   - Öneri: GMR'ye "kişilerin hak ve yükümlülükleri: kararlar, bilgi, süreler" kazanımı eklenmeli.
2. **Geri verme / kaldırma (md. 210–217) ile zamanaşımı ve kesinleşme (md. 197, 231, 235)** – 2023/1 S4, 2023/2 S4, 2025/2 C4, 2025/3 C3, 2024/2 C2. Toplam ≈90+ puan. yaml'da yalnız "gümrük borcu" var; bu başlıklar ayrı kazanım olmalı.
3. **Tasfiye ve kaçakçılık (4458 md. 177–178, Tasfiye Yönetmeliği, 5607 md. 16/A)** – 2022/1 C3, 2025/2 C2, 2025/2 C5; 2023/2 S3 içinde de var. yaml'da hiç yok.
4. **Ticaret politikası önlemleri (3577 damping/sübvansiyon, İHRÖ Yönetmeliği, GTS)** – 2024/2 C3, 2025/1 C3, 2022/2 C4; 2025/1 C1'de kısmen. yaml'da yok.
5. **Gümrük Yönetmeliği ayrıntıları** – menşe şahadetnamesi aranan ve aranmayan haller (2022/3 C1, 2024/2 C1), indirgeme yöntemi (2024/1 C2), istisnai kıymetle beyan (2024/3 C2), bölünmüş beyanname (2023/2 S2), özet beyan (2023/3 C1), gümrük yükümlülüğü doğurmayan ihmaller (2023/1 S3). yaml `kaynak_dosyalari` içinde Gümrük Yönetmeliği yok.
6. **Muafiyetler (4458 md. 167–170)** – kişisel eşya, ev eşyası ve hediyelik (2026/1 C3); geri gelen eşya (2023/3 C2). yaml'da yok.
7. **Fikri mülkiyet önlemleri (md. 57)** – 2023/2 S1; **risk ve risk yönetimi (md. 3/24–25)** – 2025/3 C2.
8. **KMB'de kazanımı olmayan alanlar:**
   - Yetkili müesseseler (Tebliğ 2018-32/45): 2025/1 C6, 2025/3 C6.
   - Kıymetli madenler, aracı kuruluşlar ve rafineriler: 2022/1 C4, 2023/3 C4, 2026/1 C4, 2023/1 S5.
   - Dövize ilişkin işlemler (md. 6): 2022/2 C5, 2024/3 C5.
   - Yurt içi döviz kredisi (md. 17/A): 2024/2 C4.
   - Gayrinakdi krediler (md. 18): 2025/1 C5.
9. **Serbest bölgeler** VRG altında tek kazanım olarak duruyor, ama 3 soru tek başına bu konuya ayrılmış (2024/1 C4, 2024/3 C4, 2025/1 C4).

### SPM

1. **Piyasa altyapısı** (takas kesinliği md. 79, merkezî karşı taraf md. 78, kaydileştirme md. 13, borsalar md. 65 vd., BİST Borsacılık Yönetmeliği) – 2022/1 C2, 2024/2 C3, 2024/3 C1, 2024/2 C2 (kısmen), 2023/1 S5, 2025/3 S3. Toplam ≈110 puan. yaml'da yok.
2. **Yatırımcı tazmini ve tedricî tasfiye (md. 82–86, 97)** – 2023/3 C4, 2025/2 C3, 2026/1 C4, 2022/2 C3. Toplam ≈90 puan. yaml'da yok (SUC'ta yalnız "tedbirler" var).
3. **Örtülü kazanç aktarımı (md. 21)** – 2023/1 S2 ve 2025/1 S2: iki büyük olay sorusu, ≈53 puan. HAO kazanımlarında yok; HAO.md'de yalnız 1 atıf var.
4. **Konut ve varlık finansmanı, ipotek ve varlık teminatlı menkul kıymetler, PDMK (md. 57–61/B)** – 2026/1 C2, 2024/3 C3, 2023/2 C3, 2023/1 S1-a.
5. **Borçlanma aracı sahipleri kurulu ve teminat yönetimi (md. 31/A–31/B)** – 2025/1 S1, 2023/3 C1. IHR "borçlanma araçları" kazanımı var ama bu iki kurum ayrıca yazılmalı.
6. **Pay alım teklifi (II-26.1)** – 2023/2 C2; **geri alınan paylar (II-22.1)** – 2022/3 C4; **kanun kapsamından çıkma ve halka açık sayılma (md. 16, II-16.1)** – 2022/1 C5, 2023/2 C1, 2024/3 C4.
7. **Portföy saklama (md. 56) ve teminatlar/yatırımcı varlıkları (md. 46–47)** – 2022/1 C1, 2025/3 S2, 2025/1 S3, 2022/2 C1.
8. **Yöneticilerin net alım satım kazancı (VI-103.1)** – 2024/2 C4, 30 puanlık hesaplama sorusu.
9. **Yatırım kuruluşları kuruluş şartları (III-39.1)** ve **yabancı SPA (VII-128.4)** – 2023/3 C2, C5.

---

## 4. Hiç sorulmamış yaml kazanımları (ağırlığı düşürmeye aday)

### DTK
- **IHI:** teslim şekilleri (Incoterms); akreditif ve ödeme yöntemleri yalnız 2025/3 C5'te bir genelge maddesi olarak çıkmış; "ithalat işlemleri" genel olarak hiç sorulmamış.
- **KMB:** "döviz cinsinden sözleşme yasağı ve istisnaları" hiç sorulmamış. Kambiyo derslerinde en çok bilinen konu olmasına rağmen çıkmamış.
- **VRG:** "ihracat istisnası ve iadesi (KDV)" hiç sorulmamış. "İthalde ÖTV" doğrudan hiç sorulmamış; ithalde KDV yalnız 2023/3 C3'te hesap olarak çıkmış.
- **REJ:** antrepo rejimi ve ihracat rejimi doğrudan sorulmamış. Serbest dolaşıma giriş yalnız menşe şahadetnamesi bağlamında çıkmış.

### SPM
- **GEN:** "Kurulun görev ve yetkileri" doğrudan sorulmamış; yalnız md. 133 (sorumluluk) çıkmış.
- **DNT:** değerleme kuruluşları hiç sorulmamış.
- **IHR:** "izahnameden sorumluluk" ayrı soru olarak çıkmamış; yalnız 2025/2 C1 içinde değinilmiş.
- **YKF:** yatırım fonları (III-52.1) doğrudan sorulmamış; yalnız 2025/1 S2'de olay zemini olarak var.
- **HAO:** kurumsal yönetim yalnız 2024/1 C1'de ilişkili taraf boyutuyla çıkmış.

---

## 5. Cevap anahtarlarında atıf yapılan mevzuat ve klasördeki durumu

Sayı = o mevzuata atıf yapan cevap sayısı. ✓ = `content/kaynaklar/mevzuat` içinde var, ✗ = yok.

### DTK

| Mevzuat | Cevap sayısı | Klasörde |
|---|---|---|
| 4458 sayılı Gümrük Kanunu | ≈44 | ✓ `gumruk.txt` |
| **Gümrük Yönetmeliği** | ≈26 | ✗ **en kritik eksik** |
| Türk Parası Kıymetini Koruma Hakkında 32 Sayılı Karar | ≈14 | ✓ `tpkk_32.txt` |
| 2009/15481 s. BKK (Gümrük Kanununun Bazı Maddelerinin Uygulanması) | 5 | ✗ |
| 5607 s. Kaçakçılıkla Mücadele Kanunu | 5 | ✗ |
| 6183 s. AATUHK | 5 | ✓ `aatuhk.txt` |
| 3065 s. KDVK | 2 | ✓ `kdvk.txt` |
| Tebliğ 2018-32/48 (İhracat Bedelleri) | 2 | ✗ |
| Tebliğ 2018-32/45 (Yetkili Müesseseler) | 2 | ✗ |
| İthalatta Haksız Rekabetin Önlenmesi Hakkında Yönetmelik | 2 | ✗ |
| 5411 s. Bankacılık Kanunu | 2 | ✗ |
| Tebliğ 2008-32/34 | 1 | ✗ |
| İhracat Genelgesi | 1 | ✗ |
| İthalat Genelgesi (2020/1) | 1 | ✗ |
| KMB Aracı Kuruluşları Faaliyet Esasları … Yönetmeliği | 1 | ✗ |
| Kıymetli Maden Standartları ve Rafinerileri Tebliği (2023/1) | 1 | ✗ |
| Gümrük İdaresince Tasfiye … Yönetmeliği | 1 | ✗ |
| 3577 s. Kanun ve 99/13482 s. Karar (İthalatta haksız rekabet) | 1 + 1 | ✗ |
| 3218 s. Serbest Bölgeler Kanunu | 1 | ✗ |
| GGT (Gümrük Kıymeti) Seri 2 | 1 | ✗ |
| GGT (Tahsilat İşlemleri) Seri 2 | 1 | ✗ |
| GGT (Gümrük Kontrolü Altında İşleme) | 1 | ✗ |
| GGT (Gümrük İşlemleri) | 1 | ✗ |
| GTS'ye İlişkin Tebliğ (İthalat 2022/6) | 1 | ✗ |
| İthalat Rejimi Kararı | 1 | ✗ |
| Dahilde İşleme Rejimi Kararı | 1 | ✗ |
| İhracat Sayılan Satış ve Teslimler Tebliği (İhracat 2005/2) | 1 | ✗ |
| Harç İstisnası Tebliği (İhracat 2017/4) | 1 | ✗ |
| 5326 Kabahatler Kanunu | 1 | ✓ `kabahatler.txt` |
| 2577 İYUK | 1 | ✓ `iyuk.txt` |
| 5846 FSEK | 1 | ✗ |
| 4734 KİK | 1 | ✗ |
| 2886 DİK | 1 | ✗ |

- 3812, 8391 ve 6833 sayılı kararlar (2023/1 S5) cevapta numara olarak geçiyor. Bunlar büyük olasılıkla 32 s. Karar değişiklik kararları, ancak bu doğrulanmadı.

### SPM

| Mevzuat | Cevap sayısı | Klasörde |
|---|---|---|
| 6362 SPKn | ≈56 | ✓ `spkn.txt` |
| 6102 TTK | 5 | ✓ `ttk.txt` |
| 5411 Bankacılık Kanunu | 4 | ✗ |
| VII-128.1 Pay Tebliği | 3 | ✓ |
| II-5.2 Satış Tebliği | 2 | ✓ |
| II-23.2 Birleşme ve Bölünme | 2 | ✓ |
| II-23.3 Önemli Nitelikteki İşlemler | 2 | ✓ |
| II-17.1 Kurumsal Yönetim | 2 | ✓ |
| III-37.1 Yatırım Hizmetleri | 2 | ✓ |
| II-5.1 İzahname | 1 | ✓ |
| II-15.1 Özel Durumlar | 1 | ✓ |
| II-18.1 Kayıtlı Sermaye | 1 | ✓ |
| II-19.1 Kâr Payı | 1 | ✓ |
| III-35/A.2 Kitle Fonlaması | 1 | ✓ |
| III-48.1 GYO | 1 | ✓ |
| **VII-128.8 Borçlanma Araçları** | 2 | ✗ |
| **III-39.1 Yatırım Kuruluşları** | 2 | ✗ |
| II-16.1 (Kapsamdan Çıkarma / Borsada İşlem Görme Zorunluluğu) | 2 | ✗ |
| II-14.1 Finansal Raporlama | 1 | ✗ |
| BİST Borsacılık Faaliyetlerine İlişkin Esaslar Yönetmeliği | 2 | ✗ |
| Borsalar ve Piyasa İşleticileri Yönetmeliği | 1 | ✗ |
| II-22.1 Geri Alınan Paylar | 1 | ✗ |
| II-26.1 Pay Alım Teklifi | 1 | ✗ |
| III-61/B.1 PDMK | 1 | ✗ |
| II-31/A.1 BASK | 1 | ✗ |
| II-31/B.1 Teminat Yönetimi | 1 | ✗ |
| Seri X No 22 Bağımsız Denetim Standartları | 1 | ✗ |
| VII-128.4 Yabancı SPA | 1 | ✗ |
| II-16.2 Kooperatif kontrolündeki AO | 1 | ✗ |
| V-101.1 Tedbirler | 1 | ✗ |
| VI-103.1 Yönetici Net Kazanç | 1 | ✗ |
| III-48.5 MKYO | 1 | ✗ |
| Kredili Alım ve Açığa Satış Tebliği | 1 | ✗ |
| 213 VUK | 2 | ✓ |
| 5520 KVK | 3 | ✓ |
| 3065 KDVK | 1 | ✓ |
| 2004 İİK | 2 | ✓ `iik.txt` |
| 5237 TCK | 1 | ✓ |
| 4721 TMK | 1 | ✓ |
| 4857 İş K. | 1 | ✓ `isk.txt` |
| 6183 AATUHK | 1 | ✓ |
| 5684 Sigortacılık Kanunu | 1 | ✗ |
| 1163 Kooperatifler Kanunu | 1 | ✗ |

- `spk_iii_35b_*` (kripto) ve `spk_iii_52_1` (fonlar) klasörde var, ancak cevaplarda numarayla atıf yok.
- Seri X No 22'nin güncelliği ayrıca kontrol edilmeli.

**Ekleme önceliği:**
- DTK: Gümrük Yönetmeliği; 5607; 2009/15481 BKK; 2018-32/48; 2018-32/45; 3218; İthalatta haksız rekabet mevzuatı (Kanun + Karar + Yönetmelik); Tasfiye Yönetmeliği; İhracat ve İthalat Genelgeleri.
- SPM: VII-128.8; III-39.1; II-16.1; II-14.1; II-26.1; II-22.1; II-31/A.1; BİST Borsacılık Yönetmeliği; VI-103.1; III-61/B.1; Yatırımcı tazmini ve tedricî tasfiye yönetmeliği. Bu sonuncusuna cevaplarda adıyla atıf yok; SPKn md. 82–86 yönetmeliğe yollama yapıyor.

---

## 6. Soru üslubu (gerçekçi pratik soru yazmak için)

- **Biçim:** 2 saatlik klasik sınav, 4–6 soru, toplam 100 puan. Her soruya 7–40 puan arası verilmiş; tipik soru 15–25 puan.
  - Önsözde standart uyarılar var.
  - Önsözde "isimler hayal ürünüdür" açıklaması yer alıyor.
- **Soru kökü kalıbı:** "4458 Sayılı Gümrük Kanunu ve Kanunun verdiği yetki dâhilinde yayımlanan Gümrük Yönetmeliği hükümleri kapsamında; … açıklayınız." Kalıbın SPM karşılığı: "6362 sayılı SPKn ve Kanunun verdiği yetki dahilinde yayımlanan … Tebliği (II-x.y) kapsamında …".
  - Sorular çoğunlukla a-, b-, c- bentlerine bölünmüş. Her bendin puanı parantez içinde veriliyor.
  - Fiiller: "tanımlayınız", "açıklayınız", "belirtiniz", "değerlendiriniz", "yapılması gerekenleri açıklayınız".
- **Üç soru tipi:**
  1. **Madde aktarımı ve sayma** (çoğunluk). Adaydan bir maddenin bentlerini eksiksiz yazması bekleniyor. Puan her bent veya cümle için ayrı veriliyor (0,5–4 puan). Örnek kural: "her bir bent 0,75 puan".
     - 2025 ve sonrasında DTK cevapları neredeyse tamamen "madde hükmü aşağıda yer almaktadır" biçiminde, yani maddenin aynen aktarımı.
  2. **Olay (vaka) soruları.** Kurgusal şirketler kullanılıyor (Doruk, Merkür, Yakamoz, Gökyüzü, Zirve, Günışığı). Gerçekçi veriler veriliyor: GTİP kodu, ton, USD/kg, kur, tarih, gümrük idaresi adı, ortaklık oranı, bilanço kalemleri.
     - Hesaplamalar, DTK: gümrük kıymeti, gümrük vergisi, ithalde KDV.
     - Hesaplamalar, SPM: borçlanma aracı ihraç limiti, kâr payı ve stopaj, birleşme oranı ve verilecek pay adedi, ayrılma hakkı fiyatı ve pay adedi, VI-103.1 net kazancı ve "menfaatin 2 katı" idari para cezası, GYO kredi limiti, halka arzda özkaynak ve sermaye şartları.
     - Suç ve eylem nitelendirmesi de isteniyor: piyasa bozucu eylem mi, işlem bazlı mı bilgi bazlı mı, bilgi suistimali mi; ceza aralığı ve etkin pişmanlık indirimi.
  3. **Doğru/yanlış/eksik değerlendirmesi** (2023/1 S5). Birkaç ifade veriliyor; aday her birinin neden yanlış olduğunu ve doğrusunu yazıyor. Her ifade 1–2 puan.
- **Cevap anahtarı üslubu:**
  - Önce soruyu yeniden ifade ediyor ("… açıklanması istenmiştir").
  - Sonra madde numarasını ve başlığını veriyor, metni tırnak içinde aktarıyor.
  - Olay sorularında "Örnek olayda …" diye başlayıp adım adım gerekçeli sonuç yazıyor ve her sonuç cümlesine puan bağlıyor.
  - Alternatif doğru cevaplar açıkça kabul ediliyor (2025/2-09 C5: eski ve yeni metin; 2025/1-10 C5 ve 2024/1-10'da da benzer notlar var). 2024/1-10 için cevap anahtarı sonradan güncellenmiş (23.07.2024).
- **Kapsam:** Kanun maddesinin yanında ikincil mevzuat (yönetmelik, tebliğ, genelge) ve bu metinlerdeki sayısal eşikler doğrudan soruluyor. Örnekler: 180/365/90 gün, 430 €, 5 milyon TL ve 35 milyon TL sermaye, bağlayıcı tarife bilgisinde 6 yıl ve menşe bilgisinde 3 yıl, 24 ay.
  - Yakın tarihli değişiklikler soruluyor: kripto md. 35/B–C ve 110/A, 2023 rafineri tebliği.
- **Pratik soru önerisi:**
  - Her soru 2–4 bent olsun. Bir bent "sayınız", bir bent "olaya uygulayınız/hesaplayınız" biçiminde olsun.
  - Cevapta madde numarası ve bent bazında puan dağılımı verilsin.
  - Kurgusal şirket adları ve gerçekçi rakamlar kullanılsın.

---

## 7. Anlatım dosyalarının kontrolü (ders başına 2 dosya)

### DTK/GMR.md (en çok sorulan konu, %38)

**İyi kapsanan:** md. 3 tanımları, md. 15 tarife, md. 24–28 kıymet ve eklenen/eklenmeyen unsurlar, md. 17–22 menşe, md. 9/4 bağlayıcı bilgi süreleri, md. 181–198 ve 208 gümrük borcunun ana hatları.

**Somut eksikler:**
- md. 6–7 **kararlar** ve md. 14 **süreler, mücbir sebep listesi** yok. Bunlar 4 soru, ≈83 puan.
- md. 8 bilgi talebi yalnız dolaylı geçiyor.
- **Geri verme ve kaldırma** (md. 210–217) tek cümle (md. 211/2). Sınav maddenin tamamını istiyor (2023/1 S4, 2025/3 C3).
- **Zamanaşımı ve kesinleşme** hiç yok: "zamanaşımı" ve "kesinleş" araması 0 sonuç veriyor. md. 197'nin dava durdurma etkisi ve kesinleşme halleri eksik.
- md. 208'in yanında md. 209 eksik.
- **Gümrük Yönetmeliği hükümleri yok:**
  - Menşe şahadetnamesi aranacak ve aranmayacak haller (GY md. 38–39).
  - Kıymet yöntemleri anlatılmış, ama sorulan uygulama ayrıntıları yok: indirgeme yöntemi ayrıntısı, istisnai kıymetle beyan, royalti beyanı.
  - Bölünmüş beyanname, özet beyan eksiklik/fazlalık, yükümlülük doğurmayan ihmaller.
- md. 57 fikri mülkiyet, md. 3/24–25 risk ve md. 167 muafiyetler yok.

### DTK/KMB.md (%15, 13 soru)

**İyi kapsanan:** md. 2 tanımlar, md. 3–4 döviz/TL ithal-ihracı, md. 7 kıymetli maden ve ziynet, md. 12–17 sermaye hareketleri, md. 17/4 örneği.

**Somut eksikler:**
- Ders "ihracat bedeli süresi Karar'da yok, kaynaklarda yer almaz" diyor. Oysa sınav **Tebliğ 2018-32/48 md. 3 ve 5**'teki süreleri iki kez sordu (2022/3 C5, 2025/2 C3): 180 gün, müteahhit 365 gün, konsinye 90 gün, vadeli ihracat vb. Ders bu haliyle sınavda yanlış yönlendirir.
- **Yetkili müesseseler** (2018-32/45 md. 4 faaliyet konuları, md. 6 kuruluş şartları) yok; 2 soru, ≈35 puan.
- **md. 17/A-3 yurt içi döviz kredisi halleri** listesi yok; yalnız 17/A-10'a değiniliyor.
- **md. 18 gayrinakdi krediler** ve **md. 6 dövize ilişkin işlemler** ayrıntısı (yetkili müessese, efektif devri) zayıf.
- Kıymetli maden alanında üç düzenleme eksik: yurt içi alım satım (md. 7/4), KMB aracı kuruluşları yasakları ve rafineri kuruluş şartları (Tebliğ 2023/1).
- Ders ağırlığını "döviz cinsinden sözleşme yasağı"na veriyor. Bu konu 13 dönemde hiç sorulmadı.

### SPM/SUC.md (%12)

**İyi kapsanan:** md. 106–108, 110, 110/A cezaları, etkin pişmanlık hesabı, md. 103–105 idari para cezaları, md. 101 tedbirler, md. 115 muhakeme şartı. Sorulan olay tiplerine iyi uyuyor.

**Somut eksikler:**
- **Örtülü kazanç aktarımı (md. 21) ve tedbirleri** için ayrı başlık yok. İki büyük olay sorusu bu konudan geldi (2023/1 S2, 2025/1 S2; ≈53 puan). Bu başlık SUC'a ya da HAO'ya eklenmeli.
- **VI-103.1 net kazanç hesabı** yalnız md. 103/4 cümlesi düzeyinde. Sınav bu konudan 30 puanlık hesap sordu: istisnalar, dönem eşleştirmesi, ödenmezse 2 kat ceza.
- md. 104 piyasa bozucu eylem ve md. 107 ayrımının olaya uygulanış örneği yok (2024/1 C4, 2025/1 S5).
- Suç listesi (md. 106–113) tam sayılmıyor; md. 111–113 sır saklama vb. eksik (2024/3 C5).
- md. 99 ve 109 izinsiz faaliyet var, ama erişim engeli ve Kurul'un 5 yıllık dava yetkisi (2023/2 C5) özetten öte değil.
- md. 97 mali durumun bozulması 1 satır. Tedricî tasfiye (md. 86) yok.

### SPM/YKF.md (%20)

**İyi kapsanan:** md. 37–41 yatırım hizmetleri ve aracı kurum grupları, md. 48 ve III-48.1 GYO oranları, kitle fonlaması, kripto md. 35/B–C.

**Somut eksikler:**
- **Portföy saklama (md. 56)** yalnız tek kural (md. 56/6). Sınav maddenin tamamını iki kez sordu (2022/1 C1, 2025/3 S2): saklayıcının kontrol yükümlülükleri ve sorumluluğu.
- **Teminatlar ve yatırımcı varlıkları (md. 46–47)** yok; 2025/1 S3 ve 2022/2 C1'de soruldu.
- **Yatırım kuruluşu kuruluş şartları ve yasakları (III-39.1)** yok: AO, nama yazılı pay, nakit sermaye, ticari gayrimenkul alım satımı yasağı, getiri garantisi yasağı (2023/3 C2).
- **Yatırımcı tazmin kapsamı (md. 82–85)** yalnız "kapsam dışı" ipucu olarak geçiyor. Kimin tazmin edildiği, sorumlular ve zamanaşımının durması sorulmuş (2023/3 C4, 2025/2 C3).
- **GYO "yapamayacağı işler"** ve **kredi kullanım limiti (özkaynağın 5 katı) hesabı** yok (2026/1 C3, 34 puan). Ders yalnız portföy oranlarını işliyor.
- Yatırım ortaklıklarının kuruluş şartları listesi (md. 48, 2026/1 C1) ders içinde kısaltılmış.
- md. 3 kripto ve menkul kıymet tanımları var, ancak kaydileştirme (md. 13) yok.
- Yatırım fonları alt başlığı (III-52.1 oranları) sınavda hiç sorulmadı. Ağırlığı azaltılıp yerine saklama, tazmin ve kuruluş şartları konulabilir.

---

## Özet öneriler (yaml)

### DTK
- GMR ağırlığını ≈35'e çıkarın. GMR'ye şu kazanımları ekleyin: "kararlar, bilgi ve süreler (md. 6–9, 14)"; "geri verme, kaldırma, zamanaşımı ve kesinleşme"; "Gümrük Yönetmeliği uygulama hükümleri".
- Yeni konu ekleyin (≈15): **TKP – Tasfiye, kaçakçılık ve ticaret politikası önlemleri** (5607, tasfiye, 3577 damping, GTS, muafiyetler md. 167–170).
- IHI'yi 16'dan ≈5'e indirin.
- VRG'yi ≈8'e indirin; serbest bölgeleri ayrı kazanım olarak tutun.
- KMB'yi ≈17'ye indirin; kazanımlara "yetkili müesseseler ve kıymetli maden kuruluşları" ile "ihracat bedelleri tebliği süreleri"ni ekleyin.
- `kaynak_dosyalari` listesine Gümrük Yönetmeliği'ni ekleyin.

### SPM
- Yeni konu ekleyin (≈15): **PAL – Piyasa altyapısı ve yatırımcı koruma** (takas, MKT, kaydileştirme, borsalar, yatırımcı tazmini, tedricî tasfiye, md. 46–47 ve 56).
- GEN'i 14'ten ≈5'e indirin.
- DNT'yi ≈7'ye indirin.
- HAO kazanımlarına "örtülü kazanç aktarımı (md. 21)", "pay alım teklifi", "geri alınan paylar" ve "kanun kapsamına girme ve çıkma (md. 16)" ekleyin.
- IHR kazanımlarına "BASK ve teminat yönetimi", "konut/varlık finansmanı, ipotekli SPA ve PDMK" ekleyin.
