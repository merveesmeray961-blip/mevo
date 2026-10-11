// Kullanım: node shot.js <tema> <seedmode: seed|empty|first> <steps.json>
const { chromium } = require('/opt/node22/lib/node_modules/playwright');
const fs = require('fs');
const { execFileSync } = require('child_process');
const [tema, mode, stepsFile] = process.argv.slice(2);
const OUT = __dirname + '/magaza_ham/';
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium', args: ['--no-sandbox'] });
  const ctx = await browser.newContext({ viewport: { width: 412, height: 824 }, deviceScaleFactor: 2.5, isMobile: true, hasTouch: true, colorScheme: tema === 'dark' ? 'dark' : 'light' });
  let seed = {};
  if (mode.startsWith('seed')) seed = JSON.parse(execFileSync('python3', ['-I', __dirname + '/seed.py', tema]).toString());
  if (mode === 'seedp') seed['flutter.abonelik.onizleme.v1'] = JSON.stringify('1');
  if (mode === 'empty') seed = { 'flutter.ayarlar.v1': JSON.stringify(JSON.stringify({ bolum: 'YET', tema, oturum: 10, yazi: 1.0, yaziSurum: 2 })) };
  await ctx.addInitScript((s) => { if (!sessionStorage.getItem('seeded')) { localStorage.clear(); for (const [k, v] of Object.entries(s)) localStorage.setItem(k, v); sessionStorage.setItem('seeded', '1'); } }, seed);
  await ctx.route(/gstatic\.com\/flutter-canvaskit\/[^/]+\/(.*)$/, (route) => { const m = route.request().url().match(/flutter-canvaskit\/[^/]+\/(.*)$/); route.fulfill({ path: '/home/user/mevo/app/build/web/canvaskit/' + m[1] }); });
  await ctx.route(/fonts\.gstatic\.com/, r => r.abort());
  const page = await ctx.newPage();
  page.on('pageerror', e => console.log('PAGEERR', e.message));
  await page.goto('http://localhost:8765/', { waitUntil: 'load' });
  await page.waitForSelector('flutter-view', { timeout: 30000 });
  await page.waitForTimeout(3500);
  // semantics etkinleştir
  await page.evaluate(() => { const p = document.querySelector('flt-semantics-placeholder'); if (p) p.click(); });
  await page.waitForTimeout(800);
  const steps = JSON.parse(fs.readFileSync(stepsFile));
  for (const s of steps) {
    try {
      if (s.tap) await page.mouse.click(s.tap[0], s.tap[1]);
      if (s.label) {
        const b = await page.evaluate((lab) => {
          const els = [...document.querySelectorAll('flt-semantics')];
          let e = els.find(x => (x.getAttribute('aria-label') || '').startsWith(lab));
          if (!e) { const c = els.filter(x => (x.textContent || '').includes(lab)); e = c[c.length - 1]; }
          if (!e) return null; const r = e.getBoundingClientRect(); return { x: r.x + r.width / 2, y: r.y + r.height / 2 };
        }, s.label);
        if (!b) throw new Error('no el ' + s.label);
        await page.mouse.click(b.x, b.y);
      }
      if (s.scroll) { await page.mouse.move(195, 420); await page.mouse.wheel(0, s.scroll); }
      if (s.key) await page.keyboard.press(s.key);
      if (s.move) await page.mouse.move(s.move[0], s.move[1]);
      await page.waitForTimeout(s.wait ?? 900);
      if (s.shot) await page.screenshot({ path: OUT + s.shot });
      if (s.dump) { const t = await page.evaluate(() => [...document.querySelectorAll('flt-semantics')].map(e => { const r = e.getBoundingClientRect(); const l = e.getAttribute('aria-label') || (e.childElementCount === 0 ? e.textContent : ''); return l ? `${Math.round(r.x)},${Math.round(r.y)},${Math.round(r.width)}x${Math.round(r.height)} ${e.getAttribute('role') || ''} ${l.replace(/\n/g, ' | ').slice(0, 90)}` : null; }).filter(Boolean)); console.log('--- DUMP', s.dump); console.log(t.join('\n')); }
    } catch (e) { console.log('STEPERR', JSON.stringify(s), e.message); }
  }
  await browser.close();
})();
