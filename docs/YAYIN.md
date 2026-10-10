# Yayın rehberi (Mevo SMMM)

Bu rehber yazılımcı olmayan biri için yazıldı. Önce **"0. Başlamadan önce"** bölümünü oku; sonra Android (Google Play)
için **A**, iPhone/iPad için **B**, yeni soru eklemek ve güncelleme çıkarmak için **C** bölümüne geç.

Uygulama bilgileri: ad **Mevo SMMM**, paket/bundle kimliği **`app.mevo.smmm`**, satın alma ürünü **`tam_erisim`**
(tek seferlik, tüketilemez). Fiyatı mağazada sen belirlersin; uygulamada fiyat yazmaz, mağazadan okunur.

---

## 0. Başlamadan önce

### 0.1 Elindeki dosyalar (bu bilgisayarda; git'e girmez)

| Ne | Nerede |
|---|---|
| Mağazaya yüklenecek paket (AAB) | `app/build/app/outputs/bundle/release/app-release.aab` |
| Elle kurulabilir deneme dosyası (APK) | `app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (çoğu yeni Android telefon) |
| **Yükleme anahtarı** (keystore) | `.gizli/upload-keystore.jks` |
| Anahtar parolaları | `.gizli/ANAHTAR_BILGISI.txt` |
| Anahtar ayar dosyası | `app/android/key.properties` |

> **UYARI — anahtarı yedekle.** `.gizli` klasörünü (anahtar + parola dosyası) en az iki güvenli yere kopyala (USB, şifreli
> bulut). Bu klasör bilerek git'e eklenmedi; bu bilgisayar silinirse anahtar da gider. Anahtarı kaybedersen Play
> Console'dan "yükleme anahtarını sıfırla" talebi açabilirsin (Play Uygulama İmzalama açıksa; 1–2 hafta sürebilir), ama
> yedeği olması çok daha rahattır. Anahtarı ve parolayı **kimseyle paylaşma**, e-postayla gönderme.

### 0.2 Gizlilik politikası sayfasını internete koy (iki mağaza da ister)

Dosya: `docs/magaza/gizlilik.html` (tek dosya, her yerde açılır). Önce içindeki **`[yayın öncesi eklenecek]`**
yerlerine veri sorumlusunun adını ve iletişim e-postasını yaz (uygulama içindeki `app/lib/ekranlar/yasal.dart` metninde de
aynı yerler var; ikisini de doldur). Sonra dosyayı herkese açık bir adrese koy. En kolay yollar:

- **Netlify Drop:** https://app.netlify.com/drop adresine dosyayı sürükle → `https://....netlify.app` adresi verir
  (dosyanın adını `index.html` yap). Ücretsiz.
- **GitHub Pages:** Depo herkese açıksa Settings → Pages → Branch: `main`, klasör: `/docs` → adres
  `https://KULLANICI.github.io/DEPO/magaza/gizlilik.html`. (Özel depoda ücretli plan gerekir.)

Aldığın adresi not et; aşağıda "Gizlilik politikası adresi" istenince yapıştıracaksın.

### 0.3 Mağaza metinleri

Hazır metinler: `docs/magaza/MAGAZA_METNI.md` (açıklamalar, anahtar kelimeler) ve
`docs/magaza/VERI_GUVENLIGI_VE_DERECELENDIRME.md` (veri güvenliği, gizlilik etiketi ve yaş derecelendirmesi cevapları).
İlgili kutuya kopyala–yapıştır yap.

### 0.4 Ekran görüntüleri ve simge

> **Hazır:** `docs/magaza/gorseller/` klasöründe 7 telefon ekran görüntüsü (1080×1920, başlıklı), öne çıkan görsel
> (1024×500) ve 512×512 simge var; doğrudan Play Console'a yükleyebilirsin. Aşağıdaki adımlar yenilemek istersen içindir.

