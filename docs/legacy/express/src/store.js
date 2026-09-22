import pg from 'pg';
import {PGlite} from '@electric-sql/pglite';
export async function createStore({memory=false}={}) {
 const db=memory?new PGlite():process.env.DB_HOST?new pg.Pool({host:process.env.DB_HOST,port:Number(process.env.DB_PORT||5432),database:process.env.DB_NAME,user:process.env.DB_USER,password:process.env.DB_PASSWORD}):new PGlite(process.env.DATA_DIR||'./data');
 await db.query(`CREATE TABLE IF NOT EXISTS service_requests (code TEXT PRIMARY KEY, name TEXT NOT NULL, phone TEXT NOT NULL, service TEXT NOT NULL, device TEXT NOT NULL, description TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'received', consent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), created_at TIMESTAMPTZ NOT NULL DEFAULT NOW())`);
 return {async create(data){await db.query('INSERT INTO service_requests (code,name,phone,service,device,description) VALUES ($1,$2,$3,$4,$5,$6)',[data.code,data.name,data.phone,data.service,data.device,data.description]);},async find(code){return (await db.query('SELECT code,service,status,created_at FROM service_requests WHERE code=$1',[code])).rows[0]},async close(){if(db.end)await db.end();else await db.close()}};
}
