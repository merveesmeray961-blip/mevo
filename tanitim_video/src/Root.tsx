import React from 'react';
import {Composition} from 'remotion';
import {Tanitim, SURE, URUNLER} from './Tanitim';

export const Root: React.FC = () => (
  <>
    <Composition id="SMMM" component={Tanitim} durationInFrames={SURE} fps={30} width={1920} height={1080} defaultProps={{u: URUNLER.smmm}} />
    <Composition id="YMM" component={Tanitim} durationInFrames={SURE} fps={30} width={1920} height={1080} defaultProps={{u: URUNLER.ymm}} />
  </>
);
