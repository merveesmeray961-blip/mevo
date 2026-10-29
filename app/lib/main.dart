import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'abonelik/abonelik.dart';
import 'abonelik/magaza_abonelik.dart';
import 'bilesenler/sesli_okuma.dart';
import 'ekranlar/ana_kabuk.dart';
import 'ekranlar/bolum_secimi.dart';
import 'urun.dart';
import 'uygulama.dart';
import 'veri/ayarlar.dart';
import 'veri/depo.dart';
import 'veri/ilerleme.dart';
import 'veri/modeller.dart';
import 'veri/notlar.dart';
import 'veri/paket.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kenardan kenara çizim (Android 15+ zaten böyledir); sistem çubuklarının arkası uygulama rengiyle dolar.
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  final urun = Urun.calisan;
  final depo = await CihazDepo.ac();
  final paket = (await rootBundle.load(urun.paketYolu)).buffer.asUint8List();
  final banka = SoruBankasi.fromJson(jsonDecode(paketCoz(paket)) as Map<String, dynamic>);
  // Yanlış paketle derlenmiş uygulamayı baştan reddet (ör. YMM uygulamasına SMMM paketi konmuşsa).
  if (banka.urun != null && banka.urun != urun.kod) {
    throw StateError('Soru paketi ${banka.urun} uygulamasına ait; bu uygulama ${urun.kod}.');
  }
  // Android ve iOS'ta gerçek mağaza ödemesi; web önizlemesinde (mağaza yok) sahte önizleme ödemesi.
  final gercekMagaza =
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  final AbonelikServisi abonelik = gercekMagaza ? MagazaAbonelik(depo) : OnizlemeAbonelik(depo);
  unawaited(abonelik.baslat());
  final ayarlar = Ayarlar(depo);
  final ses = varsayilanSesMotoru();
  unawaited(ses.hizSec(ayarlar.sesHizi));
  runApp(
    MevoUygulamasi(
      durum: UygulamaDurumu(
        banka: banka,
        ilerleme: Ilerleme(depo),
        ayarlar: ayarlar,
        abonelik: abonelik,
        notlar: Notlar(depo),
        urun: urun,
        ses: ses,
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
          title: durum.urun.ad,
          debugShowCheckedModeBanner: false,
          theme: tema(Brightness.light, durum.urun.anaRenk),
          darkTheme: tema(Brightness.dark, durum.urun.anaRenk),
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
          home: durum.bolumSecildi ? const AnaKabuk() : const BolumSecimi(ilkAcilis: true),
        ),
      ),
    );
  }
}
