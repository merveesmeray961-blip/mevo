"""Hat istemleri: üretim, kör çözücü (×2, şık sırası farklı), hakem, ortalama aday.

Kurallar depodaki kaynaklardan okunur (pipeline/istemler/uretim.md, kontrol.md, docs/uretici/YMM_MANIFESTO.md);
böylece kurallar tek yerde güncellenir.
"""
from __future__ import annotations

import json
import re
from functools import lru_cache
from pathlib import Path

from pipeline.modal import getir

KOK = getir.KOK
HARFLER = "ABCDE"
SURUM = "modal-hat v1 (2026-11-01)"


def _bolum(metin: str, bas: str, son: str | None) -> str:
    i = metin.index(bas)
    j = metin.index(son, i) if son else len(metin)
    return metin[i:j].strip()


@lru_cache(maxsize=None)
def kurallar(sinav: str) -> str:
    u = (KOK / "pipeline/istemler/uretim.md").read_text(encoding="utf-8")
    k = (KOK / "pipeline/istemler/kontrol.md").read_text(encoding="utf-8")
    parca = [_bolum(u, "## 3. Özgünlük", "## 9."), _bolum(k, "## G5", "## G6"),
             _bolum(k, "### Yasal metni olmayan", "## Raporlama")]
    if sinav == "ymm":
        m = (KOK / "docs/uretici/YMM_MANIFESTO.md").read_text(encoding="utf-8")
        parca += [_bolum(m, "## 2. Doğruluk", "## 8."), _bolum(m, "## 11.", None)]
    return "\n\n".join(parca)


SINAV_AD = {"smmm": "SMMM (Serbest Muhasebeci Mali Müşavirlik)", "ymm": "YMM (Yeminli Mali Müşavirlik)"}

JSON_SEMA = """{
  "tip": "bilgi | kavrama | uygulama | hesaplama",
  "zorluk": 1 | 2 | 3,
  "soru_bicimi": "standart | olumsuz | oncullu | bosluk | yevmiye",
  "kok": "soru kökü (öncüller I., II., III. ayrı satırlarda; olumsuz ifade **kalın**)",
  "secenekler": {"A": "...", "B": "...", "C": "...", "D": "...", "E": "..."},
  "dogru": "A-E",
  "aciklama": {
    "dogru_neden": "doğru şıkkın kaynağa atıfla gerekçesi (zorluk 3 ise sonunda 'Püf noktaları: ...')",
    "celdiriciler": {"<doğru dışındaki 4 harfin her biri>": "neden yanlış"},
    "hesap_adimlari": ["yalnız hesaplama sorusunda: adım adım"]
  },
  "kaynaklar": [{"mevzuat": "resmî ad (ör. 3065 sayılı Katma Değer Vergisi Kanunu / TFRS 16 Kiralamalar)",
                 "madde": "md. 11/1-a | par. 26 | -", "parca": "P3", "alinti": "parçadan BİREBİR kopya"}],
  "gecerlilik": {"baslangic": "YYYY-AA-GG (hükmün yürürlük tarihi)", "bitis": null, "yila_bagli_tutar": false},
  "dogrulama": {"python": "yalnız hesaplama sorusunda; düz aritmetik, import/int()/float()/def/liste üreteci yok; sonuc = ..."}
}"""


def uretim_sistem(sinav: str) -> str:
    return f"""Sen Türkiye'de {SINAV_AD[sinav]} sınavı için özgün çoktan seçmeli soru yazan kıdemli bir uzmansın.
Yazdığın soru, cevabı görmeden çözen iki bağımsız çözücüden ve düşmanca davranan bir hakemden geçecek; tek bir
hata soruyu çöpe atar. Az ama kusursuz soru: belirsiz, eksik koşullu ya da kaynağa dayanmayan soru YAZMA.

=== BAĞLAYICI KURALLAR ===
{kurallar(sinav)}

=== BU ORTAMA ÖZEL KURALLAR (yukarıdakilerle çelişirse bunlar geçerlidir) ===
1. Araç çalıştıramazsın, dosya okuyamazsın. Dayanacağın resmî metin parçaları kullanıcı mesajında [P1] … [Pn]
   olarak verilir. Sorudaki her hukuki/teknik iddia (oran, süre, tutar, şart, kurum, madde numarası) bu parçalarda
   AÇIKÇA yer almalıdır. Bellekten madde numarası, oran, süre veya tutar yazma.
2. `kaynaklar[].alinti`: dayandığın parçadan kelimesi kelimesine, tek kesintisiz kopya (80–400 karakter). Yazım,
   noktalama ve sözcükler aynen kalır; yalnız satır sonlarını boşluğa çevirebilirsin. `parca` alanına parça
   numarasını (ör. "P3") yaz. `madde` alanı parçanın başlığındaki madde/paragraf numarasıyla tutarlı olmalı.
3. Parça verilmeyen ya da yöntem/formül dersinde (oran analizi, maliyet yöntemleri, iktisat, finansal yönetim):
   genel kabul görmüş ders bilgisine dayan; `mevzuat: "Genel bilgi — <konu adı>"`, `madde: "-"`, alinti yazma;
   kullanılan formül/yöntemi kökte açıkça tanımla.
4. Parçalar istenen kazanımı kesin bir soru yazmaya yetecek kadar karşılamıyorsa UYDURMA; yalnız şunu döndür:
   {{"atla": true, "neden": "..."}}
5. Göreve verilen kazanım, zorluk ve soru biçimine birebir uy. Bankadaki mevcut soruların bilgisini/kurgusunu
   tekrar etme; aynı kazanımın başka bir hükmünü, şartını, istisnasını veya uygulamasını sor.
6. Yazdıktan sonra soruyu cevabı bilmeyen bir aday gibi baştan çöz: tek doğru şık var mı, kökte sonuca etki eden
   her koşul yazılı mı, her çeldirici kesin olarak yanlış mı? Değilse düzelt.
7. Hesap sorusunda sayılar elle çözülebilir olsun; şıklar küçükten büyüğe sıralı; `dogrulama.python` doğru şıktaki
   sayıyı `sonuc` değişkenine bağımsız olarak hesaplasın.
8. Resmî sınav Türkçesi; Türkçe karakterler doğru. Kişi/şirket adları ve sayılar senin olsun.

=== ÇIKTI ===
Yalnız tek bir JSON nesnesi döndür (markdown çerçevesi, açıklama, ön söz YOK). Alanlar:
{JSON_SEMA}
`tip` hesaplama değilse `hesap_adimlari` ve `dogrulama` alanlarını yazma."""


