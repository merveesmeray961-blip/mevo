/// Sesli okuma için metin hazırlığı (saf mantık; ses motoruna bağımlı değildir, bu yüzden test edilebilir).
///
/// Ekranda gösterilen sade Markdown (başlık, madde, kalın, tablo, not kutusu) olduğu gibi okunsa "yıldız yıldız"
/// ya da "dikey çizgi" gibi seslendirilir; "KDV", "VUK", "31.12.2026", "TL'ye", "md. 5/1" gibi yazımlar da cihaz
/// sesinde bozuk çıkar. Bu dosya metni bir insanın sesli okuyacağı gibi düz Türkçe cümlelere çevirir ve cümle
/// cümle okunabilecek parçalara böler (cümleler arası doğal duraklama, ileri/geri atlama için).
library;

import '../veri/modeller.dart';

/// Çoğu cihaz ses motoru tek seferde yaklaşık 4000 karakter okur; güvenli pay bırakılır.
const sesParcaSiniri = 1500;

/// Cümle cümle okumada bir parçanın en uzun hali (uzun tablo satırları ve madde listeleri bölünür).
const cumleSiniri = 320;

const _simgeler = {
  '₺': ' lira ',
  '&': ' ve ',
  '→': ', sonra ',
  '⇒': ', sonra ',
  '≥': ' büyük eşit ',
  '≤': ' küçük eşit ',
  '≠': ' eşit değil ',
  '≈': ' yaklaşık ',
  '×': ' çarpı ',
  '÷': ' bölü ',
  '±': ' artı eksi ',
  '√': ' karekök ',
  '°': ' derece',
  '…': '.',
  '—': ', ',
  '•': ', ',
};

/// Noktalı kısaltmalar: sözcük sınırında, büyük/küçük harf duyarsız.
const _noktaliKisaltmalar = {
  r'vb\.': 've benzeri',
  r'vs\.': 'vesaire',
  r'bkz\.': 'bakınız',
  r'örn\.': 'örneğin',
  r'ör\.': 'örneğin',
  r'par\.': 'paragraf',
  r'mük\.': 'mükerrer',
  r'yön\.': 'yönetmelik',
  r'tebl\.': 'tebliğ',
  r'no\.': 'numara',
  r'sy\.': 'sayılı',
  r'çev\.': 'çeviren',
  r'Ltd\.\s*Şti\.': 'limited şirketi',
  r'A\.\s*Ş\.': 'anonim şirketi',
  r'T\.\s*C\.': 'Türkiye Cumhuriyeti',
};

/// Harf harf okunan kısaltmalarda Türkçe harf adları ("KDV" → "kadeve", "SMMM" → "semememe").
const _harfAdi = {
  'A': 'a', 'B': 'be', 'C': 'ce', 'Ç': 'çe', 'D': 'de', 'E': 'e', 'F': 'fe', 'G': 'ge', 'Ğ': 'yumuşak ge',
  'H': 'he', 'I': 'ı', 'İ': 'i', 'J': 'je', 'K': 'ka', 'L': 'le', 'M': 'me', 'N': 'ne', 'O': 'o', 'Ö': 'ö',
  'P': 'pe', 'Q': 'kü', 'R': 're', 'S': 'se', 'Ş': 'şe', 'T': 'te', 'U': 'u', 'Ü': 'ü', 'V': 've', 'W': 'dabılyu',
  'X': 'iks', 'Y': 'ye', 'Z': 'ze',
};

/// Sözcük gibi okunan büyük harfli kısaltmalar (harf harf okunmaz).
const _sozcukKisaltmalar = {
  'TÜRMOB', 'TESMER', 'FIFO', 'LIFO', 'EBOB', 'EKOK', 'TÜFE', 'ÜFE', 'FAVÖK', 'KOBİ', 'BOBİ', 'TÜİK', 'BİST',
  'NATO', 'SEDDK', 'TOKİ', 'ASAL', 'NAFTA', 'UNESCO', 'OECD',
};

