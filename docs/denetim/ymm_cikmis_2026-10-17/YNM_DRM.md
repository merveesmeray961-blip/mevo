# YMM çıkmış soru analizi: Yönetim Muhasebesi (03 → YNM) ve Denetim, Raporlama ve Meslek Hukuku (04 → DRM)

Kapsam: `content/kaynaklar/cikmis/ymm/ymm_<YIL>_<DONEM>_03|04.txt`, 2022/1 – 2026/1 arası 13 dönem, 26 dosya. Hepsi okundu; okunamayan dosya yok.
Karşılaştırma: `content/mufredat/ymm.yaml` (YNM, DRM) ve `content/anlatim/ymm/{YNM,DRM}/*.md`.

## 0. Kaynak hakkında uyarılar (önce okuyun)

- **YNM dosyalarının hiçbirinde soru metni yok, yalnız "Sınav Komisyonu Cevapları" var.** Soru konuları cevaplardan çıkarıldı. Soru metnindeki veriler (ör. kapasite, stok politikası) çoğu zaman yalnızca cevaptaki hesaplardan anlaşılabiliyor.
- YNM'de puan **yalnız 2022/1, 2022/2 ve 2026/1** dosyalarında görünüyor. Diğer 10 dönemde puan yok. Bu yüzden frekans esas olarak soru sayısına dayanıyor.
- pdftotext -layout çıktısında tablolar kaymış. Özellikle 2022/1 S2, 2022/2 S3 (normal maliyet tablosu), 2023/1 S2 (nakit bütçesi), 2024/1 S1b ve 2025/1 S1-S2'de sütunlar karışık; rakamlar tek tek doğrulanamadı. Konu tespiti bundan etkilenmiyor.
- DRM'de soru metni yalnız 2022/3, 2023/1, 2023/2, 2023/3 ve 2025/1 dosyalarında var. Öteki dönemlerde konu cevaptan çıkarıldı.
- DRM 2025/3 dosyasında puan yok; cevaplar doğrudan kanun maddesinin metni.
- DRM 2024/3 S1'de başlık "15 Puan" diyor, alt puanların toplamı ise 4+6+10 = 20. Kaynakta tutarsızlık var.
- DRM 2024/1 S3 b-c'de "Yönetmeliğin 29. / 48. maddesi" deniyor. Bağlamda (S3a) YMM Odaları Yönetmeliği geçiyor, fakat b-c'de yönetmeliğin adı tekrarlanmıyor. 29. madde (Genel İdare Müdürü ve Oda Sekreterinin disiplin yetkisi) personel hükmü gibi duruyor; hangi yönetmelik olduğu **belirsiz**.
- DRM 2022/2 S2 (denetim çalışmaları, denetim raporu çeşitleri) ve S4 (tam tasdik raporunun "III-Hesap İncelemeleri" ve "IV-Sonuç" bölümleri) cevaplarında mevzuat adı ve madde numarası verilmemiş. Dayanak **metinde belirtilmemiş** diye işaretlendi.

---

# BÖLÜM A — YÖNETİM MUHASEBESİ (03 → YNM)

## A1. Soru soru döküm

Kısaltmalar: MHK maliyet-hacim-kâr, KRV karar verme, BTC bütçe ve standart maliyet, FDM faaliyete dayalı ve stratejik maliyetleme, PRF performans ve transfer fiyatı, DEG değişken ve tam maliyetleme. "YOK", yaml'da karşılığı olmayan soru demek. Yönetim muhasebesinde yasal dayanak bulunmaz; tek istisna Tekdüzen Hesap Planı (MSUGT) atıflarıdır ve bunlar belirtildi.

