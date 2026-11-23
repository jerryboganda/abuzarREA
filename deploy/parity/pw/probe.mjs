import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
page.on('console', m => { if (m.type() === 'error') console.log('CONSOLE', m.text().slice(0, 300)); });
page.on('pageerror', e => console.log('PAGEERR', String(e.message).slice(0, 300)));
for (const url of [
  'http://127.0.0.1:5173/?app=1&db=mock',
  'http://127.0.0.1:5173/?w=w_main&db=mock',
  'http://127.0.0.1:5173/?autologin=admin:admin&db=mock'
]) {
  console.log('===', url);
  await page.goto(url, { waitUntil: 'load' });
  await page.waitForTimeout(6000);
  const state = await page.evaluate(() => ({
    title: document.title,
    body: document.body.innerText.replace(/\s+/g, ' ').slice(0, 300),
    rt: !!window.rt,
    windows: window.rt ? [...window.rt.windowInstances.keys()] : [],
    canvas: document.querySelectorAll('canvas').length,
    msg: [...document.querySelectorAll('.msgbox .txt')].map(x => x.textContent.slice(0,120)),
  }));
  console.log(JSON.stringify(state));
}
await browser.close();
