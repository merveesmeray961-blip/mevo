# YMM SORU YAZARI MANİFESTOSU — KESİN KURALLAR

Bu paket sana Yeminli Mali Müşavirlik (YMM) sınavı için **soru yazma görevi** olarak verildi. Yazdığın her soru
önce **otomatik ön elemeden**, sonra **bağımsız hakemden** (cevap anahtarını görmeden çözer) geçer. Ölçüt: piyasadaki
**en iyi YMM soru bankası kitabı**. Bu belgede "ZORUNLU" ve "YASAK" diye geçen her kural **otomatik ret** sebebidir;
köşeli parantezdeki kod (ör. `[K07]`) ret raporunda o kuralı gösterir. Az ama kusursuz soru, çok ama şüpheli sorudan
değerlidir. Kurala uymayan tek bir soru bile teslimin geri kalanını etkilemez; yalnız o soru elenir.

## 0. Okuma sırası (ZORUNLU)

1. Bu belgenin tamamı.  2. `GOREV_XX.md` (senin görevin).  3. `ORNEKLER.yaml` (kabul edilmiş örnek sorular — kalite çıtası).
4. `BANKADA_OLAN.md` (bankada zaten olan soru kökleri — TEKRARLAMA).  5. Gerektikçe `kaynaklar/` içindeki resmî metinler.

## 1. Görev satırına bağlılık

- `[K01]` GOREV tablosundaki **her satır = tam bir soru**. Satırdaki ders, konu kodu, kazanım, zorluk ve soru biçimi
  **birebir** aynı olmalı. Başka kazanım, başka zorluk, başka biçim = ret.
- `[K02]` Her soruya `gorev_satiri` (tablodaki numara) yaz. Aynı satır numarasını iki kez kullanma.
- `[K03]` **Mevzuat dersinde** (kaynaklar/ klasöründe metin olan derslerde) bir satırı kaynak metin yetersiz olduğu
  için yazamıyorsan **uydurma**; `atlanan` listesine satır numarası ve nedenle yaz.
  **İSTİSNA — FYN (Finansal Yönetim) ve YNM (Yönetim Muhasebesi):** Bu derslerin resmî metni yoktur, `kaynaklar/`
  klasörü bilerek boştur. Bu derslerde kaynak yokluğu atlama sebebi DEĞİLDİR; her satır genel kabul görmüş ders
  bilgisine dayanılarak yazılır. Bu derslerde satır atlayan teslim eksik sayılır.

## 2. Doğruluk (en önemli kısım)

- `[K04]` **Tek doğru şık.** Tam 5 şık (A–E), yalnız biri doğru. İkinci savunulabilir şık, yoruma bağlı cevap,
  tebliğ ile kanun arasında çelişkili konu = ret. Cevabı "hangi görüşe göre" sorusuna bağlı olan soruyu yazma.
- `[K05]` **Kök kendi kendine yeterli.** Çözüm için gereken HER koşul kökte yazılı olmalı: yöre/bölge, süre, kişi
  türü (tam/dar mükellef, gerçek/tüzel), tarih, istisna şartının sağlanıp sağlanmadığı, gün/ay esası, KDV dahil mi,
  yuvarlama kuralı. Hakem eksik koşul bulursa soru elenir. "Diğer koşullar sağlanmıştır" gibi genel ifade YETMEZ;
  sonuca etki eden koşulu açıkça yaz.
- `[K06]` **2026 güncelliği.** Yalnız `kaynaklar/` içindeki güncel metne dayan. Mülga hükümden, eski orandan, eski
  tutardan soru yazma. Yıla bağlı tutar varsa kökte ver; `gecerlilik.yila_bagli_tutar: true`, `yil: 2026` yaz.
- `[K07]` **Alıntı birebir.** `kaynaklar[].alinti` resmî metinden **kelimesi kelimesine** kopya olmalı (en çok 600
  karakter; uzunsa `…` ile kes). Otomatik aranır, bulunamazsa soru elenir. Emin değilsen `alinti` alanını hiç yazma.
  Metni olmayan derslerde (FYN, YNM): `mevzuat: "Genel bilgi — <konu adı>"`, `madde: "-"`, `alinti` yazma.
- `[K08]` Madde/fıkra/bent/paragraf numarası doğru olmalı (ör. `md. 32/C-1`, `TFRS 16 par. 26`).
- `[K09]` `gecerlilik.baslangic` = sorulan hükmün **yürürlük** tarihi (YYYY-AA-GG).

## 3. Şıklar

