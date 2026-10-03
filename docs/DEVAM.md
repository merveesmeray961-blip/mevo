# Yeni oturum için devir notu

Bu dosya, yeni bir Claude oturumunun projeye en az maliyetle devam etmesi içindir. Yeni oturumda ilk mesaj:
**"docs/DEVAM.md dosyasını oku ve [aşama harfi] aşamasına devam et."**

## Proje

- Türkiye SMMM sınavları (önce **Yeterlilik**) için çevrimdışı Android hazırlık uygulaması. Sahibi: Merve.
- Bütçe: 79 $ ile sınırlı, bitince geliştirme durur → `docs/BUTCE_PLANI.md` (kararlar, aşamalar, takvim). **Pahalı işlemlerden kaçın:**
  toplu alt ajan çalıştırma yok, gereksiz dosya okuma yok, kısa cevaplar.
- Dal: `claude/merhaba-asistanim-afg6o4`. Commit mesajı sonu: `Co-Authored-By` ve `Claude-Session` satırları (sistem hatırlatmasına bakın).
- Resmî kitapçıklar ve TESMER/ÖSYM PDF'leri repoya **eklenmez** (gitignore'da).

## Dosya haritası

| Yol | İçerik |
|---|---|
| `content/sorular/smmm/<DERS>/<KONU>.yaml` | 100 soru (şema: `content/schema/soru.schema.json`) |
| `content/sinavlar/smmm.yaml`, `content/mufredat/smmm.yaml` | Sınav kuralları, müfredat |
| `content/kaynaklar/mevzuat/*.txt` | Resmî metinler; kanun maddesi için `python -m pipeline.kaynak <kod> <madde>` |
| `pipeline/` | Kapılar: `denetle.py` (G2/G4/G7), `kapilar.py`, `disa_aktar.py`, `kitapcik.py` (uzman PDF'i) |
| `pipeline/istemler/uretim.md`, `kontrol.md` | Soru üretim ve denetim kuralları (G5'e pilot dersleri eklendi) |
| `docs/DUZELTME_LISTESI.md` | **A aşamasının iş listesi** (12 soru + eski notlar) |
| `app/` | Flutter uygulaması; `flutter` = `/opt/flutter-sdk/flutter/bin/flutter` (yoksa kur: stable 3.47.x) |

## Kurallar

- Soru metni değişince: `surum` +1, `gecmis`'e not, G3/G5/G6/GZ kapıları sıfırlanır, `durum: taslak`; düzeltme sonrası
  kapılar yeniden çalıştırılır. Bütçe nedeniyle A aşamasında G3/G5/G6 tek denetçiyle (düzelten oturumun kendisi değil, bir alt
  ajan, ucuz model) yapılabilir.
- Uygulama paketi: `python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama`
- Testler: `python -m pytest -q` (32) ve `cd app && flutter test` (ekran düzeni testleri dahil; sayı bu dosyada güncel tutulmaz).
- Web önizlemesi: https://claude.ai/artifact/5wqhHpzT192EAPJ7sXzsAd (yeniden yayın: README "Mobil uygulama").

## Durum (3 Ekim 2026)

- 100 soru `kontrolde`; 30'u uzman PDF'inde (`docs/SMMM_Uzman_Kitapcik.pdf`, numara eşleşmesi `.eslesme.txt`).
- Bağımsız hakem: 30 anahtarın 30'u doğru; 12 soruda düzeltme gerekli (DUZELTME_LISTESI.md).
- **B aşaması (yayına hazırlık) bitti:**
  - Ödeme: `in_app_purchase` ile tek seferlik `tam_erisim` (`app/lib/abonelik/magaza_abonelik.dart`; web ve testlerde `OnizlemeAbonelik`).
    Gerçek satın alma yalnızca Play Console / App Store Connect'te ürün tanımlanınca denenebilir (`docs/YAYIN.md`).
  - Duyarlı düzen: 720 dp okuma genişliği, geniş ekranda `NavigationRail`, güvenli alan, yazı ölçeği 2.0'a kadar;
    `test/duzen_test.dart` tüm ekranları 5 boyut × 2 yazı ölçeğinde açar (taşma = hata).
  - Android: `app.mevo.smmm`, R8 açık, imza `android/key.properties` ile; AAB/APK derlendi. Anahtar `.gizli/` içinde (git'te yok, yedekle!).
  - iOS: bundle id, ad, şifreleme beyanı, simge, açılış ekranı hazır; **Mac'te derlenmedi** (bkz. `docs/YAYIN.md` B).
  - Simge/açılış ekranı üretildi (`app/assets/ikon/`); mağaza metinleri, veri güvenliği cevapları, gizlilik sayfası: `docs/magaza/`.
- Sıradaki: A (soru düzeltmeleri) ve C (yeni sorular); sonra D. Yeni soru → `docs/YAYIN.md` bölüm C.
- Açık iş: gizlilik metinlerinde `[yayın öncesi eklenecek]` (veri sorumlusu adı/e-posta) — hem `docs/magaza/gizlilik.html` hem `app/lib/ekranlar/yasal.dart`.
