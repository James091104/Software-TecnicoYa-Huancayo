# CANVAS — Diagrama de clases del dominio — TécnicoYa Huancayo

**Fecha:** 5 de octubre de 2026. **Estado:** diseño propuesto, no implementación acreditada. **Entrega:** 1 de 5; un diagrama por mensaje.

## 1. Propósito y fuentes

Representar los conceptos del negocio, sus responsabilidades y relaciones. Se basa en la Fuente 0, los CANVAS de análisis y diseño técnico y el diccionario `Diccionario-MySQL-TecnicoYa.json`, conservando sus decisiones pendientes.

Esta vista selecciona atributos y operaciones del dominio. El diccionario conserva el detalle físico de las 79 tablas, claves, índices y restricciones. Las clases propuestas no se presentan como clases PHP ya implementadas.

## 2. Cómo leer el diagrama

- **Entidad:** conserva identidad e historial; por ejemplo, Solicitud o Participacion.
- **Objeto de valor:** expresa un dato sin identidad propia, como Dinero o Intervalo. Se sustituye por otro valor al cambiar.
- **Servicio de dominio:** concentra una política que involucra varios conceptos. Las interfaces Reloj y RepositorioCandidatos permiten sustituir sus implementaciones para las pruebas.
- **Multiplicidad:** `1` significa exactamente uno; `0..1`, opcional; `0..*`, ninguno o varios. La multiplicidad histórica no equivale al límite simultáneo.
- **Composición:** el contenido pertenece a su entidad; no autoriza borrado físico en cascada.
- **Dependencia punteada:** una clase utiliza otra; no implica clave foránea.
- Texto, Entero, Decimal, Id e InstanteUTC son tipos conceptuales. El sufijo Opcional admite ausencia. Contexto, Instantanea y ListaCandidatos describen datos de entrada o salida, no tablas adicionales.
- Las operaciones representan responsabilidades, no endpoints ni firmas definitivas. Requieren autorización, validación y transacciones desde los casos de uso de aplicación.

## 3. Correspondencia con el diccionario

| Grupo | Clases principales | Tablas de referencia |
|---|---|---|
| Identidad | Usuario, Rol, Permiso, PerfilCliente, PerfilTecnico, BloqueoCliente | users, roles, permissions, client_profiles, technician_profiles, client_blocks; role_permissions y user_permissions resuelven permisos |
| Verificación y portafolio | RevisionTecnico, DocumentoVerificacion, Archivo, TrabajoPortafolio | technician_reviews, technician_documents, media_files, portfolio_items, review_documents, portfolio_images |
| Catálogo y oferta | Especialidad, Subcategoria, ServicioOfrecido, VersionTarifa | specialties, subcategories, technician_services, service_rate_versions |
| Cobertura y disponibilidad | Distrito, Disponibilidad, PausaTemporal | districts, technician_districts, availability_slots, technician_pauses |
| Solicitudes y ofertas | Solicitud, EventoSolicitud, RondaOferta, Oferta | service_requests, request_events, offer_rounds, offers, request_attachments |
| Atención | Participacion, Cita, Reprogramacion, ReporteAtencion, Incidencia, Reasignacion | participations, appointments, reschedule_requests, service_reports, incidents, reassignment_records |
| Matching | EvaluacionMatching, CandidatoMatching, FactoresMatching | matching_runs y matching_candidates; los factores son valores dentro del candidato |
| Reglas | VersionReglas, ParametroRegla, ValorParametro, PesosMatching | rule_versions, rule_parameters, rule_values, matching_weights |
| Reputación | Calificacion, VersionCalificacion, RespuestaResena, Apelacion, ResolucionApelacion | ratings, rating_versions, rating_replies, rating_appeals, rating_resolutions |
| Comunicación y soporte | Notificacion, IntentoNotificacion, PreferenciaNotificacion, Comunicado, TicketSoporte | notifications, notification_attempts, notification_preferences, announcements, announcement_audiences, support_tickets |
| Simulación y auditoría | MetodoPago, PagoSimulado, RegistroAuditoria | payment_methods, simulated_payments, audit_entries; request_payment_methods representa la elección por solicitud |

