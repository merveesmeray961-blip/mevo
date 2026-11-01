# Türev pilot (2026-11-02) — KABUL EDİLEN SORU YOK

40 kalıptan (SMMM 2026-1/2 resmî test soruları, resmî anahtarla) 40 aday üretildi; **0 kabul**.
Ayrıntı: `red.json` (her adayın ret gerekçesi), `maliyet.json`, `log.txt`, ham çıktılar `ham.json`.

- Yerel kapılarda elenen 33: G2 19 (çoğu `aciklama.celdiriciler` alanı hiç yazılmamış), KOPYA 14 (kalıbın kök
  cümlesi neredeyse aynen kullanılmış; 5-gram Jaccard ya da kök benzerliği eşiği), SIK 4, ALINTI 3, G4 3.
- Üretimde 3: düşünme 12k token sınırında bitmedi / JSON okunamadı.
- Doğrulamaya giden 4'ün 4'ü reddedildi (2'sinde hakem gerçek içerik hatası buldu: K012 BDS 580 öncülü aslında doğru;
  K021 atıf ifadesi; 2'sinde hakem çıktısı 8k token sınırında kesildi → güvenli tarafta ret).

## Elle inceleme (ana oturum için): doğrulamaya hiç ulaşmamış ya da ulaşmış 7 aday

| Aday | Kalıp | Gözlem |
|---|---|---|
| K006 | S26-2-VER-09 (6183 zamanaşımını kesen haller) | İçerik doğru (md. 103 listesi), ama `celdiriciler` yok → G2 ret. |
| K029 | S26-1-HUK-19 (zayi kıymetli evrak mercii) | İçerik doğru (TTK 661/2 asliye ticaret), `celdiriciler` yok. |
| K031 | S26-1-HUK-05 (İYUK ilk inceleme) | İçerik doğru; kök kalıpla neredeyse aynı → KOPYA ret (doğru karar). |
| K005 | S26-1-VER-17 (kaçakçılık fiilleri) | Büyük olasılıkla doğru (C kâğıt fatura = VUK 160/A), kalın olumsuz kök yok → G2. |
| K023 | S26-1-SPK-08 (yatırım ortaklığı portföy yönetimi) | Anahtar doğru ama 4 çeldirici aynı şeyi söylüyor (zayıf). |
| K035 | S26-2-FIN-17 (KV karşılığı kaydı) | Kayıt doğru; senaryo 2023 KV oranıyla tutarsız (125.000 kâra 18.750 KV) → hakem çıktısı kesildi, ret. |
| K036 | S26-2-FIN-03 (ihraç primi) | **HATALI**: "kooperatif niteliğindeki A.Ş." imkânsız niteleme; A ve D şıkları aynı kaydın satır sırası değişmiş hâli (iki doğru şık). Hakem çıktısı kesildi, ret. |

Sonuç: üretici (Thinking) hâlâ ~2/7 oranında ciddi hata yapıyor; hat bunları **kabul etmedi** (fail-closed),
ama biçim kurallarına uyumsuzluk yüzünden doğru soruların da çoğu yandı. Hat, onarım aşaması (1b) ve daha uzun
doğrulama sınırıyla güncellendi; yeni koşu yapılmadı (bütçe).
