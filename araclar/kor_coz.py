"""Yerel model (Ollama) ile test sorularını cevabı görmeden çözdürür; uyuşmazlıkları işaretler.

Kullanım (proje kökünde):
  python araclar/kor_coz.py kalibrasyon <model> [adet]   # kontrolde (onaylı) YMM sorularında isabet ölçer
  python araclar/kor_coz.py taslak <model>               # taslak YMM test sorularını çözer → content/teslim/ymm_hakem/kor_<model>.jsonl
"""
import glob, json, random, re, sys, time, urllib.request
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
CIKTI = KOK / "content/teslim/ymm_hakem"
CIKTI.mkdir(parents=True, exist_ok=True)


def sorular(durumlar):
    for p in sorted((KOK / "content/sorular/ymm").rglob("*.yaml")):
        for s in yaml.safe_load(p.read_text(encoding="utf-8")) or []:
            if s.get("durum") in durumlar and s.get("secenekler"):
                yield s


def sor(model, s):
    siklar = "\n".join(f"{h}) {v}" for h, v in s["secenekler"].items())
    istem = ("Aşağıdaki Yeminli Mali Müşavirlik (YMM) sınavı sorusunu Türkiye mevzuatına göre çöz. "
             "Önce kısaca düşün, en sonda yalnızca 'CEVAP: <harf>' yaz.\n\n"
             f"SORU:\n{s['kok']}\n\nŞIKLAR:\n{siklar}\n")
    veri = json.dumps({"model": model, "prompt": istem, "stream": False, "think": False,
                       "options": {"temperature": 0, "num_ctx": 4096, "num_predict": 700}}).encode()
    t = time.time()
    yanit = json.loads(urllib.request.urlopen(urllib.request.Request(
        "http://127.0.0.1:11434/api/generate", data=veri, headers={"Content-Type": "application/json"}), timeout=600).read())
    metin = yanit.get("response", "")
    m = re.findall(r"CEVAP\s*[:：]\s*\**\s*([A-E])", metin, re.I)
    return (m[-1].upper() if m else "?"), round(time.time() - t, 1), metin[-300:]


def main():
    mod, model = sys.argv[1], sys.argv[2]
    if mod == "kalibrasyon":
        adet = int(sys.argv[3]) if len(sys.argv) > 3 else 30
        havuz = list(sorular({"kontrolde", "onayli", "yayinda"}))
        random.Random(7).shuffle(havuz)
        liste, dosya = havuz[:adet], CIKTI / f"kalibrasyon_{model.replace(':', '_').replace('/', '_')}.jsonl"
    else:
        liste, dosya = list(sorular({"taslak"})), CIKTI / f"kor_{model.replace(':', '_').replace('/', '_')}.jsonl"
    bitti = set()
    if dosya.exists():
        bitti = {json.loads(l)["id"] for l in dosya.read_text(encoding="utf-8").splitlines() if l.strip()}
    with dosya.open("a", encoding="utf-8") as f:
        for s in liste:
            if s["id"] in bitti:
                continue
            cevap, sure, son = sor(model, s)
            f.write(json.dumps({"id": s["id"], "dogru": s["dogru"], "model": cevap, "tutar": cevap == s["dogru"],
                                "sure": sure, "son": son}, ensure_ascii=False) + "\n")
            f.flush()
    kayit = [json.loads(l) for l in dosya.read_text(encoding="utf-8").splitlines() if l.strip()]
    tut = sum(k["tutar"] for k in kayit)
    print(f"{dosya.name}: {tut}/{len(kayit)} tuttu (%{100 * tut / max(1, len(kayit)):.0f}), "
          f"ort. süre {sum(k['sure'] for k in kayit) / max(1, len(kayit)):.0f} sn")


if __name__ == "__main__":
    main()
