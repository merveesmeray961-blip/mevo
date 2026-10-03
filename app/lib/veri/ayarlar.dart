import 'dart:convert';

import 'package:flutter/material.dart';

import 'depo.dart';

class Ayarlar extends ChangeNotifier {
  static const _anahtar = 'ayarlar.v1';
  final Depo _depo;

  String? _bolum;
  ThemeMode _tema = ThemeMode.system;
  int _oturumBoyu = 10;

  Ayarlar(this._depo) {
    final s = _depo.oku(_anahtar);
    if (s == null) return;
    final j = jsonDecode(s) as Map<String, dynamic>;
    _bolum = j['bolum'] as String?;
    _tema = ThemeMode.values.firstWhere((t) => t.name == j['tema'], orElse: () => ThemeMode.system);
    _oturumBoyu = (j['oturum'] ?? 10) as int;
  }

  /// Kullanıcının hazırlandığı bölüm: 'SGS' veya 'YET'. İlk açılışta null (bölüm seçimi gösterilir).
  String? get bolum => _bolum;
  ThemeMode get tema => _tema;
  int get oturumBoyu => _oturumBoyu;

  Future<void> bolumSec(String b) => _guncelle(() => _bolum = b);
  Future<void> temaSec(ThemeMode t) => _guncelle(() => _tema = t);
  Future<void> oturumBoyuSec(int n) => _guncelle(() => _oturumBoyu = n);

  Future<void> _guncelle(void Function() f) async {
    f();
    notifyListeners();
    await _depo.yaz(_anahtar, jsonEncode({'bolum': _bolum, 'tema': _tema.name, 'oturum': _oturumBoyu}));
  }
}
