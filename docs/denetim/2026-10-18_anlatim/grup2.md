# Anlatım denetimi, grup 2 (MAL, MES, SHK, SPK, STD, TAB)

Tarih: 2026-10-18. Kapsam: `content/anlatim/smmm/{MAL,MES,SHK,SPK,STD,TAB}/*.md`, toplam 33 dosya.
Ölçüt: `docs/devir/ANLATIM_EDITOR_TALIMATI.md`. Müfredat: `content/mufredat/smmm.yaml`.
Doğrulama kaynağı: `content/kaynaklar/mevzuat/*.txt`.

## Genel sonuç

- 33 dosyanın hepsi `python -m pipeline.anlatim` çıktısında "tamam" görünüyor (HATA yok).
- Ön bilgideki bütün `alinti` alanları pipeline'ın otomatik alıntı denetiminden (`alinti_sorunlari`) geçiyor. Hiçbir alıntı değiştirilmedi ya da çıkarılmadı. `durum` alanlarına dokunulmadı.
- Müfredattaki kazanımların hepsi her dosyada işlenmiş; katı denetimin A05 (kazanım) kontrolü de 33 dosyada sorunsuz. Eksik kazanım bulunmadı.
- Kontrol edilen sayısal örneklerin hepsi elle yeniden hesaplandı (maliyet tabloları, safha FIFO ve ortalama, sapmalar, MHK, kademeli ve matematiksel dağıtım, oran analizleri, DuPont, kâr payı avansı, idari para cezası, prim, gelir vergisi tarifesi, şerefiye, TFRS 15 dağıtımı, sınav ortalaması, süre hesapları). Hesap hatası bulunmadı.
- Mevzuat olguları (madde, oran, süre, tutar, kurul bileşimi, hesap kodu ve kayıt yönü) kaynak metinlerle tek tek karşılaştırıldı. Olgu hatası bulunmadı; bir dosyaya 2026'da yürürlüğe giren bir kural eklendi (aşağıda MES/CUE).

## Biçim düzeltmesi (33 dosyanın hepsinde)

- Gövde metindeki tutarlar 2026 SMMM test biçimine çevrildi: "100.000 TL" yerine "100.000 ₺" (583 yer). Bu kapsamda "(bin TL)", "TL/saat", "Borç (TL)" gibi ifadeler de "₺" oldu.
- Ön bilgiye (alıntılara) dokunulmadı.
- SPK/YHZ'deki "TL hesabında" ifadesi para birimi adı olarak bırakıldı (döviz hesabıyla karşıtlık kuruyor).

## Dosya bazında notlar

### MAL (Maliyet Muhasebesi)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| 7AB | 7/A–7/B ayrımı ("veya / ve" sınırı), yansıtma hesaplarının kapanışı, 732/733/734 üçlü ayrım örneği (4.000 + 6.000 + 7.000 = 17.000), 740/741/622, 78 grubu ve VUK 262, bordro kaydı (420.000 denkliği). THP ile karşılaştırıldı. | Yok |
| DIG | Tam, değişken ve normal maliyet kâr farkı (20.000), MHK, normal ve anormal kayıp (279.300 + 5.700), FIFO, hareketli ortalama ve dönemsel ortalama (toplam 63.000) yeniden hesaplandı. TMS 2 par. 13, 16, 25, 27 doğrulandı. | Yok |
| KAV | Gider çeşitleri 0-7 ve gider yeri grupları THP ile karşılaştırıldı; asal maliyet ve dönüştürme maliyeti geri hesabı doğrulandı. | Yok |
| ORT | Satış değeri, NSD, katsayılı bölme ve yan ürün geri hesabı örnekleri doğrulandı. | Yok |
| SAF | Ortalama (474.800) ve FIFO (410.800 + 64.000) çözümleri ile dört geri hesap tekniği doğrulandı. | Yok |
| SIP | Fazla ve eksik yükleme kaydı (732), kademeli (168.800 / 119.200) ve matematiksel (168.000 / 120.000) dağıtım, FTM örneği doğrulandı. | Yok |
| STD | Fiyat, miktar, karma, ücret, zaman ve GÜG üçlü sapmaları ile 71x/72x/73x kayıt yönleri doğrulandı. | Yok |
| TBL | Maliyet tablosu (570.000), geri hesap ve zincirleme tablo doğrulandı. | Yok |

