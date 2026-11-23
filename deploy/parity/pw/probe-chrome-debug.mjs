import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage();
const logs=[]; p.on('console',m=>logs.push(m.type()+': '+m.text().slice(0,300))); p.on('pageerror',e=>logs.push('PAGEERR '+String(e.stack||e.message).slice(0,1000)));
try{
 await p.goto('http://127.0.0.1:5180/?app=1&db=mock',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(8000);
 const s=await p.evaluate(()=>({body:document.body.innerText.replace(/\s+/g,' ').slice(0,300),html:document.body.innerHTML.slice(0,500),cls:document.body.className}));
 s.logs=logs.slice(0,20); console.log(JSON.stringify(s,null,1));
 await p.screenshot({path:'C:/Projects/Abuzar/deploy/parity/real/53-chrome-debug.png'});
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
