import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
const errors = [];
page.on('pageerror', e => errors.push(String(e.message).slice(0,200)));
await page.goto('http://127.0.0.1:5173/?app=1&db=mock', { waitUntil: 'load' });
await page.waitForTimeout(3000);
const login = page.locator('[data-obj="login"]');
const pass = page.locator('[data-obj="password"]');
await login.click();
await page.waitForSelector('input.dw-edit');
await page.locator('input.dw-edit').fill('admin');
await page.keyboard.press('Enter');
await page.waitForTimeout(800);
await pass.click();
await page.waitForSelector('input.dw-edit');
await page.locator('input.dw-edit').fill('admin');
await page.keyboard.press('Enter');
await page.waitForTimeout(800);
await page.locator('button', { hasText: 'Ok' }).first().click();
await page.waitForTimeout(5000);
let state = await page.evaluate(() => ({
  body: document.body.innerText.replace(/\s+/g,' ').slice(0,500),
  windows: window.rt ? [...window.rt.windowInstances.keys()] : [],
  msg: [...document.querySelectorAll('.msgbox .txt')].map(x => x.textContent.slice(0,160)),
}));
console.log('after login', JSON.stringify(state), 'errors', errors.slice(0,3));
await page.screenshot({ path: 'C:/Projects/Abuzar/deploy/parity/shots/rebuild-after-login.png' });
const opened = await page.evaluate(async () => {
  try {
    if (!window.__opensheet) return 'no __opensheet';
    await Promise.race([window.__opensheet('w_sale'), new Promise(r => setTimeout(r, 6000))]);
    return 'called';
  } catch (e) { return 'ERR ' + String(e.message || e).slice(0,200); }
});
await page.waitForTimeout(4000);
state = await page.evaluate(() => ({
  body: document.body.innerText.replace(/\s+/g,' ').slice(0,600),
  windows: window.rt ? [...window.rt.windowInstances.keys()] : [],
  msg: [...document.querySelectorAll('.msgbox .txt')].map(x => x.textContent.slice(0,160)),
}));
console.log('after opensheet', opened, JSON.stringify(state), 'errors', errors.slice(0,5));
await page.screenshot({ path: 'C:/Projects/Abuzar/deploy/parity/shots/rebuild-w_sale-userflow.png' });
await browser.close();
