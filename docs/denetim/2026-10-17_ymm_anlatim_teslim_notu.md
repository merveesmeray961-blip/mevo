# YMM konu anlatımları — teslim notu (17.10.2026)

## Kapsam
10 ders, 59 konu (10-13 tarihli paketler esas alındı; 10-11 paketleriyle görev içeriği aynıdır).

| Ders | Konular |
|---|---|
| DRM | BDS, RAP, YMM, MHK, KGK |
| DTK | GMR, REJ, IHI, KMB, VRG |
| FYN | ZDP, SBT, SMR, ISY, RGT, FPA |
| GUV | GVM, GVI, KVM, KVI, DAR, ASG |
| HSV | KDV, KIS, OTV, DMG, SRV, USL |
| IFM | KON, ENF, FAR, KUR, KIR, VRG, BDB |
| REV | GNL, AKT, PSF, GLR, VIN, TAS |
| SPM | GEN, IHR, HAO, YKF, DNT, SUC |
| VTK | DEG, TFR, BDB, MTR, TSV, CEZ |
| YNM | MHK, KRV, BTC, FDM, PRF, DEG |

## Kalite güvencesi
1. **Otomatik doğrulayıcı** (ANLATIM_KURALLARI'ndan daha sıkı): A00–A08 kodları, ön bilgi/YAML, `durum: taslak`,
   her kazanım ifadesinin metinde harfiyen geçmesi, 3–6 hedef / 4–8 özet maddesi, en az 2 not kutusu, adım adım örnek,
   tasdik/inceleme uygulama notu, desteklenmeyen biçim taraması, yasak ifadeler, kelime sayısı (iki farklı sayım yöntemiyle
   900–1.800 içinde; ön bilgi dahil toplam da ≤1.800). **Her alıntı, kaynak dosyada TEK SATIR içinde birebir** aranır —
   ön elemenin hangi arama yöntemini kullandığından bağımsız olarak bulunur. Sonuç: **59/59 hatasız.**
2. **Bağımsız denetim:** Her konu, metni yazmamış ayrı bir denetçi tarafından cümle cümle kaynakla karşılaştırıldı
   (madde/paragraf no, oran, süre, tutar, şart, mülga hüküm, THP kodu). Her sayısal örnek Python ile yeniden hesaplandı.
   Denetimde toplam ~260 düzeltme yapıldı (çoğu eksik şart, lafızdan sapma, fazla kesin genelleme; birkaçı esaslı:
   ör. ters yazılmış formül, yanlış madde atfı, mantık hatalı örnek). Ayrıntılar `raporlar/<DERS>/_DENETIM_<KONU>.txt`.
3. **Önceki REV taslakları** (anlatim_YMM_REV.zip) reddedildi ve sıfırdan yazıldı: alıntılarının çoğu kaynaklarda yoktu,
   numaralı bölüm yapısı/kazanım ifadeleri eksikti, desteklenmeyen `---` çizgileri vardı.

## Editörün bilmesi gerekenler — kaynak paketindeki eksikler
Bu bilgiler kaynaklarda olmadığı için **rakam/hüküm uydurulmadı**; konu genel tanımla ya da kanuni metinle işlendi:
- **DRM/YMM:** VUK md.227 metni kaynak klasöründe yok. Sorumluluk 3568 md.12 ve Tasdik Yönetmeliği ile anlatıldı.
  Tasdik raporu teslim süresi ve KDV iade raporu süreleri kaynakta yok. "Tam tasdik" terimi kaynaklarda tanımlı değil (yalnız 2026 ücret tarifesinde geçiyor).
- **Cumhurbaşkanı kararları kaynaklarda yok:** Yürürlükteki KDV oranları, KVK md.5 (9160, 11257 sayılı kararlar) ve md.30 (9707) oranları,
  GVK md.94 fiili tevkifat oranları, finansman gider kısıtlaması oranı. Metinlerde **kanuni oranlar** ve yetki hükmü verildi; örneklerdeki oranlar "varsayım" diye işaretli.
- **DTK:** Incoterms, akreditif, ödeme yöntemleri, ihracat bedellerinin getirilme süresi, ÖTV Kanunu, Serbest Bölgeler Kanunu kaynakta yok — genel tanımla, rakamsız işlendi.
- **TTK** hiçbir pakette yok (birleşme/bölünme/sermaye taahhüdü ticaret hukuku boyutu rakamsız).
- **SPM:** Borçlanma Araçları Tebliği, Finansal Raporlama Tebliği (II-14.1), BD Standartları Tebliği yok.

## Kaynaklardaki çelişki/hatalar (metinlere ALINMADI)
- vuk.txt md.353/2 tutarları (14.000 / 1.400.000 / 14.000.000 TL) ile 588 Sıra No.lu VUK Tebliği (17.000 / 1.700.000 / 17.000.000 TL) çelişiyor; md.353/8 üst sınırı derlemede tutarsız yazılmış.
- vuk.txt md.352 dipnot 118'de Resmî Gazete tarihi "30/12/2026" (muhtemelen 30/12/2025).
- KDV Genel Uygulama Tebliği'nin oran bölümü ve azami iade formülü hâlâ eski %18 oranını anıyor.
- THP metninde 370 hesabının işleyişi "350"ye atıf yapıyor; bazı hesap adları liste ve açıklama bölümleri arasında farklı (520, 649, 659, 253).

## Yorum içeren (açıkça işaretlenmiş) noktalar
- GUV/GVI: GVK md.86/1-b ve 1-c'deki "dilim tutarı" ifadeleri 2026 tarifesindeki dilim sınırlarıyla eşleştirildi (yorum olduğu metinde yazılı).
- DRM/MHK: 2026 SMMM ücret tarifesindeki "%02" yazımı "binde 2" olarak okundu (tarife ekindeki EK-3 karşılık listesiyle doğrulandı).
- FYN/YNM (kaynaksız dersler): ekole bağlı her noktada kullanılan yöntem metinde açıkça belirtildi.

## Dosyalar
- `anlatim_YMM_<DERS>-2026-10-13-<n>konu.zip`: her ders için yalnız konu `.md` dosyaları (sisteme yüklenecek paket).
- `raporlar/`: yazar raporları (`_RAPOR_`: her iddia → kaynak dosya:satır), denetim raporları (`_DENETIM_`), kaynak dışı notlar (`_NOTLAR_`), doğrulayıcı betiği.
