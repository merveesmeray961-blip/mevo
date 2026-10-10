import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'depo.dart';
import 'modeller.dart';

/// Aralıklı tekrar kutuları (Leitner): doğru cevapta bir üst kutuya, yanlışta ilk kutuya.
/// Kutu n'deki bir soru, son cevaptan [tekrarAraliklari][n] gün sonra yeniden sorulur.
const tekrarAraliklari = [1, 3, 7, 16, 35];
const yanlisTekrarDakika = 10;

class SoruDurumu {
  int deneme;
  int dogru;
  int kutu;
  bool sonDogru;
  DateTime sonCevap;
  DateTime sonraki;
  bool isaretli;
  int surum;

  SoruDurumu({
    this.deneme = 0,
    this.dogru = 0,
    this.kutu = 0,
    this.sonDogru = false,
    DateTime? sonCevap,
    DateTime? sonraki,
    this.isaretli = false,
    this.surum = 0,
  }) : sonCevap = sonCevap ?? DateTime.fromMillisecondsSinceEpoch(0),
       sonraki = sonraki ?? DateTime.fromMillisecondsSinceEpoch(0);

  bool get cozuldu => deneme > 0;

  Map<String, dynamic> toJson() => {
    'd': deneme,
    'g': dogru,
    'k': kutu,
    's': sonDogru,
    't': sonCevap.millisecondsSinceEpoch,
    'n': sonraki.millisecondsSinceEpoch,
    if (isaretli) 'i': true,
    'v': surum,
  };

  factory SoruDurumu.fromJson(Map<String, dynamic> j) => SoruDurumu(
    deneme: j['d'] as int,
    dogru: j['g'] as int,
    kutu: j['k'] as int,
    sonDogru: j['s'] as bool,
    sonCevap: DateTime.fromMillisecondsSinceEpoch(j['t'] as int),
    sonraki: DateTime.fromMillisecondsSinceEpoch(j['n'] as int),
    isaretli: (j['i'] ?? false) as bool,
    surum: (j['v'] ?? 0) as int,
  );
}

class DersSonucu {
  final int soru;
  final int dogru;
  final int yanlis;
  final double puan;

  const DersSonucu({required this.soru, required this.dogru, required this.yanlis, required this.puan});

  int get bos => soru - dogru - yanlis;

  Map<String, dynamic> toJson() => {'s': soru, 'd': dogru, 'y': yanlis, 'p': puan};

  factory DersSonucu.fromJson(Map<String, dynamic> j) =>
      DersSonucu(soru: j['s'] as int, dogru: j['d'] as int, yanlis: j['y'] as int, puan: (j['p'] as num).toDouble());
}

class DenemeKaydi {
  final DateTime tarih;
  final String bolum;
  final String baslik;
  final int sureSn;
  final int kullanilanSn;
  final Map<String, DersSonucu> dersler;
  final double puan;
  final bool? gecti;

  /// Denemedeki soruların kimlikleri (sırasıyla) ve verilen cevaplar; geçmiş deneme yeniden incelenebilsin diye
  /// saklanır. Bu alanlar eklenmeden önce kaydedilen denemelerde boştur.
  final List<String> soruIdler;
  final Map<String, String> cevaplar;

  const DenemeKaydi({
    required this.tarih,
    required this.bolum,
    required this.baslik,
    required this.sureSn,
    required this.kullanilanSn,
    required this.dersler,
    required this.puan,
    required this.gecti,
    this.soruIdler = const [],
    this.cevaplar = const {},
  });

  Map<String, dynamic> toJson() => {
    't': tarih.millisecondsSinceEpoch,
    'b': bolum,
    'a': baslik,
    's': sureSn,
    'k': kullanilanSn,
    'd': {for (final e in dersler.entries) e.key: e.value.toJson()},
    'p': puan,
    'g': gecti,
    if (soruIdler.isNotEmpty) 'q': soruIdler,
    if (cevaplar.isNotEmpty) 'c': cevaplar,
  };

  factory DenemeKaydi.fromJson(Map<String, dynamic> j) => DenemeKaydi(
    tarih: DateTime.fromMillisecondsSinceEpoch(j['t'] as int),
    bolum: j['b'] as String,
    baslik: j['a'] as String,
    sureSn: j['s'] as int,
    kullanilanSn: j['k'] as int,
    dersler: {
      for (final e in (j['d'] as Map).entries) e.key as String: DersSonucu.fromJson(e.value as Map<String, dynamic>),
    },
    puan: (j['p'] as num).toDouble(),
    gecti: j['g'] as bool?,
    soruIdler: List<String>.from((j['q'] ?? const []) as List),
    cevaplar: Map<String, String>.from((j['c'] ?? const {}) as Map),
  );
}

