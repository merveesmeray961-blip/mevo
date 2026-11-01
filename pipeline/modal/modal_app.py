"""Mizan/Tasdik soru üretim hattı — Modal tarafı (Qwen3-235B-A22B Instruct / Thinking 2507 FP8, vLLM).

Model ağırlıkları `tarih-en-hf` volume'ünden YALNIZ OKUNARAK kullanılır (read_only). Bu dosya kendi başına
yüklenir (pipeline paketine bağımlı değildir); yerel hat `pipeline/modal/hat.py` bunu `app.run()` ile açar,
tüm aşamaları tek konteyner oturumunda bitirir ve çıkınca uygulama kapanır (boşta ücret yazmaz).
"""
import modal

app = modal.App("mevo-soru")
hf_vol = modal.Volume.from_name("tarih-en-hf").read_only()
HF = "/hf"
MODEL = "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8"
MODEL_DUSUNEN = "Qwen/Qwen3-235B-A22B-Thinking-2507-FP8"

# tarih-en projesindeki llm_img ile birebir aynı tanım (önbellekteki imaj yeniden kullanılır)
llm_img = (
    modal.Image.from_registry("nvidia/cuda:13.0.1-devel-ubuntu24.04", add_python="3.12")
    .entrypoint([])
    .uv_pip_install("vllm", "huggingface_hub")
    .env({"HF_HOME": HF, "VLLM_LOGGING_LEVEL": "WARNING", "CUDA_HOME": "/usr/local/cuda"})
)
soru_img = llm_img.env({"VLLM_CACHE_ROOT": "/tmp/vllm_cache", "FLASHINFER_WORKSPACE_BASE": "/tmp/flashinfer",
                        "HF_HUB_OFFLINE": "1"})

GPU = ["B200:2", "H200:2"]


class _Taban:
    MODEL = MODEL
    BELLEK = 0.90

    def _yukle(self):
        import time
        import torch
        from vllm import LLM
        t0 = time.time()
        n = torch.cuda.device_count()
        self.gpu = f"{n}x {torch.cuda.get_device_name(0)}"
        print(f"[USTA] {self.gpu} {self.MODEL}", flush=True)
        self.llm = LLM(model=self.MODEL, tensor_parallel_size=n, max_model_len=32768, gpu_memory_utilization=self.BELLEK,
                       enable_prefix_caching=True)
        self.yukleme_sn = time.time() - t0
        print(f"[USTA] yüklendi {self.yukleme_sn:.0f} sn", flush=True)

    def _bilgi(self) -> dict:
        return {"gpu": self.gpu, "yukleme_sn": self.yukleme_sn, "model": self.MODEL}

    def _uret(self, istekler: list) -> dict:
        """istekler: [{system, user, max_tokens, temperature, seed, top_p?, top_k?}] → {metinler, sure_sn, girdi_tok, cikti_tok}."""
        import time
        from vllm import SamplingParams
        t0 = time.time()
        mesajlar = [[{"role": "system", "content": i["system"]}, {"role": "user", "content": i["user"]}]
                    for i in istekler]
        params = []
        for i in istekler:
            sic = i.get("temperature", 0.7)
            params.append(SamplingParams(temperature=sic, top_p=i.get("top_p", 0.9 if sic > 0 else 1.0),
                                         top_k=i.get("top_k", -1), max_tokens=i.get("max_tokens", 4096), seed=i.get("seed")))
        cikti = self.llm.chat(mesajlar, sampling_params=params, use_tqdm=False)
        return {"metinler": [c.outputs[0].text for c in cikti], "sure_sn": time.time() - t0,
                "girdi_tok": sum(len(c.prompt_token_ids or []) for c in cikti),
                "cikti_tok": sum(len(c.outputs[0].token_ids) for c in cikti),
                "bitis": [c.outputs[0].finish_reason for c in cikti]}


@app.cls(image=soru_img, gpu=GPU, volumes={HF: hf_vol}, timeout=3600, scaledown_window=120, max_containers=1)
class Usta(_Taban):
    @modal.enter()
    def yukle(self):
        self._yukle()

    @modal.method()
    def bilgi(self) -> dict:
        return self._bilgi()

    @modal.method()
    def uret(self, istekler: list) -> dict:
        return self._uret(istekler)


# Akıl yürüten model (türev hattı: üretim + kör çözücü + hakem). Ağırlıklar aynı volume'e pipeline/modal/indir.py ile indirilir.
# B200 önce: 2x H200'de ağırlıklardan sonra KV önbelleğine ~25-30 GB kalır (uzun düşünme çıktılarında eşzamanlılık
# 5-8 diziye düşer); 2x B200'de ~90 GB kalır, aynı iş daha kısa sürede ve toplamda daha ucuza biter.
# timeout: her uret() çağrısı için üst sınır; bütçe koruması yerelde (turev.py) yapılır.
@app.cls(image=soru_img, gpu=["B200:2", "H200:2"], volumes={HF: hf_vol}, timeout=1800, scaledown_window=60,
         max_containers=1)
class Dusunen(_Taban):
    MODEL = MODEL_DUSUNEN
    BELLEK = 0.94

    @modal.enter()
    def yukle(self):
        self._yukle()

    @modal.method()
    def bilgi(self) -> dict:
        return self._bilgi()

    @modal.method()
    def uret(self, istekler: list) -> dict:
        return self._uret(istekler)