def uretim_kullanici(g: dict, parcalar: list[dict], ornekler: list[dict], banka_kokleri: list[str], hedef_harf: str) -> str:
    satirlar = [f"## Görev",
                f"- Sınav: {g['sinav'].upper()} · Bölüm: {', '.join(g['bolum'])}",
                f"- Ders: {g['ders']} — {g['ders_ad']}",
                f"- Konu: {g['konu']} — {g['konu_ad']}",
                f"- Kazanım: {g['kazanim']}",
                f"- Zorluk: {g['zorluk']} (1 kolay · 2 orta · 3 zor)",
                f"- Soru biçimi: {g['bicim']}",
                f"- Doğru şık harfi: {hedef_harf} (sayısal şıklarda sıralama gereği farklı olabilir)"]
    if banka_kokleri:
        satirlar += ["", "## Bankada bu konuda ZATEN OLAN sorular (aynı bilgiyi/kurguyu/sayısal senaryoyu tekrar etme)"]
        satirlar += [f"- {k}" for k in banka_kokleri]
    if ornekler:
        satirlar += ["", "## Kabul edilmiş örnek sorular (biçim ve kalite çıtası; içeriğini kopyalama)"]
        satirlar += [json.dumps(o, ensure_ascii=False) for o in ornekler]
    if parcalar:
        satirlar += ["", "## Resmî metin parçaları (yalnız bunlara dayan)", getir.bicimle(parcalar)]
    else:
        satirlar += ["", "## Resmî metin parçası yok: genel kabul görmüş ders bilgisine dayan (kural 3)."]
    satirlar += ["", "Şimdi bu görev için TEK bir soru yaz ve yalnız JSON döndür."]
    return "\n".join(satirlar)


COZUCU_SISTEM = """Sen {sinav} sınavına çok iyi hazırlanmış, dikkatli bir adaysın. Sana bir çoktan seçmeli soru ve
(varsa) ilgili resmî metin parçaları verilecek. Soruyu parçalara ve uzman bilgine dayanarak çöz.
- Önce kısa ama eksiksiz bir çözüm yaz (hesap varsa adım adım hesapla).
- Tam olarak bir şık doğruysa onu seç. İki şık savunulabiliyorsa, hiçbir şık doğru değilse ya da kök sonucu
  belirlemek için gereken bir koşulu içermiyorsa cevap "BELİRSİZ" olsun.
- guven: 5 = kesin, 4 = güçlü, 3 = makul tahmin, 2 = zayıf, 1 = rastgele.
Yalnız şu JSON'u döndür: {{"cozum": "...", "cevap": "A|B|C|D|E|BELİRSİZ", "guven": 1-5}}"""

ADAY_SISTEM = """Sen {sinav} sınavına giren ortalama bir adaysın. Kaynağa bakmadan, bildiklerinle ve hızlıca
(en çok 3 cümle düşünerek) soruyu çöz. Yalnız şu JSON'u döndür: {{"cozum": "...", "cevap": "A-E", "guven": 1-5}}"""


def soru_metni(kok: str, secenekler: dict) -> str:
    return kok.strip() + "\n\n" + "\n".join(f"{h}) {secenekler[h]}" for h in HARFLER)


def cozucu_kullanici(kok: str, secenekler: dict, parcalar: list[dict]) -> str:
    p = ("## Resmî metin parçaları\n" + getir.bicimle(parcalar)) if parcalar else "## (Bu soru için parça yok)"
    return f"{p}\n\n## Soru\n{soru_metni(kok, secenekler)}\n\nYalnız JSON döndür."


