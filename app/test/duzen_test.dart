import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/ekranlar/ana_kabuk.dart';
import 'package:mevo/ekranlar/ayarlar_ekrani.dart';
import 'package:mevo/ekranlar/bolum_secimi.dart';
import 'package:mevo/ekranlar/calisma.dart';
import 'package:mevo/ekranlar/deneme.dart';
import 'package:mevo/ekranlar/dersler.dart';
import 'package:mevo/ekranlar/odeme.dart';
import 'package:mevo/mantik/deneme.dart';
import 'package:mevo/uygulama.dart';
import 'package:mevo/veri/depo.dart';

import 'yardimci.dart';

/// Ödeme ekranının mağaza durumlarını göstermek için sabit bir servis.
class SabitAbonelik extends AbonelikServisi {
  @override
  final MagazaDurumu magaza;
  @override
  final IslemDurumu islem;
  @override
  final String? hata;

  SabitAbonelik(this.magaza, {this.islem = IslemDurumu.bos, this.hata});

  @override
  bool get premium => false;

  @override
  bool get onizleme => false;

  @override
  List<AbonelikPaketi> get paketler => [
    AbonelikPaketi(
      kimlik: tamErisimKimligi,
      ad: tamErisimPaketi.ad,
      aciklama: tamErisimPaketi.aciklama,
      fiyat: magaza == MagazaDurumu.hazir ? '₺1.249,99' : null,
    ),
  ];

  @override
  Future<bool> satinAl(AbonelikPaketi paket) async => false;

  @override
  Future<bool> geriYukle() async => false;

  @override
  Future<void> baslat() async {}
}

const boyutlar = {
  'telefon küçük 320x568': Size(320, 568),
  'telefon 390x844': Size(390, 844),
  'telefon yatay 844x390': Size(844, 390),
  'tablet 820x1180': Size(820, 1180),
  'tablet geniş 1366x1024': Size(1366, 1024),
};

