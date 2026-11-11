import 'dart:convert';

import 'package:archive/archive.dart';

import 'depo.dart';

/// İlerleme yedeği: telefon değiştirince çalışma geçmişini taşımak için.
///
/// Yedek, sıkıştırılmış ve base64 ile yazıya çevrilmiş tek bir koddur ("MEVO1:..."). Kullanıcı kodu kopyalayıp
/// kendine gönderir (not, e-posta, mesaj), yeni telefonda yapıştırır. Sunucu yoktur; veri cihazdan çıkmaz.
/// Satın alma yedeğe girmez; tam erişim mağazadan "Satın alımı geri yükle" ile gelir.
const yedekOnEki = 'MEVO1:';

/// Yedeğe giren depo anahtarları (ilerleme, notlar, ayarlar).
const yedekAnahtarlari = [
  'ilerleme.sorular.v1',
  'ilerleme.denemeler.v1',
  'ilerleme.gunluk.v1',
  'ilerleme.bildirimler.v1',
  'ilerleme.anlatimlar.v1',
  'ilerleme.son_anlatim.v1',
  'ilerleme.yarim_deneme.v1',
  'notlar.v1',
  'ayarlar.v1',
];

class YedekHatasi implements Exception {
  final String mesaj;
  const YedekHatasi(this.mesaj);
  @override
  String toString() => mesaj;
}

/// Depodaki verilerden yedek kodu üretir. [urun] uygulama kodudur ('smmm' / 'ymm').
String yedekOlustur(Depo depo, String urun, DateTime tarih) {
  final veri = <String, String>{
    for (final a in yedekAnahtarlari)
      if (depo.oku(a) != null) a: depo.oku(a)!,
  };
  final ham = utf8.encode(jsonEncode({'u': urun, 't': tarih.toIso8601String(), 'v': veri}));
  return yedekOnEki + base64.encode(const GZipEncoder().encode(ham));
}

/// Yedek kodunu çözer ve doğrular; sorun varsa kullanıcıya gösterilecek Türkçe iletiyle [YedekHatasi] atar.
({DateTime tarih, Map<String, String> veri}) yedekCoz(String kod, String urun) {
  final temiz = kod.replaceAll(RegExp(r'\s'), '');
  if (!temiz.startsWith(yedekOnEki)) {
    throw const YedekHatasi('Bu bir yedek kodu değil. Kodu eksiksiz kopyaladığından emin ol.');
  }
  final Map<String, dynamic> j;
  try {
    final acik = const GZipDecoder().decodeBytes(base64.decode(temiz.substring(yedekOnEki.length)));
    j = jsonDecode(utf8.decode(acik)) as Map<String, dynamic>;
  } catch (_) {
    throw const YedekHatasi('Yedek kodu bozuk ya da eksik kopyalanmış.');
  }
  if (j['u'] != urun) {
    throw const YedekHatasi('Bu yedek diğer uygulamaya ait (Mizan SMMM ↔ Tasdik YMM).');
  }
  final veri = <String, String>{};
  (j['v'] as Map).forEach((k, v) {
    if (yedekAnahtarlari.contains(k)) veri[k as String] = v as String;
  });
  return (tarih: DateTime.parse(j['t'] as String), veri: veri);
}

/// Yedeği depoya yazar: yedekte olmayan anahtarlar silinir (cihazdaki eski ilerlemeyle karışmaz).
Future<void> yedekYaz(Depo depo, Map<String, String> veri) async {
  for (final a in yedekAnahtarlari) {
    final v = veri[a];
    if (v == null) {
      await depo.sil(a);
    } else {
      await depo.yaz(a, v);
    }
  }
}
