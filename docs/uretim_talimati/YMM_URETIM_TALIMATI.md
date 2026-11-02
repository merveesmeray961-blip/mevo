# Tasdik YMM — özgün soru üretim talimatı (hedef 3.000+, klasik ağırlıklı)

Hazırlanış: 2 Kasım 2026 · Dağılım betiği: `docs/uretim_talimati/dagilim.py` · Ham tablo: `dagilim_ymm.csv`

## 1. Hedef

- Bankada şu an **1887 test + 300 klasik = 2187 özgün soru** var.
- YMM sınavı yazılı (klasik) olduğundan ağırlık klasikte: **klasik 300 → 900** (her derste 90),
  **test 1887 → 2187**. Sonuç: **3087 özgün soru.**
- Net ihtiyaç: **600 klasik + 300 test.** Kayıp payı dahil üretilecek: **870 klasik + 454 test.**
- Dağılım müfredattaki konu ağırlıklarına göre; az sorusu olan konular öne alındı. Testte her konu en az 25 soruya,
  klasikte en az 4 vakaya tamamlanıyor.

## 2. Ders özeti

| Ders | Ad | Test mevcut | Test net | Test üret | Klasik mevcut | Klasik net | Klasik üret |
|---|---|---|---|---|---|---|---|
| IFM | İleri Düzeyde Finansal Muhasebe | 219 | 34 | 52 | 30 | 60 | 89 |
| FYN | Finansal Yönetim | 232 | 13 | 20 | 30 | 60 | 87 |
| YNM | Yönetim Muhasebesi | 261 | 6 | 10 | 30 | 60 | 87 |
| DRM | Denetim, Raporlama ve Meslek Hukuku | 309 | 27 | 40 | 30 | 60 | 87 |
| REV | Revizyon | 217 | 45 | 72 | 30 | 60 | 88 |
| VTK | Vergi Tekniği | 109 | 37 | 55 | 30 | 60 | 86 |
| GUV | Gelir Üzerinden Alınan Vergiler | 122 | 39 | 57 | 30 | 60 | 87 |
| HSV | Harcama ve Servet Üzerinden Alınan Vergiler | 117 | 41 | 62 | 30 | 60 | 86 |
| DTK | Dış Ticaret ve Kambiyo Mevzuatı | 141 | 31 | 45 | 30 | 60 | 86 |
| SPM | Sermaye Piyasası Mevzuatı | 160 | 27 | 41 | 30 | 60 | 87 |
| **Toplam** | | **1887** | **300** | **454** | **300** | **600** | **870** |

