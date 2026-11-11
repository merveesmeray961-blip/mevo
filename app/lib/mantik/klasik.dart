import 'dart:math';

import '../veri/ilerleme.dart';
import '../veri/modeller.dart';

/// Klasik denemede hedeflenen toplam puan: gerçek sınavda her ders 100 üzerinden değerlendirilir.
const klasikHedefPuan = 100;

class KlasikDenemePlani {
  final String ders;
  final String baslik;
  final List<KlasikSoru> sorular;

  const KlasikDenemePlani({required this.ders, required this.baslik, required this.sorular});

  /// Sınav süresi: soruların önerilen yanıtlama sürelerinin toplamı.
  int get sureSn => sorular.fold(0, (a, k) => a + k.sureDk * 60);

  int get hamPuan => sorular.fold(0, (a, k) => a + k.puan);

  /// Bankada 100 puanlık bir sınav kuracak kadar soru yoksa true; ekranda kullanıcıya söylenir.
  bool get eksik => hamPuan < klasikHedefPuan;
}

/// Uygulama kapanınca kaybolmasın diye diske yazılan yarım klasik deneme (yazılan cevaplar dahil).
class YarimKlasik {
  final KlasikDenemePlani plan;
  final Map<String, String> cevaplar;
  final int gecenSn;
  final int sira;

  const YarimKlasik({required this.plan, required this.cevaplar, required this.gecenSn, required this.sira});

  int get kalanSn => (plan.sureSn - gecenSn).clamp(0, plan.sureSn);

  Map<String, dynamic> toJson() => {
    'klasik': true,
    'bolum': 'YMM',
    'ders': plan.ders,
    'baslik': plan.baslik,
    'sorular': [for (final k in plan.sorular) k.id],
    'cevaplar': cevaplar,
    'gecenSn': gecenSn,
    'sira': sira,
  };

