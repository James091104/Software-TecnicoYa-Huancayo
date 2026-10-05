# CANVAS DE ANÁLISIS DEL MVP
## TécnicoYa Huancayo

**Versión:** 1.0 · **Fecha:** 4 de octubre de 2026 · **Etapa:** análisis de usuarios y requerimientos.

**Estado:** información consolidada con decisiones pendientes explícitas. Este documento no declara implementación, ejecución de pruebas, conformidad normativa ni aprobación del asesor.

**Equipo:** Delgado Janampa, Jesus Oscar; Mayhuasca Huanca, Karen Jandre; Pimentel Chumbes, James. **Asesor:** Dr. Maglioni Arana Caparachin. **Institución:** Universidad Continental. **Curso indicado en la Fuente 0:** Pruebas y Calidad de Software, semestre 2026-2.

**Control del alcance:** no se seleccionan tecnologías, infraestructura, diseño físico de datos ni herramientas de implementación. Tampoco se programa el siguiente paso: lo indicará el usuario. Los mecanismos técnicos presentes en la Fuente 0 se mantienen como referencias diferidas, sin desarrollarlos aquí.

### Fuentes y autoridad de las decisiones

| Código | Fuente | Uso |
|---|---|---|
| F0 | FUENTE 0 — CONTEXTO MAESTRO DE TÉCNICOYA HUANCAYO, leído completo | Única fuente base del producto: propósito, actores, alcance, RF, RNF y paneles. |
| R1–R15 | Respuestas del usuario a las 15 preguntas de análisis, leídas completas | Aclaraciones y cambios explícitos a F0. |
| U | Mensaje que solicita este canvas | Última instrucción: moneda y pagos por confirmar; registro, calificación, contacto y control del siguiente paso. |

Ante una diferencia se aplica la instrucción explícita más reciente. Una marca **[CONFIRMAR]**, **[COMPLETAR]** o **[VALIDAR]** no se convierte en aprobación. Las precisiones añadidas para hacer verificables los requisitos se identifican como **propuesta de análisis**, no como regla acordada. No se utilizan otros documentos del repositorio ni investigación externa para definir el producto.

**Lectura del documento:** “confirmado” significa que el usuario lo especificó sin reserva; “provisional” mantiene su reserva; “pendiente” requiere una decisión. Ninguno de esos términos sustituye la aceptación académica del asesor.

## 1. Canvas ejecutivo

| Dimensión | Definición del MVP |
|---|---|
| Problema | Búsqueda informal de técnicos mediante recomendaciones, WhatsApp, redes y llamadas; información dispersa, dificultad para comparar y falta de seguimiento. |
| Usuarios | Clientes MYPES y hogares; prestadores técnicos independientes o empresas con una sola cuenta; administradores. |
| Propuesta de valor | Centralizar solicitud, comparación, matching, respuesta, asignación, atención, calificación y trazabilidad. |
| Especialidades | Cómputo, refrigeración comercial y electricidad; aproximadamente 30 subcategorías administrables. |
| Cobertura inicial propuesta | Huancayo, El Tambo y Chilca. Ratificación pendiente P03. No se acepta una solicitud fuera del catálogo de cobertura. |
| Flujo principal | Solicitar → notificar candidatos → recibir aceptaciones → elección del cliente → asignar → atender → finalizar → calificar/cerrar. |
| Diferencia entre rutas | Automática: rondas de hasta 3 candidatos. Desde perfil: primero solo el elegido; las alternativas requieren decisión del cliente. |
| Resultado esperado | Reducción de al menos 30 % en el tiempo de búsqueda y asignación frente a una comparación académica; todavía no medida. |
| Límite operativo | Demostración académica controlada, datos sintéticos, usuarios voluntarios y sin transacciones ni notificaciones externas productivas. |
| Modelo SaaS | Plataforma web de acceso por cuenta. No se definen planes, suscripciones comerciales, cobros por uso ni organizaciones con varios usuarios. |
| Gobierno | El asesor aprueba requerimientos e incrementos; un integrante aún por identificar mantiene el backlog. |
| Condiciones de calidad | Seguridad y privacidad por rol, escenarios BDD, trazabilidad y criterios medibles. Las metas son requisitos, no resultados obtenidos. |

## 2. Propósito y objetivos

**Objetivo general:** definir un MVP que conecte MYPES y hogares de Huancayo con técnicos adecuados, centralice el ciclo de servicio y permita evaluar la reducción del tiempo de búsqueda y asignación y la trazabilidad desde la solicitud hasta el cierre.

| ID | Objetivo específico | Evidencia prevista de aceptación |
|---|---|---|
| O-01 | Registrar necesidades claras y dentro de cobertura. | Recorrido de cinco pasos, validaciones, fotos y resumen previo al envío. |
| O-02 | Proponer candidatos elegibles y ordenar con criterios transparentes. | Escenarios de filtros, pesos, desempate, nuevos técnicos y estimaciones. |
| O-03 | Controlar notificaciones, SLA, rondas y falta de disponibilidad. | Línea de tiempo con envíos, respuestas, vencimientos y reasignaciones. |
| O-04 | Seguir la atención, sus cambios y la participación de técnicos. | Agenda, asignaciones, reprogramaciones, reportes y finalización individual. |
| O-05 | Recoger y revisar calificaciones de forma trazable. | Calificación, versiones, vencimientos y resolución motivada de apelaciones. |
| O-06 | Administrar el servicio con acceso restringido. | Habilitación, suspensiones, catálogo, reglas, comunicados, auditoría y reportes. |
| O-07 | Proteger la información y facilitar el uso. | Pruebas de permisos, privacidad, compatibilidad y evaluación de usabilidad. |
| O-08 | Evaluar el beneficio y la calidad académica del MVP. | Comparación de tiempos, más de 60 casos ejecutados y evidencias del periodo de demostración. |

No se garantiza una reducción real del 30 % sin medición. No se agregan objetivos comerciales, financieros ni de certificación.

## 3. Alcance y exclusiones

### Incluye

- Registro propio del cliente; registro del técnico en estado Pendiente de verificación; acceso por rol.
- Empresa técnica como un único prestador y una sola cuenta, sin empleados o subcuentas empresariales.
- Solicitud con especialidad, subcategoría, descripción, evidencia fotográfica, ubicación, modalidad y resumen.
- Modalidades “lo antes posible” y “programada”; fecha y hora se incluyen en el paso 4.
- Matching, notificaciones internas y en entorno de prueba, SLA, rondas, alternativas, asignación y pendientes.
- Atención, agenda, cancelación, reprogramación y participación de un técnico principal más uno adicional como máximo.
- Reporte individual, calificación de 1 a 5 con comentario, edición, historial y apelación.
- Perfiles, portafolio, búsqueda de técnicos, tarifas referenciales y criterios de matching visibles.
- Supervisión, verificación limitada, catálogo, distritos, comunicados, reglas editables, auditoría y reportes.
- Método de pago seleccionado y registrado; comprobante simulado como propuesta actual por confirmar. El detalle económico ampliado está suspendido como decisión pendiente P02.
- Landing y paneles definidos en F0, con las restricciones y pendientes de este documento.

### No incluye

- La ejecución física ni garantía material del trabajo del técnico.
- Verificación documental integral, certificación ISO o declaración de cumplimiento legal.
- Procesamiento de dinero, pasarelas, cobros, devoluciones ni facturación tributaria real.
- Aplicación móvil nativa, chat integrado, notificaciones externas productivas o geolocalización real en este MVP.
- Operación 24x7, carga de producción o validación comercial del mercado.
- Empresas con equipos de usuarios, planes de suscripción o permisos por organizaciones no definidos en las fuentes.
- Decisiones tecnológicas, infraestructura, código, sprints calendarizados o estimaciones de esfuerzo en esta etapa.

El alcance descrito contiene más que un formulario y un directorio. Para evitar una reducción implícita, cualquier traslado de una función a una versión posterior requiere decisión del usuario y aprobación del asesor.

## 4. Actores, responsabilidades y permisos

| Actor | Responsabilidades y acceso | Límites |
|---|---|---|
| Cliente | Gestiona su perfil, crea y sigue solicitudes propias, elige entre aceptaciones, autoriza técnico adicional, califica y pide soporte. | No modifica el ranking, la verificación ni datos privados de otros clientes. |
| Técnico/prestador | Declara especialidades, subcategorías, horarios, zona, tarifas y experiencia; responde ofertas y atiende sus asignaciones; registra reportes y apela. | No se autoverifica; no ve solicitudes ajenas ni documentos privados de otros técnicos. |
| Administrador | Verifica y gestiona técnicos y clientes; supervisa incidencias, apelaciones, catálogo, reglas, comunicados y reportes. | No crea o administra cuentas de otros administradores salvo permiso de responsable. |
| Administrador responsable | Tiene las capacidades administrativas y administra cuentas de otros administradores. | Es una especialización de permisos del rol administrador, no un cuarto tipo de cliente del negocio. |
| Docente/asesor | Aprueba requerimientos, acepta incrementos y resuelve diferencias del proyecto. | No se presupone una cuenta operativa ni acceso a datos personales por su función académica. |
| Responsable del backlog | Organiza decisiones y coordina con el asesor. Nombre pendiente P04. | No sustituye la aprobación del asesor. |
| Servicio externo de notificación en pruebas | Entrega o simula correo/push bajo condiciones de prueba. | No realiza envíos productivos a usuarios reales. |

Matching, temporizadores, notificaciones internas e historial son procesos internos. La geolocalización externa es futura, no un actor activo del MVP. “Soporte” representa una función administrativa existente; no se crea un rol adicional sin decisión.

### Visibilidad por momento

| Información | Antes de asignar | Después de asignar |
|---|---|---|
| Zona, descripción y fotos de la falla | Cliente titular y técnicos notificados; acceso administrativo para gestión. | Participantes autorizados y administración para gestión. |
| Dirección exacta y contacto privado del cliente | No se entregan a candidatos. | Solo a técnicos asignados y personal administrativo autorizado. |
| WhatsApp del técnico | Oculto al cliente. | Visible al cliente titular de la solicitud. |
| Documentos del técnico | Solo el propio técnico y administración. | Se mantiene la misma restricción. |
| Perfil público y reseñas | Datos destinados al perfil: bio, galería, especialidades y reseñas. | No habilitan acceso público a solicitudes, contactos ni documentos privados. |

**Propuesta de análisis:** revisar que las fotos y textos no expongan direcciones o teléfonos antes de la asignación. La política de conservación y cierre de cuenta queda pendiente de validación; no se declara conformidad legal.

## 5. Experiencia y recorridos de usuario

### 5.1 Solicitud automática

