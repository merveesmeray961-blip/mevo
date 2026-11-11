import 'dart:io';

List<int> zlibCoz(List<int> veri) => ZLibDecoder().convert(veri);
