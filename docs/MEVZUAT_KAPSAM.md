# Mevzuat kapsam denklemi (8 Ekim 2026)

Soru üretiminde ve uygulamanın Mevzuat bölümünde dayanılan resmî metinler. Kaynak: `content/kaynaklar/mevzuat/`
(her belgenin URL'si, indirme tarihi ve SHA-256'sı `KAYNAKLAR.md`'de). Güncellik: metinler 3–8 Ekim 2026'da
mevzuat.gov.tr / KGK / SPK / GİB / TÜRMOB'dan alındı; Resmî Gazete günlük olarak `rg-takip` iş akışıyla izleniyor.

## Sınav konularının dayandığı kanunlar (SMMM Yeterlilik + Staja Giriş)

| # | Kanun | Ders | Arşivde |
|---|---|---|---|
| 1 | 3568 SMMM ve YMM Kanunu | Meslek Hukuku | ✅ |
| 2 | 213 Vergi Usul Kanunu | Vergi, Finansal Muhasebe | ✅ |
| 3 | 193 Gelir Vergisi Kanunu | Vergi | ✅ |
| 4 | 5520 Kurumlar Vergisi Kanunu | Vergi | ✅ |
| 5 | 3065 Katma Değer Vergisi Kanunu | Vergi | ✅ |
| 6 | 4760 Özel Tüketim Vergisi Kanunu | Vergi | ✅ |
| 7 | 488 Damga Vergisi Kanunu | Vergi | ✅ |
| 8 | 492 Harçlar Kanunu | Vergi, Maliye | ✅ |
| 9 | 7338 Veraset ve İntikal Vergisi Kanunu | Vergi | ✅ |
| 10 | 197 Motorlu Taşıtlar Vergisi Kanunu | Vergi | ✅ |
| 11 | 1319 Emlak Vergisi Kanunu | Vergi | ✅ |
| 12 | 6183 Amme Alacaklarının Tahsil Usulü Hakkında Kanun | Vergi, Hukuk | ✅ |
| 13 | 6102 Türk Ticaret Kanunu | Hukuk, Finansal Muhasebe, Denetim | ✅ |
| 14 | 6098 Türk Borçlar Kanunu | Hukuk | ✅ |
| 15 | 4857 İş Kanunu | Hukuk | ✅ |
| 16 | 5510 Sosyal Sigortalar ve GSS Kanunu | Hukuk | ✅ |
| 17 | 6356 Sendikalar ve Toplu İş Sözleşmesi Kanunu | Hukuk | ✅ |
| 18 | 7036 İş Mahkemeleri Kanunu | Hukuk | ✅ |
| 19 | 2577 İdari Yargılama Usulü Kanunu | Hukuk | ✅ |
| 20 | 2576 BİM, İdare ve Vergi Mahkemeleri Kanunu | Hukuk | ✅ |
| 21 | 6362 Sermaye Piyasası Kanunu | Sermaye Piyasası | ✅ |
| 22 | 5018 Kamu Malî Yönetimi ve Kontrol Kanunu | Maliye | ✅ |
| 23 | 4447 İşsizlik Sigortası Kanunu | Hukuk (prim/işsizlik ödeneği) | ✅ 8 Ekim'de eklendi |
| 24 | 4721 Türk Medeni Kanunu | Hukuk (temel kavramlar, kişiler, eşya) | ✅ 8 Ekim'de eklendi |
| 25 | 2709 Anayasa (md. 73, 161–165) | Maliye, Vergi | ✅ 8 Ekim'de eklendi |
| 26 | 660 sayılı KHK (KGK) | Denetim | ✅ 8 Ekim'de eklendi |
| 27 | 5549 Suç Gelirlerinin Aklanmasının Önlenmesi Hk. Kanun | Meslek Hukuku (yükümlülükler) | ❌ indirilemedi, sonraki denemede |

**Denklem: 27 kanun gerekli → 26 arşivde, 1 eksik (5549).**

## İkincil mevzuat (yönetmelik, tebliğ, standart)

| Grup | Arşivde | Not |
|---|---|---|
| 3568'e dayalı TÜRMOB yönetmelikleri (çalışma usul, disiplin, etik, ücret, SMGE, odalar, YMM tasdik) | 11 | 2026 ücret tarifesi dahil |
| KGK: BDS (TDS 2026 seti), SBDS, GDS, İHS, KYS 1–2, Etik Kurallar, BD Yönetmeliği | 47 | |
| Muhasebe: MSUGT 1 ve ekleri (THP), MSUGT 2–15, Kavramsal Çerçeve, TMS/TFRS (33), BOBİ FRS | 46 | |
| Vergi tebliğleri: KDV GUT, KV GT 1 ve 23, GV 329/332, VUK 577/588, ÖTV listeleri, CBK 3490, asgari KV | 16 | 2026 hadleri dahil |
| SPK tebliğleri (II-5.1, 5.2, 15.1, 17.1, 18.1, 19.1, 23.2, 23.3; III-35/A.2, 35/B.1–2, 37.1, 48.1, 52.1; VII-128.1) | 18 | konsolide metinler |
| SGK / İş: Sosyal Sigorta İşlemleri Yönetmeliği ve ekleri | 2 | |

Toplam arşiv: 120+ belge, metin olarak taranabilir. Eksik bilinen ikincil düzenleme yok; KDV GUT ekleri (form örnekleri)
ve BOBİ FRS eğitim modülleri bilerek alınmadı.

## Güncellik güvencesi

- Her soruda `gecerlilik.baslangic` (hükmün yürürlük tarihi) ve yıla bağlı tutarlarda `yila_bagli_tutar: true, yil: 2026`.
- `rg-takip` GitHub iş akışı her sabah Resmî Gazete'yi tarar; yukarıdaki kanunlardan birini değiştiren düzenleme çıkarsa
  issue açar → ilgili sorular `content/sorular` içinde aranıp yeniden denetlenir.
