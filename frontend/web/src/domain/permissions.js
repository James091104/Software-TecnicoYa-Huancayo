export const roleNames={client:'Usuario',technician:'Técnico',admin:'Administrador'};
export const rolePermissions={
 client:['create','confirm','cancel','rate','profile'],
 technician:['availability','accept','decline','start','complete','profile','technician-profile'],
 admin:['verify','accounts','profile','announcement-save'],
};
export const permissionNames={'technician-profile':'Editar mi tarifa y cobertura','announcement-save':'Gestionar anuncios por perfil',create:'Solicitar servicios',confirm:'Confirmar mis servicios',cancel:'Cancelar mis solicitudes',rate:'Calificar mis servicios',profile:'Editar mi perfil',availability:'Gestionar mi disponibilidad',accept:'Aceptar ofertas recibidas',decline:'Rechazar ofertas recibidas',start:'Iniciar trabajos asignados',complete:'Finalizar trabajos asignados',verify:'Verificar técnicos',accounts:'Administrar acceso de usuarios'};
export const can=(actor,action)=>Boolean(actor && (rolePermissions[actor.role]||[]).includes(action) && (!actor.permissions||actor.permissions.includes(action)));
