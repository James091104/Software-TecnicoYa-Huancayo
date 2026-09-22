import 'dotenv/config';
import {createStore} from './store.js';
import {createApp} from './app.js';
const store=await createStore();
const app=createApp(store,{guidance:async(body)=>{const response=await fetch((process.env.PYTHON_URL||'http://127.0.0.1:8000')+'/guidance',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify(body),signal:AbortSignal.timeout(2000)});if(!response.ok)throw Error('guidance unavailable');return response.json()}});
const server=app.listen(Number(process.env.PORT||3000),'0.0.0.0',()=>console.log('TecnicoYa API ready'));
for(const signal of ['SIGINT','SIGTERM'])process.on(signal,()=>server.close(async()=>{await store.close();process.exit(0)}));
