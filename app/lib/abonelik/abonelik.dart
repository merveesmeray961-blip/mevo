import 'package:flutter/foundation.dart';

import '../veri/depo.dart';

/// Ücretsiz katman sınırları (PLAN.md §9.1: günlük soru limiti + tek seferlik tam erişim).
const ucretsizGunlukSoru = 20;
const ucretsizDeneme = 1;

/// Mağazada (Google Play / App Store) tanımlanacak tek seferlik ürünün kimliği.
const tamErisimKimligi = 'tam_erisim';

class AbonelikPaketi {
  final String kimlik;
  final String ad;
  final String aciklama;

  /// Mağazanın yerel para birimiyle gösterdiği fiyat; mağazadan alınamadıysa null.
  final String? fiyat;

  const AbonelikPaketi({required this.kimlik, required this.ad, required this.aciklama, this.fiyat});
}

/// Mağaza bağlantısının durumu (ödeme ekranı buna göre çizilir).
enum MagazaDurumu {
  /// Mağazaya soruluyor.
  yukleniyor,

  /// Ürün bulundu, satın alınabilir.
  hazir,

  /// Mağaza servisi bu cihazda kullanılamıyor (Play Store yok, çevrimdışı, ebeveyn kısıtı vb.).
  kullanilamiyor,

  /// Mağaza yanıt verdi ama `tam_erisim` ürünü tanımlı/yayında değil.
  urunYok,
}

/// Son satın alma girişiminin durumu.
enum IslemDurumu {
  bos,

  /// Mağaza ekranı açık veya onay bekleniyor.
  suruyor,

  /// Ödeme beklemede (ör. aile onayı, nakit ödeme); tamamlanınca premium kendiliğinden açılır.
  beklemede,

  /// Kullanıcı vazgeçti.
  iptal,

  /// Mağaza hata döndürdü; ayrıntı [AbonelikServisi.hata] içinde.
  hata,
}

/// Tam erişim durumu ve satın alma. Ekranlar yalnızca bu arayüzü bilir.
abstract class AbonelikServisi extends ChangeNotifier {
  bool get premium;
  List<AbonelikPaketi> get paketler;

  /// Gerçek ödeme alınmayan önizleme/test kurulumunda true; ödeme ekranı bunu kullanıcıya söyler.
  bool get onizleme;

  MagazaDurumu get magaza => MagazaDurumu.hazir;
  IslemDurumu get islem => IslemDurumu.bos;
  String? get hata => null;

  /// Mağaza bağlantısını kurar ve ürünü sorgular; ödeme ekranındaki "Yeniden dene" de bunu çağırır.
  Future<void> baslat() async {}

  Future<bool> satinAl(AbonelikPaketi paket);
  Future<bool> geriYukle();
}

const tamErisimPaketi = AbonelikPaketi(
  kimlik: tamErisimKimligi,
  ad: 'Tam erişim',
  aciklama: 'Tek seferlik ödeme, süre sınırı yok. Abonelik değildir.',
);

const varsayilanPaketler = [tamErisimPaketi];

/// Web önizlemesi ve testler için: "satın alma" cihazda bir bayrak açar, para çekilmez.
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
