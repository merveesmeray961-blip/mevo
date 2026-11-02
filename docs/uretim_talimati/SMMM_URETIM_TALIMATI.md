# Mizan SMMM — özgün soru üretim talimatı (hedef 5.000)

Hazırlanış: 2 Kasım 2026 · Dağılım betiği: `docs/uretim_talimati/dagilim.py` · Ham tablo: `dagilim_smmm.csv`

## 1. Hedef

- Bankada şu an **3223 özgün soru** var (çıkmış sorular hariç). Hedef **5.000** → **net 1777 yeni soru** kabul edilmeli.
- Kayıp payı (%30 ret varsayımı) dahil **üretilecek toplam: 2630 soru.**
- Dağılım sınavdaki soru oranlarına göre yapıldı: her konunun payı = dersin sınavdaki soru sayısı × konunun ders içi
  ağırlığı. Bankada **az sorusu olan konular öne alındı**; her konu en az 40 soruya tamamlanıyor. Zaten yeterli
  olan konulara (ör. Denetim/BDY, Vergi, Hukuk) üretim verilmedi.
- **En büyük açık: SGS Hukuk (SHK) dersi bankada hiç yok** (SGS'de 24 soru, sınavın beşte biri). İlk önce bu üretilmeli.
  Ardından Finansal Tablolar Analizi, Sermaye Piyasası ve Maliyet.

## 2. Ders özeti

| Ders | Ad | Mevcut | Net ihtiyaç | Sonra | Üretilecek |
|---|---|---|---|---|---|
| FIN | Finansal Muhasebe | 297 | 147 | 444 | 235 |
| TAB | Finansal Tablolar ve Analizi | 99 | 292 | 391 | 420 |
| MAL | Maliyet Muhasebesi | 237 | 186 | 423 | 275 |
| DEN | Muhasebe Denetimi | 416 | 139 | 555 | 215 |
| VER | Vergi Mevzuatı ve Uygulaması | 414 | 14 | 428 | 20 |
| HUK | Hukuk | 402 | 13 | 415 | 20 |
| SPK | Sermaye Piyasası Mevzuatı | 158 | 237 | 395 | 340 |
| MES | Muhasebecilik ve Mali Müşavirlik Meslek Hukuku | 329 | 77 | 406 | 120 |
| STD | Muhasebe Standartları | 115 | 82 | 197 | 125 |
| SHK | SGS Hukuk (İş-SGK; Vergi; Ticaret; Borçlar) | 0 | 464 | 464 | 660 |
| EKO | Ekonomi | 79 | 55 | 134 | 90 |
| MLY | Maliye | 124 | 9 | 133 | 15 |
| GKY | Genel Kültür, Yetenek ve Yabancı Dil (SGS) | 553 | 62 | 615 | 95 |
| **Toplam** | | **3223** | **1777** | **5000** | **2630** |

**Durum (2 Kasım):** SHK/TCR ilk parti 12/12 kabul edildi → TCR'de kalan net ihtiyaç ≈ 104.

**Öncelik sırası:** 1) SHK (4 konu; önce TCR'yi bitir: ticari temsilci, kıymetli evrak — poliçe, bono, çek) → 2) TAB → 3) SPK → 4) MAL → 5) FIN → 6) DEN → 7) STD → 8) MES → 9) EKO, GKY → 10) diğerleri.


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

## 4. Konu konu dağılım

`Bölüm` sütunu soruya yazılacak `bolum` listesidir (SGS+YET → `[SGS, YET]`). SGS düzeyi: tek adımlı, temel kavram/işlem;
Yeterlilik düzeyi: çok adımlı senaryo. **Zorluk dağılımı:** Yeterlilik içeren konularda %20 kolay · %45 orta · %35 zor;
yalnız SGS konularında %25 · %50 · %25. **Tip:** hesaplı derslerde (FIN, TAB, MAL) en az %50 `hesaplama`/`uygulama`;
sözel derslerde `kavrama` ve `uygulama` ağırlıklı, `bilgi` en çok %25.

| Ders | Konu | Konu adı | Bölüm | Mevcut | Net | Sonra | Üretilecek |
|---|---|---|---|---|---|---|---|
| FIN | STK | Stoklar ve ticari mallar | SGS+YET | 59 | 22 | 81 | 35 |
| FIN | MDV | Maddi ve maddi olmayan duran varlıklar | SGS+YET | 55 | 18 | 73 | 30 |
| FIN | MKY | Menkul kıymetler ve ortaklık payları | SGS+YET | 45 | 8 | 53 | 15 |
| FIN | DON | Dönem sonu tahakkuk | SGS+YET | 33 | 19 | 52 | 30 |
| FIN | ALC | Alacaklar ve senetler | SGS+YET | 21 | 19 | 40 | 30 |
| FIN | BOR | Yabancı kaynaklar ve mali borçlar | SGS+YET | 34 | 7 | 41 | 10 |
| FIN | OZK | Özkaynak işlemleri | SGS+YET | 28 | 36 | 64 | 55 |
| FIN | HAZ | Hazır değerler | SGS+YET | 22 | 18 | 40 | 30 |
| TAB | DVR | Devir hızları ve süreleri | SGS+YET | 18 | 79 | 97 | 115 |
| TAB | LIK | Likidite ve finansal yapı oranları | SGS+YET | 15 | 55 | 70 | 80 |
| TAB | DIK | Dikey | SGS+YET | 27 | 117 | 144 | 165 |
| TAB | KAR | Kârlılık oranları | SGS+YET | 15 | 25 | 40 | 35 |
| TAB | TMS | Finansal tablolar ve TMS 1 / nakit akışı | SGS+YET | 24 | 16 | 40 | 25 |
| MAL | TBL | Maliyet tabloları ve geri hesaplar | SGS+YET | 64 | 10 | 74 | 15 |
| MAL | KAV | Temel kavramlar ve GÜG kalemleri | SGS+YET | 48 | 36 | 84 | 55 |
| MAL | 7AB | 7/A ve 7/B seçenekleri ve hesap akışı | SGS+YET | 46 | 15 | 61 | 25 |
| MAL | ORT | Ortak ve yan ürün | SGS+YET | 15 | 32 | 47 | 45 |
| MAL | SAF | Safha maliyeti ve eşdeğer birim | SGS+YET | 15 | 25 | 40 | 35 |
| MAL | SIP | Sipariş maliyeti ve GÜG yükleme/dağıtım | SGS+YET | 15 | 25 | 40 | 35 |
| MAL | STD | Standart maliyet ve sapmalar | SGS+YET | 19 | 20 | 39 | 30 |
| MAL | DIG | Değişken/tam maliyet | SGS+YET | 15 | 23 | 38 | 35 |
| DEN | RAP | Raporlama ve görüş türleri | SGS+YET | 31 | 33 | 64 | 50 |
| DEN | KNT | Denetim kanıtı | SGS+YET | 31 | 20 | 51 | 30 |
| DEN | RSK | Risk | SGS+YET | 53 | 43 | 96 | 65 |
| DEN | ICK | İç kontrol ve hile | SGS+YET | 24 | 24 | 48 | 35 |
| DEN | KAL | Kalite yönetimi ve etik kurallar | SGS+YET | 33 | 8 | 41 | 15 |
| DEN | PRG | Hesap bazlı denetim programları | SGS | 28 | 11 | 39 | 20 |
| VER | GVK | Gelir vergisi | YET | 67 | 14 | 81 | 20 |
| HUK | SGK | Sosyal güvenlik (5510) | YET | 96 | 7 | 103 | 10 |
| HUK | ISH | İş hukuku (4857; 7036) | YET | 76 | 6 | 82 | 10 |
| SPK | HAO | Halka açık ortaklıklar | YET | 33 | 46 | 79 | 65 |
| SPK | SUC | Suçlar | YET | 29 | 50 | 79 | 70 |
| SPK | KYK | Kolektif yatırım kuruluşları | YET | 20 | 39 | 59 | 55 |
| SPK | IZA | İzahname ve halka arz | YET | 18 | 31 | 49 | 45 |
| SPK | ALT | Piyasa altyapıları | YET | 15 | 24 | 39 | 35 |
| SPK | YEN | Kripto varlıklar | YET | 19 | 21 | 40 | 30 |
| SPK | YHZ | Yatırım hizmetleri ve tazmin | YET | 24 | 26 | 50 | 40 |
| MES | KAN | 3568 sayılı Kanun | SGS+YET | 62 | 9 | 71 | 15 |
| MES | ETK | Etik İlkeler Yönetmeliği | SGS+YET | 54 | 7 | 61 | 10 |
| MES | CUE | Çalışma Usul ve Esasları | SGS+YET | 46 | 15 | 61 | 25 |
| MES | DIS | Disiplin Yönetmeliği | SGS+YET | 35 | 15 | 50 | 25 |
| MES | HRK | Haksız Rekabet ve Reklam Yasağı | SGS+YET | 35 | 6 | 41 | 10 |
| MES | DGR | Diğer yönetmelikler | SGS+YET | 97 | 25 | 122 | 35 |
| STD | TFR | TMS/TFRS ve Kavramsal Çerçeve | SGS | 85 | 36 | 121 | 55 |
| STD | MBS | Muhasebe bilgi sistemi | SGS | 15 | 23 | 38 | 35 |
| STD | KRL | Meslek kuruluşları ve sürdürülebilirlik | SGS | 15 | 23 | 38 | 35 |
| SHK | ISG | İş ve sosyal güvenlik hukuku | SGS | 0 | 116 | 116 | 165 |
| SHK | VRG | Vergi hukuku | SGS | 0 | 116 | 116 | 165 |
| SHK | TCR | Ticaret hukuku | SGS | 0 | 116 | 116 | 165 |
| SHK | BRC | Borçlar hukuku | SGS | 0 | 116 | 116 | 165 |
| EKO | MIK | Mikro iktisat | SGS | 27 | 15 | 42 | 25 |
| EKO | MAK | Makro iktisat | SGS | 36 | 18 | 54 | 30 |
| EKO | DIS | Dış ekonomi | SGS | 16 | 22 | 38 | 35 |
| MLY | KGH | Kamu gelirleri ve harcamaları | SGS | 41 | 2 | 43 | 5 |
| MLY | BUT | Bütçe ve kamu açığı | SGS | 32 | 7 | 39 | 10 |
| GKY | TUR | Türkçe | SGS | 121 | 20 | 141 | 30 |
| GKY | MAT | Matematik | SGS | 135 | 30 | 165 | 45 |
| GKY | TAR | Atatürk İlkeleri ve İnkılap Tarihi | SGS | 98 | 7 | 105 | 10 |
| GKY | ING | İngilizce | SGS | 199 | 5 | 204 | 10 |

Konuların kazanım listesi: `content/mufredat/smmm.yaml` (her konunun `kazanimlar` alanı). Bir partide kazanımları
döndür; aynı kazanımdan arka arkaya soru yazma.

## 5. Ders bazında stil ve kaynaklar

| Ders | Kaynak dosyalar (`content/kaynaklar/mevzuat/`) | Stil |
|---|---|---|
| FIN | msugt_*, kavramsal_cerceve, bobi_frs, vuk, ttk, tms_2/16/38/40 | Aksi belirtilmedikçe Tekdüzen (MSUGT); KDV %20. Şıklar çoğunlukla THP kodlu yevmiye kaydı ya da "X hesabına N ₺ borç/alacak". Çeldirici: yakın hesap, ters taraf, KDV hatası. |
| TAB | msugt_*, tms_1, tms_7 | Kökte "ortalama değer; yıl 360, ay 30 gün". Dikey analizde baz net satışlar. Bilanço/gelir tablosunu Markdown tabloyla ver. Grafik yok. |
| MAL | msugt_* (7/A–7/B), vuk | Kökte "KDV dikkate alınmayacaktır". Harf kodlu işletme (A, AB, AX İşletmesi). Finansman/genel yönetim gideri tuzağı. |
| DEN | bds_*, sbds_*, kys_*, bagimsiz_denetim_yon, bd_etik_kurallar, kgk_660_khk, ttk | Tamamen sözel; kökte BDS numarası ve adı; olumsuz kök ≈ %40. |
| SPK | spk* (6362 SPKn ve SPK tebliğleri) | %20 öncüllü (I/II/III); kanun/tebliğ dili; kripto varlık hükümleri 7518 sonrası güncel hâliyle. |
| MES | smmm_* (3568), ymm_*, turmob, disiplin_yon, calisma_usul_yon, etik_ilkeler_yon, haksiz_rekabet_yon, aklama_5549 | Ezber bilgi; olumsuz kök ≈ %50; şıklar süre, sayı, kurul adı. |
| STD | tms_*, tfrs_*, kavramsal_cerceve, bobi_frs, tsrs_* | SGS düzeyi; standart numarası ve adı kökte. |
| SHK | ISG→isk, sgk; VRG→vuk, gvk, kvk, kdvk; TCR→ttk; BRC→tbk | SGS düzeyi (tek kural, kısa şık). Kökte kanun numarası. İcra-İflas yok. |
| EKO | (mevzuat yok) kaynak: content/anlatim/ altındaki EKO konu anlatımı; `{mevzuat: 'Hakemli konu anlatımı — EKO/<KONU>', madde: '§<bölüm>'}` | SGS düzeyi; tanım, grafik yorumu yok (grafik yasak), basit hesap. |
| MLY | kmyk (5018), harclar, aatuhk, vuk, anayasa | SGS düzeyi kamu maliyesi. |
| GKY | (mevzuat yok; Türkçe dil bilgisi, temel matematik, Atatürk ilkeleri, İngilizce) | Türkçe: dil bilgisi/anlam; Matematik: elle çözülebilir; Tarih: Atatürk ilkeleri ve inkılap tarihi; İngilizce: okuduğunu anlama, kelime, dil bilgisi. `kaynaklar`: `{mevzuat: 'Genel bilgi — <alan>', madde: '-', alinti: '(genel bilgi)'}`. |
| VER, HUK | gvk, kvk, kdvk, vuk, aatuhk (6183), otv, dvk, vivk, mtvk, evk, harclar; ttk, tbk, isk (4857), sgk/sosyal_sigorta (5510), sendikalar (6356), iyuk (2577) | Bu dersler yeterli; yalnız tablodaki küçük açıklar. |


## 6. Teslim

- **Toplu üretim:** tüm üretimi ara onay beklemeden yap; kontrol toplu yapılacak. Dosyalar yine **en çok 25 soru** ve tek konu: dosya adı `<DERS>_<KONU>_<tarih>_<n>.yaml` (ör. `SHK_TCR_20261105_1.yaml`).
- Dosyaları `content/teslim/smmm/` klasörüne koy (yoksa oluştur). Başka klasöre yazma; bankadaki dosyalara dokunma.
- `id` alanına `TASLAK` yaz; kalıcı kimliği alım sırasında asistan verir. `durum: taslak`, `surum: 1`,
  `uretim.kaynak_turu: yapay_zeka`, `uretim.model: <kullanılan model>`.
- Üretim bitince tek bir `OZET.md` (aynı klasöre): dosya listesi, konu başına soru sayısı, atlanan kazanımlar ve nedeni.

## 7. Kabul süreci (asistan yapar)

Teslim edilen her soru sırayla: şema (G2) → hesap kodu (G4) → alıntının resmî metinde birebir aranması (G6) →
özgünlük/kopya (G7) → kör çözücü + hakem denetiminden geçer. Geçemeyen soru bankaya girmez; ret nedeni partiye yazılır.
Tablodaki "Üretilecek" sütunu bu kayıplar için **%40 fazlası** olarak hesaplandı; tablodaki sayılara uy, fazlasını üretme.

## 8. Örnek soru (biçim)

```yaml
- id: TASLAK
  sinav: smmm
  bolum: [YET]
  ders: HUK
  unite: İş hukuku (4857, 7036)
  konu: ISH
  kazanim: toplu işçi çıkarma
  tip: uygulama
  zorluk: 2
  soru_bicimi: standart
  kok: 4857 sayılı İş Kanunu'na göre, 260 işçinin çalıştığı bir işyerinde işveren, ekonomik nedenlerle işçi sayısını
    azaltmayı planlamaktadır. Bu işyerinde bir aylık süre içinde aynı tarihte veya farklı tarihlerde, 17. madde uyarınca
    en az kaç işçinin işine son verilmesi toplu işçi çıkarma sayılır?
  secenekler: {A: '10', B: '20', C: '26', D: '30', E: '52'}
  dogru: C
  aciklama:
    dogru_neden: 4857 sayılı Kanun md. 29/2 uyarınca işçi sayısı 101 ile 300 arasında ise en az yüzde on oranında
      işçinin işine son verilmesi toplu işçi çıkarma sayılır. 260 işçinin yüzde onu 26'dır.
    celdiriciler:
      A: En az 10 işçi ölçütü 20–100 işçili işyerleri içindir.
      B: 20, ilk dilimin alt sınırını oluşturan işyeri işçi sayısıdır.
      D: En az 30 işçi ölçütü 301 ve daha fazla işçili işyerleri içindir.
      E: 52, yüzde yirmi oranıyla bulunur; kanundaki oran yüzde ondur.
  kaynaklar:
  - mevzuat: 4857 sayılı İş Kanunu
    madde: md. 29/2
    alinti: 'İşyerinde çalışan işçi sayısı: a) 20 ile 100 işçi arasında ise, en az 10 işçinin, b) 101 ile 300 işçi
      arasında ise, en az yüzde on oranında işçinin, c) 301 ve daha fazla ise, en az 30 işçinin, İşine 17 nci madde
      uyarınca ve bir aylık süre içinde aynı tarihte veya farklı tarihlerde son verilmesi toplu işçi çıkarma sayılır.'
  gecerlilik: {baslangic: '2003-06-10', bitis: null, yila_bagli_tutar: false}
  durum: taslak
  surum: 1
  uretim: {kaynak_turu: yapay_zeka, model: <model adı>}
```

Hesap sorusunda ek alanlar: `aciklama.hesap_adimlari: [..]` ve `dogrulama: {python: "sonuc = 400000 * 0.25"}`.
Tam şema: `content/schema/soru.schema.json`.
