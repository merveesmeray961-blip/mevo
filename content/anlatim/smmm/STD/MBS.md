---
ders: "STD"
konu: "MBS"
baslik: "Muhasebe bilgi sistemi"
durum: "kontrolde"
yazar: "mevo-editor"
kaynaklar:
  - mevzuat: "BDS 315 Önemli Yanlışlık Risklerinin Belirlenmesi ve Değerlendirilmesi"
    madde: "Ek 3 prg. 20 (görevler ayrılığı)"
    alinti: "İşlemlerin yetkilendirilmesi, kaydedilmesi ve varlıkların korunmasına ilişkin sorumlulukların farklı kişilere verilmesi"
  - mevzuat: "BDS 315 Önemli Yanlışlık Risklerinin Belirlenmesi ve Değerlendirilmesi"
    madde: "Ek 3 prg. 20 (fiziksel veya mantıksal kontroller)"
    alinti: "Bilgisayar programlarına ve veri dosyalarına erişim yetkisi (diğer bir ifadeyle, mantıksal erişim)."
  - mevzuat: "BDS 315 Önemli Yanlışlık Risklerinin Belirlenmesi ve Değerlendirilmesi"
    madde: "Ek 3 prg. 20 (görevler ayrılığı örneği)"
    alinti: "kredili satışlara yetki veren bir yönetici, alacak hesaplarının veya nakit makbuzların tutulmasından sorumlu değildir"
  - mevzuat: "6102 sayılı Türk Ticaret Kanunu"
    madde: "md. 65/3"
    alinti: "Bir yazım veya kayıt, önceki içeriği belirlenemeyecek şekilde çizilemez ve değiştirilemez."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 231/5"
    alinti: "Fatura, malın teslimi veya hizmetin yapıldığı tarihten itibaren azami yedi gün içinde düzenlenir."
  - mevzuat: "213 sayılı Vergi Usul Kanunu"
    madde: "md. 219/a"
    alinti: "Bu gibi kayıtların on günden fazla geciktirilmesi caiz değildir."
  - mevzuat: "TFRS 15 Müşteri Sözleşmelerinden Hasılat"
    madde: "paragraf 31"
    alinti: "Bir varlığın kontrolü müşterinin eline geçtiğinde (veya geçtikçe) varlık devredilmiş olur."
---
## Bu konuda neler öğreneceksin

- Muhasebe bilgi sisteminin (MBS) bileşenlerini, alt sistemlerini ve işlem döngülerini
- Ekonomik olayın belgeden kayda, kayıttan finansal rapora dönüşümünü ve yasal kayıt kurallarını
- Belge akış şeması, sistem akış şeması ve veri akış diyagramını; sembolleri ve çizim kurallarını
- Genel BT kontrolleri ile uygulama kontrollerini, erişim kontrollerini ve görevler ayrılığını
- Satış-tahsilat sürecinin adımlarını, belgelerini, risklerini, kontrollerini ve muhasebe kayıtlarını

## 1. Muhasebe bilgi sistemi ve bileşenleri

**Muhasebe bilgi sistemi**, işletmenin ekonomik olaylarına ilişkin verileri toplayan, işleyen, saklayan ve karar alıcılara bilgi olarak sunan; insan, prosedür, veri, yazılım, donanım ve iç kontrollerden oluşan bütündür. Sistem yalnızca muhasebe programı değildir.

**Veri** işlenmemiş ham olgudur (tek bir faturadaki tutar). **Bilgi** ise işlenerek karar için anlam kazanmış veridir (müşteri bazında vadesi geçmiş alacak raporu). Bilginin değeri ihtiyaca uygunluğuna, güvenilirliğine, zamanlılığına ve anlaşılabilirliğine bağlıdır.

MBS'nin altı bileşeni sınavda sık sorulur:

1. **Kullanıcılar (insanlar):** Sistemi işleten ve bilgiyi kullanan kişiler.
2. **Prosedürler ve talimatlar:** Verinin nasıl toplanıp işleneceğini belirleyen manuel ve otomatik kurallar.
3. **Veri:** İşletmenin faaliyetlerine ilişkin kayıtlar (müşteri ana dosyası, işlem dosyaları).
4. **Yazılım:** Veriyi işleyen programlar (ERP, muhasebe paketi).
5. **BT altyapısı:** Donanım, ağ, sunucular.
6. **İç kontroller:** Varlıkları ve veriyi koruyan, kayıtların doğruluğunu sağlayan önlemler.

