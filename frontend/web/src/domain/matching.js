import rules from './rules.json';
export {rules};
export const specialtyNames = {computo:'Cómputo',refrigeracion:'Refrigeración comercial',electricidad:'Electricidad'};
export const statusNames = {searching:'Buscando técnico',pending_availability:'Pendiente de disponibilidad',proposed:'Técnico propuesto',confirmed:'Servicio confirmado',in_progress:'En ejecución',completed:'Completado',rated:'Calificado',cancelled:'Cancelado',unassigned:'Sin cobertura disponible'};
export function rankTechnicians(request, technicians, excluded=[]) {
  const eligible = technicians.filter(t=>t.verified && t.available && t.specialties.includes(request.specialty) && t.zones.includes(request.zone) && !excluded.includes(t.id));
  if (!eligible.length) return [];
  const min = Math.min(...eligible.map(t=>Number(t.fee))), max = Math.max(...eligible.map(t=>Number(t.fee)));
  return eligible.map(t=>{
    const factors={proximity:t.zone===request.zone?1:rules.secondaryZoneProximity,price:max===min?1:(max-t.fee)/(max-min),rating:t.rating/5,experience:Math.min(t.years/rules.maxExperienceYears,1)};
    const score=Object.entries(rules.weights).reduce((sum,[key,weight])=>sum+factors[key]*weight,0);
    return {...t,score:Math.round((score+Number.EPSILON)*1e6)/1e6,factors};
  }).sort((a,b)=>b.score-a.score || b.rating-a.rating || a.id.localeCompare(b.id));
}
