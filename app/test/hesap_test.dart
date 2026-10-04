import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/mantik/hesap.dart';

double h(String s) => Hesap.degerlendir(s);

/// Tuşları sırayla uygular ("=" hariç).
String tuslar(String tuslar) {
  var s = '';
  for (final t in tuslar.split('')) {
    s = Hesap.tusla(s, t);
  }
  return s;
}

void main() {
  group('işlem önceliği ve parantez', () {
    test('çarpma/bölme toplamadan önce', () {
      expect(h('2+3×4'), 14);
      expect(h('10−6÷2'), 7);
      expect(h('2×3+4×5'), 26);
      expect(h('100÷5÷2'), 10);
      expect(h('10−3−2'), 5);
    });

    test('parantez önceliği ve iç içe parantez', () {
      expect(h('(2+3)×4'), 20);
      expect(h('2×(3+(4−1))'), 12);
      expect(h('((7))'), 7);
      expect(h('(1+2)×(3+4)'), 21);
    });

    test('klavye karakterleri ve boşluklar', () {
      expect(h('2 * (3 - 1) / 4'), 1);
    });

    test('eksik ya da hatalı ifade HesapHatasi fırlatır', () {
      for (final s in ['', '5+', '(2+3', '2+3)', '×5', '()', ',']) {
        expect(() => h(s), throwsA(isA<HesapHatasi>()), reason: s);
      }
    });
  });

  group('virgüllü ondalık ve negatif sayılar', () {
    test('ondalık virgül', () {
      expect(h('1,5+2,25'), 3.75);
      expect(h(',5×4'), 2);
      expect(h('5,×2'), 10);
      expect(h('0,1+0,2'), closeTo(0.3, 1e-12));
    });

    test('negatif sayılar ve tekli eksi', () {
      expect(h('−5+3'), -2);
      expect(h('5×−3'), -15);
      expect(h('−(2+3)'), -5);
      expect(h('4−−2'), 6);
      expect(h('(−2)×(−3)'), 6);
      expect(h('−2×3'), -6);
    });
  });

  group('yüzde kuralları', () {
    test('tek başına b% = b/100', () {
      expect(h('50%'), 0.5);
      expect(h('(10+30)%'), 0.4);
    });

    test('a + b% = a + a·b/100, a − b% benzer', () {
      expect(h('200+10%'), 220);
      expect(h('200−10%'), 180);
      expect(h('1250+12%'), 1400);
    });

    test('a × b% = a·b/100, a ÷ b% = a/(b/100)', () {
      expect(h('1250×12%'), 150);
      expect(h('50×10%'), 5);
      expect(h('50÷50%'), 100);
    });

    test('zincirleme: birikmiş sonuca uygulanır; çarpım teriminde yüzde toplama kuralı dışında kalır', () {
      expect(h('200+10%+5%'), closeTo(231, 1e-9));
      expect(h('5+10×20%'), 7);
      expect(h('100+−5%'), 95);
    });
  });

  group('sıfıra bölme', () {
    test('Tanımsız', () {
      expect(() => h('5÷0'), throwsA(isA<TanimsizHata>()));
      expect(() => h('0÷0'), throwsA(isA<TanimsizHata>()));
      expect(() => h('1÷(2−2)'), throwsA(isA<TanimsizHata>()));
      expect(Hesap.onizleme('5÷0'), 'Tanımsız');
    });
  });

  group('biçimleme', () {
    test('Türkçe binlik ve ondalık', () {
      expect(Hesap.bicimle(1234567.5), '1.234.567,5');
      expect(Hesap.bicimle(1250), '1.250');
      expect(Hesap.bicimle(999), '999');
      expect(Hesap.bicimle(1000), '1.000');
      expect(Hesap.bicimle(-1234.25), '-1.234,25');
      expect(Hesap.bicimle(0), '0');
    });

    test('en çok 6 ondalık, sondaki sıfırlar atılır', () {
      expect(Hesap.bicimle(1 / 3), '0,333333');
      expect(Hesap.bicimle(2 / 3), '0,666667');
      expect(Hesap.bicimle(0.1 + 0.2), '0,3');
      expect(Hesap.bicimle(100.0), '100');
      expect(Hesap.bicimle(12.340000), '12,34');
      expect(Hesap.bicimle(-0.0000001), '0');
    });

    test('binliksiz biçim ve sonsuz', () {
      expect(Hesap.bicimle(1234567.5, gruplu: false), '1234567,5');
      expect(Hesap.bicimle(double.infinity), 'Tanımsız');
    });

    test('ekran gösterimi', () {
      expect(Hesap.goruntu('1250×12%'), '1.250 × 12%');
      expect(Hesap.goruntu('−5+3,25'), '−5 + 3,25');
      expect(Hesap.goruntu('2×−3'), '2 × −3');
      expect(Hesap.goruntu('0,12345'), '0,12345');
    });
  });

  group('önizleme ve tamamlama', () {
    test('eksik ifade tamamlanır', () {
      expect(Hesap.tamamla('5+'), '5');
      expect(Hesap.tamamla('2×(3+'), '2×(3)');
      expect(Hesap.onizleme('2×(3+4'), '14');
      expect(Hesap.onizleme(''), isNull);
      expect(Hesap.onizleme('('), isNull);
      expect(Hesap.onizleme('1250×12%'), '150');
    });
  });

  group('tuş kuralları', () {
    test('rakam ve virgül', () {
      expect(tuslar('007'), '7');
      expect(tuslar('1,,5'), '1,5');
      expect(tuslar(','), '0,');
      expect(tuslar('5+,'), '5+0,');
      expect(tuslar('1,5,5'), '1,55');
    });

    test('işlem tuşları birbirini değiştirir', () {
      expect(tuslar('5+×'), '5×');
      expect(tuslar('+'), '');
      expect(tuslar('−5'), '−5');
      expect(tuslar('5×−'), '5×−');
      expect(tuslar('5×−+'), '5+');
      expect(tuslar('5,+'), '5+');
    });

    test('parantez', () {
      expect(tuslar(')'), '');
      expect(tuslar('(2+3)'), '(2+3)');
      expect(tuslar('(2+3))'), '(2+3)');
      expect(tuslar('2('), '2×(');
      expect(tuslar('(2+3)4'), '(2+3)×4');
    });

    test('yüzde yalnızca sayı veya ) sonrası', () {
      expect(tuslar('%'), '');
      expect(tuslar('5%'), '5%');
      expect(tuslar('5+%'), '5+');
      expect(tuslar('1250×12%'), '1250×12%');
    });

    test('± işareti değiştirir', () {
      expect(tuslar('5±'), '−5');
      expect(tuslar('5±±'), '5');
      expect(tuslar('5+3±'), '5−3');
      expect(tuslar('5−3±'), '5+3');
      expect(tuslar('5×3±'), '5×−3');
      expect(tuslar('5×3±±'), '5×3');
      expect(tuslar('±'), '−');
    });

    test('C ve geri sil', () {
      expect(tuslar('12+3C'), '');
      expect(Hesap.tusla('12', '⌫'), '1');
      expect(Hesap.tusla('', '⌫'), '');
    });

    test('tuşlarla yazılan ifade doğru hesaplanır', () {
      expect(h(tuslar('1250×12%')), 150);
      expect(h(tuslar('1250+12%')), 1400);
      expect(h(tuslar('2(3+4)')), 14);
    });
  });
}
