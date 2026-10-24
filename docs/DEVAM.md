# Yeni oturum için devir notu (2026-10-18)

## 2026-10-18 oturumu (aynı dal) — soru bankası düzeltme turları tamamlandı

- **Ağır + hafif tur bitti:** `guncellik_denetimi.py` bulgulu soru 828 → **0**. Tekrar eden hükümler çekildi, mutlak
  ifadeli çeldiriciler ve "doğru şık en uzun" ipuçları giderildi, SMMM köklerinden BDS numaraları çıkarıldı, sınav
  düzeyinin altındaki 35 tek adımlık soru çekildi. Son durum: SMMM 3.128 aktif (72 taslak), YMM 1.485 aktif + 80 klasik.
  Rapor: `docs/denetim/2026-10-18_guncellik_son.json`.
- **Elle doğrulanmış yanlış alarmlar** `docs/denetim/guncellik_istisna.json` içinde (gerekçeli; denetçi bunları atlar).
- **SMMM tutarları ₺ biçiminde** (`para_birimi.py --uygula`; ek ünlüsü "lira"ya göre: ₺'dır, ₺'ya). Alıntılar ve
  doğrulama kodu TL olarak kalır. YMM'de TL korunur.
- `duzeltme.py` artık `secenek_degis` (yalnız verilen şıkları değiştirir) kabul eder.
- **Sıradaki:** anlatım denetimi (69 SMMM + 59 YMM taslak; YMM raporlarındaki "anlatım açıkları"), yeni YMM konuları
  için soru/anlatım, paket + sürüm 1.0.8 + APK/AAB.

## 2026-10-17 oturumu (dal `claude/ymm-cikmis-analiz`, `claude/devam-md-continue-itrwgl` üstünde)

- **Gerçek müfredat kaynağı bulundu:** TESMER resmî alt konu listesi yayımlamıyor; 2022/1–2026/1 YMM soru ve cevap
  anahtarları (130 PDF) indirildi (`content/kaynaklar/cikmis/ymm/`, depoya girmez; uç nokta
  `https://www2.tesmer.org.tr/ajax.php?type=sinav_yili&sinav_turu=ymm`, PDF `…/files/ortak/soru_cevaplar/ymm/<yıl>/<dönem>/<ders>/…`).
  Ders ders analiz: `docs/denetim/ymm_cikmis_2026-10-17/` (soru dökümü, puan payı, stil, anlatım açıkları).
- **`content/mufredat/ymm.yaml` sürüm 2:** ağırlıklar gerçek puan payına göre; yeni konular IFM KCV/MDV/STK/TAS,
  FYN PIY, YNM MSS, DRM DSP/DGY, REV IST/ULU/GEC, VTK UGN/YRG/THS/DUZ/SRM, GUV OZL, HSV GDR, DTK TKP, SPM PAL.
  VTK'daki TFR, BDB, MTR, TSV **REV'e taşındı** (sorular, klasikler, anlatımlar; kimlikler `YMM-REV-…`). Yeni konuların
  sorusu ve anlatımı YOK → üretim gerekir.
- **YMM anlatımları:** 59 konu dış tesliminden alındı (`content/anlatim/ymm/`, `durum: taslak`, uygulamaya girmez).
  Çıkmış soru raporlarındaki "anlatım açıkları" bölümleri revizyon listesidir (ör. YNM/BTC GÜG sapma yöntemi anahtarla çelişiyor).
- **Kaynaklar:** 21 yeni mevzuat (KDV oran kararları, 9160/11257/9707 CBK, 3218, ihracat/ithalat rejimi, SPK VII-128.8,
  II-14.1, X-22, III-39.1, TSRS 1-2, TSRS eşik) `KAYNAKLAR.md`'de. Taranmış olanlar Tesseract (tur) ile OCR'landı; OCR "%"
  işaretini bozuyor, kısa kararlar elle düzeltildi, `ithalat_rejimi_2026_10790.txt` düzeltilmedi.
  Hâlâ eksik: 6802 Gider Vergileri K., 7194 (DHV), 210 Değerli Kağıtlar K., Gümrük Yönetmeliği, 5607, 3577, Tasfiye Yön.,
  32 s. Karar tebliğleri (2018-32/45, 32/48), SPK II-16.1, II-26.1, II-22.1, VI-103.1, 555 s. VUK GT.
