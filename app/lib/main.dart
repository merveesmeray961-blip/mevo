import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'abonelik/abonelik.dart';
import 'abonelik/magaza_abonelik.dart';
import 'ekranlar/ana_kabuk.dart';
import 'ekranlar/bolum_secimi.dart';
import 'uygulama.dart';
import 'veri/ayarlar.dart';
import 'veri/depo.dart';
import 'veri/ilerleme.dart';
import 'veri/modeller.dart';
import 'veri/notlar.dart';

const soruPaketi = 'assets/sorular/smmm.json';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kenardan kenara çizim (Android 15+ zaten böyledir); sistem çubuklarının arkası uygulama rengiyle dolar.
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  final depo = await CihazDepo.ac();
  final banka = SoruBankasi.fromJson(jsonDecode(await rootBundle.loadString(soruPaketi)) as Map<String, dynamic>);
  // Android ve iOS'ta gerçek mağaza ödemesi; web önizlemesinde (mağaza yok) sahte önizleme ödemesi.
  final gercekMagaza =
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  final AbonelikServisi abonelik = gercekMagaza ? MagazaAbonelik(depo) : OnizlemeAbonelik(depo);
  unawaited(abonelik.baslat());
  runApp(
    MevoUygulamasi(
      durum: UygulamaDurumu(
        banka: banka,
        ilerleme: Ilerleme(depo),
        ayarlar: Ayarlar(depo),
        abonelik: abonelik,
        notlar: Notlar(depo),
      ),
    ),
  );
}

class MevoUygulamasi extends StatelessWidget {
  final UygulamaDurumu durum;

  const MevoUygulamasi({super.key, required this.durum});

  @override
  Widget build(BuildContext context) {
    return Kapsam(
      durum: durum,
      child: ListenableBuilder(
        listenable: durum.ayarlar,
        builder: (context, _) => MaterialApp(
          title: 'Mevo SMMM',
          debugShowCheckedModeBanner: false,
          theme: tema(Brightness.light),
          darkTheme: tema(Brightness.dark),
          themeMode: durum.ayarlar.tema,
          locale: const Locale('tr'),
          // Yazı boyutu en çok 2 kata kadar büyür; ötesinde yerleşim bozulmasın diye sınırlanır.
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                (MediaQuery.textScalerOf(context).scale(100) / 100 * durum.ayarlar.yazi).clamp(0.8, 2.0),
              ),
            ),
            child: child!,
          ),
          home: durum.ayarlar.bolum == null ? const BolumSecimi(ilkAcilis: true) : const AnaKabuk(),
        ),
      ),
    );
  }
}
