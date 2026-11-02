"""dagilim_*.csv + sabit kurallar → SMMM_URETIM_TALIMATI.md ve YMM_URETIM_TALIMATI.md"""
import csv
from collections import OrderedDict
from pathlib import Path

B = Path(__file__).parent
s = list(csv.DictReader(open(B / "dagilim_smmm.csv", encoding="utf-8")))
y = list(csv.DictReader(open(B / "dagilim_ymm.csv", encoding="utf-8")))

KAYNAK_SMMM = {
    "FIN": "msugt_*, kavramsal_cerceve, bobi_frs, vuk, ttk, tms_2/16/38/40",
    "TAB": "msugt_*, tms_1, tms_7",
    "MAL": "msugt_* (7/A–7/B), vuk",
    "DEN": "bds_*, sbds_*, kys_*, bagimsiz_denetim_yon, bd_etik_kurallar, kgk_660_khk, ttk",
    "VER": "gvk, kvk, kdvk, vuk, aatuhk (6183), otv, dvk, vivk, mtvk, evk, harclar",
    "HUK": "ttk, tbk, isk (4857), sgk/sosyal_sigorta (5510), sendikalar (6356), iyuk (2577)",
    "SPK": "spk* (6362 SPKn ve SPK tebliğleri)",
    "MES": "smmm_* (3568), ymm_*, turmob, disiplin_yon, calisma_usul_yon, etik_ilkeler_yon, haksiz_rekabet_yon, aklama_5549",
    "STD": "tms_*, tfrs_*, kavramsal_cerceve, bobi_frs, tsrs_*",
    "SHK": "ISG→isk, sgk; VRG→vuk, gvk, kvk, kdvk; TCR→ttk; BRC→tbk",
    "EKO": "(mevzuat yok) kaynak: content/anlatim/ altındaki EKO konu anlatımı; `{mevzuat: 'Hakemli konu anlatımı — EKO/<KONU>', madde: '§<bölüm>'}`",
    "MLY": "kmyk (5018), harclar, aatuhk, vuk, anayasa",
    "GKY": "(mevzuat yok; Türkçe dil bilgisi, temel matematik, Atatürk ilkeleri, İngilizce)",
}

ORTAK_KURALLAR = r"""
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
"""

TESLIM = r"""
## 6. Teslim

- **Toplu üretim:** tüm üretimi ara onay beklemeden yap; kontrol toplu yapılacak. Dosyalar yine **en çok 25 soru** ve tek konu: dosya adı `<DERS>_<KONU>_<tarih>_<n>.yaml` (ör. `SHK_TCR_20261105_1.yaml`).
- Dosyaları `content/teslim/{sinav}/` klasörüne koy (yoksa oluştur). Başka klasöre yazma; bankadaki dosyalara dokunma.
- `id` alanına `TASLAK` yaz; kalıcı kimliği alım sırasında asistan verir. `durum: taslak`, `surum: 1`,
  `uretim.kaynak_turu: yapay_zeka`, `uretim.model: <kullanılan model>`.
- Üretim bitince tek bir `OZET.md` (aynı klasöre): dosya listesi, konu başına soru sayısı, atlanan kazanımlar ve nedeni.

## 7. Kabul süreci (asistan yapar)

Teslim edilen her soru sırayla: şema (G2) → hesap kodu (G4) → alıntının resmî metinde birebir aranması (G6) →
özgünlük/kopya (G7) → kör çözücü + hakem denetiminden geçer. Geçemeyen soru bankaya girmez; ret nedeni partiye yazılır.
Tablodaki "Üretilecek" sütunu bu kayıplar için **%40 fazlası** olarak hesaplandı; tablodaki sayılara uy, fazlasını üretme.
"""


def tablo(rows, kolonlar, basliklar):
    out = ["| " + " | ".join(basliklar) + " |", "|" + "---|" * len(basliklar)]
    for r in rows:
        out.append("| " + " | ".join(str(r[k]) for k in kolonlar) + " |")
    return "\n".join(out)


# ---------------- SMMM
ders = OrderedDict()
for r in s:
    d = ders.setdefault(r["ders"], {"ders": r["ders"], "ad": r["ders_ad"].strip('"'), "mevcut": 0, "net": 0, "uret": 0})
    d["mevcut"] += int(r["mevcut"]); d["net"] += int(r["net_ihtiyac"]); d["uret"] += int(r["uretilecek"])