1. El cliente registrado completa cinco pasos: especialidad; subcategoría; descripción y fotos; ubicación, modalidad y horario; resumen y envío.
2. Se comprueban cobertura y datos requeridos. El cliente confirma el envío.
3. Se filtran candidatos y se obtiene el ranking con los criterios acordados.
4. Se notifica simultáneamente a los tres mejores candidatos elegibles como máximo, con 10 minutos de respuesta.
5. El cliente elige entre quienes aceptaron dentro del SLA. Aceptar una oferta no equivale a quedar asignado.
6. Si ninguno acepta, se pasa a la siguiente ronda de hasta tres. Agotados los candidatos, se muestra Pendiente de disponibilidad, hasta 24 horas.
7. La elección del cliente establece la asignación; se habilitan los contactos y se reserva la franja cuando corresponda.
8. El técnico inicia la atención y registra su finalización y reporte. Se habilita la calificación durante 48 horas.
9. Con calificación se cierra la atención; al vencer sin calificación queda Sin calificar. Con dos técnicos se conserva el resultado individual; la regla del estado global está pendiente P13.

Pendiente P11: si la elección puede hacerse apenas llega la primera aceptación o solo después de cerrar la ronda; cuánto tiempo tiene el cliente para elegir; qué ocurre si no elige o el candidato deja de estar disponible.

### 5.2 Solicitud desde el perfil

Se contacta primero únicamente al técnico elegido. Tiene el mismo SLA de 10 minutos. Si rechaza o no responde, se ofrecen alternativas del matching y el cliente decide cómo continuar. No hay reasignación automática en esta situación inicial. La relación entre esa excepción y una cancelación posterior a la asignación se registra en P14.

### 5.3 Atención con técnico adicional

El principal propone un técnico adicional; el cliente autoriza. No puede haber más de dos participantes técnicos: un principal y un adicional. Cada uno finaliza y recibe su propia calificación. Falta resolver elegibilidad, aceptación, plazos y estado global de una atención con resultados distintos; se conserva como P13, sin inventar un coordinador empresarial.

### 5.4 Supervisión e incidencias

El administrador puede revisar estados, notificaciones, rechazos, vencimientos y reasignaciones; atender reportes de inasistencia, habilitar o suspender prestadores y resolver apelaciones con motivo registrado. La reasignación manual debe mantener la trazabilidad. **Propuesta de análisis:** no debe permitir asignar técnicos suspendidos o fuera de especialidad; confirmar excepciones antes de definir los escenarios administrativos finales.

## 6. Estados y relojes del negocio

### 6.1 Solicitud y atención

| Estado | Significado | Salidas descritas o por precisar |
|---|---|---|
| Registrada | Solicitud registrada para continuar el flujo. | Enviada al contactar candidatos; frontera entre borrador y registro pendiente P22. |
| Enviada | Existen ofertas enviadas o respuestas en evaluación. | Asignada por elección; nuevas rondas; Pendiente si no quedan candidatos; Cancelada si procede. |
| Pendiente | Sin candidatos disponibles para asignación. | Nueva búsqueda si aparecen candidatos, con condición de reintento pendiente P12; Expirada al superar 24 h; Cancelada si procede. |
| Asignada | Cliente y técnico están vinculados al servicio. | En atención; Cancelada por el cliente antes del inicio; reasignación ante cancelación técnica. |
| En atención | El técnico inició el servicio. | Finalizada al registrar reporte; tratamiento de abandono o conflicto pendiente P14. |
| Finalizada | El técnico registró su finalización y reporte. | Cerrada al calificar; Sin calificar al vencer 48 h sin calificación. |
| Cerrada | Atención terminada con calificación registrada. | Puede editarse la calificación dentro de su plazo propio, sin reabrir la atención. |
| Sin calificar | Atención terminada cuyo plazo de calificación venció. | Estado terminal según R8; se considera parte del cierre operativo, sin segunda confirmación del cliente. |
| Cancelada | Cancelación válida antes de iniciar atención. | Reactivación no definida; no se supone permitida. |
| Expirada | Pendiente de disponibilidad que excedió las 24 h. | Estado propio confirmado; reactivación no definida. |

R8 aclara F0: la ventana de calificación empieza en **Finalizada**, no después de que el cliente haya calificado o confirmado un cierre. “Cerrada” y “Sin calificar” son resultados distintos de un cierre operativo. La agregación cuando participan dos técnicos sigue pendiente.

### 6.2 Técnico

Estados de F0: Pendiente de verificación, Activo, Inactivo y Suspendido. La verificación, la disponibilidad horaria y la pausa temporal son condiciones diferenciadas: estar verificado no implica estar disponible. El rechazo de verificación debe registrar motivo; falta definir si mantiene Pendiente o añade un estado propio (P22).

### 6.3 Plazos

| Evento | Regla | Estado de definición |
|---|---|---|
| Respuesta a oferta | 10 min, editable; no más de 3 notificados simultáneos. | Confirmado; inicio ante fallo de entrega y límite exacto pendientes P12. |
| Falta de disponibilidad | Hasta 24 h antes de Expirada. | Confirmado; reinicios o continuidad entre rondas pendientes P12. |
| Primera calificación | 48 h desde la finalización correspondiente. | Confirmado por R8. |
| Edición | 48 h desde que se calificó. | Confirmado; propuesta: anclar en la primera calificación y no reiniciar al editar, pendiente P23. |
| Reprogramación sin respuesta | A las 24 h se mantiene la fecha original. | Confirmado; tratamiento si la cita original ocurre antes, pendiente P14. |
| Margen de atención inmediata | Sin cita en las próximas 2 h. | Provisional P05. |
| Máximo de reprogramaciones | 2 por solicitud. | Provisional P06. |
| Apelación | 5 días hábiles desde la recepción de la calificación. | Provisional P07; calendario hábil y ediciones posteriores por precisar. |
| Retención | 12 meses. | Provisional P08; inicio y datos incluidos por precisar. |
| Confirmación de monto declarado | 48 h en R13. | No adoptado mientras P02 mantenga en conflicto el alcance económico. |

## 7. Reglas de negocio consolidadas

| ID | Regla | Origen / condición |
|---|---|---|
| RN-01 | Cliente se registra por sí mismo; técnico inicia Pendiente de verificación. | U, F0. |
| RN-02 | Empresa técnica opera como un único prestador con una sola cuenta. | R1. |
| RN-03 | Solo catálogo de distritos habilitados; fuera del catálogo se impide registrar y se informa “fuera de cobertura”. | R2; distritos iniciales P03. |
| RN-04 | Cinco pasos de solicitud; fecha/hora en el paso 4 para modalidad programada. | F0, R5. |
| RN-05 | Especialidad y subcategoría activas, técnico verificado y activo, disponibilidad compatible y sin pausa temporal. | F0. |
| RN-06 | Ranking: cercanía 35 %, tarifa 20 %, historial 30 %, experiencia 15 %; suma 100 %. | F0. |
| RN-07 | Empate: mayor calificación promedio. Empate persistente sin regla acordada. | F0; P15. |
| RN-08 | Nuevo técnico: valoración neutra del 50 % en el componente historial, con etiqueta sin información suficiente; se sustituye tras 3 servicios finalizados. | R10; falta caso sin calificaciones al tercer servicio, P15. |
| RN-09 | Distancia por centros de distrito, rotulada aproximada; estimación general por subcategoría sin historial. | R10; referencias y cálculo por precisar P15. |
| RN-10 | Ruta automática: hasta 3 candidatos por ronda, SLA 10 min; el cliente elige entre aceptaciones válidas. | R4. |
| RN-11 | Si nadie acepta, siguiente ronda; si no quedan candidatos, Pendiente hasta 24 h y luego Expirada. | R4, R8. |
| RN-12 | Ruta desde perfil: solo técnico elegido primero; rechazo o silencio lleva a alternativas que decide el cliente. | R4; excepción expresa a reasignación inicial automática. |
| RN-13 | Cita confirmada bloquea su franja; para atención inmediata se propone margen de 2 h. | R5; margen provisional y duración P05/P16. |
| RN-14 | Un principal y como máximo un adicional; propuesta del principal y autorización del cliente; finalización y calificación individuales. | R6. |
| RN-15 | Cliente puede cancelar hasta Asignada y antes de En atención. Técnico que cancela tras aceptar genera incidencia y reasignación. | R7; tratamiento de etapas y ruta directa P14. |
| RN-16 | Inasistencia: cliente reporta, soporte revisa y administrador puede reasignar manualmente. | R7. |
| RN-17 | Ambas partes pueden pedir reprogramación; requiere aceptación de la otra; sin respuesta en 24 h mantiene fecha original. | R7; tope propuesto de 2, P06. |
| RN-18 | Finalizar exige reporte y abre 48 h para calificar; no requiere confirmación de cierre del cliente. | R8. |
| RN-19 | Puntaje de 1 a 5 y comentario; edición dentro de 48 h desde calificación; se guardan versiones. | U, R9; límites de comentario P17. |
| RN-20 | Apelación abierta evalúa la versión vigente; administrador mantiene, ajusta o anula con motivo y auditoría. | R9; plazo P07. |
| RN-21 | Causales de revisión: lenguaje ofensivo, contenido ajeno al servicio, servicio no ocurrido o indicios de abuso. | R9; no hay modificación automática. |
| RN-22 | Antes de asignar, solo técnicos notificados ven zona, descripción y fotos; contacto y dirección exacta se habilitan al asignar. | R12, U. |
| RN-23 | Documentos del técnico: acceso propio y administrativo. Cierre de cuenta con anonimización propuesta, por validar. | R12; P08. |
| RN-24 | Habilitación revisa identidad, teléfono, especialidades, zona, tarifa, experiencia y evidencia; no implica verificación integral. | R11. |
| RN-25 | Rechazo por información falsa/incompleta, especialidad sin respaldo o duplicidad; suspensión por incumplimiento, inasistencia, quejas fundadas o abuso. | R11; umbrales pendientes P18. |
| RN-26 | Solo administrador responsable gestiona otras cuentas administrativas. | R11. |
| RN-27 | Catálogo conserva historial mediante activación/desactivación; no se eliminan categorías o subcategorías utilizadas. | F0; CRUD se interpreta sin borrado de historial. |
| RN-28 | Parámetros y pesos son editables con historial; falta definir su efecto sobre solicitudes en curso. | F0; P19. |
| RN-29 | Moneda propuesta S/, sin conversión. No se procesa dinero. Alcance de registros y comprobante pendiente. | U; P01/P02. |
| RN-30 | Límite de solicitudes activas simultáneas por cliente no definido. | U; P10. |

## 8. Catálogo de casos de uso

