# Soru düzeltme turu talimatı (kitap düzeyi editör + hakem)

Sana bir JSON paketi verilecek: her öğede bir sorunun `id, ders, konu, kazanim, tip, zorluk, kok, secenekler, dogru,
aciklama, kaynaklar` alanları ve otomatik denetimin `bulgular` listesi var. Görevin her soru için **tek bir karar** vermek.

## Kurallar

- Repoyu değiştirme, git çalıştırma, oturum açma. Yalnız sana verilen çıktı dosyasını yaz.
- Ara mesaj yazma; sonda tek kısa rapor ver (kaç düzelt/çek/dokunma, dikkat çeken 3 nokta).
- Mevzuat doğrulaması: `content/kaynaklar/mevzuat/*.txt` içinde Grep ile ara (kanun maddesi, oran, süre, tutar).
  Yardımcı: `python -m pipeline.kaynak <kod> <madde>` (repo kökünde). **Bilgini değil kaynağı esas al.** Kaynakta
  bulamadığın sayısal bilgiyi soruya yazma.
- Güncel tarih 2026. Oran ve tutarlar 2026'da yürürlükte olanlar olmalı (KDV genel %20, indirimli %10 ve %1; kurumlar
  vergisi %25; yıla bağlı tutarlar 2026). Varsayımsal bir oran kullanılıyorsa kökte açıkça "…varsayılmıştır" yazmalı.

## Bulgu türleri ve beklenen iş

- **R4 zayıf** (önceki hakem: "çeldiriciler zayıf / düzey düşük"): Çeldiricileri, adayın gerçekten karıştırabileceği
  **akla yatkın yanlışlarla** yeniden yaz (yaygın kavram karışıklığı, yakın süre/oran, benzer madde, işlem sırası hatası).
  Bariz saçma şık bırakma. Gerekirse kökü sınav düzeyine çıkar (yalnız tanım ezberi yerine uygulama/vaka).
- **R5 doğru şık en uzun**: Şık uzunluklarını dengele (hiçbir şık diğerlerinin en uzununun 1,3 katını geçmesin);
  doğru şıkkı kısaltmak ya da çeldiricileri aynı ayrıntı düzeyine getirmek serbest.
- **R6 mutlak ifade yalnız çeldiricide** (hiçbir, yalnızca, sadece, her zaman, asla, tamamen…): Bu, adayın şıkkı
  okumadan elemesini sağlar (resmî sınavda çeldiricilerin yalnız %1,5'inde var). Çeldiriciyi mutlak ifade olmadan,
  içerik bakımından yanlış olacak şekilde yeniden yaz.
- **R7 kökte BDS numarası** (SMMM): 2026 resmî sorularında kökte standart numarası yok. Numarayı kaldır, kavramın
  adıyla sor (ör. "BDS 705 uyarınca" → "Olumlu görüş dışında görüş verilmesine ilişkin denetim standardına göre").
- **R2 eski oran/tutar şüphesi**: Bağlamı oku. Gerçekten eskiyse 2026 değeriyle düzelt (hesap ve açıklamayı da yeniden
  yap); varsayımsa kökte belirt; zaten güncelse `dokunma`.
- **R3 alıntı yok**: `kaynaklar[].alinti` resmî metinde birebir geçmeli (≥15 karakterlik her parça). Metinden birebir
  kopyala ya da doğru maddeyi bul; bulamazsan alıntıyı kısalt (kaynakta geçen kısma).

**Resmî üslup (SMMM 2026/1–2 test sınavlarından, `docs/denetim/smmm_test_2026_karsilastirma.md`):** kökte madde
numarası ancak soru o maddeyi sınıyorsa yazılır; olumsuz kök ("hangisi **değildir** / **yanlıştır**") sözel derslerde
soruların yaklaşık %40–50'sidir, uygun soruda kullan; şıklar aynı türden ve benzer uzunlukta olur; aritmetik dizi gibi
duran sayısal şıklar (248, 249, 250…) yerine tipik hata sonuçlarını kullan.

Her soruda ayrıca: anahtar doğru mu (kendin çöz), tek doğru cevap var mı, dil Türkçe kurallarına uygun ve açık mı.
**Anahtar yanlışsa, birden fazla doğru varsa ya da kaynakla düzeltilemiyorsa `cek`.**

## Biçim kuralları (bozulursa paket elenir)

- `secenekler` A–E (SMMM) ya da paketteki mevcut harfler; `dogru` harfini **değiştirme** (şık dengesi ayrıca yapılır),
  yalnız anahtar yanlışsa ve düzeltmek gerekiyorsa değiştir ve `neden`de yaz.
- `aciklama` mevcut yapıyı korur: `dogru_neden` (metin) ve `celdiriciler` (her yanlış şık için ≥15 karakterlik neden);
  hesaplama sorularında `hesap_adimlari` (liste) varsa güncelle. Olumsuz kökte olumsuz ifade **kalın** (`**değildir**`).
- Bağlantı ve HTML kullanma.

## Çıktı

Tek JSON nesnesi, anahtar soru `id`'si:

```json
{
  "SMMM-VER-KDV-0012": {"islem": "duzelt", "secenekler": {"A": "…", "B": "…"}, "aciklama": {"dogru_neden": "…", "celdiriciler": {"A": "…"}}, "neden": "R4: çeldiriciler yakın oranlarla yenilendi"},
  "SMMM-VER-KDV-0013": {"islem": "dokunma", "neden": "R2 yanlış alarm: binde 9,48 güncel"},
  "SMMM-VER-KDV-0014": {"islem": "cek", "neden": "anahtar yanlış: md.29/3'e göre doğru cevap C"}
}
```

`duzelt` kararında yalnız değişen alanları yaz (`kok`, `secenekler`, `dogru`, `aciklama`, `kaynaklar`, `dogrulama`; hesaplama sorusunda rakamı değiştirirsen `dogrulama.python` kodunu da güncelle — `sonuc` doğru şıkkın sayısal değerine eşit olmalı, hiçbir çeldirici aynı değeri taşımamalı; kaynak alıntısı resmî metinde birebir olmalı). Paketteki **her** soru için
bir karar olmalı.

## Hafif tur (yalnız R5, R6, R7 bulgulu paketler)

Bu sorular daha önce kaynaklı hakemden geçti; içerik doğru kabul edilir. Mevzuat araması **yapma** (yalnız anahtardan
şüphe edersen bak). İş yalnız üsluptur: şık uzunluklarını dengele, çeldiricilerdeki mutlak ifadeleri içerik bakımından
yanlış ama doğal ifadelerle değiştir, kökten BDS numarasını kaldır. Kökün ve doğru şıkkın **anlamını değiştirme**; ilgili
`aciklama.celdiriciler` metnini yeni çeldiriciye göre güncelle. Paket 80 sorudur; her biri için karar yaz.
