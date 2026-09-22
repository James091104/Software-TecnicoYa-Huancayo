import 'dotenv/config';
import pg from 'pg';
import {PGlite} from '@electric-sql/pglite';
const [code,status]=process.argv.slice(2);
if(!/^TY-[A-F0-9]{24}$/.test(code||'')||!['received','contacted','diagnosing','repairing','ready','closed'].includes(status)){console.error('Uso: node src/update-status.js TY-CODIGO received|contacted|diagnosing|repairing|ready|closed');process.exit(1)}
const db=process.env.DB_HOST?new pg.Pool({host:process.env.DB_HOST,port:Number(process.env.DB_PORT||5432),database:process.env.DB_NAME,user:process.env.DB_USER,password:process.env.DB_PASSWORD}):new PGlite(process.env.DATA_DIR||'./data');
try{const result=await db.query('UPDATE service_requests SET status=$1 WHERE code=$2 RETURNING code',[status,code]);if(!result.rows.length){console.error('Código no encontrado');process.exitCode=1}else console.log('Estado actualizado:',status)}finally{if(db.end)await db.end();else await db.close()}
