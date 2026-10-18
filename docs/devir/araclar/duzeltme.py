"""Bulgulu soruların düzeltme turu: girdi paketleri ve kararların uygulanması.

    python docs/devir/araclar/duzeltme.py girdi <bulgu.json> <cikti_klasoru> [--parti 40] [--kural R4,R5]
        Her ders için en çok --parti soruluk JSON dosyaları yazar: id, kök, şıklar, doğru, açıklama, kaynaklar, bulgular.
        Ajan yalnız bu dosyayı okur (bankanın tamamını okumaz).

    python docs/devir/araclar/duzeltme.py uygula <karar.json> [<karar2.json> …]
        Karar biçimi: {"<id>": {"islem": "duzelt"|"cek"|"dokunma", "kok"?, "secenekler"?, "dogru"?,
                                "aciklama"?, "neden": "..."}}
        duzelt → verilen alanlar yazılır, G5 notu ve geçmiş kaydı eklenir; cek → geri_cekildi; dokunma → yalnız not.
"""
from __future__ import annotations

import collections
import copy
import datetime as dt
import json
import sys
from pathlib import Path

KOK = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(KOK))

import yaml  # noqa: E402

from pipeline import g2_yapi  # noqa: E402

ALANLAR = ("id", "ders", "konu", "kazanim", "tip", "zorluk", "kok", "secenekler", "dogru", "aciklama", "kaynaklar")
BUGUN = dt.date.today().isoformat()


def _banka() -> list[tuple[str, dict]]:
    return [x for sinav in ("smmm", "ymm") for x in g2_yapi.dosyalari_yukle(KOK / "content/sorular" / sinav)]


def girdi(bulgu_yolu: Path, cikti: Path, parti: int, kurallar: set[str] | None) -> None:
    bulgu = json.loads(bulgu_yolu.read_text(encoding="utf-8"))
    if kurallar:
        bulgu = {i: [x for x in h if x[:2] in kurallar] for i, h in bulgu.items()}
        bulgu = {i: h for i, h in bulgu.items() if h}
    gruplar: dict[str, list[dict]] = collections.defaultdict(list)
    for _, s in _banka():
        if s["id"] in bulgu and s.get("durum") == "kontrolde":
            kayit = {k: s[k] for k in ALANLAR if k in s}
            kayit["bulgular"] = bulgu[s["id"]]
            gruplar["-".join(s["id"].split("-")[:2])].append(kayit)
    cikti.mkdir(parents=True, exist_ok=True)
    for ders, liste in sorted(gruplar.items()):
        for n in range(0, len(liste), parti):
            yol = cikti / f"{ders}_{n // parti + 1:02d}.json"
            yol.write_text(json.dumps(liste[n:n + parti], ensure_ascii=False, indent=1), encoding="utf-8")
            print(yol.name, len(liste[n:n + parti]))


def uygula(karar_yollari: list[Path]) -> None:
    karar: dict[str, dict] = {}
    for y in karar_yollari:
        karar.update(json.loads(y.read_text(encoding="utf-8")))
    sayac = collections.Counter()
    reddedilen: dict[str, dict] = {}
    for sinav in ("smmm", "ymm"):
        for yol in sorted((KOK / "content/sorular" / sinav).rglob("*.yaml")):
            icerik = yaml.safe_load(yol.read_text(encoding="utf-8"))
            liste = icerik if isinstance(icerik, list) else [icerik]
            degisti = False
            for s in liste:
                k = karar.get(s.get("id"))
                if not k or s.get("durum") != "kontrolde":
                    continue
                islem, neden = k.get("islem"), k.get("neden", "")
                kapilar = s.setdefault("uretim", {}).setdefault("kapilar", {})
                if islem == "duzelt":
                    yeni = copy.deepcopy(s)
                    for alan in ("kok", "secenekler", "dogru", "kaynaklar"):
                        if alan in k:
                            yeni[alan] = k[alan]
                    if isinstance(k.get("aciklama"), dict):  # açıklama birleştirilir: verilmeyen alt alanlar korunur
                        aciklama = dict(yeni.get("aciklama") or {})
                        for alt, deger in k["aciklama"].items():
                            if isinstance(deger, dict) and isinstance(aciklama.get(alt), dict):
                                aciklama[alt] = {**aciklama[alt], **deger}
                            else:
                                aciklama[alt] = deger
                        aciklama["celdiriciler"] = {h: v for h, v in (aciklama.get("celdiriciler") or {}).items()
                                                    if h != yeni.get("dogru")}
                        yeni["aciklama"] = aciklama
                    # Düzeltme yeni bir yapı hatası getiriyorsa uygulanmaz; soru eski hâliyle kalır.
                    eski_hata = set(g2_yapi.soru_denetle(s).hatalar)
                    yeni_hata = [h for h in g2_yapi.soru_denetle(yeni).hatalar if h not in eski_hata]
                    if yeni_hata:
                        reddedilen[s["id"]] = {"karar": k, "g2": yeni_hata}
                        sayac["reddedildi"] += 1
                        continue
                    s.clear()
                    s.update(yeni)
                    kapilar = s.setdefault("uretim", {}).setdefault("kapilar", {})
                    s["surum"] = int(s.get("surum") or 1) + 1
                    kapilar["G5"] = {"sonuc": "gecti", "tarih": BUGUN, "not": f"düzeltme turu: {neden}"[:400]}
                    s.setdefault("gecmis", []).append({"tarih": BUGUN, "kim": "hakem", "ne": "düzeltildi", "neden": neden})
                elif islem == "cek":
                    s["durum"] = "geri_cekildi"
                    kapilar["G5"] = {"sonuc": "kaldi", "tarih": BUGUN, "not": neden[:400]}
                    s.setdefault("gecmis", []).append({"tarih": BUGUN, "kim": "hakem", "ne": "durum: kontrolde → geri_cekildi", "neden": neden})
                else:
                    islem = "dokunma"
                sayac[islem] += 1
                degisti = degisti or islem != "dokunma"
            if degisti:
                veri = liste if isinstance(icerik, list) else liste[0]
                yol.write_text(yaml.safe_dump(veri, allow_unicode=True, sort_keys=False, width=110), encoding="utf-8")
    print(dict(sayac), f"karar sayısı {len(karar)}")
    if reddedilen:
        yol = karar_yollari[0].with_name(karar_yollari[0].stem + ".reddedilen.json")
        yol.write_text(json.dumps(reddedilen, ensure_ascii=False, indent=1), encoding="utf-8")
        print("G2'den geçmeyen düzeltmeler:", yol)


def main(argv: list[str]) -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    if len(argv) >= 4 and argv[1] == "girdi":
        parti = int(argv[argv.index("--parti") + 1]) if "--parti" in argv else 40
        kurallar = set(argv[argv.index("--kural") + 1].split(",")) if "--kural" in argv else None
        girdi(Path(argv[2]), Path(argv[3]), parti, kurallar)
        return 0
    if len(argv) >= 3 and argv[1] == "uygula":
        uygula([Path(a) for a in argv[2:]])
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
