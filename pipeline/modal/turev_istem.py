"""Türev hattı istemleri: ÇIKMIŞ SORUDAN ÖZGÜN SORU (kalıp → yeni senaryo/sayı/şık, güncel mevzuat kanıtlı).

Akıl yürüten model (Qwen3-235B-A22B-Thinking-2507) için yazıldı: çıktı '<düşünme>…</think>' + tek JSON nesnesi.
"""
from __future__ import annotations

import json
import re
from functools import lru_cache

from pipeline.modal import getir, istemler

SURUM = "turev-hat v1 (2026-11-02)"
KOK = getir.KOK


@lru_cache(maxsize=None)
def proje_kurallari() -> str:
    u = (KOK / "pipeline/istemler/uretim.md").read_text(encoding="utf-8")
    k = (KOK / "pipeline/istemler/kontrol.md").read_text(encoding="utf-8")
    return "\n\n".join([istemler._bolum(u, "## 4. Biçim", "## 8."), istemler._bolum(k, "## G5", "## G6"),
                        istemler._bolum(k, "### Yasal metni olmayan", "## Raporlama")])


SERT = """=== SERT KURALLAR (her biri tek başına RET sebebidir; otomatik kapılar ölçer) ===
K1 KOPYA YASAK. Sana verilen KALIP soru gerçek bir sınav sorusudur ve telif/özgünlük nedeniyle KOPYALANAMAZ.
   Yeni sorunun kökü, senaryosu, kişi/şirket adları, tüm sayıları ve tüm şıkları kalıptan FARKLI olmalı. Kalıptan
   cümle, kalıp şık metni ya da kalıptaki sayı/ad kullanma. Aynı KURALI (ölçülen bilgi/hüküm) başka bir olay, başka
   rakamlar ve başka şıklarla sor; mümkünse aynı hükmün kalıpta sorulmayan bir unsurunu (başka şart, başka istisna,
   başka süre) öne çıkar. Kalıpla kelime 5-gram örtüşmesi ölçülür; %15'i aşan soru silinir.
K2 MEVZUAT KANITI. Sorudaki her hukuki/teknik iddia aşağıdaki [P1]…[Pn] resmî metin parçalarında AÇIKÇA yazılı
   olmalı. `kaynaklar[].alinti` parçadan KELİMESİ KELİMESİNE, tek kesintisiz kopyadır (60–450 karakter; "..." yok,
   kısaltma yok, kendi cümlen yok). Alıntılar resmî metin dosyalarında harf harf aranır; bulunmayan soru silinir.
   Doğru cevap alıntıdan DOĞRUDAN çıkmalı; her çeldiricinin yanlışlığı `aciklama.celdiriciler` içinde bir parçaya
   ("[P3]'e göre …") dayanarak gösterilmeli.
K3 GÜNCELLİK. Kalıp eski bir yılın mevzuatına göre yazılmış olabilir. Oran, tutar, süre, had, sayı YALNIZ verilen
   parçalarda yazılı ise kullanılır; kalıptaki rakamı, parçada yoksa ASLA kullanma. Kalıbın dayandığı hüküm
   parçalara göre değişmişse yeni soruyu GÜNCEL hükme göre kur; hüküm mülga ise ya da parçalarda bulunamıyorsa ATLA.
   Yıla bağlı tutar (tarife dilimi, had, asgari ücret vb.) kullanırsan `gecerlilik.yila_bagli_tutar: true` ve
   `gecerlilik.yil` yaz; kökte yılı açıkça belirt ve o yılın parçadaki tutarını kullan.
K4 UYDURMA YASAK. Parçada görmediğin madde/fıkra/bent/geçici madde/tebliğ/standart paragraf numarası yazma
   (`madde` alanı parçanın başlığındaki numarayla aynı olmalı; emin değilsen yalnız madde numarasını yaz).
   Senaryoda imkânsız, çelişkili ya da o tarihte uygulanamayan bir varsayım kurma (ör. kaldırılmış bir uygulamanın
   o yıl yapıldığını varsaymak, dönem/tarih sırası tutarsız olaylar, toplamı tutmayan veriler).
K5 TEK DOĞRU. Yalnız bir şık savunulabilir. Kök tek başına anlaşılır; sonucu etkileyen her koşul (mükellefiyet
   türü, yıl, KDV dahil/hariç, yöntem, şirket türü, süre başlangıcı) kökte yazılı. "Hepsi/hiçbiri" şıkkı yok.
   Doğru şık en uzun şık olmasın; şıklar benzer uzunlukta ve aynı biçimde olsun.
K6 HESAP. Hesap sorusunda `tip: "hesaplama"`, `aciklama.hesap_adimlari` ve `dogrulama.python` zorunlu;
   python yalnız düz aritmetik (import, int(), float(), def, lambda, liste üreteci YOK), son satır `sonuc = ...`;
   sonuç yalnız doğru şıktaki sayıya eşit olmalı. Sayısal şıklar küçükten büyüğe sıralı; elle çözülebilir rakamlar.
K6b ZORUNLU ALANLAR. `aciklama.celdiriciler` doğru şık DIŞINDAKİ dört harfin HER BİRİ için yazılır (eksik = ret).
   Kökü kalıbın kök cümlesiyle başlatma; kendi senaryonla ya da farklı bir soru kalıbıyla kur. Yevmiye şıklarında
   aynı kaydın satır sırası değiştirilmiş hâli başka bir şık olamaz (iki doğru şık olur). Senaryodaki kişi/şirket
   nitelikleri birbiriyle bağdaşmalı (ör. "kooperatif niteliğinde A.Ş." gibi imkânsız nitelemeler yok); oran
   kullanılan tutarlar o yılın oranıyla tutarlı olmalı.
K7 EMİN DEĞİLSEN ATLA. Yukarıdakilerden birini sağlayamıyorsan ya da kalıbın doğru cevabının dayanağını
   parçalarda bulamıyorsan yalnız şunu döndür: {"atla": true, "neden": "..."}. Hatalı soru yazmak, atlamaktan
   çok daha kötüdür; atlamak ceza değildir."""

