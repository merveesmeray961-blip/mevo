"""Mevzuat takip: Resmî Gazete'yi her gün tarar, uygulamalardaki soruları etkileyebilecek değişiklikleri bulur,
panel.html'i günceller ve kritik değişikliklerde WhatsApp (CallMeBot) mesajı gönderir.

Kullanım:
  python tara.py                 # son taranan günden bugüne kadar (eksik günleri de) tarar
  python tara.py --bastan 2026-10-17   # bu tarihten itibaren yeniden tarar (geriye dönük kontrol)
  python tara.py --deneme-mesaj  # WhatsApp ayarını sınar
Ayar: ayar.json  {"whatsapp_tel": "+90...", "callmebot_apikey": "..."}  (yalnız bu bilgisayarda durur)
"""
import datetime as dt, html, io, json, re, sys, time, urllib.parse, urllib.request
from pathlib import Path
import yaml

K = Path(__file__).resolve().parent
PROJE = K.parent
VERI = K / "veri"; VERI.mkdir(exist_ok=True)
DURUM, DEG = VERI / "durum.json", VERI / "degisiklikler.json"
BASLANGIC = "2026-10-17"  # mevzuat metinlerinin alındığı tarih
UA = {"User-Agent": "Mozilla/5.0 (mevzuat-takip)"}
FIIL = ("değiştirilmiştir", "eklenmiştir", "yürürlükten kaldırılmıştır", "iptaline", "ibaresi", "aşağıdaki şekilde",
        "yeniden düzenlenmiştir", "mülga", "yürürlüğe girer", "değiştirilmesine")


def kucult(s):
    return (s or "").replace("İ", "i").replace("I", "ı").lower()


def oku_json(p, varsayilan):
    try:
        return json.loads(p.read_text(encoding="utf-8-sig"))
    except Exception:
        return varsayilan


def getir(url, deneme=3):
    for i in range(deneme):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=40) as r:
                return r.read()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            time.sleep(3 * (i + 1))
        except Exception:
            time.sleep(3 * (i + 1))
    raise RuntimeError(f"erişilemedi: {url}")


def coz(b):
    """Resmî Gazete sayfaları çoğunlukla windows-1254; önce bildirilen/UTF-8, olmazsa 1254."""
    m = re.search(rb'charset=["\']?([\w-]+)', b[:2000], re.I)
    for enc in ([m.group(1).decode()] if m else []) + ["utf-8", "windows-1254"]:
        try:
            return b.decode(enc)
        except Exception:
            continue
    return b.decode("windows-1254", "replace")


def metin(url):
    b = getir(url)
    if not b:
        return ""
    if url.lower().endswith(".pdf"):
        try:
            import pypdf
            return "\n".join((p.extract_text() or "") for p in pypdf.PdfReader(io.BytesIO(b)).pages[:60])
        except Exception:
            return ""
    t = coz(b)
    return html.unescape(re.sub(r"<[^>]+>", " ", re.sub(r"(?is)<(script|style).*?</\1>", " ", t)))