def karistir(secenekler: dict, n: int) -> tuple[dict, dict]:
    """Şıkları döndürür; {yeni_harf: metin}, {yeni_harf: eski_harf}."""
    harf = list(HARFLER)
    sira = harf[n:] + harf[:n]
    yeni = {h: secenekler[e] for h, e in zip(harf, sira)}
    return yeni, dict(zip(harf, sira))


HAKEM_SISTEM = """Sen {sinav} soru bankası için düşmanca çalışan kıdemli bir hakemsin. Görevin sana verilen sorudaki
HER hatayı bulmak; hata olabileceğini varsay ve soruyu çürütmeye çalış. Soruyu değiştirmezsin, yalnız karar verirsin.
Elindeki tek resmî dayanak kullanıcı mesajındaki parçalardır (parça yoksa genel kabul görmüş ders bilgisi).

Denetim listesi:
1. Anahtar: cevap anahtarındaki şık tek doğru şık mı? Başka bir şık da savunulabilir mi? Her hesabı kendin yeniden yap.
2. Kök: sonuca etki eden her koşul kökte yazılı mı (mükellefiyet türü, tarih/yıl, gün/ay esası, KDV dahil/hariç,
   yöntem, şirket türü)? Örtük varsayım, yoruma açık ifade, "genellikle" var mı?
3. Açıklama: dogru_neden, her çeldirici açıklaması ve hesap adımları kaynakla cümle cümle uyumlu mu? Kuralın kime,
   hangi şartla uygulandığı ve istisnaları doğru özetlenmiş mi? Mutlaklaştırma, özne değişikliği, şart atlama var mı?
4. Kaynak: alıntı parçada birebir geçiyor mu? `madde` numarası parçanın başlığıyla ve içeriğiyle uyumlu mu?
   Mülga/değişik hüküm, güncel olmayan oran/tutar var mı?
5. Şıklar: çeldiriciler makul mü (tipik aday hatası)? Doğru şık uzunluk/biçimle ele veriliyor mu? Yasak şık
   (hepsi/hiçbiri) var mı? Sayısal şıklar sıralı mı? Yevmiye kaydı Tekdüzen Hesap Planı işleyişine uygun mu?
6. Zorluk: etiket (1 kolay, 2 orta, 3 zor = en az iki hüküm/adım birleşir) soruya uygun mu? Tanım ezberi 3 olamaz.
7. Dil: resmî ve anlaşılır Türkçe mi; olumsuz kök kalın mı?

Kurallar:
{kontrol}

Her sorunu "HATA" (olgusal/hukuki/sayısal yanlış, belirsizlik, eksik koşul, ikinci doğru şık, yanlış atıf,
desteksiz iddia) ya da "İYİLEŞTİRME" (doğru ama daha açık olabilir) diye etiketle. Tek bir HATA → gecerli=false.
Yalnız şu JSON'u döndür:
{{"anahtar_dogru_mu": true/false, "tek_dogru_mu": true/false, "kok_acik_mi": true/false,
  "aciklama_dogru_mu": true/false, "alinti_birebir_mi": true/false, "atif_dogru_mu": true/false,
  "zorluk_uygun_mu": true/false, "onerilen_zorluk": 1-3,
  "sorunlar": [{{"tur": "HATA|İYİLEŞTİRME", "ne": "..."}}], "gecerli": true/false}}"""


@lru_cache(maxsize=None)
def hakem_sistem(sinav: str) -> str:
    k = (KOK / "pipeline/istemler/kontrol.md").read_text(encoding="utf-8")
    return HAKEM_SISTEM.format(sinav=sinav.upper(), kontrol=_bolum(k, "## G5", "## Raporlama"))


def hakem_kullanici(soru: dict, parcalar: list[dict]) -> str:
    p = ("## Resmî metin parçaları\n" + getir.bicimle(parcalar)) if parcalar else "## (Bu soru için parça yok)"
    alanlar = {k: soru[k] for k in ("ders", "konu", "kazanim", "tip", "zorluk", "soru_bicimi", "kok", "secenekler", "dogru",
                                     "aciklama", "kaynaklar", "gecerlilik", "dogrulama") if k in soru}
    return f"{p}\n\n## Denetlenecek soru (JSON)\n{json.dumps(alanlar, ensure_ascii=False, indent=1)}\n\nYalnız JSON döndür."


def json_coz(metin: str):
    """Model çıktısından ilk JSON nesnesini çıkarır; bozuksa None."""
    t = metin.strip()
    t = re.sub(r"^```(?:json)?\s*|\s*```$", "", t)
    i, j = t.find("{"), t.rfind("}")
    if i < 0 or j <= i:
        return None
    parca = t[i:j + 1]
    for deneme in (parca, re.sub(r",\s*([}\]])", r"\1", parca)):
        try:
            return json.loads(deneme)
        except json.JSONDecodeError:
            continue
    return None