Los procesos automáticos de cada caso no se modelan como actores independientes. “Resultado” describe una condición esperada, no una función ya implementada.

| CU | Actor principal | Propósito y precondición | Resultado / excepción relevante |
|---|---|---|---|
| CU-01 | Cliente/técnico | Registrarse e iniciar sesión con su tipo de cuenta. | Cliente habilitado para solicitar; técnico pendiente hasta revisión. |
| CU-02 | Administrador | Revisar prestador registrado y gestionar su estado. | Habilitación o decisión motivada; no autoverificación. |
| CU-03 | Cliente | Completar y enviar solicitud dentro de cobertura. | Solicitud confirmada con subcategoría y modalidad; se rechazan datos inválidos. |
| CU-04 | Técnico | Declarar servicios, tarifas, horarios, cobertura y pausa. | Oferta profesional utilizable por matching y agenda. |
| CU-05 | Cliente/técnico | Buscar candidatos y responder ofertas automáticas. | Ranking, respuestas y elección; rondas o Pendiente si faltan candidatos. |
| CU-06 | Cliente | Solicitar a un técnico desde su perfil. | Contacto inicial exclusivo y alternativas bajo decisión del cliente. |
| CU-07 | Cliente/técnico | Consultar solicitud y atención asignada. | Línea de tiempo y contactos según permiso y momento. |
| CU-08 | Cliente/técnico | Cancelar o solicitar reprogramación. | Cambio permitido con registro; solicitud rechazada si incumple reglas. |
| CU-09 | Técnico principal/cliente | Proponer y autorizar técnico adicional. | Máximo dos participantes; aceptación operativa pendiente de precisar. |
| CU-10 | Técnico | Iniciar atención y registrar finalización con reporte. | Ventana de calificación individual; posterior cierre o Sin calificar. |
| CU-11 | Cliente | Calificar o editar dentro de plazo. | Puntaje/comentario y versiones; bloqueo fuera de plazo. |
| CU-12 | Técnico/administrador | Apelar y resolver una calificación. | Resolución motivada sobre versión vigente, con historial. |
| CU-13 | Cliente/técnico | Consultar perfil, historial y notificaciones propias. | Información filtrada por rol, pertenencia y visibilidad. |
| CU-14 | Administrador | Supervisar solicitudes, incidencias y cobertura. | Intervenciones auditadas, alertas y reportes. |
| CU-15 | Administrador | Administrar catálogo, distritos, reglas y comunicados. | Cambios validados y trazables; preservación del historial. |
| CU-16 | Administrador responsable | Administrar accesos administrativos. | Cuentas y permisos sin escalamiento desde otros roles. |
| CU-17 | Cliente | Registrar método de pago y consultar constancia simulada. | Ningún movimiento financiero; alcance documental pendiente P02. |
| CU-18 | Usuario | Consultar ayuda y reportar incidencias. | Canal de soporte existente; no se agrega chat integrado. |
| CU-19 | Visitante | Entender servicios y acceder al registro. | Landing con especialidades y llamadas a la acción. |
| CU-20 | Equipo/asesor/voluntarios | Evaluar el MVP con escenarios y evidencia. | Resultados medidos para aceptación académica, sin afirmar éxito previo. |

## 9. Historias de usuario y criterios BDD

Los criterios son especificaciones para futura validación, no pruebas ejecutadas. Las protecciones contra acceso ajeno y datos inválidos concretan el control por rol definido en F0. Cuando se cita un pendiente P, el escenario queda condicionado a resolverlo; no debe considerarse aceptado para implementar su parte incierta.

### HU-01 · Registro y acceso

Como cliente o técnico, quiero registrarme e iniciar sesión para utilizar las funciones de mi rol. **CU-01.**

- **AC-01.1 — Dado** un cliente sin cuenta y con datos válidos, **cuando** completa el registro, **entonces** obtiene una cuenta de cliente y puede acceder a su panel.
- **AC-01.2 — Dado** un técnico recién registrado, **cuando** entra a su cuenta, **entonces** se muestra Pendiente de verificación y no recibe asignaciones como técnico habilitado.
- **AC-01.3 — Dado** un visitante que intenta registrarse como administrador, **cuando** solicita ese privilegio, **entonces** se impide el alta administrativa por el registro público.

### HU-02 · Habilitación y estado del técnico

Como administrador, quiero revisar y gestionar prestadores para habilitar únicamente a quienes cumplan los requisitos definidos. **CU-02.**

- **AC-02.1 — Dado** un perfil pendiente con identidad, teléfono, especialidad, subcategorías, zona, tarifa, experiencia y evidencia, **cuando** el administrador aprueba su revisión, **entonces** queda habilitado y la decisión se registra.
- **AC-02.2 — Dado** un rechazo o suspensión por una causal definida, **cuando** el administrador registra la decisión y su motivo, **entonces** el prestador no participa como candidato habilitado y la intervención queda trazada. Los umbrales de suspensión automática no están definidos (P18).

### HU-03 · Solicitud en cinco pasos

Como cliente, quiero describir mi necesidad y revisar la información antes de enviarla para solicitar el servicio correcto. **CU-03.**

- **AC-03.1 — Dado** un cliente autenticado, **cuando** completa especialidad, subcategoría, descripción/fotos, ubicación/modalidad/horario y resumen, **entonces** puede confirmar la solicitud en cinco pasos.
- **AC-03.2 — Dado** un distrito fuera del catálogo o una subcategoría inactiva, **cuando** intenta enviar, **entonces** se impide el registro y se identifica el dato que debe corregir; fuera de catálogo se informa “fuera de cobertura”.

### HU-04 · Evidencia fotográfica

Como cliente, quiero adjuntar fotos de la falla para que los candidatos entiendan el problema. **CU-03.**

- **AC-04.1 — Dado** un archivo que cumple la política de imágenes acordada, **cuando** lo adjunto en el paso 3, **entonces** puedo revisar su asociación con la solicitud antes del envío. Tipos, tamaño, cantidad y obligatoriedad pendientes P17.
- **AC-04.2 — Dado** un técnico no notificado ni asignado, **cuando** intenta acceder a esas fotos, **entonces** no obtiene acceso por conocer el identificador de la solicitud.

### HU-05 · Subcategorías y tarifas referenciales

Como cliente, quiero identificar el servicio y su tarifa referencial para entender qué estoy solicitando. **CU-03/CU-04.**

- **AC-05.1 — Dada** una especialidad activa, **cuando** consulto sus servicios, **entonces** aparecen únicamente sus subcategorías activas y su información referencial.
- **AC-05.2 — Dada** una tarifa mostrada, **cuando** reviso el servicio, **entonces** se informa que es referencial y que el monto final se coordina en sitio; moneda y relación entre tarifa de catálogo y del técnico quedan sujetas a P01/P16.

### HU-06 · Disponibilidad y agenda

Como técnico, quiero declarar horarios, subcategorías, cobertura y pausas para recibir solicitudes compatibles. **CU-04.**

- **AC-06.1 — Dado** un técnico habilitado que está en pausa o no cubre la subcategoría/zona/franja, **cuando** se buscan candidatos, **entonces** no figura como elegible para esa solicitud.
- **AC-06.2 — Dada** una cita confirmada, **cuando** otra solicitud programada coincide con su franja, **entonces** esa franja no se ofrece como disponible. Duración de la franja y margen de atención inmediata pendientes P05/P16.

### HU-07 · Ranking y desempate

Como cliente, quiero recibir candidatos ordenados mediante criterios conocidos para comparar opciones pertinentes. **CU-05.**

- **AC-07.1 — Dados** candidatos elegibles, **cuando** se calcula el ranking, **entonces** se aplican cercanía 35 %, tarifa 20 %, historial 30 % y experiencia 15 %, o la configuración vigente cuyos pesos sumen 100 %.
- **AC-07.2 — Dados** dos candidatos con igual puntuación, **cuando** se ordenan, **entonces** se prioriza la mayor calificación promedio. Si también coincide, no se presume otro desempate hasta resolver P15.
- **AC-07.3 — Dado** un técnico sin historial, **cuando** participa, **entonces** se identifica como nuevo y se utiliza el 50 % del componente historial; sustitución después de tres servicios y ausencia de reseñas pendientes P15.

### HU-08 · Estimaciones comprensibles

Como cliente o técnico autorizado, quiero conocer estimaciones identificadas como aproximadas para no confundirlas con compromisos garantizados. **CU-05/CU-07.**

- **AC-08.1 — Dados** distritos con referencias de distancia definidas, **cuando** se muestra cercanía, **entonces** se rotula “distancia aproximada por zona”, sin afirmar ubicación en tiempo real.
- **AC-08.2 — Dado** un técnico sin historial suficiente, **cuando** se muestra tiempo de atención, **entonces** se indica “estimación general de la subcategoría”; la base numérica queda pendiente P15.

### HU-09 · Ofertas y SLA

Como técnico, quiero recibir ofertas con plazo visible para aceptar o rechazar a tiempo. **CU-05.**

- **AC-09.1 — Dada** una solicitud automática con candidatos disponibles, **cuando** se abre una ronda, **entonces** se notifica como máximo a tres y se muestra el plazo de 10 minutos configurado.
- **AC-09.2 — Dada** una ronda sin aceptaciones válidas dentro del SLA, **cuando** vence, **entonces** se registra el resultado y se contacta a la siguiente ronda de candidatos; no se supera el límite simultáneo. Inicio exacto y fronteras del reloj pendientes P12.

### HU-10 · Elección del cliente y ruta directa

Como cliente, quiero elegir al técnico que me atenderá para conservar el control sobre la asignación. **CU-05/CU-06.**

- **AC-10.1 — Dados** técnicos que aceptaron válidamente, **cuando** el cliente elige uno, **entonces** se registra su asignación y no se confunde la aceptación de otra oferta con una asignación adicional. Momento y vencimiento de elección pendientes P11.
- **AC-10.2 — Dada** una solicitud desde un perfil cuyo técnico rechaza o no responde, **cuando** termina ese intento, **entonces** se muestran alternativas y se espera la decisión del cliente, sin asignar automáticamente otro prestador.

### HU-11 · Pendiente y expiración

Como cliente, quiero saber cuándo no hay candidatos y cuándo termina la búsqueda para no esperar indefinidamente. **CU-05.**

- **AC-11.1 — Dada** una solicitud que agotó candidatos, **cuando** no puede asignarse, **entonces** queda Pendiente de disponibilidad y se informa su condición al cliente.
- **AC-11.2 — Dada** una solicitud pendiente que supera 24 horas según el reloj acordado, **cuando** se evalúa su plazo, **entonces** queda Expirada y se conserva su historial. Reintentos y continuidad del reloj pendientes P12.

### HU-12 · Seguimiento y cancelación