Future<void> pompala(
  WidgetTester tester,
  Widget ekran,
  UygulamaDurumu durum,
  Size boyut,
  double olcek,
  bool koyu,
) async {
  tester.view.physicalSize = boyut;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    Kapsam(
      durum: durum,
      child: MaterialApp(
        theme: tema(Brightness.light),
        darkTheme: tema(Brightness.dark),
        themeMode: koyu ? ThemeMode.dark : ThemeMode.light,
        locale: const Locale('tr'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(olcek)),
          child: child!,
        ),
        home: ekran,
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump(const Duration(milliseconds: 600));
}

UygulamaDurumu dolguluDurum({String bolum = 'YET'}) => durumOlustur(bolum: bolum);

Future<void> hazirla(UygulamaDurumu durum) async {
  for (final s in durum.banka.bolumSorulari(durum.bolum).take(25)) {
    await durum.ilerleme.cevapla(s, s.zorluk == 3 ? 'A' : s.dogru, gunlugeSay: false);
  }
  final plan = denemePlanla(durum.banka, DenemeTuru.yetDers, ders: 'FIN', rastgele: Random(1));
  final sonuc = denemePuanla(durum.banka, plan, {for (final s in plan.sorular.take(5)) s.id: s.dogru}, 900);
  await durum.ilerleme.denemeEkle(sonuc.kayit(DateTime(2026, 10, 4)));
}

/// Bir ekranı verilen kurulumla açar; taşma veya istisna olursa test kendiliğinden başarısız olur.
typedef EkranKurucu = Future<Widget> Function(UygulamaDurumu durum);
typedef Sonra = Future<void> Function(WidgetTester tester);

Future<void> sekmeAc(WidgetTester tester, String ad) async {
  await tester.tap(find.text(ad).last);
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  final ekranlar = <String, (EkranKurucu, Sonra?)>{
    'Bölüm seçimi': ((_) async => const BolumSecimi(ilkAcilis: true), null),
    'Bugün': ((_) async => const AnaKabuk(), null),
    'Dersler': ((_) async => const AnaKabuk(), (t) => sekmeAc(t, 'Dersler')),
    'Deneme listesi': ((_) async => const AnaKabuk(), (t) => sekmeAc(t, 'Deneme')),
    'İstatistik': ((_) async => const AnaKabuk(), (t) => sekmeAc(t, 'İstatistik')),
    'Ders detayı': ((d) async => DersDetay(ders: d.banka.dersler['FIN']!), null),
    'Çalışma (cevaplanmış soru)': (
      (d) async => CalismaEkrani(baslik: 'Hızlı çalışma', sorular: d.banka.dersSorulari('YET', 'FIN').take(5).toList()),
      (t) async {
        await t.ensureVisible(find.text('A').first);
        await t.pump();
        await t.tap(find.text('A').first);
        await t.pump(const Duration(milliseconds: 600));
        expect(find.text('Çözüm'), findsOneWidget);
      },
    ),
    'Deneme ekranı': (
      (d) async => DenemeEkrani(
        plan: denemePlanla(d.banka, DenemeTuru.yetDers, ders: 'FIN', rastgele: Random(2)),
      ),
      null,
    ),
    'Deneme sonucu': (
      (d) async {
        final plan = denemePlanla(d.banka, DenemeTuru.yetDers, ders: 'FIN', rastgele: Random(2));
        return DenemeSonucEkrani(
          sonuc: denemePuanla(d.banka, plan, {for (final s in plan.sorular.take(9)) s.id: s.dogru}, 1200),
        );
      },
      null,
    ),
    'Ayarlar': ((_) async => const AyarlarEkrani(), null),
    'Ödeme (önizleme)': ((_) async => const OdemeEkrani(neden: 'Bugünkü ücretsiz soru hakkını kullandın.'), null),
  };

  for (final MapEntry(key: ad, value: (kur, sonra)) in ekranlar.entries) {
    for (final MapEntry(key: boyutAdi, value: boyut) in boyutlar.entries) {
      for (final olcek in [1.0, 2.0]) {
        testWidgets('$ad · $boyutAdi · yazı ×$olcek${olcek > 1 ? ' · koyu' : ''}', (tester) async {
          final durum = dolguluDurum();
          await hazirla(durum);
          await pompala(tester, await kur(durum), durum, boyut, olcek, olcek > 1);
          if (sonra != null) await sonra(tester);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  final magazaDurumlari = {
    'yükleniyor': SabitAbonelik(MagazaDurumu.yukleniyor),
    'mağaza yok': SabitAbonelik(MagazaDurumu.kullanilamiyor),
    'ürün yok': SabitAbonelik(MagazaDurumu.urunYok),
    'fiyatlı': SabitAbonelik(MagazaDurumu.hazir),
    'beklemede': SabitAbonelik(MagazaDurumu.hazir, islem: IslemDurumu.beklemede),
    'hata': SabitAbonelik(
      MagazaDurumu.hazir,
      islem: IslemDurumu.hata,
      hata: 'Satın alma tamamlanamadı: kart reddedildi, lütfen başka bir ödeme yöntemi dene.',
    ),
  };
  for (final MapEntry(key: ad, value: abonelik) in magazaDurumlari.entries) {
    for (final MapEntry(key: boyutAdi, value: boyut) in boyutlar.entries) {
      testWidgets('Ödeme ($ad) · $boyutAdi · yazı ×2', (tester) async {
        final durum = UygulamaDurumu(
          banka: gercekBanka(),
          ilerleme: durumOlustur().ilerleme,
          ayarlar: durumOlustur().ayarlar,
          abonelik: abonelik,
        );
        await pompala(tester, const OdemeEkrani(), durum, boyut, 2, false);
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(find.text('Satın alımı geri yükle'), 200);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('geniş ekranda kenar çubuğu, dar ekranda alt çubuk kullanılır', (tester) async {
    final durum = dolguluDurum();
    await pompala(tester, const AnaKabuk(), durum, const Size(1366, 1024), 1, false);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await pompala(tester, const AnaKabuk(), durum, const Size(390, 844), 1, false);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('geniş ekranda içerik okuma genişliğiyle sınırlanır', (tester) async {
    final durum = dolguluDurum();
    await pompala(tester, const AyarlarEkrani(), durum, const Size(1366, 1024), 1, false);
    expect(tester.getSize(find.byType(ListView).first).width, lessThanOrEqualTo(720));
  });

  testWidgets('çentik ve kenar boşlukları (güvenli alan) içeriği iter', (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(left: 47, right: 47, bottom: 21);
    tester.view.viewPadding = const FakeViewPadding(left: 47, right: 47, bottom: 21);
    addTearDown(tester.view.reset);
    final durum = dolguluDurum();
    await tester.pumpWidget(
      Kapsam(
        durum: durum,
        child: MaterialApp(theme: tema(Brightness.light), home: const AyarlarEkrani()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.byType(ListView).first).dx, greaterThanOrEqualTo(47));
    expect(BellekDepo, isNotNull);
  });
}
