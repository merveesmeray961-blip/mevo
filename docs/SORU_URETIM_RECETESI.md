# Soru üretim reçetesi (parti başına)

Bu reçete Parti 1'de (4 Ekim 2026) denendi: 20 yeni soru, 0 yanlış anahtar, hakemler 14 ifade hatası yakalayıp düzeltti.
Maliyet ≈ 8–10 $ / 20 soru. **Bütçe sınırı: toplam 30 $; bakiye 15 $'ın altına inerse yeni parti başlatma.**

## Hedef (Yeterlilik, her ders 20 soru)

| Ders | Şu an | Eksik |
|---|---|---|
| DEN Denetim | 12 | 8 |
| MAL Maliyet | 12 | 8 |
| VER Vergi | 12 | 8 |
| FIN Finansal Muhasebe | 14 | 6 |
| TAB Finansal Tablolar | 14 | 6 |
| HUK Hukuk | 14 | 6 |
| MES Meslek Hukuku | 14 | 6 |
| SPK Sermaye Piyasası | 14 | 6 |

Partiler: **P3** = DEN 8 + MAL 8 + VER 4 (20) · **P4** = VER 4 + FIN 6 + TAB 6 + HUK 4 (20) · **P5** = HUK 2 + MES 6 + SPK 6 (14).
Güncel sayıyı her parti öncesi doğrula:
`python3 -c "import json,collections;d=json.load(open('app/assets/sorular/smmm.json'));print(collections.Counter(s['ders'] for s in d['sorular'] if 'YET' in s['bolum']))"`

## Adımlar (her adım bir alt ajan; ana oturum yalnız yönetir — ana oturum soru dosyalarını okumaz)

1. **Üretim** — 1 ajan, `model: sonnet`. İstem: Parti 1'deki gibi: `docs/DEVAM.md`, `pipeline/istemler/uretim.md` (§7 dahil, "Püf noktaları:" biçimi),
   `pipeline/istemler/kontrol.md` (G5 kontrolleri), şema, müfredat ve aynı dersten 2–3 örnek soru okunur. Kurallar:
   yalnız yerel resmî metne dayan (`content/kaynaklar/mevzuat/*.txt`, `python -m pipeline.kaynak <kod> <madde>`), alıntılar birebir,
   kaynağı olmayan kazanımı atla, yıla bağlı tutarı yalnız yerel kaynakta varsa kullan, zorluk ≈ %20/45/35,
   yeni sorular **yalnız yeni dosyalara**: `content/sorular/smmm/<DERS>/<KONU>.pN.yaml` (N = parti no), `durum: taslak`,
   G2/G4/G7 çalıştırılır (`python -m pipeline.denetle content/sorular/smmm`), G3/G5/G6/GZ `{sonuc: bekliyor}`; **commit yok**.
2. **Kör dosya** — ana oturum: `python -m pipeline.kor dosya <scratchpad>/kor.md '.pN.'`
3. **Paralel denetim** (aynı anda başlat):
   - **Kör çözücü** — `model: sonnet`: yalnız `kor.md` + resmî kaynaklar; `content/sorular`, `app`, `web`, `docs`, git geçmişi YASAK.
     Çıktı `<scratchpad>/g3.json` `{id: {cevap, guven 1-5, not}}`.
   - **Ortalama aday** — `model: haiku`: yalnız `kor.md`, kaynaksız, tek geçiş. Çıktı `<scratchpad>/gz.json` `{id: {cevap, guven}}`.
   - **Hakemler** — varsayılan (güçlü) model, ders grubuna göre 2 ajan (≈10 soru/ajan): `pipeline/istemler/hakem.md` +
     `pipeline/istemler/kontrol.md` okunur; fark: `.pN.yaml` dosyalarını **düzeltebilir** (kaynağa göre, `gecmis` notu
     "hakem <tarih>", kök/şık değişirse `surum` +1), düzeltilemezse `durum: geri_cekildi`; G5 ve G6'yı yazar; commit yok.
4. **Kapat** — ana oturum: `python -m pipeline.kor isle <scratchpad>/g3.json <scratchpad>/gz.json`.
   "G3 KALDI" çıkan soru varsa ilgili hakeme (SendMessage) kör çözücünün gerekçesiyle sorulur; hakem kararını yazınca
   G3 elle `gecti` (gerekçeli not) ya da soru geri çekilir. "GZ DİKKAT" uyarısı hakeme iletilir.
5. **Doğrula ve yayınla**:
   `python -m pipeline.denetle content/sorular/smmm` (hepsi geçmeli) · `python -m pytest -q` ·
   `python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama` · `python -m pipeline.disa_aktar web/onizleme/sorular.json`
6. **Commit** yalnız `content/sorular`, `app/assets/sorular/smmm.json`, `web/onizleme/sorular.json`:
   `git pull --rebase origin claude/merhaba-asistanim-afg6o4` sonra push. (Başka bir oturum aynı dalda uygulama kodu üzerinde çalışıyor;
   onun dosyalarına — `app/lib`, `app/test`, `app/android`, `app/ios`, `docs/magaza` — dokunma.)
7. Merve'ye kısa rapor: kaç soru eklendi, kaç hata düzeltildi, ders başına yeni sayılar; **bakiyeyi sor** ve sonraki partiye geç.

## Commit mesajı sonu

Oturumun sistem hatırlatmasında verilen `Co-Authored-By` ve `Claude-Session` satırları (birebir).
