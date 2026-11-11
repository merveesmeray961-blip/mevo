import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../mantik/sesli_okuma.dart';

/// Cihazdaki bir Türkçe ses (Ayarlar'da seçilebilir).
class SesSecenegi {
  /// Motorun ses adı (ör. "tr-tr-x-cfs-local").
  final String ad;

  /// Kullanıcıya gösterilen ad (ör. "Ses 2 · yüksek kalite").
  final String etiket;

  /// İnternet gerektiren ses mi?
  final bool internet;

  final Map<String, String> ham;

  const SesSecenegi({required this.ad, required this.etiket, this.internet = false, this.ham = const {}});
}

/// Sesli okuma motoru. Ekranlar yalnız bu arayüzü bilir; gerçek cihazda [CihazSesi], testlerde sahte bir sınıf kullanılır.
///
/// Metin cümle cümle okunur: cümle aralarında doğal duraklama olur; kullanıcı duraklatabilir, kaldığı cümleden
/// sürdürebilir, bir cümle ileri/geri atlayabilir. Ekranlar [kaynak] ile o an kendi metinlerinin okunup
/// okunmadığını anlar.
abstract class SesMotoru extends ChangeNotifier {
  /// Etkin bir okuma var mı (çalıyor ya da duraklatılmış)?
  bool get okuyor;

  /// Okuma duraklatıldı mı?
  bool get duraklatildi => false;

  /// Cihazda Türkçe ses bulunamadıysa false (düğme bunu kullanıcıya söyler).
  bool get turkceVar;

  /// Okuma hızı (flutter_tts ölçeği; 0.5 ≈ normal konuşma).
  double get hiz;

  /// Okunan metnin cümleleri ve şu anki cümle (0'dan).
  List<String> get cumleler => const [];
  int get sira => 0;

  /// Okunan metnin sahibi (ör. "anlatim/FIN/ALC"); ekranlar kendi okumalarını buna göre tanır.
  String? get kaynak => null;

  /// Cihazdaki Türkçe sesler ve seçili olanın adı.
  List<SesSecenegi> get sesler => const [];
  String? get seciliSes => null;

  Future<void> hazirla();

  /// [metin] konuşmaya hazırlanmış düz metindir (bkz. `konusmaMetni`); cümlelere motor böler.
  Future<void> oku(String metin, {String? kaynak, int baslangic = 0});
  Future<void> durdur();
  Future<void> duraklat() async {}
  Future<void> devam() async {}
  Future<void> atla(int fark) async {}
  Future<void> hizSec(double hiz);
  Future<void> sesSec(String? ad) async {}
}

/// `flutter_tts` ile cihazın kendi Türkçe sesini kullanır: internet ve ek ücret gerekmez.
///
/// Kalite için: Android'de Google'ın konuşma motoru varsa o seçilir (Türkçe sesleri en doğal olandır); cihazdaki
/// Türkçe sesler arasından internet istemeyen en yüksek kaliteli olan otomatik seçilir, kullanıcı Ayarlar'dan
/// değiştirebilir.
class CihazSesi extends SesMotoru {
  final FlutterTts _tts;
  bool _turkce = true;
  bool _hazir = false;
  Future<void>? _hazirlik;
  double _hiz = 0.5;
  String? _istenenSes;
  String? _seciliSes;
  List<SesSecenegi> _sesler = const [];

  List<String> _cumleler = const [];
  int _sira = 0;
  String? _kaynak;
  bool _calisiyor = false;
  bool _duraklatildi = false;
  int _oturum = 0; // yeni bir okuma ya da durdurma gelince eski döngü kendini bitirir