İşlemler **işlem döngüleri** halinde incelenir:

| Döngü | Kapsadığı faaliyetler |
|---|---|
| Gelir (satış-tahsilat) | Sipariş, sevk, faturalama, alacak, tahsilat |
| Harcama (satın alma-ödeme) | Satın alma talebi, sipariş, mal kabul, borç, ödeme |
| Üretim | Hammadde kullanımı, işçilik, maliyetleme |
| İnsan kaynakları (bordro) | İşe alma, puantaj, ücret hesaplama, ödeme |
| Finansman | Kredi, sermaye, faiz ve kâr payı ödemeleri |
| Genel defter ve raporlama | Diğer döngülerden gelen kayıtların toplanması, mali tablolar |

Ana dosya (master file) kalıcı verileri tutar (müşteri adı, kredi limiti, fiyat listesi); işlem dosyası (transaction file) dönem içindeki hareketleri tutar (günlük satışlar). Ana dosyadaki yetkisiz bir değişiklik (örneğin fiyat listesinin değiştirilmesi) sonraki bütün işlemleri etkilediği için daha sıkı korunur.

> **Sınav ipucu:** "MBS sadece bilgisayar programıdır" ifadesi yanlıştır. İnsan, prosedür, veri, yazılım, altyapı ve iç kontrol birlikte sistemi oluşturur.

## 2. Belgeden finansal rapora: kayıt süreci ve yasal kurallar

Bir işlemin sistemdeki yolculuğu: ekonomik olay → kaynak belge → belge kontrolü → hesap kodlama → yevmiye kaydı → büyük deftere aktarma → mizan → mutabakat ve dönem sonu işlemleri → finansal tablolar.

**Kaynak belge** işlemin gerçekleştiğini kanıtlar (sipariş formu, sevk irsaliyesi, fatura, banka dekontu). Her belge farklı bir olguyu kanıtlar: sipariş talebi, irsaliye malın gönderildiğini, fatura bedelin istendiğini gösterir.

Yasal kayıt kuralları MBS tasarımını doğrudan etkiler:

- **Kayıt süresi (VUK md. 219):** İşlemlerin deftere kaydının on günden fazla geciktirilmesi caiz değildir. Muhasebe fişi gibi yetkili imzası taşıyan belgelere dayanarak kayıt yapan işletmelerde de işlemler esas defterlere en geç 45 gün içinde geçirilmelidir.
- **Kayıtların değiştirilemezliği (TTK md. 65/3):** Bir kayıt, önceki içeriği belirlenemeyecek şekilde çizilemez ve değiştirilemez. Elektronik sistemde bu kural, hatalı kaydın silinmesi yerine düzeltme (ters) kaydı yapılmasını ve değişiklik geçmişinin tutulmasını gerektirir.
- **Saklama süresi:** TTK md. 82'ye göre ticari defterler ve kayıtların dayandığı belgeler 10 yıl, VUK md. 253'e göre defter ve belgeler izleyen takvim yılından başlayarak 5 yıl saklanır. Uygulamada uzun olan TTK süresi esas alınır.

**Mutabakat**, iki veri kaynağının karşılaştırılmasıdır: banka ekstresi ile 102 hesabı, müşteri cari hesabı ile müşterinin kendi kaydı, stok sayımı ile 153 hesabı. Borç ve alacak toplamlarının eşit olması (mizan denkliği) kaydın doğru olduğunu kanıtlamaz; yanlış hesaba eşit tutarda yapılan kayıt mizan denkliğini bozmaz.

**Denetim izi**, bir işlemin kaynak belgeden finansal tabloya ve tablodan geriye kaynak belgeye kadar izlenebilmesidir. Belge numarası, tarih, kullanıcı adı, onay kaydı ve değişiklik günlüğü (log) denetim izini oluşturur.

## 3. Akış şeması

**Akış şeması**, bir sürecin adımlarını, belgelerin hareketini ve karar noktalarını standart sembollerle gösteren çizimdir. Türleri:

- **Belge akış şeması:** Belgelerin birimler arasındaki hareketini gösterir; iç kontrol değerlendirmesinde en çok kullanılandır.
- **Sistem akış şeması:** Girdi, işleme, depolama ve çıktının bilgisayar sistemindeki akışını gösterir.
- **Program akış şeması:** Bir programın mantıksal adımlarını gösterir.
- **Veri akış diyagramı (VAD):** Verinin kaynağını, varış yerini, işlendiği süreçleri ve depolandığı yerleri gösterir; işin "kim tarafından, hangi araçla" yapıldığını değil, "ne yapıldığını" (mantıksal akışı) anlatır.