Como cliente, quiero consultar la evolución y cancelar antes de la atención cuando ya no necesite el servicio. **CU-07/CU-08.**

- **AC-12.1 — Dada** una solicitud propia, **cuando** consulto su detalle, **entonces** veo estado, línea de tiempo y solo los datos del técnico permitidos en ese momento.
- **AC-12.2 — Dada** una solicitud Asignada que aún no está En atención, **cuando** el cliente la cancela, **entonces** queda Cancelada; si ya está En atención, no se permite esa cancelación ordinaria. Excepciones e incidencias pendientes P14.

### HU-13 · Reprogramación e incidencias

Como cliente o técnico, quiero proponer un cambio de horario y reportar problemas para mantener una atención coordinada. **CU-08/CU-14.**

- **AC-13.1 — Dada** una propuesta de reprogramación, **cuando** la otra parte acepta un horario compatible, **entonces** se actualiza la cita y queda constancia de ambas intervenciones; si no responde en 24 horas, se mantiene la fecha original. Tope y proximidad de la cita pendientes P06/P14.
- **AC-13.2 — Dada** una inasistencia reportada por el cliente, **cuando** soporte la revisa, **entonces** el administrador puede reasignar manualmente y la incidencia y decisión quedan registradas.

### HU-14 · Técnico adicional

Como cliente, quiero autorizar la incorporación de un técnico adicional para controlar quién participa en mi atención. **CU-09.**

- **AC-14.1 — Dada** una solicitud con técnico principal, **cuando** este propone un adicional y el cliente autoriza, **entonces** puede incorporarse sin exceder un principal y un adicional; elegibilidad y aceptación del invitado pendientes P13.
- **AC-14.2 — Dada** una atención con dos técnicos, **cuando** cada uno registra su finalización, **entonces** se conservan reportes y oportunidades de calificación independientes, sin atribuir a uno el trabajo del otro.

### HU-15 · Atención, reporte y cierre

Como técnico, quiero registrar el inicio y fin de mi atención para dejar evidencia del servicio y habilitar su evaluación. **CU-10.**

- **AC-15.1 — Dada** una atención asignada al técnico, **cuando** registra el inicio y posteriormente la finalización con reporte, **entonces** queda trazada y se abre la ventana de 48 horas para calificar esa atención.
- **AC-15.2 — Dada** una atención finalizada, **cuando** el cliente califica, **entonces** se registra el cierre; si vence el plazo sin calificación, queda Sin calificar, sin exigir confirmación de cierre. Estado global con dos técnicos pendiente P13.

### HU-16 · Calificación y edición

Como cliente, quiero evaluar cada atención y corregir mi opinión dentro de plazo para mantener un historial fiel. **CU-11.**

- **AC-16.1 — Dada** una atención propia finalizada y dentro de las 48 horas, **cuando** envío un puntaje de 1 a 5 y comentario, **entonces** se registra la calificación asociada al técnico; puntajes fuera del rango se rechazan.
- **AC-16.2 — Dada** una calificación propia, **cuando** la edito dentro de las 48 horas desde que califiqué, **entonces** se guarda una nueva versión conservando la anterior; fuera del plazo se impide la edición. Anclaje exacto pendiente P23.

### HU-17 · Apelación y resolución

Como técnico, quiero apelar una calificación y recibir una resolución motivada para disponer de un mecanismo de revisión. **CU-12.**

- **AC-17.1 — Dada** una calificación del técnico y un plazo válido, **cuando** presenta una apelación, **entonces** se envía a revisión administrativa sin modificar automáticamente la nota. Plazo de cinco días hábiles provisional P07.
- **AC-17.2 — Dada** una apelación abierta y la versión vigente de la calificación, **cuando** el administrador mantiene, ajusta o anula con una causal y motivo, **entonces** se conserva la decisión auditada; no se sobrescribe silenciosamente el historial.

### HU-18 · Historial de servicios

Como cliente o técnico, quiero consultar mis atenciones y calificaciones para conocer mi actividad anterior. **CU-13.**

- **AC-18.1 — Dado** un usuario autenticado, **cuando** consulta su historial, **entonces** accede a solicitudes y participaciones propias con sus estados y calificaciones asociadas.
- **AC-18.2 — Dado** un historial que contiene solicitudes expiradas, canceladas o sin calificar, **cuando** se filtra por resultado, **entonces** esos registros conservan su condición y no se presentan como servicios exitosamente calificados.

### HU-19 · Transparencia del matching

Como técnico, quiero conocer los criterios del matching para entender cómo se determina mi posición. **CU-04/CU-05.**

- **AC-19.1 — Dado** un técnico que consulta los criterios, **cuando** se muestra la explicación, **entonces** identifica factores, pesos, condiciones de elegibilidad y desempate vigentes.
- **AC-19.2 — Dado** un técnico nuevo, **cuando** consulta cómo se trata su historial, **entonces** se explica el valor neutro y la condición de sustitución, sin presentar calificaciones inexistentes como reseñas reales.

### HU-20 · Notificaciones y preferencias

Como usuario, quiero recibir avisos pertinentes y consultar sus eventos para responder a tiempo. **CU-13.**

- **AC-20.1 — Dado** un evento de oferta, asignación o calificación pendiente dirigido a un usuario, **cuando** se emite una notificación, **entonces** aparece únicamente para su destinatario autorizado y se conserva su relación con el evento.
- **AC-20.2 — Dado** un fallo de entrega en el entorno de pruebas, **cuando** se reintenta, **entonces** no se exceden tres reintentos ni se realizan envíos productivos. Intervalo, preferencias obligatorias y objetivo de latencia pendientes P12/P21.

### HU-21 · Supervisión administrativa

Como administrador, quiero detectar solicitudes detenidas e incidencias para intervenir con trazabilidad. **CU-14.**

- **AC-21.1 — Dadas** solicitudes con eventos registrados, **cuando** consulto el panel, **entonces** veo actividad por periodo, cumplimiento de SLA, pendientes, técnicos y gráficos por especialidad/zona según F0.
- **AC-21.2 — Dada** una solicitud pendiente por más de 20 horas, **cuando** se evalúan alertas, **entonces** se presenta al administrador; los umbrales de SLA reiterado y calificación baja quedan pendientes P18.

### HU-22 · Reportes de cobertura y desempeño

Como administrador, quiero consultar y exportar reportes por zona y especialidad para evaluar cobertura y desempeño. **CU-14.**

- **AC-22.1 — Dados** registros del periodo seleccionado, **cuando** filtro por zona y especialidad, **entonces** el reporte usa esos filtros y permite distinguir solicitudes y técnicos pertinentes.
- **AC-22.2 — Dado** un reporte consultado, **cuando** se exporta a Excel o PDF, **entonces** conserva filtros, periodo y resultados; fórmulas de cobertura y denominadores pendientes P21.

### HU-23 · Método de pago y constancia simulada

Como cliente, quiero registrar el método de pago seleccionado para dejar esa información junto al servicio. **CU-17.**

- **AC-23.1 — Dado** un servicio propio, **cuando** selecciono un método permitido, **entonces** se conserva como dato declarado y no se ejecuta un cobro. Catálogo de métodos y alcance final pendientes P02/P16.
- **AC-23.2 — Dado** un comprobante de demostración, **cuando** se consulta, **entonces** se identifica como simulado y no acredita pago real ni validez tributaria. Generación de constancia, montos y ganancias quedan condicionados a P02.

### HU-24 · Privacidad y acceso por relación

Como usuario, quiero que mis datos se muestren solo a quienes corresponda para evitar exposición de información personal. **CU-07/CU-13/CU-16.**

- **AC-24.1 — Dado** un candidato notificado pero no asignado, **cuando** consulta una solicitud, **entonces** ve zona aproximada, descripción y fotos permitidas, sin dirección exacta ni contactos privados.
- **AC-24.2 — Dada** la asignación confirmada, **cuando** las partes consultan su atención, **entonces** se habilitan los datos necesarios y el WhatsApp del técnico solo al cliente correspondiente; otros usuarios siguen sin acceso.
- **AC-24.3 — Dado** un documento privado del técnico, **cuando** lo solicita otro cliente o técnico, **entonces** se deniega el acceso; su propietario y administración mantienen el acceso permitido.

### HU-25 · Catálogo y cobertura administrables

Como administrador, quiero mantener especialidades, subcategorías, imágenes y distritos para ofrecer servicios dentro del alcance. **CU-15.**

- **AC-25.1 — Dada** una subcategoría con solicitudes históricas, **cuando** se desactiva, **entonces** deja de ofrecerse para nuevas solicitudes sin eliminar ni desfigurar el historial.
- **AC-25.2 — Dado** un distrito habilitado en el catálogo, **cuando** el cliente registra una dirección de servicio, **entonces** puede seleccionarlo; cambios sobre atenciones existentes quedan sujetos a P19.

### HU-26 · Parámetros con historial

Como administrador, quiero modificar reglas dentro de sus restricciones para ajustar el funcionamiento sin perder trazabilidad. **CU-15.**

- **AC-26.1 — Dados** nuevos pesos, **cuando** su suma no es 100 %, **entonces** se rechaza el cambio y se informa el problema.
- **AC-26.2 — Dado** un cambio válido de un parámetro editable, **cuando** el administrador lo confirma, **entonces** queda historial del valor y del responsable; su aplicación a solicitudes abiertas depende de P19.

### HU-27 · Comunicados por audiencia

Como administrador, quiero publicar comunicados con audiencia y vigencia para informar a los usuarios pertinentes. **CU-15.**

- **AC-27.1 — Dado** un comunicado con título, imagen, texto, enlace, audiencia, inicio y vigencia, **cuando** se publica dentro del periodo válido, **entonces** se muestra a la audiencia elegida con vista previa disponible antes de publicar.
- **AC-27.2 — Dado** un comunicado fuera de vigencia o dirigido a otro rol, **cuando** un usuario abre su panel, **entonces** no se presenta como comunicado vigente para él; administración dispone de edición, eliminación y duplicado según F0.

### HU-28 · Permisos administrativos y auditoría

Como administrador responsable, quiero controlar cuentas administrativas para limitar acciones privilegiadas. **CU-16.**

- **AC-28.1 — Dado** un administrador ordinario, **cuando** intenta crear o administrar otro administrador, **entonces** se deniega la acción.
- **AC-28.2 — Dada** una intervención autorizada sobre accesos, reglas, verificación o apelaciones, **cuando** se confirma, **entonces** queda registro del responsable, acción y momento y, donde corresponde, motivo y cambio realizado.

### HU-29 · Perfil, portafolio y búsqueda

Como cliente, quiero buscar y comparar perfiles para elegir un prestador informado. **CU-04/CU-06/CU-13.**

