import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/mantik/sesli_okuma.dart';

import 'yardimci.dart';

void main() {
  group('Konuşma metni', () {
    test('Markdown işaretleri okunmaz', () {
      final s = konusmaMetni('## Başlık\n- **kalın** madde\n1. sıralı\n> **İpucu:** not\nDüz `kod` metin');
      expect(s, isNot(contains('#')));
      expect(s, isNot(contains('*')));
      expect(s, isNot(contains('`')));
      expect(s, isNot(contains('>')));
      expect(s, contains('Başlık'));
      expect(s, contains('kalın madde'));
      expect(s, contains('İpucu: not'));
    });

    test('tablo satırı virgüllü cümle olur, ayırıcı satır düşer', () {
      final s = konusmaMetni('| Hesap | Ne izlenir |\n|---|---|\n| 100 Kasa | Nakit |');
      expect(s, isNot(contains('|')));
      expect(s, isNot(contains('---')));
      expect(s, contains('Hesap, Ne izlenir'));
      expect(s, contains('100 Kasa, Nakit'));
    });

    test('simgeler ve madde numaraları sese uygun yazılır', () {
      final s = konusmaMetni('Tutar ₺1.000, oran %20 ve md. 26/1-(ç) uyarınca');
      expect(s, contains('lira'));
      expect(s, contains('yüzde'));
      expect(s, contains('madde 26, fıkra 1, bent ç'));
      expect(s, isNot(contains('₺')));
      expect(s, isNot(contains('%')));
    });

    test('boş metin boş kalır', () {
      expect(konusmaMetni('   '), isEmpty);
      expect(sesParcalari('  \n '), isEmpty);
    });
  });

  group('Parçalama', () {
    test('kısa metin tek parçadır', () {
      expect(sesParcalari('Kısa bir cümle.'), ['Kısa bir cümle.']);
    });

    test('hiçbir parça sınırı aşmaz, boş değildir ve sözcük kaybolmaz', () {
      const cumle = 'Bu bir deneme cümlesidir ve oldukça uzundur.';
      final metin = List.filled(200, cumle).join(' ');
      final parcalar = sesParcalari(metin, sinir: 300);
      expect(parcalar.length, greaterThan(5));
      for (final p in parcalar) {
        expect(p.length, lessThanOrEqualTo(300));
        expect(p.trim(), isNotEmpty);
      }
      expect(parcalar.join(' ').split(RegExp(r'\s+')).length, metin.split(RegExp(r'\s+')).length);
    });

    test('tek başına sınırı aşan cümle kelime sınırında bölünür', () {
      final uzun = List.filled(400, 'kelime').join(' ');
      final parcalar = sesParcalari(uzun, sinir: 200);
      for (final p in parcalar) {
        expect(p.length, lessThanOrEqualTo(200));
        expect(p, isNot(startsWith(' ')));
      }
      expect(parcalar.join(' '), uzun);
    });

    test('gerçek anlatımların tümü okunabilir parçalara bölünür', () {
      final banka = gercekBanka();
      expect(banka.anlatimlar, isNotEmpty);
      for (final a in banka.anlatimlar.values) {
        final metin = anlatimOkumaMetni(a);
        expect(metin, isNot(contains('**')), reason: a.anahtar);
        expect(metin, isNot(contains('|')), reason: a.anahtar);
        for (final p in sesParcalari(metin)) {
          expect(p.length, lessThanOrEqualTo(sesParcaSiniri), reason: a.anahtar);
        }
      }
    });
  });

  group('Soru okuma metni', () {
    test('soru, şıklar ve (cevaplandıysa) doğru cevap okunur', () {
      final soru = gercekBanka().sorular.first;
      final once = soruOkumaMetni(soru);
      expect(once, contains('A şıkkı.'));
      expect(once, contains('E şıkkı.'));
      expect(once, isNot(contains('Doğru cevap')));
      expect(soruOkumaMetni(soru, cevapGoster: true), contains('Doğru cevap ${soru.dogru}.'));
    });

    test('bütün soruların okuma metni işaretsiz ve doludur', () {
      for (final s in gercekBanka().sorular) {
        final m = soruOkumaMetni(s, cevapGoster: true);
        expect(m, isNot(contains('**')), reason: s.id);
        expect(m, isNot(contains('|')), reason: s.id);
        expect(m.length, greaterThan(40), reason: s.id);
      }
    });
  });
}