| Sembol | Anlamı |
|---|---|
| Oval (terminal) | Başlangıç, bitiş veya sistem dışındaki taraf |
| Dikdörtgen | İşlem, faaliyet (bilgisayarda işleme) |
| Yamuk | Manuel işlem (elle yapılan iş) |
| Elmas | Karar noktası (evet/hayır dalları) |
| Paralelkenar | Veri girişi veya çıktısı |
| Alt kenarı dalgalı dikdörtgen | Belge (fatura, irsaliye, rapor) |
| Üst üste belgeler | Bir belgenin birden fazla nüshası |
| Ters üçgen | Dosyalama, arşivleme (yanına sıralama ölçütü yazılır) |
| Silindir | Veri tabanı, disk depolama |
| Küçük daire | Aynı sayfa içindeki bağlantı |
| Beşgen (ev biçimi) | Başka sayfaya bağlantı |
| Ok | Akışın yönü |

Çizim kuralları:

1. Şema, birimlere ayrılmış sütunlar (her departman bir sütun) halinde soldan sağa ve yukarıdan aşağıya çizilir.
2. Belgenin her nüshası numaralanır ve her nüshanın nereye gittiği gösterilir. Bir belge şemada nedensiz "kaybolmamalı"; ya dosyalanır ya başka birime gider.
3. Her karar elmasından en az iki çıkış olmalıdır; "hayır" dalının nereye gittiği gösterilmezse süreç tasarımı eksik kalır.
4. Kontrol noktaları (onay, karşılaştırma) açıkça işaretlenir: kontrolü kimin, hangi belgeyle, ne zaman yaptığı görünmelidir.

> **Sık yapılan hata:** Belge akış şemasını veri akış diyagramıyla karıştırmak. Akış şeması fiziksel akışı (hangi birim, hangi belge, hangi nüsha) gösterir; VAD mantıksal akışı (kaynak, süreç, veri deposu) gösterir. Ayrıca bir sürecin şemada gösterilmesi, kontrolün etkili çalıştığını kanıtlamaz.

## 4. Erişim kontrolleri ve görevler ayrılığı

Bilgi sistemindeki kontroller iki gruba ayrılır:

- **Genel BT kontrolleri:** Tüm uygulamaların sağlıklı çalışmasını destekler. Erişim yönetimi, program değişikliği yönetimi, BT operasyonları (yedekleme, iş sürekliliği) bu gruptadır.
- **Uygulama (bilgi işleme) kontrolleri:** Belirli bir uygulamadaki işlemlere uygulanır. Girdi kontrolleri (zorunlu alan, format, limit ve makullük testi, sıra numarası kontrolü, kontrol hanesi), işleme kontrolleri (toplu işlem toplamları, eşleştirme) ve çıktı kontrolleri (rapor dağıtımının sınırlanması, mutabakat) örnektir.

Genel BT kontrolleri zayıfsa, en iyi tasarlanmış uygulama kontrolüne de güvenilemez: yetkisiz kişi kredi limiti kuralını değiştirebiliyorsa limit kontrolü anlamını yitirir.

**Erişim kontrolü** iki boyutludur. **Fiziksel erişim**, varlıklara ve kayıtlara (kasa, depo, sunucu odası, belge arşivi) ulaşmayı sınırlar. **Mantıksal erişim**, bilgisayar programlarına ve veri dosyalarına erişim yetkisidir. Mantıksal erişimin unsurları:

