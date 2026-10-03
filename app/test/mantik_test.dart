import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mevo/abonelik/abonelik.dart';
import 'package:mevo/mantik/deneme.dart';
import 'package:mevo/veri/depo.dart';
import 'package:mevo/veri/ilerleme.dart';
import 'package:mevo/veri/modeller.dart';

import 'yardimci.dart';

void main() {
  final banka = gercekBanka();

  group('Soru paketi', () {
    test('tüm sorular okunur ve her sorunun doğru şıkkı seçeneklerde vardır', () {
      expect(banka.sorular, isNotEmpty);
      for (final s in banka.sorular) {
        expect(s.secenekler.keys.toSet(), harfler.toSet(), reason: s.id);
        expect(harfler, contains(s.dogru), reason: s.id);
        expect(banka.dersler[s.ders]?.konular[s.konu], isNotNull, reason: '${s.id} konu adı yok');
      }
    });

    test('yazara yönelik teknik notları açıklamada görünmez, püf noktalarına taşınır', () {
      for (final s in banka.sorular) {
        expect(s.dogruNeden, isNot(matches(RegExp(r'Kullanılan teknikler|Zorluk \(\d\) kaynakları'))), reason: s.id);
      }
      expect(banka.sorular.where((s) => s.pufNoktalari != null), isNotEmpty);
    });

    test('sınav kuralları resmî değerlerle aynı', () {
      final yet = banka.formatlar['YET']!;
      expect(yet.dersBasinaSoru, 20);
      expect(yet.dersBasinaSureDk, 45);
      expect(yet.yanlisCezasi, 0.25);
      expect(yet.dersMin, 50);
      expect(yet.ortalamaMin, 60);
      expect(yet.oturumlar, [
        ['FIN', 'MAL', 'HUK', 'SPK'],
        ['TAB', 'DEN', 'VER', 'MES'],
      ]);
      final sgs = banka.formatlar['SGS']!;
      expect(sgs.toplamSoru, 130);
      expect(sgs.toplamSureDk, 165);
      expect(sgs.yanlisCezasi, 0);
    });

    test('takvim: sıradaki sınav doğru seçilir, takvim bitince null', () {
      expect(banka.sonrakiSinav('YET', DateTime(2026, 10, 5)), DateTime(2026, 11, 28));
      expect(banka.sonrakiSinav('SGS', DateTime(2026, 11, 21, 15)), DateTime(2026, 11, 21));
      expect(banka.sonrakiSinav('SGS', DateTime(2026, 11, 22)), isNull);
    });

    test('bölüm dersleri yalnız o sınavda olan dersleri içerir', () {
      final yet = banka.bolumDersleri('YET').map((d) => d.kod).toSet();
      expect(yet, containsAll(['FIN', 'MAL', 'HUK', 'SPK', 'TAB', 'DEN', 'VER', 'MES']));
      expect(yet, isNot(contains('EKO')));
      final sgs = banka.bolumDersleri('SGS').map((d) => d.kod).toSet();
      expect(sgs, isNot(contains('VER')));
      expect(sgs, contains('EKO'));
    });
  });

  group('Yeterlilik puanı', () {
    test('20 soruda 12 doğru 4 yanlış = (12 − 1) × 5 = 55', () {
      expect(yetDersPuani(20, 12, 4, 0.25), 55);
    });
    test('küsurat yuvarlanmaz', () {
      expect(yetDersPuani(20, 11, 1, 0.25), closeTo(53.75, 1e-9));
    });
    test('puan sıfırın altına inmez', () {
      expect(yetDersPuani(20, 0, 20, 0.25), 0);
    });
  });

  group('Deneme planı', () {
    test('ders denemesi en fazla 20 soru, süre soru başına 135 sn', () {
      final p = denemePlanla(banka, DenemeTuru.yetDers, ders: 'FIN', rastgele: Random(1));
      expect(p.hedefToplam, 20);
      expect(p.sorular.length, min(20, banka.dersSorulari('YET', 'FIN').length));
      expect(p.sureSn, p.sorular.length * 135);
      expect(p.sorular.every((s) => s.ders == 'FIN' && s.bolumde('YET')), isTrue);
      expect(p.sorular.map((s) => s.id).toSet().length, p.sorular.length);
    });

    test('oturum denemesi 4 ders ve 180 dakikalık orana göre', () {
      final p = denemePlanla(banka, DenemeTuru.yetOturum, oturum: 2, rastgele: Random(1));
      expect(p.dersler, ['TAB', 'DEN', 'VER', 'MES']);
      expect(p.hedefToplam, 80);
    });

    test('SGS denemesi yalnız SGS sorularından ve süre 165/130 oranında', () {
      final p = denemePlanla(banka, DenemeTuru.sgs, rastgele: Random(1));
      expect(p.sorular.every((s) => s.bolumde('SGS')), isTrue);
      expect(p.sureSn, p.sorular.length * (165 * 60 / 130).round());
    });

    test('yeterli soru varsa zorluk dağılımı hedefe uyar', () {
      final havuz = [
        for (var i = 0; i < 60; i++)
          Soru(
            id: 'X-$i',
            surum: 1,
            bolum: const ['YET'],
            ders: 'FIN',
            konu: 'K',
            tip: 'bilgi',
            zorluk: i % 3 + 1,
            kok: '',
            secenekler: const {'A': '', 'B': '', 'C': '', 'D': '', 'E': ''},
            dogru: 'A',
            dogruNeden: '',
            celdiriciler: const {},
            hesapAdimlari: const [],
            kaynaklar: const [],
          ),
      ];
      final b = SoruBankasi(
        olusturma: '',
        uyari: '',
        formatlar: banka.formatlar,
        dersler: banka.dersler,
        sorular: havuz,
        takvim: const {},
      );
      final p = denemePlanla(b, DenemeTuru.yetDers, ders: 'FIN', rastgele: Random(3));
      expect(p.sorular.length, 20);
      expect(p.sorular.where((s) => s.zorluk == 1).length, 4);
      expect(p.sorular.where((s) => s.zorluk == 2).length, 9);
      expect(p.sorular.where((s) => s.zorluk == 3).length, 7);
    });

    test('puanlama: boş bırakılan ceza almaz, geçme barajı uygulanır', () {
      final p = denemePlanla(banka, DenemeTuru.yetDers, ders: 'VER', rastgele: Random(2));
      final n = p.sorular.length;
      final cevaplar = <String, String>{};
      // ilk yarı doğru, sonraki 2 yanlış, kalan boş
      for (var i = 0; i < n; i++) {
        final s = p.sorular[i];
        if (i < n ~/ 2) {
          cevaplar[s.id] = s.dogru;
        } else if (i < n ~/ 2 + 2) {
          cevaplar[s.id] = harfler.firstWhere((h) => h != s.dogru);
        }
      }
      final sonuc = denemePuanla(banka, p, cevaplar, 600);
      final d = sonuc.dersler['VER']!;
      expect(d.dogru, n ~/ 2);
      expect(d.yanlis, 2);
      expect(d.bos, n - n ~/ 2 - 2);
      expect(d.puan, closeTo((n ~/ 2 - 0.5) * 100 / n, 1e-9));
      expect(sonuc.gecti, d.puan >= 50);
    });

    test('SGS puanı doğru oranıdır ve geçme kararı verilmez (bağıl)', () {
      final p = denemePlanla(banka, DenemeTuru.sgs, rastgele: Random(2));
      final cevaplar = {for (final s in p.sorular.take(10)) s.id: s.dogru};
      final sonuc = denemePuanla(banka, p, cevaplar, 100);
      expect(sonuc.puan, closeTo(1000 / p.sorular.length, 1e-9));
      expect(sonuc.gecti, isNull);
    });
  });

  group('İlerleme ve aralıklı tekrar', () {
    late Saat saat;
    late BellekDepo depo;
    late Ilerleme il;
    final soru = banka.sorular.first;
    final yanlisSik = harfler.firstWhere((h) => h != soru.dogru);

    setUp(() {
      saat = Saat(DateTime(2026, 10, 5, 10));
      depo = BellekDepo();
      il = Ilerleme(depo, simdi: () => saat.simdi);
    });

    test('doğru cevap kutuyu yükseltir ve tekrar aralığını uzatır', () async {
      await il.cevapla(soru, soru.dogru);
      expect(il.durum(soru.id)!.kutu, 1);
      expect(il.tekrarZamani(soru.id), isFalse);
      saat.ilerlet(const Duration(days: 1));
      expect(il.tekrarZamani(soru.id), isTrue);
      await il.cevapla(soru, soru.dogru);
      expect(il.durum(soru.id)!.kutu, 2);
      saat.ilerlet(const Duration(days: 2));
      expect(il.tekrarZamani(soru.id), isFalse);
      saat.ilerlet(const Duration(days: 1));
      expect(il.tekrarZamani(soru.id), isTrue);
    });

    test('yanlış cevap ilk kutuya döndürür, yanlış defterine ekler ve kısa sürede tekrar sorar', () async {
      await il.cevapla(soru, soru.dogru);
      await il.cevapla(soru, yanlisSik);
      final d = il.durum(soru.id)!;
      expect(d.kutu, 0);
      expect(il.yanlislar(banka.sorular), [soru]);
      saat.ilerlet(const Duration(minutes: yanlisTekrarDakika));
      expect(il.tekrarlar(banka.sorular), [soru]);
      await il.cevapla(soru, soru.dogru);
      expect(il.yanlislar(banka.sorular), isEmpty);
    });

    test('ilerleme depoya yazılır ve yeniden açılınca okunur', () async {
      await il.cevapla(soru, yanlisSik);
      await il.isaretle(soru.id, true);
      final yeni = Ilerleme(depo, simdi: () => saat.simdi);
      expect(yeni.durum(soru.id)!.deneme, 1);
      expect(yeni.durum(soru.id)!.isaretli, isTrue);
      expect(yeni.bugunCozulen, 1);
    });

    test('günlük sayaç ve seri', () async {
      await il.cevapla(soru, soru.dogru);
      saat.ilerlet(const Duration(days: 1));
      await il.cevapla(soru, soru.dogru);
      expect(il.seri, 2);
      saat.ilerlet(const Duration(days: 1));
      expect(il.bugunCozulen, 0);
      expect(il.seri, 2, reason: 'bugün henüz çözülmediyse seri dünden sayılır');
      saat.ilerlet(const Duration(days: 1));
      expect(il.seri, 0);
      expect(il.sonYediGun().reduce((a, b) => a + b), 2);
    });

    test('çalışma sırası: önce tekrar zamanı gelenler, sonra yeniler', () async {
      final havuz = banka.dersSorulari('YET', 'FIN');
      await il.cevapla(havuz[0], harfler.firstWhere((h) => h != havuz[0].dogru));
      await il.cevapla(havuz[1], havuz[1].dogru);
      saat.ilerlet(const Duration(hours: 1));
      final sira = il.calismaSirasi(havuz, havuz.length, tohum: 1);
      expect(sira.first, havuz[0]);
      expect(sira.last, havuz[1]);
      expect(sira.toSet().length, havuz.length);
    });
  });

  group('Ücretsiz sınır', () {
    test('günlük soru hakkı dolunca kapanır, ertesi gün açılır; tam erişimde sınır yok', () async {
      final saat = Saat(DateTime(2026, 10, 5, 10));
      final durum = durumOlustur(saat: saat, bolum: 'YET');
      final soru = durum.banka.sorular.first;
      for (var i = 0; i < ucretsizGunlukSoru; i++) {
        expect(durum.soruHakkiVar, isTrue);
        await durum.ilerleme.cevapla(soru, soru.dogru);
      }
      expect(durum.soruHakkiVar, isFalse);
      expect(durum.kalanUcretsizSoru, 0);
      saat.ilerlet(const Duration(days: 1));
      expect(durum.soruHakkiVar, isTrue);
      saat.ilerlet(const Duration(days: -1));
      await durum.abonelik.satinAl(durum.abonelik.paketler.first);
      expect(durum.soruHakkiVar, isTrue);
    });

    test('deneme hakkı ilk denemeden sonra kapanır', () async {
      final durum = durumOlustur(bolum: 'YET');
      expect(durum.denemeHakkiVar, isTrue);
      final p = denemePlanla(durum.banka, DenemeTuru.yetDers, ders: 'FIN');
      await durum.ilerleme.denemeEkle(denemePuanla(durum.banka, p, const {}, 0).kayit(durum.ilerleme.simdi));
      expect(durum.denemeHakkiVar, isFalse);
    });
  });
}
