# YMM KONU ANLATIMI — KESİN KURALLAR

Bu paketle Yeminli Mali Müşavirlik (YMM) sınavına hazırlanan aday için **konu anlatımı** yazacaksın. Aday önce bu
metni okuyacak, sonra aynı konudan test ve klasik soru çözecek. Metin, sınavda soru çözdürecek bilgiyi **eksiksiz,
doğru ve müfredata birebir uygun** vermelidir. Kalite çıtası: `ORNEK_ANLATIM.md`.

Her anlatım önce **otomatik ön elemeden**, sonra **editör hakemden** geçer. "ZORUNLU/YASAK" kurallar otomatik ret
sebebidir; köşeli parantezdeki kod (ör. `[A05]`) ret raporunda o kuralı gösterir.

## 1. Müfredata bağlılık

- `[A05]` GOREV tablosunda konunun **her kazanımı** anlatımda ayrı bir bölümde ya da alt başlıkta işlenmeli. Kazanımın
  anahtar terimleri metinde geçmeli. Kazanım atlamak = ret.
- Tabloda olmayan konuya geçme; başka konunun ayrıntısını anlatma (yalnız bağlantı cümlesi kurabilirsin).
- `[A00]` Ön bilgide `ders` ve `konu` kodları GOREV tablosundakiyle **birebir** aynı olmalı; dosya adı = konu kodu
  (`KON.md`).

## 2. Teslim biçimi (ZORUNLU)

Her konu için ayrı `.md` dosyası; hepsi tek zip. Dosya şu ön bilgiyle başlar:

```
---
ders: IFM
konu: KON
baslik: Konsolidasyon ve işletme birleşmeleri
durum: taslak
yazar: <asistan adı>
kaynaklar:
  - mevzuat: TFRS 10 Konsolide Finansal Tablolar
    madde: par. 7
    alinti: "…kaynak metinden kelimesi kelimesine…"
---
## Bu konuda neler öğreneceksin
...
```

- `[A08]` `durum: taslak` yaz (başka değer yazma).
- Değerinde `:` geçen alanları tırnak içine al.

## 3. Metin biçimi (yalnız bunlar)

`## Başlık`, `### Alt başlık`, `- madde`, `1. madde`, `**kalın**`, `> **Sınav ipucu:** …`, `| tablo |`.
YASAK: tek `#` başlık, bağlantı, resim, HTML, emoji, dipnot, kod bloğu. (Uygulama bunları göstermez → ret.)

## 4. İçerik yapısı (ZORUNLU)

1. `[A02]` `## Bu konuda neler öğreneceksin`: 3–6 maddelik hedef listesi (kazanımları kapsar).
2. Ana bölümler (`## 1. …`, `## 2. …`): her kazanım için **tanım → kural → kayıt/hesap örneği → istisna** sırası.
3. Sayısal örnek: hesap gerektiren konularda en az bir **adım adım çözümlü** örnek; rakamlar tutarlı. Muhasebe kaydında
   hesap kodu ve adı birlikte (`654 Karşılık Giderleri`).
4. `[A04]` En az 2 not kutusu: `> **Sınav ipucu:** …` ya da `> **Sık yapılan hata:** …`.
5. YMM'ye özgü: konunun **tasdik/inceleme pratiğinde** nasıl karşılaşıldığını gösteren en az bir kısa uygulama notu
   (ör. "Tam tasdikte bu kalem şöyle kontrol edilir").
6. `[A03]` Sonda `## Özet`: 4–8 madde.
7. `[A01]` Uzunluk **900–1.800 kelime**. Dolgu ve tekrar yasak.

## 5. Doğruluk ve kaynak (en önemli kısım)

- Bilgi yalnız `kaynaklar/` klasöründeki resmî metinlere dayanır. Kanun maddesi, oran, süre, tutar yazarken kaynağa bak;
  emin olmadığın bilgiyi **yazma**. Mülga hükmü anlatma; 2026 itibarıyla güncel metni kullan.
- `[A07]` Ön bilgideki `kaynaklar` listesine dayandığın her önemli maddeyi yaz (metni olmayan FYN ve YNM derslerinde
  `mevzuat: "Genel bilgi — <konu>"`, `madde: "-"` yaz, `alinti` yazma).
- `alinti` kaynak metinden **kelimesi kelimesine** kopya olmalı (15–600 karakter). Otomatik aranır; bulunamazsa
  anlatım **reddedilir**. Emin değilsen `alinti` yazma.
- Yıla bağlı tutar ve oranları **2026** değeriyle ve yılını belirterek ver. Standartlarda paragraf numarası ver
  (`TFRS 10.7`, `BDS 705.7`). Tebliğ ile kanun arasında çelişki varsa ikisini de göster, kesin hüküm kurma.
- Ders kitabı, dershane notu, internet sayfası kopyalama YASAK; metin özgün olmalı (yalnız mevzuat alıntısı birebir).

## 6. Dil ve üslup

- Adaya "sen" diye hitap eden, sade, akademik Türkçe. Kısa paragraflar (en çok 4–5 cümle).
- Terimi ilk geçtiği yerde **kalın** yaz ve tanımla; kısaltmayı ilk geçtiği yerde aç (KVK, VUK, TFRS…).
- `[A06]` YASAK: "bu yazıda", "yazar olarak", "biz", reklam, motivasyon cümlesi, emoji.

## 7. Teslimden önce kontrol listesi (her konu)

- [ ] Her kazanım ayrı bölümde işlendi. [A05]
- [ ] "Bu konuda neler öğreneceksin", en az 2 not kutusu ve "Özet" var. [A02][A04][A03]
- [ ] 900–1.800 kelime. [A01]
- [ ] Her rakam, süre, oran, madde numarası kaynakla doğrulandı; alıntılar birebir. [A07]
- [ ] Hesap örneklerinin toplamları tutuyor.
- [ ] Yalnız desteklenen biçimler kullanıldı; `durum: taslak`. [A08]
