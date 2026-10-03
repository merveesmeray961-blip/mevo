# Mağaza beyanları: veri güvenliği, gizlilik etiketi, içerik derecelendirmesi

Uygulama **hiçbir kişisel veri toplamaz ve hiçbir sunucuya veri göndermez** (reklam, analiz, çökme raporu, hesap yok).
Tek ağ kullanımı mağazanın kendi satın alma servisidir (Google Play Faturalandırma / App Store). Aşağıdaki cevaplar
buna göre hazırlandı; uygulamaya reklam, analiz (Firebase vb.) veya hesap eklenirse **bu belge ve gizlilik politikası
yeniden yazılmalıdır**.

## 1) Google Play Console — Uygulama içeriği

### Veri güvenliği (Data safety)

| Soru | Cevap |
|---|---|
| Uygulamanız gerekli kullanıcı veri türlerinden herhangi birini topluyor veya paylaşıyor mu? | **Hayır** |
| Toplanan tüm veriler aktarım sırasında şifreleniyor mu? | Sorulmaz (veri toplanmıyor) |
| Kullanıcılar veri silme talebinde bulunabiliyor mu? | Sorulmaz; bilgi notu: veriler yalnızca cihazdadır, uygulama kaldırılınca silinir |
| Hesap oluşturma | Yok (hesap silme adresi gerekmez) |
| Gizlilik politikası | `gizlilik.html` yayınlandığı adres |

Not: Satın alma, Google Play tarafından yürütülür; uygulama kart/ödeme bilgisine erişmez, satın alma kaydını yalnızca
cihazda doğrular. Bu nedenle "Finansal bilgiler > Satın alma geçmişi" için **toplanıyor demeyin**.

### Diğer beyanlar

| Başlık | Cevap |
|---|---|
| Reklamlar | **Reklam içermiyor** |
| Hedef kitle ve içerik | **18 yaş ve üzeri** (meslek sınavı adayları); çocuklara yönelik değil |
| Uygulamaya erişim | Tüm işlevlere özel giriş gerekmeden erişilir (hesap yok) |
| Haberler / Sağlık / Finansal özellikler / Devlet uygulaması | Hayır (muhasebe *sınav hazırlığı* içeriği finansal hizmet sunmaz; kredi, ödeme, yatırım işlevi yok) |
| COVID-19, konum, kamera, mikrofon izinleri | Yok (manifestte yalnızca `INTERNET`, `ACCESS_NETWORK_STATE`, `BILLING`) |
| Uygulama içi satın alma | Evet: tek seferlik ürün `tam_erisim` (abonelik değil) |
| Reklam kimliği (AD_ID) | Kullanılmıyor |

### İçerik derecelendirmesi (IARC anketi)

Kategori: **Referans, haber veya eğitim** (eğitim uygulaması).

| Soru | Cevap |
|---|---|
| Şiddet / kan | Hayır |
| Cinsel içerik / çıplaklık | Hayır |
| Küfür / kaba dil | Hayır |
| Uyuşturucu, alkol, tütün | Hayır |
| Kumar / simüle kumar | Hayır |
| Kullanıcılar arası iletişim / içerik paylaşımı | Hayır |
| Konum paylaşımı | Hayır |
| Dijital satın alma | Evet (uygulama içi satın alma) |
| Web'e serbest erişim | Hayır |

Beklenen sonuç: **PEGI 3 / ESRB Everyone / Türkiye: 3+** (satın alma notuyla).

## 2) App Store Connect

### Uygulama gizliliği (Privacy "nutrition label")

- "Bu uygulamanın sizinle ilgili veri toplayıp toplamadığı": **Hayır, bu uygulamadan veri toplamıyoruz** ("Data Not Collected").
- İzleme (tracking): **Hayır**. App Tracking Transparency izni gerekmez, `NSUserTrackingUsageDescription` eklenmez.
- Gizlilik politikası adresi: `gizlilik.html` yayınlandığı adres (zorunlu).
- Kullanıcı gizlilik seçenekleri adresi: boş bırakılabilir.

### Şifreleme / ihracat uyumu

`Info.plist` içinde `ITSAppUsesNonExemptEncryption = false` ayarlıdır. Uygulama yalnızca işletim sisteminin standart
HTTPS/StoreKit şifrelemesini kullanır; her yüklemede şifreleme sorusu çıkmaz. Sorulursa: "Yalnızca standart/muaf şifreleme".

### Yaş derecelendirmesi

Tüm sorulara **Yok/Hayır** → **4+**. "Uygulama içi satın alma" işaretlenir (otomatik). Kumar, sınırsız web erişimi yok.

### Uygulama içi satın alma (StoreKit)

- Tür: **Tüketilemez (Non-Consumable)**, Ürün Kimliği: `tam_erisim`, Referans adı: "Tam erişim".
- Yerelleştirme (Türkçe): Görünen ad "Tam erişim", açıklama "Günlük soru sınırını kaldırır, sınırsız deneme. Tek seferlik ödeme."
- İnceleme için ekran görüntüsü: ödeme ekranının (Ayarlar > Ücretsiz sürüm) görüntüsü.
- Aile Paylaşımı: istenirse açılabilir (kapalı önerilir).
- "Satın alımı geri yükle" düğmesi ödeme ekranındadır (Apple zorunluluğu karşılanır).

### İnceleme notu (App Review Information > Notes)

```
Uygulama hesap gerektirmez. Ücretsiz sürümde günde 20 soru ve 1 deneme sınavı vardır. Ayarlar > "Ücretsiz sürüm" veya
soru limiti dolunca açılan ekrandan tek seferlik "Tam erişim" (tam_erisim) satın alınabilir; "Satın alımı geri yükle"
düğmesi aynı ekrandadır. Uygulama TÜRMOB/TESMER ile bağlantılı değildir; sorular özgündür.
```