**Öncelik:** önce klasik (her dersten sırayla 10'ar vaka), sonra test.


## 3. Kesin kurallar (çiğnenen soru otomatik elenir)

1. **Mevzuattan yaz, bellekten yazma.** Sorudaki her hukuki/teknik iddia `content/kaynaklar/mevzuat/` altındaki resmî
   metinde açıkça bulunmalı. `kaynaklar` alanına mevzuat adı + madde/fıkra + **birebir, kesintisiz** alıntı (en çok 600
   karakter, "..." ile kısaltma YOK) yaz. Alıntı resmî metinde aynen aranır; bulunamazsa soru elenir.
2. **Güncel hüküm.** Esas tarih: Kasım 2026 yürürlükteki mevzuat. Mülga/değişik maddeden soru yazma; emin değilsen o
   maddeyi atla. Yıla bağlı tutar (had, oran, asgari ücret, tarife) kullanıyorsan değeri **kökte ver** ve
   `gecerlilik.yila_bagli_tutar: true`, `gecerlilik.yil: 2026` yaz.
3. **Kopya yasak.** TESMER çıkmış sorularını, ders kitaplarını, rakip uygulamaları **kopyalama, taklit etme, cümle
   yapısını alma.** Senaryo, sayılar, işletme/kişi adları ve şıklar senin olmalı. Kök cümlesi bilinen bir sorunun
   özgün kısmına benziyorsa ya da şık seti büyük ölçüde aynıysa soru elenir ("6102 sayılı Kanun'a göre aşağıdakilerden
   hangisi…" gibi kalıp ifadeler sayılmaz). Bankadaki sorularla da benzerlik ölçülür.
4. **Tek ve kesin doğru cevap.** Yoruma açık, "en uygun" tartışmalı, iki şıkkı birden savunulabilir soru yazma.
   Aynı kaydın satır sırası değişmiş hâli ayrı şık olamaz. İmkânsız/çelişkili varsayım (ör. "kooperatif niteliğinde A.Ş.")
   kurma.
5. **5 şık (A–E), tek doğru.** Doğru şık harfleri dengeli dağılsın (her harf ≈ %20). Doğru şık en uzun ya da en kısa
   şık olmasın (ipucu). Sayısal şıklar küçükten büyüğe sıralı.
6. **Açıklama zorunlu:** `aciklama.dogru_neden` (doğru şık neden doğru, maddeye atıfla) **ve**
   `aciklama.celdiriciler` (doğru dışındaki **dört şıkkın her biri** için neden yanlış). Eksik çeldirici = ret.
7. **Olumsuz kök kalın:** "hangisi **değildir**?", "**yanlıştır**".
8. **Hesap soruları:** hesap makinesi yok; yuvarlak sayılar, elle yapılabilir işlem, sonuç tam ya da en çok 2 ondalık.
   `dogrulama.python` alanına sonucu bağımsız hesaplayan kısa Python yaz (`sonuc = ...` ile bitir, import yok) ve
   `aciklama.hesap_adimlari` listesini doldur. Kod çalıştırılır; sonuç doğru şıkla tutmazsa ret.
9. **Grafik/şekil sorusu yok.** Tablo gerekiyorsa Markdown tablo kullan.
10. **Zor sorular (zorluk 3):** en az iki zorlaştırma tekniği (çok adımlı hesap, istisnanın istisnası, madde birleştirme,
    geri hesap, yakın kavram ayrımı, tipik hata çeldiricileri, gereksiz veri, tarih/süre hesabı) ve `dogru_neden`
    sonunda "Püf noktaları:" bölümü (adaya hitap eden sade dil).
11. **Emin değilsen yazma.** Bir maddeden kesin, tek doğrulu soru çıkmıyorsa o kazanımı atla ve teslim notunda belirt.
    Az ama doğru soru, çok ama hatalı sorudan iyidir.
12. **Dil:** resmî, sade, yazım kılavuzuna uygun Türkçe; kök tek başına anlaşılır.
13. **Çeldiriciler gerçekçi olsun:** aynı hükmün adayların gerçekten karıştırdığı yanlış okumaları (yakın süre, komşu
    dilim, istisnayı unutma, benzer kurum). Başka bir maddeye ait alakasız bilgi ("sekiz gün" fatura süresini sözleşme
    cezası sorusuna koymak gibi) ya da saçma şık ("mahkeme kararı gerekir") yazma.
14. **Kendi doğrulamanı yap:** teslimden önce şema, birebir alıntı, şık dengesi ve çeldirici açıklamalarını kendin
    kontrol et (ilk parti böyle geldi ve 12/12 kabul edildi).

### 3a. Klasik (yazılı) vaka kuralları — ek

1. Gerçek YMM sınavı biçimi: **olay/veri bloğu + (a), (b), (c), (d) istekleri**, her isteğin puanı parantezde. Toplam
   `puan` 20–25, `sure_dk` 25–35.
2. `cozum`: örnek cevap — hesap tabloları, yevmiye kayıtları (Markdown tablo), her istek için gerekçe ve madde atfı.
3. `puanlama`: ölçüt listesi; puanların toplamı `puan`'a **eşit** olmalı (ör. "Vergi ziyaı cezasının doğru hesabı – 4").
4. Hesaplı derslerde (IFM, FYN, YNM, REV, VTK, GUV, HSV) `dogrulama.python` zorunlu: çözümdeki ana sonuçları bağımsız
   hesaplayan kod, `sonuc = {"a": ..., "b": ...}` sözlüğü atar. Kod çalıştırılır; çözümdeki sayılarla tutmazsa ret.
5. Vaka gerçekçi olmalı: tarihler 2025–2026, tutarlar tutarlı, yıla bağlı had/oran kökte verilir.
6. Bir vaka en az **iki kazanımı** birleştirir (ör. ceza hesabı + uzlaşma + dava yolu). Tek satırlık "tanım yazınız"
   istekleri en çok bir tane.
7. `id` biçimi teslimde `TASLAK`; alımda `YMM-<DERS>-<KONU>-K<NNN>` verilir.

## 4. Konu konu dağılım

| Ders | Konu | Konu adı | Test mevcut | Test net | Test üret | Klasik mevcut | Klasik net | Klasik üret |
|---|---|---|---|---|---|---|---|---|
| IFM | KCV | Kavramsal Çerçeve ve finansal tabloların sunuluşu | 15 | 4 | 6 | 3 | 7 | 10 |
| IFM | VRG | VUK'tan TFRS'ye dönüşüm ertelenmiş vergi ve karşılıklar | 18 | 9 | 13 | 5 | 13 | 19 |
| IFM | MDV | Maddi ve maddi olmayan duran varlıklar ve yatırım amaçlı gayrimenkuller | 15 | 6 | 9 | 4 | 9 | 13 |
| IFM | STK | Stoklar canlı varlıklar ve devlet teşvikleri | 15 | 3 | 5 | 2 | 5 | 7 |
| IFM | KIR | Hasılat ve kiralamalar | 15 | 4 | 6 | 4 | 6 | 9 |
| IFM | TAB | Nakit akış tablosu ve özel raporlama konuları | 15 | 3 | 5 | 3 | 4 | 6 |
| IFM | FAR | Finansal araçlar | 25 | 0 | 0 | 2 | 4 | 6 |
| IFM | ENF | Enflasyon muhasebesi | 19 | 2 | 3 | 2 | 4 | 6 |
| IFM | KON | Konsolidasyon ve işletme birleşmeleri | 42 | 0 | 0 | 2 | 3 | 5 |
| IFM | KUR | Kur değişimi ve yabancı para işlemleri | 21 | 1 | 2 | 2 | 2 | 3 |
| IFM | BDB | Birleşme devir ve bölünme muhasebesi | 19 | 2 | 3 | 1 | 3 | 5 |
| FYN | FPA | Finansal analiz planlama ve kâr dağıtımı | 52 | 4 | 6 | 9 | 18 | 26 |
| FYN | ZDP | Paranın zaman değeri ve değerleme | 32 | 4 | 6 | 6 | 12 | 17 |
| FYN | PIY | Finansal piyasalar ve türev ürünler | 15 | 4 | 6 | 4 | 7 | 10 |
| FYN | ISY | İşletme sermayesi yönetimi | 41 | 0 | 0 | 4 | 6 | 9 |
| FYN | SBT | Sermaye bütçelemesi | 39 | 0 | 0 | 3 | 7 | 10 |
| FYN | SMR | Sermaye maliyeti ve sermaye yapısı | 32 | 0 | 0 | 3 | 7 | 10 |
| FYN | RGT | Risk getiri ve portföy | 21 | 1 | 2 | 1 | 3 | 5 |
| YNM | KRV | Karar verme ve ilgili maliyetler | 39 | 3 | 5 | 6 | 14 | 20 |
| YNM | BTC | Bütçeleme ve standart maliyet | 53 | 0 | 0 | 5 | 13 | 19 |
| YNM | MHK | Maliyet hacim kâr analizi | 38 | 0 | 0 | 5 | 11 | 16 |
| YNM | FDM | Faaliyete dayalı ve stratejik maliyetleme | 33 | 0 | 0 | 4 | 10 | 14 |
| YNM | MSS | Maliyet sistemleri ve maliyet akışı | 15 | 3 | 5 | 4 | 7 | 10 |
| YNM | DEG | Değişken ve tam maliyetleme | 49 | 0 | 0 | 3 | 4 | 6 |
| YNM | PRF | Performans ölçümü ve transfer fiyatı | 34 | 0 | 0 | 3 | 1 | 2 |
| DRM | MHK | 3568 sayılı Kanun odalar ve TÜRMOB | 36 | 9 | 13 | 6 | 19 | 27 |
| DRM | DSP | Disiplin ve çalışma usul ve esasları | 15 | 9 | 13 | 1 | 16 | 23 |
| DRM | YMM | YMM tasdik esasları | 72 | 0 | 0 | 6 | 11 | 16 |
| DRM | DGY | Meslek mensubunun diğer yükümlülükleri | 15 | 6 | 9 | 1 | 11 | 16 |
| DRM | KGK | KGK ve kamu gözetimi | 15 | 3 | 5 | 1 | 3 | 5 |
| REV | IST | Kurumlar vergisi istisnaları | 15 | 8 | 12 | 4 | 10 | 14 |
| REV | ULU | Dar mükellefiyet çifte vergilendirme ve vergi kesintisi | 15 | 8 | 12 | 4 | 10 | 14 |
| REV | MTR | Matrah ve beyan teknikleri | 15 | 3 | 5 | 3 | 5 | 7 |
| REV | TFR | Transfer fiyatlandırması ve örtülü sermaye | 33 | 0 | 0 | 3 | 5 | 7 |
| REV | TSV | Teşvikler ve özel uygulamalar | 15 | 3 | 5 | 3 | 5 | 7 |
| REV | GLR | Gider ve gelir hesaplarının revizyonu | 15 | 3 | 5 | 3 | 5 | 7 |
| REV | AKT | Aktif hesapların revizyonu ve değerleme | 15 | 3 | 5 | 2 | 4 | 6 |
| REV | GEC | Geçici ve af düzenlemeleri | 15 | 3 | 5 | 2 | 3 | 5 |
| REV | BDB | Birleşme devir bölünme ve tür değişikliği | 19 | 2 | 3 | 1 | 3 | 5 |
| REV | PSF | Pasif ve özkaynak hesaplarının revizyonu | 15 | 3 | 5 | 2 | 2 | 3 |
| REV | GNL | Revizyonun kapsamı ve teknikleri | 15 | 3 | 5 | 1 | 3 | 5 |
| REV | VIN | Vergi incelemesi ve hile tespiti | 15 | 3 | 5 | 1 | 3 | 5 |
| REV | TAS | Tasdik çalışmalarında revizyon | 15 | 3 | 5 | 1 | 2 | 3 |
| VTK | DEG | Değerleme ve enflasyon düzeltmesi | 19 | 6 | 9 | 6 | 10 | 14 |
| VTK | UGN | Vergi usulünün genel hükümleri | 15 | 6 | 9 | 5 | 9 | 13 |
| VTK | YRG | Vergi yargısı | 15 | 6 | 9 | 4 | 10 | 14 |
| VTK | THS | Vergi alacağının tahsili | 15 | 6 | 9 | 4 | 9 | 13 |
| VTK | DUZ | İnceleme takdir ve düzeltme | 15 | 5 | 7 | 4 | 9 | 13 |
| VTK | CEZ | Vergi cezaları ve uzlaşma | 15 | 5 | 7 | 5 | 8 | 12 |
| VTK | SRM | Vergi sorumluluğu ve teminat | 15 | 3 | 5 | 2 | 5 | 7 |
| GUV | GVM | Gelir vergisi mükellefiyeti ve kazanç unsurları | 15 | 14 | 20 | 8 | 17 | 24 |
| GUV | KVI | Kurumlar vergisinde istisnalar | 25 | 5 | 7 | 6 | 11 | 16 |
| GUV | KVM | Kurumlar vergisi mükellefiyeti ve matrah | 22 | 4 | 6 | 5 | 9 | 13 |
| GUV | GVI | Gelir vergisinde istisna indirim ve beyan | 15 | 5 | 7 | 4 | 9 | 13 |
| GUV | OZL | Kurumlar vergisinde indirimler teşvikler ve geçici düzenlemeler | 15 | 5 | 7 | 4 | 9 | 13 |
| GUV | DAR | Dar mükellefiyet ve uluslararası vergilendirme | 15 | 3 | 5 | 2 | 2 | 3 |
| GUV | ASG | Asgari ve küresel asgari kurumlar vergisi | 15 | 3 | 5 | 1 | 3 | 5 |
| HSV | KIS | KDV istisnaları ve iade | 15 | 13 | 19 | 8 | 15 | 21 |
| HSV | OTV | Özel tüketim vergisi | 19 | 9 | 13 | 7 | 12 | 17 |
| HSV | SRV | Servet vergileri | 15 | 9 | 13 | 6 | 12 | 17 |
| HSV | GDR | Gider vergileri ve diğer harcama vergileri | 15 | 3 | 5 | 3 | 7 | 10 |
| HSV | KDV | KDV konusu mükellefiyet ve vergiyi doğuran olay | 23 | 1 | 2 | 3 | 6 | 9 |
| HSV | DMG | Damga vergisi ve harçlar | 15 | 3 | 5 | 2 | 5 | 7 |
| HSV | USL | Harcama vergilerinde usul ve cezalar | 15 | 3 | 5 | 1 | 3 | 5 |
| DTK | GMR | Gümrük mevzuatı temelleri | 37 | 12 | 17 | 11 | 20 | 28 |
| DTK | REJ | Gümrük rejimleri | 19 | 6 | 9 | 5 | 11 | 16 |
| DTK | KMB | Kambiyo mevzuatı | 15 | 7 | 10 | 5 | 10 | 14 |
| DTK | TKP | Tasfiye kaçakçılık muafiyetler ve ticaret politikası önlemleri | 15 | 6 | 9 | 4 | 10 | 14 |
| DTK | VRG | Dış ticaretin vergisel boyutu | 24 | 0 | 0 | 3 | 6 | 9 |
| DTK | IHI | İhracat ve ithalat işlemleri | 31 | 0 | 0 | 2 | 3 | 5 |
| SPM | HAO | Halka açık ortaklıklar | 36 | 4 | 6 | 6 | 14 | 20 |
| SPM | YKF | Yatırım kuruluşları ve kolektif yatırım | 23 | 6 | 9 | 5 | 13 | 19 |
| SPM | IHR | İhraç ve halka arz | 23 | 6 | 9 | 5 | 12 | 17 |
| SPM | PAL | Piyasa altyapısı ve yatırımcı koruma | 15 | 6 | 9 | 4 | 10 | 14 |
| SPM | SUC | Suçlar ve yaptırımlar | 21 | 2 | 3 | 4 | 7 | 10 |
| SPM | DNT | Finansal raporlama ve bağımsız denetim | 15 | 3 | 5 | 3 | 3 | 5 |
| SPM | GEN | SPKn genel hükümler ve Kurul | 27 | 0 | 0 | 3 | 1 | 2 |

Kazanımlar ve her dersin kaynak dosya önekleri: `content/mufredat/ymm.yaml` (`kazanimlar`, `kaynak_dosyalari`).
Test sorularında zorluk: %20 kolay · %45 orta · %35 zor. Klasikte zorluk 2–3.


## 6. Teslim

- **Toplu üretim:** tüm üretimi ara onay beklemeden yap; kontrol toplu yapılacak. Dosyalar yine **en çok 25 soru** ve tek konu: dosya adı `<DERS>_<KONU>_<tarih>_<n>.yaml` (ör. `SHK_TCR_20261105_1.yaml`).
- Dosyaları `content/teslim/ymm/` klasörüne koy (yoksa oluştur). Başka klasöre yazma; bankadaki dosyalara dokunma.
- `id` alanına `TASLAK` yaz; kalıcı kimliği alım sırasında asistan verir. `durum: taslak`, `surum: 1`,
  `uretim.kaynak_turu: yapay_zeka`, `uretim.model: <kullanılan model>`.
- Üretim bitince tek bir `OZET.md` (aynı klasöre): dosya listesi, konu başına soru sayısı, atlanan kazanımlar ve nedeni.

## 7. Kabul süreci (asistan yapar)

Teslim edilen her soru sırayla: şema (G2) → hesap kodu (G4) → alıntının resmî metinde birebir aranması (G6) →
özgünlük/kopya (G7) → kör çözücü + hakem denetiminden geçer. Geçemeyen soru bankaya girmez; ret nedeni partiye yazılır.
Tablodaki "Üretilecek" sütunu bu kayıplar için **%40 fazlası** olarak hesaplandı; tablodaki sayılara uy, fazlasını üretme.

## 8. Örnek klasik vaka (biçim, kısaltılmış)

```yaml
- id: TASLAK
  sinav: ymm
  ders: VTK
  konu: CEZ
  kazanimlar: [vergi ziyaı ve usulsüzlük cezaları, ceza indirimi, uzlaşma ve izaha davet]
  zorluk: 3
  puan: 25
  sure_dk: 30
  soru: |
    (Ü) Ltd. Şti. nezdinde 2026 yılında yapılan vergi incelemesi sonucunda ... ihbarnameler 15/9/2026'da tebliğ edilmiştir:

    | Tespit | Bilgi |
    |---|---|
    | Kurumlar vergisi matrah farkı | 400.000 TL; oran %25 |
    | Özel usulsüzlük cezası (nihai) | 45.000 TL |

    **İstenenler:**
    (a) Kesilecek vergi ziyaı cezasını hesaplayınız. (6 puan)
    (b) VUK md. 376'dan yararlanma şartlarını ve ödenecek toplamı bulunuz. (8 puan)
    (c) Uzlaşmaya konu edilebilecek kalemleri ve süreyi açıklayınız. (6 puan)
    (d) Uzlaşma vaki olmazsa başvurulabilecek yolları açıklayınız. (5 puan)
  cozum: |
    **(a)** Kurumlar vergisi farkı = 400.000 × %25 = 100.000 TL; vergi ziyaı cezası (md. 344/1) ... 
    | Kalem | Tutar | İndirim | Ödenecek |
    |---|---|---|---|
    ...
  puanlama:
  - {olcut: "(a) KV farkı ve vergi ziyaı cezası, tekerrür dahil", puan: 6}
  - {olcut: "(b) md. 376 şartları ve indirimli tutarlar", puan: 8}
  - {olcut: "(c) uzlaşma kapsamı ve süresi", puan: 6}
  - {olcut: "(d) dava yolu ve süreler", puan: 5}
  kaynaklar:
  - {mevzuat: 213 sayılı Vergi Usul Kanunu, madde: md. 376, alinti: '<resmî metinden birebir>'}
  dogrulama: {python: "kv = 400000*0.25\nsonuc = {'a': kv + min(kv*0.5, 20000)}"}
  gecerlilik: {baslangic: '2026-01-01', bitis: null, yila_bagli_tutar: true, yil: 2026}
  durum: taslak
  surum: 1
  uretim: {kaynak_turu: yapay_zeka, model: <model adı>}
```

Tam örnek: `content/klasik/ymm/VTK/CEZ.yaml` (ilk vaka). Şema: `content/schema/klasik.schema.json`.
Test sorusu biçimi Mizan talimatındaki örnekle aynıdır (`sinav: ymm`, `bolum: [YMM]`).