class DersIstatistigi {
  final int toplam;
  final int cozulen;
  final int deneme;
  final int dogru;

  const DersIstatistigi({required this.toplam, required this.cozulen, required this.deneme, required this.dogru});

  /// Tüm denemelerdeki doğru oranı (0–1); hiç çözülmediyse null.
  double? get basari => deneme == 0 ? null : dogru / deneme;
}

/// Kullanıcının cihazdaki ilerlemesi: soru durumları, deneme geçmişi, günlük sayaç ve hata bildirimleri.
class Ilerleme extends ChangeNotifier {
  static const _anahtarSorular = 'ilerleme.sorular.v1';
  static const _anahtarDenemeler = 'ilerleme.denemeler.v1';
  static const _anahtarGunluk = 'ilerleme.gunluk.v1';
  static const _anahtarBildirimler = 'ilerleme.bildirimler.v1';
  static const _anahtarAnlatimlar = 'ilerleme.anlatimlar.v1';

  final Depo _depo;
  final DateTime Function() _simdi;
  final Map<String, SoruDurumu> _durumlar = {};
  final List<DenemeKaydi> _denemeler = [];
  final Map<String, int> _gunluk = {};
  final List<Map<String, dynamic>> _bildirimler = [];
  final Set<String> _okunanlar = {};

  Ilerleme(this._depo, {DateTime Function()? simdi}) : _simdi = simdi ?? DateTime.now {
    final s = _depo.oku(_anahtarSorular);
    if (s != null) {
      (jsonDecode(s) as Map<String, dynamic>).forEach(
        (id, j) => _durumlar[id] = SoruDurumu.fromJson(j as Map<String, dynamic>),
      );
    }
    final d = _depo.oku(_anahtarDenemeler);
    if (d != null) {
      _denemeler.addAll([for (final j in jsonDecode(d) as List) DenemeKaydi.fromJson(j as Map<String, dynamic>)]);
    }
    final g = _depo.oku(_anahtarGunluk);
    if (g != null) _gunluk.addAll(Map<String, int>.from(jsonDecode(g) as Map));
    final b = _depo.oku(_anahtarBildirimler);
    if (b != null) _bildirimler.addAll([for (final j in jsonDecode(b) as List) Map<String, dynamic>.from(j as Map)]);
    final a = _depo.oku(_anahtarAnlatimlar);
    if (a != null) _okunanlar.addAll(List<String>.from(jsonDecode(a) as List));
  }

  /// Konu anlatımı okundu mu? Anahtar "DERS/KONU".
  bool okundu(String anahtar) => _okunanlar.contains(anahtar);

  int get okunanSayisi => _okunanlar.length;

  Future<void> okunduIsaretle(String anahtar) async {
    if (!_okunanlar.add(anahtar)) return;
    notifyListeners();
    await _depo.yaz(_anahtarAnlatimlar, jsonEncode(_okunanlar.toList()..sort()));
  }

  DateTime get simdi => _simdi();

  static String gunAnahtari(DateTime t) =>
      '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';

  SoruDurumu? durum(String id) => _durumlar[id];

  List<DenemeKaydi> get denemeler => List.unmodifiable(_denemeler.reversed);

  List<Map<String, dynamic>> get bildirimler => List.unmodifiable(_bildirimler);

  int get bugunCozulen => _gunluk[gunAnahtari(simdi)] ?? 0;

  /// Son 7 günün (bugün dahil) çözülen soru sayıları, eskiden yeniye.
  List<int> sonYediGun() {
    final bugun = simdi;
    return [for (var i = 6; i >= 0; i--) _gunluk[gunAnahtari(bugun.subtract(Duration(days: i)))] ?? 0];
  }

  /// Arka arkaya soru çözülen gün sayısı (bugün henüz çözülmediyse dünden geriye sayılır).
  int get seri {
    var gun = simdi;
    if ((_gunluk[gunAnahtari(gun)] ?? 0) == 0) gun = gun.subtract(const Duration(days: 1));
    var n = 0;
    while ((_gunluk[gunAnahtari(gun)] ?? 0) > 0) {
      n++;
      gun = gun.subtract(const Duration(days: 1));
    }
    return n;
  }

