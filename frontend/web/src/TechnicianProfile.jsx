import React, {useState} from 'react';
import {rules,subcategoriesFor} from './domain/matching';

export default function TechnicianProfile({technician, requests, act, busy}) {
 const [zone,setZone]=useState(technician.zone);
 const [zones,setZones]=useState(technician.zones);
 const [subcategories,setSubcategories]=useState(technician.subcategories||[]);
 const options=technician.specialties.flatMap(subcategoriesFor);
 const [fee,setFee]=useState(String(technician.fee));
 const locked=requests.some(r=>(r.technicianId===technician.id&&['proposed','confirmed','in_progress'].includes(r.status))||r.offers.some(o=>o.technicianId===technician.id&&o.status==='pending'));
 return <details className="account-details technician-profile">
  <summary>Mi tarifa y cobertura</summary>
  <p className="muted">Actualiza las condiciones para nuevas solicitudes. Tu zona principal siempre forma parte de tu cobertura.</p>
  {locked&&<p role="status">Responde tus ofertas y termina tus atenciones antes de cambiar tarifa o cobertura.</p>}
  <form onSubmit={e=>{e.preventDefault();act('technician-profile',{zone,zones:[...new Set([zone,...zones])],fee:Number(fee),subcategories})}}>
   <fieldset disabled={busy||locked}>
    <legend>Condiciones de atención</legend>
    <div className="form-row">
     <label>Zona principal<select value={zone} onChange={e=>setZone(e.target.value)}>{rules.zones.map(z=><option key={z}>{z}</option>)}</select></label>
     <label>Tarifa de visita (S/)<input type="number" min="0" max="100000" step="0.01" required value={fee} onChange={e=>setFee(e.target.value)}/></label>
    </div>
    <fieldset><legend>Zonas de cobertura</legend>{rules.zones.map(z=><label className="checkbox-label" key={z}><input type="checkbox" checked={z===zone||zones.includes(z)} disabled={z===zone} onChange={e=>setZones(current=>e.target.checked?[...current,z]:current.filter(item=>item!==z))}/>{z}</label>)}</fieldset>
    <fieldset><legend>Subcategorías que atiendes</legend><p className="muted">Selecciona tus servicios. Solo recibirás nuevas solicitudes de las subcategorías elegidas.</p>{options.map(s=><label className="checkbox-label" key={s.id}><input type="checkbox" checked={subcategories.includes(s.id)} onChange={e=>setSubcategories(current=>e.target.checked?[...current,s.id]:current.filter(id=>id!==s.id))}/>{s.name}</label>)}</fieldset>
    <button className="button outline" type="submit">Guardar tarifa y cobertura</button>
   </fieldset>
  </form>
 </details>;
}
