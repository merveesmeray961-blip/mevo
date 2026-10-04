/// Mevzuat ekranının saf mantığı: arama, gruplama ve alıntı vurgusu.
library;

import '../veri/modeller.dart';

const turSirasi = ['kanun', 'yonetmelik', 'teblig', 'standart', 'diger'];

const turBasliklari = {
  'kanun': 'Kanunlar',
  'yonetmelik': 'Yönetmelikler',
  'teblig': 'Tebliğler ve yönergeler',
  'standart': 'Standartlar (yalnızca alıntılar)',
  'diger': 'Diğer kaynaklar',
};

/// Aramaya uyan maddeler; her sözcük (boşlukla ayrılmış) aramaMetni içinde geçmeli.
List<MevzuatMaddesi> mevzuatAra(List<MevzuatMaddesi> liste, String sorgu) {
  final sozcukler = turkceKucult(sorgu).split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
  if (sozcukler.isEmpty) return liste;
  return [
    for (final m in liste)
      if (sozcukler.every(m.aramaMetni.contains)) m,
  ];
}

/// tür → kaynak adı → maddeler (girdi sırası korunur).
Map<String, Map<String, List<MevzuatMaddesi>>> mevzuatGrupla(List<MevzuatMaddesi> liste) {
  final sonuc = <String, Map<String, List<MevzuatMaddesi>>>{};
  for (final m in liste) {
    sonuc.putIfAbsent(m.tur, () => {}).putIfAbsent(m.kaynak, () => []).add(m);
  }
  return {
    for (final t in turSirasi)
      if (sonuc.containsKey(t)) t: sonuc[t]!,
  };
}

/// [alintilar] içindeki birebir parçaların [metin] içinde geçtiği aralıklar (birleştirilmiş, sıralı) ve
/// metinde hiç bulunamayan alıntıların indeksleri. "..." / "…" ile ayrılmış parçalar ayrı aranır.
({List<(int, int)> araliklar, List<int> bulunamayan}) alintiAraliklari(String metin, List<String> alintilar) {
  final ham = <(int, int)>[];
  final yok = <int>[];
  final kucukMetin = turkceKucult(metin); // harf başına bire bir dönüşür; aralıklar özgün metin için de geçerlidir
  for (var i = 0; i < alintilar.length; i++) {
    final parcalar = alintilar[i].split(RegExp(r'\[?(?:\.{3}|…)\]?')).map((p) => p.trim()).where((p) => p.length >= 12);
    var bulundu = false;
    for (final p in parcalar) {
      final desen = turkceKucult(p).split(RegExp(r'\s+')).map(RegExp.escape).join(r'\s+');
      final e = RegExp(desen).firstMatch(kucukMetin);
      if (e != null) {
        ham.add((e.start, e.end));
        bulundu = true;
      }
    }
    if (!bulundu) yok.add(i);
  }
  ham.sort((a, b) => a.$1.compareTo(b.$1));
  final birlesik = <(int, int)>[];
  for (final r in ham) {
    if (birlesik.isNotEmpty && r.$1 <= birlesik.last.$2) {
      final son = birlesik.removeLast();
      birlesik.add((son.$1, r.$2 > son.$2 ? r.$2 : son.$2));
    } else {
      birlesik.add(r);
    }
  }
  return (araliklar: birlesik, bulunamayan: yok);
}

const _aylar = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

/// "2026-10-04" → "4 Ekim 2026"; çözülemezse null.
String? trTarih(String? iso) {
  final t = iso == null ? null : DateTime.tryParse(iso);
  return t == null ? null : '${t.day} ${_aylar[t.month - 1]} ${t.year}';
}

String mevzuatTarihNotu(String? iso) =>
    'Metin ${trTarih(iso) ?? '4 Ekim 2026'} itibarıyla alınmıştır. Güncel hâli için resmî kaynağa bakın.';