  /// Çalışma modunda verilen cevabı işler: istatistik, tekrar kutusu ve günlük sayaç güncellenir.
  Future<void> cevapla(Soru soru, String secilen, {bool gunlugeSay = true}) async {
    final t = simdi;
    final d = _durumlar.putIfAbsent(soru.id, SoruDurumu.new);
    final dogruMu = secilen == soru.dogru;
    d
      ..deneme += 1
      ..dogru += dogruMu ? 1 : 0
      ..sonDogru = dogruMu
      ..sonCevap = t
      ..surum = soru.surum;
    if (dogruMu) {
      d.sonraki = t.add(Duration(days: tekrarAraliklari[d.kutu.clamp(0, tekrarAraliklari.length - 1)]));
      d.kutu = (d.kutu + 1).clamp(0, tekrarAraliklari.length);
    } else {
      d.kutu = 0;
      d.sonraki = t.add(const Duration(minutes: yanlisTekrarDakika));
    }
    if (gunlugeSay) {
      final k = gunAnahtari(t);
      _gunluk[k] = (_gunluk[k] ?? 0) + 1;
    }
    notifyListeners();
    await _kaydetSorular();
    if (gunlugeSay) await _depo.yaz(_anahtarGunluk, jsonEncode(_gunluk));
  }

  Future<void> isaretle(String id, bool deger) async {
    _durumlar.putIfAbsent(id, SoruDurumu.new).isaretli = deger;
    notifyListeners();
    await _kaydetSorular();
  }

  Future<void> denemeEkle(DenemeKaydi k) async {
    _denemeler.add(k);
    notifyListeners();
    await _depo.yaz(_anahtarDenemeler, jsonEncode([for (final d in _denemeler) d.toJson()]));
  }

  Future<void> bildirimEkle(Soru soru, String tur, String not) async {
    _bildirimler.add({'soru': soru.id, 'surum': soru.surum, 'tur': tur, 'not': not, 'tarih': simdi.toIso8601String()});
    notifyListeners();
    await _depo.yaz(_anahtarBildirimler, jsonEncode(_bildirimler));
  }

  Future<void> sifirla() async {
    _durumlar.clear();
    _denemeler.clear();
    _gunluk.clear();
    _okunanlar.clear();
    notifyListeners();
    await _depo.sil(_anahtarAnlatimlar);
    await _depo.sil(_anahtarSorular);
    await _depo.sil(_anahtarDenemeler);
    await _depo.sil(_anahtarGunluk);
  }

  Future<void> _kaydetSorular() =>
      _depo.yaz(_anahtarSorular, jsonEncode({for (final e in _durumlar.entries) e.key: e.value.toJson()}));

  // ---- Sorgular ----

  bool tekrarZamani(String id) {
    final d = _durumlar[id];
    return d != null && d.cozuldu && !d.sonraki.isAfter(simdi);
  }

  List<Soru> yanlislar(Iterable<Soru> havuz) => [
    for (final s in havuz)
      if (_durumlar[s.id] case final d? when d.cozuldu && !d.sonDogru) s,
  ];

  List<Soru> isaretliler(Iterable<Soru> havuz) => [
    for (final s in havuz)
      if (_durumlar[s.id]?.isaretli ?? false) s,
  ];

  List<Soru> tekrarlar(Iterable<Soru> havuz) => [
    for (final s in havuz)
      if (tekrarZamani(s.id)) s,
  ];

  DersIstatistigi istatistik(Iterable<Soru> havuz) {
    var toplam = 0, cozulen = 0, deneme = 0, dogru = 0;
    for (final s in havuz) {
      toplam++;
      final d = _durumlar[s.id];
      if (d == null || !d.cozuldu) continue;
      cozulen++;
      deneme += d.deneme;
      dogru += d.dogru;
    }
    return DersIstatistigi(toplam: toplam, cozulen: cozulen, deneme: deneme, dogru: dogru);
  }

  /// Çalışma oturumu için soru sırası: önce tekrar zamanı gelenler (en eski önce), sonra hiç
  /// çözülmemişler (karışık), en son diğerleri (en uzun süredir görülmeyen önce).
  List<Soru> calismaSirasi(List<Soru> havuz, int adet, {int? tohum}) {
    final tekrar = <Soru>[], yeni = <Soru>[], diger = <Soru>[];
    for (final s in havuz) {
      final d = _durumlar[s.id];
      if (d == null || !d.cozuldu) {
        yeni.add(s);
      } else if (tekrarZamani(s.id)) {
        tekrar.add(s);
      } else {
        diger.add(s);
      }
    }
    tekrar.sort((a, b) => _durumlar[a.id]!.sonraki.compareTo(_durumlar[b.id]!.sonraki));
    yeni.shuffle(tohum == null ? null : Random(tohum));
    diger.sort((a, b) => _durumlar[a.id]!.sonCevap.compareTo(_durumlar[b.id]!.sonCevap));
    return [...tekrar, ...yeni, ...diger].take(adet).toList();
  }
}
