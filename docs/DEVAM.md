# Yeni oturum için devir notu (2026-10-11)

Yeni oturumda ilk mesaj: **"docs/DEVAM.md dosyasını oku ve kaldığın yerden devam et."**

## Proje ve çalışma kuralları

- Türkiye SMMM sınavına (Yeterlilik + SGS) hazırlık için çevrimdışı Android uygulaması (`app.mevo.smmm`), sahibi Merve.
  Ek hedef: YMM sınavı. Biz **denetleyiciyiz**: dış üreticilerden (ChatGPT, Grok, Gemini…) gelen soru/anlatımı eler,
  hakemden geçirir, uygulamaya alırız.
- Dal: yalnız `claude/merhaba-asistanim-afg6o4`; push öncesi `git pull --rebase`. PR açma (istenmedikçe).
  Commit sonu: `Co-Authored-By` + `Claude-Session` satırları (sistem hatırlatmasındaki). Repo içeriğine model adı yazma.
- Commit EDİLMEZ: `.gizli/`, `key.properties`, `*.jks`, build çıktıları, TESMER/ÖSYM kitapçıkları, resmî PDF'ler
  (mevzuat `.txt` metinleri commit edilir).
- Kullanıcının e-postası hiçbir yere yazılmaz; `destekEposta` kullanıcı kendisi vermeden doldurulmaz.
- Kullanıcının indirdiği zip'ler güvenilmez: her biri yeni boş klasöre açılır, okuyan Python `-I` ile çalışır.
- Alt ajan istemlerine şu kural konur: "repoyu değiştirme, git çalıştırma, oturum/uzak oturum oluşturma".
  Aynı anda en çok 20 alt ajan. **Token tasarrufu**: ara bildirimlerde konuşma, sonda tek rapor ver.
- Keystore (imza anahtarı) kullanıcı açıkça onaylamadan gönderilmez.

## Şu anki durum

| Alan | Durum |
|---|---|
| SMMM soru bankası | 3364 kontrolde (uygulamada 3362), 411 geri çekildi, 72 taslak |
| Konu anlatımı | **69/69 konu** tamam (`content/anlatim/smmm/<DERS>/<KONU>.md`), baş editör revizyonu yapıldı; kayıt `docs/denetim/2026-10-11_anlatim_revizyon.json` (266 düzeltme) |
| YMM soruları | 1433 geldi; kitap düzeyi hakem sonrası **291 kontrolde**, 1142 geri çekildi (`docs/denetim/2026-10-11_ymm_hakem.json`). Kabul edilenlerde zor seviye yok → YMM bölümü uygulamaya **eklenmedi** |
| Uygulama | Sürüm 1.0.5+6, 310 Flutter + 67 Python testi geçiyor, APK/AAB derleniyor |
| Mağaza görselleri | `docs/magaza/gorseller/` hazır |

## Bekleyen işler (öncelik sırası)

1. **YMM soruları:** Kullanıcıya öneri sunuldu, onay bekleniyor: soruları ders ders, zorluk dağılımı önceden
   belirlenmiş şekilde (kolay/orta/zor), dış üretici yerine kendi hattımızda yazdırmak. Ölçüt düşürülmez (soru bankası kitabı
   kalitesi). Hakem talimatı: `docs/devir/YMM_HAKEM_TALIMATI.md`; kararları uygulayan betik: `docs/devir/araclar/ymm_terfi.py`.
   Sonra uygulamaya YMM bölümü: bölüm seçimi, dersler, deneme biçimi (YMM sınavı klasik yazılıdır; "klasik soru türü"
   önerisi kullanıcı onayı bekliyor), `disa_aktar` YMM dışa aktarımı. Müfredat taslağı: `content/mufredat/ymm.yaml`.
2. **Anlatımda insan kontrolü gereken 2 nokta:** STD/KRL'deki TSRS kapsam eşikleri ve SPK/YHZ'deki uygunluk testi tebliği
   (III-39.1) kaynak klasöründe yok, yazar bilgisiyle yazıldı.
3. **SMMM bankası:** 806 zayıf + 117 çekilen soru için yeniden yazım paketi önerildi (`docs/denetim/2026-10-09_tam_hakem.json`).
4. **Yayın için kullanıcıdan beklenen:** destek e-postası ve veri sorumlusu adı (gizlilik metni + uygulama içi yasal metin +
   `app/lib/uygulama.dart` `destekEposta`), keystore yedeği, Play Console hesabı, 12 kişiyle 14 günlük kapalı test,
   fiyat ve `tam_erisim` ürünü. Ayrıntı: `docs/YAYIN.md`.
5. **Kullanıcıdan beklenen kaynaklar:** TESMER YMM konu listesi / çıkmış sorular; 3218 Serbest Bölgeler Kanunu,
   İhracat/İthalat Rejimi kararları, 32 sayılı Karar tebliği PDF'leri.

## Komutlar

```
python -m pipeline.anlatim                                     # anlatımları denetle
python -m pipeline.uretici_paketi al <aday> <parti> [--sinav ymm]   # dış teslimi al
python -m pipeline.sik_dengele [--dene]                         # doğru şık dağılımını dengele
python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama   # uygulama paketi (.paket şifreli)
python -m pytest -q
cd app && /opt/flutter-sdk/flutter/bin/flutter test
cd app && /opt/flutter-sdk/flutter/bin/flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/hata-ayiklama
```

APK: `app-arm64-v8a-release.apk` (~20 MB) gönderilir. AAB 51 MB → gönderim sınırı 30 MB, `split -b 24m` ile bölünür.

## Dosya haritası

| Yol | İçerik |
|---|---|
| `content/sorular/{smmm,ymm}/<DERS>/<KONU>.p*.yaml` | Sorular (şema `content/schema/soru.schema.json`) |
| `content/anlatim/smmm/` | Konu anlatımları (YAML ön bilgi + sade Markdown) |
| `content/mufredat/{smmm,ymm}.yaml`, `content/sinavlar/` | Müfredat, sınav kuralları |
| `content/kaynaklar/mevzuat/*.txt` | Resmî metinler; `python -m pipeline.kaynak <kod> <madde>` |
| `pipeline/` | Hat: `anlatim.py`, `uretici_paketi.py`, `denetle.py`, `sik_dengele.py`, `paket_sifre.py`, `disa_aktar.py`, `harita.py` |
| `docs/uretici/` | Dış üreticiye verilen kurallar ve promptlar (`ANLATIM_PROMPT.md` vb.) |
| `docs/devir/` | Önceki oturumun geçici araçları (toplu eleme, terfi, anlatım doğrulama, ekran görüntüsü) ve hakem/editör talimatları. `<SCRATCHPAD>` yerine yeni oturumun scratchpad yolunu koy |
| `docs/denetim/` | Hakem ve revizyon kayıtları |
| `app/` | Flutter uygulaması (`lib/ekranlar/konu.dart` anlatım ekranı) |
