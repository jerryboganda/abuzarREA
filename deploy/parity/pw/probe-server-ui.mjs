import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1280,height:800}});
const logs=[]; p.on('console',m=>{if(m.type()==='error') logs.push(m.text().slice(0,300))}); p.on('pageerror',e=>logs.push('PAGEERR '+String(e.stack||e.message).slice(0,800)));
try{
 await p.goto('http://127.0.0.1:8787/',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(6000);
 const s=await p.evaluate(()=>({body:document.body.innerText.replace(/\s+/g,' ').slice(0,300),menu:typeof window.__menu,rt:typeof window.rt}));
 s.logs=logs.slice(0,10); console.log(JSON.stringify(s,null,1));
 await p.screenshot({path:'C:/Projects/Abuzar/deploy/parity/real/52-desktop-server-ui.png'});
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
