# Yeni oturum için devir notu

Bu dosya, yeni bir Claude oturumunun projeye en az maliyetle devam etmesi içindir. Yeni oturumda ilk mesaj:
**"docs/DEVAM.md dosyasını oku ve [aşama harfi] aşamasına devam et."**

## Proje

- Türkiye SMMM sınavları (önce **Yeterlilik**) için çevrimdışı Android hazırlık uygulaması. Sahibi: Merve.
- Bütçe: 79 $ ile sınırlı, bitince geliştirme durur → `docs/BUTCE_PLANI.md` (kararlar, aşamalar, takvim). **Pahalı işlemlerden kaçın:**
  toplu alt ajan çalıştırma yok, gereksiz dosya okuma yok, kısa cevaplar.
- Dal: `claude/merhaba-asistanim-afg6o4`. Commit mesajı sonu: `Co-Authored-By` ve `Claude-Session` satırları (sistem hatırlatmasına bakın).
- Resmî kitapçıklar ve TESMER/ÖSYM PDF'leri repoya **eklenmez** (gitignore'da).

## Dosya haritası

| Yol | İçerik |
|---|---|
| `content/sorular/smmm/<DERS>/<KONU>.yaml` | 100 soru (şema: `content/schema/soru.schema.json`) |
| `content/sinavlar/smmm.yaml`, `content/mufredat/smmm.yaml` | Sınav kuralları, müfredat |
| `content/kaynaklar/mevzuat/*.txt` | Resmî metinler; kanun maddesi için `python -m pipeline.kaynak <kod> <madde>` |
| `pipeline/` | Kapılar: `denetle.py` (G2/G4/G7), `kapilar.py`, `disa_aktar.py`, `kitapcik.py` (uzman PDF'i) |
| `pipeline/istemler/uretim.md`, `kontrol.md` | Soru üretim ve denetim kuralları (G5'e pilot dersleri eklendi) |
| `docs/DUZELTME_LISTESI.md` | **A aşamasının iş listesi** (12 soru + eski notlar) |
| `app/` | Flutter uygulaması; `flutter` = `/opt/flutter-sdk/flutter/bin/flutter` (yoksa kur: stable 3.47.x) |

## Kurallar

- Soru metni değişince: `surum` +1, `gecmis`'e not, G3/G5/G6/GZ kapıları sıfırlanır, `durum: taslak`; düzeltme sonrası
  kapılar yeniden çalıştırılır. Bütçe nedeniyle A aşamasında G3/G5/G6 tek denetçiyle (düzelten oturumun kendisi değil, bir alt
  ajan, ucuz model) yapılabilir.
- Uygulama paketi: `python -m pipeline.disa_aktar app/assets/sorular/smmm.json --uygulama`
- Testler: `python -m pytest -q` (32) ve `cd app && flutter test` (27).
- Web önizlemesi: https://claude.ai/artifact/5wqhHpzT192EAPJ7sXzsAd (yeniden yayın: README "Mobil uygulama").

## Durum (3 Ekim 2026)

- 100 soru `kontrolde`; 30'u uzman PDF'inde (`docs/SMMM_Uzman_Kitapcik.pdf`, numara eşleşmesi `.eslesme.txt`).
- Bağımsız hakem: 30 anahtarın 30'u doğru; 12 soruda düzeltme gerekli (DUZELTME_LISTESI.md).
- Uygulama: çalışma, deneme, aralıklı tekrar, istatistik, ödeme ekranı (önizleme, ödeme yok). Sonraki: B aşaması.
