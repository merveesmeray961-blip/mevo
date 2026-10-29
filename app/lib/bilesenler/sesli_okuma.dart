import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../mantik/sesli_okuma.dart';

/// Sesli okuma motoru. Ekranlar yalnız bu arayüzü bilir; gerçek cihazda [CihazSesi], testlerde sahte bir sınıf kullanılır.
abstract class SesMotoru extends ChangeNotifier {
  /// Şu an bir metin okunuyor mu?
  bool get okuyor;

  /// Cihazda Türkçe ses bulunamadıysa false (düğme bunu kullanıcıya söyler).
  bool get turkceVar;

  /// Okuma hızı: 0.5 (yavaş) ... 1.0 (normal) ... 1.5.
  double get hiz;

  Future<void> hazirla();
  Future<void> oku(String metin);
  Future<void> durdur();
  Future<void> hizSec(double hiz);
}

/// `flutter_tts` ile cihazın kendi Türkçe sesini kullanır: internet ve ek ücret gerekmez.
class CihazSesi extends SesMotoru {
  final FlutterTts _tts;
  bool _okuyor = false;
  bool _turkce = true;
  bool _hazir = false;
  double _hiz = 0.5; // flutter_tts ölçeğinde 0.5 ≈ normal konuşma hızı (Android/iOS)
  int _oturum = 0; // yeni bir okuma başlayınca eskisinin kalan parçaları iptal olur

  CihazSesi({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  @override
  bool get okuyor => _okuyor;

  @override
  bool get turkceVar => _turkce;

  @override
  double get hiz => _hiz;

  @override
  Future<void> hazirla() async {
    if (_hazir) return;
    _hazir = true;
    try {
      final diller = await _tts.getLanguages;
      _turkce = diller is List && diller.any((d) => d.toString().toLowerCase().startsWith('tr'));
      if (_turkce) await _tts.setLanguage('tr-TR');
      await _tts.setSpeechRate(_hiz);
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {
      _turkce = false;
    }
    notifyListeners();
  }

  @override
  Future<void> oku(String metin) async {
    await hazirla();
    if (!_turkce) return;
    final oturum = ++_oturum;
    await _tts.stop();
    _okuyor = true;
    notifyListeners();
    try {
      for (final parca in sesParcalari(metin)) {
        if (oturum != _oturum) return; // araya başka okuma ya da durdurma girdi
        await _tts.speak(parca);
      }
    } finally {
      if (oturum == _oturum) {
        _okuyor = false;
        notifyListeners();
      }
    }
  }

  @override
  Future<void> durdur() async {
    _oturum++;
    _okuyor = false;
    notifyListeners();
    try {
      await _tts.stop();
    } catch (_) {}
  }

  @override
  Future<void> hizSec(double hiz) async {
    _hiz = hiz.clamp(0.3, 0.8);
    try {
      await _tts.setSpeechRate(_hiz);
    } catch (_) {}
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_tts.stop());
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
  Future<void> oku(String metin) async {}

  @override
  Future<void> durdur() async {}

  @override
  Future<void> hizSec(double hiz) async {}
}

/// Mobilde cihaz sesi, webde sessiz motor.
SesMotoru varsayilanSesMotoru() => kIsWeb ? SessizSes() : CihazSesi();

/// Verilen metni okuyan / durduran düğme. [metin] her tıklamada hesaplanır (uzun metin yalnız gerektiğinde işlenir).
/// Düğmenin bulunduğu ekran kapanınca okuma kendiliğinden durur.
class SesDugmesi extends StatefulWidget {
  final SesMotoru motor;
  final String Function() metin;
  final String ipucu;

  const SesDugmesi({super.key, required this.motor, required this.metin, this.ipucu = 'Sesli oku'});

  @override
  State<SesDugmesi> createState() => _SesDugmesiState();
}

class _SesDugmesiState extends State<SesDugmesi> {
  SesMotoru get motor => widget.motor;

  @override
  void dispose() {
    // Ağaç sökülürken dinleyicileri tetiklememek için bir sonraki mikro göreve bırakılır.
    if (motor.okuyor) scheduleMicrotask(motor.durdur);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: motor,
      builder: (context, _) {
        final okuyor = motor.okuyor;
        return IconButton(
          tooltip: okuyor ? 'Okumayı durdur' : widget.ipucu,
          icon: Icon(okuyor ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
          onPressed: () async {
            if (okuyor) return motor.durdur();
            await motor.hazirla();
            if (!context.mounted) return;
            if (!motor.turkceVar) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Bu cihazda Türkçe ses bulunamadı. Telefon ayarlarından "Metin okuma" bölümünden Türkçe ses yükleyebilirsin.',
                  ),
                ),
              );
              return;
            }
            await motor.oku(widget.metin());
          },
        );
      },
    );
  }
}
