import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'modeller.dart';
import 'paket.dart';

/// TESMER'in yayımladığı geçmiş sınav sorularından bir oturum (ör. 2025/3 SGS).
///
/// Sorular yayımlandıkları biçimde, resmî kitapçıkta işaretlenen cevapla verilir; yorum ya da çözüm eklenmez.
/// Uygulamada ücretsizdir. Paket yalnız SMMM uygulamasına gömülür (pipeline/cikmis_paketle.py).
class CikmisOturum {
  final String kod;
  final String sinav; // "SGS" | "Yeterlilik"
  final int yil;
  final int donem;
  final List<Soru> sorular;

  const CikmisOturum({required this.kod, required this.sinav, required this.yil, required this.donem, required this.sorular});

  String get ad => donem > 0 ? '$yil / $donem. dönem $sinav' : '$yil $sinav';

  /// Bu oturumda verilen derslerin kodları (soru sırasıyla).
  List<String> get dersler => {for (final s in sorular) s.ders}.toList();

  factory CikmisOturum.fromJson(Map<String, dynamic> j) {
    final sinav = j['sinav'] as String;
    final yil = j['yil'] as int;
    final donem = j['donem'] as int;
    final ad = donem > 0 ? '$yil/$donem $sinav' : '$yil $sinav';
    return CikmisOturum(
      kod: j['kod'] as String,
      sinav: sinav,
      yil: yil,
      donem: donem,
      sorular: [
        for (final q in (j['sorular'] as List).cast<Map<String, dynamic>>())
          Soru(
            id: q['id'] as String,
            surum: 1,
            bolum: [sinav == 'SGS' ? 'SGS' : 'YET'],
            ders: q['ders'] as String,
            konu: (q['dersAd'] as String?) ?? '',
            tip: 'cikmis',
            zorluk: 2,
            kok: q['kok'] as String,
            secenekler: Map<String, String>.from(q['secenekler'] as Map),
            dogru: q['dogru'] as String,
            dogruNeden: 'Bu soru $ad sınavında sorulmuştur. Resmî cevap anahtarına göre doğru cevap '
                '${q['dogru']} şıkkıdır. Soru, sınav tarihindeki mevzuata göre hazırlanmıştır; '
                'sonradan değişen hükümler için güncel konu anlatımına bak.',
            celdiriciler: const {},
            hesapAdimlari: const [],
            kaynaklar: const [],
          ),
      ],
    );
  }
}

const cikmisPaketYolu = 'assets/cikmis/smmm_cikmis.paket';

List<CikmisOturum> cikmisCoz(Uint8List paket) {
  final j = jsonDecode(paketCoz(paket)) as Map<String, dynamic>;
  return [for (final o in (j['oturumlar'] as List).cast<Map<String, dynamic>>()) CikmisOturum.fromJson(o)];
}

List<CikmisOturum>? _onbellek;

/// Testlerde ve ekran görüntüsü üretiminde paketi önceden yüklemek için.
void cikmisOnbellegeKoy(List<CikmisOturum> oturumlar) => _onbellek = oturumlar;

/// Paketi bir kez açar (ayrı isolate'ta) ve bellekte tutar. Paket yoksa (YMM uygulaması) boş liste döner.
Future<List<CikmisOturum>> cikmisYukle({AssetBundle? bundle}) async {
  if (_onbellek != null) return _onbellek!;
  try {
    final veri = (await (bundle ?? rootBundle).load(cikmisPaketYolu)).buffer.asUint8List();
    _onbellek = await compute(cikmisCoz, veri);
  } catch (_) {
    _onbellek = const [];
  }
  return _onbellek!;
}