| Dönem | S | Konu (bir satır) | Dayanak / yöntem | Puan | yaml konu → kazanım |
|---|---|---|---|---|---|
| 2022/1 | 1 | Dört kavram tanımı: GÜG verim sapması, Dİ süre sapması, hedef maliyet, finansal tabloların konsolidasyonu | Kavram | 20 (4×5) | BTC → GÜG ve işçilik sapmaları (10p); FDM → hedef maliyet (5p); **konsolidasyon: YOK** (5p, YNM kapsamında değil) |
| 2022/1 | 2 | İki aşamalı safha maliyeti: kumaş m²→adet dönüşümü, normal fire (%3), fire maliyetinin sağlam birimlere yüklenmesi | Safha maliyet sistemi | 35 (20+15) | **YOK** (safha maliyet sistemi) |
| 2022/1 | 3 | Ekipman (balon) yenileme: gelir artışı, işletim tasarrufu, yeni maliyet, eski satış geliri | Fark analizi | 15 | KRV → fark analizi |
| 2022/1 | 4 | Özel sipariş (Kayseri teklifi) ve iki alternatif: aynı fiyattan ek satış ya da tüm müşteriler için fiyat indirimi | Katkı payı / fark analizi | 30 (15+15) | KRV → özel sipariş |
| 2022/2 | 1 | Net katkı payı ve geçerli (ilgili) maliyet tanımı | Kavram | 10 (5+5) | MHK → katkı payı; KRV → fark analizi |
| 2022/2 | 2 | Standart maliyet: iki mamul, DBYM'nin tamamlanması, tamamlanan mamullerin standart maliyeti, FIFO ile fiili DİMM, 711/721/731 yansıtma hesaplarıyla toplam sapmalar | Standart maliyet + THP 7/A | 35 (20+5+5+5) | BTC → malzeme/işçilik/GÜG sapmaları (THP kayıt kısmı kazanımda yok) |
| 2022/2 | 3 | Tam, değişken ve normal maliyete göre gelir tabloları (kapasite sapması, çalışmayan kısım gideri) | Maliyetleme yöntemleri | 35 (15+10+10) | DEG → değişken/tam maliyet, normal kapasite |
| 2022/2 | 4 | Ortak üründe (süt tozu) ayrılma noktasında satış ile ek işlem kararı | Ek işlem kararı | 20 | KRV (**"ek işlem / ayrılma noktası" kazanımı yaml'da yok**) |
| 2022/3 | 1 | Hacme dayalı (HTM) ve FTM ile birim maliyet; iki ürün, dört faaliyet; farkın yorumu | FTM | puan yok | FDM → faaliyete dayalı maliyetleme |
| 2022/3 | 2 | Çeyreklik ana bütçe: satış, üretim, hammadde alımı, Dİ, GÜG, pazarlama giderleri | Ana bütçe | puan yok | BTC → ana bütçe |
| 2022/3 | 3 | Dört parça için üret ya da satın al; üretime girmeyen sabit gider dışarıda tutulur | Üret / satın al | puan yok | KRV → üret veya satın al |
| 2022/3 | 4 | Hedef maliyet (maliyet üzerinden %30 kâr) ve iki üretim alternatifi | Hedef maliyetleme | puan yok | FDM → hedef maliyetleme |
| 2023/1 | 1 | Bilet komisyonu işinde BBN ve hedef kâr; komisyon düşünce yeniden hesap | MHK | puan yok | MHK → başabaş, hedef kâr |
| 2023/1 | 2 | Altı aylık nakit giriş, çıkış ve nakit bütçesi; dış finansman ihtiyacı; iki büyüme senaryosu | Nakit bütçesi | puan yok | BTC → ana bütçe (nakit bütçesi açıkça yazılı değil) |
| 2023/1 | 3 | FTM ile birim maliyet, kâr/zarar, hedef maliyet; yeni makinenin etkisi | FTM + hedef maliyet | puan yok | FDM |
| 2023/2 | 1 | Otelde bölüm bazında brüt kâr, sermaye getirisi; ek getiri hedefi için iki alternatif ve nitel yorum | ROI + hedef kâr | puan yok | PRF → yatırımın kârlılığı (kısmen MHK → hedef kâr) |
| 2023/2 | 2 | DİMM fiyat/miktar, Dİ ücret/zaman, GÜG bütçe/verim/kapasite sapmaları | Standart maliyet (Anglosakson üçlü ayrım) | puan yok | BTC → tüm sapmalar |
| 2023/2 | 3 | Ekonomik sipariş miktarı, yıllık sipariş sayısı, elde tutma ve sipariş maliyetleri, sipariş noktası | EOQ | puan yok | **YOK** (yaml'da FYN → ISY'de) |
| 2023/3 | 1 | THP 7. grup maliyet hesapları, 7/A ve 7/B seçenekleri (sözel) | MSUGT / THP | puan yok | **YOK** |
| 2023/3 | 2 | Katkı payı oranı, faaliyet kaldıracı, değişken maliyet artınca BBN, KP oranını korumak için fiyat, yeni yapıda BBN | MHK | puan yok | MHK (**faaliyet kaldıracı kazanımı yok**) |
| 2023/3 | 3 | Sipariş maliyeti: tamamlanan siparişlerde SMM, mamul stoku, yarı mamul | Sipariş maliyet sistemi | puan yok | **YOK** |
| 2024/1 | 1 | Ticari mal alım bütçesi ile nakit bütçesi (tahsilat, borçlanma, anapara, faiz) | Ana bütçe / nakit bütçesi | puan yok | BTC → ana bütçe |
| 2024/1 | 2 | Üç farklı hacimde üret ya da satın al (makine kiralama dahil) ve nitel faktörler | Üret / satın al | puan yok | KRV → üret veya satın al |
| 2024/2 | 1 | DİMM fiyat/miktar ve Dİ ücret/zaman sapmaları (üçlü sütun gösterimiyle) | Standart maliyet | puan yok | BTC → malzeme ve işçilik sapmaları |
| 2024/2 | 2 | İki ürünlü (5:2) ağırlıklı katkı payıyla BBN | MHK | puan yok | MHK → çok ürünlü başabaş |
| 2024/2 | 3 | Zarar gösteren departmanın kapatılması | Bölüm kapatma | puan yok | KRV → ürün hattını kapatma |
| 2024/2 | 4 | Kârı %20 artırmak için gereken satış artışı | MHK | puan yok | MHK → hedef kâr |
| 2024/3 | 1 | Kademeli değişken maliyet ve ek kira ile BBN; hedef kâr; BBN üstü satışa prim | MHK | puan yok | MHK → başabaş, hedef kâr |
| 2024/3 | 2 | Üretim bütçesinden bilinmeyen satışın geri bulunması (denklem) | Üretim bütçesi | puan yok | BTC → ana bütçe |
| 2024/3 | 3 | Üç ortak üründe ek işlem kararı | Ek işlem kararı | puan yok | KRV (kazanım yok) |
| 2024/3 | 4 | Dört kavram: faaliyet kaldıracı, güvenlik payı, geçerli maliyet, batmış maliyet | Kavram | puan yok | MHK (2), KRV (2) |
| 2025/1 | 1 | Üretilen mamul maliyeti tablosu, gelir tablosu, birim maliyet | Maliyet akışı | puan yok | **YOK** (temel maliyet akışı) |
| 2025/1 | 2 | GÜG yükleme oranı (Dİ'ye göre), iki müşteri işinin maliyeti, maliyete göre fiyatlama | İş / sipariş maliyeti | puan yok | **YOK** (sipariş maliyeti / normal maliyetleme) |
| 2025/1 | 3 | Kalite maliyetlerinin dört sınıfa ayrılması; programın getirisi | Kalite maliyetleri | puan yok | FDM → kalite maliyetleri |
| 2025/2 | 1 | Kalite maliyeti sınıflaması (TQM); program kabul analizi | Kalite maliyetleri | puan yok | FDM → kalite maliyetleri |
| 2025/2 | 2 | Geleneksel yöntem ile FTM arasında birim GÜG karşılaştırması ve gerekçe | FTM | puan yok | FDM |
| 2025/2 | 3 | Çok ürünlü BBN, güvenlik marjı, faaliyet kaldıracı | MHK | puan yok | MHK |
| 2025/3 | 1 | Zarar gösteren atölyenin iptali (kaçınılamayan sabit gider) ve yöneticinin oran odaklı yanılgısı | Bölüm kapatma | puan yok | KRV → ürün hattını kapatma |
| 2025/3 | 2 | Makine saati kısıtında üretim karması | Kıt kaynak | puan yok | KRV → kıt kaynak kullanımı |
| 2025/3 | 3 | Hedef maliyet (maliyet üzerinden %25) ve iki alternatif | Hedef maliyetleme | puan yok | FDM |
| 2025/3 | 4 | Tam, değişken ve normal maliyetlemeye göre gelir tabloları | Maliyetleme yöntemleri | puan yok | DEG |
| 2026/1 | 1 | Üretim bütçesi, üretilen mamul maliyeti, ortalama maliyetle dönem sonu stoku ve SMM | Bütçe + stok değerleme | 40 (4×10) | BTC → ana bütçe (ortalama maliyet kısmı kazanımda yok) |
| 2026/1 | 2 | Üç ortak üründe ek işlem kararı; ayrılma noktasında başabaş satış fiyatı | Ek işlem kararı | 30 (10+20) | KRV (kazanım yok) |
| 2026/1 | 3 | İşçilik %15 artınca KP oranını korumak için fiyat; hedef kâr için satış; kapasite artışı (amortisman) öncesi ve sonrası kâr | MHK | 30 (10+10+10) | MHK → hedef kâr, katkı payı |

Toplam: 13 dönemde 44 ana soru (dönem başına 2–4).

## A2. yaml konularına göre frekans

Bir soru birden çok konuya dağılıyorsa kesirli sayıldı (ör. 2024/3 S4 = MHK 0,5 + KRV 0,5).

| yaml konu | Soru sayısı (13 dönem) | Pay | yaml agirlik | Görünen puan (3 dönem, 300p) | Değerlendirme |
|---|---|---|---|---|---|
| KRV Karar verme | 11 | %25 | 18 | 70 | **Az ağırlıklı.** Neredeyse her dönem soruluyor (13 dönemin 11'inde). |
| BTC Bütçeleme ve standart maliyet | 8,5 | %19 | 20 | 85 | Uyumlu |
| MHK Maliyet hacim kâr | 8 | %18 | 18 | 35 | Uyumlu |
| FDM Faaliyete dayalı ve stratejik | 7,25 | %16 | 14 | 5 | Biraz az ağırlıklı; 2025'ten beri her dönem var |
| DEG Değişken ve tam maliyetleme | 2 | %5 | 14 | 35 | **Fazla ağırlıklı** |
| PRF Performans ve transfer fiyatı | 1 (kısmi) | %2 | 16 | 0 | **Çok fazla ağırlıklı** |
| YOK (maliyet sistemleri, EOQ, THP 7/A-7/B, konsolidasyon tanımı) | 6,25 | %14 | — | 40 | **yaml'da konu yok** |

Önerilen yeniden dağılım (öneri, kesin değil): KRV 22, BTC 20, MHK 18, FDM 15, **yeni "Maliyet sistemleri ve maliyet akışı" 12**, DEG 8, PRF 5.

## A3. Sorulan ama yaml'da eksik ya da zayıf YNM konuları

1. **Maliyet sistemleri ve maliyet akışı** (yaml'da hiç yok, 6 soru):
   - safha maliyeti ve fire (2022/1 S2, 35 puan)
   - sipariş maliyeti (2023/3 S3)
   - üretilen mamul maliyeti tablosu ve gelir tablosu (2025/1 S1)
   - GÜG yükleme oranıyla iş maliyeti (2025/1 S2)
   - ortalama maliyetle stok ve SMM (2026/1 S1c-d)
2. **Ortak ürünlerde ek işlem / ayrılma noktası kararı**: 2022/2 S4, 2024/3 S3, 2026/1 S2 (30 puan). Ayrılma noktasındaki başabaş fiyat da soruluyor. KRV kazanımlarına eklenmeli.
3. **Nakit bütçesi ve finansman ihtiyacı** (borçlanma, faiz): 2023/1 S2, 2024/1 S1b. BTC kazanımında yalnızca "ana bütçe" yazıyor. Ticari mal alım bütçesi (2024/1 S1a) ve bilinmeyeni geriye doğru bulma (2024/3 S2) de açıkça eklenmeli.
4. **Faaliyet kaldıracı ve güvenlik marjı**: 2023/3 S2b, 2024/3 S4a-b, 2025/2 S3c-d. Güvenlik marjı MHK'de var; faaliyet kaldıracı yok (yalnızca FYN → FPA'da).
5. **THP 7. grup, 7/A–7/B ve yansıtma/fark hesapları**: 2023/3 S1, 2022/2 S2 (711/721/731).
6. **EOQ ve sipariş noktası**: 2023/2 S3. yaml'da FYN dersinde. YNM'de de bir kez sorulduğu not edilmeli.
7. **Kalite maliyetleri** iki ardışık dönemde soruldu (2025/1 S3, 2025/2 S1). Kazanım FDM'de var; ağırlığı artırılabilir.
8. **Kavram tanımı mini soruları** (5'er puan): 2022/1 S1, 2022/2 S1, 2024/3 S4. Sapma tanımları, hedef maliyet, net katkı, geçerli ve batık maliyet, faaliyet kaldıracı, güvenlik payı, hatta konsolidasyon. Banka için kısa tanım soruları üretilmeli.
9. Bölüm kapatmada "yöneticinin yanılgısı" türü nitel yorum (2025/3 S1b) ve nitel faktör listeleri (2024/1 S2d, 2023/2 S1c).

## A4. 13 dönemde hiç sorulmayan YNM kazanımları (ağırlığı düşürmeye aday)

- PRF: sorumluluk merkezleri, artık kâr, dengeli başarı kartı, **işletme içi transfer fiyatlaması**. Hiçbiri sorulmadı. Yatırımın kârlılığı yalnızca 2023/2 S1'de dolaylı geçti.
- FDM: yaşam boyu maliyetleme (yalnızca 2022/1 S1c'nin hedef maliyet tanımında "yaşam seyri" ifadesi geçiyor).
- DEG: "stok değişiminin kâra etkisi" mutabakatı açıkça istenmedi; yalnızca üç gelir tablosu düzenlendi.
- BTC: esnek bütçe ayrı bir soru olarak gelmedi. Yalnızca GÜG sapmasında esnek bütçe formülü kullanıldı (2023/2).
- MHK: hedef kârın vergi sonrası olması hiç sorulmadı.

## A5. YNM soru stili

- **Biçim:** 2 saat, 3–4 soru, toplam 100 puan. Görülen puanlar: S başına 15–40, alt şık başına 5–20.
- **Vaka uzunluğu:** Kısa sayısal mini vakalar, yani bir şirket adı ve 5–12 veri. Örnekler: "Kervan İşletmesi", "Tınaztepe AŞ", "Urla AŞ". Tutarlar TL; 2023/3 S2'de karışık olarak $ var. Soruların çoğu yabancı ders kitabı problemlerinden uyarlanmış görünüyor: otel, bilet acentesi, traktör/biçerdöver.
- **Alt sorular:** a–d şıkları zincirleme; bir şıkkın sonucu sonrakinde kullanılıyor (2023/1 S3, 2026/1 S1). Son şık çoğunlukla "değişiklik olursa" senaryosu (yeni makine, fiyat değişimi, kapasite artışı) ya da nitel yorum.
- **Cevap biçimi:**
  - Çok sütunlu tablolar: çeyrek veya ay sütunlu bütçeler, ürün sütunlu karar tabloları, tam/değişken/normal gelir tabloları.
  - Sapmalarda "GM×GF | GM×SF | SM×SF" üç sütun gösterimi, yanında formülle "alternatif çözüm".
  - Her sonuca "Olumlu/Olumsuz sapma" etiketi.
  - Her karar sorusunda tek cümlelik karar ("ayrılma noktasında satılmalı", "teklif kabul edilebilir").
- **Puanlama:** Mikro puanlama yalnızca birkaç dönemde görünür. Görülen yerlerde puan şık bazında (5/10/15/20). Kavram başına 5 puan. 2022/2 S2'de her hesap kalemi için 5 puan (DİMM sapması, Dİ sapması, GÜG sapması).
- **Esneklik:** Anahtar sık sık "alternatif çözüm de doğru kabul edilmektedir" diyor. Yıllık ya da aylık çözüm (2023/1 S1), alım artış tabanı (2023/1 S2), yeni makine varsayımı (2023/1 S3d) ve "önemsiz fark başabaş kabul edilebilir" (2024/1 S2a) örnekleri var. Pratik sorularda çözüm varsayımı açıkça yazılmalı.
- **GÜG sapma modeli:** Resmi anahtar Anglosakson modelini kullanıyor. Verim sapması = (FS − SS) × **değişken** GÜG oranı (2022/1 S1a tanımı ve 2023/2 S2c hesabı). Kapasite sapması = SS'de bütçelenen GÜG − SS × toplam oran. Ayrıntı A6'da.

## A6. Anlatım kontrolü (YNM)

### `anlatim/ymm/YNM/BTC.md` (en çok sorulan ikinci konu)

Kapsanan: ana bütçe bağlantıları, esnek bütçe, malzeme ve işçilik sapma formülleri, GÜG üçlü/ikili ayrım, THP 732–734.

Somut eksikler:
1. **GÜG sapma modeli resmi anahtarla çelişiyor.** Ders "Türkiye'de yaygın modeli" (verimlilik = (FS−SS) × toplam oran; kapasite = (NK − FS) × sabit oran) varsayılan yapıyor ve "soru belirtmiyorsa üçlü ayrımı kullan" diyor. Resmi cevap (2023/2 S2c) ise verim sapmasını değişken oranla, kapasite sapmasını SS bazında hesaplıyor: 6.776 TL = 2,20 × 3.080 saat. 2022/1 S1a tanımı da değişken oranı kullanıyor. Varsayılan model sınav anahtarının modeline çevrilmeli; Türk modeli "alternatif" olarak kalmalı.
2. **Nakit bütçesi örneği yok.** Konu iki kez soruldu (tahsilat gecikmesi, asgari kasa, borçlanma, anapara ve faiz). Ticari mal alım bütçesi de yok.
3. Bütçe tablosundan bilinmeyen satışı geri bulma (2024/3 S2) yok.
4. DBYM'nin tamamlanması ve tamamlanan mamullerin standart maliyeti, 711/721/731 yansıtma hesaplarıyla sapma bulma (2022/2 S2) yok. Ders yalnız 7/A fark hesaplarını anıyor.
5. Ortalama maliyetle dönem sonu stoku ve SMM (2026/1 S1) yok.
6. Örnekler tek ürünlü ve tek dönemli. Sınav çeyrek veya ay sütunlu çok dönemli tablo istiyor.

### `anlatim/ymm/YNM/KRV.md` (en çok sorulan konu)

Kapsanan: ilgili/batık maliyet, fark analizi (makine değiştirme), üret/satın al, özel sipariş, ürün hattını kapatma, kıt kaynak. Bu konular 2022/1 S3-S4, 2022/3 S3, 2024/1 S2, 2024/2 S3, 2025/3 S1-S2 ile iyi örtüşüyor.

Somut eksikler:
1. **Ek işlem / ayrılma noktası kararı yok.** Konu 3 kez soruldu; 2026/1'de 30 puan, ayrılma noktasındaki başabaş fiyat dahil. En büyük boşluk bu.
2. Özel siparişte "tüm mevcut müşterilere fiyat indirimi"nin katkı kaybı (2022/1 S4) işlenmemiş.
3. Üret/satın al örneğinde birden çok hacim ve yeni ekipman kirası gibi adım sabit maliyetin hacimle karşılaştırması (2024/1 S2a-c) yok. Nitel faktör listesi tek cümle; resmi cevap 7 madde sayıyor.
4. Bölüm kapatmada yöneticinin oran odaklı yanılgısının yorumu (2025/3 S1b) için yazılı gerekçe örneği yok.
5. "Geçerli maliyet" ve "batmış maliyet" kavram tanımları var; sınavdaki kısa tanım kalıbıyla uyumlu.

---

# BÖLÜM B — DENETİM, RAPORLAMA VE MESLEK HUKUKU (04 → DRM)

## B1. Soru soru döküm

Kısaltmalar:
- "3568" = 3568 sayılı SMMM ve YMM Kanunu
- "Tasdik Yön." = YMM'lerin Tasdik Edecekleri Belgeler... Hakkında Yönetmelik
- "Çalışma Usul Yön." = SMMM ve YMM'lerin Çalışma Usul ve Esasları Hakkında Yönetmelik
- "Disiplin Yön." = 3568 Disiplin Yönetmeliği
- "SMGE Yön." = TÜRMOB Sürekli Mesleki Geliştirme Eğitimi Yönetmeliği
- "MMK" = Mecburi Meslek Kararı

| Dönem | S | Konu | Dayanak | Puan | yaml konu → kazanım |
|---|---|---|---|---|---|
| 2022/1 | 1 | a) Haksız rekabet sayılan haller (11 madde) b) Odaların ve meslek mensubunun hakları, Haksız Rekabetle Mücadele Kurulunun görevleri c) Şikâyet süreci | Haksız Rekabet ve Reklam Yasağı Yön.; 3568 md.14; TTK md.56 | 25 (10+10+5) | MHK → haksız rekabet ve reklam yasağı |
| 2022/1 | 2 | a) Oda disiplin kurulunun oluşumu ve görevi b) Birlik disiplin kurulu c) Oda ve Birlik kurulu üyeleri hakkında soruşturma | YMM Odaları Yön.; TÜRMOB Yön.; Disiplin Yön. | 25 (10+10+5) | MHK → disiplin (oda/Birlik organları kısmen) |
| 2022/1 | 3 | Karşıt inceleme: a) tanım ve amaç b) tam tasdik ve KDV iadesinde kapsam, %80 kuralı c) tutanakta bulunması zorunlu 15 bilgi d) teyitle karşıt inceleme e) zorunlu olmadığı durumlar | 3568 Genel Tebliğleri (seri no metinde yok) | 25 (5×5) | YMM → KDV iade tasdiki / tam tasdik (**"karşıt inceleme" kazanımı yok**) |
| 2022/1 | 4 | a) YMM'nin tasdik yetkisi ve sorumluluğu b) Müteselsil sorumluluk ve takibat c) Ceza kovuşturması ile disiplin ilişkisi, VUK 153/A | 3568 md.12; Tasdik Yön. md.4; VUK mük.227; 18 Seri No'lu Genel Tebliğ; Disiplin Yön. md.30; VUK 153/A | 25 (a=10; b-c puanı görünmüyor) | YMM → YMM'nin sorumluluğu; MHK → disiplin |
| 2022/2 | 1 | a) YMM'nin vergi mevzuatı yönünden tasdik edebileceği konu ve belgeler b) Kanıt toplama | Tasdik Yön. (madde no metinde yok; içerik md.7 ile örtüşüyor) | 25 (20 = konu başına 1p; 5) | YMM → tam tasdik (kanıt toplama kazanımı yok) |
| 2022/2 | 2 | a) Mali tablo denetiminde yapılacak çalışmalar (muhasebe denetimi...) b) Denetim raporu çeşitleri (olumlu...) | **Metinde belirtilmemiş** | 25 (20+5) | RAP → tasdik raporu türleri (zayıf eşleşme; BDS 700 değil) |
| 2022/2 | 3 | SMGE: zorunluluk ve yaptırım, uzaktan / yüz yüze / diğer faaliyetlerde en az süreler | SMGE Yön. | 25 (10+5+5+5) | **YOK** |
| 2022/2 | 4 | Tam tasdik raporunun "III-Hesap İncelemeleri" ve "IV-Sonuç" bölümlerinde asgari zorunlu hususlar (ticari kârdan mali kâra geçiş) | **Metinde belirtilmemiş** | 25 (15+10) | YMM → tam tasdik / RAP → tasdik raporu türleri |
| 2022/3 | 1 | a) Meslek unvanlarının haksız kullanılması b) Tasdik ve tasdikten doğan sorumluluk | 3568 md.3, 49, 12 | 25 (10+15) | MHK (a, kazanım yok); YMM → sorumluluk (b) |
| 2022/3 | 2 | a) Denetim teknikleri b) Tekniklerin uygulanacağı dönem c) Analitik inceleme | Tasdik Yön. md.15 | 25 (10+5+10) | YMM (**denetim teknikleri kazanımı yok**) |
| 2022/3 | 3 | a) Büro edinme zorunluluğu b) Tabela asılması | Çalışma Usul Yön. md.14, 15 | 25 (15+10) | MHK → reklam yasağı (kısmen) |
| 2022/3 | 4 | a) Disiplin cezası türleri b) Yeminli sıfatını kaldırma c) Disiplin cezalarında farklı uygulama | Disiplin Yön. md.4, 8, 11 | 25 (10+5+10) | MHK → disiplin cezaları |
| 2023/1 | 1 | a) Oda disiplin kurulunun oluşumu ve görevleri b) Yasaklar | 3568 md.25, 26, 45 | 25 (10+15) | MHK |
| 2023/1 | 2 | a) Meslek mensubunun 5549 sayılı Kanunda yükümlü sayılıp sayılmadığı, yükümlülükleri b) Şüpheli işlem bildirimi | 5549 md.2/d, 4, 14, 27; Tedbirler Yön. md.4/t-u, 27–29; TÜRMOB 2015/1 Genelgesi; Danıştay İDDK 2015/330 | 25 (10+15) | **YOK** |
| 2023/1 | 3 | a) YMM'nin çalışma konuları b) İş kabulü c) Bildirim mecburiyeti | Çalışma Usul Yön. md.19, 23, 20 | 25 (10+10+5) | MHK (kazanım yok) |
| 2023/1 | 4 | a) Tasdik talebi b) SMGE katılım, yaptırım, süre c) Etik Kurulunun oluşumu ve toplantısı | Tasdik Yön. md.9; SMGE Yön. md.9–10; Etik İlkeler Yön. md.5–6 | 25 (10+10+5) | YMM (a); **YOK** (b, c) |
| 2023/2 | 1 | a) Odaların nitelikleri ve kuruluşu b) Oda genel kurul toplantısı | 3568 md.14, 15, 20 | 25 (15+10) | MHK → odalar |
| 2023/2 | 2 | a) Muhtasar ve prim hizmet beyannamesinde meslek mensubunun sorumluluğu b) MPHB kavramı | 5510 md.12, 86; GVK md.98/A; MPHB Genel Tebliği | 25 (15+10) | **YOK** |
| 2023/2 | 3 | a) Denetleme b) Tasdik sözleşmesi c) Tasdik raporu | Tasdik Yön. md.8, 10, 19 | 25 (5+10+10) | YMM → sözleşme, raporlar |
| 2023/2 | 4 | a) İşin devri ve ücret b) Personelin işe alınması c) Odanın gelirleri | Ücret Esasları Yön. md.17; TÜRMOB/Odalar Personel Yön.; YMM Odaları Yön. md.16 | 25 (5+10+10) | MHK → ücret (a), odalar (c); **YOK** (b) |
| 2023/3 | 1 | a-i) YMM olmanın özel şartları a-ii) Ücret b) 46 Sıra No'lu Tebliğde hadler ve uygulama zamanı | 3568 md.9, 46; 46 SN SMMM ve YMM Kanunu Genel Tebliği md.3 | 25 (10+5+10) | MHK → şartlar, ücret; YMM (b, kazanım yok) |
| 2023/3 | 2 | a) Beyannamelerin imzalanması ve YMM tasdik raporları b) Tasdik raporlarının elektronik ortamda gönderilmesi | VUK mük.227; 1 SN YMM Tasdik Raporlarının Elektronik Ortamda Gönderilmesi Genel Tebliği | 25 (10+15) | YMM → sorumluluk (VUK 227), raporların ibrazı |
| 2023/3 | 3 | a) İnceleme yeri ve YMM'nin yetkileri b) Hataların düzeltilmesi ve hilelerin ortaya çıkarılması c) Çalışma kâğıtları | Tasdik Yön. md.11, 16, 17 | 25 (10+5+10) | YMM (kazanımda yok; ders kısmen işliyor) |
| 2023/3 | 4 | a) Rapor türleri b) Çalışanlar listesinden silinme halleri ve kararı c) SMGE sertifikası | Defter ve Kayıtlar ile Bildirim Mecburiyeti Yön.; Çalışma Usul Yön. md.35–36; SMGE Yön. | 25 (10+10+5) | **YOK** (a, c); MHK (b, kazanım yok) |
| 2024/1 | 1 | a) Birliğin gelirleri b) Birlik genel kurulunun oluşumu c) Birlik genel kurul toplantısı | 3568 md.30, 32, 34 | 25 (5+10+10) | MHK → TÜRMOB |
| 2024/1 | 2 | a) İhaleli işlerde ve özel bina inşaatlarında SGK işlemleri b-i) İşyeri kayıtlarının incelenmesi b-ii) Rapordan doğan sorumluluk | 5510 md.59; İşyeri Kayıtlarının İncelenmesi Hk. Yön. md.5, 12, 13 | 25 (10+10+5) | **YOK** |
| 2024/1 | 3 | a) Oda bütçesi ve harcamalar b) Personel disiplin cezaları c) Hizmet sözleşmesi | YMM Odaları Yön. md.15, 17; b-c'de "Yönetmeliğin md.29 / md.48" (**hangi yönetmelik olduğu belirsiz**) | 25 (10+5+10) | MHK → odalar (kısmen); diğerleri YOK |
| 2024/1 | 4 | a) Kayıt düzeni ve belge düzeni b) Mesleki davranış c) Meslekle ve meslek onuruyla bağdaşmayan haller d) SMGE akreditasyonu | Defter ve Kayıtlar Yön. md.5–11; Etik İlkeler Yön. md.16–17; Çalışma Usul Yön. md.42; SMGE Yön. md.21 | 25 (5×5) | MHK (c, kısmen); **YOK** (a, b, d) |
| 2024/2 | 1 | Meslek sırları (değerlendirme sorusu) | 3568 md.43; yönetmelikler; Birlik kuralları | 25 | MHK → yasaklar (kısmen) |
| 2024/2 | 2 | Örnek olay: YMM Ltd. Şti.'nin %50 ortağı YMM öldü; mirasçının hissesi ne zamana kadar tasfiye edilmeli | 3568 md.45/4; Çalışma Usul Yön.; TTK md.573; MMK Genelgesi 1996/2 md.7/c | 25 | **YOK** (mesleki şirketler) |
| 2024/2 | 3 | Mecburi meslek kararlarının teklifi, belirlenmesi ve alınması: yetkili kuruluşlar ve organlar | 3568 md.14, 29, geçici md.11 vb.; MMK listesi | 25 | **YOK** |
| 2024/2 | 4 | YMM'nin çalışma konuları (değerlendirme) | 3568 md.2/B, 12 | 25 | MHK / YMM |
| 2024/3 | 1 | a) Birlik organları b) Birlik denetleme kurulu c) Birliğin gelirleri | 3568 md.31, 39, 30 | 15 (başlık) / 20 (alt toplam) **tutarsız** | MHK → TÜRMOB |
| 2024/3 | 2 | Örnek olay: VUK 153/A'ya göre sahte belgeye iştirak eden SMMM A için disiplin süreci adım adım (teminat, üç yıl alıkoyma, itiraz, ilan) | VUK 153/A, mük.355; 3568 md.48, 50/k; Disiplin Yön.; 570 SN VUK Genel Tebliği | 15 | MHK → disiplin |
| 2024/3 | 3 | Oda ve Birlik organlarının denetimi: amaç, bilgi ve belge verme, denetim konuları | Odalar ve Birlik Organlarının Denetimi Hk. Yön. md.4, 9 | 15 (5+5+5) | **YOK** |
| 2024/3 | 4 | Ruhsat verilmesi; ruhsat verilmezse tebliğ ve itiraz süreci | 3568 md.36/h; TÜRMOB Yön. md.23/h; ruhsat hükümlerini içeren 3568 yönetmeliği (adı metinde kesik) | 15 | **YOK** (ruhsat kazanımı yok) |
| 2024/3 | 5 | a) Disiplin cezaları b) Disiplin Yön. md.4 tanımları c) Takdir hakkı ve tekerrür d) İflas idaresinde YMM/SMMM | 3568 md.48; Disiplin Yön. md.4, 11; İİK md.223, 226 | 25 (10+5+5+5) | MHK → disiplin; **YOK** (d) |
| 2024/3 | 6 | Örnek olaylar: a) başka meslek mensubunun personeline iş teklifi b) başka meslek mensubu aleyhine konuşma | Meslek Ahlak Kuralları MMK md.15 ve ilgili madde | 10 (5+5) | MHK → haksız rekabet (kısmen); kazanım yok |
| 2025/1 | 1 | YMM sınav komisyonu: üye sayısı, nereden ve kimce seçildiği, aday nitelikleri, yargıda bilirkişi heyeti | 3568 md.10 | 20 | MHK (kazanım yok) |
| 2025/1 | 2 | Ücretin tanımı ve tarifenin belirlenme süreci | 3568 md.46 | 20 (5+15) | MHK → ücret tarifesi |
| 2025/1 | 3 | Meslekten çıkarma dışındaki cezalar, çıkarmayı gerektiren iki fiil, bir derece ağır/hafif ceza yetkisi | 3568 md.48 | 25 (12+10+3) | MHK → disiplin cezaları |
| 2025/1 | 4 | Çalışanlar listesinden silme: karar mercii, haller, itiraz süreleri ve mercileri | Çalışma Usul Yön. md.35, 36 | 23 (1+9+6+1+6) | MHK (kazanım yok) |
| 2025/1 | 5 | Birliğin organları | 3568 md.31 | 12 (4×3) | MHK → TÜRMOB |
| 2025/2 | 1 | YMM mesleğinin konusu ve YMM yasakları | 3568 md.2/B | 15 (9+6) | MHK → yasaklar |
| 2025/2 | 2 | Odaların gelirleri; %50 indirim | 3568 md.16 | 15 (12+3) | MHK → odalar |
| 2025/2 | 3 | Oda yönetim kurulunun görevleri | 3568 (madde no metinde yok) | 12 | MHK → odalar |
| 2025/2 | 4 | Birliğin görevleri | 3568 (madde no metinde yok) | 15 | MHK → TÜRMOB |
| 2025/2 | 5 | Birlik genel kurulunun görevleri | 3568 (madde no metinde yok) | 15 | MHK → TÜRMOB |
| 2025/2 | 6 | Meslekten çıkarma cezasını gerektiren fiiller | 3568 md.48 | 10 | MHK → disiplin |
| 2025/2 | 7 | Yönetmeliklerle düzenlenecek hususlar (14 bent) | 3568 (yönetmelik maddesi; numara metinde yok) | 18 | MHK (kazanım yok) |
| 2025/3 | 1 | Kanunun amacı | 3568 md.1 | puan yok | MHK (kazanım yok) |
| 2025/3 | 2 | Meslek mensubu olmanın genel şartları | 3568 md.4 | puan yok | MHK → şartlar |
| 2025/3 | 3 | Odaların gelirleri | 3568 md.16 | puan yok | MHK → odalar |
| 2025/3 | 4 | Odaların organları | 3568 md.17 | puan yok | MHK → odalar |
| 2025/3 | 5 | Ücret | 3568 md.46 | puan yok | MHK → ücret |
| 2026/1 | 1 | Odaların organları | 3568 md.17 | 20 (4×5) | MHK → odalar |
| 2026/1 | 2 | Meslekten çıkarma dışındaki cezalar, çıkarmayı gerektiren dört fiil, derece takdiri | 3568 md.48 | 40 (16+20+4) | MHK → disiplin |
| 2026/1 | 3 | Çalışanlar listesinden silme: karar mercii ve 6 hal | Çalışma Usul Yön. md.35 | 25 (1+24) | MHK (kazanım yok) |
| 2026/1 | 4 | Odaların gelirleri ve %50 indirim | 3568 md.16 | 15 (12+3) | MHK → odalar |

