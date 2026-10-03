import 'package:flutter/material.dart';

import '../bilesenler/duzen.dart';
import 'bugun.dart';
import 'deneme_listesi.dart';
import 'dersler.dart';
import 'istatistik.dart';

class AnaKabuk extends StatefulWidget {
  const AnaKabuk({super.key});

  @override
  State<AnaKabuk> createState() => _AnaKabukState();
}

class _AnaKabukState extends State<AnaKabuk> {
  int _sekme = 0;

  static const _sekmeler = [
    (Icons.today_outlined, Icons.today, 'Bugün'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Dersler'),
    (Icons.timer_outlined, Icons.timer, 'Deneme'),
    (Icons.insights_outlined, Icons.insights, 'İstatistik'),
  ];

  @override
  Widget build(BuildContext context) {
    // Geniş ekranda (tablet, yatay) alttaki çubuk yerine yan kenar çubuğu kullanılır.
    final genis = MediaQuery.sizeOf(context).width >= genisEkranEsigi;
    final icerik = IndexedStack(
      index: _sekme,
      children: const [BugunEkrani(), DerslerEkrani(), DenemeListesi(), IstatistikEkrani()],
    );
    return Scaffold(
      body: genis
          ? Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: _sekme,
                    onDestinationSelected: (i) => setState(() => _sekme = i),
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final (ikon, secili, ad) in _sekmeler)
                        NavigationRailDestination(icon: Icon(ikon), selectedIcon: Icon(secili), label: Text(ad)),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: MediaQuery.removePadding(context: context, removeLeft: true, child: icerik),
                ),
              ],
            )
          : icerik,
      bottomNavigationBar: genis
          ? null
          : NavigationBar(
              selectedIndex: _sekme,
              onDestinationSelected: (i) => setState(() => _sekme = i),
              destinations: [
                for (final (ikon, secili, ad) in _sekmeler)
                  NavigationDestination(icon: Icon(ikon), selectedIcon: Icon(secili), label: ad),
              ],
            ),
    );
  }
}
