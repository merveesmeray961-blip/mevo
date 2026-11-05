"""Taslak YMM sorularına ek otomatik kontroller (bedava katman). Hakeme gidecek şüpheli soruları işaretler.

Çıktı: content/teslim/ymm_hakem/ek_kontrol.json  →  {id: [neden, ...]}
"""
import json, re
from collections import Counter
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
CIKTI = KOK / "content/teslim/ymm_hakem"
CIKTI.mkdir(parents=True, exist_ok=True)
MEVZUAT = {p.stem: p.read_text(encoding="utf-8", errors="ignore") for p in (KOK / "content/kaynaklar/mevzuat").glob("*.txt")}


def norm(t):
    t = str(t).replace("İ", "i").replace("I", "ı").lower()
    return re.sub(r"[^0-9a-zçğıöşüâîû]", "", t)


NORM = {k: norm(v) for k, v in MEVZUAT.items()}


def alinti_mulga_mi(alinti):
    """Alıntının geçtiği yerden önceki 400 karakterde 'mülga' veya 'yürürlükten kaldırıl' var mı?"""
    n = norm(alinti)[:60]
    if len(n) < 15:
        return False
    for k, v in MEVZUAT.items():
        i = NORM[k].find(n)
        if i >= 0:
            # Normalleştirilmiş konumu ham metne yaklaşık oranla eşle
            j = int(i / max(1, len(NORM[k])) * len(v))
            on = v[max(0, j - 1500):j + 20]
            # Yalnız alıntının içinde bulunduğu maddeye bak: son "Madde N" başlığından sonrası
            bas = max(on.rfind("Madde "), on.rfind("MADDE "))
            on = (on[bas:] if bas >= 0 else on[-300:]).lower()
            return bool(re.search(r"\(mülga|mülga\s*:|yürürlükten kaldırılmıştır", on))
    return False


def sayilar(t):
    return [float(x.replace(".", "").replace(",", ".")) for x in re.findall(r"-?\d{1,3}(?:\.\d{3})+(?:,\d+)?|-?\d+(?:,\d+)?", str(t))]


isaret = {}


def ekle(i, neden):
    isaret.setdefault(i, []).append(neden)


test_say = klasik_say = 0
harf = Counter()
for p in sorted((KOK / "content/sorular/ymm").rglob("*.yaml")):
    for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        if s.get("durum") != "taslak":
            continue
        test_say += 1
        sik = s.get("secenekler") or {}
        harf[s.get("dogru")] += 1
        degerler = [norm(v) for v in sik.values()]
        if len(set(degerler)) < len(degerler):
            ekle(s["id"], "aynı içerikli iki şık")
        say = [sayilar(v) for v in sik.values()]
        if all(len(x) == 1 for x in say) and len(say) == 5:
            seri = [x[0] for x in say]
            if seri != sorted(seri):
                ekle(s["id"], "sayısal şıklar sıralı değil")
        g = s.get("gecerlilik") or {}
        if g.get("yila_bagli_tutar") and str(g.get("yil")) not in ("2026", "2027"):
            ekle(s["id"], f"yıla bağlı tutar, yıl {g.get('yil')}")
        for k in s.get("kaynaklar") or []:
            if alinti_mulga_mi(k.get("alinti") or ""):
                ekle(s["id"], f"alıntı mülga/kaldırılmış madde yakınında ({k.get('madde')})")
        if re.search(r"\b(her ikisi|hepsi|hiçbiri)\b", " ".join(sik.values()), re.I):
            ekle(s["id"], "'hepsi/hiçbiri' tipi şık")

for p in sorted((KOK / "content/klasik/ymm").rglob("*.yaml")):
    for k in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
        if k.get("durum") != "taslak":
            continue
        klasik_say += 1
        g = k.get("gecerlilik") or {}
        if g.get("yila_bagli_tutar") and str(g.get("yil")) not in ("2026", "2027"):
            ekle(k["id"], f"yıla bağlı tutar, yıl {g.get('yil')}")
        for kk in k.get("kaynaklar") or []:
            if alinti_mulga_mi(kk.get("alinti") or ""):
                ekle(k["id"], f"alıntı mülga/kaldırılmış madde yakınında ({kk.get('madde')})")
        istek = len(set(re.findall(r"(?m)^\s*\**\s*\(?([a-g])\)\s", k.get("soru", ""))))
        if istek and len(k.get("puanlama") or []) < istek:
            ekle(k["id"], f"{istek} istek var, {len(k.get('puanlama') or [])} puan ölçütü")
        if len(str(k.get("cozum", ""))) < 400:
            ekle(k["id"], "örnek çözüm çok kısa")

(CIKTI / "ek_kontrol.json").write_text(json.dumps(isaret, ensure_ascii=False, indent=1), encoding="utf-8")
print(f"taslak test {test_say}, klasik {klasik_say}; işaretlenen {len(isaret)}")
print("neden dağılımı:", Counter(n.split(" (")[0].split(",")[0] for v in isaret.values() for n in v).most_common())
print("doğru harf dağılımı (test):", dict(harf))
