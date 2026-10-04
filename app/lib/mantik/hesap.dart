/// Hesap makinesinin saf Dart çekirdeği: ifade çözümleyici, biçimleyici ve tuş kuralları.
///
/// İfade dizgesi ekrandaki gibi yazılır: rakamlar, ondalık virgül `,`, `+ − × ÷`, `%`, `( )`.
/// Yüzde, yaygın hesap makinelerindeki gibi çalışır:
/// - `a + b%` = a + a·b/100 (çıkarma da öyle),
/// - `a × b%` = a·b/100, `a ÷ b%` = a ÷ (b/100),
/// - tek başına `b%` = b/100.
library;

/// İfade yazım olarak eksik ya da hatalı (ör. `5 +`, `)(`).
class HesapHatasi implements Exception {
  final String mesaj;
  const HesapHatasi(this.mesaj);

  @override
  String toString() => 'HesapHatasi: $mesaj';
}

/// Sıfıra bölme gibi tanımsız sonuçlar.
class TanimsizHata extends HesapHatasi {
  const TanimsizHata() : super('Tanımsız');
}

const tanimsizYazi = 'Tanımsız';

class Hesap {
  Hesap._();

  static const _islemler = '+−×÷';

  static bool _islemMi(String c) => c.isNotEmpty && _islemler.contains(c);
  static bool _rakamMi(String c) => c.isNotEmpty && c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;

  /// Klavyeden gelebilecek `- * /` ve boşlukları ekran gösterimine çevirir.
  static String normallestir(String s) =>
      s.replaceAll(' ', '').replaceAll('-', '−').replaceAll('*', '×').replaceAll('/', '÷');

  /// [ifade]yi hesaplar. Hatalı ifadede [HesapHatasi], sıfıra bölmede [TanimsizHata] fırlatır.
  static double degerlendir(String ifade) {
    final a = _Ayristirici(normallestir(ifade));
    final (deger, _) = a.tumu();
    if (!deger.isFinite) throw const TanimsizHata();
    return deger;
  }

  /// Sondaki işlemleri/açık parantezi atar, açık parantezleri kapatır: `5 + (3 ×` → `5 + (3)`.
  static String tamamla(String ifade) {
    var s = normallestir(ifade);
    while (s.isNotEmpty && (_islemMi(s[s.length - 1]) || s.endsWith('(') || s.endsWith(','))) {
      s = s.substring(0, s.length - 1);
    }
    var acik = 0;
    for (final c in s.split('')) {
      if (c == '(') acik++;
      if (c == ')') acik--;
    }
    return acik > 0 ? s + ')' * acik : s;
  }

  /// Canlı sonuç önizlemesi: biçimlenmiş sonuç, `Tanımsız` ya da (ifade henüz hesaplanamıyorsa) null.
  static String? onizleme(String ifade) {
    final s = tamamla(ifade);
    if (s.isEmpty) return null;
    try {
      return bicimle(degerlendir(s));
    } on TanimsizHata {
      return tanimsizYazi;
    } on HesapHatasi {
      return null;
    }
  }

  /// Türkçe biçim: binlik `.`, ondalık `,`, en çok 6 ondalık, sondaki sıfırlar atılır (1.234.567,5).
  /// [gruplu] false ise binlik ayracı konmaz (kopyalama ve ifadeye geri yazma için).
  static String bicimle(double x, {bool gruplu = true}) {
    if (!x.isFinite) return tanimsizYazi;
    if (x.abs() >= 1e21) return x.toStringAsExponential(6).replaceFirst(RegExp(r'\.?0+e'), 'e').replaceAll('.', ',');
    var s = x.toStringAsFixed(6);
    if (s.contains('.')) s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    if (s == '-0') s = '0';
    final eksi = s.startsWith('-');
    if (eksi) s = s.substring(1);
    final parcalar = s.split('.');
    final tam = gruplu ? _grupla(parcalar[0]) : parcalar[0];
    return '${eksi ? '-' : ''}$tam${parcalar.length > 1 ? ',${parcalar[1]}' : ''}';
  }

  static String _grupla(String rakamlar) {
    final b = StringBuffer();
    for (var i = 0; i < rakamlar.length; i++) {
      if (i > 0 && (rakamlar.length - i) % 3 == 0) b.write('.');
      b.write(rakamlar[i]);
    }
    return b.toString();
  }

