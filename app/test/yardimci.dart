import 'dart:convert';
import 'dart:io';

import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/bilesenler/sesli_okuma.dart';
import 'package:mevo/urun.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/ayarlar.dart';
import 'package:mevo/veri/depo.dart';
import 'package:mevo/veri/ilerleme.dart';
import 'package:mevo/veri/modeller.dart';
import 'package:mevo/veri/notlar.dart';

/// Testler gerçek soru paketini kullanır; böylece paket biçimi değişirse testler de kırılır.
/// Varsayılan SMMM paketidir; YMM uygulaması için `gercekBanka(Urun.ymm)`.
SoruBankasi gercekBanka([Urun urun = Urun.smmm]) => SoruBankasi.fromJson(gercekBankaJson(urun));

Map<String, dynamic> gercekBankaJson([Urun urun = Urun.smmm]) =>
    jsonDecode(File('assets/sorular/${urun.kod}.json').readAsStringSync()) as Map<String, dynamic>;

class Saat {
  DateTime simdi;
  Saat(this.simdi);
  void ilerlet(Duration d) => simdi = simdi.add(d);
}

UygulamaDurumu durumOlustur({
  SoruBankasi? banka,
  Depo? depo,
  Saat? saat,
  String? bolum,
  Urun urun = Urun.smmm,
  SesMotoru? ses,
}) {
  final d =
      depo ??
      BellekDepo(
        bolum == null
            ? null
            : {
                'ayarlar.v1': jsonEncode({'bolum': bolum}),
              },
      );
  final s = saat ?? Saat(DateTime(2026, 10, 5, 10));
  return UygulamaDurumu(
    banka: banka ?? gercekBanka(urun),
    ilerleme: Ilerleme(d, simdi: () => s.simdi),
    ayarlar: Ayarlar(d),
    abonelik: OnizlemeAbonelik(d),
    notlar: Notlar(d),
    urun: urun,
    ses: ses,
  );
}
