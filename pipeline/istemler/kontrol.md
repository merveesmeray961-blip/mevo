# Model tabanlı kontrol kapıları (G3, G5, G6)

Her kapı, soruyu yazan ajandan **bağımsız** bir ajan tarafından yürütülür. Kontrolcü, soru dosyasını değiştirmez; yalnızca
karar verir. Kararlar `uretim.kapilar.<G>` alanına `{sonuc: gecti|kaldi, not, tarih}` olarak işlenir.

## G3 — Bağımsız çözüm (iki ayrı ajan)

1. Sana yalnızca **kök ve şıklar** verilir; cevap anahtarı, açıklama ve kaynak verilmez.
2. Soruyu sınavdaki bir aday gibi çöz. Gerekirse resmî metni getir: `python -m pipeline.kaynak <kod> <madde>`.
3. Çıktı: `{id, cevap: A-E | "BELİRSİZ", gerekce, guven: 1-5}`.
4. **Geçme ölçütü:** İki bağımsız çözücünün ikisi de cevap anahtarıyla aynı şıkkı, en az 4 güvenle bulmalı. Aksi hâlde `kaldi`.

## G5 — Düşman denetimi

Amaç soruyu çürütmektir. Şunları ara:
- Doğru şık dışında savunulabilir ikinci bir doğru şık var mı?
- Doğru şık gerçekten doğru mu (kaynağa göre)?
- Kök belirsiz, eksik veriyle ya da birden fazla yoruma açık mı?
- Hesaplama: veri tutarlı mı, hesap makinesiz çözülebilir mi, yuvarlama sorunu var mı?
- Mevzuat güncel mi (mülga, değişik, yürürlük tarihi)?
- Çeldirici, kökü okumadan elenebilecek kadar zayıf mı?

Çıktı: `{id, sonuc: gecti | kaldi, itirazlar: [...], onerilen_duzeltme}`. İnandırıcı tek bir itiraz bile `kaldi` sebebidir.

## G6 — Kaynak uyumu

1. Sorunun `kaynaklar` alanındaki her madde için resmî metni getir (`pipeline.kaynak` veya mevzuat klasörü).
2. Alıntının resmî metinle birebir örtüştüğünü doğrula.
3. Açıklamadaki (`dogru_neden`, `celdiriciler`) her iddianın resmî metinde karşılığı olduğunu doğrula.
4. Çıktı: `{id, sonuc, desteksiz_iddialar: [...], alinti_uyumsuz: bool}`. Desteksiz tek iddia `kaldi` sebebidir.

### Yasal metni olmayan yöntem soruları

Maliyet yöntemleri (FIFO/ortalama, eşdeğer birim, sapma analizi, ortak maliyet dağıtımı), oran analizi formülleri ve
iktisat/maliye teorisi bir kanun maddesine değil, alanın standart yöntemlerine dayanır. Bu sorularda G6:
1. Kullanılan formül veya yöntemin kökte ya da açıklamada **açıkça** yazılı olduğunu,
2. Formülün yaygın ders kitabı tanımıyla tutarlı olduğunu (yoruma açıksa kökte tanımlanmış olmalı),
3. `dogrulama.python` sonucunun açıklamadaki hesapla aynı olduğunu denetler.
Tekdüzen Hesap Planı'na dayanan iddialar (hesap kodları, 7/A–7/B akışı, kapanış kayıtları) için alıntı zorunludur:
`content/kaynaklar/mevzuat/msugt_1_ek5_thp_guncel.txt` ve `msugt_1*.txt`.
Bu sorular uzman incelemesinde (G8) yöntem bakımından ayrıca işaretlenir.

## Raporlama

Kapı sonuçları sorulara işlendikten sonra `python -m pipeline.denetle <klasör>` tüm kapıların durumunu gösterir.
Bütün kapılardan geçen soru `durum: kontrolde` olur ve uzman incelemesine (G8) gider.
