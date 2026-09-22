import test from 'node:test';
import assert from 'node:assert/strict';
import {createStore} from '../src/store.js';
import {createApp,validate} from '../src/app.js';
const valid={name:'Cliente Prueba',phone:'999123456',service:'diagnostico',device:'Laptop Lenovo',description:'Mi computadora no enciende.',consent:true};
test('validation rejects malformed fields and missing consent',()=>{assert.equal(validate(valid),true);for(const patch of [{consent:false},{name:' '},{phone:'abcdefghi'},{service:'__proto__'},{description:'corto'}])assert.equal(validate({...valid,...patch}),false)});
test('request persists; tracking omits personal information; Python failure is tolerated',async()=>{
 const store=await createStore({memory:true});const server=createApp(store,{guidance:async()=>{throw Error('offline')}}).listen(0,'127.0.0.1');await new Promise(r=>server.once('listening',r));const base='http://127.0.0.1:'+server.address().port;
 try{const response=await fetch(base+'/api/requests',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify(valid)});assert.equal(response.status,201);const created=await response.json();assert.match(created.code,/^TY-[A-F0-9]{24}$/);assert.equal(created.guidance,null);const tracking=await(await fetch(base+'/api/requests/'+created.code)).json();assert.equal(tracking.status,'received');for(const field of ['name','phone','device','description'])assert.equal(field in tracking,false);assert.equal((await fetch(base+'/api/requests/TY-NOTFOUND')).status,404);assert.equal((await fetch(base+'/api/requests',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({...valid,consent:false})})).status,400);assert.equal((await fetch(base+'/api/requests',{method:'POST',headers:{'content-type':'application/json'},body:'{'})).status,400)}finally{await new Promise(r=>server.close(r));await store.close()}
});
