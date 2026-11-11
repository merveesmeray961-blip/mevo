import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/veri/depo.dart';
import 'package:mevo/veri/yedek.dart';

import 'yardimci.dart';

void main() {
  test('yedek başka telefona taşınınca çalışma geçmişi, notlar ve ayarlar aynen gelir', () async {
    final eski = durumOlustur(bolum: 'YET');
    final sorular = eski.banka.bolumSorulari('YET').take(12).toList();
    for (final s in sorular) {
      await eski.ilerleme.cevapla(s, s.dogru);
    }
    await eski.notlar.kaydet(sorular.first.id, 'KDV iadesi tuzağı');
    final kod = yedekOlustur(eski.ilerleme.depo, 'smmm', DateTime(2026, 11, 11));
    expect(kod, startsWith(yedekOnEki));

    // Yeni telefon: boş depo, önce bölüm seçilmemiş.
    final yeni = durumOlustur(depo: BellekDepo());
    final y = yedekCoz('  $kod\n', 'smmm');
    expect(y.tarih, DateTime(2026, 11, 11));
    await yedekYaz(yeni.ilerleme.depo, y.veri);
    yeni.ilerleme.yenidenYukle();
    yeni.notlar.yenidenYukle();
    yeni.ayarlar.yenidenYukle();
    expect(yeni.ilerleme.istatistik(sorular).cozulen, 12);
    expect(yeni.notlar.not(sorular.first.id)?.metin, 'KDV iadesi tuzağı');
    expect(yeni.ayarlar.bolum, 'YET');
  });

  test('diğer uygulamanın, bozuk ya da yanlış metnin yedeği kabul edilmez', () {
    final d = durumOlustur(bolum: 'YET');
    final kod = yedekOlustur(d.ilerleme.depo, 'smmm', DateTime(2026, 11, 11));
    expect(() => yedekCoz(kod, 'ymm'), throwsA(isA<YedekHatasi>()));
    expect(() => yedekCoz('merhaba', 'smmm'), throwsA(isA<YedekHatasi>()));
    expect(() => yedekCoz(kod.substring(0, kod.length - 10), 'smmm'), throwsA(isA<YedekHatasi>()));
  });
}