1. **Tanımlama ve kimlik doğrulama:** Her kullanıcıya kişiye özel hesap verilir. Kimlik; bilinen bir şeyle (parola), sahip olunan bir şeyle (telefona gelen kod, akıllı kart) veya biyometrik özellikle doğrulanır. İki farklı türün birlikte kullanılması çok faktörlü doğrulamadır. Ortak (paylaşılan) kullanıcı hesabı denetim izini yok eder.
2. **Yetkilendirme:** Kullanıcı yalnızca görevinin gerektirdiği işlemleri yapabilmelidir (**en az yetki ilkesi**). Yetkiler genellikle rol bazında ve bir yetki matrisiyle tanımlanır; "görüntüleme", "giriş", "onay" ve "değiştirme" yetkileri ayrı ayrı verilir.
3. **Kullanıcı yaşam döngüsü:** İşe girişte onaylı talep ile hesap açılır; görev değişikliğinde eski yetkiler kaldırılır; işten ayrılışta hesap derhal kapatılır. Yetkiler dönemsel olarak gözden geçirilir.
4. **Ayrıcalıklı hesaplar:** Sistem yöneticisi gibi geniş yetkili hesaplar sınırlı sayıda kişiye verilir ve faaliyetleri izlenir. BT personelinin muhasebe kaydı girebilmesi görevler ayrılığını bozar.
5. **İzleme:** Başarısız giriş denemeleri, mesai dışı işlemler ve ana dosya değişiklikleri log kayıtlarından raporlanıp incelenir.

Kontroller işlevine göre **önleyici** (parola, onay limiti), **tespit edici** (mutabakat, istisna raporu) ve **düzeltici** (yedekten geri yükleme) olarak sınıflandırılır.

**Görevler ayrılığı**, işlemlerin yetkilendirilmesi, kaydedilmesi ve varlıkların korunmasına ilişkin sorumlulukların farklı kişilere verilmesidir. Amaç, bir kişinin hem hata veya hile yapıp hem de bunu saklayabileceği konuma gelmesini önlemektir. BDS 315'teki örneğe göre kredili satışlara yetki veren yönetici, alacak hesaplarının veya nakit makbuzların tutulmasından sorumlu olmamalıdır; aksi halde tespit edilemeyen sahte satış ortaya çıkabilir. Satış görevlisi de fiyat dosyasını veya komisyon oranlarını değiştirememelidir.

Küçük işletmelerde ideal ayrım mümkün olmayabilir. Bu durumda **telafi edici kontrol** (örneğin işletme sahibinin banka mutabakatını bizzat incelemesi, fiyat değişikliklerinin bağımsız biri tarafından dönemsel gözden geçirilmesi) kurulur.

> **Sınav ipucu:** Görevler ayrılığında ayrılması gereken üç işlev: yetkilendirme (onay), kayıt tutma ve varlığın korunması (saklama). Soruda aynı kişinin "tahsilatı alıp müşteri hesabına kaydettiği" bir durum varsa, zayıflık budur.

## 5. Satış-tahsilat süreci

Satış-tahsilat (gelir) döngüsünün adımları, belgeleri ve kontrolleri:

| Adım | Sorumlu birim | Belge | Temel kontrol | Önlenen risk |
|---|---|---|---|---|
| Sipariş alma | Satış | Müşteri siparişi, satış emri | Onaylı fiyat listesi, müşteri ana dosyası | Yetkisiz fiyat ve iskonto |
| Kredi onayı | Kredi/finans | Onaylı satış emri | Kredi limiti kontrolü | Tahsil edilemeyen alacak |
| Sevkiyat | Depo, sevkiyat | Sevk irsaliyesi | Onaylı emir olmadan sevk yapılmaması | Yetkisiz mal çıkışı |
| Faturalama | Faturalama | Satış faturası | Sipariş-irsaliye-fatura eşleştirmesi, sıra numarası takibi | Faturalanmayan sevk (tamlık), hayali satış (gerçekleşme) |
| Kayıt | Muhasebe (alacaklar) | Muhasebe fişi | Fatura toplamı ile kayıt toplamının karşılaştırılması | Yanlış tutar (doğruluk), yanlış dönem (hesap kesimi) |
| Tahsilat | Finans/hazine | Banka dekontu, tahsilat makbuzu, çek | Tahsilatı alan ile kaydı yapanın farklı olması | Tahsilatın zimmete geçirilmesi |
| İzleme | Muhasebe, yönetim | Alacak yaşlandırma raporu, mutabakat mektubu | Vadesi geçenlerin takibi, cari mutabakat | Değer düşüklüğünün gözden kaçması |

Süreçteki yasal ve muhasebe noktaları:

