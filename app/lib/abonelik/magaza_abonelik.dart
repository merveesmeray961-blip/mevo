import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../veri/depo.dart';
import 'abonelik.dart';

/// Google Play / App Store üzerinden tek seferlik "Tam erişim" satın alımı (`in_app_purchase`).
///
/// Sunucu yoktur: hak, mağazanın verdiği satın alma kaydına dayanarak cihazda ([Depo]) saklanır.
/// Kullanıcı "Satın alımı geri yükle" dediğinde mağazaya yeniden sorulur ve yanıta göre hak doğrulanır.
class MagazaAbonelik extends AbonelikServisi {
  static const anahtar = 'abonelik.magaza.v1';

  /// Geri yüklemede mağazanın yanıtı için beklenen azami süre (iOS, satın alma yoksa hiç olay göndermez).
  final Duration geriYuklemeSuresi;

  final InAppPurchase _magaza;
  final Depo _depo;
  StreamSubscription<List<PurchaseDetails>>? _abone;

  bool _premium;
  MagazaDurumu _magazaDurumu = MagazaDurumu.yukleniyor;
  IslemDurumu _islem = IslemDurumu.bos;
  String? _hata;
  ProductDetails? _urun;

  Completer<bool>? _satinAlma;
  Completer<List<PurchaseDetails>?>? _geriYukleme;

  MagazaAbonelik(this._depo, {InAppPurchase? magaza, this.geriYuklemeSuresi = const Duration(seconds: 8)})
    : _magaza = magaza ?? InAppPurchase.instance,
      _premium = _depo.oku(anahtar) == '1';

  @override
  bool get premium => _premium;

  @override
  bool get onizleme => false;

  @override
  MagazaDurumu get magaza => _magazaDurumu;

  @override
  IslemDurumu get islem => _islem;

  @override
  String? get hata => _hata;

  @override
  List<AbonelikPaketi> get paketler => [
    AbonelikPaketi(
      kimlik: tamErisimKimligi,
      ad: tamErisimPaketi.ad,
      aciklama: tamErisimPaketi.aciklama,
      fiyat: _urun?.price,
    ),
  ];

  @override
  Future<void> baslat() async {
    _abone ??= _magaza.purchaseStream.listen(_guncellemeGeldi, onError: _akisHatasi);
    _magazaDurumu = MagazaDurumu.yukleniyor;
    notifyListeners();
    try {
      if (!await _magaza.isAvailable()) {
        _magazaDurumu = MagazaDurumu.kullanilamiyor;
      } else {
        final yanit = await _magaza.queryProductDetails({tamErisimKimligi});
        final urun = yanit.productDetails.where((u) => u.id == tamErisimKimligi).firstOrNull;
        _urun = urun;
        _magazaDurumu = urun != null
            ? MagazaDurumu.hazir
            : (yanit.error != null ? MagazaDurumu.kullanilamiyor : MagazaDurumu.urunYok);
      }
    } catch (_) {
      _magazaDurumu = MagazaDurumu.kullanilamiyor;
    }
    notifyListeners();
  }

  @override
  Future<bool> satinAl(AbonelikPaketi paket) async {
    if (_premium) return true;
    final urun = _urun;
    if (urun == null || _satinAlma != null) return false;
    _hata = null;
    _islem = IslemDurumu.suruyor;
    notifyListeners();
    final tamam = _satinAlma = Completer<bool>();
    try {
      final basladi = await _magaza.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: urun));
      if (!basladi) _bitir(IslemDurumu.hata, 'Satın alma başlatılamadı.');
    } catch (e) {
      _bitir(IslemDurumu.hata, 'Satın alma başlatılamadı.');
    }
    final sonuc = await tamam.future;
    _satinAlma = null;
    return sonuc;
  }

  @override
  Future<bool> geriYukle() async {
    if (_geriYukleme != null) return _premium;
    _hata = null;
    final bekleyen = _geriYukleme = Completer<List<PurchaseDetails>?>();
    try {
      await _magaza.restorePurchases();
      final liste = await bekleyen.future.timeout(geriYuklemeSuresi, onTimeout: () => null);
      // Mağaza yanıt verdi ama bu ürünü içermiyorsa (iade, başka hesap) hak geri alınır. Yanıt hiç gelmediyse
      // (iOS'ta satın alma yoksa olay gelmez) çevrimdışı kullanıcıyı korumak için yerel hak olduğu gibi kalır.
      if (liste != null && !liste.any(_gecerli) && !liste.any((p) => p.status == PurchaseStatus.error)) {
        await _hakVer(false);
      }
    } catch (_) {
      _hata = 'Mağazaya ulaşılamadı. İnternet bağlantını kontrol edip tekrar dene.';
      notifyListeners();
    } finally {
      _geriYukleme = null;
    }
    return _premium;
  }

  /// Satın alma kaydı bu ürün için geçerli bir hak mı?
  bool _gecerli(PurchaseDetails p) =>
      p.productID == tamErisimKimligi &&
      (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) &&
      p.verificationData.serverVerificationData.isNotEmpty;

  Future<void> _guncellemeGeldi(List<PurchaseDetails> liste) async {
    for (final p in liste) {
      if (p.productID != tamErisimKimligi) {
        if (p.pendingCompletePurchase) await _magaza.completePurchase(p);
        continue;
      }
      switch (p.status) {
        case PurchaseStatus.pending:
          _bitir(IslemDurumu.beklemede, null);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (_gecerli(p)) await _hakVer(true);
          _bitir(IslemDurumu.bos, null, basarili: _gecerli(p));
        case PurchaseStatus.canceled:
          _bitir(IslemDurumu.iptal, null);
        case PurchaseStatus.error:
          _bitir(IslemDurumu.hata, p.error?.message ?? 'Satın alma tamamlanamadı.');
      }
      // Mağazaya "işlendi" demek zorunludur; yoksa Android 3 gün içinde parayı iade eder, iOS işlemi tekrar yollar.
      if (p.pendingCompletePurchase) await _magaza.completePurchase(p);
    }
    final geriYukleme = _geriYukleme;
    if (geriYukleme != null && !geriYukleme.isCompleted) geriYukleme.complete(liste);
  }

  void _akisHatasi(Object hata) {
    _bitir(IslemDurumu.hata, 'Mağaza bağlantısında sorun oluştu.');
    final geriYukleme = _geriYukleme;
    if (geriYukleme != null && !geriYukleme.isCompleted) geriYukleme.completeError(hata);
  }

  Future<void> _hakVer(bool acik) async {
    if (_premium == acik) return;
    _premium = acik;
    notifyListeners();
    if (acik) {
      await _depo.yaz(anahtar, '1');
    } else {
      await _depo.sil(anahtar);
    }
  }

  void _bitir(IslemDurumu durum, String? hata, {bool basarili = false}) {
    _islem = durum;
    _hata = hata;
    notifyListeners();
    final satinAlma = _satinAlma;
    if (satinAlma != null && !satinAlma.isCompleted) satinAlma.complete(basarili);
  }

  @override
  void dispose() {
    _abone?.cancel();
    super.dispose();
  }
}
