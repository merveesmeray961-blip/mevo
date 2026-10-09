import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/veri/paket.dart';

void main() {
  test('gömülü paket açılınca dışa aktarılan JSON ile birebir aynıdır', () {
    final paket = File('assets/sorular/smmm.paket').readAsBytesSync();
    expect(paketCoz(paket), File('assets/sorular/smmm.json').readAsStringSync());
  });

  test('web için parçalı 32 bit çarpım doğrudan çarpımla aynı sonucu verir', () {
    final veri = List.generate(500, (i) => (i * 37 + 11) & 0xFF);
    expect(fnv1aParcali(veri), fnv1aDogrudan(veri));
  });

  test('tanınmayan paket reddedilir', () {
    expect(() => paketCoz(File('assets/sorular/smmm.json').readAsBytesSync()), throwsFormatException);
  });
}
