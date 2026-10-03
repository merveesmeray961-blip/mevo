import 'package:shared_preferences/shared_preferences.dart';

/// Cihazdaki anahtar–değer deposu. Testlerde [BellekDepo], uygulamada [CihazDepo] kullanılır.
abstract class Depo {
  String? oku(String anahtar);
  Future<void> yaz(String anahtar, String deger);
  Future<void> sil(String anahtar);
}

class BellekDepo implements Depo {
  final Map<String, String> veri;
  BellekDepo([Map<String, String>? baslangic]) : veri = {...?baslangic};

  @override
  String? oku(String anahtar) => veri[anahtar];

  @override
  Future<void> yaz(String anahtar, String deger) async => veri[anahtar] = deger;

  @override
  Future<void> sil(String anahtar) async => veri.remove(anahtar);
}

class CihazDepo implements Depo {
  final SharedPreferences _p;
  CihazDepo._(this._p);

  static Future<CihazDepo> ac() async => CihazDepo._(await SharedPreferences.getInstance());

  @override
  String? oku(String anahtar) => _p.getString(anahtar);

  @override
  Future<void> yaz(String anahtar, String deger) => _p.setString(anahtar, deger);

  @override
  Future<void> sil(String anahtar) => _p.remove(anahtar);
}