- **AC-29.1 — Dado** el buscador, **cuando** filtro por especialidad, subcategoría, zona y calificación mínima, **entonces** veo resultados coherentes con esos criterios y puedo revisar bio, trabajos y reseñas.
- **AC-29.2 — Dado** un técnico dueño de su perfil, **cuando** actualiza bio o portafolio, **entonces** modifica únicamente su información permitida y no su estado de verificación; reglas de moderación y límites de archivos pendientes P17.

### HU-30 · Ayuda y soporte

Como usuario, quiero consultar ayuda y reportar dificultades para resolver dudas sin depender de funciones fuera del MVP. **CU-18.**

- **AC-30.1 — Dado** un usuario en su panel, **cuando** accede a ayuda, **entonces** encuentra FAQ y el canal de WhatsApp de soporte definido, sin un chat integrado.
- **AC-30.2 — Dado** un reporte de inasistencia o incidencia, **cuando** administración lo atiende, **entonces** puede relacionarlo con la solicitud y registrar su intervención; contacto de demostración y operación de bandeja pendientes P21.

### HU-31 · Presentación pública del servicio

Como visitante, quiero entender las especialidades y el funcionamiento para decidir si registrarme como cliente o técnico. **CU-19.**

- **AC-31.1 — Dada** la landing, **cuando** navego por ella, **entonces** encuentro las especialidades con carrusel, explicación por rol, FAQ, registro/acceso y llamados a la acción descritos en F0.
- **AC-31.2 — Dada** la demostración académica, **cuando** consulto el pie y el contenido de confianza, **entonces** se identifica el proyecto académico. Propuesta de análisis: los testimonios y cifras sintéticos se etiquetan como ejemplos y no como resultados reales.

### HU-32 · Validación académica del MVP

Como asesor y equipo, quiero evidencias reproducibles para aceptar los incrementos y evaluar los objetivos. **CU-20.**

- **AC-32.1 — Dados** participantes y escenarios aprobados, **cuando** se comparan ambos métodos de búsqueda con orden alternado, **entonces** se registran tiempos y evidencia y se evalúa si la mediana de TécnicoYa es al menos 30 % menor, sin declarar éxito si no lo es. Tamaño de muestra pendiente P09.
- **AC-32.2 — Dado** un incremento candidato a aceptación, **cuando** se revisa, **entonces** se presentan historias, criterios BDD, resultados de casos y pendientes; el asesor acepta o devuelve observaciones. El objetivo final exige más de 60 casos ejecutados, no solo criterios redactados.

## 10. Requerimientos funcionales y matriz RF → historia

Se conservan los 33 identificadores de F0. La tabla combina catálogo y trazabilidad para evitar versiones divergentes. Los criterios AC de las historias citadas forman la base para derivar casos de prueba en una etapa posterior.

| RF | Requerimiento de F0, precisado al nivel de análisis | Historia | Caso de uso |
|---|---|---|---|
| RF-01 | Registrar especialidad, descripción y ubicación dentro de cobertura; modalidad/horario en el paso 4. | HU-03 | CU-03 |
| RF-02 | Revisar resumen y confirmar envío en el quinto paso. | HU-03 | CU-03 |
| RF-03 | Asociar evidencia fotográfica con control de acceso. | HU-04, HU-24 | CU-03, CU-07 |
| RF-04 | Mostrar tarifa referencial, sin compromiso de cobro. | HU-05 | CU-03, CU-04 |
| RF-05 | Declarar disponibilidad horaria y evitar solapamientos de citas. | HU-06 | CU-04 |
| RF-06 | Matching por cercanía, tarifa, historial y experiencia según pesos. | HU-07 | CU-05 |
| RF-07 | Filtrar prestadores habilitados, activos, disponibles y compatibles. | HU-02, HU-06, HU-07 | CU-02, CU-04, CU-05 |
| RF-08 | Ordenar candidatos según la puntuación obtenida. | HU-07 | CU-05 |
| RF-09 | Desempatar por calificación promedio; empate persistente pendiente. | HU-07 | CU-05 |
| RF-10 | Afinar por subcategoría activa ofrecida por el técnico. | HU-05, HU-06, HU-07 | CU-03, CU-04, CU-05 |
| RF-11 | Mostrar tiempo estimado según experiencia/historial, o estimación general sin datos suficientes. | HU-08 | CU-05, CU-07 |
| RF-12 | Mostrar distancia aproximada por zona. | HU-08 | CU-05, CU-07 |
| RF-13 | Limitar ofertas simultáneas a tres, o parámetro vigente. | HU-09 | CU-05 |
| RF-14 | Mantener Pendiente de disponibilidad y expirar al superar 24 h. | HU-11 | CU-05 |
| RF-15 | Notificar ofertas al técnico autorizado. | HU-09, HU-20 | CU-05, CU-13 |
| RF-16 | Controlar plazo de respuesta y registrar vencimientos. | HU-09 | CU-05 |
| RF-17 | Reasignar según ruta automática o excepción de solicitud directa; registrar incidencias. | HU-09, HU-10, HU-13 | CU-05, CU-06, CU-08, CU-14 |
| RF-18 | Confirmar elección del cliente entre aceptaciones válidas. | HU-10 | CU-05, CU-06 |
| RF-19 | Consultar estados y trazabilidad, incluida cancelación. | HU-12, HU-15 | CU-07, CU-08, CU-10 |
| RF-20 | Reprogramar por acuerdo y conservar fecha si no se acepta en 24 h. | HU-13 | CU-08 |
| RF-21 | Coordinar principal y un adicional autorizado por cliente. | HU-14 | CU-09 |
| RF-22 | Registrar reporte y finalización; efectuar cierre operativo. | HU-15 | CU-10 |
| RF-23 | Calificar de 1 a 5 con comentario dentro de 48 h desde finalización; editar dentro del plazo propio. | HU-16 | CU-11 |
| RF-24 | Cerrar sin calificación al vencer su plazo. | HU-15 | CU-10 |
| RF-25 | Consultar historial de solicitudes, atenciones y calificaciones. | HU-18 | CU-13 |
| RF-26 | Presentar apelaciones y resolverlas con motivo e historial. | HU-17 | CU-12 |
| RF-27 | Mostrar al técnico criterios del matching. | HU-19 | CU-04, CU-05 |
| RF-28 | Registro e inicio de sesión por rol, sin alta administrativa pública. | HU-01 | CU-01 |
| RF-29 | Notificaciones en tiempo real dentro del entorno autorizado de prueba. | HU-20 | CU-13 |
| RF-30 | Supervisión administrativa de solicitudes, técnicos, estados e incidencias. | HU-02, HU-21 | CU-02, CU-14 |
| RF-31 | Reportes de cobertura y desempeño por zona/especialidad. | HU-22 | CU-14 |
| RF-32 | Seleccionar y registrar método de pago sin procesar dinero; detalle pendiente. | HU-23 | CU-17 |
| RF-33 | Proteger datos y aplicar permisos por rol y relación con el servicio. | HU-01, HU-24, HU-28 | CU-01, CU-07, CU-13, CU-16 |

### 10.1 Funciones de los paneles sin RF individual en F0

Estos identificadores complementarios **RF-C** desglosan contenido ya descrito en F0/R; no sustituyen ni renumeran los 33 RF ni representan funciones nuevas ajenas al alcance.

| ID | Función y origen | Historia |
|---|---|---|
| RF-C01 | Catálogo de especialidades/subcategorías, activación e imagen (F0 §8.4). | HU-25, HU-05 |
| RF-C02 | Catálogo administrable de distritos y rechazo fuera de cobertura (R2). | HU-25, HU-03 |
| RF-C03 | Reglas editables y registro de cambios (F0 §8.4). | HU-26 |
| RF-C04 | Comunicados, audiencias, vigencia, vista previa, edición, eliminación y duplicado (F0 §8.4). | HU-27 |
| RF-C05 | Cuentas administrativas, permisos y auditoría (F0 §8.4, R11). | HU-28 |
| RF-C06 | Perfiles, portafolio, búsqueda y solicitud desde perfil (F0 §8.2–8.3). | HU-29, HU-10 |
| RF-C07 | Ayuda, FAQ, canal WhatsApp y soporte administrativo (F0 §8.2–8.4). | HU-30 |
| RF-C08 | Landing con navegación, carrusel, confianza, testimonios, CTA y pie académico (F0 §8.1). | HU-31 |
| RF-C09 | Preferencias de notificación, avisos y comunicados en paneles (F0 §8.2–8.3). | HU-20, HU-27 |
| RF-C10 | Retención y anonimización al cerrar cuenta, propuestas por validar (R12). | HU-24; faltan criterios definitivos P08 |
| RF-C11 | Métodos guardados, constancia, montos e historial económico (F0 §8.2–8.3, R13, U). | HU-23; alcance en conflicto P02 |
| RF-C12 | Clientes, historial y bloqueo/desbloqueo (F0 §8.4). | HU-21, HU-28; efectos sobre servicios activos pendientes P18 |

RF-C12 requiere el siguiente criterio adicional: **AC-21.3 — Dado** un administrador con permiso y un cliente identificable, **cuando** registra bloqueo o desbloqueo, **entonces** la intervención se conserva en auditoría; los efectos sobre acceso y solicitudes en curso no se implementan sin resolver P18.

## 11. Requerimientos no funcionales y matriz RNF → historia

Las metas se conservan. Los RNF que prescriben mecanismos técnicos se registran a nivel de intención y se diferencian como **diferidos a diseño**; no se eliminan ni se reinterpretan como ya cumplidos.