- Telefonda uygulamayı aç, 5–8 ekran görüntüsü al (Bugün, Dersler, soru + çözüm, deneme sonucu, İstatistik, tam erişim ekranı).
- Tablet görüntüsü (7" ve 10") eklersen tabletlerde daha iyi görünür; iPad için Apple **zorunlu** tutar.
- Simge: `app/assets/ikon/ikon.png` (1024×1024). Play için 512×512'ye küçült; Apple 1024×1024'ü uygulamanın içinden alır.
- Play "öne çıkan görsel" 1024×500: Canva ile teal (#0F6B5C) zemin üzerine "Mevo SMMM" yazman yeterli.

---

## A) Google Play (Android)

Maliyet: Geliştirici hesabı **25 $ (tek sefer)**.

### A1. Geliştirici hesabı

1. https://play.google.com/console adresine Google hesabınla gir → "Geliştirici hesabı oluştur" → **Kişisel** hesap seç.
2. Kimlik doğrulaması ister (kimlik fotoğrafı, adres, telefon). Birkaç gün sürebilir; **hemen başla.**
3. 25 $'ı öde.

> **Önemli kural:** Kişisel hesaplar, uygulamayı herkese açmadan önce **en az 12 test kullanıcısıyla 14 gün üst üste
> kapalı test** yapmak zorundadır. Bu yüzden A5'i erken başlat; takvimi buna göre planla.

### A2. Uygulamayı oluştur

1. Play Console → **Uygulama oluştur**.
2. Ad: **Mevo SMMM** · Varsayılan dil: **Türkçe** · Uygulama (oyun değil) · **Ücretsiz** (uygulama içi satın alma var).
3. Beyanları işaretle (geliştirici ilkeleri, ABD ihracat yasaları) → Oluştur.

### A3. İlk AAB'yi yükle (kapalı test yoluyla)

1. Sol menü → **Test et ve yayınla → Testler → Kapalı test** → "Kapalı test kanalı" oluştur (ad: `Arkadaslar`).
2. "Yeni sürüm oluştur". **Play Uygulama İmzalama**'yı kabul et (Google uygulamanı kendi anahtarıyla imzalar; sen yalnızca
   yükleme anahtarını kullanırsın — bu yüzden `.jks` dosyasını mağazaya vermen gerekmez).
3. `app-release.aab` dosyasını sürükleyip bırak. Sürüm adı otomatik gelir (1.0.0).
4. Sürüm notu: `İlk sürüm: konu konu çalışma, gerçek kurallarla deneme, yanlış defteri, aralıklı tekrar ve istatistik.`
5. Kaydet → İncele → **Kapalı testte yayınlamaya başla** (henüz test kullanıcısı eklemeden de kaydedilir).

### A4. Uygulama içeriğini doldur (Pano'daki "Uygulamanızı kurun" listesi)

Hepsini `docs/magaza/VERI_GUVENLIGI_VE_DERECELENDIRME.md` dosyasından cevapla:

- **Gizlilik politikası:** 0.2'deki adres.
- **Uygulama erişimi:** Tüm işlevler özel giriş olmadan kullanılabilir.
- **Reklamlar:** Reklam yok.
- **İçerik derecelendirmesi:** Anketi doldur (kategori: Referans/eğitim; hepsi Hayır).
- **Hedef kitle:** 18 ve üzeri. Çocuklara yönelik değil.
- **Veri güvenliği:** Veri toplamıyor / paylaşmıyor.
- **Finansal özellikler, Sağlık, Devlet uygulaması, Haberler:** Hayır / geçerli değil.
- **Mağaza girişi (Ana mağaza girişi):** `MAGAZA_METNI.md`'deki ad, kısa ve uzun açıklama; simge 512×512; öne çıkan görsel; ekran görüntüleri.
  Kategori: **Eğitim**. İletişim e-postası ve (varsa) web sitesi.

### A5. Uygulama içi ürünü tanımla — `tam_erisim`

> Ürün, **uygulamanın en az bir sürümü Play Console'a yüklendikten sonra** tanımlanabilir (A3'ü önce yap).

