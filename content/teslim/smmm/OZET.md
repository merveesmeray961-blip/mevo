# SMMM soru üretimi — teslim özeti (2 Kasım 2026)

**Toplam: 2630 / 2630 soru, 136 dosya** (`<DERS>_<KONU>_20261102_<n>.yaml`, her dosya tek konu, en çok 25 soru).
Model: claude-sonnet-5-5. Hepsi `id: TASLAK`, `durum: taslak`, `surum: 1`.

**Önemli:** `SHK_TCR_20261102_1.yaml` (12 soru) ilk partidir ve bankaya zaten alınmıştır (`TCR.p1`). Yeniden alınırsa mükerrer olur. Bu dosya sayılırsa yeni soru sayısı 2618'dir.

## Kendi doğrulamam (resmî kabul DEĞİL)

`dogrula2.py` ile tüm klasör toplu çalıştırıldı: şema, birebir alıntı (≤600 karakter), hesap kodu sonucu, şık ve harf dengesi, çeldirici anahtarları, banka ve diğer teslimlerle benzerlik. Sonuç: 2630 sorunun 2618'i **0 hata**. Kalan 12 "hata", bankada zaten bulunan ilk partinin kendisi (`TCR.p1` ile birebir aynı). G2–G7, kör çözücü ve hakem sizde.

- Zorluk: 578 kolay / 1256 orta / 796 zor. Doğru şık harfleri: A 497, B 551, C 568, D 531, E 483.

## Konu başına yazılan (tümü hedefe eşit)

| Ders | Konu | Soru |
|---|---|---|
| FIN | STK 35, MDV 30, MKY 15, DON 30, ALC 30, BOR 10, OZK 55, HAZ 30 | 235 |
| TAB | DVR 115, LIK 80, DIK 165, KAR 35, TMS 25 | 420 |
| MAL | TBL 15, KAV 55, 7AB 25, ORT 45, SAF 35, SIP 35, STD 30, DIG 35 | 275 |
| DEN | RAP 50, KNT 30, RSK 65, ICK 35, KAL 15, PRG 20 | 215 |
| VER | GVK 20 | 20 |
| HUK | SGK 10, ISH 10 | 20 |
| SPK | HAO 65, SUC 70, KYK 55, IZA 45, ALT 35, YEN 30, YHZ 40 | 340 |
| MES | KAN 15, ETK 10, CUE 25, DIS 25, HRK 10, DGR 35 | 120 |
| STD | TFR 55, MBS 35, KRL 35 | 125 |
| SHK | ISG 165, VRG 165, TCR 165, BRC 165 | 660 |
| EKO | MIK 25, MAK 30, DIS 35 | 90 |
| MLY | KGH 5, BUT 10 | 15 |
| GKY | TUR 30, MAT 45, TAR 10, ING 10 | 95 |

## Hakem aşamasında özellikle bakılması gerekenler

1. **Güncellik / geçerlilik tarihleri:** `gecerlilik.baslangic` alanlarının bir kısmı metne bakılarak değil, ajanların tahminiyle girildi. Doğrulayıcı bu alanı denetlemiyor. Özellikle: TAB (MSUGT 1994-01-01, TMS 1 2024-01-01), SPK (II-5.1 2013-07-17, II-5.2 2013-07-07, md. 31/B 2020-02-26, II-18.1, II-19.1, II-23.3, II-17.1, II-23.2, II-15.1, kitle fonlaması 2021-10-22), 2020 değişikliği geçen SPKn md. 23, 24, 103, 106-109, DEN (standart sürüm tarihleri).
2. **THP çelişkileri (FIN):**
   - Zarar fazlası için Tekdüzen Hesap Planı 681 diyor, müfredat kazanım adı 689 geçiyor. ALC'de 689 çeldirici olarak kullanıldı; 689'u doğru sayan bir inceleme bu iki soruyu yanlış bulabilir.
   - Reeskont: 122/322/647 metinleri kendi içinde çelişiyor (652/642 ve 657/647). Yalnızca dönem sonu alacak reeskontu (657/122) soruldu; DON'da 657/647 kullanıldı.
