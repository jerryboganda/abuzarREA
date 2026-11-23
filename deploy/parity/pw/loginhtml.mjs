import { chromium } from 'playwright';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
await page.goto('http://127.0.0.1:5173/?w=w_login1&db=mock', { waitUntil: 'load' });
await page.waitForTimeout(3000);
const s = await page.evaluate(() => {
  const els = [...document.querySelectorAll('[contenteditable], input, textarea, .edit, .sle, [class*=edit], [class*=sle]')];
  return {
    count: els.length,
    els: els.map(e => ({tag:e.tagName, cls:e.className, ce:e.getAttribute('contenteditable'), type:e.type||'', name:e.name||'', text:(e.textContent||'').slice(0,40), rect:e.getBoundingClientRect().toJSON()})).slice(0,30),
    html: document.querySelector('.win')?.outerHTML.slice(0,2500) || document.body.innerHTML.slice(0,2500),
  };
});
console.log(JSON.stringify(s, null, 1).slice(0,6000));
await browser.close();