/// Bazı kısaltmaların doğal okunuşu.
const _ozelOkunus = {
  'TL': 'lira',
  'USD': 'dolar',
  'EUR': 'avro',
  'ABD': 'abede',
  'TBMM': 'tebeemem',
  'TCMB': 'merkez bankası',
  'RG': 'resmî gazete',
  'IFRS': 'ayefaares',
  'KAYİK': 'kayık',
  'IFAC': 'ifak',
  'IASB': 'ayeyesbi',
  'IESBA': 'iesba',
  'IAASB': 'ayeyeyesbi',
  'ISSB': 'ayesesbi',
  'ROI': 'ar o ay',
  'CIF': 'sif',
  'FOB': 'fob',
};

const _aylar = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];

const _romaSayilari = {'II': 'iki', 'III': 'üç', 'IV': 'dört', 'VI': 'altı', 'VII': 'yedi', 'VIII': 'sekiz', 'IX': 'dokuz'};
const _romaSiralari = {
  'I': 'birinci', 'II': 'ikinci', 'III': 'üçüncü', 'IV': 'dördüncü', 'V': 'beşinci', 'VI': 'altıncı',
  'VII': 'yedinci', 'VIII': 'sekizinci', 'IX': 'dokuzuncu', 'X': 'onuncu',
};

const _buyuk = 'A-ZÇĞİÖŞÜ';
const _unluler = 'AEIİOÖUÜ';

/// "TL'ye" gibi bir kısaltma kalın ünlülü bir sözcükle ("lira") okununca ekin de uyması gerekir: ye → ya, den → dan.
String _ekiKalinlastir(String ek) {
  var e = ek.replaceAll('e', 'a').replaceAll('i', 'ı').replaceAll('ü', 'u').replaceAll('ö', 'o');
  if (e.startsWith('t')) e = 'd${e.substring(1)}'; // TL'ten → liradan ("lira" ünlüyle biter)
  if (e.startsWith('ı') || e.startsWith('a') || e.startsWith('u')) {
    // Ünlüyle başlayan ek ünlüyle biten sözcüğe "y" ya da "n" kaynaştırmasıyla eklenir: lira + ı → lirayı.
    e = 'y$e';
  }
  return e;
}

/// Büyük harfli tek bir sözcüğü (kısaltmayı) okunuşuna çevirir.
String _kisaltmaOku(String k) {
  if (_ozelOkunus.containsKey(k)) return _ozelOkunus[k]!;
  if (_romaSayilari.containsKey(k)) return _romaSayilari[k]!;
  if (_sozcukKisaltmalar.contains(k)) return _kucult(k);
  final unlu = k.split('').where((h) => _unluler.contains(h)).length;
  // Ünlüsü bol, Türkçe hece yapısına uyan uzun büyük harfli sözcük ("DİKKAT", "ÖNEMLİ") düz okunur.
  if (k.length >= 5 && unlu >= 2 && !RegExp('[$_unluler]{2}').hasMatch(k) && RegExp('^(?:[^$_unluler]?[$_unluler][^$_unluler]{0,2})+\$').hasMatch(k)) {
    return _kucult(k);
  }
  return k.split('').map((h) => _harfAdi[h] ?? h).join();
}

String _kucult(String s) => s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

