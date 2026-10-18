---
ders: FYN
konu: ZDP
baslik: Paranın zaman değeri ve değerleme
durum: taslak
yazar: Claude
kaynaklar:
  - mevzuat: "Genel bilgi — Paranın zaman değeri: bugünkü ve gelecek değer"
    madde: "-"
  - mevzuat: "Genel bilgi — Anüite ve sürekli anüite"
    madde: "-"
  - mevzuat: "Genel bilgi — Tahvil değerlemesi"
    madde: "-"
  - mevzuat: "Genel bilgi — Hisse senedi değerlemesi ve Gordon modeli"
    madde: "-"
---
## Bu konuda neler öğreneceksin

- Bileşik faizle gelecek değer ve iskontolamayla bugünkü değer hesabı
- Normal anüite, peşin anüite ve sürekli anüitenin bugünkü ve gelecek değeri
- Kuponlu tahvilin fiyatı ile piyasa faizi arasındaki ters ilişki
- Sabit büyüme varsayımıyla hisse senedi değerlemesi (Gordon modeli)
- Bu araçların YMM değerleme ve tasdik çalışmalarındaki yeri

## 1. Bugünkü ve gelecek değer

**Paranın zaman değeri**, bugün elde edilen bir liranın ileride elde edilecek bir liradan daha değerli olduğunu anlatır; çünkü bugünkü para yatırılarak faiz kazanabilir. Finansal yönetimdeki bütün değerleme yöntemleri bu ilkeye dayanır.

**Gelecek değer (GD)**, bugünkü bir tutarın bileşik faizle n dönem sonra ulaşacağı tutardır. **Bugünkü değer (BD)** ise gelecekte elde edilecek bir tutarın, uygun bir iskonto oranıyla bugüne indirgenmiş karşılığıdır. Bu iki işlem birbirinin tersidir:

- GD = BD × (1 + r)^n
- BD = GD / (1 + r)^n

Burada r dönemsel faiz (iskonto) oranı, n dönem sayısıdır. (1 + r)^n ifadesine **bileşik faiz faktörü**, 1 / (1 + r)^n ifadesine **iskonto faktörü** denir. Bugünkü ve gelecek değer hesabının sınavdaki temel kuralı, oran ile dönemin aynı birimde olmasıdır: faiz yıllık, ödeme aylıksa önce dönemsel orana geçilir.

Kısa bir uygulama: 100.000 TL yıllık yüzde 10 bileşik faizle 3 yıl yatırılırsa GD = 100.000 × 1,1^3 = 133.100 TL olur. Tersinden, 3 yıl sonra alınacak 133.100 TL'nin yüzde 10 iskonto oranıyla bugünkü değeri 100.000 TL'dir.

Yıl içinde m kez faiz işletiliyorsa formül GD = BD × (1 + r / m)^(n × m) biçimini alır. Faiz işletme sıklığı arttıkça, aynı nominal oranla ulaşılan gelecek değer de artar.

> **Sık yapılan hata:** Yıllık nominal oranı aylık dönem sayısıyla doğrudan kullanmak. Aylık işleyen faizde oran r / 12, dönem sayısı n × 12 alınır.

## 2. Anüite

**Anüite**, belirli sayıda dönem boyunca eşit aralıklarla ödenen ya da tahsil edilen eşit tutarlı nakit akışları dizisidir. Kira, kredi taksiti ve tahvil kuponları tipik örneklerdir.

### Normal ve peşin anüite

Ödemeler her dönemin sonunda yapılıyorsa **normal (dönem sonu) anüite**, her dönemin başında yapılıyorsa **peşin (dönem başı) anüite** söz konusudur. Normal anüitede formüller şunlardır:

- BD = C × [1 − (1 + r)^(−n)] / r
- GD = C × [(1 + r)^n − 1] / r

C dönemsel eşit ödemedir. Peşin anüitede her ödeme bir dönem erken yapıldığından normal anüite sonucu (1 + r) ile çarpılır.

### Örnek: Normal ve peşin anüitenin değeri