ozet = [dict(v, sonra=v["mevcut"] + v["net"]) for v in ders.values()]
top_m = sum(v["mevcut"] for v in ozet); top_n = sum(v["net"] for v in ozet); top_u = sum(v["uret"] for v in ozet)
konu_rows = [r for r in s if int(r["uretilecek"]) > 0]
for r in konu_rows:
    r["sonra"] = int(r["mevcut"]) + int(r["net_ihtiyac"])
    r["konu_ad"] = r["konu_ad"].strip('"')

smmm = f"""# Mizan SMMM — özgün soru üretim talimatı (hedef 5.000)

Hazırlanış: 2 Kasım 2026 · Dağılım betiği: `docs/uretim_talimati/dagilim.py` · Ham tablo: `dagilim_smmm.csv`

## 1. Hedef

- Bankada şu an **{top_m} özgün soru** var (çıkmış sorular hariç). Hedef **5.000** → **net {top_n} yeni soru** kabul edilmeli.
- Kayıp payı (%30 ret varsayımı) dahil **üretilecek toplam: {top_u} soru.**
- Dağılım sınavdaki soru oranlarına göre yapıldı: her konunun payı = dersin sınavdaki soru sayısı × konunun ders içi
  ağırlığı. Bankada **az sorusu olan konular öne alındı**; her konu en az 40 soruya tamamlanıyor. Zaten yeterli
  olan konulara (ör. Denetim/BDY, Vergi, Hukuk) üretim verilmedi.
- **En büyük açık: SGS Hukuk (SHK) dersi bankada hiç yok** (SGS'de 24 soru, sınavın beşte biri). İlk önce bu üretilmeli.
  Ardından Finansal Tablolar Analizi, Sermaye Piyasası ve Maliyet.

## 2. Ders özeti

{tablo(ozet, ["ders", "ad", "mevcut", "net", "sonra", "uret"], ["Ders", "Ad", "Mevcut", "Net ihtiyaç", "Sonra", "Üretilecek"])}
| **Toplam** | | **{top_m}** | **{top_n}** | **{top_m + top_n}** | **{top_u}** |

**Durum (2 Kasım):** SHK/TCR ilk parti 12/12 kabul edildi → TCR'de kalan net ihtiyaç ≈ 104.

**Öncelik sırası:** 1) SHK (4 konu; önce TCR'yi bitir: ticari temsilci, kıymetli evrak — poliçe, bono, çek) → 2) TAB → 3) SPK → 4) MAL → 5) FIN → 6) DEN → 7) STD → 8) MES → 9) EKO, GKY → 10) diğerleri.

{ORTAK_KURALLAR}
## 4. Konu konu dağılım

`Bölüm` sütunu soruya yazılacak `bolum` listesidir (SGS+YET → `[SGS, YET]`). SGS düzeyi: tek adımlı, temel kavram/işlem;
Yeterlilik düzeyi: çok adımlı senaryo. **Zorluk dağılımı:** Yeterlilik içeren konularda %20 kolay · %45 orta · %35 zor;
yalnız SGS konularında %25 · %50 · %25. **Tip:** hesaplı derslerde (FIN, TAB, MAL) en az %50 `hesaplama`/`uygulama`;
sözel derslerde `kavrama` ve `uygulama` ağırlıklı, `bilgi` en çok %25.

{tablo(konu_rows, ["ders", "konu", "konu_ad", "bolum", "mevcut", "net_ihtiyac", "sonra", "uretilecek"], ["Ders", "Konu", "Konu adı", "Bölüm", "Mevcut", "Net", "Sonra", "Üretilecek"])}

Konuların kazanım listesi: `content/mufredat/smmm.yaml` (her konunun `kazanimlar` alanı). Bir partide kazanımları
döndür; aynı kazanımdan arka arkaya soru yazma.

## 5. Ders bazında stil ve kaynaklar

| Ders | Kaynak dosyalar (`content/kaynaklar/mevzuat/`) | Stil |
|---|---|---|
| FIN | {KAYNAK_SMMM['FIN']} | Aksi belirtilmedikçe Tekdüzen (MSUGT); KDV %20. Şıklar çoğunlukla THP kodlu yevmiye kaydı ya da "X hesabına N ₺ borç/alacak". Çeldirici: yakın hesap, ters taraf, KDV hatası. |
| TAB | {KAYNAK_SMMM['TAB']} | Kökte "ortalama değer; yıl 360, ay 30 gün". Dikey analizde baz net satışlar. Bilanço/gelir tablosunu Markdown tabloyla ver. Grafik yok. |
| MAL | {KAYNAK_SMMM['MAL']} | Kökte "KDV dikkate alınmayacaktır". Harf kodlu işletme (A, AB, AX İşletmesi). Finansman/genel yönetim gideri tuzağı. |
| DEN | {KAYNAK_SMMM['DEN']} | Tamamen sözel; kökte BDS numarası ve adı; olumsuz kök ≈ %40. |
| SPK | {KAYNAK_SMMM['SPK']} | %20 öncüllü (I/II/III); kanun/tebliğ dili; kripto varlık hükümleri 7518 sonrası güncel hâliyle. |
| MES | {KAYNAK_SMMM['MES']} | Ezber bilgi; olumsuz kök ≈ %50; şıklar süre, sayı, kurul adı. |
| STD | {KAYNAK_SMMM['STD']} | SGS düzeyi; standart numarası ve adı kökte. |
| SHK | {KAYNAK_SMMM['SHK']} | SGS düzeyi (tek kural, kısa şık). Kökte kanun numarası. İcra-İflas yok. |
| EKO | {KAYNAK_SMMM['EKO']} | SGS düzeyi; tanım, grafik yorumu yok (grafik yasak), basit hesap. |
| MLY | {KAYNAK_SMMM['MLY']} | SGS düzeyi kamu maliyesi. |
| GKY | {KAYNAK_SMMM['GKY']} | Türkçe: dil bilgisi/anlam; Matematik: elle çözülebilir; Tarih: Atatürk ilkeleri ve inkılap tarihi; İngilizce: okuduğunu anlama, kelime, dil bilgisi. `kaynaklar`: `{{mevzuat: 'Genel bilgi — <alan>', madde: '-', alinti: '(genel bilgi)'}}`. |
| VER, HUK | {KAYNAK_SMMM['VER']}; {KAYNAK_SMMM['HUK']} | Bu dersler yeterli; yalnız tablodaki küçük açıklar. |

{TESLIM.format(sinav="smmm")}
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
  secenekler: {{A: '10', B: '20', C: '26', D: '30', E: '52'}}
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
  gecerlilik: {{baslangic: '2003-06-10', bitis: null, yila_bagli_tutar: false}}
  durum: taslak
  surum: 1
  uretim: {{kaynak_turu: yapay_zeka, model: <model adı>}}
```

Hesap sorusunda ek alanlar: `aciklama.hesap_adimlari: [..]` ve `dogrulama: {{python: "sonuc = 400000 * 0.25"}}`.
Tam şema: `content/schema/soru.schema.json`.
"""
(B / "SMMM_URETIM_TALIMATI.md").write_text(smmm, encoding="utf-8")