/// Markdown işaretlerini, simgeleri ve kısaltmaları kaldırıp konuşmaya uygun düz metin üretir.
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
    s = s.replaceFirst(RegExp(r'^(?:[-*•]|\d+[.)])\s+'), ''); // madde işareti
    s = s.replaceFirstMapped(RegExp(r'^\(?([a-zçğıöşü])\)\s+'), (m) => '${m.group(1)}. '); // "a) Uyarma" → "a. Uyarma"
    s = s.replaceAll('**', '').replaceAll('__', '').replaceAll('`', '');
    s = s.replaceAll(RegExp(r'(?<=\S)\s\*\s(?=\S)'), ' çarpı ').replaceAll('*', '');
    // Başlık ve madde sonunda nokta yoksa eklenir: ses motoru orada durur, cümleler birbirine karışmaz.
    if (s.isNotEmpty && !RegExp(r'[.!?:;,]$').hasMatch(s)) s = '$s.';
    satirlar.add(s);
  }
  var d = satirlar.join('\n');

  // Mutlak değer |x| → "mutlak değer x"; satır içinde kalan tek tük çizgi virgüle dönüşür.
  d = d.replaceAllMapped(RegExp(r'\|([^|\n]{1,40}?)\|'), (m) => 'mutlak değer ${m.group(1)}');
  d = d.replaceAll('|', ', ');

  // Madde numaraları: "md. 26/1-(ç)" → "madde 26, fıkra 1, bent ç"; "md. 32/C" → "madde 32 C".
  d = d.replaceAllMapped(
    RegExp(r'\bmd\.\s*(\d+)(?:/(\d+))?(?:/([A-ZÇĞİÖŞÜa-zçğıöşü])\b)?(?:-\(([a-zçğıöşü])\))?', caseSensitive: false),
    (m) {
      final fikra = m.group(2) == null ? '' : ', fıkra ${m.group(2)}';
      final harf = m.group(3) == null ? '' : ' ${m.group(3)!.toUpperCase()}';
      final bent = m.group(4) == null ? '' : ', bent ${m.group(4)}';
      return 'madde ${m.group(1)}$fikra$harf$bent';
    },
  );
  d = d.replaceAllMapped(RegExp(r'\b(\d+)\s*s\.\s*(?=[$_buyuk])'), (m) => '${m.group(1)} sayılı ');

  // Tarih: 31.12.2026 → 31 Aralık 2026
  d = d.replaceAllMapped(RegExp(r'\b(\d{1,2})[./](\d{1,2})[./](\d{4})\b'), (m) {
    final ay = int.parse(m.group(2)!);
    if (ay < 1 || ay > 12) return m.group(0)!;
    return '${int.parse(m.group(1)!)} ${_aylar[ay - 1]} ${m.group(3)}';
  });

  // Para: "₺1.000" / "1.000 ₺'dır" → "1.000 lira" / "1.000 liradır" (sayı önce, birim sonra okunur).
  d = d.replaceAllMapped(RegExp(r"₺\s?(\d[\d.,]*)(?:['’]([a-zçğıöşü]+))?"), (m) => '${m.group(1)} lira${m.group(2) ?? ''}');
  d = d.replaceAllMapped(RegExp(r"₺['’]([a-zçğıöşü]+)"), (m) => 'lira${m.group(1)}');
  d = d.replaceAll('ve/veya', 've veya');

  // Yüzde: %20 → yüzde 20; %0,5 → yüzde 0,5
  d = d.replaceAllMapped(RegExp(r'%\s*(\d)'), (m) => 'yüzde ${m.group(1)}');
  d = d.replaceAll('%', ' yüzde ');

  // Noktalı kısaltmalar
  _noktaliKisaltmalar.forEach((k, v) {
    d = d.replaceAll(RegExp('(?<![\\wçğıöşüÇĞİÖŞÜ])$k', caseSensitive: false), v);
  });

  // TL'ye, TL'den, KDV'nin… : önce özel ek uyumu (TL → lira), sonra genel kısaltma okunuşu.
  d = d.replaceAllMapped(RegExp(r"\bTL['’]([a-zçğıöşü]+)"), (m) => 'lira${_ekiKalinlastir(m.group(1)!)}');

  // Roma rakamıyla sıra: "II. Tertip" → "ikinci Tertip" (yalnız ardından büyük harfli sözcük gelirse).
  d = d.replaceAllMapped(RegExp('\\b(I{1,3}|IV|VI{0,3}|IX|X)\\.\\s+(?=[$_buyuk])'), (m) => '${_romaSiralari[m.group(1)]} ');
  // Tek başına Roma rakamları (şıklardaki "I ve II", "Yalnız III", "I, II ve IV"): sayı olarak okunur; yoksa ses
  // motoru "I"yı Türkçe "ı" harfi, "II"yi "ı ı" diye okuyor.
  d = d.replaceAllMapped(
    RegExp('(?<![\\wçğıöşü$_buyuk])(I{1,3}|IV|V)(?![\\wçğıöşü$_buyuk.])'),
    (m) => const {'I': 'bir', 'II': 'iki', 'III': 'üç', 'IV': 'dört', 'V': 'beş'}[m.group(1)]!,
  );

  // Büyük harfli kısaltmalar
  d = d.replaceAllMapped(
    RegExp('(?<![\\wçğıöşü$_buyuk])([$_buyuk]{2,7})(?![a-zçğıöşü$_buyuk])'),
    (m) => _kisaltmaOku(m.group(1)!),
  );

  // Matematik işaretleri (yalnız boşlukla ya da rakamla çevrili olanlar; kısa çizgili sözcükler bozulmaz).
  d = d.replaceAll(RegExp(r'\s=\s|(?<=\d)=(?=\d)'), ' eşittir ');
  d = d.replaceAll(RegExp(r'\s\+\s|(?<=\d)\+(?=\d)'), ' artı ');
  d = d.replaceAll(RegExp(r'(?<=\d)\+'), ' artı');
  d = d.replaceAll(RegExp(r'\s[−-]\s'), ' eksi ');
  d = d.replaceAllMapped(RegExp(r'(^|[\s(])[−-](?=\d)'), (m) => '${m.group(1)}eksi ');
  d = d.replaceAll('−', ' eksi ');
  d = d.replaceAll(RegExp(r'\s>\s'), ' büyüktür ').replaceAll(RegExp(r'\s<\s'), ' küçüktür ');
  d = d.replaceAll('^', ' üssü ').replaceAll('=', ' eşittir ');
  // Aralık: 2024–2026, 1-3 gün → "2024 ile 2026", "1 ile 3 gün"
  d = d.replaceAllMapped(RegExp(r'(\d)\s*[–-]\s*(\d)'), (m) => '${m.group(1)} ile ${m.group(2)}');
  d = d.replaceAll('–', ', ');
  // Eğik çizgi: "7/A" → "7 A"; "gelir/gider" → "gelir ya da gider"; sayı/sayı olduğu gibi (bölü) kalır.
  d = d.replaceAllMapped(RegExp(r'(\d)/([A-ZÇĞİÖŞÜa-zçğıöşü])\b'), (m) => '${m.group(1)} ${m.group(2)!.toUpperCase()}');
  d = d.replaceAllMapped(RegExp(r'(\d)\s*/\s*(\d)'), (m) => '${m.group(1)} bölü ${m.group(2)}');
  d = d.replaceAll(RegExp(r'\s*/\s*'), ' ya da ');

  _simgeler.forEach((k, v) => d = d.replaceAll(k, v));

  // Kapanan parantezden sonra gelen ek ("(KGK)'dur") okunmaz; parantezler ve köşeli ayraçlar doğal bir duraklamaya dönüşür.
  d = d.replaceAllMapped(RegExp(r'''([)\]"”])['’][a-zçğıöşü]+'''), (m) => m.group(1)!);
  d = d.replaceAll(RegExp(r'\s*[(\[]\s*'), ', ').replaceAll(RegExp(r'\s*[)\]]\s*'), ', ');
  d = d.replaceAll('"', '').replaceAll('“', '').replaceAll('”', '');

  // Temizlik: art arda noktalama ve boşluklar.
  d = d.replaceAll(RegExp(r'[ \t]+'), ' ');
  d = d.replaceAllMapped(RegExp(r'\s+([,.;:!?])'), (m) => m.group(1)!);
  d = d.replaceAll(RegExp(r',+'), ',');
  d = d.replaceAll(RegExp(r',(?=[.;:!?])'), '');
  d = d.replaceAllMapped(RegExp(r'([.;:!?]),'), (m) => m.group(1)!);
  d = d.replaceAll(RegExp(r"(?<=[,.;:!?\s])['’]"), '');
  d = d.replaceAll(RegExp(r'^[ ,]+|[ ,]+$', multiLine: true), '');
  d = d.replaceAll(RegExp(r'\.{2,}'), '.');
  d = d.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return d.trim();
}

