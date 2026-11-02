import React, {useEffect, useState} from 'react';
import {continueRender, delayRender, AbsoluteFill, Img, Sequence, interpolate, spring, staticFile, useCurrentFrame, useVideoConfig, Easing} from 'remotion';

export type Urun = {
  kod: 'smmm' | 'ymm';
  ad: string;
  alt: string;
  ust: string; // gradyan üst
  dip: string; // gradyan alt
  cipler: string[];
  sahneler: {kare: string; ikinci?: string; baslik: string; vurgu: string; aciklama: string}[];
};

const LIMON = '#C8F04A';
const MUREKKEP = '#111827';

export const URUNLER: Record<'smmm' | 'ymm', Urun> = {
  smmm: {
    kod: 'smmm',
    ad: 'Mizan SMMM',
    alt: 'SGS ve Yeterlilik sınav hazırlığı',
    ust: '#5B4FF0',
    dip: '#231A86',
    cipler: ['5.800+ özgün soru', '3.700+ çıkmış soru · ücretsiz', '52 konu anlatımı', 'Gerçek kurallarla deneme', 'İnternetsiz çalışır'],
    sahneler: [
      {kare: 'bugun', ikinci: 'dersler', baslik: 'Sınava kaç gün kaldı,', vurgu: 'bugün ne çalışmalısın?', aciklama: 'Günlük hedef, seri ve tek dokunuşla hızlı çalışma.'},
      {kare: 'anlatim', ikinci: 'anlatimlar', baslik: 'Konu anlatımı', vurgu: 'oku ya da sesli dinle', aciklama: 'Tüm anlatımlar ana sayfadan tek dokunuş uzağında.'},
      {kare: 'soru', ikinci: 'ders', baslik: 'Her soruda çözüm ve', vurgu: 'dayanak mevzuat maddesi', aciklama: 'Yanlışların defterine düşer, tekrar karşına çıkar.'},
      {kare: 'cikmis', ikinci: 'istatistik', baslik: 'TESMER çıkmış soruları', vurgu: 'ücretsiz', aciklama: '2014–2026 SGS ve Yeterlilik, resmî cevaplarıyla.'},
    ],
  },
  ymm: {
    kod: 'ymm',
    ad: 'Tasdik YMM',
    alt: 'Yeminli Mali Müşavirlik sınav hazırlığı',
    ust: '#243044',
    dip: '#070A12',
    cipler: ['1.800+ test ve klasik soru', '79 konu anlatımı', 'Klasik vaka · öz puanlama', 'İnternetsiz çalışır'],
    sahneler: [
      {kare: 'bugun', ikinci: 'dersler', baslik: 'YMM sınavına', vurgu: 'planlı hazırlan', aciklama: '10 ders, sınav takvimi ve günlük hedef bir arada.'},
      {kare: 'anlatim', ikinci: 'anlatimlar', baslik: 'Konu anlatımı', vurgu: 'oku ya da sesli dinle', aciklama: 'Tüm anlatımlar ana sayfadan tek dokunuş uzağında.'},
      {kare: 'soru', ikinci: 'ders', baslik: 'Her soruda çözüm ve', vurgu: 'dayanak mevzuat maddesi', aciklama: 'Test ve klasik vaka soruları, adım adım çözüm.'},
      {kare: 'istatistik', ikinci: 'bugun', baslik: 'Zayıf konunu gör,', vurgu: 'onu çalış', aciklama: 'Ders ve konu bazında başarı, son 7 günün ritmi.'},
    ],
  },
};

const GIRIS = 105;
const SAHNE = 165;
const KAPANIS = 150;
export const SURE = GIRIS + SAHNE * 4 + KAPANIS; // 915 kare ≈ 30,5 sn

const YAZI_TIPLERI: [string, string, string][] = [
  ['Sora', '400', 'fonts/Sora-400.ttf'], ['Sora', '600', 'fonts/Sora-600.ttf'], ['Sora', '700', 'fonts/Sora-700.ttf'],
  ['Sora', '800', 'fonts/Sora-800.ttf'], ['Roboto', '400', 'fonts/Roboto-400.ttf'], ['Roboto', '500', 'fonts/Roboto-500.ttf'],
];

const useYaziTipleri = () => {
  const [tut] = useState(() => delayRender('yazı tipleri'));
  useEffect(() => {
    Promise.all(
      YAZI_TIPLERI.map(([ad, agirlik, dosya]) =>
        new FontFace(ad, `url(${staticFile(dosya)})`, {weight: agirlik}).load().then((y) => document.fonts.add(y)),
      ),
    ).then(() => continueRender(tut));
  }, [tut]);
};

