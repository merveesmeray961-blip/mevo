import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/abonelik/magaza_abonelik.dart';
import 'package:mevo/veri/depo.dart';

/// Gerçek mağaza yerine geçen sahte: satın alma olayları testten elle gönderilir.
class SahteMagaza implements InAppPurchase {
  final akis = StreamController<List<PurchaseDetails>>.broadcast();
  bool musait = true;
  bool urunVar = true;
  bool sorguPatlar = false;
  final tamamlananlar = <PurchaseDetails>[];
  int geriYuklemeSayisi = 0;

  /// Mağaza ekranı açılınca (buyNonConsumable) ne olacağı.
  Future<void> Function(SahteMagaza)? satinAlmaAkisi;
  Future<void> Function(SahteMagaza)? geriYuklemeAkisi;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => akis.stream;

  @override
  Future<bool> isAvailable() async => musait;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> kimlikler) async {
    if (sorguPatlar) throw Exception('ağ yok');
    return ProductDetailsResponse(
      productDetails: urunVar
          ? [
              ProductDetails(
                id: tamErisimKimligi,
                title: 'Tam erişim',
                description: '',
                price: '₺349,99',
                rawPrice: 349.99,
                currencyCode: 'TRY',
              ),
            ]
          : [],
      notFoundIDs: urunVar ? [] : [tamErisimKimligi],
    );
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    unawaited(Future(() => satinAlmaAkisi?.call(this)));
    return true;
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    geriYuklemeSayisi++;
    unawaited(Future(() => geriYuklemeAkisi?.call(this)));
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async => tamamlananlar.add(purchase);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  void gonder(
    PurchaseStatus durum, {
    String urun = tamErisimKimligi,
    bool bekliyor = true,
    String belge = 'jeton',
    IAPError? hata,
  }) {
    final p = PurchaseDetails(
      purchaseID: 'siparis-1',
      productID: urun,
      verificationData: PurchaseVerificationData(
        localVerificationData: belge,
        serverVerificationData: belge,
        source: 'test',
      ),
      transactionDate: null,
      status: durum,
    )..pendingCompletePurchase = bekliyor;
    p.error = hata;
    akis.add([p]);
  }
}

Future<void> bekle() => Future<void>.delayed(const Duration(milliseconds: 20));

Future<(MagazaAbonelik, SahteMagaza, BellekDepo)> kur({
  bool premium = false,
  void Function(SahteMagaza)? ayar,
  Duration sure = const Duration(milliseconds: 200),
}) async {
  final depo = BellekDepo(premium ? {MagazaAbonelik.anahtar: '1'} : null);
  final magaza = SahteMagaza();
  ayar?.call(magaza);
  final servis = MagazaAbonelik(depo, magaza: magaza, geriYuklemeSuresi: sure);
  addTearDown(servis.dispose);
  await servis.baslat();
  return (servis, magaza, depo);
}

