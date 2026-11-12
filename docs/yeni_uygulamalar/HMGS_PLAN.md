# HMGS uygulaması — plan (12 Kasım 2026)

## 1. Sınav (RESMÎ, ÖSYM 2026-HMGS/2 kılavuzu)
- 120 soru · 5 seçenek (A–E) · 155 dakika · baraj 70/100 · yanlış doğruyu götürmez · yılda 2 oturum.
- 20 ders, soru sayıları (yüzde × 120):

| Ders | Kod | Soru | Banka hedefi |
|---|---|---|---|
| Anayasa Hukuku | ANA | 6 | 250 |
| Anayasa Yargısı | AYG | 3 | 125 |
| İdare Hukuku | IDR | 6 | 250 |
| İdari Yargılama Usulü | IYU | 3 | 125 |
| Genel Kamu Hukuku | GKH | 3 | 125 |
| Medeni Hukuk | MED | 15 | 625 |
| Borçlar Hukuku | BRC | 12 | 500 |
| Ticaret Hukuku | TIC | 12 | 500 |
| Hukuk Yargılama Usulü | HMK | 12 | 500 |
| İcra ve İflas Hukuku | IIK | 6 | 250 |
| Ceza Hukuku | CEZ | 9 | 375 |
| Ceza Yargılama Usulü | CMK | 6 | 250 |
| İş ve Sosyal Güvenlik Hukuku | ISH | 6 | 250 |
| Vergi Hukuku | VER | 3 | 125 |
| Vergi Usul Hukuku | VUH | 3 | 125 |
| Avukatlık Hukuku | AVK | 3 | 125 |
| Hukuk Felsefesi ve Sosyolojisi | FEL | 3 | 125 |
| Türk Hukuk Tarihi | TAR | 3 | 125 |
| Milletlerarası Hukuk | MIH | 3 | 125 |
| Milletlerarası Özel Hukuk | MOH | 3 | 125 |
| **Toplam** | | **120** | **5000** |

Müfredat: `content/mufredat/hmgs.yaml` (v2). Dersler ve soru sayıları resmî; konu/kazanımlar taslak →
ÖSYM'nin yayımladığı 2024–2026 temel soru kitapçıklarının ders ders analiziyle kesinleşecek (YMM yöntemi).

## 2. Elimizdeki veri (hmgs/HMGS.zip, 24 teslim)
- 585 soru, hepsi 5 seçenekli, hepsinde kaynak + alıntı var.
- Yalnız 2 ders: İcra-İflas ~360 (hedef 250 → yeterli), İş-Sosyal Güvenlik ~225 (hedef 250 → 25 eksik).
- Bu, sınavın yalnız %10'u. **Eksik: 18 ders, ~4.400 soru.**
- Temizlik gereken: ders/konu kodları karışık (TKP/IFL ders alanında, Türkçe adlar kod yerinde: 121 soru),
  `bolum` 74 soruda liste değil; 25 tekrar kök; doğru şık dağılımı dengeli (A 144, B 123, C 88, D 99, E 131).

## 3. Kaynak durumu (content/kaynaklar/mevzuat)
- Var: anayasa, aym_6216 (yeni), dmk, kamulastirma, iyuk, idare_mahkemeleri, tmk, tbk, ttk, hmk, iik, tck, cmk,
  isk, sgk, sendikalar, is_mahkemeleri, vuk, gvk, kvk, kdvk, aatuhk, avukatlik, mohuk_5718 (yeni), vatandaslik_5901 (yeni).
- Kanun metni olmayan dersler: Genel Kamu Hukuku, Hukuk Felsefesi ve Sosyolojisi, Türk Hukuk Tarihi, Milletlerarası Hukuk.
  Bu 4 ders (12 soru, %10) öğreti dersi; alıntı-doğrulama hattımız kanun maddesine dayanıyor. Öneri: bu derslerde
  kaynak = ÖSYM çıkmış soruları + açık erişimli ders notları; hakem denetimi iki model + daha sıkı.

## 4. Uygulamanın özellikleri (HMGS'ye özgü)
- Deneme: 120 soru / 155 dk, ders dağılımı tablodaki gibi; sonuç 100 üzerinden puan + "baraj 70" göstergesi.
- Ders bazlı hız uyarısı (soru başı ~77 sn).
- Çıkmış sorular: ÖSYM temel soru kitapçıkları (2024/1'den beri) + resmî cevap anahtarı, iptaller işaretli.
- Mevzuat sekmesi: 20 dersin kanunları, maddeye atlama.
- Klasik soru YOK (HMGS tamamen test).

## 5. Sıra
1. ÖSYM çıkmış kitapçıklarını topla → ders/konu analizi → müfredat konu ağırlıklarını kesinleştir.
2. 585 sorunun kod temizliği + içe alma + hakem denetimi.
3. 18 dersin üretim paketleri (büyük dersler önce: MED, BRC, TIC, HMK, CEZ).
4. Uygulama: mevcut motor üzerinde `hmgs` flavor (ayrı uygulama kimliği, ad, renk).
