import http from 'node:http';
import {readFile} from 'node:fs/promises';
import path from 'node:path';
const root=path.resolve('dist');
const types={'.html':'text/html; charset=utf-8','.js':'text/javascript','.css':'text/css','.mp4':'video/mp4','.svg':'image/svg+xml'};
http.createServer(async(req,res)=>{
 try {
  if(req.url.startsWith('/api/')){
   const upstream=http.request(new URL(req.url,process.env.API_URL||'http://127.0.0.1:3000'),{method:req.method,headers:req.headers},r=>{res.writeHead(r.statusCode,r.headers);r.pipe(res)});
   upstream.on('error',()=>{res.writeHead(502,{'content-type':'application/json'});res.end(JSON.stringify({error:'El servicio no está disponible. Intenta nuevamente.'}))});
   req.pipe(upstream);return;
  }
  const pathname=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
  const file=path.resolve(root,'.'+(pathname==='/'?'/index.html':pathname));
  if(!file.startsWith(root+path.sep)){res.writeHead(403);res.end();return;}
  const data=await readFile(file);res.writeHead(200,{'content-type':types[path.extname(file)]||'application/octet-stream'});res.end(data);
 }catch{res.writeHead(404);res.end('No encontrado');}
}).listen(Number(process.env.PORT||5173),'0.0.0.0');