- **Hat düzeltmeleri:** `anlatim.on_eleme` aynı konu kodlu farklı dersleri eziyordu; HTML kuralı "a < b"yi reddediyordu;
  `g4_hesap`/`klasik` exec ad alanı Python 3.11'de 2 soruyu eliyordu. Paket: 4849 soru + 80 klasik, eleme yok.
- **SMMM 2026 test biçimi** (TÜRMOB YK 14.01.2026): 8 ders × 20 soru, 45 dk/ders, yanlış ¼ götürür, hesap makinesi yok,
  her dersten 50 / ortalama 60. TESMER 2026/1–2 test soruları yayımladı (`sinav_turu=smmm`). Bankanın üslubu bunlarla
  karşılaştırılmalı.
- **Soru sayısı:** 7.776 kayıt (SMMM 3.847 = YET+SGS; YMM 3.929), aktif 4.849 + 80 klasik.
- **Kullanıcının hedefi (sıra):** 1) müfredat ✔ (YMM) → 2) bütün soruların denetimi → 3) anlatımların müfredat ve
  öğretmen dili denetimi → 4) eksiklerin giderilmesi (YMM klasik vaka soruları, yeni konular) → 5) hatasız paket ve yayın.
  Sonra: sesli okuma (cihaz TTS), seslendirme, video.

Yeni oturumda ilk mesaj: **"docs/DEVAM.md dosyasını oku ve kaldığın yerden devam et."**

## Proje ve çalışma kuralları

- Türkiye SMMM sınavına (Yeterlilik + SGS) hazırlık için çevrimdışı Android uygulaması (`app.mevo.smmm`), sahibi Merve.
  Ek hedef: YMM sınavı. Biz **denetleyiciyiz**: dış üreticilerden (ChatGPT, Grok, Gemini…) gelen soru/anlatımı eler,
  hakemden geçirir, uygulamaya alırız.
- Dal: oturumun verdiği dal (son: `claude/ymm-cikmis-analiz`); push öncesi `git pull --rebase`. PR açma (istenmedikçe).
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
| YMM altyapısı | Uygulamada YMM bölümü, klasik soru çalışma/deneme/öz puanlama hazır; `content/sinavlar/ymm.yaml` içinde `yayinda: true` yapılınca pakete girer (şu an kapalı). Klasik soru: şema `content/schema/klasik.schema.json`, kayıtlar `content/klasik/ymm/`, hat `python -m pipeline.klasik al|denetle` |
| YMM soruları | Dış teslimlerin hepsi hakemden geçti (57 parti, 2026-10-13): **1485 test kontrolde** (DRM 274, YNM 246, FYN 217, IFM 159, SPM 140, DTK 126, VTK 103, HSV 89, GUV 82, REV 49), 2444 geri çekildi, taslak 0. Pakette 80 klasik. Dış teslim klasiklerinin neredeyse hepsi elendi (yanlış madde/hesap kodu). Zayıf dersler: REV, GUV, HSV → yeni görev gerekir. FYN/YNM hakemleri hızlı: örnek elle denetlenmeli |
| Uygulama | Sürüm 1.0.7+8, 315 Flutter + 77 Python testi geçiyor. Paket: 4849 soru + 80 klasik (YMM yayında) |
| Mağaza görselleri | `docs/magaza/gorseller/` hazır |

## Dış üretici hattı (YMM, 2026-10-11 kullanıcı kararı: üretim ChatGPT/Gemini/Grok'a, biz ön eleme + hakem)

1. Paketler: `python -m pipeline.ymm_gorev paket` (plan `content/gorevler/ymm_<tarih>.json`: 103 görev, 2965 test +
   349 klasik, eleme payı ×1.3; hedef ders başına 300 test + 30 klasik). Anlatım: `python -m pipeline.anlatim paket
   IFM,...,SPM --sinav ymm`. Zip'ler `uretici_paketleri/` (depoya girmez). Kurallar: `docs/uretici/YMM_MANIFESTO.md`
   (K01–K34), `docs/uretici/YMM_ANLATIM_KURALLARI.md` (A00–A08); kullanıcıya verilecek istem: `YMM_PROMPT.md`,
   `YMM_ANLATIM_PROMPT.md`.
