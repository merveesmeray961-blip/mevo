# Soru Yazarı Manifestosu — SMMM Sınav Soru Bankası

Bu klasör sana bir **soru yazma görevi** için verildi. Lütfen önce bu belgenin tamamını, sonra `GOREV.md`'yi oku.
Ürettiğin her soru, bizim tarafta **kör çözücü, ortalama aday testi ve hakem denetiminden** geçecek; kurallara uymayan
soru doğrudan reddedilir. Az ama kusursuz soru, çok ama şüpheli sorudan değerlidir.

## 1. Klasörde neler var

| Dosya | Ne işe yarar |
|---|---|
| `MANIFESTO.md` | Bu belge: kurallar ve teslim biçimi |
| `GOREV.md` | Yazacağın soruların listesi (her satır = bir soru: ders, konu, kazanım, zorluk, bölüm) |
| `URETIM_KURALLARI.md` | Ayrıntılı yazım kuralları (biçim, hesaplama, ders bazında stil, zorluk teknikleri) |
| `KONTROL_LISTESI.md` | Hakemlerimizin uygulayacağı kontroller — teslimden önce kendin uygula |
| `SEMA.json` | Sorunun veri yapısı (JSON Schema) |
| `ORNEKLER.yaml` | Bankamızdan, tüm denetimlerden geçmiş örnek sorular — biçim ve kalite çıtası |
| `kaynaklar/` | Dayanacağın resmî metinler (kanun, yönetmelik, tebliğ, standart). **Tek bilgi kaynağın bunlar.** |

## 2. Değişmez kurallar

1. **Yalnız `kaynaklar/` klasöründeki metinlere dayan.** Bellekten, internetten, ders kitabından bilgi yazma. Bir kazanım için
   metin yoksa o satırı **yazma**, `atlanan` listesine yaz (bkz. §5).
2. **Alıntılar birebir olmalı.** `kaynaklar[].alinti` alanına metinden kopyala-yapıştır yap (en çok 600 karakter). Tek harf değiştirme,
   kısaltma gerekiyorsa yalnız `…` kullan.
3. **Madde/fıkra/bent numaraları doğru olmalı.** "md. 26/1-(ç)" gibi; emin değilsen metinde başlığına bakarak doğrula.
4. **Güncel hüküm.** Metinde "(Mülga …)", "(Değişik …)" notlarına dikkat et; mülga hükümden soru yazma. Yıllık değişen tutar
   (had, ceza tutarı, istisna tutarı) kullanacaksan kökte açıkça ver ve `gecerlilik.yila_bagli_tutar: true`, `yil: 2026` yaz.
5. **Özgünlük.** Çıkmış sınav sorularını kopyalama, taklit etme. Senaryo, sayılar, işletme/kişi adları ve şıklar senin olsun.
6. **Tek doğru şık.** Tam 5 şık (A–E); yalnız biri doğru. İkinci savunulabilir şık = soru reddedilir.
7. **Hesap makinesi yok.** Sayılar elle hesaplanabilir olsun; sayısal şıklar sıralı olsun.
8. **Türkçe**, resmî sınav dili; olumsuz kök **kalın** ("hangisi **yanlıştır**?").

## 3. Hakemlerin en sık yakaladığı hatalar — bunları yapma

- **Kuralı yanlış özetlemek:** Bir hükmün *kime* ve *hangi şartla* uygulandığını değiştirmek ("kuruluş üstlenemez" ↔ "denetçi görev alamaz"),
  şartı atlamak ya da istisnası olan kuralı mutlak söylemek ("bir yıldan fazla olamaz" — oysa başka fıkrada 3 yıl var).
- **Kökte örtük varsayım:** Çözüm için gereken bilgiyi kökte vermemek (faiz ay mı gün mü esasıyla? borcun ne kadarı ticari? kaç kez tekrarlandı?).
  Olayların sırası gerçekçi olmalı (zamanaşımı dolduktan sonra gelen karar gibi tutarsızlıklar olmasın).
- **Eski tutar/eski metin:** Tebliğin ilk metnindeki tutarı 2026 tutarı sanmak; kanunun eski adını kullanmak.
- **Yanlış yürürlük tarihi:** `gecerlilik.baslangic` = ilgili hükmün **yürürlük** tarihi (kabul tarihi değil; indirme tarihi hiç değil).
- **Yevmiye kaydını kısaltmak:** Tekdüzen Hesap Planı'ndaki hesap işleyişine birebir uy (ör. 408'den çıkış yalnız 308'e aktarmayla).
- **Açıklamada yazara yönelik dil:** "Teknik (3)", "çeldiriciler tipik hatadan türetildi" gibi ifadeler yok. Zor sorularda çözümden sonra
  **"Püf noktaları:"** başlığıyla adaya hitap eden sade bir not yaz.

## 4. Teslimden önce kendi kontrolün (her soru için)

- [ ] Cevabı anahtara bakmadan baştan çözdüm; tek doğru şık var.
- [ ] Her yanlış şıkkın neden yanlış olduğu `celdiriciler`'de yazılı ve kaynakla tutarlı.
- [ ] Her alıntıyı `kaynaklar/` metninde aratıp birebir buldum.
- [ ] Hesaplama sorusunda `dogrulama.python` aynı sonucu veriyor.
- [ ] Kökte çözüm için gereken her bilgi var; gereksiz veri bilerek konduysa açıklamada belirtildi.
- [ ] Zorluk etiketi GOREV satırıyla aynı; zor sorularda en az iki teknik var (URETIM_KURALLARI §7).

## 5. Teslim biçimi

Tek bir YAML dosyası teslim et: `teslim_<adın>_<tarih>.yaml`. Yapısı:

```yaml
yazar: "<adın veya takma adın>"
gorev: "<GOREV.md başlığındaki paket kodu>"
atlanan:            # yazamadığın satırlar (yoksa boş liste)
  - satir: 7
    neden: "Kazanım için kaynaklar/ içinde metin yok"
sorular:
  - gorev_satiri: 1           # GOREV.md'deki satır numarası
    bolum: [YET]
    ders: HUK
    konu: TIC
    kazanim: "şirket türleri"
    tip: uygulama             # bilgi | kavrama | uygulama | hesaplama
    zorluk: 3
    kok: "…"
    secenekler: {A: "…", B: "…", C: "…", D: "…", E: "…"}
    dogru: D
    aciklama:
      dogru_neden: "… Püf noktaları: …"
      celdiriciler: {A: "…", B: "…", C: "…", E: "…"}
      hesap_adimlari: []      # hesaplama sorusunda adım adım
    kaynaklar:
      - mevzuat: "6102 sayılı Türk Ticaret Kanunu"
        madde: "md. 573/1"
        alinti: "…birebir…"
    gecerlilik: {baslangic: "2012-07-01", bitis: null, yila_bagli_tutar: false}
    dogrulama:                # yalnız hesaplama sorusunda
      python: "sonuc = 1000 * 0.2"
```

`id`, `durum`, `surum`, `uretim` alanlarını **yazma** — bunları biz veririz. Örnek sorulardaki diğer alanların anlamı için `SEMA.json`'a bak.
