---
ders: FYN
konu: ZDP
baslik: Paranın zaman değeri ve değerleme
durum: "kontrolde"
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Paranın zaman değeri: bugünkü ve gelecek değer, reel faiz"
    madde: "-"
  - mevzuat: "Genel bilgi — Anüite: ertelenmiş, büyüyen ve sürekli anüite"
    madde: "-"
  - mevzuat: "Genel bilgi — Tahvil değerlemesi ve durasyon"
    madde: "-"
  - mevzuat: "Genel bilgi — İskonto ve senet hesapları"
    madde: "-"
  - mevzuat: "Genel bilgi — Hisse senedi değerlemesi, Gordon modeli ve göreli değerleme"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Bugünkü ve gelecek değer, efektif faiz ve Fisher eşitliğiyle reel faiz
- Normal, peşin, ertelenmiş, büyüyen ve sürekli anüite; eşit taksitli kredi
- Tahvil fiyatı, Macaulay ve düzeltilmiş durasyon, konveksite
- Senet iskontosu (dış ve iç iskonto), senet değişimi ve hazine bonosu fiyatı
- Gordon modeli, değişken büyüme ve F/K, PD/DD ile göreli değerleme

## 1. Bugünkü ve gelecek değer

**Paranın zaman değeri**, bugünkü bir liranın faiz kazanabileceği için gelecekteki bir liradan değerli olmasıdır.

- **Gelecek değer:** GD = BD × (1 + r)^n
- **Bugünkü değer:** BD = GD / (1 + r)^n
- Yılda m kez faiz işletilirse GD = BD × (1 + r/m)^(n×m)
- **Efektif yıllık faiz** = (1 + r/m)^m − 1; farklı vadeli getiriyi yıllıklandırmak için (1 + dönem getirisi)^(365/gün) − 1

Örnek: 100.000 TL %10 ile 3 yıl: GD = 133.100 TL. Yıllık %48 nominal, aylık bileşik faizin efektif oranı (1,04)^12 − 1 = %60,10'dur.

**Fisher eşitliği:** (1 + nominal faiz) = (1 + reel faiz) × (1 + enflasyon). Nominal %50, enflasyon %40 ise reel faiz 1,50 / 1,40 − 1 = %7,14'tür. Ters çözüm: reel %5, nominal %47 ise enflasyon 1,47 / 1,05 − 1 = %40'tır. Yaklaşık formül (nominal ≈ reel + enflasyon) yüksek enflasyonda büyük hata verir.

> **Sık yapılan hata:** Yıllık nominal oranı aylık dönem sayısıyla doğrudan kullanmak. Aylık işleyen faizde oran r/12, dönem sayısı n × 12 alınır.

## 2. Anüite

**Anüite**, eşit aralıklarla ödenen eşit tutarlı nakit akışlarıdır.

- Normal (dönem sonu) anüite: BD = C × [1 − (1 + r)^(−n)] / r; GD = C × [(1 + r)^n − 1] / r
- Peşin (dönem başı) anüite: normal anüite sonucu × (1 + r)
- Eşit taksitli kredi: C = Kredi × r / [1 − (1 + r)^(−n)]
- **Sürekli anüite:** BD = C / r
- **Büyüyen anüite** (ilk ödeme C, büyüme g): BD = C / (r − g) × [1 − ((1 + g)/(1 + r))^n]; sonsuz büyüyen anüitede BD = C / (r − g)
- **Ertelenmiş anüite:** Ödemeler k dönem sonra başlıyorsa anüite değeri bulunur, sonra (1 + r)^k ile bugüne indirgenir.

### Örnek 1: Normal ve peşin anüite

5 yıl boyunca yıllık 20.000 TL kira, iskonto oranı %12.

1. BD faktörü [1 − 1,12^(−5)] / 0,12 = 3,604776; BD = 72.095,52 TL.
2. GD faktörü (1,12^5 − 1) / 0,12 = 6,352847; GD = 127.056,95 TL.
3. Kiralar yıl başında alınsaydı: BD = 80.746,99 TL; GD = 142.303,78 TL.
4. Sonsuza kadar sürseydi BD = 20.000 / 0,12 = 166.666,67 TL.

### Örnek 2: Ertelenmiş taksit

500.000 TL kredi, aylık %3, ilk 3 ay ödemesiz, sonra 12 eşit taksit.

1. Borcun 3. ay sonundaki değeri: 500.000 × 1,03³ = 546.363,50 TL.
2. Anüite faktörü: [1 − 1,03^(−12)] / 0,03 = 9,954004.
3. Taksit = 546.363,50 / 9,954004 = 54.888,82 TL (ilk taksit 4. ay sonunda).

### Örnek 3: Büyüyen anüite

İlk yıl sonunda 100.000 TL alınacak, ödeme her yıl %5 artacak, 10 yıl sürecek; r = %10. BD = 100.000 / 0,05 × [1 − (1,05/1,10)^10] = 743.981,21 TL.

> **Sınav ipucu:** "Her dönemin başında" veya "peşin" ifadesi peşin anüitedir; "ödemesiz dönem" ifadesi ertelenmiş anüitedir.

## 3. Tahvil değerlemesi ve durasyon

Tahvil fiyatı, kuponların ve nominal değerin **piyasa getirisiyle** (k) iskonto edilmiş toplamıdır: P = Kupon × [1 − (1 + k)^(−n)] / k + Nominal / (1 + k)^n.

### Örnek 4: Fiyat ve durasyon

Nominal 1.000 TL, kupon %10 (yıllık), vade 3 yıl, k = %12.

