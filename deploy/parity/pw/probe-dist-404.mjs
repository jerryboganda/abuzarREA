import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage();
p.on('response',r=>{if(r.status()===404) console.log('404',r.url())});
p.on('pageerror',e=>console.log('PAGEERR',String(e.stack||e.message).slice(0,800)));
try{
 await p.goto('http://127.0.0.1:5180/',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(5000);
 console.log('body',await p.evaluate(()=>document.body.innerHTML.slice(0,200)));
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