void main() {
  group('mağaza durumu', () {
    test('ürün bulunur ve mağaza fiyatı gösterilir', () async {
      final (s, _, _) = await kur();
      expect(s.magaza, MagazaDurumu.hazir);
      expect(s.paketler.single.fiyat, '₺349,99');
      expect(s.premium, isFalse);
      expect(s.onizleme, isFalse);
    });

    test('mağaza kullanılamıyorsa satın alma reddedilir', () async {
      final (s, _, _) = await kur(ayar: (m) => m.musait = false);
      expect(s.magaza, MagazaDurumu.kullanilamiyor);
      expect(await s.satinAl(s.paketler.first), isFalse);
      expect(s.premium, isFalse);
    });

    test('ürün mağazada tanımlı değilse urunYok', () async {
      final (s, _, _) = await kur(ayar: (m) => m.urunVar = false);
      expect(s.magaza, MagazaDurumu.urunYok);
      expect(s.paketler.single.fiyat, isNull);
      expect(await s.satinAl(s.paketler.first), isFalse);
    });

    test('sorgu hata verirse kullanilamiyor; yeniden dene toparlar', () async {
      final (s, m, _) = await kur(ayar: (m) => m.sorguPatlar = true);
      expect(s.magaza, MagazaDurumu.kullanilamiyor);
      m.sorguPatlar = false;
      await s.baslat();
      expect(s.magaza, MagazaDurumu.hazir);
    });
  });

  group('satın alma', () {
    test('başarılı: hak açılır, cihaza yazılır, işlem tamamlanır', () async {
      final (s, m, depo) = await kur(ayar: (m) => m.satinAlmaAkisi = (m) async => m.gonder(PurchaseStatus.purchased));
      expect(await s.satinAl(s.paketler.first), isTrue);
      expect(s.premium, isTrue);
      expect(s.islem, IslemDurumu.bos);
      expect(depo.oku(MagazaAbonelik.anahtar), '1');
      expect(m.tamamlananlar, hasLength(1));
    });

    test('hak yeniden açılışta cihazdan okunur', () async {
      final (s, _, _) = await kur(premium: true);
      expect(s.premium, isTrue);
    });

    test('kullanıcı vazgeçerse iptal olur ve ücret/hak yok', () async {
      final (s, m, depo) = await kur(
        ayar: (m) => m.satinAlmaAkisi = (m) async => m.gonder(PurchaseStatus.canceled, bekliyor: false),
      );
      expect(await s.satinAl(s.paketler.first), isFalse);
      expect(s.islem, IslemDurumu.iptal);
      expect(s.premium, isFalse);
      expect(depo.oku(MagazaAbonelik.anahtar), isNull);
      expect(m.tamamlananlar, isEmpty);
    });

    test('mağaza hatası mesajla bildirilir ve işlem tamamlanır', () async {
      final (s, m, _) = await kur(
        ayar: (m) => m.satinAlmaAkisi = (m) async => m.gonder(
          PurchaseStatus.error,
          hata: IAPError(source: 'test', code: 'x', message: 'Kart reddedildi'),
        ),
      );
      expect(await s.satinAl(s.paketler.first), isFalse);
      expect(s.islem, IslemDurumu.hata);
      expect(s.hata, 'Kart reddedildi');
      expect(s.premium, isFalse);
      expect(m.tamamlananlar, hasLength(1));
    });

    test('beklemede: hak verilmez; sonra onaylanınca kendiliğinden açılır', () async {
      final (s, m, depo) = await kur(
        ayar: (m) => m.satinAlmaAkisi = (m) async => m.gonder(PurchaseStatus.pending, bekliyor: false),
      );
      expect(await s.satinAl(s.paketler.first), isFalse);
      expect(s.islem, IslemDurumu.beklemede);
      expect(s.premium, isFalse);
      m.gonder(PurchaseStatus.purchased);
      await bekle();
      expect(s.premium, isTrue);
      expect(s.islem, IslemDurumu.bos);
      expect(depo.oku(MagazaAbonelik.anahtar), '1');
    });

    test('doğrulama verisi boş satın alma hak vermez', () async {
      final (s, _, _) = await kur(
        ayar: (m) => m.satinAlmaAkisi = (m) async => m.gonder(PurchaseStatus.purchased, belge: ''),
      );
      expect(await s.satinAl(s.paketler.first), isFalse);
      expect(s.premium, isFalse);
    });

    test('başka ürünün satın alması hak vermez ama tamamlanır', () async {
      final (s, m, _) = await kur();
      m.gonder(PurchaseStatus.purchased, urun: 'baska');
      await bekle();
      expect(s.premium, isFalse);
      expect(m.tamamlananlar, hasLength(1));
    });

    test('uygulama kapalıyken tamamlanmamış satın alma açılışta işlenir', () async {
      final (s, m, _) = await kur();
      m.gonder(PurchaseStatus.purchased);
      await bekle();
      expect(s.premium, isTrue);
      expect(m.tamamlananlar, hasLength(1));
    });
  });

  group('geri yükleme', () {
    test('mağaza satın alımı döndürürse hak açılır', () async {
      final (s, m, depo) = await kur(ayar: (m) => m.geriYuklemeAkisi = (m) async => m.gonder(PurchaseStatus.restored));
      expect(await s.geriYukle(), isTrue);
      expect(m.geriYuklemeSayisi, 1);
      expect(depo.oku(MagazaAbonelik.anahtar), '1');
    });

    test('mağaza boş liste döndürürse (iade/başka hesap) hak geri alınır', () async {
      final (s, _, depo) = await kur(premium: true, ayar: (m) => m.geriYuklemeAkisi = (m) async => m.akis.add([]));
      expect(await s.geriYukle(), isFalse);
      expect(s.premium, isFalse);
      expect(depo.oku(MagazaAbonelik.anahtar), isNull);
    });

    test('mağazadan yanıt gelmezse (iOS, satın alma yok) yerel hak korunur', () async {
      final (s, _, _) = await kur(premium: true);
      expect(await s.geriYukle(), isTrue);
    });

    test('hakkı olmayan kullanıcı için geri yükleme false döner', () async {
      final (s, _, _) = await kur();
      expect(await s.geriYukle(), isFalse);
    });
  });

  test('önizleme servisi: satın alma bayrağı açar, geri yükleme mevcut durumu döndürür', () async {
    final s = OnizlemeAbonelik(BellekDepo());
    expect(s.onizleme, isTrue);
    expect(await s.geriYukle(), isFalse);
    expect(await s.satinAl(s.paketler.single), isTrue);
    expect(s.premium, isTrue);
    expect(s.paketler.single.kimlik, tamErisimKimligi);
  });
}