| RNF | Criterio o intención conservada | Cómo se evaluará / límite pendiente | Historia relacionada |
|---|---|---|---|
| RNF-01 | Matching en 3 segundos o menos. | Medir desde solicitud de cálculo hasta ranking; volumen, repetición y estadístico de aceptación pendientes P21. | HU-07, HU-32 |
| RNF-02 | 200 usuarios concurrentes. | Escenario académico de carga; mezcla de acciones, duración y errores tolerados pendientes P21. | HU-03, HU-07, HU-20, HU-32 |
| RNF-03 | Uso en Chrome, Edge y Firefox; adaptación a móvil/escritorio. | Recorridos de registro, solicitud, ofertas y calificación; versiones y tamaños pendientes P21. | HU-01, HU-03, HU-09, HU-16, HU-31 |
| RNF-04 | SUS de 70 o más. | Evaluación con usuarios y registro del resultado; composición y protocolo pendientes P09/P21. | HU-32 |
| RNF-05 | Cinco pasos y mediana de 3 minutos o menos para registrar solicitud. | R15 aclara que deben cumplirse ambos; medir desde inicio del formulario hasta envío exitoso. Condiciones y ayuda permitida pendientes P21. | HU-03, HU-32 |
| RNF-06 | Disponibilidad del 99 %. | Propuesta R15: siete días, 07:00–22:00. Ventana, frecuencia de medición y tratamiento de interrupciones pendientes P09/P21. | HU-32 |
| RNF-07 | Hasta tres reintentos de notificación. | Simular fallos y comprobar límite y trazabilidad, sin envíos productivos; intervalos pendientes P12. | HU-20 |
| RNF-08 | Protección de contraseñas almacenadas. | Mecanismo prescrito en F0 reservado al diseño; en análisis exigir que usuarios y operadores no recuperen la contraseña original como dato visible. | HU-01, HU-24 |
| RNF-09 | Control de acceso por rol. | Escenarios permitidos y denegados, incluida pertenencia de solicitudes y permiso administrativo responsable. | HU-24, HU-28 |
| RNF-10 | Protección de información en tránsito. | Mecanismo técnico de F0 diferido a diseño; no exponer credenciales o datos privados durante el intercambio. | HU-01, HU-24 |
| RNF-11 | Separación de responsabilidades de la solución. | Restricción arquitectónica de F0 diferida; no se diseña infraestructura en este canvas. | HU-32, transversal |
| RNF-12 | Cobertura de pruebas de al menos 70 % en matching, notificación y calificación. | Métrica y unidad de cobertura pendientes P21; no confundir cobertura de código con historias que tienen criterios BDD. | HU-07, HU-09, HU-16, HU-20, HU-32 |
| RNF-13 | Despliegue reproducible según restricción de F0. | Prescripción técnica diferida; aceptación posterior sin selección de herramientas aquí. | HU-32, transversal |
| RNF-14 | Cambios de estructura de datos versionados. | Prescripción técnica diferida; evidencia se definirá en diseño y ejecución. | HU-32, transversal |

**Criterios de seguridad propuestos para posterior aprobación:** no exponer la existencia de otras cuentas por mensajes innecesarios; limitar intentos abusivos; poder recuperar acceso sin revelar credenciales; permitir cerrar sesión; validar archivos antes de hacerlos visibles. Son refinamientos propuestos de RF-28/RF-33, no funcionalidades asumidas como aprobadas ni selección de herramientas.

## 12. Modelo de datos conceptual

Este modelo expresa conceptos del negocio y relaciones, no tablas físicas, tipos de columnas, claves técnicas ni elecciones de base de datos. Las cardinalidades no resueltas se indican explícitamente.

| Entidad conceptual | Información del negocio | Relaciones principales |
|---|---|---|
| Cuenta/usuario | Identidad, contacto, estado de acceso y rol. | Tiene perfil según rol; multiplicidad de roles por persona pendiente P20. |
| Perfil de cliente | Datos de cliente, MYPE/hogar y ubicación habitual editable. | Un cliente registra muchas solicitudes; límite activas pendiente P10. |
| Perfil de técnico | Prestador individual/empresa, bio, experiencia, habilitación, disponibilidad y pausa. | Tiene especialidades, servicios ofrecidos, zonas, documentos y portafolio. |
| Revisión de técnico | Revisor, evidencia examinada, decisión, fecha y motivo. | Varias revisiones pueden pertenecer a un técnico; permiten conservar historial. |
| Especialidad | Nombre y estado activo. | Agrupa muchas subcategorías; cada subcategoría pertenece a una especialidad. |
| Subcategoría | Nombre, estado, imagen y referencia del servicio. | Aparece en solicitudes y ofertas profesionales. |
| Servicio ofrecido | Relación técnico–subcategoría, tarifa declarada y experiencia aplicable si se define. | Un técnico ofrece varias subcategorías; una subcategoría puede tener varios técnicos. |
| Distrito/zona | Nombre, cobertura activa y referencia para distancia aproximada. | Relaciona clientes, solicitudes y cobertura de técnicos. |
| Disponibilidad | Franjas declaradas, pausas y cobertura. | Pertenece al técnico; se contrasta con sus citas. |
| Solicitud | Cliente, subcategoría, descripción, ubicación, modalidad, horario solicitado, ruta automática/directa y estado. | Tiene fotos, rondas, ofertas, eventos y hasta dos participaciones asignadas. |
| Evidencia fotográfica | Imagen asociada, autor y momento de carga. | Pertenece a solicitud; acceso depende de relación con ella. |
| Ronda de ofertas | Secuencia, inicio, vencimiento y resultado. | Pertenece a solicitud automática; comprende hasta tres ofertas simultáneas según parámetro. |
| Oferta a técnico | Destinatario, envío, plazo, aceptación/rechazo/silencio. | Vincula solicitud y técnico candidato; no implica asignación. |
| Resultado de matching | Candidatos elegibles, puntuaciones, factores y configuración aplicada. | Se vincula a una búsqueda. Conservar su detalle histórico es propuesta de trazabilidad, su retención está pendiente P08. |
| Participación/asignación | Técnico principal/adicional, autorización, aceptación y estado de su atención. | Pertenece a una solicitud; permite reporte y calificación individual. |
| Cita | Franja confirmada y técnico participante. | Relaciona asignación con agenda; cambios se registran mediante reprogramaciones. |
| Reprogramación | Proponente, fecha original/propuesta, solicitud, respuesta y vencimiento. | Pertenece al servicio/cita; máximo provisional P06. |
| Incidencia | Tipo, reportante, momento, revisión y resolución. | Relaciona solicitud, participantes y actuación administrativa. |
| Reporte de atención | Trabajo descrito, inicio, finalización y autor. | Corresponde a la participación de cada técnico. |
| Calificación | Cliente autor, técnico evaluado, puntaje, comentario y fecha original. | Una por participación evaluable; tiene versiones y puede tener apelaciones según política pendiente P07. |
| Versión de calificación | Contenido, puntaje, autor del cambio, fecha y motivo cuando aplica. | Pertenece a una calificación; distingue edición del cliente y resolución administrativa. |
| Apelación | Motivo, técnico, versión vigente examinada, decisión y justificación. | Relaciona calificación y administrador resolutor. |
| Notificación/intento | Evento, destinatario, canal de prueba, estado e intentos. | Asociada a solicitud, oferta, calificación u otro evento permitido. |
| Preferencia de notificación | Canales elegidos por usuario. | No define por sí sola qué avisos son obligatorios; P12. |
| Documento/portafolio | Tipo, propietario, contenido y visibilidad. | Documentos privados y trabajos públicos se distinguen aunque pertenezcan al mismo técnico. |
| Método de pago seleccionado | Método declarado para un servicio. | Relacionado con cliente y solicitud; catálogo y métodos guardados pendientes P02/P16. |
| Registro económico/constancia | Montos declarados, confirmación y documento simulado si se aprueban. | Entidad condicional: no se adopta como requisito cerrado mientras exista P02. |
| Comunicado | Título, texto, imagen, enlace, audiencia, inicio y vigencia. | Administrado por personal autorizado, presentado a usuarios según audiencia. |
| Parámetro/versionado de regla | Valor, vigencia, responsable y motivo de cambio. | Se relaciona con decisiones de matching y plazos; efecto temporal pendiente P19. |
| Evento de solicitud | Estado anterior/nuevo, actor, momento y motivo. | Muchos eventos de una solicitud construyen su línea de tiempo. |
| Registro de auditoría | Acción privilegiada, actor, objeto, momento y motivo/cambio. | Registra intervenciones administrativas; acceso restringido. |
| Caso de soporte | Usuario, solicitud asociada si existe, motivo y atención. | Desglose conceptual de bandeja de soporte, sin chat integrado. |

### Relaciones esenciales

- Cliente **1 → muchas** Solicitudes. Cada solicitud pertenece a un solo cliente.
- Especialidad **1 → muchas** Subcategorías; Técnico **muchos ↔ muchas** Subcategorías mediante Servicio ofrecido.
- Solicitud **1 → muchas** Ofertas a técnicos; una aceptación sigue siendo candidatura hasta que el cliente asigna.
- Solicitud **1 → 0..2** Participaciones; cuando está asignada tiene principal y puede tener adicional.
- Participación **1 → 0..1** Calificación; Calificación **1 → muchas** Versiones. La política de múltiples apelaciones queda pendiente.
- Técnico **1 → muchas** Citas; no se permiten solapamientos de franjas confirmadas conforme a la regla de disponibilidad.
- Solicitud **1 → muchos** Eventos; se distingue historia de servicio de auditoría administrativa.

**Invariantes de análisis:** ninguna oferta crea una asignación por sí sola; una reseña corresponde a una atención identificable; desactivar catálogo no elimina historial; la declaración de un pago nunca acredita una transacción real.

## 13. Mapa de contenido por superficie

Este inventario conserva la estructura de F0. No prescribe un diseño visual nuevo ni agrega páginas técnicas.

| Superficie | Contenido requerido | Condiciones |
|---|---|---|
| Landing | Header con logo, Especialidades/Cómo funciona/Para técnicos, Encontrar técnico e Iniciar sesión; hero; carrusel; explicación por rol; confianza y números; 3–4 testimonios; CTA de técnicos; FAQ; CTA final; footer. | Identificación académica, contacto, cobertura, redes, términos y privacidad. Cifras/testimonios deben tener procedencia; se propone rotular los sintéticos. |
| Cliente: inicio y solicitud | Tarjeta de actividad, comunicados, accesos rápidos, aviso de calificación; formulario de cinco pasos y pantalla de espera. | Límite de solicitudes activas pendiente. “Tarjeta activa” no prueba que solo pueda existir una. |
| Cliente: seguimiento | Mis solicitudes, filtros/pestañas, detalle, línea de tiempo, datos técnicos, calificación y WhatsApp tras asignación. | “En curso” es una agrupación de consulta, no un nuevo estado. Incluir Expirada como resultado consultable sin ocultar registros. |
| Cliente: directorio | Filtros por especialidad, subcategoría, zona y nota mínima; perfil, bio, galería, reseñas y solicitar servicio. | Mantener excepción de solicitud directa. |
| Cliente: cuenta | Mis calificaciones, perfil, notificaciones/preferencias, ayuda/FAQ/WhatsApp. | Historial de pagos, métodos guardados y comprobante sujetos a P02. |
| Técnico: inicio y ofertas | Cronómetro SLA, ofertas, resumen mensual, Disponible/No disponible, comunicados y detalle de fallas. | La ubicación previa a asignación es aproximada. No confundir disponibilidad con habilitación. |
| Técnico: operación | Agenda en calendario/lista, inicio/finalización, horarios, distritos, subcategorías, pausas y tarifas. | No se desarrolla radio geográfico real mientras no se definan criterios distintos del distrito. |
| Técnico: reputación | Calificaciones, promedio general y por subcategoría, respuesta y apelación; historial, perfil, documentos y galería. | Respuesta pública a reseñas: detalle de edición/moderación pendiente P17. Ganancias y exportación económica sujetas a P02. |
| Técnico: comunicación | Comunicados, ayuda y soporte. | Sin chat integrado. |
| Administrador: supervisión | Métricas día/semana/mes, SLA, pendientes, técnicos activos/registrados, gráficos, alertas, solicitudes filtrables y línea de tiempo. | Fórmulas y umbrales pendientes P18/P21. |
| Administrador: personas | Técnicos por estado, verificación y apelaciones; clientes, historial, soporte y bloqueo/desbloqueo. | Motivos registrados; efecto de suspensiones sobre servicios en curso pendiente. |
| Administrador: configuración de negocio | Catálogo e imágenes, distritos, comunicados, reglas/pesos, historial de cambios. | Especialidades/subcategorías con desactivación sin borrar historial. |
| Administrador: control | Reportes de cobertura/desempeño y exportación Excel/PDF; cuentas administrativas, permisos y auditoría. | Administrador responsable controla otras cuentas administrativas. |

