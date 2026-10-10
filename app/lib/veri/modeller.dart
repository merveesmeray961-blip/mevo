/// Soru bankası paketinin (pipeline/disa_aktar.py çıktısı) Dart karşılığı.
library;

const harfler = ['A', 'B', 'C', 'D', 'E'];

class Kaynak {
  final String mevzuat;
  final String madde;
  final String? alinti;

  const Kaynak({required this.mevzuat, required this.madde, this.alinti});

  factory Kaynak.fromJson(Map<String, dynamic> j) =>
      Kaynak(mevzuat: j['mevzuat'] as String, madde: j['madde'] as String, alinti: j['alinti'] as String?);
}

/// Bir sorunun bir maddeden aldığı birebir alıntı. [atif] sorudaki ham gösterim ("md. 26/1-(ç)").
class MevzuatAlintisi {
  final String atif;
  final String metin;
  final String soruId;

  const MevzuatAlintisi({required this.atif, required this.metin, required this.soruId});

  factory MevzuatAlintisi.fromJson(Map<String, dynamic> j) => MevzuatAlintisi(
    atif: (j['atif'] ?? '') as String,
    metin: (j['metin'] ?? '') as String,
    soruId: (j['soru_id'] ?? '') as String,
  );
}

/// "Mevzuat" bölümünde bir kaynağın (kanun, standart, tebliğ...) sorularda atıf yapılan tek maddesi.
/// Tam metin yalnızca resmî kanun metinlerinde vardır; diğerlerinde yalnızca sorulardaki alıntılar gösterilir.
class MevzuatMaddesi {
  final String kaynak;

  /// kanun | yonetmelik | teblig | standart | diger
  final String tur;
  final String? kod;
  final String madde;
  final String? baslik;
  final String? tamMetin;
  final List<MevzuatAlintisi> alintilar;
  final List<String> soruIdler;
  final String? mevzuatGovUrl;

  /// Arama için küçük harfli birleşik metin (kaynak, madde, başlık, alıntılar ve tam metin).
  late final String aramaMetni = turkceKucult(
    [kaynak, madde, ?baslik, for (final a in alintilar) a.metin, ?tamMetin].join('\n'),
  );

  MevzuatMaddesi({
    required this.kaynak,
    required this.tur,
    this.kod,
    required this.madde,
    this.baslik,
    this.tamMetin,
    required this.alintilar,
    required this.soruIdler,
    this.mevzuatGovUrl,
  });

  factory MevzuatMaddesi.fromJson(Map<String, dynamic> j) => MevzuatMaddesi(
    kaynak: j['kaynak'] as String,
    tur: (j['tur'] ?? 'diger') as String,
    kod: j['kod'] as String?,
    madde: j['madde'] as String,
    baslik: j['baslik'] as String?,
    tamMetin: j['tam_metin'] as String?,
    alintilar: [
      for (final a in (j['alintilar'] ?? const []) as List) MevzuatAlintisi.fromJson(a as Map<String, dynamic>),
    ],
    soruIdler: List<String>.from((j['soru_idler'] ?? const []) as List),
    mevzuatGovUrl: j['mevzuat_gov_url'] as String?,
  );
}

/// Türkçe harflere duyarlı küçük harfe çevirme (İ→i, I→ı); arama için.
String turkceKucult(String s) => s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

class Soru {
  final String id;
  final int surum;
  final List<String> bolum;
  final String ders;
  final String konu;
  final String tip;
  final int zorluk;
  final String kok;
  final Map<String, String> secenekler;
  final String dogru;
  final String dogruNeden;

  /// Zor sorularda tuzağın ve zorluğun nerede olduğunu anlatan not (yoksa null).
  final String? pufNoktalari;
  final Map<String, String> celdiriciler;
  final List<String> hesapAdimlari;
  final List<Kaynak> kaynaklar;

  const Soru({
    required this.id,
    required this.surum,
    required this.bolum,
    required this.ders,
    required this.konu,
    required this.tip,
    required this.zorluk,
    required this.kok,
    required this.secenekler,
    required this.dogru,
    required this.dogruNeden,
    this.pufNoktalari,
    required this.celdiriciler,
    required this.hesapAdimlari,
    required this.kaynaklar,
  });

