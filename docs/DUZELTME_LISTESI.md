# Uzman sonrası düzeltme listesi

Bu notlar soru dosyalarına **uzman incelemesi döndükten sonra, tek turda** işlenecek. Bir soruyu şimdi değiştirmek
sürümünü yükseltir, G3/G5/G6/GZ kapılarını sıfırlar ve uzmana giden kitapçıktaki metinle bankadaki metni ayırır.
Her madde işlendiğinde soru yeniden kapılardan geçirilir ve madde buradan silinir.

## Açıklama biçimi (21 soru)

✅ uygulandı (4 Ekim 2026): 21 sorunun tamamı (ve ayrıca FIN-BOR-0001, FIN-STK-0003) "Püf noktaları:" biçimine getirildi. Aynı biçime uymayan, ancak bu listede olmayan FIN-MDV-0002, FIN-MKY-0002, FIN-OZK-0001 notları ("… ve tipik hata çeldiricileri") yerinde bırakıldı.

Zor soruların `dogru_neden` alanında teknik notu farklı etiketlerle yazılmış ("Kullanılan teknikler:",
"Zor soru teknikleri:", "Bu soru zor düzeydedir; kullanılan teknikler:", "Zorluk (3) kaynakları:",
"Zor soru; üç teknik birlikte kullanılır:"). Uygulama paketi bunları şimdilik dışa aktarımda ayırıyor
(`pipeline/disa_aktar.py --uygulama`). Düzeltme turunda hepsi tek biçime getirilecek: çözümden sonra
**"Püf noktaları:"** etiketi ve adaya hitap eden sade dil (`pipeline/istemler/uretim.md` §7).

## Soru bazında

| Soru | Not | Kaynak |
|---|---|---|
| DEN-BDY-0002 | ✅ uygulandı (s2): Cevap (C) doğru; iki bağımsız kontrolde de hukuki hata yok. Düzeltilecek ifadeler: (1) Gerekçenin ilk cümlesi md. 26/1-(ç)'yi yanlış özetliyor: "denetçiler … denetimleri üstlenemez" demek yerine, maddenin öznesi denetim kuruluşudur; ekip denetçileri için "son on yılda yedi yıl görev aldıkları işletmenin denetiminde üç yıl geçmedikçe görev alamaz" yazılmalı. Ayrıca "denetim çalışması yürüttükleri" ifadesi atlanmış. (2) "Üç yıllık bekleme süresi başlar" cümlesine "(K) en erken 2028 hesap dönemi denetiminde görev alabilir" eklenmeli. (3) C şıkkına "(K) dışında bir ekiple" eklenmeli. (4) D açıklamasındaki "yalnızca" için "26/2 birinci cümle uyarınca toplu hesap … için öngörülmüştür" yazılmalı. (5) E açıklamasına "Yönetmelik md. 26 bakımından" kaydı eklenmeli (Etik Kurallar'da KAYİK'e özgü uzun süreli ilişki kuralları var). (6) Dayanaklara TTK md. 400/2 eklenmeli. (7) Teknik notu "Püf noktaları:" biçimine getirilmeli. | Merve'nin isteğiyle kontrol + bağımsız hakem, 3 Ekim 2026 |
| FIN-MKY-0001 | ✅ uygulandı (s3): B, C, D şıklarının çeldirici açıklamalarına dayanak alıntısı eklenecek. | G6 denetçi notu |
| FIN-DON-0001 | ✅ uygulandı (s3): D şıkkı için alıntı eklenecek; `gecmis` kaydındaki VUK/KDVK notu düzeltilecek. | G6 denetçi notu |
| FIN-HAZ-0001 | ✅ uygulandı (s3): `gecmis` kaydındaki VUK/KDVK notu düzeltilecek. | G6 denetçi notu |
| STD-TFR-0002 | ✅ uygulandı (s3): TMS 36 par. 18 alıntısı eklenecek. | G6 denetçi notu |
| STD-TFR-0004 | ✅ uygulandı (s3): TFRS 15 par. 74 alıntısı eklenecek. | G6 denetçi notu |
| TAB-TMS-0001 | ✅ uygulandı (s4) (yalnız `gecerlilik.bitis`; TFRS 18 sürümü uzman görüşü için yazılmadı): `gecerlilik.bitis` = 2026-12-31 (TFRS 18, 1 Ocak 2027'den itibaren TMS 1'in yerini alıyor); TFRS 18 sürümü ayrıca yazılacak. Uzman görüşüne bağlı (UZMAN_INCELEME.md §3-1). | Plan notu |