  static YarimKlasik? fromJson(SoruBankasi banka, Map<String, dynamic>? j) {
    if (j == null || j['klasik'] != true) return null;
    try {
      final sorular = <KlasikSoru>[];
      for (final id in j['sorular'] as List) {
        final k = banka.klasik(id as String);
        if (k == null) return null;
        sorular.add(k);
      }
      if (sorular.isEmpty) return null;
      return YarimKlasik(
        plan: KlasikDenemePlani(ders: j['ders'] as String, baslik: j['baslik'] as String, sorular: sorular),
        cevaplar: Map<String, String>.from(j['cevaplar'] as Map),
        gecenSn: j['gecenSn'] as int,
        sira: (j['sira'] as int).clamp(0, sorular.length - 1),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Bir dersten klasik deneme kurar: farklı konulardan, toplamı 100 puana en yakın olacak kadar soru seçilir.
/// Önce her konudan birer soru (konu sırası karışık) alınır; puan dolmadıysa kalan sorulardan, 100'ü aşmadan tamamlanır.
/// Sorular kolaydan zora sıralanır.
KlasikDenemePlani klasikDenemePlanla(SoruBankasi banka, String ders, {Random? rastgele}) {
  final r = rastgele ?? Random();
  final havuz = [...banka.klasikSorulari(ders)]..shuffle(r);
  final konuIlk = <String, KlasikSoru>{};
  for (final k in havuz) {
    konuIlk.putIfAbsent(k.konu, () => k);
  }
  final sira = [
    ...konuIlk.values,
    for (final k in havuz)
      if (!konuIlk.containsValue(k)) k,
  ];
  // Önce gerçek sınavdaki gibi farklı konulardan tam 100 puanlık bir set aranır; bulunamazsa aşağıdaki yakınsama.
  final tam = _tamYuzPuan(havuz, r);
  if (tam != null) {
    tam.sort((a, b) => a.zorluk.compareTo(b.zorluk));
    return KlasikDenemePlani(ders: ders, baslik: '${banka.dersler[ders]?.ad ?? ders} klasik denemesi', sorular: tam);
  }
  final secilen = <KlasikSoru>[];
  var toplam = 0;
  for (final k in sira) {
    // Hedefi aşan soru alınmaz (tek sorusu 100'ü aşan derste yalnız ilk soru alınır).
    if (secilen.isNotEmpty && toplam + k.puan > klasikHedefPuan) continue;
    secilen.add(k);
    toplam += k.puan;
  }
  secilen.sort((a, b) => a.zorluk.compareTo(b.zorluk));
  return KlasikDenemePlani(ders: ders, baslik: '${banka.dersler[ders]?.ad ?? ders} klasik denemesi', sorular: secilen);
}

/// Puanları toplamı tam [klasikHedefPuan] olan rastgele bir soru seti; bulunamazsa null.
List<KlasikSoru>? _tamYuzPuan(List<KlasikSoru> havuz, Random r) {
  if (havuz.isEmpty) return null;
  final enKucuk = havuz.map((k) => k.puan).reduce(min);
  for (var deneme = 0; deneme < 300; deneme++) {
    final karisik = [...havuz]..shuffle(r);
    final secilen = <KlasikSoru>[];
    final konular = <String>{};
    var toplam = 0;
    for (final k in karisik) {
      if (konular.contains(k.konu)) continue;
      final kalan = klasikHedefPuan - toplam;
      // Ya kalanı tam kapatır ya da arkasında en az bir soru sığacak yer bırakır.
      if (k.puan > kalan || (k.puan != kalan && kalan - k.puan < enKucuk)) continue;
      secilen.add(k);
      konular.add(k.konu);
      toplam += k.puan;
      if (toplam == klasikHedefPuan) return secilen;
    }
  }
  return null;
}

/// Adayın her soruya verdiği puanlardan 100 üzerinden ders puanı (ham puan 100 değilse orantılanır).
double klasikDersPuani(KlasikDenemePlani plan, Map<String, double> verilen) {
  if (plan.hamPuan == 0) return 0;
  final alinan = plan.sorular.fold(0.0, (a, k) => a + (verilen[k.id] ?? 0).clamp(0, k.puan));
  return alinan * 100 / plan.hamPuan;
}

/// Klasik denemenin kaydı: puanlar `cevaplar` alanında soru kimliği → verilen puan olarak saklanır.
DenemeKaydi klasikKayit(
  KlasikDenemePlani plan,
  Map<String, double> verilen,
  int kullanilanSn,
  DateTime tarih, {
  required int dersMin,
}) {
  final puan = klasikDersPuani(plan, verilen);
  return DenemeKaydi(
    tarih: tarih,
    bolum: 'YMM',
    baslik: plan.baslik,
    sureSn: plan.sureSn,
    kullanilanSn: kullanilanSn,
    dersler: {plan.ders: DersSonucu(soru: plan.sorular.length, dogru: 0, yanlis: 0, puan: puan)},
    puan: puan,
    gecti: puan >= dersMin,
    soruIdler: [for (final k in plan.sorular) k.id],
    cevaplar: {for (final e in verilen.entries) e.key: e.value.toString()},
  );
}

/// Kayıtlı bir klasik denemeyi yeniden göstermek için plan ve puanları geri kurar; bankadan çıkarılmış sorular atlanır.
(KlasikDenemePlani, Map<String, double>)? klasikKayittan(SoruBankasi banka, DenemeKaydi k) {
  if (k.bolum != 'YMM' || k.soruIdler.isEmpty) return null;
  final sorular = [for (final id in k.soruIdler) ?banka.klasik(id)];
  if (sorular.isEmpty) return null;
  return (
    KlasikDenemePlani(ders: k.dersler.keys.first, baslik: k.baslik, sorular: sorular),
    {for (final e in k.cevaplar.entries) e.key: double.tryParse(e.value) ?? 0},
  );
}
