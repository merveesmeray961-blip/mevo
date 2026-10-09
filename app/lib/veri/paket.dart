import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Uygulamaya gömülü soru paketini açar (pipeline/paket_sifre.py ile aynı algoritma).
///
/// Paket sıkıştırılmış ve karartılmış JSON'dur: APK'yı açan biri soru bankasını düz metin olarak kopyalayamaz.
/// Anahtar uygulamanın içinde olduğundan bu kriptografik bir koruma değil, karartmadır; kodu karıştırılmış
/// (--obfuscate) derlemeyle birlikte kullanılır.
///
/// Biçim: "MVO1" + 16 bayt tohum + zlib(JSON) ⊕ anahtar akışı (xorshift32). İşlemler 32 bitle sınırlandığı için
/// mobilde ve web derlemesinde aynı sonucu verir.
const _sihir = [0x4D, 0x56, 0x4F, 0x31]; // "MVO1"
const _anahtar = [
  0x0e, 0x9d, 0x8e, 0xf1, 0x6f, 0x19, 0x08, 0xe9, 0x8e, 0x67, 0x75, 0x00, 0x92, 0x26, 0xca, 0x06, //
  0x8b, 0x43, 0x29, 0x12, 0x4d, 0xc0, 0xe5, 0x86, 0x41, 0x68, 0x05, 0xdb, 0x49, 0x85, 0x81, 0x51,
];
const _m32 = 0xFFFFFFFF;

int _fnv1a(List<int> veri) {
  var h = 0x811C9DC5;
  for (final b in veri) {
    h = ((h ^ b) * 0x01000193) & _m32;
  }
  return h == 0 ? 1 : h;
}

/// 32 bitlik çarpma: web derlemesinde sayılar 53 bit hassasiyetli olduğundan çarpım 16 bitlik parçalarla yapılır.
int _carp32(int a, int b) {
  final alt = (a & 0xFFFF) * b;
  final ust = ((a >>> 16) * b) & 0xFFFF;
  return (alt + (ust << 16)) & _m32;
}

int _fnv1aGuvenli(List<int> veri) {
  var h = 0x811C9DC5;
  for (final b in veri) {
    h = _carp32((h ^ b) & _m32, 0x01000193);
  }
  return h == 0 ? 1 : h;
}

Uint8List _karistir(Uint8List veri, List<int> tohum) {
  var x = _fnv1aGuvenli([..._anahtar, ...tohum]);
  final cikti = Uint8List(veri.length);
  for (var i = 0; i < veri.length; i++) {
    x = (x ^ (x << 13)) & _m32;
    x = x ^ (x >>> 17);
    x = (x ^ (x << 5)) & _m32;
    cikti[i] = veri[i] ^ (x >>> 24) ^ _anahtar[i % _anahtar.length];
  }
  return cikti;
}

/// Paketi açıp JSON metnini döndürür; paket tanınmazsa [FormatException] fırlatır.
String paketCoz(Uint8List paket) {
  if (paket.length < 20 || !List.generate(4, (i) => paket[i] == _sihir[i]).every((e) => e)) {
    throw const FormatException('soru paketi tanınmadı');
  }
  final tohum = paket.sublist(4, 20);
  final sikistirilmis = _karistir(Uint8List.sublistView(paket, 20), tohum);
  return utf8.decode(const ZLibDecoder().decodeBytes(sikistirilmis));
}

/// Yalnız test için: VM'de doğrudan çarpımla hesaplanan FNV-1a (web için yazılan sürümle aynı sonucu vermeli).
int fnv1aDogrudan(List<int> veri) => _fnv1a(veri);
int fnv1aParcali(List<int> veri) => _fnv1aGuvenli(veri);
