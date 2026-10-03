import 'package:flutter/material.dart';

/// Okunabilir içeriğin en geniş hâli (dp). Daha geniş ekranlarda (tablet, yatay telefon) içerik ortalanır.
const okumaGenisligi = 720.0;

/// Kenar çubuğu (NavigationRail) kullanılan en küçük ekran genişliği (dp).
const genisEkranEsigi = 840.0;

/// İçeriği [okumaGenisligi] ile sınırlayıp ortalar.
class OrtalaGenislik extends StatelessWidget {
  final Widget child;

  /// Alt çubuk gibi yalnızca içeriği kadar yer kaplaması gereken yerlerde true.
  final bool icerikYuksekligi;

  const OrtalaGenislik({super.key, required this.child, this.icerikYuksekligi = false});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: icerikYuksekligi ? 1 : null,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: okumaGenisligi),
      child: child,
    ),
  );
}

/// Ekran gövdesi: çentik/kenar boşluklarına (yatay ve alt) saygı gösterir ve içeriği ortalar. Üst boşluğu AppBar karşılar.
class Govde extends StatelessWidget {
  final Widget child;

  const Govde({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SafeArea(top: false, child: OrtalaGenislik(child: child));
}