SEMA = """{
  "kalip_kurali": "kalıp sorunun ölçtüğü kural/bilgi, 1-2 cümle",
  "guncellik": {"durum": "gecerli | guncellendi", "parca": "P?", "not": "kural parçada nasıl/nerede yazılı; değiştiyse ne değişti"},
  "kazanim": "aşağıdaki kazanım listesinden biri (aynen)",
  "tip": "bilgi | kavrama | uygulama | hesaplama",
  "zorluk": 1 | 2 | 3,
  "soru_bicimi": "standart | olumsuz | oncullu | bosluk",
  "kok": "soru kökü (öncüller I., II., III. ayrı satırlarda; olumsuz ifade **kalın**)",
  "secenekler": {"A": "...", "B": "...", "C": "...", "D": "...", "E": "..."},
  "dogru": "A-E",
  "aciklama": {"dogru_neden": "parçaya atıfla gerekçe (zorluk 3 ise sonunda 'Püf noktaları: ...')",
               "celdiriciler": {"<doğru dışındaki 4 harfin her biri>": "[P?]'ye göre neden yanlış"},
               "hesap_adimlari": ["yalnız hesaplamada"]},
  "kaynaklar": [{"mevzuat": "resmî ad (ör. 6098 sayılı Türk Borçlar Kanunu)", "madde": "md. 147 | par. 26",
                 "parca": "P2", "alinti": "parçadan birebir kopya"}],
  "gecerlilik": {"baslangic": "YYYY-AA-GG", "bitis": null, "yila_bagli_tutar": false},
  "dogrulama": {"python": "yalnız hesaplamada; sonuc = ..."}
}"""


