export const audiences={client:'Clientes',technician:'Técnicos',both:'Clientes y técnicos'};
export const announcementStatuses={draft:'Borrador',published:'Publicado',archived:'Archivado'};
export const safeLink=value=>{try{const url=new URL(value);return ['http:','https:'].includes(url.protocol)?url.href:null}catch{return null}};
export const visibleAnnouncements=(items,role)=>items.filter(a=>a.status==='published'&&[role,'both'].includes(a.audience)).sort((a,b)=>b.priority-a.priority);
export const demoAnnouncements=()=>[
 {id:'welcome-client',title:'Tu próxima solución empieza aquí.',body:'Describe la falla, revisa la tarifa de visita y confirma al profesional que atenderá tu solicitud.',audience:'client',status:'published',priority:10,image:'',linkUrl:'',linkLabel:''},
 {id:'welcome-technician',title:'Tu experiencia abre nuevas oportunidades.',body:'Mantén tu disponibilidad al día y revisa las solicitudes de tu especialidad. Cada atención cuenta.',audience:'technician',status:'published',priority:10,image:'',linkUrl:'',linkLabel:''}
];