## Uzman kitapçığındaki 30 sorunun bağımsız hakem denetimi (3 Ekim 2026)

Her soruyu soruyu çürütmeye çalışan bağımsız bir hakem inceledi: hesaplar baştan yapıldı, her cümle ve atıf resmî metinle
karşılaştırıldı. **30 cevap anahtarının 30'u doğru.** Aşağıdakiler gerekçe, kök veya üst veri düzeltmeleridir.
(No = kitapçıktaki soru numarası.)

### Gerekçede bilgi/ifade hatası

| No | Soru | Hata | Doğrusu |
|---|---|---|---|
| 1 | FIN-BOR-0001 | ✅ uygulandı (s3): Gerekçe ve hesap adımları "780 B / 408 A" kaydını anlatıyor. THP 408 işleyişine göre 408'e alacak yalnız 308'e aktarmayla yazılır. | 308 B 60.000 / 408 A 60.000; 780 B 30.000 / 308 A 30.000. Birleşik kayıt (D) değişmez. 781 → 661 (uzun vadeli) notu eklenmeli. |
| 5 | FIN-STK-0003 | ✅ uygulandı (s3): "Mamulün maliyeti NGD'yi aştığından istisnanın istisnası işler" cümlesi TMS 2 par. 32'nin ikinci cümlesini (ilk madde fiyatındaki düşüşe bağlı) yanlış uyguluyor. | Mamul maliyetinin üstünde satılamayacağı için par. 32 ilk cümledeki koruma işlemez; par. 9 genel kuralı uygulanır, NGD'nin ölçüsü yenileme maliyetidir. Sonuç (B) değişmez. |
| 8 | TAB-TMS-0001 | ✅ uygulandı (s4): `gecerlilik.bitis` boş; TMS 1, TFRS 18 par. C8 ile 1.1.2027'den itibaren yürürlükten kalkıyor. | `bitis: 2026-12-31`; TFRS 18 par. 99'a dayanan ikinci sürüm yazılacak (uzman görüşüyle). |
| 12 | DEN-BDY-0002 | ✅ uygulandı (s2): Yukarıdaki tabloya bakınız (md. 26/1-ç özeti). | — |
| 14 | DEN-RAP-0001 | ✅ uygulandı (s2): E çeldiricisi "birden fazla belirsizliğin bulunduğu istisnai durumlarda" diyerek BDS 705 par. 10'u genişletiyor. | "…birden fazla belirsizlik içeren istisnai durumlarda, belirsizliklerin muhtemel etkileşimi ve kümülatif etkileri sebebiyle görüş oluşturmanın mümkün olmadığı sonucuna varılırsa" |
| 24 | MES-DGR-0001 | ✅ uygulandı (s3): Kaynakta Kanunun eski adı ("Serbest Muhasebecilik, …"). 5786 s. K. ile değişti. | "3568 sayılı Serbest Muhasebeci Mali Müşavirlik ve Yeminli Mali Müşavirlik Kanunu". Hatanın kaynağı `pipeline/kaynak.py` başlığıydı; araç düzeltildi. |
| 25 | MES-DIS-0001 | ✅ uygulandı (s3): E çeldiricisi "geçici alıkoyma … bir yıldan fazla olamaz" diyor; Disiplin Yön. md. 7'nin ek fıkrası (VUK 153/A) üç yıl öngörür ve sorunun kendi C açıklaması bunu söyler. | "md. 4/2(c) ve md. 7/1'e göre altı aydan az, bir yıldan fazla olamaz (yalnız md. 7 ek fıkrasındaki 153/A hâlinde üç yıl); bir–iki yıl aralığı Yönetmelikte yoktur." |
| 27 | MES-KAN-0001 | ✅ uygulandı (s3): Kaynaklarda Kanunun eski adı (no. 24 ile aynı). Kitapçık dışındaki MES-KAN-0002 de aynı. | No. 24 ile aynı. |

### Kökte belirsizlik (aday takılabilir)