def fihrist(gun):
    """Günün (ve mükerrerlerin) başlıklarını döndürür: [(bolum, baslik, url, sayi)]."""
    y, a, g = gun.strftime("%Y"), gun.strftime("%m"), gun.strftime("%Y%m%d")
    taban = f"https://www.resmigazete.gov.tr/eskiler/{y}/{a}/"
    sonuc, sayfalar = [], [g] + [f"{g}M{i}" for i in range(1, 6)]
    for s in sayfalar:
        b = getir(taban + s + ".htm")
        if b is None:
            if s == g:
                return None  # o gün gazete yok (ya da henüz yayımlanmadı)
            break
        t = re.sub(r"\s+", " ", coz(b))
        sayi = (re.search(r"(\d{5}) (?:\(Mükerrer\) )?Sayılı", html.unescape(t)) or [None, ""])[1]
        bolum = ""
        for parca in re.split(r"(<a[^>]+>.*?</a>)", t):
            if parca.startswith("<a"):
                m = re.match(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>', parca)
                if not m:
                    continue
                href, bas = m.group(1), html.unescape(re.sub("<[^>]+>", "", m.group(2))).strip("  –-")
                bas = re.sub(r"^[^\wÇĞİÖŞÜçğıöşü(]+", "", bas)
                if len(bas) < 8 or "main.aspx" in href or href.endswith(f"{g}.pdf"):
                    continue
                sonuc.append((bolum, bas, href if href.startswith("http") else taban + href, sayi + (" (Mük.)" if "M" in s else "")))
            else:
                duz = html.unescape(re.sub("<[^>]+>", "|", parca))
                for b in [x.strip() for x in duz.split("|") if x.strip()]:
                    if b.isupper() and 3 < len(b) < 60:
                        bolum = b
    return sonuc


def soru_etkisi(konular):
    """Her konu için kaynak gösterilen soru sayısı ve madde listesi (etki hesabı)."""
    say = {k["ad"]: {"soru": 0, "maddeler": {}} for k in konular}
    for d in ("content/sorular", "content/klasik"):
        for p in (PROJE / d).rglob("*.yaml"):
            for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
                if s.get("durum") == "geri_cekildi":
                    continue
                gordu = set()
                for kay in s.get("kaynaklar") or []:
                    if not isinstance(kay, dict):
                        continue
                    ad = kucult(kay.get("mevzuat"))
                    for k in konular:
                        if any(x in ad for x in k["soru"]):
                            if k["ad"] not in gordu:
                                say[k["ad"]]["soru"] += 1; gordu.add(k["ad"])
                            for n in re.findall(r"(\d+)", str(kay.get("madde") or ""))[:1]:
                                say[k["ad"]]["maddeler"][n] = say[k["ad"]]["maddeler"].get(n, 0) + 1
    return say


def eslestir(cfg, bolum, baslik, url):
    """(seviye, [konu adları], [madde no], not) — seviye: kritik | olasi | None"""
    kb, bk = kucult(baslik), kucult(bolum)
    if any(x in kb for x in cfg["atla"]):
        return None, [], [], ""
    konular = [k["ad"] for k in cfg["konular"] if any(x in kb for x in k["rg"])]
    if konular:
        seviye, notu, metin_k = "kritik", "başlıkta geçiyor", None
    else:
        seviye, notu, metin_k = None, "", None
    icerik_bak = konular or any(x in bk or x in kb for x in cfg["icerik_bolumleri"]) or "anayasa mahkemesi" in kb
    maddeler = []
    if icerik_bak:
        try:
            metin_k = kucult(metin(url))
        except Exception as e:
            metin_k, notu = "", f"içerik açılamadı: {e}"
        if metin_k and not konular:
            for k in cfg["konular"]:
                for x in k["rg"]:
                    i = metin_k.find(x)
                    while i >= 0:
                        pencere = metin_k[i:i + 400]
                        # Değişiklik o mevzuatın kendisine mi yapılıyor? ("... Kanununun 5 inci maddesi ... değiştirilmiştir")
                        kendisi = re.search(r"(kanununun|kanunun\b|tebliğinin|tebliğin\b|yönetmeliğinin|kararının|kararnamenin|kanunu ile)", metin_k[i:i + 90])
                        if (kendisi and any(f in pencere for f in FIIL)) or "anayasa mahkemesi" in kb:
                            konular.append(k["ad"]); seviye, notu = "kritik", "metinde değişiklik hükmü"
                            break
                        i = metin_k.find(x, i + 1)
                    if k["ad"] in konular:
                        break
                else:
                    continue
            if not konular:
                yakin = [k["ad"] for k in cfg["konular"] if any(x in metin_k for x in k["rg"] if "sayılı" in x)]
                if yakin:
                    konular, seviye, notu = yakin[:3], "olasi", "metinde atıf var (değişiklik hükmü görülmedi)"
        if metin_k:
            # Yalnız değiştirilen mevzuatın maddeleri: "... Kanununun 104 üncü maddesinin" kalıbı.
            maddeler = sorted(set(re.findall(
                r"(?:kanununun|kanunun|tebliğinin|tebliğin|yönetmeliğinin|yönetmeliğin|kararının|kararın|kararnamenin)\s+"
                r"(?:geçici\s+|ek\s+|mükerrer\s+)?(\d+)\s*['’]?\s*(?:inci|ıncı|üncü|uncu|nci|ncı|ncü|ncu)?\s*madde", metin_k)), key=int)[:40]
    if not seviye and any(x in kb for x in cfg["genel"]):
        seviye, notu = "olasi", "başlıkta genel anahtar kelime"
    return seviye, sorted(set(konular)), maddeler, notu


def whatsapp(ayar, mesaj):
    tel, key = (ayar.get("whatsapp_tel") or "").strip(), (ayar.get("callmebot_apikey") or "").strip()
    if not tel or not key:
        return "ayar yok"
    url = "https://api.callmebot.com/whatsapp.php?" + urllib.parse.urlencode({"phone": tel, "text": mesaj[:1500], "apikey": key})
    try:
        b = getir(url, deneme=2) or b""
        return "gönderildi" if b"queued" in b.lower() or b"sent" in b.lower() or b"message" in b.lower() else b[:120].decode("utf-8", "replace")
    except Exception as e:
        return f"hata: {e}"


def telegram(ayar, mesaj):
    tok, chat = (ayar.get("telegram_token") or "").strip(), str(ayar.get("telegram_chat_id") or "").strip()
    if not tok or not chat:
        return "ayar yok"
    veri = urllib.parse.urlencode({"chat_id": chat, "text": mesaj[:3900], "disable_web_page_preview": "true"}).encode()
    try:
        with urllib.request.urlopen(urllib.request.Request(f"https://api.telegram.org/bot{tok}/sendMessage", data=veri), timeout=30) as r:
            return "gönderildi" if json.loads(r.read()).get("ok") else "hata"
    except Exception as e:
        return f"hata: {str(e)[:80]}"


def bildir(ayar, mesaj):
    """Telegram ve (ayarlıysa) WhatsApp'a gönderir; panelde gösterilecek kısa sonuç döner."""
    s = {"telegram": telegram(ayar, mesaj), "whatsapp": whatsapp(ayar, mesaj)}
    gonderildi = [k for k, v in s.items() if v == "gönderildi"]
    if gonderildi:
        return "gönderildi: " + ", ".join(gonderildi)
    return "ayar yok" if all(v == "ayar yok" for v in s.values()) else "; ".join(f"{k}: {v}" for k, v in s.items())


def telegram_kur(ayar):
    """Kullanıcı bota /start yazdıktan sonra sohbet numarasını bulup ayar.json'a yazar."""
    tok = (ayar.get("telegram_token") or "").strip()
    if not tok:
        return "Önce ayar.json'a telegram_token yazın."
    with urllib.request.urlopen(f"https://api.telegram.org/bot{tok}/getUpdates", timeout=30) as r:
        sonuc = json.loads(r.read()).get("result", [])
    sohbet = [u["message"]["chat"]["id"] for u in sonuc if "message" in u]
    if not sohbet:
        return "Bota henüz mesaj gelmemiş: Telegram'da botunuzu açıp /start yazın, sonra tekrar çalıştırın."
    ayar["telegram_chat_id"] = sohbet[-1]
    (K / "ayar.json").write_text(json.dumps(ayar, ensure_ascii=False, indent=1), encoding="utf-8")
    return "Sohbet bulundu ve kaydedildi. Deneme: " + telegram(ayar, "✅ Mevzuat Takip: Telegram bağlantısı çalışıyor.")


def panel_yaz(durum, degisiklikler, etki, konular):
    veri = json.dumps({"durum": durum, "degisiklikler": degisiklikler, "etki": etki,
                       "konular": [k["ad"] for k in konular]}, ensure_ascii=False)
    sablon = (K / "panel_sablon.html").read_text(encoding="utf-8")
    (K / "panel.html").write_text(sablon.replace("/*VERI*/null", veri), encoding="utf-8")


def main():
    ayar = oku_json(K / "ayar.json", {})
    if "--deneme-mesaj" in sys.argv:
        print(bildir(ayar, "✅ Mevzuat Takip: bildirim bağlantısı çalışıyor.")); return
    if "--telegram-kur" in sys.argv:
        print(telegram_kur(ayar)); return
    cfg = yaml.safe_load((K / "izleme.yaml").read_text(encoding="utf-8"))
    for k in cfg["konular"]:
        k["rg"] = [kucult(x) for x in k["rg"]]; k["soru"] = [kucult(x) for x in k["soru"]]
    cfg["genel"] = [kucult(x) for x in cfg["genel"]]; cfg["atla"] = [kucult(x) for x in cfg["atla"]]
    cfg["icerik_bolumleri"] = [kucult(x) for x in cfg["icerik_bolumleri"]]
    durum = oku_json(DURUM, {"son_tarih": None, "hata_gun": 0, "son_kalp": None})
    degisiklikler = oku_json(DEG, [])
    bilinen = {d["url"] for d in degisiklikler}
    bugun = dt.date.today()
    if "--bastan" in sys.argv:
        bas = dt.date.fromisoformat(sys.argv[sys.argv.index("--bastan") + 1])
    else:
        bas = dt.date.fromisoformat(durum["son_tarih"]) + dt.timedelta(days=1) if durum.get("son_tarih") else dt.date.fromisoformat(BASLANGIC)
    etki = soru_etkisi(cfg["konular"])
    yeni, taranan, hata = [], 0, None
    gun = bas
    while gun <= bugun:
        try:
            liste = fihrist(gun)
        except Exception as e:
            hata = f"{gun}: {e}"; break
        if liste is not None:
            taranan += 1
            for bolum, baslik, url, sayi in liste:
                if url in bilinen:
                    continue
                seviye, konu, maddeler, notu = eslestir(cfg, bolum, baslik, url)
                if not seviye:
                    continue
                etk = sum(etki[k]["soru"] for k in konu)
                madde_etk = sum(etki[k]["maddeler"].get(m, 0) for k in konu for m in maddeler)
                kayit = {"tarih": gun.isoformat(), "sayi": sayi, "bolum": bolum, "baslik": baslik, "url": url,
                         "seviye": seviye, "konular": konu, "maddeler": maddeler, "not": notu,
                         "etkilenen_soru": etk, "madde_eslesen_soru": madde_etk, "bulundu": dt.datetime.now().isoformat(timespec="minutes")}
                degisiklikler.append(kayit); bilinen.add(url); yeni.append(kayit)
            durum["son_tarih"] = gun.isoformat()
        elif gun < bugun:
            durum["son_tarih"] = gun.isoformat()  # o gün gazete yok
        gun += dt.timedelta(days=1)
    durum["son_calisma"] = dt.datetime.now().isoformat(timespec="minutes")
    kanal = [k for k, v in (("Telegram", ayar.get("telegram_token") and ayar.get("telegram_chat_id")),
                            ("WhatsApp", ayar.get("whatsapp_tel") and ayar.get("callmebot_apikey"))) if v]
    if durum.get("son_mesaj") in (None, "ayar yok") and kanal:
        durum["son_mesaj"] = "hazır: " + ", ".join(kanal)
    durum["hata_gun"] = durum.get("hata_gun", 0) + 1 if hata else 0
    durum["son_hata"] = hata
    durum["taranan_gun_son_calisma"] = taranan
    degisiklikler.sort(key=lambda d: (d["tarih"], d["seviye"] != "kritik"), reverse=True)
    DEG.write_text(json.dumps(degisiklikler, ensure_ascii=False, indent=1), encoding="utf-8")

    kritik = [d for d in yeni if d["seviye"] == "kritik"]
    if kritik:
        satir = [f"📜 Mevzuat değişikliği — {len(kritik)} kayıt"]
        for d in kritik[:8]:
            satir.append(f"• RG {d['tarih']} ({d['sayi']}): {d['baslik'][:110]}\n  Konu: {', '.join(d['konular'])} | Etkilenebilecek soru: {d['etkilenen_soru']}"
                         + (f" (madde eşleşen {d['madde_eslesen_soru']})" if d["madde_eslesen_soru"] else ""))
        if len(kritik) > 8:
            satir.append(f"… ve {len(kritik) - 8} kayıt daha. Ayrıntı: Mevzuat Takip paneli.")
        durum["son_mesaj"] = bildir(ayar, "\n".join(satir))
    elif durum["hata_gun"] >= 2:
        durum["son_mesaj"] = bildir(ayar, f"⚠️ Mevzuat Takip {durum['hata_gun']} gündür Resmî Gazete'ye ulaşamıyor: {hata}")
    elif bugun.weekday() == 0 and durum.get("son_kalp") != bugun.isoformat():
        acik = sum(1 for d in degisiklikler if d["seviye"] == "kritik")
        durum["son_mesaj"] = bildir(ayar, f"✅ Mevzuat Takip çalışıyor. Son taranan gazete: {durum['son_tarih']}. Bu hafta yeni kritik değişiklik yok. Kayıtlı kritik toplam: {acik}.")
        durum["son_kalp"] = bugun.isoformat()
    DURUM.write_text(json.dumps(durum, ensure_ascii=False, indent=1), encoding="utf-8")
    panel_yaz(durum, degisiklikler, {k: v["soru"] for k, v in etki.items()}, cfg["konular"])
    print(f"taranan gün {taranan}, yeni kayıt {len(yeni)} (kritik {len(kritik)}), son tarih {durum['son_tarih']}, hata {hata}")


if __name__ == "__main__":
    main()
