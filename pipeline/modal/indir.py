"""Model ağırlığını Modal volume'üne CPU konteyneriyle indirir (GPU ücreti yok).

    MODAL_PROFILE=er-merve0614 python pipeline/modal/indir.py [Qwen/Qwen3-235B-A22B-Thinking-2507-FP8] [tarih-en-hf]
"""
import sys

import modal

MODEL = sys.argv[1] if len(sys.argv) > 1 else "Qwen/Qwen3-235B-A22B-Thinking-2507-FP8"
VOL = sys.argv[2] if len(sys.argv) > 2 else "tarih-en-hf"
app = modal.App("mevo-indir")
vol = modal.Volume.from_name(VOL, create_if_missing=True)
img = modal.Image.debian_slim(python_version="3.12").uv_pip_install("huggingface_hub[hf_xet]").env({"HF_HOME": "/hf"})


@app.function(image=img, volumes={"/hf": vol}, cpu=4, memory=8192, timeout=3 * 3600)
def indir(model: str) -> str:
    import os
    import time
    from huggingface_hub import snapshot_download
    t0 = time.time()
    yol = snapshot_download(model, max_workers=16)
    vol.commit()
    boyut = sum(os.path.getsize(os.path.join(d, f)) for d, _, fs in os.walk(yol, followlinks=True) for f in fs)
    return f"{model} → {yol} ({boyut / 1e9:.1f} GB, {time.time() - t0:.0f} sn)"


if __name__ == "__main__":
    with modal.enable_output(), app.run():
        print(indir.remote(MODEL), flush=True)