def uretim_sistem() -> str:
    return f"""Sen Türkiye'de SMMM/YMM sınavları için soru yazan kıdemli bir uzmansın. Görevin: gerçek bir çıkmış
sınav sorusunu (KALIP) incelemek, onun ölçtüğü kuralı belirlemek ve AYNI KURALI ölçen, kalıptan tamamen bağımsız,
GÜNCEL mevzuata dayalı YENİ bir soru yazmak. Yazdığın soru cevabı görmeden çözen iki bağımsız çözücüden ve düşmanca
bir hakemden geçecek; tek hata soruyu çöpe atar. Kalite her şeyden önce gelir.

{SERT}

=== PROJE KURALLARI (bağlayıcı) ===
{proje_kurallari()}

=== ÇALIŞMA SIRASI ===
1. Kalıbın resmî cevabını, kalıbın ölçtüğü kuralı ve bu kuralın parçalardaki yerini bul (bulamazsan ATLA).
2. Kuralın güncel hâlini parçalardan doğrula (oran/süre/tutar değişmiş olabilir).
3. Yeni senaryo/öncül/şıkları kur; çeldiricileri tipik aday hatalarından türet.
4. Soruyu cevabı bilmeyen bir aday gibi baştan çöz: tek doğru var mı, her çeldirici parçaya göre kesin yanlış mı,
   kökte eksik koşul var mı, kalıptan cümle/sayı/ad taşıdın mı? Sorun varsa düzelt ya da ATLA.
5. Alıntıyı parçadan harfi harfine kopyala.

=== ÇIKTI ===
Düşünmeni bitirdikten sonra YALNIZ tek bir JSON nesnesi yaz (markdown çerçevesi yok):
{SEMA}
`tip` hesaplama değilse `hesap_adimlari` ve `dogrulama` yazma."""


def uretim_kullanici(k: dict, parcalar: list[dict], kazanimlar: list[str], banka_kokleri: list[str], hedef: str) -> str:
    from pipeline.modal.kalip import kalip_metni
    s = ["## KALIP (gerçek çıkmış soru — KOPYALAMA, yalnız ölçtüğü kuralı kullan)",
         f"Sınav: {k['sinav'].upper()} {k.get('yil')}{'-' + str(k['donem']) if k.get('donem') else ''} · Ders: {k['ders']} · "
         f"Konu: {k.get('konu')} ({k.get('konu_aciklama') or '-'})",
         kalip_metni(k), f"Resmî cevap anahtarı: {k['dogru']}",
         "", f"## Yeni soru için kazanım listesi (birini aynen seç)", *[f"- {x}" for x in kazanimlar],
         f"- Yeni sorunun doğru şık harfi tercihen {hedef} olsun (sayısal şıklarda sıralama gereği farklı olabilir)."]
    if banka_kokleri:
        s += ["", "## Bankada bu konuda ZATEN OLAN sorular (bunların bilgisini/kurgusunu tekrar etme)"]
        s += [f"- {x}" for x in banka_kokleri]
    s += ["", "## Resmî metin parçaları (GÜNCEL; yalnız bunlara dayan)", getir.bicimle(parcalar) if parcalar else "(parça yok → ATLA)",
          "", "Şimdi tek bir yeni soru yaz ya da ATLA; yalnız JSON döndür."]
    return "\n".join(s)


COZUCU = """Sen {sinav} sınavına çok iyi hazırlanmış, titiz bir adaysın. Sana bir çoktan seçmeli soru ve ilgili resmî
metin parçaları verilecek. Soruyu parçalara ve uzman bilgine dayanarak çöz; hesap varsa adım adım hesapla.
Tam olarak bir şık doğruysa onu seç. İki şık savunulabiliyorsa, hiçbir şık doğru değilse ya da kök sonucu belirlemek
için gereken bir koşulu içermiyorsa ya da senaryo çelişkili/imkânsızsa cevap "BELİRSİZ" olsun.
guven: 5 kesin, 4 güçlü, 3 makul tahmin, 2 zayıf, 1 rastgele.
Düşünmeni bitirince YALNIZ şu JSON'u yaz: {{"cozum": "kısa gerekçe", "cevap": "A|B|C|D|E|BELİRSİZ", "guven": 1-5}}"""


