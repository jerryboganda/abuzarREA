import { chromium } from 'playwright';
const b=await chromium.launch(); const p=await b.newPage();
await p.goto('about:blank');
const r=await p.evaluate(()=>{const c=document.createElement("canvas").getContext("2d"); const out={}; for(const f of ['Arial Narrow','Arial','Tahoma','Liberation Sans Narrow','Nimbus Sans Narrow']){c.font='10pt "'+f+'"'; out[f]=c.measureText('****CASH SALES CUSTOMER').width;} return out;});
console.log(JSON.stringify(r,null,1)); await b.close();
