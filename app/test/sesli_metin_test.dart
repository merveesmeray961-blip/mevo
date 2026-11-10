import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/urun.dart';
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

    test('şıklardaki Roma rakamları sayı olarak okunur', () {
      expect(konusmaMetni('I ve II'), startsWith('bir ve iki'));
      expect(konusmaMetni('I, II ve III'), startsWith('bir, iki ve üç'));
      expect(konusmaMetni('Yalnız IV'), startsWith('Yalnız dört'));
      expect(konusmaMetni('II. Tertip'), contains('ikinci'));
    });

    test('kısaltmalar Türkçe harf adlarıyla, tarihler ve para doğal okunur', () {
      expect(konusmaMetni("KDV'nin oranı"), contains("kadeve'nin"));
      expect(konusmaMetni('VUK ve TTK hükümleri'), contains('veuka ve teteka'));
      expect(konusmaMetni('TÜRMOB ve TESMER'), contains('türmob ve tesmer'));
      expect(konusmaMetni('Son gün 31.12.2026 tarihidir'), contains('31 Aralık 2026'));
      expect(konusmaMetni("Tutar 1.000 TL'ye ulaşır"), contains('1.000 liraya'));
      expect(konusmaMetni("Tutar 5.000 TL'den azdır"), contains('5.000 liradan'));
      expect(konusmaMetni('Bedel ₺1.000 olur'), contains('1.000 lira'));
      expect(konusmaMetni("Bedel 2.500 ₺'dır"), contains('2.500 liradır'));
      expect(konusmaMetni('GVK md. 32/C kapsamında'), contains('madde 32 C'));
      expect(konusmaMetni('A = B + C'), contains('eşittir'));
      expect(konusmaMetni('vb. giderler (örn. kira)'), allOf(contains('ve benzeri'), contains('örneğin kira')));
      expect(konusmaMetni('2024–2026 döneminde'), contains('2024 ile 2026'));
      expect(konusmaMetni('II. Tertip'), contains('ikinci Tertip'));
    });

    test('cümle cümle bölmede sayılardaki noktalar cümle sonu sayılmaz', () {
      final c = okumaCumleleri('Sermaye 1.000.000 liradır. Kâr 250.000 liradır.\nBaşlık.');
      expect(c, ['Sermaye 1.000.000 liradır.', 'Kâr 250.000 liradır.', 'Başlık.']);
      final uzun = List.filled(60, 'uzun bir madde,').join(' ');
      for (final p in okumaCumleleri(uzun)) {
        expect(p.length, lessThanOrEqualTo(cumleSiniri));
      }
    });

    test('örnek okuma metinleri (inceleme için build/ses_ornek_*.txt)', () {
      for (final u in Urun.values) {
        final banka = gercekBanka(u);
        final b = StringBuffer();
        for (final a in banka.anlatimlar.values.take(3)) {
          b.writeln('=== ${a.anahtar}');
          for (final c in okumaCumleleri(anlatimOkumaMetni(a)).take(80)) {
            b.writeln(c);
          }
        }
        Directory('build').createSync(recursive: true);
        File('build/ses_ornek_${u.kod}.txt').writeAsStringSync(b.toString());
      }
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
      expect(once, contains('A şıkkı:'));
      expect(once, contains('E şıkkı:'));
      expect(once, isNot(contains('Doğru cevap')));
      expect(soruOkumaMetni(soru, cevapGoster: true), contains('Doğru cevap ${soru.dogru} şıkkı.'));
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
