// Mobilde sistemin (yerel) zlib'i, webde saf Dart (archive) kullanılır; yerel çözme belirgin hızlıdır.
export 'zlib_coz_web.dart' if (dart.library.io) 'zlib_coz_io.dart';
