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

/// Açılış süresi ölçümü: `--dart-define=MEVO_OLCUM=true` ile derlenince adımlar logcat'e yazılır.
const _olcum = bool.fromEnvironment('MEVO_OLCUM');
final _acilis = Stopwatch()..start();
void _olc(String adim) {
  if (_olcum) debugPrint('OLCUM ${_acilis.elapsedMilliseconds} ms: $adim');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _olc('binding');
  // Kenardan kenara çizim (Android 15+ zaten böyledir); sistem çubuklarının arkası uygulama rengiyle dolar.
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  final urun = Urun.calisan;
  // İlk kare hemen çizilir (marka renginde açılış ekranı); soru bankası arkada yüklenince asıl uygulama gelir.
  WidgetsBinding.instance.addPostFrameCallback((_) => _olc('açılış karesi'));
  runApp(AcilisEkrani(urun: urun));
  // Önce depo (hafif, platform kanalı) açılır; ağır paket ayrıştırması sonra arka iş parçacığında başlar.
  // Eş zamanlı başlatınca yavaş cihazda depo yanıtı saniyelerce gecikebiliyordu (emülatör ölçümü, 11.11.2026).
  final depo = await CihazDepo.ac();
  _olc('depo');
  final paket = (await rootBundle.load(urun.paketYolu)).buffer.asUint8List();
  final banka = await compute(bankaAc, paket);
  _olc('banka');
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
  unawaited(ses.sesSec(ayarlar.sesAdi));
  _olc('runApp');
  WidgetsBinding.instance.addPostFrameCallback((_) => _olc('ilk kare'));
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

/// Gömülü soru paketini açıp soru bankasını kurar (arka iş parçacığında çalışır).
SoruBankasi bankaAc(Uint8List paket) {
  final s = Stopwatch()..start();
  final bayt = paketCozBayt(paket);
  final t1 = s.elapsedMilliseconds;
  // UTF-8 çözme ve JSON ayrıştırma tek geçişte (ara metin yok; Dart bu birleşimi hızlı yoldan çalıştırır).
  final j = utf8.decoder.fuse(json.decoder).convert(bayt) as Map<String, dynamic>;
  final t2 = s.elapsedMilliseconds;
  final b = SoruBankasi.fromJson(j);
  if (_olcum) debugPrint('OLCUM isolate: coz $t1 ms, json ${t2 - t1} ms, model ${s.elapsedMilliseconds - t2} ms');
  return b;
}

/// Soru bankası yüklenirken gösterilen sade açılış ekranı (Kapsam/tema gerektirmez).
class AcilisEkrani extends StatelessWidget {
  final Urun urun;

  const AcilisEkrani({super.key, required this.urun});

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: urun.anaRenk,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              urun.ad,
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, fontFamily: 'Sora'),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
