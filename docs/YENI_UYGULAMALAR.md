# Sıradaki uygulamalar — araştırma ve hazırlık talimatı (8 Ekim 2026)

## Strateji: tek motor, çok sınav
SMMM için kurduğumuz her şey (soru bankası şeması, kalite hattı, harici üretici paketleri, kör çözücü denetimi,
mevzuat arşivi + Mevzuat sekmesi, Flutter uygulaması, tek seferlik satın alma) **sınavdan bağımsız**.
Cumartesi ilk iş: uygulamayı "beyaz etiket" yapmak (sınav = bir veri paketi + renk/isim/ikon). Sonra her yeni
uygulama = yeni müfredat + mevzuat + soru üretimi; kod neredeyse hiç yazılmaz.

Seçim ölçütleri: (1) zorunlu/kariyer belgesi → ödeme isteği yüksek, (2) her yıl düzenli aday akışı,
(3) içerik resmî mevzuata dayalı → bizim alıntı-doğrulamalı hattımız rakiplerden üstün, (4) SMMM ile örtüşme.

## Önerilen 4 uygulama (öncelik sırasıyla)

| # | Uygulama | Hedef kitle / talep | Neden biz | Fiyat önerisi |
|---|---|---|---|---|
| 1 | **SPK Lisanslama** (Düzey 1, Düzey 2, Düzey 3, Türev Araçlar, Konut Değerleme) | Banka/aracı kurum çalışanları; lisans almadan çalışma süresi sınırlı (yardımcı personel 31.01.2026 sonrası lisans zorunlu) | SPK mevzuatı + tebliğler zaten arşivde; Düzey 2'deki muhasebe/ticaret hukuku SMMM bankasından gelir. **En yüksek yeniden kullanım** | 499–749 TL (kurum çalışanı öder) |
| 2 | **İSG Uzmanlığı + İşyeri Hekimliği** (A/B/C sınıfı, ÖSYM) | Her dönem on binlerce aday (2018/1'de yalnız C sınıfına 23.674 başvuru) | Tamamen mevzuata dayalı (6331 ve yönetmelikleri); mevzuat sekmemiz birebir uyuyor | 349–449 TL |
| 3 | **HMGS** (Hukuk Mesleklerine Giriş, ÖSYM, yılda 2 kez) | Her oturumda ~16 bin hukuk mezunu (2025/2: 16.240 başvuru); avukat/hâkim olmak için zorunlu | TBK, TTK, İYUK, İşK, Anayasa, TMK arşivde; eklenecek: TCK, CMK, HMK, İİK, İdare hukuku | 499–699 TL |
| 4 | **Emlak Danışmanı MYK (Seviye 4 / 5)** | Türkiye'de ~142 bin emlak danışmanı; MYK belgesi zorunlu | Mevzuat: Taşınmaz Ticareti Yönetmeliği, TBK kira, tapu/imar; kısa ve net müfredat | 199–299 TL (hacim) |

Bonus (çok ucuz): **KGK Bağımsız Denetçilik Sınavı** — konular SMMM ile büyük ölçüde aynı; mevcut bankadan
"Denetçi" sürümü çıkar. Aday az ama ödeme isteği yüksek.

## Senin 3 günlük hazırlığın (token harcamadan)

Her uygulama için ayrı klasör aç: `SPK/`, `ISG/`, `HMGS/`, `EMLAK/`. İçine:

1. **Resmî sınav kılavuzu ve konu listesi** (PDF): SPL (spl.com.tr) e-LS kılavuzu ve konu başlıkları;
   ÖSYM İSG ve HMGS kılavuzları; MYK Emlak Danışmanı ulusal yeterliliği (Seviye 4 ve 5).
2. **Sınav biçimi notu** (tek sayfa): soru sayısı, süre, baraj puanı, yılda kaç sınav, başvuru ücreti, son 2 yıl sınav tarihleri.
3. **Mevzuat listesi + PDF'ler**: konu listesinde geçen her kanun/yönetmelik/tebliğ için mevzuat.gov.tr PDF'i
   (dosya adına kanun numarası yaz: `6331.pdf`). Benim indirmem bazen zaman aşımına düşüyor; senin indirmen en sağlamı.
4. **Rakip taraması**: Play Store'da "SPK lisans", "İSG sınav", "HMGS", "emlak danışmanı sınav" ara;
   ilk 5 uygulamanın adı, fiyatı, indirme sayısı, puanı, ekran görüntüsü ve kötü yorumları (eksikleri = bizim fırsatımız).
5. **Müfredat taslağı** (ChatGPT'ye yaptırabilirsin): aşağıdaki biçimde, resmî konu listesinden birebir:

```yaml
dersler:
  - kod: MEV            # 3 harf
    ad: Sermaye Piyasası Mevzuatı
    soru: {sinav: 25}   # sınavda bu dersten kaç soru çıkıyor
    konular:
      - {kod: SPK, ad: 6362 sayılı SPKn genel hükümler, agirlik: {sinav: 30},
         kazanimlar: [ihraç ve izahname, halka açık ortaklıklar, sermaye piyasası suçları]}
    kaynaklar: [6362 SPKn, II-5.1 Tebliği]
```
   Kural: kazanım adlarında virgül kullanma (gerekirse noktalı virgül).

6. **Mağaza**: her uygulama için isim önerisi (3 alternatif), kısa açıklama, ikon fikri.

## Cumartesi planı (kota yenilenince)
1. Uygulamayı beyaz etikete çevir (sınav yapılandırması, uygulama kimliği, tema) — SMMM bozulmadan.
2. Senin klasörlerinden müfredat + mevzuat arşivini sisteme al → harita + üretici paketlerini oluştur.
3. Paketleri sen asistanlara dağıt; teslimler geldikçe aynı denetim hattı.
4. Sırayla: SPK → İSG → HMGS → Emlak.