/// Metni, cümle ya da satır sınırında bölerek en çok [sinir] karakterlik parçalara ayırır.
/// Hiçbir parça boş olmaz; birleştirilince (boşluk farkı dışında) özgün metni verir.
List<String> sesParcalari(String metin, {int sinir = sesParcaSiniri}) {
  final temiz = metin.trim();
  if (temiz.isEmpty) return const [];
  final cumleler = _cumleyeBol(temiz);
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

/// Sayıların içindeki noktaları ("1.000", "26.1") ve sıra sayılarını ("3. madde") cümle sonu saymadan böler.
List<String> _cumleyeBol(String metin) =>
    metin.split(RegExp(r'(?<=[.!?;:])(?<!\d\.)(?<!(?:^|[\s(])[A-ZÇĞİÖŞÜa-zçğıöşü]\.)\s+|\n+|(?<=\d\.)\s+(?=[A-ZÇĞİÖŞÜ])'));

/// Cümle cümle okuma için parçalar: her biri tek cümle (ya da [cumleSiniri]'nı aşan cümlenin bir bölümü).
/// Çok kısa parçalar (tek sözcüklük başlık gibi) bir sonrakiyle birleştirilmez; başlıkta duraklamak doğaldır.
List<String> okumaCumleleri(String metin, {int sinir = cumleSiniri}) {
  final sonuc = <String>[];
  for (var c in _cumleyeBol(metin.trim())) {
    c = c.trim();
    if (c.isEmpty || !RegExp(r'[\wçğıöşüÇĞİÖŞÜ]').hasMatch(c)) continue;
    while (c.length > sinir) {
      // Önce virgülde, olmazsa boşlukta bölünür.
      var kesim = c.lastIndexOf(', ', sinir);
      if (kesim < sinir ~/ 3) kesim = c.lastIndexOf(' ', sinir);
      if (kesim <= 0) kesim = sinir;
      sonuc.add(c.substring(0, kesim + (c[kesim] == ',' ? 1 : 0)).trim());
      c = c.substring(kesim + 1).trim();
    }
    if (c.isNotEmpty) sonuc.add(c);
  }
  return sonuc;
}

/// Bir konu anlatımının okunacak metni: başlık ve gövde.
String anlatimOkumaMetni(KonuAnlatimi a) => '${konusmaMetni(a.baslik)}\n${konusmaMetni(a.metin)}';

/// Bir sorunun okunacak metni. [cevapGoster] true ise doğru cevap ve gerekçe de okunur.
String soruOkumaMetni(Soru s, {bool cevapGoster = false}) {
  final b = StringBuffer(konusmaMetni(s.kok));
  b.write('\n');
  for (final h in harfler) {
    final m = s.secenekler[h];
    if (m != null) b.write('\n$h şıkkı: ${konusmaMetni(m)}');
  }
  if (cevapGoster) {
    b.write('\n\nDoğru cevap ${s.dogru} şıkkı. ${konusmaMetni(s.dogruNeden)}');
  }
  return b.toString().trim();
}

/// Cevap kutusunun okunacak metni: sonuç, seçilen yanlış şıkkın nedeni, çözüm ve adımlar.
String cozumOkumaMetni(Soru s, String? secilen) {
  final b = StringBuffer();
  if (secilen == null) {
    b.write('Boş bıraktın. Doğru cevap ${s.dogru} şıkkı.');
  } else if (secilen == s.dogru) {
    b.write('Doğru! Cevap ${s.dogru} şıkkı.');
  } else {
    b.write('Yanlış. Doğru cevap ${s.dogru} şıkkı.');
    final neden = s.celdiriciler[secilen];
    if (neden != null) b.write('\nNeden $secilen değil? ${konusmaMetni(neden)}');
  }
  b.write('\nÇözüm. ${konusmaMetni(s.dogruNeden)}');
  for (var i = 0; i < s.hesapAdimlari.length; i++) {
    b.write('\nAdım ${i + 1}. ${konusmaMetni(s.hesapAdimlari[i])}');
  }
  return b.toString().trim();
}