3. **Betikle üretilen sorular** (özgünlük/çeşitlilik riski): TAB (DIK, DVR, KAR, LIK, TMS), MAL (hepsi), SHK/BRC ve SHK/TCR, SHK/ISG, SHK/VRG, GKY/MAT. Köklerin ilk 5 kelimesi bazı konularda yineleniyor (SHK ~%30–44, MES/MLY %60–80 ortak başlangıç); devamları farklı ve benzerlik kontrolünü geçiyor.
4. **Yapay çeldiriciler:** MAL ve TAB sayısal sorularında "doğru şık en uzun/en kısa olmasın" kuralı için 5/7 haneli veya ondalıklı çeldiriciler eklendi; talimatın 13. kuralı (gerçekçi çeldirici) açısından bakılmalı.
5. **TAB alıntıları:** oran formülleri mevzuatta olmadığından alıntılar hesap tanımlarından (THP, MSUGT Ek 3/4/5) alındı; dayanak soruyla dolaylı ilişkili.
6. **`dogrulama.python` olmayanlar:** FIN yevmiye / "X hesabına N ₺ borç" biçimli sorular ve GKY/MAT'ta yargı-birleşimi/metin şıklı ~15 soru (doğrulayıcı sayısal olmayan şıkkı çözemiyor). `hesap_adimlari` var, tutarlar elle kontrol edildi.
7. **DEN/RSK_1:** BDS 320 performans önemliliği sorusunun doğru şıkkı belirsiz kısa bir cümle ("…müteakip prosedürlerin zamanlaması için"); gözden geçirilmeli.
8. **Alıntılarda satır sonu tireleri** (MES: ETK, DIS, DGR, HRK; "tas- laklarını"): kaynak PDF'ten geldiği gibi duruyor; G6 sorun çıkarırsa düzeltilir.
9. **MAL_KAV_20261102_3:** zorluk 1/3/1 (hedef 1/2/2).

## Talimattan sapmalar

- Olumsuz kök oranı: DEN hedef ≈%40 → RAP %18, KNT %23, RSK %12; MES hedef ≈%50 → %40–50.
- Öncüllü oran (SPK, hedef ≈%20): YEN %17, YHZ %12, KYK %18.
- Zorluk dağılımı bazı konularda hedefin birkaç puan dışında (MAL_DIG zor %26; SHK/ISG 38/83/44; SPK/YHZ 4/24/12).

## Atlanan kazanımlar ve nedenleri

- **Tutara / yıla bağlı veya Cumhurbaşkanı kararıyla değişen hükümler** (tüm derslerde bilerek atlandı): asgari sermaye (TTK 332, 580), faiz üst sınırları (TBK 88, 120), kefalet ve kira güvence tutarları, VUK had ve miktarları, GVK tarife / istisna / engellilik tutarları, KDV / KVK stopaj / gecikme zammı oranları, SPK tebliğ sabit tutarları (kitle fonlaması, GYO sermaye sınırları, 250.000 TL eşikleri), 5510 md. 80/b, ücret tarifesi tutarları.
- **Güncelliği doğrulanamayan veya belirsiz:** analık / doğum izni (5510 md. 15/16/18, 4857 md. 74; 7578 sayılı Kanun değişikliği), TBK md. 55/3-4 (7589), TTK 617/3 ve 623/3 (AYM iptali), 4857 md. 25/I-a (ifade tek anlamlı değil), TÜRMOB yönetmeliği md. 15 (Kanun md. 34 ile çelişki), ücret yönetmeliğindeki tarife takvimi.
- **Kaynak metni olmayan:** FIN akreditif, mizan, düzenleyici hesaplar, aralıklı envanter, stopaj (BOR); MAL maliyet muhasebesinin amaçları, muhasebe bilgi sistemi, 732–734 alt sapma formülleri, 7/A zorunluluk tutarları; DEN GKGDS, COSO; STD MBS "akış şeması", KRL IASB/IFAC/IESBA/ISSB; SPK YEN kira sertifikası (yalnız SPKn md. 61'den 4 soru); DEN/MLY Wagner, Baumol, Peacock-Wiseman, operasyonel açık, borç dinamiği.
- **Bankada zaten yoğun / okunamayan:** DEN BDS 200, 505, 540, 550 (PRG), 705 md. 17 ve 720 md. 23T (metinde "…" / işaret kaybı); MES Odalar, YMM Odaları ve YMM Tasdik yönetmelikleri; GVK md. 18, 21, 75, 86, 89, 120, 121, 80; SGK md. 3, 4, 8, 11, 13, 60, 102; "geçici vergi", "mahsuplar", "vergiye uyumlu mükellef indirimi"; SPKn md. 99/A(1) son kısmı ve md. 103/8 (dipnot metnin ortasında).
