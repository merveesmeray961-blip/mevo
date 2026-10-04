import 'dart:convert';
import 'dart:io';

import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/ayarlar.dart';
import 'package:mevo/veri/depo.dart';
import 'package:mevo/veri/ilerleme.dart';
import 'package:mevo/veri/modeller.dart';
import 'package:mevo/veri/notlar.dart';

/// Testler gerçek soru paketini kullanır; böylece paket biçimi değişirse testler de kırılır.
SoruBankasi gercekBanka() =>
    SoruBankasi.fromJson(jsonDecode(File('assets/sorular/smmm.json').readAsStringSync()) as Map<String, dynamic>);

class Saat {
  DateTime simdi;
  Saat(this.simdi);
  void ilerlet(Duration d) => simdi = simdi.add(d);
}

UygulamaDurumu durumOlustur({SoruBankasi? banka, Depo? depo, Saat? saat, String? bolum}) {
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
    banka: banka ?? gercekBanka(),
    ilerleme: Ilerleme(d, simdi: () => s.simdi),
    ayarlar: Ayarlar(d),
    abonelik: OnizlemeAbonelik(d),
    notlar: Notlar(d),
  );
}
