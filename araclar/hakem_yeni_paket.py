"""11.11.2026 uretim2 teslimindeki taslak soruları TAM hakem incelemesi için paketler.
Çıktı: content/teslim/u1111_hakem/paket/{smmm_test,ymm_test,ymm_klasik}_NN.json"""
import json, sys, yaml
from pathlib import Path
KOK = Path(__file__).resolve().parents[1]
P = KOK / "content/teslim/u1111_hakem/paket"; P.mkdir(parents=True, exist_ok=True)
def yeni(s):
    return s.get("durum") == "taslak" and any("u1111" in str(g.get("ne", "")) or "_test.yaml, satır" in str(g.get("ne", "")) and g.get("tarih") == "2026-11-11" or "ymm_klasik" in str(g.get("ne", "")) and g.get("tarih") == "2026-11-11" for g in s.get("gecmis") or [])
TEST = ("id", "ders", "konu", "kazanim", "tip", "zorluk", "kok", "secenekler", "dogru", "aciklama", "kaynaklar", "gecerlilik", "dogrulama")
KLS = ("id", "ders", "konu", "puan", "soru", "cozum", "puanlama", "kaynaklar", "gecerlilik", "dogrulama")
say = {}
for ad, klasor, alan, boy in (("smmm_test", "content/sorular/smmm", TEST, 25), ("ymm_test", "content/sorular/ymm", TEST, 25), ("ymm_klasik", "content/klasik/ymm", KLS, 8)):
    liste = [{k: s.get(k) for k in alan} for p in sorted((KOK / klasor).rglob("*.yaml")) for s in (yaml.safe_load(p.read_text(encoding="utf-8")) or []) if yeni(s)]
    for i in range(0, len(liste), boy):
        (P / f"{ad}_{i // boy + 1:02d}.json").write_text(json.dumps(liste[i:i + boy], ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    say[ad] = len(liste)
print(say)
