# Soru bankası biçim kalitesi — yeniden ölçüm (29.10.2026)

Araç: `python docs/devir/araclar/kalite_olc.py [smmm|ymm]` (yalnız `kontrolde/onayli/yayinda` sorular).
Karşılaştırma: 18.10.2026 raporu (`smmm_test_2026_karsilastirma.md` §1.4), resmî 2026/1–2 TESMER testleri (320 soru).

## SMMM (3.223 soru)

| Ölçüt | 18.10 bankası | Bugün | Resmî sınav | Durum |
|---|---|---|---|---|
| Doğru şık tek başına en uzun | %62 | **%27,4** | ≈ %24 | düzeldi (şansa yakın) |
| Yanlış şıkta mutlak ifade | %31 | **%0,2** | %1,5 | düzeldi |
| Kökte BDS numarası | DEN %35 | **%0,3** | 0 | düzeldi |
| Doğru şık dağılımı (A–E) | ders bazında çarpık | **%19,5–20,5** | %18–25 | düzeldi |
| Sayısal şıklar artan sırada | sıra bozuk | **%81** | neredeyse hep | büyük ölçüde düzeldi, %19 hâlâ sırasız |
| Olumsuz kök (kalın) | %12–18 | **%13,7** | sözel derslerde %36–56 | **hâlâ düşük** |
| Kökte madde numarası | VER/HUK ≈ %30 | **%7,5** (tüm bankada) | çok nadir | iyileşti, tam değil |
| Kökte "TL" / "₺" | ağırlıkla TL | 214 / 525 | ₺ | büyük ölçüde ₺'ye geçti, 214 soru kaldı |

## YMM (1.887 soru; resmî YMM sınavı klasik olduğundan test oranları bire bir karşılaştırılamaz)

| Ölçüt | Bugün |
|---|---|
| Doğru şık tek başına en uzun | %14,3 |
| Yanlış şıkta mutlak ifade | %0,2 |
| Olumsuz kök (kalın) | %14,8 |
| Öncüllü soru | %18,9 |
| Kökte BDS numarası | %7,6 |
| Kökte madde numarası | %17,0 |
| Kökte "TL" | 577 (YMM'de TL korunur; ₺ dönüşümü yalnız SMMM'de) |
| Sayısal şıklar artan sırada | %82,6 |
| Doğru şık dağılımı | **A–E hepsi %20,0** (ölçümden sonra `sik_dengele --urun ymm` ile dengelendi; önceki: A %17,3 · B %23,7 · C %25,1 · D %18,2 · E %15,7) |

## Sonuç

Gerçek sınavla en çok ayıran iki ipucu (uzun doğru şık, mutlak ifadeli çeldirici) giderilmiş. Kalan farklar:

1. **Olumsuz kök oranı** (SMMM %13,7; resmî sözel derslerde %36–56). Sözel derslerde (HUK, MES, SPK, VER-mevzuat) "…hangisi **yanlıştır / değildir**?" biçimli soru artırılmalı.
2. ~~YMM doğru şık dağılımı dengesiz~~ — **giderildi** (249 soruda şık yeri değişti; yalnız şık sırası/çeldirici açıklaması taşındı, soru metni ve doğru şık metni aynı; paket yeniden üretildi).
3. **Sayısal şıkların %19'u sırasız** (SMMM) — G4 kapısı denetliyor ama eski sorular kalmış olabilir.
4. **Kökte madde numarası** YMM'de %17: sınav tarzında nadir.
5. **YMM kökünde BDS numarası** %7,6.

## Bu ölçümün söylemediği

Biçim ölçümüdür. Soruların **içerik doğruluğunu ve zorluğunu** ölçmez; bunlar için bağımsız denetim hattı ve uzman teyidi gerekir.
Kitapçık (uzmana gidecek örnek set): `python -m pipeline.kitapcik` SMMM için hazır; YMM için örnek seçimi henüz yok.
