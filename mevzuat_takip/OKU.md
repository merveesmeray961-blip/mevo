# Mevzuat Takip (Mizan SMMM · Tasdik YMM)

- **Ne yapar:** Her sabah 08:20'de (ve bilgisayar açılınca 5 dk sonra) Resmî Gazete'yi tarar. Kaçırılan günleri de tamamlar.
  İzlenen 21 konu `izleme.yaml` dosyasında tanımlı. Kanun, CBK kararı, tebliğ, yönetmelik, kurul kararı ve Anayasa Mahkemesi kararlarının metni de açılıp okunur.
- **Panel:** Masaüstündeki "Mevzuat Takip" kısayolu (`panel.html`). Her taramada yenilenir.
  "Gözden geçirildi" düğmesi işaretlerini bu tarayıcıda saklar.
- **WhatsApp:** Kritik değişiklikte anında mesaj gönderir. 2 gün üst üste gazeteye ulaşamazsa uyarır.
  Her pazartesi "çalışıyor" mesajı gelir.
- **Ayar:** `ayar.json` → `{"whatsapp_tel": "+90...", "callmebot_apikey": "..."}`. Bu dosya git'e girmez.
- **Elle çalıştırma:** `python tara.py` · deneme mesajı: `python tara.py --deneme-mesaj` · geriye dönük: `python tara.py --bastan 2026-10-17`
- **Sınama:** `python sina.py 2024-08-02` (7524 sayılı Kanun günü → kritik çıkmalı).
- **Zamanlanmış görev:** Windows Görev Zamanlayıcı → "MevzuatTakip".
- **Değişiklik çıkınca yapılacak:** Etkilenen soruları gözden geçir → gerekirse düzelt → `content/kaynaklar/mevzuat` metnini güncelle → yeni sürüm.
