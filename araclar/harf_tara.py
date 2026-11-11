"""Açıklamada doğru şıktan farklı bir harfe 'doğru/yanlış/cevap/şık' diye gönderme yapan soruları bulur
(şık sırası değiştirilip açıklamadaki harf güncellenmemiş olabilir). Çıktı: _xfer/harf_supheli.json"""
import json, re, sys
from pathlib import Path
KOK = Path(__file__).resolve().parents[1]
DESEN = re.compile(r"(?<![\w'’(])([A-E])(?:\s+(?:şıkk|seçene|cümle|ifade)\w*|\s+(?:doğrudur|yanlıştır|doğru|yanlış)\b)"
                   r"|(?:[Dd]oğru\s+(?:cevap|şık|seçenek)|[Cc]evap)\s*(?:[:(]|olarak|ise)?\s*([A-E])\b")
out = []
for urun in ("smmm", "ymm"):
    for s in json.loads((KOK / f"app/assets/sorular/{urun}.json").read_text(encoding="utf-8"))["sorular"]:
        a = s.get("aciklama") or {}
        metin = a.get("dogru_neden", "") if isinstance(a, dict) else str(a)
        harfler = {m.group(1) or m.group(2) for m in DESEN.finditer(metin)}
        harfler = {h.upper() for h in harfler if h}
        if harfler - {s["dogru"]}:
            out.append({"id": s["id"], "dogru": s["dogru"], "anilan": sorted(harfler), "metin": metin[:400]})
(KOK / "_xfer/harf_supheli.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")
print(len(out))
