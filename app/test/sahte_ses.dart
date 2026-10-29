import 'package:mevo/bilesenler/sesli_okuma.dart';

/// Konuşma yerine okunan metni kaydeden sahte ses motoru (testler için).
class SahteSes extends SesMotoru {
  final List<String> okunan = [];
  bool _okuyor = false;
  bool turkce;
  int durdurma = 0;

  SahteSes({this.turkce = true});

  @override
  bool get okuyor => _okuyor;

  @override
  bool get turkceVar => turkce;

  @override
  double get hiz => 0.5;

  @override
  Future<void> hazirla() async {}

  @override
  Future<void> oku(String metin) async {
    okunan.add(metin);
    _okuyor = true;
    notifyListeners();
  }

  @override
  Future<void> durdur() async {
    durdurma++;
    _okuyor = false;
    notifyListeners();
  }

  @override
  Future<void> hizSec(double hiz) async {}
}
