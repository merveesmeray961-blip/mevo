"""(1) KGK 19.10.2026 güncellik notunu 3 soruya ekler. (2) Kalıp (tekrar eden) çeldirici açıklamalarını sayar.
Kullanım: python araclar/kalip_tara.py [--yaz]"""
import collections, json, sys
from pathlib import Path
import yaml

KOK = Path(__file__).resolve().parents[1]
YAZ = "--yaz" in sys.argv
NOT = (" Güncellik notu: KGK'nın 19/10/2026 tarihli kararıyla E4 (sonradan raporlama) muafiyeti tüm işletmelerin "
       "2026 yılı raporlama dönemi için de, E5 (yalnız iklim) muafiyeti ise önceki dönemlerde bu muafiyetten "
       "yararlananlar için 2026 dönemi için de geçerli kılınmıştır.")
HEDEF = {"SMMM-STD-KRL-0013", "SMMM-STD-KRL-0014", "YMM-IFM-TAB-0014"}
say = collections.Counter(); ornek = {}; soru_say = collections.defaultdict(set); toplam = 0
for p in sorted((KOK / "content/sorular").rglob("*.yaml")):
    liste = yaml.safe_load(p.read_text(encoding="utf-8")) or []
    degisti = False
    for s in liste:
        if s.get("durum") == "geri_cekildi":
            continue
        a = s.get("aciklama")
        if s["id"] in HEDEF and isinstance(a, dict) and "19/10/2026" not in a.get("dogru_neden", ""):
            a["dogru_neden"] = a["dogru_neden"].split("\n\nPüf")[0] + NOT + ("\n\nPüf" + a["dogru_neden"].split("\n\nPüf", 1)[1] if "\n\nPüf" in a["dogru_neden"] else "")
            s.setdefault("gecmis", []).append({"tarih": "2026-11-11", "kim": "asistan", "ne": "KGK 19.10.2026 güncellik notu eklendi"})
            degisti = True
        if isinstance(a, dict):
            for h, t in (a.get("celdiriciler") or {}).items():
                t = (t or "").strip()
                if t:
                    toplam += 1; say[t] += 1; ornek.setdefault(t, s["id"]); soru_say[t].add(s["id"])
    if degisti and YAZ:
        p.write_text(yaml.safe_dump(liste, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
kalip = {t: n for t, n in say.items() if n >= 3}
etkilenen = set().union(*[soru_say[t] for t in kalip]) if kalip else set()
print(f"çeldirici açıklaması: {toplam}, kalıp metin (>=3 tekrar): {len(kalip)}, kalıp kullanılan açıklama: {sum(kalip.values())}, etkilenen soru: {len(etkilenen)}")
for t, n in sorted(kalip.items(), key=lambda x: -x[1])[:15]:
    print(f"{n:4d} | {t[:120]}")
(KOK / "content/teslim/kalip_celdirici.json").write_text(json.dumps(sorted(etkilenen), ensure_ascii=False), encoding="utf-8")