1. Sol menü → **Para kazanma → Ürünler → Uygulama içi ürünler → Ürün oluştur**.
2. **Ürün kimliği: `tam_erisim`** (birebir; sonradan değiştirilemez). Ad: **Tam erişim**. Açıklama:
   `Günlük soru sınırını kaldırır, sınırsız deneme. Tek seferlik ödeme.`
3. Fiyat belirle (TL; diğer ülkeler otomatik çevrilir). Kaydet → **Etkinleştir** (durum "Etkin" olmalı).
4. Not: Bu tek seferlik ürün (abonelik değil). Aboneliklere dokunma.

### A6. Test kullanıcıları ve 14 günlük kapalı test

1. Kapalı test kanalı → **Test kullanıcıları** → e-posta listesi oluştur → **en az 12** kişinin Gmail adresini ekle
   (muhasebeci, arkadaş, stajyer adaylar).
2. Kaydet; **"Katılma bağlantısı"nı** kopyalayıp bu kişilere gönder. Her biri bağlantıyı açıp "Test kullanıcısı ol" der
   ve uygulamayı Play Store'dan indirir.
3. **14 gün boyunca** en az 12 kişinin testte *kayıtlı kalması* gerekir (aktif kullanmaları da iyi olur). Süreyi
   Pano'daki "Üretime erişim iste" sayacı gösterir.
4. **Ödemeyi paranı harcamadan dene:** Ayarlar → **Lisans testi** bölümüne kendi Gmail adresini ekle. Bu hesaplarla
   satın alma "test kartı"yla yapılır, ücret alınmaz. Telefonda uygulamayı Play Store'dan (test bağlantısıyla) kur;
   Ödeme ekranında **gerçek fiyatın göründüğünü**, satın alınca sınırların kalktığını ve uygulamayı silip
   yeniden kurunca **"Satın alımı geri yükle"nin** çalıştığını kontrol et.
   (APK'yı elle kurarsan Play'den bağımsız olduğu için satın alma çalışmaz; ödeme testini Play üzerinden kurulan sürümle yap.)

### A7. Herkese açık yayın (üretim)

14 gün ve 12 kişi şartı tamamlanınca Pano'da **"Üretime erişim iste"** düğmesi açılır:

1. Başvuruyu doldur (test sürecini anlat; kısa cevaplar yeterli). Google yaklaşık 1 hafta içinde cevap verir.
2. Onaylanınca **Üretim → Yeni sürüm** → AAB'yi (kapalı testte kullandığın ya da yeni sürüm) yükle → **Yayınla**.
3. İlk inceleme birkaç saat – birkaç gün sürer. Sonra uygulama Play Store'da "Mevo SMMM" adıyla görünür.

---

## B) App Store (iPhone / iPad)

