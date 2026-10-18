# Konu anlatımı denetimi — Grup 1 (2026-10-18)

Kapsam: `content/anlatim/smmm/{DEN,EKO,FIN,GKY,HUK,MLY}/*.md` — 30 dosya.
Ölçüt: `docs/devir/ANLATIM_EDITOR_TALIMATI.md`, müfredat `content/mufredat/smmm.yaml`, mevzuat `content/kaynaklar/mevzuat/*.txt`.

## Genel sonuç

- 30 dosyanın tamamı `python -m pipeline.anlatim` çıktısında **tamam** (durum alanları değiştirilmedi, hepsi `kontrolde`).
- Ön bilgideki bütün `alinti` alanları, pipeline'ın otomatik alıntı denetiminden (`uretici_paketi.alinti_sorunlari`) geçti; mevzuatta bulunmayan alıntı yok.
- Tüm gövde metinlerinde rakamlı tutarlar "100.000 ₺" biçimine çevrildi (398 yer). Ön bilgideki alıntılara dokunulmadı.
- Düzeltilen olgu hatası: **2** (FIN/MKY, HUK/TIC). Düzeltilen yanlış ya da belirsiz kayıt ve ifade: 4. Eksik ya da eksik anlatılmış kazanım eklenen dosya: 1 (FIN/ALC: akreditif). Ayrıca 6 dosyada güncel mevzuata dayanan bilgi eklendi.

## Dosya bazında

