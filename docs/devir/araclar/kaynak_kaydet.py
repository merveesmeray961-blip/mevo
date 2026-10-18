"""Yeni indirilen resmî belgeleri content/kaynaklar/mevzuat/KAYNAKLAR.md'ye SHA-256 ile ekler.

    python docs/devir/araclar/kaynak_kaydet.py <liste.tsv> "<bölüm başlığı>"

liste.tsv satırı (sekmeyle ayrılmış): dosya.pdf <TAB> URL <TAB> belge adı <TAB> not
"""
import datetime as dt
import hashlib
import sys
from pathlib import Path

KLASOR = Path(__file__).resolve().parents[3] / "content/kaynaklar/mevzuat"


def main(argv: list[str]) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    liste, baslik = Path(argv[1]), argv[2]
    kayit = KLASOR / "KAYNAKLAR.md"
    icerik = kayit.read_text(encoding="utf-8")
    if f"## {baslik}" in icerik:
        print("bu bölüm zaten var"); return 1
    bugun = dt.date.today().isoformat()
    satirlar = ["", f"## {baslik}", "",
                "| dosya | metin | belge adı | son değişiklik / yürürlük | kaynak URL | SHA-256 | indirme tarihi |",
                "|---|---|---|---|---|---|---|"]
    for s in liste.read_text(encoding="utf-8").splitlines():
        if not s.strip():
            continue
        ad, url, belge, not_ = (s.split("\t") + ["", ""])[:4]
        yol = KLASOR / ad
        sha = hashlib.sha256(yol.read_bytes()).hexdigest()
        txt = yol.with_suffix(".txt")
        metin = f"`{txt.name}`" if txt.exists() else "—"
        satirlar.append(f"| `{ad}` | {metin} | {belge} | {not_} | {url} | `{sha}` | {bugun} |")
    kayit.write_text(icerik.rstrip("\n") + "\n" + "\n".join(satirlar) + "\n", encoding="utf-8", newline="\n")
    print(len(satirlar) - 5, "satır eklendi")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