**Gereken:** bir **Mac** (güncel macOS) + **Xcode** (App Store'dan ücretsiz) + **Apple Developer Programı (99 $/yıl)**.
Bu bilgisayarda iOS derlenemez (Mac ve Xcode yok); iOS projesi hazırlandı ama hiç derlenmedi. Mac'te bir sorunla
karşılaşırsan Claude'a hata mesajını gönder.

### B1. Hesap

1. https://developer.apple.com/programs/enroll → Apple kimliğinle kaydol (bireysel), 99 $ öde. Onay 1–2 gün sürebilir.

### B2. Mac'te hazırlık (bir kez)

1. Xcode'u kur; ilk açılışta lisansı kabul et. Terminalde: `sudo gem install cocoapods` (ya da `brew install cocoapods`).
2. Flutter'ı kur: https://docs.flutter.dev/get-started/install/macos (sürüm: bu projedeki `flutter --version` ile aynı, 3.47.x).
3. Depoyu Mac'e indir (`git clone ...`), `app` klasöründe: `flutter pub get` ve `cd ios && pod install`.
4. Xcode'da `app/ios/Runner.xcworkspace` dosyasını aç (`.xcodeproj` değil!). Sol üstte **Runner** → **Signing & Capabilities**:
   - Team: Apple Developer hesabını seç; "Automatically manage signing" açık.
   - Bundle Identifier: **`app.mevo.smmm`** (hazır gelir).
   - **+ Capability → In-App Purchase** ekle.
5. Deployment target 15.0 (hazır). Cihaz: iPhone ve iPad (hazır).

### B3. App Store Connect'te uygulamayı ve ürünü oluştur

1. https://appstoreconnect.apple.com → **Uygulamalarım → +  → Yeni Uygulama**: Platform iOS, Ad **Mevo SMMM**,
   Birincil dil Türkçe, Bundle ID `app.mevo.smmm`, SKU `mevo-smmm-1`.
2. **Uygulama içi satın alımlar → +**: Tür **Tüketilmeyen**, Referans adı `Tam erişim`, **Ürün kimliği `tam_erisim`**,
   fiyat seç, Türkçe görünen ad/açıklama gir (`VERI_GUVENLIGI_VE_DERECELENDIRME.md` içinde hazır), inceleme ekran görüntüsü ekle.
3. Uygulama bilgileri: gizlilik politikası adresi (0.2), kategori **Eğitim**, yaş derecelendirmesi anketi, **Uygulama
   Gizliliği = Veri toplanmıyor**, metinler `MAGAZA_METNI.md`'den, ekran görüntüleri (6,9" iPhone + 13" iPad).
4. Gelir/vergi: **Anlaşmalar, Vergi ve Bankacılık** bölümünde "Ücretli Uygulamalar" sözleşmesini kabul et, banka ve vergi
   bilgilerini gir (aksi hâlde satın alma çalışmaz).

### B4. Derle ve yükle

1. Terminal (`app` klasöründe): `flutter build ipa --release --obfuscate --split-debug-info=build/hata-ayiklama` (alternatif: Xcode'da Product → Archive).
2. Çıkan arşivi Xcode **Organizer → Distribute App → App Store Connect → Upload** ile yükle (ya da Transporter uygulamasıyla `build/ios/ipa/*.ipa`).
3. Yükleme işlendikten (10–30 dk) sonra App Store Connect'te sürüme **yapıyı seç**, uygulama içi satın alımı sürüme **ekle**.
4. **Test için TestFlight:** yapıyı iç/dış test kullanıcılarına dağıtabilirsin. **Sandbox** satın alma: Users and Access →
   Sandbox → test hesabı oluştur; telefonda Ayarlar → App Store → Sandbox Hesabı ile giriş yap; uygulamada satın al
   (ücret alınmaz). "Satın alımı geri yükle"yi de dene.
5. **İncelemeye gönder.** Apple 1–3 gün içinde cevap verir. Reddedilirse sebebini yazar; mesajı Claude'a gösterebilirsin.

---

## C) Yeni soru ekleme ve güncelleme çıkarma

Uygulama soruları paket içinde taşır (internet/sunucu yok). Yani **yeni soru = yeni sürüm**. Kullanıcılar mağaza
güncellemesiyle alır; satın alımları ve ilerlemeleri korunur.

### C1. Soruları uygulamaya aktar

Bilgisayarda depo klasöründe (`mevo`):

```
python -m pytest -q
python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama
```

İlk komut kontrol kapılarını/testleri çalıştırır (hepsi geçmeli); ikincisi kontrol kapılarından (G2/G4) geçen ve durumu
"taslak" ya da "geri çekildi" olmayan soruları `app/assets/sorular/smmm.json` dosyasına yazar. Bu dosyayı **elle düzenleme.**

Aynı komut uygulamadaki **Mevzuat** sekmesinin verisini de üretir (soruların `kaynaklar` alanında geçen maddeler,
`pipeline/mevzuat_paketi.py`). Kanun maddelerinin tam metni yerel `content/kaynaklar/mevzuat/*.txt` dosyalarından gelir
(git'e girmez; yoksa `indir.sh` ile indir) — dosyalar yoksa komut maddeleri yalnızca alıntıyla yazar ve tam metinler
paketten düşer. Standartların (TMS/TFRS/BDS) tam metni hiçbir zaman eklenmez. Metin tarihi `MEVZUAT_TARIHI` sabitidir;
mevzuat metinlerini yeniden indirdiysen o tarihi güncelle.

### C2. Sürüm numarasını artır

`app/pubspec.yaml` içinde `version: 1.0.0+1` satırı vardır: `1.0.0` = kullanıcının gördüğü sürüm, `+1` = **yapı numarası**.
Her yüklemede yapı numarası **mutlaka artmalıdır** (mağaza aynı numarayı kabul etmez). Örnek: soru ekledin →
`version: 1.1.0+2`; sonraki küçük düzeltme → `1.1.1+3`.

### C3. Test et ve derle

```
cd app
flutter analyze
flutter test
flutter build appbundle --release --obfuscate --split-debug-info=build/hata-ayiklama   # Android → build/app/outputs/bundle/release/app-release.aab
flutter build ipa --release --obfuscate --split-debug-info=build/hata-ayiklama         # iOS (yalnızca Mac'te)
# --obfuscate: kod karıştırılır (soru paketinin anahtarını ve satın alma mantığını bulmak zorlaşır).
# build/hata-ayiklama klasörünü sakla ama paylaşma: çökme kayıtlarını okunur hâle getirmek için gerekir.
```

Android derlemesi `app/android/key.properties` dosyasını ve `.gizli/upload-keystore.jks` anahtarını bulamazsa
**debug anahtarıyla** imzalar; böyle bir paketi Play reddeder. Anahtar dosyaları yoksa 0.1'deki yedekten geri koy ve
`key.properties` içindeki `storeFile=` yolunu bu bilgisayardaki gerçek yola göre düzelt.

### C4. Yükle

- **Google Play:** Üretim (veya kapalı test) → **Yeni sürüm** → yeni AAB'yi yükle → sürüm notunu yaz (örn. "Yeni sorular eklendi.") → Yayınla.
- **App Store:** Yapıyı yükle (B4) → App Store Connect'te yeni sürüm oluştur (1.1.0) → yapıyı seç → "Yenilikler" yaz → İncelemeye gönder.

Küçük kontrol listesi: soru sayısı arttı mı (Bugün/Dersler ekranları) · ödeme ekranında fiyat görünüyor mu · `docs/DEVAM.md`
"Durum" bölümünü güncelle.

> **Not:** Mevzuat değişirse (yeni kanun/yönerge) ilgili sorular yeniden gözden geçirilip aynı yolla yeni sürüm çıkarılmalıdır;
> uygulama mevzuatı kendiliğinden güncellemez. Mağaza açıklamasındaki "mevzuatın yayın tarihindeki hâli" ibaresi bu yüzdendir.

---

## D) Sık karşılaşılan sorunlar

| Belirti | Çözüm |
|---|---|
| Ödeme ekranında "Mağazaya şu anda ulaşılamıyor" | Cihazda Play Store/App Store hesabı açık mı, internet var mı bak. Uygulama Play'den (test bağlantısıyla) kurulmuş olmalı; elle kurulan APK'da satın alma çalışmaz. |
| "Tam erişim ürünü mağazada bulunamadı" | Ürün kimliği birebir `tam_erisim` mi, **Etkin** mi; paket adı `app.mevo.smmm` mi; Play'de AAB yüklendi ve test kanalında yayında mı; ürün oluştuktan sonra birkaç saat beklemek gerekebilir. iOS'ta: ürün "Gönderilmeye hazır" ve Anlaşmalar kabul edilmiş mi. |
| Play yüklemeyi "debug anahtarıyla imzalı" diye reddediyor | `key.properties` bulunamadı; C3'teki açıklamaya bak. |
| Play "sürüm kodu daha önce kullanıldı" diyor | `pubspec.yaml`'da `+N` numarasını artır (C2). |
| Anahtar parolası kayboldu | `.gizli/ANAHTAR_BILGISI.txt`; yoksa Play Console'dan yükleme anahtarı sıfırlama talebi aç. |

## E) Mevzuat takibi

`.github/workflows/rg-takip.yml` her gün 05:17 UTC'de (08:17 TR) çalışır ve `python -m pipeline.rg_takip` ile o günün
Resmî Gazete içindekiler sayfasını (`resmigazete.gov.tr/eskiler/YYYY/AA/YYYYAAGG.htm`, varsa mükerrer sayılar) tarar.
Başlıkları, soru bankasının `kaynaklar` alanından üretilen izleme listesiyle (kanun numaraları ve adları, yönetmelik/tebliğ
adları, "Kamu Gözetimi", "Muhasebe Standartları", "Sermaye Piyasası", "Tekdüzen Hesap Planı" gibi genel terimler)
eşleştirir. Maliyeti sıfırdır: GitHub Actions, ek hesap veya sunucu yok. Elle çalıştırmak için GitHub → Actions →
"Resmî Gazete takibi" → Run workflow (isteğe bağlı tarih). Yerelde: `python -m pipeline.rg_takip --tarih 2026-10-03`.

**Bildirim:** eşleşme varsa depoda "Resmî Gazete: <tarih> — mevzuat değişikliği olabilir" başlıklı bir **issue** açılır
(aynı gün için varsa yorum eklenir). GitHub yeni issue'yu depo sahibine **e-postayla** bildirir; ayrıca sayfa hiç
alınamazsa iş başarısız olur ve GitHub başarısız çalışma e-postası gönderir. E-postaları almak için GitHub → Settings →
Notifications bölümünde "Actions" ve "Issues" bildirimlerinin açık olduğunu kontrol et.

**Issue gelince:**
1. Raporda her eşleşen başlığın bağlantısı ve "etkilenebilecek sorular" listesi vardır. Resmî Gazete maddesini aç ve
   değişikliğin hangi madde/standardı etkilediğine bak (çoğu eşleşme alakasız çıkabilir; o zaman issue'yu kapat).
2. Gerçekten bir madde değiştiyse listelenen soruların `kaynaklar` ve açıklamalarını gözden geçir; düzeltme
   `docs/SORU_URETIM_RECETESI.md` adımlarıyla yapılır (soru metni değişince `surum` +1, kapılar sıfırlanır).
3. `content/kaynaklar/mevzuat/` metinlerini yeniden indir (`indir.sh`), `pipeline/mevzuat_paketi.py` içindeki
   `MEVZUAT_TARIHI` tarihini güncelle, C bölümündeki adımlarla paketi yeniden üret ve uygulama güncellemesi çıkar
   (Mevzuat sekmesindeki metinler de böylece tazelenir). Issue'yu kapat.

**Sınırlar:** Eşleştirme başlık metnine dayanır (madde numarası içermez), bu yüzden "olabilir" diyen bir uyarıdır;
kaçırma ihtimali vardır (ör. başlıkta kanun adı geçmeyen değişiklikler). Standart değişiklikleri (TMS/TFRS/BDS)
Resmî Gazete'de değil KGK sitesinde yayımlanır; yalnızca "Kamu Gözetimi" başlıklı Resmî Gazete ilanları yakalanır, KGK
duyurularını arada elle kontrol et.

**Test durumu:** Birim testleri yapay bir sayfayla (`tests/veri/rg_ornek.htm`) çalışır, ağ kullanmaz. Geliştirme
ortamından (bulut sandbox) gerçek `resmigazete.gov.tr` sayfaları da çekilebildi (4 Ekim 2026 oturumunda 30 Eylül–4 Ekim
günleri tarandı, hiçbirinde eşleşme çıkmadı); GitHub Actions üzerindeki ilk çalıştırma bu ortamdan denenemedi — ilk
günlerde Actions sekmesinden "Run workflow" ile bir kez elle deneyip çıktıya bak. Site zaman zaman yavaş yanıtlar;
betik 3 kez dener.
