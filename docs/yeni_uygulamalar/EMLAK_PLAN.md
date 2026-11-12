# Emlak Danışmanı MYK uygulaması — plan (12 Kasım 2026)

## 1. Sınav (RESMÎ, MYK ulusal yeterlilikleri 17UY0332-4 ve 17UY0333-5, content/kaynaklar/myk/)
- Merkezî tek sınav yok; MYK yetkili belgelendirme kuruluşları yapar. Sınav **birim birim**:
  her birimde teorik (T1) en az 20 soru · **4 seçenek** · soru başı 1,5 dk (20 soru = 30 dk) · birim başına %70.
  A2 ve A3'te ayrıca performans (P1) sınavı (senaryo + kontrol listesi, %70).
- Birim başarısı 2 yıl geçerli; belge 5 yıl.

| Birim | Seviye 4 — Emlak Danışmanı | Seviye 5 — Sorumlu Emlak Danışmanı | Ders kodu |
|---|---|---|---|
| A1 | İSG, Çevre ve Kalite | İSG, Çevre ve Kalite | ISG |
| A2 | İş Planı Yapma ve Portföy Oluşturma | Pazarlama Stratejisi Geliştirme ve İş Organizasyonu | POR (S4) / STR (S5) |
| A3 | Emlak Satışı/Kiralanması ve Sonrası İşlemleri | Emlak Satışı/Kiralama Süreci İşlemlerinin Yürütülmesi | SAT (S5'te ek "değerleme-fizibilite-yatırım" konusu) |

Müfredat: `content/mufredat/emlak.yaml` (v2), banka hedefi 2050 (ISG 300, POR 450, STR 400, SAT 900).

## 2. Elimizdeki veri (emlak/EMLAK.zip, 75 teslim)
- 1611 soru — ama hepsi **5 seçenekli**; MYK sınavı 4 seçenekli → her soruda bir çeldirici çıkarılmalı
  (en zayıf çeldirici; açıklama ve harf sırası yeniden düzenlenir; doğru cevap korunur).
- 7 MEV teslimi boş (kaynak metni pakette yoktu, üreticiler doğru olarak soru yazmadı).
- 478 soruda alıntı yok: PAZ 250 + DEG 20 (pazarlama, mevzuata dayanmıyor — beklenen), **MEV 150**, ISG 40, diğer 18.
- **Kritik: Taşınmaz Ticareti Hakkında Yönetmelik 2025–2026'da defalarca değişti** (son: RG 01.10.2026/33387;
  ilan fiyat artışı kuralları 30.05.2025; güvenli ödeme sistemi ek md. 1; hizmet bedeli md. 20).
  MEV soruları kaynak metni olmadan yazıldı → 175 MEV sorusunun tamamı güncel metne karşı yeniden denetlenecek.

### Eski → yeni ders eşlemesi
| Eski (v1) | Soru | Yeni |
|---|---|---|
| ISG | 158 | ISG (A1) |
| PAZ-PAZ | 162 | POR-PLN/YET (S4) ve STR-PAZ (S5) — kazanıma göre |
| PAZ-DEG | 108 | POR-RAY |
| TAP-IMR / TAP-KMK | 94 / 118 | POR-TES (emlakın durumunun tespiti) |
| TAP-TAP | 115 | SAT-TAP |
| KIR-KIR / KIR-SAT | 175 / 117 | SAT-SOZ |
| VRG | 225 | SAT-VRG |
| MEV-SOZ | 88 | POR-YET (yetkilendirme, ilan) ve SAT-VRG (hizmet bedeli) |
| MEV-YTK | 87 | STR-YTK |
| ETK | 164 | SAT-MUS (KVKK, etik) ve STR-YTK (aklama) |

Not: Eski dağılım mevzuata çok yüklü (VRG 225 soru); MYK birimleri süreç ve uygulama ağırlıklı. Eksikler:
A1 acil durum/çevre/kalite, A2 iş planı ve portföy, S5-A2 ekip ve bütçe, A3 yer gösterme ve satış sonrası, S5 yatırım danışmanlığı.

## 3. Uygulamanın özellikleri (Emlak'a özgü)
- Açılışta seviye seçimi: Seviye 4 / Seviye 5 (tek uygulama, iki yol).
- Deneme = **birim denemesi**: 20 soru / 30 dk / %70; birim birim "geçti/kaldı" kartı; üç birim tamamlanınca genel durum.
- Performans sınavına hazırlık: senaryo kartları (yer gösterme, yetkilendirme sözleşmesi, pazarlık) — kontrol listesi biçiminde.
- Belgeler sekmesi: yetkilendirme sözleşmesi, yer gösterme belgesi, hizmet bedeli hesaplayıcı (md. 20 sınırı).
- Mevzuat sekmesi: Taşınmaz Ticareti Yönetmeliği (güncel), TBK kira ve satış, Kat Mülkiyeti, İmar, Tapu, Harçlar, KVKK.

## 4. Sıra
1. Taşınmaz Ticareti Yönetmeliği güncel metnini arşive al (mevzuat.gov.tr; 01.10.2026 değişikliği işlenmiş).
2. 1611 sorunun yeni koda taşınması + 4 seçeneğe indirilmesi + hakem denetimi (MEV tamamı güncel metne karşı).
3. Eksik konuların üretim paketleri.
4. Uygulama: mevcut motor üzerinde `emlak` flavor + seviye seçimi + birim denemesi.