Los pivotes, evidencias auxiliares y registros técnicos no se convierten todos en clases independientes en esta vista. El diccionario mantiene las respuestas de reprogramación, propuestas de técnico adicional, actualizaciones de soporte, comprobantes simulados, outbox, sesiones, colas e idempotencia. El historial de servicios se consulta a partir de solicitudes, participaciones, reportes y eventos; no se duplica en una entidad aparte.

## 4. Invariantes y decisiones pendientes

1. **Identidad y permisos.** Cliente, técnico y administrador son los tres roles. La propuesta vigente representa un rol por usuario (P20). Un administrador responsable se distingue por permisos, no por un cuarto rol. Las concesiones administrativas requieren autorización y auditoría.
2. **Habilitación.** Cuenta activa, verificación profesional, estado operativo, disponibilidad y pausas son condiciones diferentes. El técnico pendiente puede completar su perfil, pero no recibir trabajo como si estuviera habilitado.
3. **Tarifas.** ServicioOfrecido representa una combinación técnico–subcategoría. Su creación registra la primera versión de tarifa; los cambios preservan el historial. Una oferta conserva el importe referencial notificado aunque cambie la tarifa vigente. Su referencia a VersionTarifa es opcional, conforme al diccionario. Una tarifa no equivale a un cobro.
4. **Elegibilidad.** Se comprueban rubro/subcategoría, cobertura, habilitación, disponibilidad y pausas antes de puntuar. CandidatoMatching permite conservar excluidos con motivo y sin posición ni puntuación; el candidato elegible exige los cuatro factores completos, entre 0 y 1.
5. **Ranking reproducible.** El puntaje de 0 a 100 suma cada factor multiplicado por su peso porcentual. Pesos iniciales: cercanía 35%, tarifa 20%, historial/calificación 30%, experiencia 15%. Una versión publicada exige pesos completos que sumen 100. Se conserva la fotografía de datos y la versión aplicada. El primer desempate es la mayor calificación promedio; normalización, datos ausentes y desempate residual siguen P15.
6. **Oferta y asignación.** Hasta tres técnicos reciben ofertas simultáneas con SLA de diez minutos. Aceptar no crea automáticamente una participación: el cliente elige y el sistema revalida elegibilidad, vigencia y disponibilidad. El reloj del backend determina el vencimiento; el contador visual no es autoridad.
7. **Participaciones.** Una solicitud conserva todas las participaciones históricas. Como máximo tiene un principal y un adicional vigentes. La sustitución preserva la atención anterior. Reasignar manualmente exige permiso, motivo y auditoría. La coordinación del estado global con dos técnicos permanece sujeta a P13.
8. **Solicitud directa.** Desde un perfil se notifica inicialmente al técnico elegido. Buscar alternativas después requiere autorización del cliente; no se convierte automáticamente en una búsqueda general.
9. **Ventanas.** Pendiente de disponibilidad conserva un límite de 24 horas. Finalizar cada participación abre su ventana de 48 horas para calificar. Reinicios de rondas y límites exactos siguen P12. Se conserva Expirada porque las fuentes lo incluyen al vencer disponibilidad, además de los nueve estados enumerados en la petición de diagramas.
10. **Reputación.** Una calificación por participación, puntaje de 1 a 5 y comentario. Los cambios generan versiones. La edición dentro de 48 horas desde la primera calificación mantiene la decisión pendiente P23. La apelación identifica la versión cuestionada; la resolución registra la versión revisada y la resultante cuando existe. El administrador mantiene, ajusta o anula con motivo y auditoría. No se fija un plazo definitivo de apelación (P07).
11. **Privacidad.** Dirección exacta, documentos y evidencias requieren permisos y pertenencia. El WhatsApp se revela al cliente correspondiente tras la asignación. Publicar portafolio no vuelve públicas las evidencias privadas de una atención.
12. **Pagos simulados.** Elegir método no significa pagar. PagoSimulado pertenece a una participación y no procesa fondos. Moneda y detalles del flujo siguen P01/P02; no se agregan conversión ni pasarelas reales.
13. **Historial de reglas.** El contenido publicado no se sobrescribe: se crea una nueva versión. Retirar una versión no elimina sus usos históricos. La aplicabilidad temporal sigue P19. Notificaciones y auditoría conservan referencias polimórficas por tipo e identificador, sin inventar una tabla universal de recursos.
14. **Consistencia.** La capa de aplicación coordina permisos, propiedad, transacciones, bloqueos y control de versión. Repetir comandos no debe duplicar asignaciones, cierres o notificaciones. La publicación externa ocurre después de confirmar la transacción, conforme al diseño técnico.