  /// Ekranda gösterilecek ifade: ikili işlemlerin çevresinde boşluk, sayılarda binlik ayracı.
  static String goruntu(String ifade) {
    final s = normallestir(ifade);
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      final onceki = i > 0 ? s[i - 1] : '';
      final ikili = _islemMi(c) && (_rakamMi(onceki) || onceki == ')' || onceki == '%' || onceki == ',');
      b.write(ikili ? ' $c ' : c);
    }
    final r = b.toString();
    return r.replaceAllMapped(RegExp(r'\d+'), (m) => m.start > 0 && r[m.start - 1] == ',' ? m[0]! : _grupla(m[0]!));
  }

  static final _sonSayi = RegExp(r'(\d+(,\d*)?|,\d*)$');

  /// Bir tuş basışını ifadeye uygular (`=` hariç; onu arayüz yönetir). Geçersiz basışlar yok sayılır.
  static String tusla(String ifade, String tus) {
    final s = ifade;
    final son = s.isEmpty ? '' : s[s.length - 1];
    final sayi = _sonSayi.firstMatch(s);
    String kes(String x) => x.substring(0, x.length - 1);

    switch (tus) {
      case 'C':
        return '';
      case '⌫':
        return s.isEmpty ? s : kes(s);
      case ',':
        if (son == ')' || son == '%') return '$s×0,';
        if (sayi != null) return sayi[0]!.contains(',') ? s : '$s,';
        return '${s}0,';
      case '+' || '−' || '×' || '÷':
        if (s.isEmpty) return tus == '−' ? '−' : s;
        if (son == '(') return tus == '−' ? '$s−' : s;
        if (_islemMi(son)) {
          if (tus == '−' && (son == '×' || son == '÷')) return '$s−';
          var k = s;
          while (k.isNotEmpty && _islemMi(k[k.length - 1])) {
            k = kes(k);
          }
          if (k.isEmpty || k.endsWith('(')) return s;
          return '$k$tus';
        }
        return '${son == ',' ? kes(s) : s}$tus';
      case '%':
        if (_rakamMi(son) || son == ')') return '$s%';
        return son == ',' ? '${kes(s)}%' : s;
      case '(':
        if (s.isEmpty || _islemMi(son) || son == '(') return '$s(';
        return '${son == ',' ? kes(s) : s}×(';
      case ')':
        final acik = '('.allMatches(s).length - ')'.allMatches(s).length;
        return acik > 0 && (_rakamMi(son) || son == ')' || son == '%') ? '$s)' : s;
      case '±':
        return _isaretDegistir(s, sayi);
      default:
        if (tus.length == 1 && _rakamMi(tus)) {
          if (son == ')' || son == '%') return '$s×$tus';
          if (sayi != null && sayi[0] == '0') return '${kes(s)}$tus';
          return '$s$tus';
        }
        return s;
    }
  }

  static String _isaretDegistir(String s, RegExpMatch? sayi) {
    if (s.isEmpty) return '−';
    if (sayi == null && (s.endsWith(')') || s.endsWith('%') || s.endsWith(','))) return s;
    final i = sayi?.start ?? s.length;
    final onceki = i > 0 ? s[i - 1] : '';
    String degistir(String c) => s.substring(0, i - 1) + c + s.substring(i);
    if (onceki == '' || onceki == '(' || onceki == '×' || onceki == '÷') {
      return '${s.substring(0, i)}−${s.substring(i)}';
    }
    if (onceki == '+') return degistir('−');
    if (onceki == '−') {
      final tekli = i - 1 == 0 || '(+−×÷'.contains(s[i - 2]);
      return tekli ? s.substring(0, i - 1) + s.substring(i) : degistir('+');
    }
    return s;
  }
}

/// Özyinelemeli iniş: ifade → terim ((+|−) terim)*, terim → çarpan ((×|÷) çarpan)*, çarpan → (+|−)çarpan | birincil %*.
/// Her değerle birlikte "yüzde mi" bayrağı taşınır; yalnızca toplama/çıkarmada anlam kazanır.
class _Ayristirici {
  final String s;
  int i = 0;

  _Ayristirici(this.s);

  (double, bool) tumu() {
    if (s.isEmpty) throw const HesapHatasi('Boş ifade');
    final r = ifade();
    if (i < s.length) throw HesapHatasi('Beklenmeyen karakter: ${s[i]}');
    return r;
  }

  bool _gor(String a, [String? b]) => i < s.length && (s[i] == a || s[i] == b);

  (double, bool) ifade() {
    var (sol, yuzde) = terim();
    while (_gor('+', '−')) {
      final toplama = s[i++] == '+';
      final (sag, sagYuzde) = terim();
      final d = sagYuzde ? sol * sag : sag;
      sol = toplama ? sol + d : sol - d;
      yuzde = false;
    }
    return (sol, yuzde);
  }

  (double, bool) terim() {
    var (sol, yuzde) = carpan();
    while (_gor('×', '÷')) {
      final carpma = s[i++] == '×';
      final (sag, _) = carpan();
      if (!carpma && sag == 0) throw const TanimsizHata();
      sol = carpma ? sol * sag : sol / sag;
      yuzde = false;
    }
    return (sol, yuzde);
  }

  (double, bool) carpan() {
    if (_gor('−')) {
      i++;
      final (v, y) = carpan();
      return (-v, y);
    }
    if (_gor('+')) {
      i++;
      return carpan();
    }
    var (v, y) = birincil();
    while (_gor('%')) {
      i++;
      v /= 100;
      y = true;
    }
    return (v, y);
  }

  (double, bool) birincil() {
    if (_gor('(')) {
      i++;
      final r = ifade();
      if (!_gor(')')) throw const HesapHatasi('Parantez kapanmadı');
      i++;
      return (r.$1, r.$2);
    }
    final m = RegExp(r'\d+(,\d*)?|,\d+').matchAsPrefix(s, i);
    if (m == null) throw const HesapHatasi('Sayı bekleniyordu');
    i = m.end;
    var t = m[0]!;
    if (t.startsWith(',')) t = '0$t';
    if (t.endsWith(',')) t = t.substring(0, t.length - 1);
    return (double.parse(t.replaceAll(',', '.')), false);
  }
}