  CihazSesi({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  @override
  bool get okuyor => _calisiyor || _duraklatildi;
  @override
  bool get duraklatildi => _duraklatildi;
  @override
  bool get turkceVar => _turkce;
  @override
  double get hiz => _hiz;
  @override
  List<String> get cumleler => _cumleler;
  @override
  int get sira => _sira;
  @override
  String? get kaynak => _kaynak;
  @override
  List<SesSecenegi> get sesler => _sesler;
  @override
  String? get seciliSes => _seciliSes;

  @override
  Future<void> hazirla() => _hazirlik ??= _hazirlaIlk();

  /// Android'de sesli okuma eklentisi açılışı yavaşlatmasın diye ilk kullanımda kaydedilir (MainActivity.kt).
  static const _kanal = MethodChannel('mevo/ses');

  Future<void> _hazirlaIlk() async {
    if (_hazir) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _kanal.invokeMethod<bool>('baslat');
      } on MissingPluginException {
        // Testte ya da eski yerel kodda kanal yoksa eklenti zaten kayıtlıdır.
      } catch (_) {}
    }
    _hazir = true;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Google konuşma motoru yüklüyse onu kullan (Samsung vb. motorların Türkçesi daha robotik).
        try {
          final motorlar = await _tts.getEngines;
          if (motorlar is List && motorlar.contains('com.google.android.tts')) {
            await _tts.setEngine('com.google.android.tts');
          }
        } catch (_) {}
      }
      final diller = await _tts.getLanguages;
      _turkce = diller is List && diller.any((d) => d.toString().toLowerCase().replaceAll('_', '-').startsWith('tr'));
      if (_turkce) {
        await _tts.setLanguage('tr-TR');
        await _sesleriBul();
        await _sesUygula();
      }
      await _tts.setSpeechRate(_hiz);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS: sessiz modda da konuşsun, diğer seslerin üstüne binmesin.
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.duckOthers,
        ], IosTextToSpeechAudioMode.spokenAudio);
      }
    } catch (_) {
      _turkce = false;
    }
    notifyListeners();
  }

  Future<void> _sesleriBul() async {
    try {
      final ham = await _tts.getVoices;
      if (ham is! List) return;
      final turkce = <Map<String, String>>[
        for (final v in ham)
          if (v is Map)
            {for (final e in v.entries) e.key.toString(): e.value.toString()},
      ].where((v) => (v['locale'] ?? '').toLowerCase().replaceAll('_', '-').startsWith('tr')).toList();
      int puan(Map<String, String> v) {
        final ad = (v['name'] ?? '').toLowerCase();
        final internet = v['network_required'] == '1' || v['network_required'] == 'true' || ad.contains('network');
        final kalite = int.tryParse(v['quality'] ?? '') ?? 300;
        // iOS: "Enhanced/Premium" sesler daha doğaldır.
        final ios = (v['quality'] ?? '').toLowerCase();
        final iosPuan = ios.contains('premium') ? 500 : (ios.contains('enhanced') ? 400 : 0);
        // Google'ın internetli (nöral) sesleri çok daha doğaldır ve ücretsizdir; önce onlar seçilir. İnternet yoksa
        // Android motoru kendiliğinden aynı sesin cihazdaki sürümüne düşer.
        return (internet ? 1000 : 0) + kalite + iosPuan;
      }

      turkce.sort((a, b) => puan(b).compareTo(puan(a)));
      final liste = <SesSecenegi>[];
      for (var i = 0; i < turkce.length; i++) {
        final v = turkce[i];
        final ad = v['name'] ?? '';
        if (ad.isEmpty || liste.any((s) => s.ad == ad)) continue;
        final internet = v['network_required'] == '1' || v['network_required'] == 'true' || ad.toLowerCase().contains('network');
        final cinsiyet = switch ((v['gender'] ?? '').toLowerCase()) {
          'female' => ' · kadın',
          'male' => ' · erkek',
          _ => '',
        };
        liste.add(
          SesSecenegi(
            ad: ad,
            etiket: 'Ses ${liste.length + 1}$cinsiyet${internet ? ' · doğal (internetle)' : ' · çevrimdışı'}${liste.isEmpty ? ' · önerilen' : ''}',
            internet: internet,
            ham: v,
          ),
        );
      }
      _sesler = liste;
    } catch (_) {}
  }

  Future<void> _sesUygula() async {
    if (_sesler.isEmpty) return;
    final secim = _sesler.firstWhere((s) => s.ad == _istenenSes, orElse: () => _sesler.first);
    try {
      await _tts.setVoice({'name': secim.ad, 'locale': secim.ham['locale'] ?? 'tr-TR'});
      _seciliSes = secim.ad;
    } catch (_) {}
  }

  @override
  Future<void> sesSec(String? ad) async {
    _istenenSes = ad;
    if (_hazir) {
      await _sesUygula();
      notifyListeners();
    }
  }

  @override
  Future<void> oku(String metin, {String? kaynak, int baslangic = 0}) async {
    await hazirla();
    if (!_turkce) return;
    final cumleler = okumaCumleleri(metin);
    if (cumleler.isEmpty) return;
    await _durdurMotor();
    _cumleler = cumleler;
    _kaynak = kaynak;
    _sira = baslangic.clamp(0, cumleler.length - 1);
    _duraklatildi = false;
    unawaited(_dongu());
  }

  Future<void> _dongu() async {
    final oturum = ++_oturum;
    _calisiyor = true;
    notifyListeners();
    try {
      while (oturum == _oturum && _sira < _cumleler.length) {
        await _tts.speak(_cumleler[_sira]);
        if (oturum != _oturum) return; // araya duraklatma, atlama ya da başka okuma girdi
        _sira++;
        notifyListeners();
      }
      if (oturum == _oturum) {
        // Metin bitti.
        _calisiyor = false;
        _kaynak = null;
        _sira = 0;
        notifyListeners();
      }
    } catch (_) {
      if (oturum == _oturum) {
        _calisiyor = false;
        notifyListeners();
      }
    }
  }

  Future<void> _durdurMotor() async {
    _oturum++;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  @override
  Future<void> duraklat() async {
    if (!_calisiyor) return;
    await _durdurMotor();
    _calisiyor = false;
    _duraklatildi = true;
    notifyListeners();
  }

  @override
  Future<void> devam() async {
    if (!_duraklatildi) return;
    _duraklatildi = false;
    unawaited(_dongu());
  }

  @override
  Future<void> atla(int fark) async {
    if (_cumleler.isEmpty) return;
    final yeni = (_sira + fark).clamp(0, _cumleler.length - 1);
    final caliyordu = _calisiyor;
    await _durdurMotor();
    _sira = yeni;
    if (caliyordu) {
      unawaited(_dongu());
    } else {
      notifyListeners();
    }
  }

  @override
  Future<void> durdur() async {
    await _durdurMotor();
    _calisiyor = false;
    _duraklatildi = false;
    _kaynak = null;
    _cumleler = const [];
    _sira = 0;
    notifyListeners();
  }

  @override
  Future<void> hizSec(double hiz) async {
    _hiz = hiz.clamp(0.3, 0.8);
    // Motor henüz hazırlanmadıysa yalnız saklanır; hazırlanırken uygulanır (açılışta eklentiye dokunulmaz).
    if (_hazir) {
      try {
        await _tts.setSpeechRate(_hiz);
      } catch (_) {}
    }
    // Çalarken hız değişirse o anki cümle yeni hızla baştan okunur.
    if (_calisiyor) {
      await _durdurMotor();
      unawaited(_dongu());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (_hazir) unawaited(_tts.stop());
    super.dispose();
  }
}

/// Web önizlemesi ve ses motoru olmayan ortamlar için: hiçbir şey okumaz, düğme "kullanılamıyor" der.
class SessizSes extends SesMotoru {
  @override
  bool get okuyor => false;
  @override
  bool get turkceVar => false;
  @override
  double get hiz => 0.5;
  @override
  Future<void> hazirla() async {}
  @override
  Future<void> oku(String metin, {String? kaynak, int baslangic = 0}) async {}
  @override
  Future<void> durdur() async {}
  @override
  Future<void> hizSec(double hiz) async {}
}

/// Mobilde cihaz sesi, webde sessiz motor.
SesMotoru varsayilanSesMotoru() => kIsWeb ? SessizSes() : CihazSesi();

/// Türkçe ses yoksa kullanıcıya ne yapacağını söyler. Okuma başladıysa true döner.
Future<bool> sesliOkumayaBasla(BuildContext context, SesMotoru motor, String metin, {String? kaynak}) async {
  await motor.hazirla();
  if (!context.mounted) return false;
  if (!motor.turkceVar) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 6),
        content: Text(
          'Bu cihazda Türkçe ses bulunamadı. Telefon Ayarları › Erişilebilirlik (ya da Dil) › Metin okuma çıkışı '
          'bölümünden "Google Konuşma Hizmetleri"ni seçip Türkçe ses verisini yükleyebilirsin.',
        ),
      ),
    );
    return false;
  }
  await motor.oku(metin, kaynak: kaynak);
  return true;
}