## 5. Guía para implementación y BDD

Los nombres en español facilitan la lectura académica; no obligan a renombrar tablas. Separar políticas de los controladores evita versiones contradictorias de una regla. Reloj permite probar vencimientos sin esperar diez minutos; RepositorioCandidatos permite probar el ranking con datos controlados.

| Escenario | Criterio de aceptación |
|---|---|
| Aceptación sin elección | Dado un técnico con oferta vigente, cuando acepta, entonces la oferta queda aceptada sin participación hasta la elección autorizada del cliente. |
| Oferta vencida | Dada una oferta cuyo límite se alcanzó según la política temporal, cuando llega una aceptación tardía, entonces se rechaza sin asignar. |
| Cambio de tarifa | Dada una oferta enviada, cuando cambia la tarifa del técnico, entonces se conserva el importe notificado. |
| Técnico no elegible | Dado un técnico suspendido o con pausa incompatible, cuando se evalúa el matching, entonces se excluye con motivo y sin posición. |
| Límite simultáneo | Dada una solicitud con principal y adicional vigentes, cuando se intenta añadir otro técnico, entonces se rechaza sin borrar el historial. |
| Pesos inválidos | Dada una versión cuyos pesos no suman 100, cuando se intenta publicar, entonces se impide su publicación. |
| Calificación individual | Dadas dos participaciones finalizadas, cuando el cliente califica una dentro de su plazo, entonces la otra conserva su propio estado y vencimiento. |
| Acceso indebido | Dado un usuario ajeno a una solicitud, cuando pide sus evidencias privadas, entonces se deniega aunque conozca su identificador. |

Son criterios de diseño propuestos; no acreditan pruebas ejecutadas sobre la aplicación.

## 6. Fuente PlantUML

El archivo `.puml` es editable. El `.svg` puede ampliarse sin perder nitidez. Esta entrega no modifica el esquema ni el código de ejecución del proyecto.