### MES (Meslek Hukuku)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| KAN | 3568 md. 7, 10, 15, 20-27, 32, 34-39, 48, 49 (7546 sayılı Kanunla 2025'te eklenen meslekten çıkarma hali dahil) ve Çalışma Yön. md. 63/A kaynak metinle tek tek karşılaştırıldı. | Yok |
| ETK | Etik Kurulu (7-11 üye, ayda en az bir), beş ilke, beş tehdit, md. 40-41 ücret, md. 47 emanet doğrulandı. | Yok |
| CUE | 14.01.2026 değişiklikleri (ev-ofis, bağımsız YK üyeliği, md. 36 itiraz süresi) doğrulandı. **Eklendi:** 2026'da yeniden düzenlenen md. 44/2. Buna göre hizmet akdiyle çalışan meslek mensubu, çalıştığı işletmeye ve o işletmenin doğrudan ya da dolaylı hissedarı veya iştiraki olan işletmelere Kanun md. 2 kapsamında hizmet veremez. | Yok (eksik güncel kural tamamlandı) |
| DIS | Ceza bentleri (5/l, 6/f-g-k-u-v, 9/c-d-e), süreler (2 ay, 6 ay, 3 ay, 1 yıl, 15 gün, 30 gün), md. 12 duyuru ve RG ilanı, 60 gün ve e-beyanname şifresi kuralı doğrulandı. 30 günlük itiraz süresinin son günü (9 Nisan) yeniden sayıldı. | Yok |
| HRK | HRK Yön. md. 6-8, 13-23, 25, 28 (3 ve 5 yıl kıdem), Disiplin Yön. karşılıkları ve Ücretler Yön. md. 11-13 doğrulandı. | Yok |
| DGR | Sınav Yön. (yılda 3 sınav, 50/60/65 barajı, tezkiye notu, 80 staj notu, 7 gün, 30 gün, 2 yıl, 6 ay, 5 yıl), Odalar Yön. md. 16, Birlik Yön. (%10, ayın 15'i, Ağustos), SMGE kredileri, Ücretler Yön. (20 Aralık, 1 hafta) doğrulandı. Sınav ortalaması örneği (531 / 9 = 59) yeniden hesaplandı. | Yok |

### SHK (Hukuk)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| ISG | 4857 (bildirim süreleri, iş güvencesi, md. 25/II, md. 26, md. 74'te 7578 sayılı Kanun sonrası 8 + 16 = 24 hafta), 6356 (15 yaş, 1 ay, %1 ve %40, 60 gün, 6 iş günü, dörtte bir, salt çoğunluk), 5510 (prim oranları, %2,25, üst sınır 9 kat, 7200/9000/5400/1800/900 gün, 3 iş günü) doğrulandı. | Yok |
| VRG | 588 sayılı Tebliğ tutarları (2.500.000 / 3.500.000 / 1.200.000; 12.000; 12.000; 25.000), GV Tebliği 332 tarifesi, VUK 344 (%50), 371 (emlak vergisinde uygulanmaz), 376 (7524 sonrası yalnız "yarısı"), geçici vergi (14 / 17), KV beyanı (dördüncü ayın 25'i), 6183 (aylık %3,7, 72 ay tecil, 15 gün, 3 ay), emlak vergisi oranları doğrulandı. | Yok |
| TCR | TTK md. 11-22, 32, 36-37, 64, 82, 796, 814 (6273 sonrası 3 yıl), TBK 547-554, 7887 sayılı CBK sermaye tutarları doğrulandı. | Yok |
| BRC | TBK md. 1-11, 27-39, 49-74, 100, 117 (iyiniyetli zenginleşende bildirim), 120, 146-147 doğrulandı; müterafik kusur ve rücu örneği yeniden hesaplandı. | Yok |

### SPK (Sermaye Piyasası Mevzuatı)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| HAO | SPKn md. 16-21, 23-24, 29; II-17.1 (%5 / %10), II-19.1 (%20, dörtte bir, avans sınırları, 5 yıl), II-23.3 (%75 / %50, 3 ay, 6 aylık / Yıldız Pazar'da 1 aylık fiyat, %90), II-18.1 (100.000 ₺, 5 kat), II-23.2 (%95 kolaylaştırılmış usul ve genel kurul onayı aranmaması, 30 gün, 5 yıl, onda bir), II-15.1 (yılda 4 açıklama, 250.000 ₺) doğrulandı. Kâr payı avansı örneği yeniden hesaplandı. | Yok |
| SUC | SPKn md. 103-116 cezaları (106'da seçimlik, 107/1'de birlikte), 107/3 etkin pişmanlık (500.000 ₺ alt sınır), 109, 109/A, 110, 110/A, 105 (üç kat, %50 YTM) doğrulandı. | Yok |
| IZA | SPKn md. 6-10, 32 (6 ay zamanaşımı), II-5.1 md. 6 muafiyetleri (250.000 ₺, 5 milyon ₺), md. 17, md. 24 (2 iş günü); II-5.2 (150 kişi, 20 iş günü, üçüncü gün, 2-20 iş günü, %20 tavan, %10 + %10 tahsisat) doğrulandı. Eşit dağıtım örneği yeniden hesaplandı. | Yok |
| KYK | SPKn md. 48-56, III-48.1 (%25 halka arz, aktifin %51'i, aday gösterme imtiyazı), III-52.1 (şemsiye fon, %80, 184 / 45 gün, %10 tek ihraççı) doğrulandı. | Yok |
| ALT | İzin makamları (borsa: Kurulun uygun görüşü üzerine Cumhurbaşkanı; takas: Kurulun teklifi üzerine ilgili Bakan; saklama: Kurulun uygun görüşü üzerine ilgili Bakan), 1 yıl / 6 ay, md. 31/B (5 yıldan az olmayan ceza) doğrulandı. | Yok |
| YEN | 7518 sayılı Kanunla gelen kripto hükümleri, III-35/B.1 (6 ay, en çok 1 yıl), III-35/A.2 (1.000.000 ₺, 3 üye, 60 gün, 90 gün, 48 saat, 50.000 / 200.000 / %10 / 20.000 ₺) doğrulandı. | Yok |
| YHZ | SPKn md. 37-41, 82-86 (3 ay, 10 yıl, %5, %25, 100.000 ₺ ve 5 kat, 1 yıl), III-37.1 (20 iş günü, 5 ve 3 yıllık tecrübe) doğrulandı. | Yok |

### STD (Muhasebe Standartları)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| TFR | Kavramsal Çerçeve, TMS 8/16/23/36, TFRS 3/5/15 paragraf göndermeleri ve örnekleri (130.000 / 30.000 / 185.000 / 60.000 / 100.000 + 20.000) doğrulandı. | Yok |
| MBS | VUK 219 (10 / 45 gün), 231/5 (7 gün), TTK 65/3 ve 82, satış kaydı (96.000 denkliği) doğrulandı. | Yok |
| KRL | 660 sayılı KHK md. 4 (7549 sayılı Kanunla 9 üye), md. 9 (7420 ile eklenen ö bendi) doğrulandı. | Yok |

### TAB (Finansal Tablolar ve Analizi)

| Dosya | Yapılan / doğrulanan | Olgu hatası |
|---|---|---|
| DVR | Bütün devir hızı, nakit dönüşüm ve geri hesap örnekleri doğrulandı. **Düzeltme (terim):** A + B + C toplamı "dönemin üretim maliyeti" yerine "dönemin üretim giderleri" diye anılıyor. Böylece MAL/TBL ve MSUGT'deki "üretim maliyeti" (yarı mamul değişimi dahil) tanımıyla çelişki giderildi. | Yok (terim tutarsızlığı) |
| LIK | Oranlar, işlem etkileri tablosu ve beş geri hesap doğrulandı. | Yok |
| DIK | Dikey, yatay ve trend tabloları (104,17; 123,43; 160,71 vb.) yeniden hesaplandı. | Yok |
| KAR | DuPont (%23,44), ekonomik rantabilite (%16,25) ve ters DuPont doğrulandı. | Yok |
| TMS | TMS 1 par. 10, 82A, 87, 99-104; TMS 7 par. 19-20; MSUGT %20 "diğer" kuralı, brüt ve net yöntem; dolaylı yöntem örneği (435) doğrulandı. | Yok |

## Emin olunamayan / açık kalan noktalar

1. **SPK/YHZ, YTM azami tazmin tutarı:** Kanundaki 100.000 ₺ her yıl yeniden değerleme oranında artırılıyor. 2026 için ilan edilen güncel tutar kaynak klasöründe yok, bu yüzden metne yazılmadı. Metin "güncellenmiş tutar uygulanır" diye uyarıyor.
2. **STD/KRL, TSRS kapsam eşikleri:** İlk kapsam kararındaki eşikler (500 milyon ₺ aktif, 1 milyar ₺ hasılat, 250 çalışan) kaynak klasöründe doğrulanamadı. 2025-2026 dönemleri için güncellenmiş KGK kararı da yerel kaynakta yok. Metin "sonraki kararlarla güncellenebilir" diye uyarıyor.
3. **MES/DGR, memur maaş katsayısı:** Odalar Yönetmeliği hesabı katsayı 15 varsayılarak yapılmış ve metinde "varsayılırsa" diye belirtilmiş. 2026'nın gerçek katsayısı doğrulanmadı.
4. (Çözüldü) SHK/TCR'deki geçici tescilin üç aylık süresi TTK md. 32/4 ile doğrulandı.
5. **SPK/ALT, MKT iç denetim periyodu ("asgari altı aylık"):** Bu ayrıntı SPKn md. 78'de bulunamadı; yönetmelik düzeyinde bir kural olabilir. Değiştirilmedi.
6. **Katı denetim, uzunluk:** `siki_denetle` dış üretici sınırını (900–1.800 kelime) uyguluyor ve 12 dosya bunu aşıyor (en uzun TCR, 2.199). Editör talimatındaki sınır 1.000–2.200 kelime; dosyaların hepsi bu aralıkta. TAB/DVR'de `kaynaklar: []` var (A07); talimat mevzuata dayanmayan konularda buna izin veriyor.
