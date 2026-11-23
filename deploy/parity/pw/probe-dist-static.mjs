import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1280,height:800}});
const errs=[]; p.on('pageerror',e=>errs.push(String(e.stack||e.message).slice(0,600))); p.on('console',m=>{if(m.type()==='error') errs.push('CONSOLE '+m.text().slice(0,300))});
try{
 await p.goto('http://127.0.0.1:5180/',{waitUntil:'load',timeout:60000});
 await p.waitForTimeout(8000);
 const s=await p.evaluate(()=>({body:document.body.innerText.replace(/\s+/g,' ').slice(0,300),html:document.body.innerHTML.slice(0,200)}));
 s.errs=errs.slice(0,10); console.log(JSON.stringify(s,null,1));
 await p.screenshot({path:'C:/Projects/Abuzar/deploy/parity/real/51-dist-static.png'});
}catch(e){console.log('FATAL',String(e.stack||e.message).slice(0,700));} finally{await b.close().catch(()=>{});}