**Criterio complementario AC-17.3:** **Dada** una reseña del técnico, **cuando** publica una respuesta permitida, **entonces** se identifica como respuesta del prestador y no altera la calificación del cliente; extensión, moderación y posibilidad de editar esa respuesta quedan en P17.

## 14. Riesgos y mitigaciones de análisis

La valoración es cualitativa y propuesta; no representa un análisis estadístico realizado. Responsable indica una función, no una asignación personal ya aceptada.

| Riesgo | Impacto | Mitigación propuesta | Responsable / traza |
|---|---|---|---|
| RSK-01 · Alcance excesivo para equipo junior. | Alto | Dividir historias en incrementos verificables; impedir ampliaciones sin decisión; no simular que el panel completo está terminado. | Backlog y asesor; alcance, HU-32. |
| RSK-02 · Confundir aceptación con asignación. | Alto | Distinguir oferta y participación; comprobar elección del cliente y concurrencia de respuestas. | Equipo; HU-09/HU-10, P11. |
| RSK-03 · Doble reserva de horarios. | Alto | Definir duración y compatibilidad; revisar disponibilidad al confirmar, no solo al buscar. | Equipo y asesor; HU-06, P16. |
| RSK-04 · Exposición de dirección, fotos o documentos. | Alto | Minimizar datos visibles, controlar acceso por relación y revisar material adjunto; probar accesos denegados. | Equipo; HU-04/HU-24. |
| RSK-05 · Privilegios administrativos indebidos. | Alto | Separar permiso de administrador responsable; conservar auditoría y evaluar acciones prohibidas. | Responsable administrativo; HU-28. |
| RSK-06 · Vencimientos ambiguos o reiniciados. | Alto | Acordar inicio, límite exacto, continuidad y reloj común de cada plazo antes de cerrar escenarios. | Backlog; P12/P23. |
| RSK-07 · Ausencia de candidatos o nuevas ofertas duplicadas. | Medio | Escenarios sin cobertura efectiva, listas agotadas y reintentos; definir cuándo reintentar y a quién no volver a notificar. | Equipo; HU-11, P12. |
| RSK-08 · Sesgo o falsa precisión del matching. | Alto | Rotular aproximaciones, justificar referencias, distinguir datos ausentes y probar empates/nuevos técnicos. | Asesor y equipo; HU-07/HU-08, P15. |
| RSK-09 · Abuso en calificaciones y apelaciones. | Alto | Versiones, causales, resolución motivada y acceso al historial de decisiones; definir efecto de nota anulada. | Administración; HU-16/HU-17, P07. |
| RSK-10 · Cierre incoherente con dos técnicos. | Alto | Estados y calificaciones por participación; acordar estado global y sustitución de participantes. | Backlog; HU-14/HU-15, P13. |
| RSK-11 · Registros declarados interpretados como pagos reales. | Alto | Resolver P02; rotular constancia simulada y omitir cualquier afirmación de cobro o validez tributaria. | Asesor y equipo; HU-23. |
| RSK-12 · Declarar cumplimiento legal sin validación. | Alto | Mantener retención/anonimización como propuesta; separar análisis académico de evaluación jurídica. | Asesor; P08. |
| RSK-13 · No demostrar reducción del 30 %. | Medio | Aprobar comparación, alternar orden, conservar tiempos y reportar limitaciones; publicar resultados aunque no cumplan la meta. | Equipo y asesor; HU-32. |
| RSK-14 · Metas de rendimiento sin condiciones de medida. | Alto | Precisar carga, duración, operaciones, errores, dispositivos y estadísticos antes de aceptar RNF. | Equipo y asesor; P21. |
| RSK-15 · Cambios de reglas alteran servicios en curso. | Alto | Decidir vigencia temporal y conservar la regla usada en cada decisión; no aplicar retroactivamente por omisión. | Administración/backlog; HU-26, P19. |
| RSK-16 · Suspensión impide atender un servicio ya iniciado. | Alto | Definir efectos por estado y responsables de incidencias; no perder acceso administrativo al historial. | Administración; P18. |
| RSK-17 · Pruebas o grabaciones usan datos reales innecesarios. | Alto | Datos sintéticos y participación voluntaria; acordar autorización, uso y conservación de grabaciones. | Equipo/asesor; P08/P09. |
| RSK-18 · Documentos posteriores contradicen este análisis. | Medio | Mantener identificadores, versión, fuentes y registro de decisiones; actualizar trazas al aprobar cambios. | Responsable del backlog; todo el canvas. |

## 15. Supuestos y restricciones

### Supuestos de trabajo, no aprobaciones implícitas

- El usuario seguirá indicando la etapa siguiente; no se presume autorización para comenzar diseño técnico o implementación.
- El asesor estará disponible para resolver discrepancias y aceptar incrementos; aún falta el responsable nominal del backlog.
- La demostración dispone de usuarios voluntarios y técnicos de prueba; no acredita demanda real, cobertura real ni calidad material de servicios.
- Los ejemplos de tarifas, distancias y duración necesitarán una referencia acordada; no se inventan cifras de mercado.
- La participación de una empresa no crea un equipo de cuentas ni una organización con empleados en el MVP.
- Los subprocesos no definidos, como sustitución del técnico adicional o empate persistente, permanecen pendientes en vez de resolverse por una decisión oculta del desarrollo.

### Restricciones confirmadas

- Tres especialidades y aproximadamente 30 subcategorías; alcance geográfico limitado a catálogo aprobado.
- Sin ejecución financiera, verificación documental integral, chat integrado ni notificaciones externas productivas.
- Datos sintéticos, temporizadores configurables en pruebas y demostración académica controlada hacia la semana 12. La fecha de inicio y el calendario no se fijan aquí.
- Más de 60 casos de prueba ejecutados como exigencia final; bibliografía formal en APA 7 cuando corresponda a los entregables académicos. Este canvas no inventa referencias ni resultados.
- Filosofía DevSecOps, enfoque BDD, Scrum, principios SOLID y marcos/normas indicados por el usuario. Su mención no constituye certificación.
- No se definen tecnologías, estructura de código, infraestructura ni modelo físico. Las restricciones técnicas de F0 se conservan para revisar en una etapa posterior, sin adoptar decisiones adicionales.

## 16. Calidad, seguridad y marcos de referencia

Esta tabla describe **intenciones de aplicación propuestas** para el proyecto a partir de los marcos solicitados. No interpreta cláusulas, ediciones, obligaciones legales ni certificaciones; esos detalles no están contenidos en F0 y no se han investigado por la restricción de fuente única.

| Referencia solicitada | Aplicación prevista en análisis | Evidencia conceptual prevista |
|---|---|---|
| DevSecOps | Considerar seguridad y calidad desde los requerimientos y cambios. | Riesgos, permisos y criterios de aceptación junto con cada incremento. |
| BDD | Definir comportamiento observable con ejemplos compartidos. | Historias y criterios Dado/Cuando/Entonces trazados a RF/RNF. |
| Scrum | Organizar la revisión incremental del producto. | Backlog pendiente de calendarizar, decisiones y aceptación del incremento. |
| SOLID | Mantenerlo como orientación del diseño posterior. | En esta etapa solo responsabilidades y límites claros; sin evaluar código. |
| ISO 9001 | Usarla como referencia de gestión de calidad y control documental. | Versiones, revisión, aceptación y tratamiento de observaciones. |
| ISO/IEC 25010 | Usarla como referencia para organizar atributos de calidad. | RNF y procedimientos de medición por definir. |
| ISO/IEC 27001 | Usarla como referencia para seguridad basada en riesgos y control de accesos. | Matriz de permisos, riesgos y evidencias de revisiones. |
| ISO/IEC 27701 | Usarla como referencia para el análisis de privacidad. | Finalidades de datos, visibilidad, retención y anonimización pendientes de validación. |
| ISO/IEC/IEEE 29119, partes 2, 3 y 4 | Considerarlas al planificar, documentar y derivar pruebas. | Trazabilidad y futura definición de escenarios, casos, resultados y evidencias. |
| ISO/IEC 19510 (BPMN) | Considerarla para representar procesos posteriormente. | Flujos textuales, responsables, eventos y excepciones de este canvas como entrada. No se afirma que el texto sea un modelo BPMN. |
| ISO 9241-210 | Usarla como referencia para atender contexto de uso y necesidades de personas. | Perfiles de usuario, recorridos y validación con participantes. |
| PMBOK | Usarlo como marco de referencia para gestionar alcance, riesgos y cambios. | Objetivos, restricciones, registro de pendientes y responsables. |
| COBIT 2019 | Usarlo como marco de referencia para responsabilidades y supervisión de TI. | Separación de aprobación académica, administración operativa y permisos privilegiados. |
| Ley N.° 29733, mencionada en F0/R12 | Registrar la necesidad de validar tratamiento de datos. | P08 abierto; ninguna afirmación de cumplimiento ni consejo jurídico en este documento. |

## 17. Validación y criterios de finalización del análisis

### 17.1 Evaluación del beneficio propuesta por el usuario

Comparar la búsqueda informal y TécnicoYa con tres escenarios estandarizados, uno por especialidad. La propuesta usa 10 participantes (pendiente P09) y alterna el orden de ambos métodos. La medición inicia al recibir el escenario y termina con técnico confirmado y hora de atención. Se conservarían hoja de cronometraje y grabación de pantalla bajo condiciones de privacidad acordadas.