/// Verilen metni okuyan / durduran küçük düğme (soru ekranında). [metin] her tıklamada hesaplanır.
/// Düğmenin bulunduğu ekran kapanınca okuma kendiliğinden durur.
class SesDugmesi extends StatefulWidget {
  final SesMotoru motor;
  final String Function() metin;
  final String ipucu;

  /// Bu düğmenin okumasını tanımlayan kimlik; verilmezse düğme her okumayı kendi sayar.
  final String? kaynak;

  const SesDugmesi({super.key, required this.motor, required this.metin, this.ipucu = 'Sesli oku', this.kaynak});

  @override
  State<SesDugmesi> createState() => _SesDugmesiState();
}

class _SesDugmesiState extends State<SesDugmesi> {
  SesMotoru get motor => widget.motor;
  bool _benim = false;

  bool get _benimOkumam => motor.okuyor && (widget.kaynak == null ? _benim : motor.kaynak == widget.kaynak);

  @override
  void dispose() {
    // Ağaç sökülürken dinleyicileri tetiklememek için bir sonraki mikro göreve bırakılır.
    if (_benimOkumam) scheduleMicrotask(motor.durdur);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: motor,
      builder: (context, _) {
        final okuyor = _benimOkumam;
        return IconButton(
          tooltip: okuyor ? 'Okumayı durdur' : widget.ipucu,
          icon: Icon(okuyor ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
          onPressed: () async {
            if (okuyor) {
              _benim = false;
              return motor.durdur();
            }
            _benim = true;
            _benim = await sesliOkumayaBasla(context, motor, widget.metin(), kaynak: widget.kaynak);
          },
        );
      },
    );
  }
}

