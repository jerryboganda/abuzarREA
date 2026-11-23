import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage();
const logs=[]; p.on('console',m=>logs.push(m.type()+': '+m.text().slice(0,500))); p.on('pageerror',e=>logs.push('PAGEERR '+String(e.stack||e.message).slice(0,900)));
p.on('response',r=>{if(r.status()>=400) logs.push('HTTP '+r.status()+' '+r.url())});
try{
 await p.goto('http://127.0.0.1:5180/',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(8000);
 const s=await p.evaluate(()=>({rt:typeof window.rt, menu:typeof window.__menu, html:document.body.innerHTML.slice(0,300), err:window.__lastError||null}));
 s.logs=logs.slice(0,40); console.log(JSON.stringify(s,null,1));
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
