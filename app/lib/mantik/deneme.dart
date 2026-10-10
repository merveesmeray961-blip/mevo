import 'dart:math';

import '../veri/ilerleme.dart';
import '../veri/modeller.dart';

enum DenemeTuru { yetDers, yetOturum, sgs }

/// Deneme sınavında zorluk dağılımı hedefi (kolay, orta, zor). PLAN.md §8.
const zorlukHedefi = {
  'YET': [0.20, 0.45, 0.35],
  'SGS': [0.25, 0.50, 0.25],
};

class DenemePlani {
  final DenemeTuru tur;
  final String bolum;
  final String baslik;
  final List<String> dersler;
  final Map<String, int> hedef;
  final List<Soru> sorular;
  final int sureSn;

  const DenemePlani({
    required this.tur,
    required this.bolum,
    required this.baslik,
    required this.dersler,
    required this.hedef,
    required this.sorular,
    required this.sureSn,
  });

  int get hedefToplam => hedef.values.fold(0, (a, b) => a + b);

  /// Bankada henüz gerçek sınav kadar soru yoksa true; ekranda kullanıcıya söylenir.
  bool get eksik => sorular.length < hedefToplam;
}

class DenemeSonucu {
  final DenemePlani plan;
  final Map<String, String> cevaplar;
  final Map<String, DersSonucu> dersler;
  final double puan;
  final bool? gecti;
  final int kullanilanSn;

  const DenemeSonucu({
    required this.plan,
    required this.cevaplar,
    required this.dersler,
    required this.puan,
    required this.gecti,
    required this.kullanilanSn,
  });

  int get dogru => dersler.values.fold(0, (a, d) => a + d.dogru);
  int get yanlis => dersler.values.fold(0, (a, d) => a + d.yanlis);
  int get bos => dersler.values.fold(0, (a, d) => a + d.bos);

  DenemeKaydi kayit(DateTime tarih) => DenemeKaydi(
    tarih: tarih,
    bolum: plan.bolum,
    baslik: plan.baslik,
    sureSn: plan.sureSn,
    kullanilanSn: kullanilanSn,
    dersler: dersler,
    puan: puan,
    gecti: gecti,
    soruIdler: [for (final s in plan.sorular) s.id],
    cevaplar: cevaplar,
  );

  /// Kayıtlı bir denemeyi sonuç ekranında yeniden göstermek için sonucu geri kurar. Bankadan çıkarılmış sorular
  /// atlanır; puanlar kayıttaki gibi kalır. Soru listesi saklanmamış eski kayıtlarda null döner.
  static DenemeSonucu? kayittan(SoruBankasi banka, DenemeKaydi k) {
    if (k.soruIdler.isEmpty) return null;
    final sorular = [for (final id in k.soruIdler) ?banka.soru(id)];
    return DenemeSonucu(
      plan: DenemePlani(
        tur: k.bolum == 'SGS' ? DenemeTuru.sgs : (k.dersler.length > 1 ? DenemeTuru.yetOturum : DenemeTuru.yetDers),
        bolum: k.bolum,
        baslik: k.baslik,
        dersler: k.dersler.keys.toList(),
        hedef: {for (final e in k.dersler.entries) e.key: e.value.soru},
        sorular: sorular,
        sureSn: k.sureSn,
      ),
      cevaplar: k.cevaplar,
      dersler: k.dersler,
      puan: k.puan,
      gecti: k.gecti,
      kullanilanSn: k.kullanilanSn,
    );
  }
}

/// Soru başına süre, gerçek sınavın süre/soru oranından hesaplanır; böylece bankada eksik soru
/// olduğunda da adayın hızı gerçek sınavdakiyle aynı ölçülür.
int soruBasinaSn(SinavFormati f) {
  if (f.dersBasinaSoru != null && f.dersBasinaSureDk != null) return f.dersBasinaSureDk! * 60 ~/ f.dersBasinaSoru!;
  return (f.toplamSureDk! * 60 / f.toplamSoru!).round();
}