const Zemin: React.FC<{u: Urun}> = ({u}) => {
  const f = useCurrentFrame();
  const k = (i: number) => Math.sin((f + i * 90) / 70) * 30;
  return (
    <AbsoluteFill style={{background: `linear-gradient(160deg, ${u.ust} 0%, ${u.dip} 100%)`, overflow: 'hidden'}}>
      <div style={{position: 'absolute', width: 900, height: 900, borderRadius: 450, right: -260 + k(0), top: -300 + k(1), background: 'radial-gradient(circle, rgba(255,255,255,0.10), rgba(255,255,255,0) 65%)'}} />
      <div style={{position: 'absolute', width: 700, height: 700, borderRadius: 350, left: -240 + k(2), bottom: -320 + k(3), background: `radial-gradient(circle, ${LIMON}22, ${LIMON}00 65%)`}} />
      {/* ince ızgara noktaları */}
      <div style={{position: 'absolute', inset: 0, backgroundImage: 'radial-gradient(rgba(255,255,255,0.07) 1.5px, transparent 1.5px)', backgroundSize: '44px 44px'}} />
    </AbsoluteFill>
  );
};

const Telefon: React.FC<{src: string; genislik: number; style?: React.CSSProperties}> = ({src, genislik, style}) => {
  const yuk = Math.round((genislik * 2340) / 1080);
  const pay = Math.round(genislik * 0.035);
  return (
    <div style={{position: 'absolute', width: genislik + 2 * pay, height: yuk + 2 * pay, borderRadius: genislik * 0.13, background: '#0B0F17', padding: pay, boxShadow: '0 50px 120px rgba(0,0,0,0.45), 0 0 0 2px rgba(255,255,255,0.08)', ...style}}>
      <Img src={src} style={{width: genislik, height: yuk, borderRadius: genislik * 0.085, display: 'block'}} />
    </div>
  );
};

const Kelimeler: React.FC<{metin: string; bas: number; renk: string; boy: number; agirlik?: number; zemin?: string}> = ({metin, bas, renk, boy, agirlik = 800, zemin}) => {
  const f = useCurrentFrame();
  const {fps} = useVideoConfig();
  return (
    <div style={{display: 'flex', flexWrap: 'wrap', columnGap: boy * 0.28}}>
      {metin.split(' ').map((w, i) => {
        const s = spring({frame: f - bas - i * 3, fps, config: {damping: 16, mass: 0.6}});
        return (
          <span key={i} style={{display: 'inline-block', overflow: 'hidden', padding: zemin ? `${boy * 0.06}px 0 ${boy * 0.14}px` : `0 0 ${boy * 0.22}px`, marginBottom: zemin ? boy * 0.1 : -boy * 0.1}}>
            <span style={{display: 'inline-block', transform: `translateY(${(1 - s) * 110}%)`, opacity: s, color: renk, fontFamily: 'Sora', fontWeight: agirlik, fontSize: boy, lineHeight: 1.12, letterSpacing: -boy * 0.02, background: zemin, borderRadius: boy * 0.16, padding: zemin ? `${boy * 0.02}px ${boy * 0.16}px ${boy * 0.08}px` : undefined}}>{w}</span>
          </span>
        );
      })}
    </div>
  );
};

