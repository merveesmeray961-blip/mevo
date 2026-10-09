"""Uygulamaya gömülen soru paketinin sıkıştırılıp karıştırılması (app/lib/veri/paket.dart ile aynı algoritma).

Amaç, APK'yı açan birinin soru bankasını düz JSON olarak kopyalamasını zorlaştırmaktır. Anahtar uygulamanın
içinde olduğu için bu kriptografik bir koruma değil, karartmadır; kodu karıştırılmış (--obfuscate) derlemeyle
birlikte kullanılır.

Biçim: "MVO1" (4 bayt) + 16 bayt tohum + zlib(JSON) ⊕ anahtar akışı.
Anahtar akışı: tohum ve anahtardan FNV-1a ile başlatılan xorshift32; her baytta durumun üst baytı ve anahtarın
sıradaki baytı XOR'lanır. 32 bitlik işlemler hem mobilde hem web derlemesinde aynı sonucu verir.
"""
from __future__ import annotations

import hashlib
import zlib

SIHIR = b"MVO1"
ANAHTAR = bytes.fromhex("0e9d8ef16f1908e98e6775009226ca068b4329124dc0e586416805db49858151")
_M32 = 0xFFFFFFFF


def _fnv1a(veri: bytes) -> int:
    h = 0x811C9DC5
    for b in veri:
        h = ((h ^ b) * 0x01000193) & _M32
    return h or 1


def _karistir(veri: bytes, tohum: bytes) -> bytes:
    x = _fnv1a(ANAHTAR + tohum)
    n = len(ANAHTAR)
    cikti = bytearray(len(veri))
    for i, b in enumerate(veri):
        x ^= (x << 13) & _M32
        x ^= x >> 17
        x ^= (x << 5) & _M32
        cikti[i] = b ^ (x >> 24) ^ ANAHTAR[i % n]
    return bytes(cikti)


def sifrele(veri: bytes) -> bytes:
    # Tohum içerikten türetilir: aynı banka her derlemede aynı paketi üretir (gereksiz git farkı olmaz).
    tohum = hashlib.sha256(veri).digest()[:16]
    return SIHIR + tohum + _karistir(zlib.compress(veri, 9), tohum)


def coz(paket: bytes) -> bytes:
    if paket[:4] != SIHIR:
        raise ValueError("soru paketi tanınmadı")
    tohum = paket[4:20]
    return zlib.decompress(_karistir(paket[20:], tohum))