DenemePlani denemePlanla(SoruBankasi banka, DenemeTuru tur, {String? ders, int oturum = 1, Random? rastgele}) {
  final r = rastgele ?? Random();
  final bolum = tur == DenemeTuru.sgs ? 'SGS' : 'YET';
  final f = banka.formatlar[bolum]!;
  final Map<String, int> hedef;
  final String baslik;
  switch (tur) {
    case DenemeTuru.yetDers:
      hedef = {ders!: f.dersBasinaSoru!};
      baslik = '${banka.dersler[ders]!.ad} denemesi';
    case DenemeTuru.yetOturum:
      hedef = {for (final d in f.oturumlar[oturum - 1]) d: f.dersBasinaSoru!};
      baslik = 'Yeterlilik $oturum. oturum denemesi';
    case DenemeTuru.sgs:
      hedef = {
        for (final d in banka.dersler.values)
          if (d.sgsSoru > 0 && banka.dersSorulari('SGS', d.kod).isNotEmpty) d.kod: d.sgsSoru,
      };
      baslik = 'Staja Giriş Sınavı denemesi';
  }
  final sorular = <Soru>[];
  for (final e in hedef.entries) {
    sorular.addAll(_zorlugaGoreSec(banka.dersSorulari(bolum, e.key), e.value, zorlukHedefi[bolum]!, r));
  }
  return DenemePlani(
    tur: tur,
    bolum: bolum,
    baslik: baslik,
    dersler: hedef.keys.toList(),
    hedef: hedef,
    sorular: sorular,
    sureSn: sorular.length * soruBasinaSn(f),
  );
}

/// Havuzdan [adet] soruyu zorluk hedefine en yakın dağılımla seçer; bir zorlukta yeterli soru yoksa
/// eksik kısım kalan sorulardan rastgele tamamlanır. Seçilen sorular ders içinde kolaydan zora sıralanır.
List<Soru> _zorlugaGoreSec(List<Soru> havuz, int adet, List<double> oran, Random r) {
  if (havuz.length <= adet) return [...havuz]..sort((a, b) => a.zorluk.compareTo(b.zorluk));
  final gruplar = {
    for (var z = 1; z <= 3; z++)
      z: [
        for (final s in havuz)
          if (s.zorluk == z) s,
      ]..shuffle(r),
  };
  final secilen = <Soru>[];
  for (var z = 1; z <= 3; z++) {
    secilen.addAll(gruplar[z]!.take((adet * oran[z - 1]).round()));
  }
  final kalan = [
    for (final s in havuz)
      if (!secilen.contains(s)) s,
  ]..shuffle(r);
  secilen.addAll(kalan.take(max(0, adet - secilen.length)));
  return (secilen.take(adet).toList())..sort((a, b) => a.zorluk.compareTo(b.zorluk));
}

/// Yeterlilik puanı: "100 puan sorulara eşit dağıtılır", her yanlış 0,25 doğruyu götürür, küsurat yuvarlanmaz.
/// Ders puanı 0'ın altına inmez.
double yetDersPuani(int soru, int dogru, int yanlis, double ceza) =>
    soru == 0 ? 0 : max(0, (dogru - yanlis * ceza) * 100 / soru);

DenemeSonucu denemePuanla(SoruBankasi banka, DenemePlani plan, Map<String, String> cevaplar, int kullanilanSn) {
  final f = banka.formatlar[plan.bolum]!;
  final dersler = <String, DersSonucu>{};
  for (final d in plan.dersler) {
    final sorular = [
      for (final s in plan.sorular)
        if (banka.sinavDersi(s, plan.bolum) == d) s,
    ];
    var dogru = 0, yanlis = 0;
    for (final s in sorular) {
      final c = cevaplar[s.id];
      if (c == null) continue;
      c == s.dogru ? dogru++ : yanlis++;
    }
    final puan = plan.bolum == 'YET'
        ? yetDersPuani(sorular.length, dogru, yanlis, f.yanlisCezasi)
        : (sorular.isEmpty ? 0.0 : dogru * 100 / sorular.length);
    dersler[d] = DersSonucu(soru: sorular.length, dogru: dogru, yanlis: yanlis, puan: puan);
  }
  final double puan;
  final bool? gecti;
  if (plan.bolum == 'YET') {
    puan = dersler.isEmpty ? 0 : dersler.values.fold(0.0, (a, d) => a + d.puan) / dersler.length;
    // Gerçek sınavda ortalamaya 8 ders ve tezkiye notu girer; burada denemedeki derslerle gösterge hesaplanır.
    gecti = dersler.values.every((d) => d.puan >= f.dersMin!) && (dersler.length == 1 || puan >= f.ortalamaMin!);
  } else {
    final toplam = plan.sorular.length;
    final dogru = dersler.values.fold(0, (a, d) => a + d.dogru);
    puan = toplam == 0 ? 0 : dogru * 100 / toplam;
    gecti = null; // SGS bağıl değerlendirilir; sabit bir geçme eşiği yoktur.
  }
  return DenemeSonucu(
    plan: plan,
    cevaplar: cevaplar,
    dersler: dersler,
    puan: puan,
    gecti: gecti,
    kullanilanSn: kullanilanSn,
  );
}