Toplam: 59 ana soru.

**Doğrulama:** 26 dosyada "BDS", "Kamu Gözetimi", "660 sayılı", "KGK" geçmiyor. "Bağımsız denetim" yalnız 2023/1 S2'de, 5549 kapsamındaki yükümlüleri sayarken geçiyor. 13 dönemde **tek bir BDS ya da KGK sorusu yok.**

## B2. yaml konularına göre frekans

| yaml konu | Soru (59) | Yaklaşık puan payı | yaml agirlik | Değerlendirme |
|---|---|---|---|---|
| MHK Meslek hukuku ve disiplin | ~37 (2025/1'den beri soruların tamamı) | **~%60** | 20 | **Çok az ağırlıklı** |
| YMM tasdik esasları | ~9 (ağırlık 2022–2023'te) | ~%16 | 22 | Biraz fazla ağırlıklı ve odağı yanlış; asıl sorulanlar karşıt inceleme, Tasdik Yön. md.7–19, VUK mük.227 ve tebliğler |
| RAP Denetim ve tasdik raporlaması | 1 (2022/2 S2b, BDS değil) | ~%2 | 20 | **Fazla ağırlıklı**; BDS 700/705/706/701 hiç sorulmadı |
| BDS Bağımsız denetim standartları | 0 | %0 | 22 | **Fazla ağırlıklı** |
| KGK ve kamu gözetimi | 0 | %0 | 16 | **Fazla ağırlıklı** |
| YOK (SMGE, 5549, 5510, etik, MMK, defter-kayıt yön., mesleki şirket, organ denetimi, ruhsat, iflas idaresi) | ~12 | ~%20 | — | **yaml'da konu yok** |

Sonuç: yaml ağırlığının %58'i (BDS + RAP + KGK) sınavın yaklaşık %2'sine karşılık geliyor.

**Eğilim:** 2022–2023'te tasdik yönetmeliği, karşıt inceleme ve SGK/MASAK gibi "meslek mensubunun diğer mevzuattaki sorumlulukları" ağırlıklıydı. 2024/2–2024/3'te uzun değerlendirme ve örnek olay soruları geldi. 2025/1 – 2026/1'de sınav **neredeyse tamamen 3568 madde ezberine** döndü: md.1, 2, 4, 10, 16, 17, 31, 46, 48, Çalışma Usul Yön. md.35–36.

**Tekrar eden çekirdek:**
- 3568 md.48 disiplin cezaları: 2022/3 (Disiplin Yön. üzerinden), 2024/3, 2025/1, 2025/2, 2026/1 (5 dönem)
- md.16 oda gelirleri: 2025/2, 2025/3, 2026/1; ayrıca 2023/2 (YMM Odaları Yön. md.16) (4 dönem)
- SMGE: 2022/2, 2023/1, 2023/3, 2024/1 (4 dönem)
- Çalışanlar listesinden silme: 2023/3, 2025/1, 2026/1 (3 dönem)
- md.46 ücret: 2023/3, 2025/1, 2025/3 (3 dönem)
- md.17 oda organları: 2025/3, 2026/1
- md.31 Birlik organları: 2024/3, 2025/1
- md.30 Birlik gelirleri: 2024/1, 2024/3
- Oda disiplin kurulu (md.25–26): 2022/1, 2023/1

Önerilen yeniden dağılım (öneri):
- MHK ikiye bölünsün:
  - "3568 Kanun, odalar ve TÜRMOB" 30
  - "Disiplin ve çalışma usul yönetmelikleri" 20
- YMM (tasdik yönetmeliği, karşıt inceleme, tebliğler) 20
- **yeni "Meslek mensubunun diğer yükümlülükleri ve TÜRMOB düzenlemeleri"** (SMGE, etik, MMK, 5549, 5510) 15
- RAP 7
- BDS 5
- KGK 3

## B3. Sorulan ama yaml'da eksik ya da zayıf DRM konuları

1. **SMGE (Sürekli Mesleki Geliştirme Eğitimi) Yönetmeliği** (yaml'da yok): 2022/2 S3 (25p), 2023/1 S4b, 2023/3 S4c, 2024/1 S4d.
2. **Çalışma Usul Yön.** (yaml'da yalnız dolaylı):
   - md.35–36 çalışanlar listesinden silme ve itiraz: 2023/3 S4b, 2025/1 S4, 2026/1 S3
   - md.14–15 büro ve tabela: 2022/3 S3
   - md.19–20–23 çalışma konuları, bildirim, iş kabulü: 2023/1 S3
   - md.42 meslek onuruyla bağdaşmayan haller: 2024/1 S4c
3. **Odaların ve Birliğin kurumsal hükümleri** (kazanımda yalnız "odalar ve TÜRMOB" var):
   - md.16 gelirler (4 kez) ve md.30 Birlik gelirleri
   - md.17 oda organları ve md.31 Birlik organları
   - md.20 / 34 genel kurul toplantıları, md.32 Birlik genel kurulunun oluşumu, md.39 denetleme kurulu, md.25–26 oda disiplin kurulu
   - oda yönetim kurulunun, Birliğin ve Birlik genel kurulunun görevleri (2025/2)
   - YMM Odaları Yön. bütçe ve harcamalar (2024/1 S3)
4. **3568'in diğer maddeleri:** md.1 amaç (2025/3), md.3 ve 49 unvanın haksız kullanılması (2022/3 S1a), md.10 sınav komisyonu ve bilirkişi heyeti (2025/1 S1), md.43 meslek sırları (2024/2 S1, 25p), yönetmeliklerle düzenlenecek hususlar (2025/2 S7, 18p), ruhsat ve itiraz (2024/3 S4).
5. **Tasdik mevzuatının sorulan ayrıntıları** (YMM kazanımlarında yok):
   - karşıt inceleme (2022/1 S3, 25p)
   - denetim teknikleri ve analitik inceleme, Tasdik Yön. md.15 (2022/3 S2)
   - kanıt toplama (2022/2 S1b)
   - inceleme yeri ve yetkiler md.11, hata ve hile md.16, çalışma kâğıtları md.17 (2023/3 S3)
   - tasdik talebi md.9 (2023/1 S4a), denetleme md.8 (2023/2 S3a)
   - tasdik konuları listesi md.7 (2022/2 S1a, 20p)
   - tam tasdik raporu bölümleri (2022/2 S4)
   - 46 SN tebliğde hadler (2023/3 S1b), 1 SN e-gönderim tebliği (2023/3 S2b)
   - 18 SN tebliğe göre müteselsil sorumluluk takibatı (2022/1 S4b)
6. **Meslek mensubunun başka kanunlardaki sorumlulukları:** 5549 MASAK ve şüpheli işlem bildirimi (2023/1 S2), 5510 MPHB ve ihaleli işlerde işyeri kaydı incelemesi (2023/2 S2, 2024/1 S2), VUK 153/A teminat ve üç yıl alıkoyma (2022/1 S4c, 2024/3 S2), İİK iflas idaresi (2024/3 S5d).
7. **TÜRMOB alt düzenlemeleri:** Etik İlkeler Yön. (2023/1 S4c, 2024/1 S4b), Meslek Ahlak Kuralları MMK (2024/3 S6), MMK'lerin alınma süreci (2024/2 S3), mesleki şirket genelgesi 1996/2 (2024/2 S2), Defter ve Kayıtlar ile Bildirim Mecburiyeti Yön. (2023/3 S4a, 2024/1 S4a), Organların Denetimi Yön. (2024/3 S3), Personel Yön. (2023/2 S4b), Ücret Esasları Yön. (2023/2 S4a).
8. **Haksız rekabet ayrıntıları:** HRMK'nin görevleri, şikâyet süreci, odaların dava hakları (2022/1 S1). Kazanım var, ayrıntı derinliği yok.

## B4. 13 dönemde hiç sorulmayan DRM konu ve kazanımları

- **BDS konusunun tamamı:** BDS 200, 315/330, 500 serisi, 240, 570.
- **RAP:** BDS 700, 705, 706, 701 (kilit denetim konuları). Tek rapor sorusu 2022/2 S2b'deki meslek mevzuatı kaynaklı "olumlu..." rapor çeşitleri.
- **KGK konusunun tamamı:** 660 sayılı KHK, Bağımsız Denetim Yönetmeliği, rotasyon, kalite güvence.
- YMM: KDV iade tasdiki kendi başına sorulmadı; yalnız karşıt incelemedeki %80 kuralıyla geçti. "Tasdik raporlarının süresi" de sorulmadı (ibraz ve e-gönderim soruldu).
- MHK: ücret tarifesinde sayısal ücret hesabı hiç sorulmadı; yalnız tarife süreci soruldu.

Not: Dersin adı "Denetim, Raporlama" olduğu için BDS ve KGK ileride sorulabilir. Bu konular silinmemeli, ağırlıkları düşürülmeli (öneri 5 / 3).

## B5. DRM soru stili

- **Biçim:** 2 saat, 4–7 soru, toplam 100 puan. 2022/1 – 2024/2'de 4×25 puan standarttı. 2024/3'ten itibaren 5–7 soru ve 10–40 puan arasında değişen ağırlıklar var.
- **Soru kalıbı:**
  - "X Kanun/Yönetmelik kapsamında '...' konusunu açıklayınız (10 Puan)". Mevzuatın adı, çoğu zaman da madde numarası soruda veriliyor (ör. 2025/1: "'Ücret' başlıklı 46'ncı maddesine göre").
  - Sayma kalıbı: "...nelerdir?", "...hallerden üçünü yazınız".
  - Süre ve merci kalıbı: "hangi tarihten itibaren kaç gün içinde kime itiraz edebilir?".
- **Örnek olay tipi** (2024/2 S2, 2024/3 S2 ve S6): Bir paragraflık senaryo (YMM Z'nin vefatı, SMMM A'nın sahte belgeye iştiraki, YMM'nin başka YMM'nin personeline iş teklifi). Cevaptan beklenenler:
  - uygulanacak mevzuatın belirlenmesi
  - sürecin adım adım (1., 2., 3. ...) anlatılması
  - açık bir sonuç (ör. "hisse 20/01/2024'e kadar tasfiye edilmeli", "kurala aykırıdır")
- **Cevap anahtarı:** Mevzuat metnine çok yakın, maddeyi aynen aktaran uzun cevaplar. 2025/3 doğrudan madde metni. Cevaba madde numarasıyla başlamak standart.
- **Mikro puanlama:**
  - Sayılan her unsur 1–5 puan. Örnek: 2025/1 S1a'da 5×2 puan; 2026/1 S2b'de her fiil 5 puan; S3b'de her hal 4 puan.
  - Süre, merci ve tarih unsurları ayrı ayrı puanlanıyor: "tebliğ tarihinden itibaren (2p) onbeş gün (2p) Birliğe (2p)".
  - "N tanesini yazınız" sorularında fazla yazana ek puan yok, eksik yazana orantılı puan var (2025/1 S3b: 1 fiil 5p, 2 fiil 10p; S4a: 3p/6p/9p).
  - 2022/2 S1a'da "her konu veya belge için 1 puan".
- Pratik soruların cevaplarında unsur başına puan dağılımı ve "kaç unsur istendiği" mutlaka yazılmalı.

## B6. Anlatım kontrolü (DRM)

### `anlatim/ymm/DRM/MHK.md` (sınavın ~%60'ı)

Kapsanan:
- md.4 genel şartlar
- md.9 özel şartlar, md.10 komisyon (kısmen), md.11 yemin
- md.2/B ve 45 yasaklar, md.43 sırlar (tek satır)
- md.14–15 odalar, md.17 organlar, md.20 ve 34 genel kurul
- md.35, 36, 38 Birlik
- md.48 cezalar (iyi), md.25 itiraz
- haksız rekabet (kısmen), md.46 tarife süreci

Somut eksikler (sınavda soruldu, derste yok):
1. **md.16 odaların gelirleri ve %50 indirim** (4 kez soruldu), md.30 Birliğin gelirleri (2 kez).
2. **Çalışma Usul Yön. md.35–36 çalışanlar listesinden silme halleri, karar mercii, itiraz süreleri** (3 kez; 2026/1'de 25p).
3. md.31 Birliğin dört organı ve md.39 Denetleme Kurulu. Organlar liste olarak verilmemiş.
4. Oda disiplin kurulunun oluşumu (md.25: 3/5 üye, yedekler, 3 yıl kıdem) ve görevi (md.26).
5. Oda yönetim kurulunun, Birliğin ve Birlik genel kurulunun **görev listeleri** (2025/2 S3–S5); Birlik genel kurulunun oluşumu (md.32).
6. md.48'deki meslekten çıkarma fiillerinden "başka meslek mensuplarının ad ve unvanlarıyla beyanname düzenleme, imzalama, gönderme" eksik.
7. md.1 amaç, yönetmeliklerle düzenlenecek hususlar listesi, md.3/49 unvanın haksız kullanılması, md.10'daki aday nitelikleri ve bilirkişi heyeti.
8. Meslek sırları (md.43) tek satır; 2024/2'de 25 puanlık değerlendirme sorusuydu.
9. HRMK'nin görevleri, şikâyet ve ön inceleme raporu süreci, odaların dava hakları (2022/1 S1).
10. SMGE, Etik İlkeler Yön., Meslek Ahlak MMK'si ve Disiplin Yön. md.30 (ceza davası ile disiplin ilişkisi) hiç yok.
11. Fazla işlenen bölüm: 2026 ücret tarifesi sayısal hesabı. Sınavda hiç sorulmadı; bu yer liste maddelerine ayrılabilir.

### `anlatim/ymm/DRM/YMM.md`

Kapsanan: Tasdik Yön. md.4, 7 (özet), 8, 9, 10, 16, 17 (saklama süresi), 18–19, 20; 3568 md.12, 45; KDV iade ücreti.

Somut eksikler:
1. **VUK mük.227 bilerek dışarıda bırakılmış** ("kaynak setinde yer almadığından"). Ancak 2023/3 S2a'da doğrudan soruldu, 2022/1 S4'te de atıf var. Kaynak setine eklenip işlenmeli.
2. **Karşıt inceleme yok** (2022/1 S3, 25p): tanım, %80 kuralı, tutanakta bulunması zorunlu bilgiler, teyit yazısıyla inceleme, zorunlu olmadığı haller.
3. **Denetim teknikleri (md.15) sayılmamış**; analitik inceleme ve tekniklerin uygulanacağı dönem yok (2022/3 S2). Kanıt toplama ilkesi yok (2022/2 S1b).
4. İnceleme yeri ve YMM'nin yetkileri (md.11) yok. Çalışma kâğıtları (md.17) yalnız saklama süresiyle var; içerik ve düzen istendi (2023/3 S3c).
5. Tasdik konuları listesi (md.7) yalnız başlık halinde. 2022/2 S1a'da 20 puan, unsur başına 1 puan verildi; listenin tamamı gerekiyor.
6. Tam tasdik raporunun bölümleri (III-Hesap İncelemeleri, IV-Sonuç; ticari kârdan mali kâra geçiş) yok.
7. 46 SN tebliğde hadler ve uygulama zamanı, 1 SN e-gönderim tebliği, 18 SN tebliğde müteselsil sorumluluk takibatı yok (ders "tebliğler kaynak setinde yok" diyor).
8. Fazla işlenen bölüm: KDV iade ücret tarifesi rakamları. Sınavda sorulmadı.

### Ek not: BDS.md, RAP.md, KGK.md

Bu üç ders sınavda 13 dönemde hiç karşılığı olmayan konuları işliyor. Ayrıntılı kontrol yapılmadı, çünkü görev sorulan konulara göre kontrol istiyordu.

---

## Özet bulgular

- YNM: yaml'ın genel ağırlığı makul. Ancak "maliyet sistemleri ve maliyet akışı" (safha, sipariş, maliyet tablosu, %14) ve "ek işlem / ayrılma noktası" (3 soru) yaml'da yok. PRF (16) ve DEG (14) fazla ağırlıklı. KRV en çok sorulan konu (%25).
- YNM BTC dersinin varsayılan GÜG sapma modeli resmi anahtardaki modelle çelişiyor; varsayılan olarak verim sapması değişken oranla hesaplanmalı.
- DRM: yaml ile sınav ters orantılı. BDS, RAP ve KGK (toplam ağırlık 58) 13 dönemde hiç sorulmadı. Sınavın ~%60'ı 3568, oda ve Birlik hükümleri ile disiplin; ~%20'si yaml'da olmayan TÜRMOB yönetmelikleri ve diğer kanunlardaki sorumluluklar.
- DRM son 4 dönemde saf madde ezberi; unsur başına mikro puan veriliyor ve süre, merci, sayı unsurları ayrıca puanlanıyor.