### FIN/ALC — Alacaklar ve senetler
- **Eksik kazanım eklendi: akreditif.** İthalatta 159 Verilen Sipariş Avansları ile kaydı, malın gelince 153'e aktarılması, kredili akreditifte 300, ihracatçı tarafında 120 eklendi.
- Dosya 979 kelimeydi (talimattaki alt sınır 1.000). 1.624 kelimeye çıkarıldı: dış iskonto formülü, protesto, teminattaki senetler, sayısal örnekler (iskonto, KDV'li senet yenileme, şüpheli alacağın sonraki dönemde tahsili ve değersiz hale gelmesi), teminatlı alacakta karşılık örneği eklendi.
- Eklenen kural: alacak senedine reeskont uygulayan, borç senedine de uygulamak zorundadır (VUK md. 285; mevzuatta doğrulandı). 2026 şüpheli alacak sınırı 25.000 ₺ (588 sıra no.lu tebliğde doğrulandı).
- Ön bilgi değerleri çift tırnağa alındı; `yazar` alanı "mevo-ornek" yerine "mevo-editor" yapıldı.

### FIN/BOR — Yabancı kaynaklar
- Kapsamlı tahvil örneğinde tarih tutarsızlığı düzeltildi. İhraç 2.1.2026, vade 3 yıl olunca 31.12.2027'de kalan vade bir yılı aşıyordu; buna rağmen 405'ten 304'e aktarım yapılıyordu. Vade 31.12.2028 olarak yeniden kuruldu.

### FIN/DON — Dönem sonu
- Kapanış sırasındaki anlamsız "621/620 kaydı" ifadesi "dönem sonu stoku sayılarak 621 borç / 153 alacak" olarak düzeltildi.
- %30 kurumlar vergisine tabi kurumların listesi KVK md. 32'ye göre tamamlandı. **KVK md. 32/C yurt içi asgari kurumlar vergisi (%10)** notu eklendi (7524 sayılı Kanun; mevzuatta doğrulandı).

### FIN/HAZ — Hazır değerler
- THP 397 işleyişine göre kasa fazlası notu eklendi: üçüncü kişilere ödenecek kısım ödenir, bekleme süresini dolduran kalıntı 671'e aktarılır.

### FIN/MDV — Duran varlıklar
- VUK mükerrer md. 320 kuralı eklendi: azalan bakiyelerden normal amortismana geçilebilir, tersi yapılamaz. 2026 doğrudan gider yazma sınırı 12.000 ₺ doğrulandı.

### FIN/MKY — Menkul kıymetler
- **Olgu hatası düzeltildi.** Metin, 11 grubundaki hisselerden alınan kâr payı için "642 veya 649" diyordu. Oysa THP 642'yi yalnız faiz gelirleri için tanımlar. Metin "uygulamada 649" olarak düzeltildi; 642'yi kullanan ders kitapları da not edildi.

### FIN/OZK, FIN/STK
- Olgu hatası bulunmadı. Kontrol edilenler: TTK 344 ve 585 (limited şirkette %25 şartının uygulanmaması), 519 ve 521, KVK 5/1-ç, VUK 274 (%10), THP 197, 199 ve 397.

### HUK/TIC — Ticaret hukuku
- **Olgu hatası düzeltildi.** Metin, taşımada kasıt ve pervasızlık hâlinde "üç yıl" zamanaşımı olduğunu söylüyor ve bunu TTK md. 855'e bağlıyordu. Md. 855'te böyle bir hüküm yok. Doğrusu yazıldı: kaza sonucu ölüm veya bedensel zararda on yıl, diğer zararlarda bir yıl; sürenin başlangıcı da eklendi.
- Doğrulananlar: çekte başvuru hakkı zamanaşımı üç yıl (TTK md. 814), 8,33 ÖÇH (md. 882), 20/30 günlük zıya karinesi (md. 874), asgari sermaye tutarları.

### HUK/ISH — İş hukuku
- Analık izni sonrası yarım çalışma ödeneği hükmü tamamlandı (4857 md. 74; mevzuatta doğrulandı): evlat edinen kadın veya erkek işçi de yararlanır, çoğul doğumda süre 30'ar gün artar, engelli doğumda 360 gündür, bu dönemde süt izni uygulanmaz.
- 7578 sayılı Kanunla (2026) gelen değişiklikler doğrulandı: analık izni doğumdan önce 8, sonra 16 hafta; eşin doğumunda 10 gün izin; doğuma iki hafta kalıncaya kadar çalışabilme.

### HUK/SGK — Sosyal güvenlik
- PEK'e girmeyenler listesine md. 80/b-5 eklendi: iş sonu tazminatı ve kıdem tazminatı niteliğindeki toplu ödemeler.
- Doğrulananlar: 7566 sayılı Kanunla MYÖ primi %21 (%9 sigortalı + %12 işveren) ve PEK üst sınırı 9 kat; yemek bedeli istisnası 300 ₺ (7577, 2/4/2026); kısa vadeli sigorta primi %2,25; 7578 ile analık ödeneği 8 + 16 hafta; md. 102'deki idari para cezaları ve 10 yıllık zamanaşımı.

### HUK/BRC, HUK/IYU
- Olgu hatası bulunmadı. Kontrol edilenler: TBK 147 (dönemsel edimlerde 5 yıl), taksitle satışta 15 gün süre ve %30 sınırı, İYUK md. 45 ve 46'daki 7589 değişikliği ile Ek md. 1. 2026 parasal sınırlarının hesabı kontrol edildi: istinaf 55.000 ₺, temyiz 1.661.000 ₺.

### EKO/MAK
- Özetteki "reel değer = nominal artış / enflasyon" ifadesi yanlış formüldü; (1 + nominal) / (1 + enflasyon) − 1 olarak düzeltildi.

### EKO/MIK, EKO/DIS
- Bütün sayısal örnekler (esneklik, vergi yükü ve ölü ağırlık kaybı, tekel ve Lerner endeksi, ödemeler dengesi, karşılaştırmalı üstünlük) elle yeniden hesaplandı; hata yok.

### MLY/BUT, MLY/KGH, MLY/VTE
- Olgu hatası yok. Kontrol edilenler: Anayasa md. 161 süreleri, 5018 md. 13'teki ilke harfleri, 5510 md. 81/a'daki %21 oranı, 2026 GVK tarifesi (332 seri no.lu tebliğle karşılaştırıldı) ve GVK md. 123 mahsup örneği.

### DEN (BDY, RAP, KNT, RSK, ICK, KAL, PRG)
- Olgu hatası yok. Kontrol edilenler:
  - Bağımsız Denetim Yönetmeliği: rotasyon (10 yılda 7 yıl görev, 3 yıl ara), kilit yöneticiliğe geçişte 2 yıl yasak, sorumlu denetçi şartları (15/3 ve 10/2 yıl), rapor teslimi en az 20 gün önce, gelir bildirimi 15 Mayıs, KGK incelemesi 3 ya da 6 yılda bir.
  - KYS 1 ve BDS 220 (Revize) yürürlük tarihleri.
  - Etik Kurallar: %15 ücret eşiği, 7 yıl görev ve 5–3–2 yıllık ara verme süreleri.
- Yalnız tutar biçimi güncellendi.

### GKY (TUR, MAT, TAR, ING)
- Olgu hatası yok. İnkılap tarihi tarihleri tek tek kontrol edildi; matematik örnekleri yeniden hesaplandı.

## Emin olunamayan noktalar (kaynakla doğrulanamayanlar)

1. **FIN/ALC, akreditif kaydı.** THP'de "akreditif" geçmiyor. 159 hesabıyla kayıt, ders kitaplarındaki yaygın uygulamaya dayanıyor. Bazı kaynaklar bloke tutarı 102'nin alt hesabında izliyor. Uzman onayı önerilir.
2. **FIN/ALC ve STK, şüpheli alacağın aynı dönemde tahsili.** Karşılığın 654'e alacak yazılarak kapatılması yaygın ders kitabı yaklaşımı. THP metninde bu ayrım açıkça yer almıyor.
3. **HUK/TIC, basit yargılama sınırı.** TTK md. 4'teki "bir milyon TL" sınırı HMK ek md. 1'e göre yeniden değerleniyor. 2026 tutarı mevzuat klasöründe yok; metinde rakam verilmedi.
4. **HUK/IYU, 2026 parasal sınırları.** 55.000 ₺ ve 1.661.000 ₺ kanundaki yönteme göre hesaplandı. Danıştay'ın ilan ettiği resmî tutarlar klasörde yok; karşılaştırılmalı.
5. **DEN/KAL, rotasyon sayımı.** Kısmi aradan sonra süre sayımının sürmesine ilişkin anlatım Etik Kurallar 540'ın genel mantığına uygun. Çözümlü örnekteki adımlar ilgili paragraflarla birebir eşleştirilmedi.