- **Fatura süresi (VUK md. 231/5):** Fatura, malın teslimi veya hizmetin yapıldığı tarihten itibaren azami yedi gün içinde düzenlenir; bu süreden sonra düzenlenen fatura hiç düzenlenmemiş sayılır.
- **Hasılatın kaydı (TFRS 15 prg. 31):** Hasılat, malın kontrolü müşteriye devredildiğinde kaydedilir. Belirleyici olan fatura tarihi değil, kontrolün devridir. 31 Aralık'ta teslim edilip 3 Ocak'ta faturalanan satış, hasılat bakımından Aralık dönemine aittir; bu bir **hesap kesimi** kontrolüdür.
- **Kullanılan hesaplar:** 120 Alıcılar, 121 Alacak Senetleri, 101 Alınan Çekler, 102 Bankalar, 340 Alınan Sipariş Avansları (teslimden önce alınan bedel), 600 Yurtiçi Satışlar, 610 Satıştan İadeler (-), 611 Satış İskontoları (-), 391 Hesaplanan KDV, 621 Satılan Ticari Mallar Maliyeti (-), 128 Şüpheli Ticari Alacaklar ve 129 Şüpheli Ticari Alacaklar Karşılığı (-).

### Çözümlü örnek

İşletme 12 Mart'ta müşterisine birim satış fiyatı 400 TL olan 200 adet ticari malı vadeli satıyor. KDV oranı %20, malın birim maliyeti 250 TL'dir; sürekli envanter yöntemi kullanılmaktadır. 10 Nisan'da müşteri 60.000 TL'yi havale ediyor, kalan tutar için çek veriyor.

- Satış tutarı: 200 × 400 = 80.000 TL
- KDV: 80.000 × %20 = 16.000 TL
- Alacak: 80.000 + 16.000 = 96.000 TL
- Satılan malın maliyeti: 200 × 250 = 50.000 TL; brüt satış kârı: 80.000 − 50.000 = 30.000 TL
- Çek tutarı: 96.000 − 60.000 = 36.000 TL

| Tarih | Hesap | Borç (TL) | Alacak (TL) |
|---|---|---:|---:|
| 12 Mart | 120 Alıcılar | 96.000 | |
| | 600 Yurtiçi Satışlar | | 80.000 |
| | 391 Hesaplanan KDV | | 16.000 |
| 12 Mart | 621 Satılan Ticari Mallar Maliyeti | 50.000 | |
| | 153 Ticari Mallar | | 50.000 |
| 10 Nisan | 102 Bankalar | 60.000 | |
| | 101 Alınan Çekler | 36.000 | |
| | 120 Alıcılar | | 96.000 |

Kontrol bakışıyla: 12 Mart kaydı irsaliye ve faturayla eşleştirilmeli, 10 Nisan kaydı banka ekstresiyle mutabık kılınmalı, çek ise kasada veya portföyde fiziksel olarak korunmalıdır. Müşteri bakiyesi 96.000 − 96.000 = 0 olmalıdır.

> **Sık yapılan hata:** Tahsilatı yeni bir gelir gibi kaydetmek. Vadeli satışta gelir satış anında doğar; tahsilat yalnızca alacağı kapatır (120 hesabı alacaklanır). Satış kaydında KDV'yi 191 İndirilecek KDV hesabına yazmak da yanlıştır; satıcı için doğru hesap 391 Hesaplanan KDV'dir.

## Özet

- MBS; insan, prosedür, veri, yazılım, BT altyapısı ve iç kontrolden oluşur; işlemler gelir, harcama, üretim, bordro, finansman ve raporlama döngüleriyle incelenir.
- Kayıtlar VUK md. 219'a göre on günü aşmayacak şekilde yapılır; TTK md. 65/3 kayıtların iz bırakmadan değiştirilmesini yasaklar; belgeler TTK'ya göre 10, VUK'a göre 5 yıl saklanır.
- Akış şeması fiziksel belge akışını, VAD mantıksal veri akışını gösterir; karar elmasının iki dalı ve her belge nüshasının varış yeri gösterilmelidir.
- Genel BT kontrolleri (erişim, değişiklik yönetimi, operasyon) uygulama kontrollerinin güvenilirliğinin ön şartıdır.
- Mantıksal erişim; kişiye özel hesap, güçlü kimlik doğrulama, en az yetki ilkesi, yetki gözden geçirme ve log izlemesiyle sağlanır.
- Görevler ayrılığı yetkilendirme, kayıt ve varlık koruma işlevlerini ayırır; küçük işletmede telafi edici kontrol kurulur.
- Satış-tahsilat sürecinde sipariş-irsaliye-fatura eşleştirmesi, kredi onayı, sıra numarası takibi ve banka mutabakatı temel kontrollerdir; fatura teslimden itibaren en geç 7 günde düzenlenir, hasılat kontrolün devrinde kaydedilir.