Bir işletme 5 yıl boyunca her yıl 20.000 TL kira geliri elde edecektir. İskonto oranı yıllık yüzde 12'dir. Hesaplar yuvarlanmamış faktörlerle yapılmış, sonuçlar kuruşa yuvarlanmıştır.

1. Bugünkü değer faktörü: [1 − 1,12^(−5)] / 0,12 ≈ 3,6048.
2. Normal anüitenin bugünkü değeri: 20.000 × 3,604776 = 72.095,52 TL.
3. Gelecek değer faktörü: (1,12^5 − 1) / 0,12 ≈ 6,3528.
4. Normal anüitenin gelecek değeri: 20.000 × 6,352847 = 127.056,95 TL.
5. Kiralar her yılın başında tahsil edilseydi (peşin anüite): BD = 20.000 × 3,604776 × 1,12 = 80.746,99 TL; GD = 20.000 × 6,352847 × 1,12 = 142.303,78 TL.

### Sürekli anüite

Sonsuza kadar süren eşit ödemelere **sürekli anüite (perpetüite)** denir. Bugünkü değeri BD = C / r'dir. Aynı örnekte kira sonsuza kadar sürseydi BD = 20.000 / 0,12 = 166.666,67 TL olurdu. Sürekli anüitenin gelecek değeri tanımlı değildir; bu nedenle yalnız bugünkü değeri hesaplanır.

> **Sınav ipucu:** Soruda "her dönemin başında", "peşin" ya da "kira başta ödenir" ifadesi varsa normal anüite sonucunu (1 + r) ile çarpmayı unutma.

## 3. Tahvil değerlemesi

**Tahvil**, ihraççının belirli vadede anaparayı (nominal değer) geri ödemeyi ve dönemsel faiz (kupon) ödemeyi taahhüt ettiği borçlanma senedidir. Tahvil değerlemesi, bu nakit akışlarının yatırımcının istediği getiriyle (piyasa faizi) bugüne indirgenmesidir:

- Tahvil fiyatı = Kupon × [1 − (1 + k)^(−n)] / k + Nominal değer / (1 + k)^n

Formülün ilk kısmı kuponların anüite olarak bugünkü değeri, ikinci kısmı vadedeki anaparanın bugünkü değeridir. k piyasa getirisi, n vadeye kalan dönem sayısıdır. Kuponların yıl sonunda ödendiği kabul edilir.

### Örnek: Kuponlu tahvilin fiyatı

Nominal değeri 1.000 TL, yıllık kupon oranı yüzde 10, vadesine 3 yıl kalmış bir tahvil için piyasa getirisi yüzde 12'dir. Tutarlar kuruşa yuvarlanmıştır.

1. Yıllık kupon: 1.000 × 0,10 = 100 TL.
2. Kuponların bugünkü değeri: 100 × [1 − 1,12^(−3)] / 0,12 = 240,18 TL.
3. Anaparanın bugünkü değeri: 1.000 / 1,12^3 = 711,78 TL.
4. Tahvil fiyatı: 240,18 + 711,78 = 951,96 TL.

Piyasa getirisi kupon oranından yüksek olduğu için tahvil **iskontolu** (nominal değerin altında) işlem görür. Aynı tahvilin fiyatı piyasa getirisi yüzde 10 iken 1.000 TL (nominal değerden), yüzde 8 iken yaklaşık 1.051,54 TL (**primli**) olur.

Bu sonuç temel bir kuralı gösterir: tahvil fiyatı ile piyasa faizi ters yönde hareket eder. Kupon ödemeyen **sıfır kuponlu tahvilde** fiyat yalnız nominal değerin bugünkü değeridir. Kupon yılda iki kez ödeniyorsa kupon ikiye, k ikiye bölünür, n iki katına çıkarılır.

> **Sık yapılan hata:** Tahvili kupon oranıyla iskonto etmek. İskonto oranı her zaman piyasa getirisidir; kupon oranı yalnız nakit akışının tutarını belirler.

## 4. Hisse senedi değerlemesi (Gordon modeli)

Hisse senedinin içsel değeri, gelecekte beklenen kâr paylarının (temettülerin) yatırımcının istediği getiriyle bugüne indirgenmiş toplamıdır. Bu yaklaşıma **temettü indirgeme modeli** denir.

