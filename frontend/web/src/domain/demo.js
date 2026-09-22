import {rankTechnicians,rules} from './matching';
const KEY='tecnicoya.marketplace.v1';
const hour=3600000;
export function initialState(){return {version:1,requests:[],technicians:[
 {id:'tech-ana',name:'Ana Quispe',zone:'Huancayo',zones:['Huancayo','El Tambo','Chilca'],specialties:['computo'],fee:45,rating:4.9,reviews:24,years:6,verified:true,available:true},
 {id:'tech-luis',name:'Luis Rojas',zone:'El Tambo',zones:['El Tambo','Huancayo','Pilcomayo'],specialties:['computo','electricidad'],fee:40,rating:4.7,reviews:18,years:5,verified:true,available:true},
 {id:'tech-marco',name:'Marco Huamán',zone:'Chilca',zones:['Chilca','Huancayo','Huancán'],specialties:['refrigeracion'],fee:70,rating:4.8,reviews:32,years:8,verified:true,available:true},
 {id:'tech-elena',name:'Elena Castro',zone:'Huancayo',zones:['Huancayo','El Tambo','Chilca','Pilcomayo','Huancán'],specialties:['electricidad','refrigeracion'],fee:65,rating:4.9,reviews:21,years:9,verified:true,available:true},
 {id:'tech-diego',name:'Diego Poma',zone:'Huancayo',zones:['Huancayo','Chilca','El Tambo'],specialties:['computo'],fee:50,rating:4.6,reviews:12,years:4,verified:true,available:true},
 {id:'tech-sofia',name:'Sofía Torres',zone:'Pilcomayo',zones:['Pilcomayo','El Tambo'],specialties:['refrigeracion'],fee:60,rating:0,reviews:0,years:3,verified:false,available:false}
]}}
export function loadDemo(){try{const raw=JSON.parse(localStorage.getItem(KEY));if(raw?.version===1&&Array.isArray(raw.requests)&&Array.isArray(raw.technicians))return raw;}catch{}return initialState()}
export function saveDemo(state){localStorage.setItem(KEY,JSON.stringify(state))}
function record(r,text,now){r.events.push({at:now,text})}
function dispatch(r,state,now){
  if(now>=r.pendingUntil){r.offers.filter(o=>o.status==='pending').forEach(o=>o.status='expired');r.status='unassigned';record(r,'Finalizó la ventana de disponibilidad de 24 horas.',now);return;}
  const active=r.offers.filter(o=>o.status==='pending');
  const choices=rankTechnicians(r,state.technicians,r.offers.map(o=>o.technicianId)).slice(0,rules.maxSimultaneous-active.length);
  for(const t of choices){r.offers.push({technicianId:t.id,status:'pending',sentAt:now,expiresAt:Math.min(now+rules.responseMinutes*60000,r.pendingUntil),score:t.score});record(r,`Solicitud notificada a ${t.name}.`,now)}
  const next=r.offers.some(o=>o.status==='pending')?'searching':'pending_availability';
  if(r.status!==next){r.status=next;record(r,next==='searching'?'Buscando respuesta de técnicos.':'Pendiente de disponibilidad en tu zona.',now)}
}
export function advance(state,now=Date.now()){
  for(const r of state.requests){if(!['searching','pending_availability'].includes(r.status))continue;
    for(const o of r.offers){const t=state.technicians.find(t=>t.id===o.technicianId);if(o.status==='pending'&&(now>=o.expiresAt||!t?.available||!t?.verified)){o.status='expired';record(r,'Oferta vencida o técnico no disponible; se busca otro candidato.',now)}}
    dispatch(r,state,now);
  }return state;
}
export function actDemo(current,actor,action,payload={},now=Date.now()){
  const state=advance(structuredClone(current),now), t=state.technicians.find(t=>t.id===actor.id), r=state.requests.find(r=>r.id===payload.id);
  const require=(condition,message)=>{if(!condition)throw Error(message)};
  if(action==='create'){
    require(actor.role==='client','Solo el cliente puede solicitar servicios.');
    require(rules.specialties.includes(payload.specialty)&&rules.zones.includes(payload.zone)&&payload.description?.trim().length>=10&&payload.description.length<=2000&&payload.address?.trim().length>=5&&payload.address.length<=200,'Completa el rubro, zona, dirección y una descripción de al menos 10 caracteres.');
    const request={id:crypto.randomUUID(),clientId:actor.id,specialty:payload.specialty,zone:payload.zone,address:payload.address.trim(),description:payload.description.trim(),status:'pending_availability',createdAt:now,pendingUntil:now+rules.pendingHours*hour,offers:[],events:[],technicianId:null,rating:null};
    record(request,'Solicitud registrada.',now);state.requests.unshift(request);dispatch(request,state,now);
  }else if(action==='availability'){
    require(actor.role==='technician'&&t,'Perfil técnico no disponible.');require(!state.requests.some(r=>r.technicianId===t.id&&['proposed','confirmed','in_progress'].includes(r.status)),'Termina tu atención activa antes de cambiar la disponibilidad.');require(t.verified,'Tu perfil aún está pendiente de verificación.');t.available=Boolean(payload.available);
  }else if(action==='verify'){
    require(actor.role==='admin','Solo administración puede verificar perfiles.');const target=state.technicians.find(t=>t.id===payload.technicianId);require(target,'Técnico no encontrado.');target.verified=Boolean(payload.verified);if(!target.verified)target.available=false;
  }else{
    require(r,'Solicitud no encontrada.');
    if(action==='accept'||action==='decline'){
      const offer=r.offers.find(o=>o.technicianId===actor.id&&o.status==='pending');require(actor.role==='technician'&&t&&offer&&r.status==='searching','Esta oferta ya no está disponible.');
      if(action==='decline'){offer.status='declined';record(r,`${t.name} rechazó la solicitud.`,now);dispatch(r,state,now)}
      else{require(t.verified&&t.available,'El técnico no está habilitado o disponible.');offer.status='accepted';r.offers.filter(o=>o.status==='pending').forEach(o=>o.status='cancelled');r.technicianId=t.id;r.agreedFee=t.fee;r.status='proposed';t.available=false;record(r,`${t.name} aceptó. Falta la confirmación del cliente.`,now)}
    }else if(action==='confirm'){
      require(actor.role==='client'&&r.clientId===actor.id&&r.status==='proposed','No puedes confirmar esta solicitud.');r.status='confirmed';record(r,'El cliente confirmó al técnico y la tarifa de visita.',now);
    }else if(action==='start'||action==='complete'){
      require(actor.role==='technician'&&r.technicianId===actor.id&&r.status===(action==='start'?'confirmed':'in_progress'),'Esta acción no corresponde al estado del servicio.');r.status=action==='start'?'in_progress':'completed';record(r,action==='start'?'El técnico inició el servicio.':'Servicio finalizado. Se abrió la ventana de calificación.',now);if(action==='complete'){r.completedAt=now;r.ratingUntil=now+rules.ratingHours*hour;t.available=true;}
    }else if(action==='rate'){
      require(actor.role==='client'&&r.clientId===actor.id&&r.status==='completed'&&now<r.ratingUntil,'La calificación está cerrada o ya fue enviada.');require(Number.isInteger(payload.rating)&&payload.rating>=1&&payload.rating<=5,'Selecciona entre 1 y 5 estrellas.');const technician=state.technicians.find(t=>t.id===r.technicianId);technician.rating=Math.round(((technician.rating*technician.reviews+payload.rating)/(technician.reviews+1))*1e6)/1e6;technician.reviews++;r.rating=payload.rating;r.status='rated';record(r,`Cliente calificó con ${payload.rating} estrellas.`,now);
    }else if(action==='cancel'){
      require(actor.role==='client'&&r.clientId===actor.id&&['searching','pending_availability','proposed','confirmed'].includes(r.status),'No puedes cancelar un servicio en ejecución o finalizado.');r.offers.filter(o=>o.status==='pending').forEach(o=>o.status='cancelled');if(r.technicianId)state.technicians.find(t=>t.id===r.technicianId).available=true;r.status='cancelled';record(r,'Solicitud cancelada por el cliente.',now);
    }else throw Error('Acción desconocida.');
  }return advance(state,now);
}
