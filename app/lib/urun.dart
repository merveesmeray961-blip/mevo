import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show appFlavor;

/// Aynı koddan çıkan iki ayrı mağaza uygulaması.
///
/// Hangisinin çalıştığı derleme sırasında `--flavor smmm` / `--flavor ymm` ile seçilir (Flutter bunu [appFlavor]
/// olarak uygulamaya iletir). Aynı bayrak Android'de uygulama kimliğini, adı, simgeyi ve uygulamaya gömülecek soru
/// paketini de belirler; böylece SMMM uygulamasında YMM içeriği, YMM uygulamasında SMMM içeriği bulunmaz.
enum Urun {
  smmm(
    kod: 'smmm',
    ad: 'Mizan SMMM',
    sinav: 'SMMM',
    sinavCumlesi: 'SMMM sınavlarına',
    paketYolu: 'assets/sorular/smmm.paket',
    anaRenk: Color(0xFF0F6B5C),
    bolumler: ['SGS', 'YET'],
  ),
  ymm(
    kod: 'ymm',
    ad: 'Tasdik YMM',
    sinav: 'YMM',
    sinavCumlesi: 'YMM sınavına',
    paketYolu: 'assets/sorular/ymm.paket',
    anaRenk: Color(0xFF1F4E8C),
    bolumler: ['YMM'],
  );

  const Urun({
    required this.kod,
    required this.ad,
    required this.sinav,
    required this.sinavCumlesi,
    required this.paketYolu,
    required this.anaRenk,
    required this.bolumler,
  });

  /// Derleme bayrağı ve paketteki `urun` alanıyla aynı kısa ad.
  final String kod;

  /// Mağazadaki ve cihazdaki uygulama adı.
  final String ad;

  /// Sınavın kısa adı (metinlerde kullanılır).
  final String sinav;

  /// "… hazırlık amacıyla" cümlesindeki yönelme biçimi: "SMMM sınavlarına", "YMM sınavına".
  final String sinavCumlesi;

  /// Uygulamaya gömülü soru paketi.
  final String paketYolu;
  final Color anaRenk;

  /// Bu uygulamada çalışılabilen bölümler (sınav türleri).
  final List<String> bolumler;

  /// Kullanıcıya "hangi sınav?" sorulur mu? Tek bölümlü uygulamada sorulmaz.
  bool get bolumSecimiVar => bolumler.length > 1;

  /// Bayrak değerinden ürünü bulur; bayrak yoksa ya da tanınmıyorsa SMMM (varsayılan uygulama).
  static Urun bayraktan(String? bayrak) => values.firstWhere((u) => u.kod == bayrak, orElse: () => smmm);

  /// Web önizlemesinde Flutter `--flavor` bayrağını iletmez; ürün `--dart-define=MEVO_URUN=ymm` ile seçilir
  /// (docs/devir/araclar/web_onizleme.py bunu otomatik yapar). Mobilde bayrak esastır.
  static const _webUrunu = String.fromEnvironment('MEVO_URUN');

  /// Şu an çalışan uygulamanın ürünü.
  static Urun get calisan => bayraktan(appFlavor ?? (_webUrunu.isEmpty ? null : _webUrunu));
}
