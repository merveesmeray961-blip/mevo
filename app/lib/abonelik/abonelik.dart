import 'package:flutter/foundation.dart';

import '../veri/depo.dart';

/// Ücretsiz katman sınırları (PLAN.md §9.1: günlük soru limiti + abonelik).
const ucretsizGunlukSoru = 20;
const ucretsizDeneme = 1;

class AbonelikPaketi {
  final String kimlik;
  final String ad;
  final String aciklama;

  /// Mağazanın yerel para birimiyle gösterdiği fiyat; ödeme altyapısı bağlanmadan önce null.
  final String? fiyat;

  const AbonelikPaketi({required this.kimlik, required this.ad, required this.aciklama, this.fiyat});
}

/// Abonelik durumu ve satın alma. Mağaza bağlantısı (RevenueCat) bu arayüzü uygulayan ayrı bir sınıfla
/// eklenecek; ekranlar yalnızca bu arayüzü bilir.
abstract class AbonelikServisi extends ChangeNotifier {
  bool get premium;
  List<AbonelikPaketi> get paketler;

  /// Gerçek ödeme alınmayan önizleme/test kurulumunda true; ödeme ekranı bunu kullanıcıya söyler.
  bool get onizleme;

  Future<bool> satinAl(AbonelikPaketi paket);
  Future<bool> geriYukle();
}

const varsayilanPaketler = [
  AbonelikPaketi(kimlik: 'donem', ad: 'Sınav dönemi', aciklama: '4 ay sınırsız erişim — bir sınav dönemine yeter'),
  AbonelikPaketi(kimlik: 'aylik', ad: 'Aylık', aciklama: 'Her ay yenilenir, istediğin zaman iptal et'),
];

/// Ödeme altyapısı bağlanana kadar kullanılan önizleme aboneliği: "satın alma" cihazda bir bayrak açar,
/// para çekilmez. Kapalı beta ve önizleme sayfası bununla çalışır.
class OnizlemeAbonelik extends AbonelikServisi {
  static const _anahtar = 'abonelik.onizleme.v1';
  final Depo _depo;
  bool _premium;

  OnizlemeAbonelik(this._depo) : _premium = _depo.oku(_anahtar) == '1';

  @override
  bool get premium => _premium;

  @override
  bool get onizleme => true;

  @override
  List<AbonelikPaketi> get paketler => varsayilanPaketler;

  @override
  Future<bool> satinAl(AbonelikPaketi paket) async {
    _premium = true;
    notifyListeners();
    await _depo.yaz(_anahtar, '1');
    return true;
  }

  @override
  Future<bool> geriYukle() async => _premium;

  Future<void> iptal() async {
    _premium = false;
    notifyListeners();
    await _depo.sil(_anahtar);
  }
}