  factory Soru.fromJson(Map<String, dynamic> j) {
    final aciklama = j['aciklama'] as Map<String, dynamic>;
    return Soru(
      id: j['id'] as String,
      surum: j['surum'] as int,
      bolum: List<String>.from(j['bolum'] as List),
      ders: j['ders'] as String,
      konu: j['konu'] as String,
      tip: j['tip'] as String,
      zorluk: j['zorluk'] as int,
      kok: j['kok'] as String,
      secenekler: Map<String, String>.from(j['secenekler'] as Map),
      dogru: j['dogru'] as String,
      dogruNeden: aciklama['dogru_neden'] as String,
      pufNoktalari: aciklama['puf_noktalari'] as String?,
      celdiriciler: Map<String, String>.from((aciklama['celdiriciler'] ?? {}) as Map),
      hesapAdimlari: List<String>.from((aciklama['hesap_adimlari'] ?? const []) as List),
      kaynaklar: [for (final k in (j['kaynaklar'] as List)) Kaynak.fromJson(k as Map<String, dynamic>)],
    );
  }

  bool bolumde(String b) => bolum.contains(b);
}

class Ders {
  final String kod;
  final String ad;
  final String sgsAd;
  final int yetSoru;
  final int sgsSoru;
  final Map<String, String> konular;

  const Ders({
    required this.kod,
    required this.ad,
    required this.sgsAd,
    required this.yetSoru,
    required this.sgsSoru,
    required this.konular,
  });

  factory Ders.fromJson(String kod, Map<String, dynamic> j) {
    final soru = j['soru'] as Map<String, dynamic>;
    return Ders(
      kod: kod,
      ad: j['ad'] as String,
      sgsAd: (j['sgs_ad'] ?? j['ad']) as String,
      yetSoru: (soru['yet'] ?? 0) as int,
      sgsSoru: (soru['sgs'] ?? 0) as int,
      konular: Map<String, String>.from(j['konular'] as Map),
    );
  }

  /// Bu dersin verilen bölümün sınavında kaç sorusu olduğu (0 ise o bölümde yok).
  int sinavdakiSoru(String bolum) => bolum == 'YET' ? yetSoru : sgsSoru;

  String gorunenAd(String bolum) => bolum == 'SGS' ? sgsAd : ad;
}

/// Bölüm (SGS / YET) sınav kuralları.
class SinavFormati {
  final String kod;
  final String ad;
  final double yanlisCezasi;
  final int? toplamSoru;
  final int? toplamSureDk;
  final int? dersBasinaSoru;
  final int? dersBasinaSureDk;
  final int? dersMin;
  final int? ortalamaMin;
  final int? gecmePuani;
  final List<List<String>> oturumlar;

  const SinavFormati({
    required this.kod,
    required this.ad,
    required this.yanlisCezasi,
    this.toplamSoru,
    this.toplamSureDk,
    this.dersBasinaSoru,
    this.dersBasinaSureDk,
    this.dersMin,
    this.ortalamaMin,
    this.gecmePuani,
    this.oturumlar = const [],
  });

  /// YET oturum ders kodları paket içinde uzun adlarla (finansal_muhasebe…) geçer; uygulamadaki ders kodlarına çevrilir.
  static const _oturumDersi = {
    'finansal_muhasebe': 'FIN',
    'maliyet_muhasebesi': 'MAL',
    'hukuk': 'HUK',
    'sermaye_piyasasi_mevzuati': 'SPK',
    'finansal_tablolar_ve_analizi': 'TAB',
    'muhasebe_denetimi': 'DEN',
    'vergi_mevzuati_ve_uygulamasi': 'VER',
    'meslek_hukuku': 'MES',
  };

  factory SinavFormati.fromJson(Map<String, dynamic> j) {
    final gecme = j['gecme'] as Map<String, dynamic>?;
    final degerlendirme = j['degerlendirme'] as Map<String, dynamic>?;
    return SinavFormati(
      kod: j['kod'] as String,
      ad: j['ad'] as String,
      yanlisCezasi: ((j['yanlis_cezasi'] ?? 0) as num).toDouble(),
      toplamSoru: j['soru_sayisi'] as int?,
      toplamSureDk: j['sure_dakika'] as int?,
      dersBasinaSoru: j['ders_basina_soru'] as int?,
      dersBasinaSureDk: j['ders_basina_sure_dakika'] as int?,
      dersMin: gecme?['ders_min'] as int?,
      ortalamaMin: gecme?['ortalama_min'] as int?,
      gecmePuani: degerlendirme?['gecme_puani'] as int?,
      oturumlar: [
        for (final o in (j['oturumlar'] ?? const []) as List)
          [
            for (final d in (o['dersler'] as List))
              if (_oturumDersi[d['kod']] != null) _oturumDersi[d['kod']]!,
          ],
      ],
    );
  }
}

class SoruBankasi {
  final String olusturma;
  final String uyari;
  final Map<String, SinavFormati> formatlar;
  final Map<String, Ders> dersler;
  final List<Soru> sorular;
  final Map<String, List<DateTime>> takvim;

  /// "Mevzuat" bölümü; eski paketlerde bu anahtar yoktur (boş liste).
  final List<MevzuatMaddesi> mevzuat;

