"""uretim2 ajan çıktılarını pipeline teslim biçimine birleştirir."""
import sys, glob, yaml, pathlib
kok = pathlib.Path(sys.argv[1]); hedef = pathlib.Path(sys.argv[2]); hedef.mkdir(exist_ok=True)
for sinav, onek in (("smmm", "SMMM_"), ("ymm", "YMM_")):
    t, k = [], []
    for f in sorted(kok.glob(onek + "*/*.yaml")):
        for i, q in enumerate(yaml.safe_load(f.read_text(encoding="utf-8")), 1):
            q["gorev_satiri"] = f"{f.parent.name}/{f.name}#{i}"
            (k if "puanlama" in q else t).append(q)
    meta = {"yazar": "claude-sonnet uretim2", "gorev": "uretim2 2026-11-11"}
    if t: (hedef / f"{sinav}_test.yaml").write_text(yaml.safe_dump({**meta, "sorular": t}, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    if k: (hedef / f"{sinav}_klasik.yaml").write_text(yaml.safe_dump({**meta, "klasik": k}, allow_unicode=True, sort_keys=False, width=120), encoding="utf-8")
    print(sinav, len(t), len(k))
