import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'abonelik/abonelik.dart';
import 'ekranlar/ana_kabuk.dart';
import 'ekranlar/bolum_secimi.dart';
import 'uygulama.dart';
import 'veri/ayarlar.dart';
import 'veri/depo.dart';
import 'veri/ilerleme.dart';
import 'veri/modeller.dart';

const soruPaketi = 'assets/sorular/smmm.json';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final depo = await CihazDepo.ac();
  final banka = SoruBankasi.fromJson(jsonDecode(await rootBundle.loadString(soruPaketi)) as Map<String, dynamic>);
  runApp(
    MevoUygulamasi(
      durum: UygulamaDurumu(
        banka: banka,
        ilerleme: Ilerleme(depo),
        ayarlar: Ayarlar(depo),
        abonelik: OnizlemeAbonelik(depo),
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
          home: durum.ayarlar.bolum == null ? const BolumSecimi(ilkAcilis: true) : const AnaKabuk(),
        ),
      ),
    );
  }
}
