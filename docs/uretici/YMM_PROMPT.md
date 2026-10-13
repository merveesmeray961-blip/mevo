Ekteki zip, Yeminli Mali Müşavirlik (YMM) sınavı soru bankası için bir soru yazma görevidir. Kuralların hepsi
otomatik denetlenir; kurala uymayan soru reddedilir. Sırayla şunları yap:

1. Zip'i aç. `YMM_MANIFESTO.md` dosyasını baştan sona oku; sonra `GOREV_XX.md`, `ORNEKLER.yaml`, `BANKADA_OLAN.md`.
2. GOREV tablosundaki **her satır için tam bir soru** yaz: satırdaki ders, konu, kazanım, zorluk ve soru biçimi birebir
   aynı olsun. "Klasik" bölümündeki her satır için bir klasik (açık uçlu) soru yaz.
3. Bilgiyi yalnız `kaynaklar/` klasöründeki resmî metinlerden al. (İstisna: FYN ve YNM derslerinde resmî metin yoktur,
   klasör bilerek boştur; bu derslerde genel kabul görmüş ders bilgisiyle **her satırı yaz, atlama**.) Alıntıları kelimesi kelimesine kopyala; emin
   olmadığın alıntıyı yazma. Kaynakta olmayan bir satırı uydurma, `atlanan` listesine yaz.
4. Her soruyu anahtara bakmadan kendin yeniden çöz: tek doğru şık olsun, sonuca etki eden her koşul kökte yazılsın,
   şık yapısı cevabı ele vermesin, olumsuz kök **kalın** olsun.
5. Hesap sorularında `dogrulama.python` kodunu manifestodaki kısıtlarla yaz (import, int(), liste ifadesi yok).
6. Teslimden önce manifestonun 10. bölümündeki kontrol listesini her soruya uygula.
7. Çıktı olarak **yalnız YAML** ver (manifestodaki 9. bölümdeki biçim); başka açıklama yazma. Dosya adı:
   `teslim_<adın>_<GOREV_KODU>.yaml`.

Soruların hepsi tek yanıta sığmazsa ilk 10 soruyu tam YAML olarak ver; "devam" dediğimde kaldığın satırdan sürdür ve
yalnız yeni soruları aynı biçimde ver (başlık alanlarını tekrar etme). Hiçbir soruyu kısaltma.
