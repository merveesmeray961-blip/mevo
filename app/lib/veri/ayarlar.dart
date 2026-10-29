import 'dart:convert';

import 'package:flutter/material.dart';

import 'depo.dart';

/// Yazı boyutu seçenekleri; varsayılan Normal (telefonun kendi yazı boyutu). Uzun süre mevzuat metni okuyan
/// kullanıcı için büyütme seçenekleri sistem boyutunun üstüne çıkar.
const yaziSecenekleri = {'Küçük': 0.92, 'Normal': 1.0, 'Büyük': 1.15, 'En büyük': 1.3};
const yaziVarsayilan = 1.0;

/// Sesli okuma hızı seçenekleri (flutter_tts ölçeğinde 0.5 ≈ normal konuşma hızı).
const sesHizlari = {'Yavaş': 0.4, 'Normal': 0.5, 'Hızlı': 0.6};
const sesHiziVarsayilan = 0.5;

class Ayarlar extends ChangeNotifier {
  static const _anahtar = 'ayarlar.v1';
  final Depo _depo;

  String? _bolum;
  ThemeMode _tema = ThemeMode.system;
  int _oturumBoyu = 10;
  double _yazi = yaziVarsayilan;
  double _sesHizi = sesHiziVarsayilan;

  Ayarlar(this._depo) {
    final s = _depo.oku(_anahtar);
    if (s == null) return;
    final j = jsonDecode(s) as Map<String, dynamic>;
    _bolum = j['bolum'] as String?;
    _tema = ThemeMode.values.firstWhere((t) => t.name == j['tema'], orElse: () => ThemeMode.system);
    _oturumBoyu = (j['oturum'] ?? 10) as int;
    _yazi = ((j['yazi'] ?? yaziVarsayilan) as num).toDouble();
    _sesHizi = ((j['sesHizi'] ?? sesHiziVarsayilan) as num).toDouble();
    if (!sesHizlari.containsValue(_sesHizi)) _sesHizi = sesHiziVarsayilan;
    // Eski sürümün ölçeği (0.84/0.92/1.0) yeni ölçeğe taşınır; eski varsayılan 0.92 artık Normal'dir.
    if (j['yaziSurum'] != 2) {
      _yazi = switch (_yazi) {
        0.84 => 0.92,
        0.92 => 1.0,
        1.0 => 1.15,
        _ => yaziVarsayilan,
      };
    }
    if (!yaziSecenekleri.containsValue(_yazi)) _yazi = yaziVarsayilan;
  }

  /// Kullanıcının hazırlandığı bölüm: 'SGS', 'YET' veya 'YMM'. İlk açılışta null (bölüm seçimi gösterilir).
  String? get bolum => _bolum;
  ThemeMode get tema => _tema;
  int get oturumBoyu => _oturumBoyu;

  /// Uygulama içi yazı boyutu çarpanı; telefonun kendi yazı boyutu ayarıyla çarpılır.
  double get yazi => _yazi;

  Future<void> bolumSec(String b) => _guncelle(() => _bolum = b);
  Future<void> temaSec(ThemeMode t) => _guncelle(() => _tema = t);
  Future<void> oturumBoyuSec(int n) => _guncelle(() => _oturumBoyu = n);
  Future<void> yaziSec(double x) => _guncelle(() => _yazi = x);

  /// Sesli okuma hızı ([sesHizlari] değerlerinden biri; flutter_tts ölçeği).
  double get sesHizi => _sesHizi;
  Future<void> sesHiziSec(double x) => _guncelle(() => _sesHizi = x);

  Future<void> _guncelle(void Function() f) async {
    f();
    notifyListeners();
    await _depo.yaz(
      _anahtar,
      jsonEncode({
        'bolum': _bolum,
        'tema': _tema.name,
        'oturum': _oturumBoyu,
        'yazi': _yazi,
        'yaziSurum': 2,
        'sesHizi': _sesHizi,
      }),
    );
  }
}
