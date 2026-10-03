import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _sekme,
        children: const [BugunEkrani(), DerslerEkrani(), DenemeListesi(), IstatistikEkrani()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _sekme,
        onDestinationSelected: (i) => setState(() => _sekme = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Bugün'),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Dersler',
          ),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Deneme'),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'İstatistik',
          ),
        ],
      ),
    );
  }
}
