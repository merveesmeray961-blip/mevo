/// Sesli okuma için metin hazırlığı (saf mantık; ses motoruna bağımlı değildir, bu yüzden test edilebilir).
///
/// Ekranda gösterilen sade Markdown (başlık, madde, kalın, tablo, not kutusu) olduğu gibi okunsa "yıldız yıldız"
/// ya da "dikey çizgi" gibi seslendirilir. Bu dosya metni konuşmaya uygun düz cümlelere çevirir ve uzun metni
/// ses motorunun sınırına sığacak parçalara böler.
library;

import '../veri/modeller.dart';

/// Çoğu cihaz ses motoru tek seferde yaklaşık 4000 karakter okur; güvenli pay bırakılır.
const sesParcaSiniri = 1500;

/// Okunurken "tl", "kdv" gibi kısaltmaların harf harf okunmasını önleyen küçük sözlük (yalnız bütün sözcük).
const _kisaltmalar = {
  '₺': ' lira',
  '%': ' yüzde ',
  '&': ' ve ',
  '→': ' sonra ',
  '≥': ' en az ',
  '≤': ' en çok ',
  '×': ' çarpı ',
  '÷': ' bölü ',
  '–': ', ',
  '—': ', ',
};

/// Markdown işaretlerini ve tablo çizgilerini kaldırıp konuşmaya uygun düz metin üretir.
String konusmaMetni(String metin) {
  final satirlar = <String>[];
  for (final ham in metin.split('\n')) {
    var s = ham.trim();
    if (s.isEmpty) {
      satirlar.add('');
      continue;
    }
    // Tablo ayırıcı satırı (|---|---|) atlanır; tablo satırı virgüllü cümleye dönüşür.
    if (RegExp(r'^\|?[\s:\-|]+\|?$').hasMatch(s) && s.contains('-')) continue;
    if (s.startsWith('|')) {
      s = s.replaceAll(RegExp(r'^\||\|$'), '').split('|').map((h) => h.trim()).where((h) => h.isNotEmpty).join(', ');
    }
    s = s.replaceFirst(RegExp(r'^#{1,6}\s+'), ''); // başlık işareti
    s = s.replaceFirst(RegExp(r'^>\s?'), ''); // not kutusu
    s = s.replaceFirst(RegExp(r'^(?:[-*•]|\d+\.)\s+'), ''); // madde işareti
    s = s.replaceAll('**', '').replaceAll('`', '');
    satirlar.add(s);
  }
  var duz = satirlar.join('\n');
  // Mutlak değer |x| → "mutlak değer x"; satır içinde kalan tek tük çizgi ("Ürün | 2024 | 2025") virgüle dönüşür.
  duz = duz.replaceAllMapped(RegExp(r'\|([^|\n]{1,40}?)\|'), (m) => 'mutlak değer ${m.group(1)}');
  duz = duz.replaceAll('|', ', ');
  _kisaltmalar.forEach((k, v) => duz = duz.replaceAll(k, v));
  // Madde numaraları: "md. 26/1-(ç)" → "madde 26, fıkra 1, bent ç"
  duz = duz.replaceAllMapped(RegExp(r'\bmd\.\s*(\d+)(?:/(\d+))?(?:-\(([a-zçğıöşü])\))?', caseSensitive: false), (m) {
    final fikra = m.group(2) == null ? '' : ', fıkra ${m.group(2)}';
    final bent = m.group(3) == null ? '' : ', bent ${m.group(3)}';
    return 'madde ${m.group(1)}$fikra$bent';
  });
  duz = duz.replaceAll(RegExp(r'[ \t]+'), ' ').replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return duz.trim();
}

/// Metni, cümle ya da satır sınırında bölerek en çok [sinir] karakterlik parçalara ayırır.
/// Hiçbir parça boş olmaz; birleştirilince (boşluk farkı dışında) özgün metni verir.
List<String> sesParcalari(String metin, {int sinir = sesParcaSiniri}) {
  final temiz = metin.trim();
  if (temiz.isEmpty) return const [];
  final cumleler = temiz.split(RegExp(r'(?<=[.!?:;])\s+|\n+'));
  final parcalar = <String>[];
  var simdiki = StringBuffer();
  void bitir() {
    final s = simdiki.toString().trim();
    if (s.isNotEmpty) parcalar.add(s);
    simdiki = StringBuffer();
  }

  for (var c in cumleler) {
    c = c.trim();
    if (c.isEmpty) continue;
    // Tek başına sınırı aşan uzun cümle, kelime sınırında bölünür.
    while (c.length > sinir) {
      var kesim = c.lastIndexOf(' ', sinir);
      if (kesim <= 0) kesim = sinir;
      bitir();
      parcalar.add(c.substring(0, kesim).trim());
      c = c.substring(kesim).trim();
    }
    if (simdiki.length + c.length + 1 > sinir) bitir();
    if (simdiki.isNotEmpty) simdiki.write(' ');
    simdiki.write(c);
  }
  bitir();
  return parcalar;
}

/// Bir konu anlatımının okunacak metni: başlık, ders adı ve gövde.
String anlatimOkumaMetni(KonuAnlatimi a) => '${a.baslik}.\n${konusmaMetni(a.metin)}';

/// Bir sorunun okunacak metni. [cevapGoster] true ise doğru cevap ve gerekçe de okunur.
String soruOkumaMetni(Soru s, {bool cevapGoster = false}) {
  final b = StringBuffer(konusmaMetni(s.kok));
  b.write('\n');
  for (final h in harfler) {
    final m = s.secenekler[h];
    if (m != null) b.write('\n$h şıkkı. ${konusmaMetni(m)}');
  }
  if (cevapGoster) {
    b.write('\n\nDoğru cevap ${s.dogru}. ${konusmaMetni(s.dogruNeden)}');
  }
  return b.toString().trim();
}