| No | Soru | Sorun | Öneri |
|---|---|---|---|
| 7 | TAB-LIK-0003 | ✅ uygulandı (s4): 300.000 ₺ KVYK'nin ne kadarının ticari borç olduğu verilmemiş; 160.000 ₺ ödenebilmesi için ticari borç ≥ 160.000 olmalı. | Köke "kısa vadeli yabancı kaynakların tamamı ticari borçtur" eklenmeli. `gecmis` kaydı eski sürümü anlatıyor, düzeltilmeli. |
| 15 | DEN-RSK-0001 | ✅ uygulandı (s3): Gerekçe BDS 450 A21'i "yönetimle ilişkili taraf" diye anıyor; kök yalnız "ilişkili taraf" diyor. | Kökte "yönetimle ilişkili bir tarafa"; A21'in son cümlesi açıklamaya eklenmeli. |
| 18 | VER-VUK-0001 | ✅ uygulandı (s3): Komisyon kararı (15.4.2027) zamanaşımı dolduktan (31.12.2026) sonra geliyor; "en geç ne zamana kadar tarh edilmeli" sorusu pratikte boşa düşüyor. "Kalan üç ay" ifadesi ay esasıyla 1.1.2027 de verebilir. | Tevdi tarihi 31.12.2026'dan önceye (örn. 15.11.2026) çekilmeli; gerekçe "işlemeyen süre en fazla bir yıl olduğundan 31.12.2025 + 1 yıl = 31.12.2026" diye yazılmalı. |
| 29 | STD-TFR-0003 | ✅ uygulandı (s3): Faizin ay mı gün mü esasıyla hesaplanacağı yok; gün esasında 210.657,53 ₺ çıkar (şıklarda yok). | Köke "faiz aylık eşit tutarlarda tahakkuk eder" eklenmeli. |

### Küçük iyileştirmeler

| No | Soru | Öneri |
|---|---|---|
| 8 | TAB-TMS-0001 | ✅ uygulandı (s4): D şıkkı/açıklaması par. 66(d)'deki "bir yükümlülüğü yerine getirmek amacıyla kullanılmasının ya da takas edilmesinin" ifadesini kısaltıyor. |
| 11 | MAL-TBL-0002 | ✅ uygulandı (s4): İlk MSUGT kaynak satırı "D ve E kalemleri" değil "D kalemi". |
| 17 | VER-KVK-0002 | ✅ uygulandı (s3): "md. 32/C-6'ya göre asgari vergi matrahı" yerine "indirim ve istisnalar düşülmeden önceki kurum kazancı (md. 32/C-6)"; geçmiş yıl zararı için 1 Seri No.lu KV Genel Tebliği 32.5.4 dayanak olarak eklenmeli. |
| 19 | VER-VUK-0002 | ✅ uygulandı (s3): E çeldiricisinde yol açık yazılmalı: 400.000 × 3 × 1,5 × ½ = 900.000. |
| 21 | HUK-SGK-0003 | ✅ uygulandı (s4): E şıkkına kanundaki "o kuruluş adına ve hesabına" ibaresi eklenebilir. |
| 23 | SPK-SUC-0002 | ✅ uygulandı (s3): "İstisnanın istisnası" etiketi yerine "genel kural–özel kural ayrımı (kapsamı farklı fıkralar)". |
| 24 | MES-DGR-0001 | ✅ uygulandı (s3): "md. 16 (b)" → "md. 16(b) ve son fıkra"; Geçici md. 2'nin sakladığı eski hüküm ("3 yıl içinde yılda 3 kez") ve TESMER Yönergesi 2026'daki "3 yıl" ifadesi açıklanmalı; aday adı "(B)" şık harfiyle karışıyor → "(K)". |
| 25 | MES-DIS-0001 | ✅ uygulandı (s3): Atıflar fıkra düzeyinde: "md. 4/2(c)", "md. 6/1(d)". |
| 28 | STD-TFR-0001 | ✅ uygulandı (s3): "par. 36 uyarınca ileriye yönelik" → "par. 36–38". |

### Temiz çıkanlar

2 FIN-MDV-0002, 3 FIN-MKY-0002, 4 FIN-OZK-0001, 6 TAB-KAR-0002, 9 MAL-SAF-0002, 10 MAL-SIP-0001, 13 DEN-BDY-0003,
16 VER-GVK-0001, 20 HUK-BRC-0001, 22 SPK-ALT-0001, 26 MES-ETK-0001, 30 EKO-MAK-0001.

### Üretim kuralına çıkan ders

Hataların çoğu aynı türden: kuralın **kime/hangi şartla** uygulandığını özetlerken genişletmek veya bir şartı atlamak
(12, 14, 25), kökte çözüm için gereken bir varsayımı yazmamak (7, 18, 29) ve THP hesap işleyişini kısaltmak (1).
G5 düşman denetimi istemine bu üç kontrol açıkça eklenecek.
