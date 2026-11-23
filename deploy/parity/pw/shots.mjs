import { chromium } from 'playwright';
const out = 'C:/Projects/Abuzar/deploy/parity/shots';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
const errors = [];
page.on('pageerror', e => errors.push(String(e.message).slice(0, 200)));
const names = ['w_main', 'w_sale', 'w_purchase', 'w_item_form', 'w_customer_form', 'w_voucher'];
for (const name of names) {
  const url = `http://127.0.0.1:5173/?w=${name}&db=mock`;
  errors.length = 0;
  await page.goto(url, { waitUntil: 'load' });
  await page.waitForTimeout(5000);
  const state = await page.evaluate(() => ({
    body: document.body.innerText.replace(/\s+/g, ' ').slice(0, 200),
    rt: !!window.rt,
    windows: window.rt ? [...window.rt.windowInstances.keys()] : [],
    msg: [...document.querySelectorAll('.msgbox .txt')].map(x => x.textContent.slice(0, 120)),
  }));
  await page.screenshot({ path: `${out}/rebuild-${name}.png` });
  console.log(name, JSON.stringify(state), 'errors', errors.length, errors.slice(0, 2));
}
await browser.close();