HAKEM = """Sen {sinav} soru bankası için düşmanca çalışan kıdemli bir hakemsin. Sana verilen soru bir yapay zekâ
tarafından gerçek bir çıkmış sorudan türetildi; geçmiş denetimlerde bu tür sorularda şu hatalar bulundu:
var olmayan madde/geçici madde numarası atfı, senaryoda o yıl mümkün olmayan işlem varsayımı, birbiriyle çelişen
veriler, güncel olmayan oran/tutar, karışık/yanlış açıklama. Görevin bu soruyu ÇÜRÜTMEYE çalışmak.
Dayanağın kullanıcı mesajındaki resmî metin parçalarıdır (GÜNCEL metinler) ve uzman bilgindir.

Denetim listesi (her birini ayrı ayrı yap):
1. Anahtar: cevap anahtarındaki şık TEK doğru şık mı? Diğer dört şıkkı tek tek parçalarla çürüt; çürütemediğin şık
   varsa birden fazla doğru vardır. Her hesabı kendin yeniden yap.
2. Uydurma atıf: `kaynaklar` ve açıklamadaki her madde/fıkra/bent/geçici madde/paragraf numarası parçaların
   başlıklarında ve içeriğinde gerçekten var mı ve söylenen hükmü mü içeriyor?
3. İmkânsız/çelişkili varsayım: senaryodaki olaylar, tarihler, tutarlar birbiriyle ve o yılın mevzuatıyla
   tutarlı mı? Kökte yazılmayan örtük bir varsayıma mı dayanıyor?
4. Güncellik: kullanılan oran, tutar, süre, had parçalardaki GÜNCEL hükümle aynı mı? Mülga/değişik hüküm var mı?
5. Açıklama: dogru_neden, çeldirici açıklamaları ve hesap adımları parçalarla cümle cümle uyumlu mu (özne, şart,
   istisna, mutlaklaştırma)?
6. Alıntı: `alinti` parçada birebir geçiyor mu ve iddiayı destekliyor mu?
7. Kök ve şıklar: kök açık mı, eksik koşul var mı, doğru şık biçimden/uzunluktan ele veriliyor mu, yasak şık var mı?

Proje kuralları:
{kontrol}

Her sorunu "HATA" (olgusal/hukuki/sayısal yanlış, belirsizlik, eksik koşul, ikinci doğru şık, uydurma atıf, imkânsız
varsayım, güncel olmayan hüküm, desteksiz iddia) ya da "İYİLEŞTİRME" diye etiketle. Tek bir HATA → gecerli=false.
Düşünmeni bitirince YALNIZ şu JSON'u yaz:
{{"anahtar_dogru_mu": true/false, "tek_dogru_mu": true/false, "uydurma_atif_var_mi": true/false,
  "imkansiz_varsayim_var_mi": true/false, "guncel_olmayan_hukum_var_mi": true/false, "kok_acik_mi": true/false,
  "aciklama_dogru_mu": true/false, "alinti_destekliyor_mu": true/false, "onerilen_zorluk": 1-3,
  "sorunlar": [{{"tur": "HATA|İYİLEŞTİRME", "ne": "..."}}], "gecerli": true/false}}"""


@lru_cache(maxsize=None)
def hakem_sistem(sinav: str) -> str:
    k = (KOK / "pipeline/istemler/kontrol.md").read_text(encoding="utf-8")
    return HAKEM.format(sinav=sinav.upper(), kontrol=istemler._bolum(k, "## G5", "## G6"))


def hakem_kullanici(s: dict, parcalar: list[dict]) -> str:
    alan = {k: s[k] for k in ("ders", "konu", "kazanim", "tip", "zorluk", "soru_bicimi", "kok", "secenekler", "dogru",
                              "aciklama", "kaynaklar", "gecerlilik", "dogrulama") if k in s}
    p = "## Resmî metin parçaları (GÜNCEL)\n" + getir.bicimle(parcalar) if parcalar else "## (parça yok)"
    return f"{p}\n\n## Denetlenecek soru (JSON)\n{json.dumps(alan, ensure_ascii=False, indent=1)}\n\nYalnız JSON döndür."


def dusunce_ayir(metin: str) -> tuple[str, bool]:
    """('</think>' sonrası cevap, düşünme bitti mi)."""
    if "</think>" in metin:
        return metin.rsplit("</think>", 1)[1], True
    if "<think>" in metin:
        return "", False
    return metin, True


def json_al(metin: str):
    cevap, bitti = dusunce_ayir(metin)
    if not bitti:
        return None
    return istemler.json_coz(re.sub(r"<think>.*", "", cevap, flags=re.S) if "<think>" in cevap else cevap)