2. Teslim gelince (token harcamaz): `python -m pipeline.on_eleme teslim.yaml` → `teslim.rapor.md` (ret kodlarıyla);
   `--al 3` geçenleri taslak alır. Anlatım: `python -m pipeline.anlatim on_eleme teslim.zip --sinav ymm [--al]`.
3. Hakem (token harcar, en çok 2 ajan): `hakem_girdi.py` → `YMM_HAKEM_TALIMATI.md` / `YMM_KLASIK_HAKEM_TALIMATI.md`
   → `ymm_terfi.py` / `klasik terfi` → `disa_aktar --uygulama` (ELENDİ listesi boş olmalı) → `sik_dengele`.

## 2026-10-19 — YMM soru üretimi (parti 4) tamam

- 20 yeni YMM konusuna 15'er MC + 1 klasik; 20 sorusu az konu 15'e tamamlandı. Toplam ~493 MC + 23 klasik (S1–S4 teslim
  dosyaları scratchpad'de; iç hat S3 + OZL). Hepsi bağımsız kör hakemden geçip `kontrolde`. YMM'de taslak soru kalmadı:
  1887 MC + 100 klasik `kontrolde`.
- Hakem düzeltmeleri: YRG-0002 (VUK 106 özel hükmü), OZL-0009 (7555 geçiş tarihi), GDR-0002, SRV-0063 (EVK 16 istisnası);
  klasikler STK, ULU, DUZ yeniden yazıldı. Baş hakem kararıyla terfi: ULU-0007 (9707 CBK %5), SRV-0060 (VİV 16 yarı oran).
- Atlanan kazanımlar (kaynak yok): matrah artırımı (7143/7326/7440), TFRS 1, TFRS 13.
- Yöntem notları: `uretici_paketi al` bir kez çalıştırılır; `atlanan` öğeleri sözlük olmalı ({satir, neden}); kör hakem
  girdisi `scratchpad/ymm_hakem4/kor_*.md`, terfi ymm_terfi.py mantığıyla (G5 notu + gecmis).
- Kalan: YMM klasikleri DRM dışında ders başına 6–12 (hedef ~30); SMMM 72 taslak ve ince konular; paket + sürüm + imzalı derleme.

## 2026-10-21 — YMM klasik hakemliği (GUV, DTK, HSV, VTK, FYN)

- Ajan izni olmadığından 118 taslak klasiği (GUV 23, DTK 24, HSV 24, VTK 24, FYN 23) baş hakem tek tek okudu; oran, tutar,
  süre ve madde atıfları `content/kaynaklar/mevzuat/*.txt` ile doğrulandı (KVK, 11257/9160 CBK, Gümrük K. ve Yön., 32 sayılı
  Karar ve tebliğleri, KDV GUT, ÖTVK, VİVK, EVK, MTVK, VUK, 6183, 5604). Kararlar `scratchpad/ymm_hakem4/hk_self.json`.
- Sonuç: 118 kabul, `klasik.terfi` ile `kontrolde`. Tek düzeltme: DTK/KMB-K005 (dahilde işlemede altın ithali Karar 7/2-c/ç
  ile uyumlu hâle getirildi; vaka standart dışı altına çevrildi). YMM klasik: 218 `kontrolde`; beş ders 30'ar.
- Kalan: YNM, SPM, IFM, REV klasik üretimi (kullanıcı kararı); 2 taslak anlatım; paket + sürüm + imzalı derleme.

## 2026-10-24 — YMM klasik üretimi (YNM, SPM, IFM, REV)

- Ajan kullanılmadan dört dersin eksik klasikleri baş hakemce yazıldı ve denetlendi: YNM 23 (d23985b), SPM 23 (003befb),
  IFM 18 (d45288e), REV 18. Her klasik `kk.py` ile şema, müfredat, alıntı ve doğrulama kodu açısından geçti; `al` bir kez
  çalıştırıldı, `klasik.terfi` ile `kontrolde`. YMM klasik toplamı: 300 `kontrolde` (her ders 30).
- IFM: VUK→TFRS dönüşümü, TMS 12/19/37, TMS 16/36/38/40, TFRS 15/16, TFRS 5, TMS 7, TMS 2/41/20, TFRS 9, TMS 29 (VUK geçici
  37 ile birlikte), TMS 21. TFRS 18'in 1.1.2027'den uygulanacağı esas alındı.
- REV: 2026 mevzuatı esas alındı — KVK 5/1-b %80 (11257 CBK), 5/1-e %50 (9160 CBK) ve geçici 16 (%25), 10/1-ğ %100 (11257 CBK),
  hakediş stopajı %5 (9707 CBK), geçici vergide dört dönem (7566 s. K.), 32/A %60 ve on dönem (7555 s. K.), KVK geçici 19
  varlık barışı (7582 s. K.), 2026 binek ve VUK 313 tutarları (332 GVK, 588 VUK tebliğleri). 7582 ile değişen md. 32/8 (%12,5)
  2027'den itibaren uygulanacağı için sorulara alınmadı.
- Anlatımlar: HSV/SRV ve REV/AKT tutar ve oranları evk/vivk/mtvk/vuk/kdvk ve 588 tebliğiyle doğrulandı; SRV'de EVK md. 30
  ifadesi düzeltildi, AKT'de konkordato (alacaklı) idare görüşü olarak yazıldı; ikisi `kontrolde` (YMM anlatım: 79/79).
  REV/AKT-K010 klasiğinde azalan bakiyeler dayanağı "mükerrer md. 315" yapıldı.
- Kalan: uzman teyidi; paket yeniden üretimi + sürüm + imzalı AAB.

## Bekleyen işler (öncelik sırası)

1. **YMM soruları (kullanıcı onayladı: kendi hattımızda + klasik soru türü):** Yazar talimatı `docs/devir/YMM_YAZAR_TALIMATI.md`
   (scratchpad'e kopyalanıp `<SCRATCHPAD>` doldurulur). Ders yarıları görev kodu: IFM-1 {KON,ENF,FAR,KUR}, IFM-2 {KIR,VRG,BDB},
   FYN-1/2, YNM-1/2 (konu başına 2 orta + 5 zor), DRM-1 {BDS,RAP,YMM}, DRM-2 {MHK,KGK}, REV, VTK, GUV, HSV, SPM, DTK.
   **Token tasarrufu (kullanıcı isteği, 2026-10-11):** aynı anda en çok 2 ajan; yazara `docs/devir/araclar/ymm_baglam.py`
   ile üretilen ders özeti verilir (banka YAML'larını okumaz); hakem ajanları ucuz modelde (sonnet) çalışır.
   Ölçüm: yazar ajanı ~300–350 bin token / 24 soru + 3 klasik; hakem ~150–200 bin token.
   **Durum (2026-10-11 son):** Planlanan YMM iç hat üretimi TAMAM (10 dersin iki yarısı). YMM bankası 739 test + 53 klasik
   `kontrolde`; uygulama paketi 4103 soru + 53 klasik, hiçbir soru elenmiyor. 315 Flutter + 72 Python testi geçiyor.
   Kontrol önerisi: FYN ve YNM hakemleri çok hızlı bitti (~1 dk) → bu iki dersten örnek sorular elle denetlenmeli.
   Kaynak metni olmadığı için atlanan kazanımlar: 3218 Serbest Bölgeler K., İhracat/İthalat Rejimi, Incoterms, akreditif (UCP),
   5746 Ar-Ge K. → kullanıcı metinleri verirse bu kazanımlar için ek parti yazılır.
   Kullanıcı kotadan rahatsız: ajanları tek tek / en çok 2 başlat; hakem önceki modelle (ucuz model doğru soruları eledi).
   Hakem girdisi: `<SCRATCHPAD>/hakem_girdi.py DERS klasör` (kor/anahtar/klasik dosyaları), terfi: ymm_terfi.py karar dosyasıyla.
   Teslim alma: `python -m pipeline.uretici_paketi al t_X.yaml <parti> --sinav ymm` + `python -m pipeline.klasik al t_X.yaml`,
   sonra bağımsız hakem (MC: `docs/devir/YMM_HAKEM_TALIMATI.md`; klasik için de hakem) ve `ymm_terfi.py`.
   Eski not: soruları ders ders, zorluk dağılımı önceden
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

**Windows'ta derleme:** Proje yolu ("Masaüstü") ASCII dışı olduğu için Android Gradle eklentisi derlemeyi reddeder.
`app/` klasörü `C:\Users\erene\dev\mevo_insa\app` altına kopyalanıp orada derlenir (JAVA_HOME = JDK 21).
`android/key.properties` (yükleme anahtarı) yoksa çıktı **debug imzalıdır**; Play'e yüklenecek AAB için anahtar gerekir.

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
