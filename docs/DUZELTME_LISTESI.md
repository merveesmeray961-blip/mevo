# Uzman sonrası düzeltme listesi

Bu notlar soru dosyalarına **uzman incelemesi döndükten sonra, tek turda** işlenecek. Bir soruyu şimdi değiştirmek
sürümünü yükseltir, G3/G5/G6/GZ kapılarını sıfırlar ve uzmana giden kitapçıktaki metinle bankadaki metni ayırır.
Her madde işlendiğinde soru yeniden kapılardan geçirilir ve madde buradan silinir.

## Açıklama biçimi (21 soru)

Zor soruların `dogru_neden` alanında teknik notu farklı etiketlerle yazılmış ("Kullanılan teknikler:",
"Zor soru teknikleri:", "Bu soru zor düzeydedir; kullanılan teknikler:", "Zorluk (3) kaynakları:",
"Zor soru; üç teknik birlikte kullanılır:"). Uygulama paketi bunları şimdilik dışa aktarımda ayırıyor
(`pipeline/disa_aktar.py --uygulama`). Düzeltme turunda hepsi tek biçime getirilecek: çözümden sonra
**"Püf noktaları:"** etiketi ve adaya hitap eden sade dil (`pipeline/istemler/uretim.md` §7).

## Soru bazında

| Soru | Not | Kaynak |
|---|---|---|
| DEN-BDY-0002 | Cevap (C) doğru. Dayanaklara TTK md. 400/2 eklenebilir ("On yıl içinde aynı şirket için toplam yedi yıl denetçi olarak seçilen denetçi üç yıl geçmedikçe denetçi olarak yeniden seçilemez"; usul ve esaslar KGK'ya bırakılmış). Yönetmelik md. 26/1-ç ve 26/2 bu hükmün uygulamasıdır; (B)'nin seçildiği süre 3 yıl olduğundan kanun düzeyinde de kısıt yok. | Merve'nin isteğiyle kontrol, 3 Ekim 2026 |
| FIN-MKY-0001 | B, C, D şıklarının çeldirici açıklamalarına dayanak alıntısı eklenecek. | G6 denetçi notu |
| FIN-DON-0001 | D şıkkı için alıntı eklenecek; `gecmis` kaydındaki VUK/KDVK notu düzeltilecek. | G6 denetçi notu |
| FIN-HAZ-0001 | `gecmis` kaydındaki VUK/KDVK notu düzeltilecek. | G6 denetçi notu |
| STD-TFR-0002 | TMS 36 par. 18 alıntısı eklenecek. | G6 denetçi notu |
| STD-TFR-0004 | TFRS 15 par. 74 alıntısı eklenecek. | G6 denetçi notu |
| TAB-TMS-0001 | `gecerlilik.bitis` = 2026-12-31 (TFRS 18, 1 Ocak 2027'den itibaren TMS 1'in yerini alıyor); TFRS 18 sürümü ayrıca yazılacak. Uzman görüşüne bağlı (UZMAN_INCELEME.md §3-1). | Plan notu |
