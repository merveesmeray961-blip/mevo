import 'package:flutter/material.dart';

/// Okunabilir içeriğin en geniş hâli (dp). Daha geniş ekranlarda (tablet, yatay telefon) içerik ortalanır.
const okumaGenisligi = 720.0;

/// Kenar çubuğu (NavigationRail) kullanılan en küçük ekran genişliği (dp).
const genisEkranEsigi = 840.0;

/// İki sütunlu düzene geçilen en küçük içerik genişliği (dp). 10" tabletin yatay hali ve daha geniş ekranlar;
/// dikey tabletlerde ve telefonlarda tek sütun kalır (büyük yazı boyutlarında taşma olmasın).
const ikiSutunEsigi = 900.0;

/// İki sütunlu düzende içeriğin en geniş hali (dp).
const tabletGenisligi = 1180.0;

/// İçeriği [okumaGenisligi] ile sınırlayıp ortalar.
class OrtalaGenislik extends StatelessWidget {
  final Widget child;

  /// Alt çubuk gibi yalnızca içeriği kadar yer kaplaması gereken yerlerde true.
  final bool icerikYuksekligi;

  /// İçeriğin en geniş hali (dp); iki sütunlu tablet düzenlerinde [tabletGenisligi] verilir.
  final double enGenis;

  const OrtalaGenislik({
    super.key,
    required this.child,
    this.icerikYuksekligi = false,
    this.enGenis = okumaGenisligi,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: icerikYuksekligi ? 1 : null,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: enGenis),
      child: child,
    ),
  );
}

/// Uzun sayfalar için ListView: aşağı inildikçe sağ altta "başa dön" düğmesi belirir (mevzuat, anlatım gibi).
class YukariCikListe extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const YukariCikListe({
    super.key,
    required this.children,
    this.padding,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  /// Düğme, bu kadar dp aşağı inildikten sonra görünür.
  static const gorunmeEsigi = 600.0;

  @override
  State<YukariCikListe> createState() => _YukariCikListeState();
}

class _YukariCikListeState extends State<YukariCikListe> {
  final _kaydirma = ScrollController();
  bool _goster = false;

  @override
  void initState() {
    super.initState();
    _kaydirma.addListener(_dinle);
  }

  void _dinle() {
    final goster = _kaydirma.hasClients && _kaydirma.offset > YukariCikListe.gorunmeEsigi;
    if (goster != _goster) setState(() => _goster = goster);
  }

  @override
  void dispose() {
    _kaydirma.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
          controller: _kaydirma,
          padding: widget.padding,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          children: widget.children,
        ),
        if (_goster)
          Positioned(
            right: 16,
            bottom: 16,
            // heroTag: sekmelerde birden fazla düğme aynı ağaçta bulunabildiği için paylaşılan etiket kullanılmaz.
            child: FloatingActionButton.small(
              heroTag: null,
              tooltip: 'Başa dön',
              onPressed: () =>
                  _kaydirma.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut),
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
      ],
    );
  }
}

/// Ekran gövdesi: çentik/kenar boşluklarına (yatay ve alt) saygı gösterir ve içeriği ortalar. Üst boşluğu AppBar karşılar.
class Govde extends StatelessWidget {
  final Widget child;
  final double enGenis;

  const Govde({super.key, required this.child, this.enGenis = okumaGenisligi});

  @override
  Widget build(BuildContext context) =>
      SafeArea(top: false, child: OrtalaGenislik(enGenis: enGenis, child: child));
}