```plantuml
@startuml Clases_Dominio_TecnicoYa
title TécnicoYa Huancayo · Diagrama de clases del dominio
left to right direction
hide empty members
skinparam shadowing false
skinparam backgroundColor #FFFFFF
skinparam defaultFontName Arial
skinparam defaultFontSize 12
skinparam classAttributeIconSize 0
skinparam packageStyle rectangle
skinparam class {
  BackgroundColor #F0F9FF
  BorderColor #0369A1
  ArrowColor #475569
}
skinparam package {
  BackgroundColor #F8FAFC
  BorderColor #94A3B8
}

package "Identidad y oferta profesional · F / A" {
  class Usuario <<entidad>> {
    - id: Id
    - nombre: Texto
    - correo: Texto
    - activo: Booleano
    - version: Entero
    + estaHabilitado(): Booleano
    + permisosEfectivos(): ConjuntoPermisos
  }
  class Rol <<entidad>> {
    - codigo: Texto
    - nombre: Texto
  }
  class Permiso <<entidad>> {
    - codigo: Texto
    - descripcion: Texto
  }
  class PerfilCliente <<entidad>> {
    - id: Id
    - tipo: hogar_o_mype
    - nombreNegocio: TextoOpcional
    + actualizarDatosPermitidos(): void
  }
  class PerfilTecnico <<entidad>> {
    - id: Id
    - nombreProfesional: Texto
    - estado: EstadoTecnico
    - verificacion: EstadoVerificacion
    - experienciaAnios: Entero
    - disponibleAhora: Booleano
    + estaHabilitadoProfesionalmente(): Booleano
    + promedioCalificaciones(): Decimal
  }
  class RevisionTecnico <<entidad>> {
    - id: Id
    - decision: aprobar_rechazar_solicitarCambios
    - motivo: Texto
    - revisadoEn: InstanteUTC
    + registrarDecision(): void
  }
  class DocumentoVerificacion <<entidad>> {
    - id: Id
    - tipo: Texto
    - estadoRevision: EstadoVerificacion
    - venceEn: InstanteOpcional
  }
  class TrabajoPortafolio <<entidad>> {
    - id: Id
    - titulo: Texto
    - descripcion: Texto
    - estado: borrador_publicado_retirado
    + publicar(): void
    + retirar(): void
  }
  class Archivo <<entidad>> {
    - id: Id
    - tipoContenido: Texto
    - tamanoBytes: Entero
    - visibilidad: publica_o_privada
    - validacion: pendiente_limpio_rechazado
    + puedeServirse(): Booleano
  }
  class BloqueoCliente <<entidad>> {
    - id: Id
    - motivo: Texto
    - inicio: InstanteUTC
    - fin: InstanteOpcional
    - estado: activo_levantado_expirado
    + estaVigente(ahora: InstanteUTC): Booleano
  }
}

package "Catálogo y disponibilidad · A / F" {
  class Especialidad <<entidad>> {
    - id: Id
    - nombre: Texto
    - activa: Booleano
  }
  class Subcategoria <<entidad>> {
    - id: Id
    - nombre: Texto
    - activa: Booleano
    - ordenCarrusel: Entero
    - tarifaReferencial: DineroOpcional
  }
  class ServicioOfrecido <<entidad>> {
    - id: Id
    - tarifaVigente: Dinero
    - activo: Booleano
    - versionTarifa: Entero
    + cambiarTarifa(nueva: Dinero): void
  }
  class VersionTarifa <<entidad>> {
    - id: Id
    - numero: Entero
    - tarifa: Dinero
    - vigenteDesde: InstanteUTC
  }
  class Distrito <<entidad>> {
    - id: Id
    - codigo: Texto
    - nombre: Texto
    - activo: Booleano
  }
  class Disponibilidad <<entidad>> {
    - id: Id
    - patron: semanal_o_puntual
    - zonaHoraria: Texto
    - activa: Booleano
    + cubre(intervalo: Intervalo): Booleano
  }
  class PausaTemporal <<entidad>> {
    - id: Id
    - inicio: InstanteUTC
    - fin: InstanteOpcional
    - canceladaEn: InstanteOpcional
    + afecta(intervalo: Intervalo): Booleano
  }
}

package "Solicitud, ofertas y atención · A / C / D" {
  class Solicitud <<entidad>> {
    - id: Id
    - descripcion: Texto
    - direccionPrivada: Texto
    - modalidad: inmediata_o_programada
    - origen: automatico_o_perfil
    - estado: EstadoSolicitud
    - tarifaReferencial: DineroOpcional
    - pendienteVenceEn: InstanteOpcional
    - generacionBusqueda: Entero
    - version: Entero
    + enviar(): void
    + registrarPendiente(limite: InstanteUTC): void
    + cancelar(motivo: Texto): void
    + expirar(ahora: InstanteUTC): void
  }
  class EventoSolicitud <<entidad>> {
    - id: Id
    - tipo: Texto
    - momento: InstanteUTC
    - motivo: TextoOpcional
  }
  class RondaOferta <<entidad>> {
    - id: Id
    - numero: Entero
    - generacion: Entero
    - tipo: automatica_directa_manual_adicional
    - estado: Texto
    - venceEn: InstanteUTC
    + tieneAceptacionesValidas(): Booleano
    + cerrar(): void
  }
  class Oferta <<entidad>> {
    - id: Id
    - estado: EstadoOferta
    - disponibleEn: InstanteUTC
    - venceEn: InstanteUTC
    - tarifaOfrecida: Dinero
    + aceptar(ahora: InstanteUTC): void
    + rechazar(motivo: Texto): void
    + expirar(ahora: InstanteUTC): void
  }
  class Participacion <<entidad>> {
    - id: Id
    - puesto: principal_o_adicional
    - estado: EstadoParticipacion
    - tarifaReferencialAsignada: Dinero
    - estadoCalificacion: no_abierta_abierta_calificada_sin_calificar
    - finalizadaEn: InstanteOpcional
    - calificacionVenceEn: InstanteOpcional
    + iniciar(ahora: InstanteUTC): void
    + finalizar(reporte: ReporteAtencion): void
    + cerrarSinCalificar(ahora: InstanteUTC): void
  }
  class Cita <<entidad>> {
    - id: Id
    - franja: Intervalo
    - estado: Texto
    + reprogramar(nueva: Intervalo): void
  }
  class Reprogramacion <<entidad>> {
    - id: Id
    - anterior: Intervalo
    - propuesta: Intervalo
    - estado: Texto
    - venceEn: InstanteUTC
    + aceptar(): void
    + rechazar(): void
    + vencer(ahora: InstanteUTC): void
  }
  class ReporteAtencion <<entidad>> {
    - id: Id
    - trabajoRealizado: Texto
    - resultado: Texto
    - registradoEn: InstanteUTC
  }
  class Incidencia <<entidad>> {
    - id: Id
    - tipo: Texto
    - descripcion: Texto
    - estado: Texto
    + registrarResolucion(motivo: Texto): void
  }
  class Reasignacion <<entidad>> {
    - id: Id
    - origen: automatico_o_manual
    - motivo: Texto
    - estado: Texto
    + registrarResultado(): void
  }
}

package "Matching y configuración · B / F" {
  class EvaluacionMatching <<entidad>> {
    - id: Id
    - generacion: Entero
    - calculadaEn: InstanteUTC
    + obtenerRanking(): ListaCandidatos
  }
  class CandidatoMatching <<entidad>> {
    - id: Id
    - elegible: Booleano
    - motivoExclusion: TextoOpcional
    - puestoRanking: EnteroOpcional
    - puntuacion: DecimalOpcional
    - datosEvaluados: Instantanea
    + explicarFactores(): Texto
  }
  class VersionReglas <<entidad>> {
    - id: Id
    - numero: Entero
    - estado: borrador_publicada_retirada
    - vigenteDesde: InstanteOpcional
    - motivoCambio: Texto
    + validarParaPublicacion(): void
    + publicar(): void
  }
  class ParametroRegla <<entidad>> {
    - id: Id
    - codigo: Texto
    - tipoValor: Texto
    - unidad: Texto
    - editable: Booleano
  }
  class ValorParametro <<entidad>> {
    - valor: ValorTipado
    + validarTipoYRango(): void
  }
  class PesosMatching <<valor>> {
    - cercaniaPct: Decimal
    - tarifaPct: Decimal
    - historialPct: Decimal
    - experienciaPct: Decimal
    + suma(): Decimal
    + validarSuma100(): void
  }
  class FactoresMatching <<valor>> {
    - cercania: Decimal
    - tarifa: Decimal
    - historial: Decimal
    - experiencia: Decimal
    + validarRango0a1(): void
    + puntuar(pesos: PesosMatching): Decimal
  }
}

package "Calificación y reputación · E" {
  class Calificacion <<entidad>> {
    - id: Id
    - puntaje: Entero
    - comentario: Texto
    - estado: activa_o_anulada
    - primeraFecha: InstanteUTC
    - editableHasta: InstanteUTC
    - versionActual: Entero
    + editar(puntaje: Entero, comentario: Texto): void
    + registrarVersion(): void
  }
  class VersionCalificacion <<entidad>> {
    - id: Id
    - numero: Entero
    - puntaje: Entero
    - comentario: Texto
    - motivo: TextoOpcional
    - creadaEn: InstanteUTC
  }
  class RespuestaResena <<entidad>> {
    - id: Id
    - texto: Texto
    - estado: publicada_oculta
  }
  class Apelacion <<entidad>> {
    - id: Id
    - motivo: Texto
    - estado: Texto
    - presentadaEn: InstanteUTC
    + registrarResolucion(): void
  }
  class ResolucionApelacion <<entidad>> {
    - id: Id
    - decision: mantener_ajustar_anular
    - motivo: Texto
    - resueltaEn: InstanteUTC
    + aplicarSobreVersionVigente(): void
  }
}

package "Comunicación, soporte y control · F" {
  class Notificacion <<entidad>> {
    - id: Id
    - eventoId: Texto
    - tipoRecurso: Texto
    - recursoId: Id
    - leidaEn: InstanteOpcional
    + marcarLeida(): void
  }
  class PreferenciaNotificacion <<entidad>> {
    - canal: Texto
    - tema: Texto
    - habilitada: Booleano
  }
  class IntentoNotificacion <<entidad>> {
    - numero: Entero
    - canal: Texto
    - estado: Texto
    - programadoEn: InstanteUTC
  }
  class Comunicado <<entidad>> {
    - id: Id
    - titulo: Texto
    - estado: Texto
    - vigencia: IntervaloOpcional
    + visiblePara(rol: Rol, ahora: InstanteUTC): Booleano
  }
  class TicketSoporte <<entidad>> {
    - id: Id
    - asunto: Texto
    - estado: Texto
    + registrarActualizacion(): void
    + resolver(motivo: Texto): void
  }
  class RegistroAuditoria <<entidad>> {
    - id: Id
    - actorTipo: usuario_o_sistema
    - accion: Texto
    - recursoTipo: Texto
    - recursoId: IdOpcional
    - motivo: Texto
    - ocurridoEn: InstanteUTC
  }
  class MetodoPago <<entidad>> {
    - id: Id
    - nombre: Texto
    - activo: Booleano
  }
  class PagoSimulado <<entidad>> {
    - id: Id
    - importe: Dinero
    - estado: Texto
    - esSimulado: Booleano
    + registrarEventoSimulado(): void
  }
}

package "Valores, políticas y servicios de dominio" {
  class Dinero <<valor>> {
    - importe: Decimal
    - moneda: Texto
    + validarNoNegativo(): void
  }
  class Intervalo <<valor>> {
    - inicio: InstanteUTC
    - fin: InstanteUTC
    + solapa(otro: Intervalo): Booleano
    + validarOrden(): void
  }
  interface Reloj {
    + ahora(): InstanteUTC
  }
  interface RepositorioCandidatos {
    + obtenerInstantanea(solicitud: Solicitud): DatosCandidatos
  }
  class ServicioMatching <<servicio>> {
    + evaluar(solicitud: Solicitud, reglas: VersionReglas): EvaluacionMatching
    + ordenar(candidatos: ListaCandidatos): ListaCandidatos
  }
  class PoliticaElegibilidad <<servicio>> {
    + esElegible(tecnico: PerfilTecnico, solicitud: Solicitud): Booleano
  }
  class PoliticaAsignacion <<servicio>> {
    + validarEleccion(solicitud: Solicitud, oferta: Oferta): void
    + validarPuestoDisponible(solicitud: Solicitud): void
  }
  class PoliticaCalificacion <<servicio>> {
    + validarEnvio(participacion: Participacion, autor: Usuario): void
    + validarEdicion(calificacion: Calificacion): void
  }
  class MaquinaEstadosSolicitud <<servicio>> {
    + permite(origen: EstadoSolicitud, destino: EstadoSolicitud, contexto: Contexto): Booleano
  }
}

package "Estados del núcleo" {
  enum EstadoSolicitud {
    Registrada
    Enviada
    Pendiente
    Asignada
    EnAtencion
    Finalizada
    Cerrada
    Cancelada
    SinCalificar
    Expirada
  }
  enum EstadoOferta {
    Pendiente
    Aceptada
    Rechazada
    Expirada
    Retirada
  }
  enum EstadoParticipacion {
    Asignada
    EnAtencion
    Finalizada
    Cancelada
    Reemplazada
  }
  enum EstadoTecnico {
    PendienteVerificacion
    Activo
    Inactivo
    Suspendido
  }
  enum EstadoVerificacion {
    Pendiente
    Aprobada
    Rechazada
  }
}

' Asociaciones de identidad: perfiles por rol, no herencia de privilegios.
Usuario "0..*" -- "1" Rol : rol vigente
Rol "0..*" -- "0..*" Permiso : permisos del rol
Usuario "0..*" -- "0..*" Permiso : concesiones administrativas
Usuario "1" -- "0..1" PerfilCliente : perfil según rol
Usuario "1" -- "0..1" PerfilTecnico : perfil según rol
PerfilCliente "1" -- "0..*" BloqueoCliente : historial de acceso
Usuario "1" -- "0..*" BloqueoCliente : registra bloqueo
PerfilTecnico "1" -- "0..*" RevisionTecnico : revisiones
Usuario "1" -- "0..*" RevisionTecnico : revisa con permiso
PerfilTecnico "1" -- "0..*" DocumentoVerificacion : presenta
RevisionTecnico "0..*" -- "0..*" DocumentoVerificacion : evidencia examinada
DocumentoVerificacion "0..1" -- "1" Archivo : archivo privado
Usuario "1" -- "0..*" Archivo : propietario
PerfilTecnico "1" -- "0..*" TrabajoPortafolio : publica
TrabajoPortafolio "0..*" -- "0..*" Archivo : galería autorizada

' Catálogo y oferta profesional.
Especialidad "1" -- "0..*" Subcategoria : agrupa
Subcategoria "0..*" -- "0..1" Archivo : foto de carrusel
PerfilTecnico "1" -- "0..*" ServicioOfrecido : ofrece
Subcategoria "1" -- "0..*" ServicioOfrecido : servicio
ServicioOfrecido "1" *-- "1..*" VersionTarifa : historial de tarifas
PerfilTecnico "0..*" -- "0..*" Distrito : cobertura
PerfilTecnico "1" -- "0..*" Disponibilidad : declara
PerfilTecnico "1" -- "0..*" PausaTemporal : pausas

' Solicitudes y atención: la multiplicidad histórica no es el límite simultáneo.
PerfilCliente "1" -- "0..*" Solicitud : registra
Subcategoria "1" -- "0..*" Solicitud : clasifica
Distrito "1" -- "0..*" Solicitud : zona de atención
Solicitud "0..*" -- "0..*" Archivo : evidencias privadas
Solicitud "1" *-- "0..*" EventoSolicitud : línea de tiempo
Solicitud "1" -- "0..*" RondaOferta : rondas históricas
RondaOferta "1" *-- "0..*" Oferta : destinatarios de ronda
PerfilTecnico "1" -- "0..*" Oferta : destinatario
Oferta "0..*" -- "0..1" VersionTarifa : origen de tarifa notificada
Solicitud "1" -- "0..*" Participacion : participaciones históricas
PerfilTecnico "1" -- "0..*" Participacion : atiende
Oferta "1" -- "0..1" Participacion : elegida por cliente
Usuario "1" -- "0..*" Participacion : autoriza elección
Participacion "1" -- "0..1" Cita : reserva
Cita "1" -- "0..*" Reprogramacion : propuestas
Participacion "1" -- "0..1" ReporteAtencion : cierre individual
ReporteAtencion "0..*" -- "0..*" Archivo : evidencias de atención
Solicitud "1" -- "0..*" Incidencia : incidencias
Participacion "0..1" -- "0..*" Incidencia : atención afectada
Solicitud "1" -- "0..*" Reasignacion : historial de sustituciones
Reasignacion "0..*" -- "0..1" Participacion : participación anterior
Reasignacion "0..*" -- "0..1" Participacion : participación nueva
Usuario "0..1" -- "0..*" Reasignacion : actor manual o sistema

' Evaluación histórica y reglas versionadas.
Solicitud "1" -- "0..*" EvaluacionMatching : evaluaciones
VersionReglas "1" -- "0..*" EvaluacionMatching : reglas aplicadas
VersionReglas "0..1" -- "0..*" Solicitud : reglas al enviar
EvaluacionMatching "1" *-- "0..*" CandidatoMatching : ranking
CandidatoMatching "0..*" -- "1" PerfilTecnico : candidato
CandidatoMatching "0..*" -- "1" ServicioOfrecido : subcategoría y tarifa evaluadas
CandidatoMatching "1" *-- "0..1" FactoresMatching : completos si elegible
RondaOferta "0..*" -- "0..1" EvaluacionMatching : origen del ranking
Oferta "0..*" -- "0..1" CandidatoMatching : candidato notificado
VersionReglas "1" *-- "0..1" PesosMatching : borrador o configuración completa
VersionReglas "1" *-- "0..*" ValorParametro : valores de la versión
ParametroRegla "1" -- "0..*" ValorParametro : define tipo y unidad
Usuario "1" -- "0..*" VersionReglas : autor del cambio

' Reputación por participación, nunca una única reseña global de solicitud.
Participacion "1" -- "0..1" Calificacion : evaluación individual
Usuario "1" -- "0..*" Calificacion : cliente autor
Calificacion "1" *-- "1..*" VersionCalificacion : versiones inmutables
Calificacion "1" -- "0..1" RespuestaResena : respuesta del técnico
Calificacion "1" -- "0..*" Apelacion : apelaciones históricas
Apelacion "0..*" -- "1" VersionCalificacion : versión presentada
Apelacion "1" -- "0..1" ResolucionApelacion : resolución
ResolucionApelacion "0..*" -- "1" VersionCalificacion : versión revisada
ResolucionApelacion "0..*" -- "0..1" VersionCalificacion : versión resultante
Usuario "1" -- "0..*" ResolucionApelacion : administrador resolutor

' Comunicación, soporte, simulación económica y auditoría.
Usuario "1" -- "0..*" Notificacion : destinatario
Usuario "1" -- "0..*" PreferenciaNotificacion : preferencias
Notificacion "1" *-- "0..*" IntentoNotificacion : intentos por canal
Comunicado "0..*" -- "0..*" Rol : audiencia
Usuario "1" -- "0..*" Comunicado : autor autorizado
Usuario "1" -- "0..*" TicketSoporte : solicitante
Solicitud "0..1" -- "0..*" TicketSoporte : contexto opcional
Usuario "0..1" -- "0..*" RegistroAuditoria : actor o sistema
Solicitud "0..*" -- "0..1" MetodoPago : método elegido
Participacion "1" -- "0..*" PagoSimulado : registros ficticios
MetodoPago "1" -- "0..*" PagoSimulado : método declarado

' Dependencias de políticas: no son asociaciones persistentes ni FK.
ServicioMatching ..> RepositorioCandidatos : obtiene fotografía consistente
ServicioMatching ..> PoliticaElegibilidad : filtra antes de puntuar
ServicioMatching ..> FactoresMatching : calcula con fórmula acordada
ServicioMatching ..> PesosMatching : pondera
ServicioMatching ..> EvaluacionMatching : produce y explica
PoliticaElegibilidad ..> PerfilTecnico
PoliticaElegibilidad ..> ServicioOfrecido
PoliticaElegibilidad ..> Disponibilidad
PoliticaElegibilidad ..> PausaTemporal
PoliticaAsignacion ..> Solicitud
PoliticaAsignacion ..> Oferta
PoliticaAsignacion ..> Cita
PoliticaAsignacion ..> Reloj
PoliticaCalificacion ..> Participacion
PoliticaCalificacion ..> Calificacion
PoliticaCalificacion ..> Reloj
Solicitud ..> MaquinaEstadosSolicitud : transiciones permitidas
Solicitud ..> EstadoSolicitud
Oferta ..> EstadoOferta
Participacion ..> EstadoParticipacion
PerfilTecnico ..> EstadoTecnico
PerfilTecnico ..> EstadoVerificacion
ServicioOfrecido ..> Dinero
Cita ..> Intervalo

note right of Participacion
  Máximo vigente: un principal y un adicional.
  Las sustituciones conservan el historial.
  La ventana de calificación es individual.
end note

note right of Oferta
  Aceptación no equivale a asignación.
  Elección del cliente y revalidación obligatorias.
  Hasta 3 ofertas simultáneas; SLA de 10 min.
end note

note right of VersionReglas
  Una versión publicada tiene pesos completos:
  cercanía 35, tarifa 20, historial 30, experiencia 15.
  Son editables por nueva versión; suma = 100.
  Las evaluaciones conservan la versión utilizada.
end note

legend bottom
  |= Símbolo |= Significado |
  | - / + | Atributo privado / operación pública de dominio |
  | -- con multiplicidades | Asociación de negocio; no implica tabla o FK adicional |
  | *-- | Composición de contenido propio; no autoriza borrado físico en cascada |
  | ..> | Dependencia de uso; sin cardinalidad persistente |
  | entidad / valor / servicio | Identidad / dato inmutable por valor / política de negocio |
  Invariantes y correspondencia con el diccionario: CANVAS-Clases-Dominio-TecnicoYa.md.
endlegend
@enduml
```