- `[K10]` **Şık yapısı cevabı ele vermesin.** YASAK: doğru şıkkın tek "olumlu/olumsuz" şık olması (dördü "girmez",
  doğru "girer"); doğru şıkkın diğerlerinden belirgin uzun veya kısa olması (en uzun şıkkın %30'dan fazla uzun
  olması otomatik ret); doğru şıkkın kökteki ifadeyi tekrar etmesi; her çeldiricinin doğru şıktan yalnız bir
  noktada ayrılması (eleme yoluyla doğru şık bulunur).
- `[K11]` **Makul çeldirici.** Her yanlış şık konuyu yarım bilen adayı çekmeli: komşu madde, yakın oran/süre, ters
  yön, eksik şart, tipik hesap hatası. YASAK şıklar: "Hepsi", "Hiçbiri", "Yukarıdakilerin tümü", "Bilinmez",
  şaka/konu dışı şık, kökle dilbilgisi uyumsuz şık.
- `[K12]` **Sayısal şıklar** küçükten büyüğe sıralı; her şıkta tek sayı (ör. "1.250.000 TL"). Sayı + yorum içeren
  şıkta ("150.000 TL azalır") `dogrulama.secenek_sayisi_bekleniyor: false` yaz.
- `[K13]` Doğru şık harfleri teslim içinde A–E arasında dengeli dağılmalı (hiçbir harf %30'dan fazla değil).

## 4. Biçim

- `[K14]` Olumsuz kök **kalın**: "hangisi **yanlıştır**?", "hangisi **değildir**?", "**yer almaz**".
- `[K15]` Öncüllü soruda öncüller `I.`, `II.`, `III.` (gerekirse `IV.`) ile ayrı satırlarda; şıklar "Yalnız I",
  "I ve II" biçiminde.
- `[K16]` Türkçe resmî sınav dili; Türkçe karakterler doğru (ı, İ, ş, ğ, ü, ö, ç). Tablo gerekiyorsa kökte
  `| a | b |` biçimi.
- `[K17]` Kök en az 15 karakter; şıklar boş olamaz; `celdiriciler` **sözlük** ve yalnız 4 yanlış şık harfi.

## 5. Zorluk (kitap standardı)

- 1 kolay: tek hüküm/tek adım ama ayırt edici (şart, süre, oran, istisna). Tanım ezberi DEĞİL.
- 2 orta: iki adım ya da bir hükmün bir olaya uygulanması.
- 3 zor: en az iki hüküm/hesap adımı birleşir; senaryo çözümlemesi, istisnanın istisnası, sıralama, birden çok
  kalemin birlikte etkisi. Zorluk BELİRSİZLİKTEN gelemez. Zor sorularda `dogru_neden` sonunda
  "Püf noktaları:" ile **o soruya özgü** kısa not yaz (aynı cümleyi her soruya kopyalama).
- `[K18]` Tek maddeyi ezber soran soru zorluk 3 diye etiketlenemez (hakem seviyeyi düşürürse soru elenir).

## 6. Hesaplama soruları

- `[K19]` `tip: hesaplama` ise `dogrulama.python` ZORUNLU: kod `sonuc` adlı değişkene doğru şıktaki sayıyı atar.
- `[K20]` Kod yalnız şunları kullanabilir: `+ - * / // % **`, `round`, `abs`, `min`, `max`, `sum`, değişken,
  `if/for`, liste/sözlük. YASAK: `import`, `int(...)`, `float(...)`, liste/üreteç ifadesi (`[x for x in ...]`,
  `sum(x for ...)`), fonksiyon tanımı. Düz döngü yaz. Kod çalışmazsa veya sonuç doğru şıkla eşleşmezse soru elenir.
- `[K21]` Sayılar hesap makinesiz çözülebilir olsun; yüzde/oran verirken çözümde aynı birimi kullan.
- Hesap adımlarını `aciklama.hesap_adimlari` listesine yaz. Yevmiye kaydı Tekdüzen Hesap Planı'na birebir uymalı
  (hesap kodu + adı: `153 Ticari Mallar`).

## 7. Özgünlük ve tekrar

- `[K22]` `BANKADA_OLAN.md` içindeki soruların bilgisini, kurgusunu, sayısal senaryosunu tekrar etme. Aynı kazanımın
  başka bir hükmünü/istisnasını/uygulamasını sor. Benzerlik taraması yakın soruyu otomatik eler.
- `[K23]` Kendi teslimin içinde iki soru aynı bilgiyi sınamamalı.
- `[K24]` Çıkmış sınav sorusu, ders kitabı veya internet sorusu kopyalama/taklit YASAK. Kişi/şirket adları,
  sayılar ve kurgu senin olsun.

## 8. Klasik (açık uçlu) sorular

GOREV'de "Klasik" bölümündeki her satır bir klasik sorudur. Gerçek YMM yazılı sınavı biçimindedir.

- `[K30]` `soru`: Markdown. Gerçekçi işletme verisi (tablo olabilir) + 2–4 istek: `(a) ... (8 puan)` biçiminde,
  her isteğin puanı parantezde. Toplam `puan` 20–25; `sure_dk` 25–35.
- `[K31]` `cozum`: Her isteğin tam cevabı; hesap adımları, yevmiye kayıtları, mevzuat dayanağı. Adayın kendi
  cevabını karşılaştırabileceği netlikte. Çözümdeki her sayı soru verisiyle tutarlı olmalı.
- `[K32]` `puanlama`: `[{olcut, puan}]`; puanların toplamı `puan` alanına **tam** eşit; ölçütler kısmi puan vermeye
  elverişli (bir ölçüt = bir doğrulanabilir adım).
- `[K33]` Hesaplı klasik soruda `dogrulama.python`: kod `sonuc` adlı **sözlüğe** ana sonuçları atar
  (`sonuc = {"serefiye": 150000}`). Her değer **çözüm metninde aynı birimle** geçmeli (çözümde "%15" yazıyorsan kodda
  `15`, `0.15` değil). [K20] kod kuralları burada da geçerli.
- `[K34]` Klasik soruda da [K04]–[K09] geçerlidir: eksik koşul, yoruma bağlı sonuç, mülga hüküm = ret.

## 9. Teslim biçimi (ZORUNLU)

Tek bir YAML dosyası: `teslim_<asistanadi>_<GOREV_KODU>.yaml`. Başka hiçbir şey yazma (açıklama, özür, markdown
çerçevesi YOK; yalnız YAML). Dosya şöyle başlar:

```yaml
yazar: "<asistan adı, ör. chatgpt / gemini / grok>"
gorev: "<GOREV_XX.md başlığındaki kod>"
atlanan:
  - {satir: 7, neden: "kazanım için kaynak metin yok"}
sorular:
  - gorev_satiri: 1
    bolum: [YMM]
    ders: IFM
    konu: KON
    kazanim: "TFRS 3 satın alma yöntemi ve şerefiye"
    tip: hesaplama            # bilgi | kavrama | uygulama | hesaplama
    zorluk: 3
    soru_bicimi: standart     # standart | olumsuz | oncullu | bosluk | yevmiye
    kok: "…"
    secenekler: {A: "…", B: "…", C: "…", D: "…", E: "…"}
    dogru: C
    aciklama:
      dogru_neden: "… Püf noktaları: …"
      celdiriciler: {A: "…", B: "…", D: "…", E: "…"}
      hesap_adimlari: ["…", "…"]
    kaynaklar:
      - {mevzuat: "TFRS 3 İşletme Birleşmeleri", madde: "par. 32", alinti: "…birebir…"}
    gecerlilik: {baslangic: "2005-01-01", bitis: null, yila_bagli_tutar: false}
    dogrulama: {python: "sonuc = 150000"}
klasik:
  - gorev_satiri: K1
    ders: IFM
    konu: KON
    kazanimlar: ["…", "…"]
    zorluk: 3
    puan: 25
    sure_dk: 30
    soru: |
      …
    cozum: |
      …
    puanlama: [{olcut: "…", puan: 10}, {olcut: "…", puan: 15}]
    kaynaklar: [{mevzuat: "…", madde: "…"}]
    gecerlilik: {baslangic: "2026-01-01", bitis: null}
    dogrulama: {python: "sonuc = {'serefiye': 150000}"}
```

`id`, `durum`, `surum`, `uretim` alanlarını YAZMA. YAML'da `:` içeren metinleri tırnak içine al; çok satırlı
metinlerde `|` kullan.

## 10. Teslimden önce kendi kontrolün (her soru için)

- [ ] Satırdaki ders/konu/kazanım/zorluk/biçim birebir aynı. [K01]
- [ ] Cevabı anahtara bakmadan baştan çözdüm; tek doğru şık var; sonuç yoruma bağlı değil. [K04]
- [ ] Sonuca etki eden her koşul kökte açıkça yazılı. [K05]
- [ ] Şık uzunlukları dengeli; doğru şık tek farklı şık değil; yasak şık yok. [K10][K11]
- [ ] Olumsuz kök kalın. [K14]
- [ ] Alıntılar birebir; emin olmadığım alıntıyı yazmadım. [K07]
- [ ] Hesap sorusunda kod kurallara uygun ve sonuç doğru şıkla aynı. [K19][K20]
- [ ] Klasik soruda puanlama toplamı = puan; kod değerleri çözümde aynı birimle geçiyor. [K32][K33]
- [ ] Bankada olan soruları tekrar etmedim. [K22]
