import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
for (const url of ['http://127.0.0.1:5173/?w=w_login1&db=mock','http://127.0.0.1:5173/?app=1&db=mock']) {
  await page.goto(url, { waitUntil: 'load' });
  await page.waitForTimeout(4000);
  const s = await page.evaluate(() => ({
    body: document.body.innerText.replace(/\s+/g,' ').slice(0,400),
    inputs: [...document.querySelectorAll('input')].map(i => ({type:i.type, name:i.name, cls:i.className, ph:i.placeholder, val:i.value})),
    buttons: [...document.querySelectorAll('button')].map(b => ({text:b.textContent.trim().slice(0,30), cls:b.className})).slice(0,20),
    windows: window.rt ? [...window.rt.windowInstances.keys()] : [],
  }));
  console.log('===', url, JSON.stringify(s));
}
await browser.close();