**Gordon modeli (sabit büyüme modeli)**, kâr payının her yıl sabit g oranında sonsuza kadar büyüyeceğini varsayar:

- P0 = D1 / (ke − g)
- D1 = D0 × (1 + g)

P0 bugünkü hisse değeri, D0 son ödenmiş kâr payı, D1 gelecek yıl beklenen kâr payı, ke özkaynak maliyeti (istenen getiri), g sabit büyüme oranıdır. Model, literatürdeki yaygın kabulle **D1** (bir sonraki dönemin kâr payı) ile kurulur; bu anlatımda da bu yöntem kullanılmıştır. Modelin geçerlilik şartı ke > g'dir; aksi halde payda sıfır ya da negatif olur ve sonuç anlamsızlaşır.

### Örnek: Gordon modeliyle hisse değeri

Bir şirket geçen yıl hisse başına 2,00 TL kâr payı dağıtmıştır (D0). Kâr payının her yıl yüzde 5 büyümesi, yatırımcıların ise yüzde 15 getiri istemesi beklenmektedir.

1. Gelecek yılın kâr payı: D1 = 2,00 × 1,05 = 2,10 TL.
2. Payda: ke − g = 0,15 − 0,05 = 0,10.
3. Hisse değeri: P0 = 2,10 / 0,10 = 21,00 TL.

Formül yeniden düzenlenirse ke = D1 / P0 + g elde edilir: piyasa fiyatı biliniyorsa özkaynak maliyeti bu yolla tahmin edilir (2,10 / 21 + 0,05 = yüzde 15). Kâr payı hiç büyümüyorsa (g = 0) model sürekli anüite formülüne dönüşür: P0 = D / ke.

İstisna olarak, ilk yıllarda yüksek, sonra sabit büyüme bekleniyorsa **çok aşamalı (değişken büyüme) model** kullanılır: yüksek büyüme dönemi kâr payları tek tek iskonto edilir, sabit büyüme başladığı noktada Gordon modeliyle bir uç değer bulunur ve bu da bugüne indirgenir.

> **Sınav ipucu:** Soruda "son dağıtılan" ya da "bu yıl ödenen" kâr payı verilmişse bu D0'dır; önce (1 + g) ile çarpıp D1'i bul. D0'ı doğrudan paya (formülün payına) yazmak örnekte 21,00 TL yerine 20,00 TL gibi yanlış bir sonuç verir.

### Tasdik uygulama notu

YMM'ler bu araçlarla en çok değerleme ve tespit raporlarında karşılaşır. İştirak payı ya da işletme değerinin raporlandığı çalışmalarda indirgenmiş nakit akışı ve temettü indirgeme yöntemlerinin varsayımları (iskonto oranı, büyüme oranı, uç değer) incelenir. Kontrolde şunlara bakılır: iskonto oranının nakit akışıyla aynı birimde (nominal ya da reel, vergi öncesi ya da sonrası) olması, g'nin ke'den küçük ve uzun vadeli ekonomik büyümeyle tutarlı olması, tahvil ve senet değerlemesinde piyasa getirisinin belgelendirilmesi. Varsayımlar ve hesap tabloları çalışma kâğıtlarında yeniden hesaplanarak doğrulanır.

## Özet

- GD = BD × (1 + r)^n; BD = GD / (1 + r)^n. Oran ve dönem aynı birimde olmalıdır.
- Normal anüitede BD = C × [1 − (1 + r)^(−n)] / r; peşin anüitede sonuç (1 + r) ile çarpılır.
- Sürekli anüitenin bugünkü değeri C / r'dir; gelecek değeri tanımlı değildir.
- Tahvil fiyatı, kuponların ve anaparanın piyasa getirisiyle iskonto edilmiş toplamıdır.
- Piyasa getirisi kupon oranından yüksekse tahvil iskontolu, düşükse primli işlem görür.
- Gordon modeli: P0 = D1 / (ke − g), şart ke > g; D0 verilmişse önce D1'e geçilir.
- Değerleme raporlarında iskonto ve büyüme varsayımları yeniden hesaplanarak kontrol edilir.