**Criterio objetivo:** mediana del tiempo con TécnicoYa ≤ 0,70 × mediana del tiempo del método informal. La regla para sesiones fallidas, tiempos máximos y resultados incompletos debe acordarse antes de medir (P21). No excluir fallos de forma silenciosa para mejorar el resultado. Los técnicos de prueba limitan la generalización a condiciones reales.

### 17.2 Condiciones para considerar una historia lista para planificar

**Propuesta de análisis:** actor y propósito claros; RF/CU relacionados; al menos un comportamiento exitoso y uno alternativo; datos visibles definidos; dependencias y pendientes identificados; sin decisiones de negocio ocultas. Una historia puede prepararse parcialmente, pero su aceptación definitiva no debe depender de un valor que siga marcado por confirmar.

### 17.3 Condiciones para aceptar un incremento posteriormente

**Propuesta para validación del asesor:** comportamiento demostrado frente a sus criterios; pruebas relevantes ejecutadas y resultados registrados; acceso por rol revisado; incidencias y riesgos visibles; documentación/trazas actualizadas; observaciones conocidas declaradas y decisión del asesor registrada. El umbral de defectos admitidos y las métricas finales permanecen pendientes P21. Este canvas no fija herramientas, tareas técnicas ni duración de sprints.

### 17.4 Condiciones de cierre de esta etapa

- Cobertura documental de todos los RF-01 a RF-33 y RNF-01 a RNF-14, sin omitir las funciones complementarias de los paneles.
- Diferenciar reglas confirmadas, provisionales, propuestas y conflictos.
- Relacionar requerimientos, historias, criterios y casos de uso; completar pendientes que bloqueen la aceptación de las historias priorizadas.
- Revisar el documento con el usuario y registrar la aprobación del asesor cuando exista.
- Mantener sin iniciar la siguiente etapa hasta que el usuario la indique.

**Estado actual:** los dos primeros puntos y la trazabilidad documental se entregan en este canvas; las decisiones pendientes y la aprobación del asesor no se presumen resueltas.

## 18. Registro de decisiones pendientes y conflictos

Este registro permite continuar la revisión sin presentar como definitivos los valores marcados por el usuario. No es una nueva solicitud de respuestas inmediata ni cambia la etapa del proyecto.

| ID | Decisión pendiente | Base actual y efecto |
|---|---|---|
| P01 | Confirmar moneda. | S/ y sin conversión, marcado [CONFIRMAR] en U. Afecta tarifas y cualquier dato económico. |
| P02 | Resolver alcance de pagos/comprobante. | R13 propone monto y estado declarados por técnico, confirmación del cliente en 48 h, ganancias declaradas y constancia de servicio PDF. U limita a método de pago y comprobante simulado, también por confirmar. Se toma esta última formulación como propuesta vigente; no se adoptan montos, ganancias o confirmación como requisitos cerrados. El no procesamiento de dinero sigue confirmado. |
| P03 | Ratificar distritos y ampliaciones. | R2 propone Huancayo, El Tambo y Chilca; U vuelve a marcar cobertura [COMPLETAR]. Se conserva la propuesta sin declarar catálogo cerrado. |
| P04 | Identificar responsable del backlog. | R3 conserva [NOMBRE]; el asesor mantiene aprobación y resolución de discrepancias. |
| P05 | Confirmar margen de atención inmediata. | R5 propone técnicos sin citas próximas en 2 h. Falta tratar servicios en curso y duración prevista. |
| P06 | Confirmar máximo de reprogramaciones. | R7 propone 2 por solicitud; precisar si cuenta propuestas o cambios aceptados, y si el tope es global con dos técnicos. |
| P07 | Completar apelaciones. | Cinco días hábiles provisional; calendario, reinicio por edición, una o varias apelaciones y efecto de nota anulada/ajustada en promedios y ranking por precisar. |
| P08 | Validar privacidad, retención y cierre de cuenta. | Doce meses provisional; definir desde cuándo, qué datos, conservación de evidencias/grabaciones, anonimización y tratamiento de servicios abiertos. Validación legal pendiente, sin afirmar cumplimiento. |
| P09 | Confirmar muestra y ventana de demostración. | Diez participantes; siete días de 07:00 a 22:00, ambos provisionales. Precisar participantes, autorización de grabación y limitaciones. |
| P10 | Definir solicitudes activas simultáneas por cliente. | U lo marca [COMPLETAR]. No se asume una sola ni un número ilimitado. Definir qué estados cuentan. |
| P11 | Completar elección de candidatos y asignación. | Definir elección inmediata o al final de ronda, plazo del cliente, cierre de ofertas no elegidas y respuesta si cambia la disponibilidad; impedir asignaciones incompatibles simultáneas. |
| P12 | Completar relojes, rondas y notificaciones. | Inicio del SLA ante entrega fallida; aceptación en el límite exacto; conservación del reloj de 24 h; reintento al aparecer candidatos; intervalos de notificación y avisos que no pueden desactivarse. |
| P13 | Completar reglas de dos técnicos. | Aceptación/eligibilidad del adicional, plazos, cancelación o sustitución individual, franjas y regla global cuando uno finaliza o es calificado y el otro no. |
| P14 | Consolidar cancelación y reprogramación. | R7 aporta reglas, pero U las vuelve a marcar [COMPLETAR]. Mantener reglas ya descritas sin asumir que cubren cancelación durante atención, ruta directa tras asignación, citas que vencen antes de responder o liberación de reservas. |
| P15 | Completar estimaciones y matching sin información. | Referencias para distancias, fórmulas/normalización, duración general y por historial, técnico con tres servicios sin reseñas y empate persistente. No inventar kilómetros, duraciones ni calificaciones. |
| P16 | Completar tarifas, métodos y franjas. | Relación de tarifa de catálogo y de técnico; duración de citas; catálogo de métodos de pago y datos mínimos de métodos guardados. No se presupone almacenamiento de datos bancarios. |
| P17 | Completar política de contenido. | Obligatoriedad/cantidad/tamaño/tipo de fotos, comentario y reporte; límites de portafolio y documentos; respuestas a reseñas, edición y moderación. |
| P18 | Definir umbrales y efectos de sanciones. | SLA reiterado, calificación baja sostenida, motivos de bloqueo del cliente y efectos sobre sesiones, ofertas, citas y servicios en curso. No se define sanción automática por omisión. |
| P19 | Definir vigencia de cambios administrativos. | Parámetros o catálogos cambiados mientras existen solicitudes abiertas: mantener versión inicial o aplicar nueva bajo regla explícita. |
| P20 | Definir una persona con varios roles. | No se aclara si un técnico puede ser cliente con la misma cuenta ni cómo operan los accesos cruzados. La empresa de cuenta única no resuelve esta cuestión. |
| P21 | Completar protocolo de calidad y reportes. | Condiciones de carga/tiempos/errores; latencia de tiempo real; navegadores y tamaños; métrica de cobertura de pruebas; disponibilidad; fórmulas de reportes, ganancias si se aprueban, criterio de defectos admitidos y tratamiento de mediciones fallidas. |
| P22 | Precisar estados iniciales y de verificación. | Determinar si hay borrador antes de Registrada, transición exacta al confirmar y representación del rechazo de verificación sin inventar un nuevo estado. |
| P23 | Precisar anclaje de edición de calificación. | U/R9 dicen 48 h desde que calificó. Se propone contar desde el primer envío y no reiniciar por ediciones; falta confirmación y tratamiento de ediciones tras resolución administrativa. |

## 19. Control de cambios, trazabilidad y conservación de fuentes

### Registro de aclaraciones aplicadas

| Decisión | Cambio frente a la formulación inicial | Fuente |
|---|---|---|
| D-01 | Empresa técnica limitada a una cuenta prestadora. | R1 |
| D-02 | Elección del cliente entre aceptaciones; ruta directa con alternativas no automáticas. | R4 |
| D-03 | Modalidad programada o lo antes posible; horario dentro del paso 4. | R5 |
| D-04 | Máximo principal y adicional; calificación y finalización individuales. | R6 |
| D-05 | Calificación desde Finalizada; sin confirmación de cierre del cliente; Expirada como estado propio. | R8 |
| D-06 | Versiones de calificación y apelación sobre versión vigente. | R9 |
| D-07 | Aproximación por distrito y tratamiento neutro de técnicos nuevos. | R10 |
| D-08 | Permiso específico de administrador responsable. | R11 |
| D-09 | Cinco pasos y mediana de tres minutos, ambas condiciones; semana 12 como demostración académica. | R15 |
| D-10 | Alcance económico ampliado no consolidado por discrepancia con última instrucción. | R13 frente a U; P02 |

### Matriz objetivo → requerimientos → evidencia prevista

| Objetivo | Requerimientos relacionados | Evidencia futura |
|---|---|---|
| O-01 | RF-01..04, RF-10, RF-C02; RNF-05 | HU-03/HU-04/HU-05, validaciones y medición del recorrido. |
| O-02 | RF-05..12, RF-27 | HU-06/HU-07/HU-08/HU-19, ejemplos de ranking y exclusión. |
| O-03 | RF-13..18, RF-29; RNF-07 | HU-09/HU-10/HU-11/HU-20, eventos y temporizadores. |
| O-04 | RF-19..22 | HU-12/HU-13/HU-14/HU-15, transiciones e incidencias. |
| O-05 | RF-23..26 | HU-15/HU-16/HU-17/HU-18, versiones y resoluciones. |
| O-06 | RF-28, RF-30..33, RF-C01..05, RF-C12 | HU-01/HU-02/HU-21..HU-28, permisos y auditoría. |
| O-07 | RF-33; RNF-03..05, RNF-08..10 | HU-24/HU-28/HU-31/HU-32, accesos denegados y evaluación de uso. |
| O-08 | RNF-01..14, exigencia académica de casos | HU-32, informe de resultados y revisión del asesor. |

Cadena de trazabilidad prevista: **F0/R/U → O/RN → RF o RNF → HU → AC → caso de prueba → resultado/evidencia → decisión del asesor**. Los tres últimos elementos no se rellenan como si existieran; se producirán en su etapa correspondiente.

### Archivos de origen utilizados

- [Fuente 0 — contexto maestro](<C:/Users/James/.codex/attachments/71cb92b5-6418-4e7c-8181-6ea337469151/Texto pegado.txt>).
- [Respuestas a las 15 preguntas](<C:/Users/James/.codex/attachments/52d2e6da-ae01-4763-921e-a2e76a9dd01a/Texto pegado.txt>).
- Último mensaje del usuario en este chat: condiciones complementarias y solicitud de canvas.

No se ha usado el código existente como prueba de conformidad ni se han actualizado los PDF anteriores. Este documento es una base editable de análisis. La siguiente actividad queda a indicación del usuario.