1. Nakit akışlarının BD'si: 89,29 + 79,72 + 782,96 ≈ 951,96 TL (iskontolu; ara değerler yuvarlanmadan toplanmıştır). k = %10'da fiyat 1.000 TL, %8'de 1.051,54 TL (primli) olur.
2. **Macaulay durasyonu** = Σ(t × BD_t) / P = (1 × 89,29 + 2 × 79,72 + 3 × 782,96) / 951,96 ≈ 2.597,60 / 951,96 = 2,7287 yıl.
3. **Düzeltilmiş durasyon** = 2,7287 / 1,12 = 2,4363.
4. k bir puan artarsa tahmini fiyat değişimi ≈ −2,4363 × %1 × 951,96 = −23,19 TL. Gerçek fiyat (k = %13) 929,17 TL'dir; değişim −22,80 TL.

Tahmin ile gerçek arasındaki fark **konveksite** etkisidir: fiyat-getiri eğrisi dışbükey olduğundan faiz artışında fiyat tahminden az düşer, faiz düşüşünde tahminden çok artar. Durasyon vade arttıkça artar; kupon oranı ve piyasa getirisi arttıkça azalır. Sıfır kuponlu tahvilin durasyonu vadesine eşittir.

> **Sık yapılan hata:** Tahvili kupon oranıyla iskonto etmek. İskonto oranı piyasa getirisidir; kupon yalnız nakit akışını belirler.

## 4. İskonto ve senet hesapları

Senet hesaplarında ticari teamülle yıl 360 gün alınır (soruda farklı gün verilmedikçe). N nominal, t yıllık faiz (%), n gündür.

- **Dış (ticari) iskonto:** İ = N × t × n / 36.000
- **İç (gerçek) iskonto:** İ = N × t × n / (36.000 + t × n); peşin değer = N / (1 + t × n / 36.000)

**Örnek 5:** 100.000 TL, 90 gün, %40. Dış iskonto 10.000 TL (peşin değer 90.000 TL); iç iskonto 9.090,91 TL (peşin değer 90.909,09 TL). Dış iskonto her zaman daha büyüktür.

**Örnek 6 (senet değişimi):** 60 gün vadeli 50.000 TL ile 120 gün vadeli 80.000 TL'lik senet, iç iskontoyla %36 faizden 90 gün vadeli tek senede çevrilecektir.

1. BD'ler: 50.000 / 1,06 = 47.169,81 TL; 80.000 / 1,12 = 71.428,57 TL; toplam 118.598,38 TL.
2. Yeni senedin nominali: 118.598,38 × (1 + 0,36 × 90 / 360) = 129.272,24 TL.

**Hazine bonosu** (kuponsuz, basit faizle): P = N / (1 + r × n / 365). 182 gün vadeli 100 TL nominal bono %36 getiride 84,78 TL'dir.

## 5. Hisse senedi değerlemesi

**Gordon modeli:** P0 = D1 / (ke − g); D1 = D0 × (1 + g); şart ke > g.

**Örnek 7:** D0 = 2,00 TL, g = %5, ke = %15. D1 = 2,10 TL; P0 = 2,10 / 0,10 = 21,00 TL. Ters çözüm: ke = D1 / P0 + g. g = 0 ise P0 = D / ke.

**Değişken büyüme:** Yüksek büyüme dönemindeki kâr payları tek tek iskonto edilir; sabit büyümenin başladığı yılda Gordon ile uç değer bulunup bugüne indirgenir.

**Tek dönem getirisi:** k = (D1 + P1 − P0) / P0. Ters çözüm: istenen getiri %20, P0 = 50 TL, D1 = 4 TL ise satış fiyatı P1 = 50 × 1,20 − 4 = 56 TL olmalıdır.

**Göreli değerleme:** Hisse, benzer şirketlerin çarpanlarıyla değerlenir: P = sektör F/K × HBK; P = sektör PD/DD × hisse başı özkaynak; firma değeri = sektör FD/FAVÖK × FAVÖK (borç düşülerek özkaynak değerine geçilir). Örnek: HBK 4 TL ve sektör F/K 8 ise 32 TL; hisse başı özkaynak 20 TL ve PD/DD 1,5 ise 30 TL; iki yöntemin ortalaması 31 TL.

> **Sınav ipucu:** "Son dağıtılan" kâr payı D0'dır; önce (1 + g) ile çarp. D0'ı paya yazmak 21 TL yerine 20 TL sonucunu verir.

### Tasdik uygulama notu

YMM'ler bu araçlarla değerleme ve tespit raporlarında, senet ve alacak reeskontunda karşılaşır. İskonto oranının nakit akışıyla aynı birimde (nominal veya reel) olduğu, g'nin ke'den küçük ve uzun vadeli büyümeyle tutarlı olduğu, reeskont hesabında iç iskonto formülünün ve doğru gün sayısının kullanıldığı çalışma kâğıtlarında yeniden hesaplanarak doğrulanır.

## Özet

- GD = BD × (1 + r)^n; efektif faiz (1 + r/m)^m − 1; Fisher: (1 + i) = (1 + reel)(1 + enflasyon).
- Peşin anüite × (1 + r); ertelenmiş anüitede ödemesiz dönem ayrıca iskonto edilir; büyüyen anüitede payda r − g'dir.
- Tahvil fiyatı piyasa getirisiyle bulunur; faiz ile fiyat ters yönlüdür.
- Düzeltilmiş durasyon = Macaulay / (1 + k); fiyat değişimi ≈ −düzeltilmiş durasyon × Δk × P; farkı konveksite açıklar.
- Dış iskonto N×t×n/36.000, iç iskonto N×t×n/(36.000 + t×n); senet değişiminde eski senetlerin BD'si yeni vadeye taşınır.
- Gordon: P0 = D1/(ke − g); göreli değerlemede F/K, PD/DD ve FD/FAVÖK çarpanları kullanılır.