# ---------------- YMM
dy = OrderedDict()
for r in y:
    d = dy.setdefault(r["ders"], {"ders": r["ders"], "ad": r["ders_ad"], "tm": 0, "tn": 0, "tu": 0, "km": 0, "kn": 0, "ku": 0})
    d["tm"] += int(r["test_mevcut"]); d["tn"] += int(r["test_net"]); d["tu"] += int(r["test_uretilecek"])
    d["km"] += int(r["klasik_mevcut"]); d["kn"] += int(r["klasik_net"]); d["ku"] += int(r["klasik_uretilecek"])
oz = list(dy.values())
T = {k: sum(v[k] for v in oz) for k in ["tm", "tn", "tu", "km", "kn", "ku"]}
toplam_once = T["tm"] + T["km"]; toplam_sonra = toplam_once + T["tn"] + T["kn"]
ky = [dict(r) for r in y if int(r["klasik_uretilecek"]) > 0 or int(r["test_uretilecek"]) > 0]

ymm = f"""# Tasdik YMM — özgün soru üretim talimatı (hedef 3.000+, klasik ağırlıklı)

Hazırlanış: 2 Kasım 2026 · Dağılım betiği: `docs/uretim_talimati/dagilim.py` · Ham tablo: `dagilim_ymm.csv`

## 1. Hedef

- Bankada şu an **{T['tm']} test + {T['km']} klasik = {toplam_once} özgün soru** var.
- YMM sınavı yazılı (klasik) olduğundan ağırlık klasikte: **klasik {T['km']} → {T['km'] + T['kn']}** (her derste 90),
  **test {T['tm']} → {T['tm'] + T['tn']}**. Sonuç: **{toplam_sonra} özgün soru.**
- Net ihtiyaç: **{T['kn']} klasik + {T['tn']} test.** Kayıp payı dahil üretilecek: **{T['ku']} klasik + {T['tu']} test.**
- Dağılım müfredattaki konu ağırlıklarına göre; az sorusu olan konular öne alındı. Testte her konu en az 25 soruya,
  klasikte en az 4 vakaya tamamlanıyor.

## 2. Ders özeti

| Ders | Ad | Test mevcut | Test net | Test üret | Klasik mevcut | Klasik net | Klasik üret |
|---|---|---|---|---|---|---|---|
""" + "\n".join(f"| {v['ders']} | {v['ad']} | {v['tm']} | {v['tn']} | {v['tu']} | {v['km']} | {v['kn']} | {v['ku']} |" for v in oz) + f"""
| **Toplam** | | **{T['tm']}** | **{T['tn']}** | **{T['tu']}** | **{T['km']}** | **{T['kn']}** | **{T['ku']}** |

**Öncelik:** önce klasik (her dersten sırayla 10'ar vaka), sonra test.

{ORTAK_KURALLAR}
### 3a. Klasik (yazılı) vaka kuralları — ek

1. Gerçek YMM sınavı biçimi: **olay/veri bloğu + (a), (b), (c), (d) istekleri**, her isteğin puanı parantezde. Toplam
   `puan` 20–25, `sure_dk` 25–35.
2. `cozum`: örnek cevap — hesap tabloları, yevmiye kayıtları (Markdown tablo), her istek için gerekçe ve madde atfı.
3. `puanlama`: ölçüt listesi; puanların toplamı `puan`'a **eşit** olmalı (ör. "Vergi ziyaı cezasının doğru hesabı – 4").
4. Hesaplı derslerde (IFM, FYN, YNM, REV, VTK, GUV, HSV) `dogrulama.python` zorunlu: çözümdeki ana sonuçları bağımsız
   hesaplayan kod, `sonuc = {{"a": ..., "b": ...}}` sözlüğü atar. Kod çalıştırılır; çözümdeki sayılarla tutmazsa ret.
5. Vaka gerçekçi olmalı: tarihler 2025–2026, tutarlar tutarlı, yıla bağlı had/oran kökte verilir.
6. Bir vaka en az **iki kazanımı** birleştirir (ör. ceza hesabı + uzlaşma + dava yolu). Tek satırlık "tanım yazınız"
   istekleri en çok bir tane.
7. `id` biçimi teslimde `TASLAK`; alımda `YMM-<DERS>-<KONU>-K<NNN>` verilir.

## 4. Konu konu dağılım

{tablo(ky, ["ders", "konu", "konu_ad", "test_mevcut", "test_net", "test_uretilecek", "klasik_mevcut", "klasik_net", "klasik_uretilecek"], ["Ders", "Konu", "Konu adı", "Test mevcut", "Test net", "Test üret", "Klasik mevcut", "Klasik net", "Klasik üret"])}

Kazanımlar ve her dersin kaynak dosya önekleri: `content/mufredat/ymm.yaml` (`kazanimlar`, `kaynak_dosyalari`).
Test sorularında zorluk: %20 kolay · %45 orta · %35 zor. Klasikte zorluk 2–3.

{TESLIM.format(sinav="ymm")}
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
  - {{olcut: "(a) KV farkı ve vergi ziyaı cezası, tekerrür dahil", puan: 6}}
  - {{olcut: "(b) md. 376 şartları ve indirimli tutarlar", puan: 8}}
  - {{olcut: "(c) uzlaşma kapsamı ve süresi", puan: 6}}
  - {{olcut: "(d) dava yolu ve süreler", puan: 5}}
  kaynaklar:
  - {{mevzuat: 213 sayılı Vergi Usul Kanunu, madde: md. 376, alinti: '<resmî metinden birebir>'}}
  dogrulama: {{python: "kv = 400000*0.25\\nsonuc = {{'a': kv + min(kv*0.5, 20000)}}"}}
  gecerlilik: {{baslangic: '2026-01-01', bitis: null, yila_bagli_tutar: true, yil: 2026}}
  durum: taslak
  surum: 1
  uretim: {{kaynak_turu: yapay_zeka, model: <model adı>}}
```

Tam örnek: `content/klasik/ymm/VTK/CEZ.yaml` (ilk vaka). Şema: `content/schema/klasik.schema.json`.
Test sorusu biçimi Mizan talimatındaki örnekle aynıdır (`sinav: ymm`, `bolum: [YMM]`).
"""
(B / "YMM_URETIM_TALIMATI.md").write_text(ymm, encoding="utf-8")
print("yazıldı", top_m, top_n, top_u, T)
