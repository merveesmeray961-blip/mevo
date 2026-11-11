import 'package:archive/archive.dart';

List<int> zlibCoz(List<int> veri) => const ZLibDecoder().decodeBytes(veri);