const Giris: React.FC<{u: Urun}> = ({u}) => {
  const f = useCurrentFrame();
  const {fps} = useVideoConfig();
  const s = spring({frame: f, fps, config: {damping: 12}});
  const cizgi = interpolate(f, [28, 55], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp', easing: Easing.out(Easing.cubic)});
  const cikis = interpolate(f, [GIRIS - 14, GIRIS], [1, 0], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'});
  return (
    <AbsoluteFill style={{alignItems: 'center', justifyContent: 'center', opacity: cikis}}>
      <div style={{display: 'flex', alignItems: 'center', gap: 56}}>
        <Img src={staticFile(`logo/${u.kod}.png`)} style={{width: 260, height: 260, borderRadius: 64, border: '4px solid rgba(255,255,255,0.22)', transform: `scale(${0.6 + 0.4 * s}) rotate(${(1 - s) * -12}deg)`, opacity: s, boxShadow: '0 30px 80px rgba(0,0,0,0.35)'}} />
        <div>
          <Kelimeler metin={u.ad} bas={8} renk="#fff" boy={124} />
          <div style={{height: 10, width: 220 * cizgi, background: LIMON, borderRadius: 5, margin: '6px 0 22px'}} />
          <Kelimeler metin={u.alt} bas={26} renk={LIMON} boy={50} agirlik={600} />
        </div>
      </div>
    </AbsoluteFill>
  );
};

const Sahne: React.FC<{u: Urun; i: number}> = ({u, i}) => {
  const f = useCurrentFrame();
  const {fps} = useVideoConfig();
  const sh = u.sahneler[i];
  const sag = i % 2 === 0; // telefonlar sırayla sağda / solda
  const giris = spring({frame: f - 4, fps, config: {damping: 15, mass: 0.9}});
  const ikinci = spring({frame: f - 14, fps, config: {damping: 15, mass: 0.9}});
  const cikis = interpolate(f, [SAHNE - 12, SAHNE], [1, 0], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'});
  const yuz = interpolate(f, [0, SAHNE], [1, 1.04]);
  const acik = interpolate(f, [30, 46], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'});
  const telX = sag ? 1130 : 210;
  const yaziX = sag ? 140 : 960;
  return (
    <AbsoluteFill style={{opacity: cikis}}>
      {sh.ikinci && (
        <Telefon src={staticFile(`kare/${u.kod}_${sh.ikinci}.png`)} genislik={330}
          style={{left: telX + (sag ? 300 : -170), top: 190 + (1 - ikinci) * 700, transform: `rotate(${sag ? 6 : -6}deg) scale(0.92)`, opacity: 0.55 * ikinci}} />
      )}
      <Telefon src={staticFile(`kare/${u.kod}_${sh.kare}.png`)} genislik={390}
        style={{left: telX, top: 95 + (1 - giris) * 900, transform: `rotate(${(sag ? -3 : 3) * giris}deg) scale(${yuz})`}} />
      <div style={{position: 'absolute', left: yaziX, top: 300, width: 860}}>
        <div style={{fontFamily: 'Sora', fontWeight: 700, fontSize: 26, color: LIMON, letterSpacing: 4, marginBottom: 22, opacity: giris}}>
          {String(i + 1).padStart(2, '0')} / 04
        </div>
        <Kelimeler metin={sh.baslik} bas={6} renk="#fff" boy={68} />
        <div style={{marginLeft: -11}}>
          <Kelimeler metin={sh.vurgu} bas={14} renk={MUREKKEP} boy={68} zemin={LIMON} />
        </div>
        <div style={{fontFamily: 'Roboto', fontSize: 34, color: 'rgba(255,255,255,0.82)', marginTop: 34, lineHeight: 1.4, opacity: acik, transform: `translateY(${(1 - acik) * 20}px)`}}>
          {sh.aciklama}
        </div>
      </div>
    </AbsoluteFill>
  );
};

const Kapanis: React.FC<{u: Urun}> = ({u}) => {
  const f = useCurrentFrame();
  const {fps} = useVideoConfig();
  const s = spring({frame: f, fps, config: {damping: 13}});
  return (
    <AbsoluteFill style={{alignItems: 'center', justifyContent: 'center', flexDirection: 'column'}}>
      <div style={{display: 'flex', alignItems: 'center', gap: 40, transform: `scale(${0.8 + 0.2 * s})`, opacity: s}}>
        <Img src={staticFile(`logo/${u.kod}.png`)} style={{width: 170, height: 170, borderRadius: 42, boxShadow: '0 0 0 4px rgba(255,255,255,0.22), 0 24px 60px rgba(0,0,0,0.35)'}} />
        <div style={{fontFamily: 'Sora', fontWeight: 800, fontSize: 100, color: '#fff', letterSpacing: -2}}>{u.ad}</div>
      </div>
      <div style={{display: 'flex', gap: 22, marginTop: 64, flexWrap: 'wrap', justifyContent: 'center', width: 1500}}>
        {u.cipler.map((c, i) => {
          const a = spring({frame: f - 14 - i * 6, fps, config: {damping: 14}});
          return (
            <div key={c} style={{fontFamily: 'Sora', fontWeight: 600, fontSize: 32, color: '#fff', padding: '18px 30px', borderRadius: 999, background: 'rgba(255,255,255,0.10)', border: '2px solid rgba(255,255,255,0.18)', transform: `translateY(${(1 - a) * 40}px)`, opacity: a}}>
              {c}
            </div>
          );
        })}
      </div>
      <div style={{marginTop: 70, opacity: interpolate(f, [50, 66], [0, 1], {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'})}}>
        <div style={{fontFamily: 'Sora', fontWeight: 800, fontSize: 44, color: MUREKKEP, background: LIMON, padding: '22px 52px', borderRadius: 24}}>
          Google Play’de · ücretsiz indir
        </div>
      </div>
    </AbsoluteFill>
  );
};

const Ilerleme: React.FC = () => {
  const f = useCurrentFrame();
  return <div style={{position: 'absolute', left: 0, bottom: 0, height: 8, width: `${(f / SURE) * 100}%`, background: LIMON}} />;
};

export const Tanitim: React.FC<{u: Urun}> = ({u}) => {
  useYaziTipleri();
  return (
  <AbsoluteFill>
    <Zemin u={u} />
    <Sequence durationInFrames={GIRIS}><Giris u={u} /></Sequence>
    {u.sahneler.map((_, i) => (
      <Sequence key={i} from={GIRIS + i * SAHNE} durationInFrames={SAHNE}><Sahne u={u} i={i} /></Sequence>
    ))}
    <Sequence from={GIRIS + 4 * SAHNE} durationInFrames={KAPANIS}><Kapanis u={u} /></Sequence>
    <Ilerleme />
  </AbsoluteFill>
  );
};