/// Uzun metinler (konu anlatımı) için oynatıcı çubuğu: oynat/duraklat, cümle geri/ileri, durdur, hız,
/// ilerleme ve o an okunan cümle. Yalnız [kaynak] okunurken görünür.
class SesOynatici extends StatelessWidget {
  final SesMotoru motor;
  final String kaynak;
  final List<double> hizlar;
  final ValueChanged<double>? hizDegisti;

  const SesOynatici({
    super.key,
    required this.motor,
    required this.kaynak,
    this.hizlar = const [0.4, 0.5, 0.6, 0.7],
    this.hizDegisti,
  });

  static String hizEtiketi(double h) => switch (h) {
    0.4 => '0,8×',
    0.5 => '1×',
    0.6 => '1,2×',
    0.7 => '1,4×',
    _ => '${(h * 2).toStringAsFixed(1).replaceAll('.', ',')}×',
  };

  @override
  Widget build(BuildContext context) {
    final r = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: motor,
      builder: (context, _) {
        if (!motor.okuyor || motor.kaynak != kaynak || motor.cumleler.isEmpty) return const SizedBox.shrink();
        final toplam = motor.cumleler.length;
        final sira = motor.sira.clamp(0, toplam - 1);
        return Material(
          color: r.surfaceContainerHigh,
          elevation: 3,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    motor.cumleler[sira],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(color: r.onSurface),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: (sira + 1) / toplam, minHeight: 4),
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Okumayı kapat',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: motor.durdur,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Önceki cümle',
                        icon: const Icon(Icons.skip_previous_rounded),
                        onPressed: () => motor.atla(-1),
                      ),
                      IconButton.filled(
                        tooltip: motor.duraklatildi ? 'Devam et' : 'Duraklat',
                        iconSize: 32,
                        icon: Icon(motor.duraklatildi ? Icons.play_arrow_rounded : Icons.pause_rounded),
                        onPressed: motor.duraklatildi ? motor.devam : motor.duraklat,
                      ),
                      IconButton(
                        tooltip: 'Sonraki cümle',
                        icon: const Icon(Icons.skip_next_rounded),
                        onPressed: () => motor.atla(1),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final i = hizlar.indexOf(motor.hiz);
                          final yeni = hizlar[(i + 1) % hizlar.length];
                          motor.hizSec(yeni);
                          hizDegisti?.call(yeni);
                        },
                        child: Text(hizEtiketi(motor.hiz), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
