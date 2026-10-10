# Konu anlatımı yazım kuralları (Mevo)

Bu paketle SMMM sınavına hazırlanan öğrenci için **konu anlatımı** yazacaksın. Öğrenci önce bu metni okuyacak,
ardından aynı konudan soru çözecek. Metin, sınavda soru çözdürecek bilgiyi eksiksiz ve doğru vermelidir.
Örnek ve kalite çıtası: `ORNEK_ANLATIM.md`. O düzeyin altında metin kabul edilmez.

## 1. Teslim biçimi

- **Her konu için ayrı bir `.md` dosyası** yaz. Dosya adı konu kodudur: `ALC.md`, `BOR.md` …
- Dosya, aşağıdaki **ön bilgi** ile başlar (üç tire arasında YAML), ardından metin gelir:

```
---
ders: FIN
konu: ALC
baslik: Alacaklar ve senetler
durum: taslak
yazar: <asistan adı>
kaynaklar:
  - mevzuat: 213 sayılı Vergi Usul Kanunu
    madde: md. 323
    alinti: "Dava veya icra safhasında bulunan alacaklar"
---
## Bu konuda neler öğreneceksin
...
```

- Bütün dosyaları **tek bir zip** hâlinde teslim et.

## 2. Metin biçimi (yalnız bunlar desteklenir)

| Yazım | Görünüm |
|---|---|
| `## Başlık` ve `### Alt başlık` | Bölüm başlıkları (tek `#` kullanma) |
| `- madde` ve `1. madde` | Liste |
| `**kalın**` | Vurgu (yalnız terimlerde ve kritik sayılarda) |
| `> **Sınav ipucu:** …` | Renkli not kutusu (ipucu, sık yapılan hata, hatırlatma) |
| `\| a \| b \|` satırları | Tablo |

Bağlantı, resim, HTML, emoji, dipnot **kullanma**. Uygulama bunları göstermez.

## 3. İçerik yapısı (her konu)

1. **Bu konuda neler öğreneceksin:** 3–6 maddelik hedef listesi (GOREV'deki kazanımları kapsasın).
2. **Ana bölümler** (`## 1. …`, `## 2. …`): Her kazanım en az bir bölümde işlenir. Tanım → kural → kayıt/hesap
   örneği → istisna sırasını izle.
3. **Sayısal örnek:** Hesap gerektiren konularda en az bir adım adım çözümlü örnek ver (rakamlar tutarlı olsun).
   Muhasebe kayıtlarında hesap kodu ve adını birlikte yaz (ör. `654 Karşılık Giderleri`).
4. **Not kutuları:** Konu başına en az 2 tane `> **Sınav ipucu:**` ya da `> **Sık yapılan hata:**` kutusu.
5. **Özet:** Sonda 4–8 maddelik "Özet". Sınavdan önce son tekrar için okunacak.

Uzunluk: **900–1.800 kelime** (en az 600; altı otomatik reddedilir). Gereksiz tekrar ve dolgu yazma.

## 4. Doğruluk ve kaynak (en önemli kısım)

- Bilgi **pakette verilen kaynak metinlere** dayanmalı. Kanun maddesi, oran, süre ve tutar yazarken kaynağa bak.
  Emin olmadığın bilgiyi **yazma**.
- Ön bilgideki `kaynaklar` listesine metinde dayandığın her önemli maddeyi ekle. `alinti`, **kaynak metinden
  kelimesi kelimesine** kopyalanmış bir parça olmalı (15 karakterden uzun). Özetleyip alıntı diye yazma:
  alıntılar otomatik olarak resmî metinde aranır, bulunamazsa anlatım **reddedilir**.
- Yıla bağlı tutar ve oranları (ör. şüpheli alacak sınırı, vergi dilimleri) **2026 yılı** değeriyle ve yılını
  belirterek yaz.
- Standart (TMS/TFRS/BDS) anlatırken paragraf numarası ver (ör. "TMS 16.7").
- Ders kitaplarından, dershane notlarından, sitelerden **kopyalama yapma**. Metin özgün olmalı; yalnız
  mevzuat alıntısı birebir olabilir.

## 5. Dil ve üslup

- Öğrenciye "sen" diye hitap eden, sade, akademik ama samimi Türkçe. Kısa paragraflar (en fazla 4–5 cümle).
- Terimi ilk geçtiği yerde **kalın** yaz ve tanımla. Kısaltmayı ilk geçtiği yerde aç (VUK, TTK, KDVK …).
- "Biz", "yazar", "bu yazıda" gibi ifadeler; reklam; motivasyon cümleleri yazma.

## 6. Kontrol listesi (teslimden önce)

- [ ] Her kazanım işlendi mi?
- [ ] Her rakam, süre, oran ve madde numarası kaynakla doğrulandı mı?
- [ ] Her alıntı kaynak metinde birebir var mı?
- [ ] Hesap örneklerinin toplamları tutuyor mu?
- [ ] En az 2 not kutusu ve sonda özet var mı?
- [ ] Yalnız desteklenen biçimler kullanıldı mı?
