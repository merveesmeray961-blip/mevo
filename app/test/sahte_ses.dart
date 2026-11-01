import 'package:mevo/bilesenler/sesli_okuma.dart';

/// Konuşma yerine okunan metni kaydeden sahte ses motoru (testler için).
class SahteSes extends SesMotoru {
  final List<String> okunan = [];
  bool _okuyor = false;
  bool _duraklatildi = false;
  String? _kaynak;
  bool turkce;
  int durdurma = 0;

  SahteSes({this.turkce = true});

  @override
  bool get okuyor => _okuyor;

  @override
  bool get duraklatildi => _duraklatildi;

  @override
  String? get kaynak => _kaynak;

  @override
  List<String> get cumleler => _okuyor ? okunan.last.split('\n') : const [];

  @override
  bool get turkceVar => turkce;

  @override
  double get hiz => 0.5;

  @override
  Future<void> hazirla() async {}

  @override
  Future<void> oku(String metin, {String? kaynak, int baslangic = 0}) async {
    okunan.add(metin);
    _kaynak = kaynak;
    _okuyor = true;
    _duraklatildi = false;
    notifyListeners();
  }

  @override
  Future<void> duraklat() async {
    _duraklatildi = true;
    notifyListeners();
  }

  @override
  Future<void> devam() async {
    _duraklatildi = false;
    notifyListeners();
  }

  @override
  Future<void> durdur() async {
    durdurma++;
    _okuyor = false;
    _duraklatildi = false;
    _kaynak = null;
    notifyListeners();
  }

  @override
  Future<void> hizSec(double hiz) async {}
}