  /// Mevzuat metinlerinin alındığı tarih (yyyy-aa-gg); yoksa null.
  final String? mevzuatTarihi;
  final Map<String, Soru> _idIle;

  SoruBankasi({
    required this.olusturma,
    required this.uyari,
    required this.formatlar,
    required this.dersler,
    required this.sorular,
    required this.takvim,
    this.mevzuat = const [],
    this.mevzuatTarihi,
  }) : _idIle = {for (final s in sorular) s.id: s};

  factory SoruBankasi.fromJson(Map<String, dynamic> j) {
    final takvim = <String, List<DateTime>>{};
    for (final yil in ((j['takvim'] ?? const {}) as Map).values) {
      (yil as Map).forEach((bolum, tarihler) {
        takvim.putIfAbsent(bolum as String, () => []).addAll([
          for (final t in tarihler as List) DateTime.parse(t as String),
        ]);
      });
    }
    for (final l in takvim.values) {
      l.sort();
    }
    return SoruBankasi(
      olusturma: j['olusturma'] as String,
      uyari: j['uyari'] as String,
      formatlar: {
        for (final e in (j['formatlar'] as Map).entries)
          e.key as String: SinavFormati.fromJson(e.value as Map<String, dynamic>),
      },
      dersler: {
        for (final e in (j['dersler'] as Map).entries)
          e.key as String: Ders.fromJson(e.key as String, e.value as Map<String, dynamic>),
      },
      sorular: [for (final s in j['sorular'] as List) Soru.fromJson(s as Map<String, dynamic>)],
      takvim: takvim,
      mevzuat: [for (final m in (j['mevzuat'] ?? const []) as List) MevzuatMaddesi.fromJson(m as Map<String, dynamic>)],
      mevzuatTarihi: j['mevzuat_tarihi'] as String?,
    );
  }

  Soru? soru(String id) => _idIle[id];

  /// SGS'nin hukuk dersi (SHK: iş-SGK, vergi, ticaret, borçlar) için ayrı soru üretilmez; Yeterlilik'in hukuk ve
  /// vergi soruları SGS konularına eşlenir (idari yargılama SGS'de yoktur). Anahtar: SHK konusu → (ders, konu?).
  static const sgsHukukEslemesi = {
    'ISG': [('HUK', 'ISH'), ('HUK', 'SGK')],
    'VRG': [('VER', null)],
    'TCR': [('HUK', 'TIC')],
    'BRC': [('HUK', 'BRC')],
  };

  /// Sorunun SGS hukuk dersindeki konusu; eşlenmiyorsa null.
  static String? sgsHukukKonusu(Soru s) {
    for (final e in sgsHukukEslemesi.entries) {
      for (final (ders, konu) in e.value) {
        if (s.ders == ders && (konu == null || s.konu == konu)) return e.key;
      }
    }
    return null;
  }

  /// Sorunun verilen bölümün sınavında sayıldığı ders: SGS'de hukuk/vergi soruları SHK'ya, diğerleri kendi dersine.
  String sinavDersi(Soru s, String bolum) => bolum == 'SGS' && sgsHukukKonusu(s) != null ? 'SHK' : s.ders;

  bool _bolumde(Soru s, String bolum) => s.bolumde(bolum) || (bolum == 'SGS' && sgsHukukKonusu(s) != null);

  List<Soru> bolumSorulari(String bolum) => [
    for (final s in sorular)
      if (_bolumde(s, bolum)) s,
  ];

  List<Soru> dersSorulari(String bolum, String ders, {String? konu}) {
    if (bolum == 'SGS' && ders == 'SHK') {
      return [
        for (final s in sorular)
          if (sgsHukukKonusu(s) case final k? when konu == null || k == konu) s,
      ];
    }
    return [
      for (final s in sorular)
        if (s.bolumde(bolum) && s.ders == ders && (konu == null || s.konu == konu)) s,
    ];
  }

  /// Bölümün sınavında yer alan ve bankada en az bir sorusu bulunan dersler, müfredat sırasıyla.
  List<Ders> bolumDersleri(String bolum) {
    final dolu = {
      for (final s in sorular)
        if (_bolumde(s, bolum)) sinavDersi(s, bolum),
    };
    return [
      for (final d in dersler.values)
        if (d.sinavdakiSoru(bolum) > 0 && dolu.contains(d.kod)) d,
    ];
  }

  /// Bugünden sonraki ilk sınav tarihi (açıklanmamışsa null).
  DateTime? sonrakiSinav(String bolum, DateTime bugun) {
    final gun = DateTime(bugun.year, bugun.month, bugun.day);
    for (final t in takvim[bolum] ?? const <DateTime>[]) {
      if (!t.isBefore(gun)) return t;
    }
    return null;
  }
}
