import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage();
const logs=[]; p.on('console',m=>logs.push(m.type()+': '+m.text().slice(0,300))); p.on('pageerror',e=>logs.push('PAGEERR '+String(e.stack||e.message).slice(0,800)));
try{
 await p.goto('http://127.0.0.1:5180/',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(10000);
 const s=await p.evaluate(()=>({body:document.body.innerHTML.slice(0,300),rt:typeof window.rt,menu:typeof window.__menu,desktop:document.getElementById('desktop')?.innerHTML.slice(0,300)}));
 s.logs=logs.slice(0,20); console.log(JSON.stringify(s,null,1));
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
