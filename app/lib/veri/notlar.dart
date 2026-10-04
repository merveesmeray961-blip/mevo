import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'depo.dart';
import 'modeller.dart';

class Not {
  final String metin;
  final DateTime tarih;

  const Not({required this.metin, required this.tarih});
}

/// Sorulara yazılan kişisel notlar: `notlar.v1` anahtarında {soruId: {metin, tarih}}.
/// "İlerlememi sıfırla" notlara dokunmaz; notlar yalnızca [hepsiniSil] ile silinir.
class Notlar extends ChangeNotifier {
  static const _anahtar = 'notlar.v1';

  final Depo _depo;
  final DateTime Function() _simdi;
  final Map<String, Not> _notlar = {};

  Notlar(this._depo, {DateTime Function()? simdi}) : _simdi = simdi ?? DateTime.now {
    final h = _depo.oku(_anahtar);
    if (h == null) return;
    (jsonDecode(h) as Map<String, dynamic>).forEach((id, j) {
      final m = j as Map<String, dynamic>;
      _notlar[id] = Not(metin: m['metin'] as String, tarih: DateTime.parse(m['tarih'] as String));
    });
  }

  Not? not(String soruId) => _notlar[soruId];

  int get sayi => _notlar.length;

  /// [havuz] içinde notu olan sorular, en yeni not başta.
  List<Soru> notluSorular(Iterable<Soru> havuz) {
    final l = [
      for (final s in havuz)
        if (_notlar.containsKey(s.id)) s,
    ];
    l.sort((a, b) => _notlar[b.id]!.tarih.compareTo(_notlar[a.id]!.tarih));
    return l;
  }

  /// Notu kaydeder; metin boşsa notu siler. Metin değişmediyse tarih korunur.
  Future<void> kaydet(String soruId, String metin) async {
    final m = metin.trim();
    if (m.isEmpty) return sil(soruId);
    if (_notlar[soruId]?.metin == m) return;
    _notlar[soruId] = Not(metin: m, tarih: _simdi());
    notifyListeners();
    await _yaz();
  }

  Future<void> sil(String soruId) async {
    if (_notlar.remove(soruId) == null) return;
    notifyListeners();
    await _yaz();
  }

  Future<void> hepsiniSil() async {
    _notlar.clear();
    notifyListeners();
    await _depo.sil(_anahtar);
  }

  Future<void> _yaz() => _depo.yaz(
    _anahtar,
    jsonEncode({
      for (final e in _notlar.entries) e.key: {'metin': e.value.metin, 'tarih': e.value.tarih.toIso8601String()},
    }),
  );
}
