import 'dart:convert';

import 'package:flutter/material.dart';

import 'depo.dart';

/// Yazı boyutu seçenekleri (Küçük, Orta, Büyük); varsayılan Orta.
const yaziSecenekleri = {'Küçük': 0.84, 'Orta': 0.92, 'Büyük': 1.0};
const yaziVarsayilan = 0.92;

class Ayarlar extends ChangeNotifier {
  static const _anahtar = 'ayarlar.v1';
  final Depo _depo;

  String? _bolum;
  ThemeMode _tema = ThemeMode.system;
  int _oturumBoyu = 10;
  double _yazi = yaziVarsayilan;

  Ayarlar(this._depo) {
    final s = _depo.oku(_anahtar);
    if (s == null) return;
    final j = jsonDecode(s) as Map<String, dynamic>;
    _bolum = j['bolum'] as String?;
    _tema = ThemeMode.values.firstWhere((t) => t.name == j['tema'], orElse: () => ThemeMode.system);
    _oturumBoyu = (j['oturum'] ?? 10) as int;
    _yazi = ((j['yazi'] ?? yaziVarsayilan) as num).toDouble();
  }

  /// Kullanıcının hazırlandığı bölüm: 'SGS' veya 'YET'. İlk açılışta null (bölüm seçimi gösterilir).
  String? get bolum => _bolum;
  ThemeMode get tema => _tema;
  int get oturumBoyu => _oturumBoyu;

  /// Uygulama içi yazı boyutu çarpanı; telefonun kendi yazı boyutu ayarıyla çarpılır.
  double get yazi => _yazi;

  Future<void> bolumSec(String b) => _guncelle(() => _bolum = b);
  Future<void> temaSec(ThemeMode t) => _guncelle(() => _tema = t);
  Future<void> oturumBoyuSec(int n) => _guncelle(() => _oturumBoyu = n);
  Future<void> yaziSec(double x) => _guncelle(() => _yazi = x);

  Future<void> _guncelle(void Function() f) async {
    f();
    notifyListeners();
    await _depo.yaz(_anahtar, jsonEncode({'bolum': _bolum, 'tema': _tema.name, 'oturum': _oturumBoyu, 'yazi': _yazi}));
  }
}
