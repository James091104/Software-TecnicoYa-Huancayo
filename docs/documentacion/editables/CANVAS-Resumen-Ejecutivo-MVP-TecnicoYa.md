# TécnicoYa Huancayo
## CANVAS | Resumen ejecutivo del MVP

Versión 1.0 | 4 de octubre de 2026 | Base para revisión y aprobación académica

### 1. Propósito y justificación

TécnicoYa Huancayo es una plataforma web SaaS que conecta MYPES y hogares con técnicos independientes o empresas de cuenta única en cómputo, refrigeración comercial y electricidad. Centraliza la búsqueda, solicitud, asignación, atención y evaluación del servicio. Responde a la dispersión de información en recomendaciones, WhatsApp y avisos, que dificulta comparar disponibilidad, tarifas e historial y seguir la atención.

El MVP constituye un proyecto académico de la Universidad Continental. Su beneficio esperado es reducir el tiempo de búsqueda y asignación, mejorar la trazabilidad y facilitar decisiones informadas. La reducción esperada no se presenta como un resultado obtenido.

### 2. Objetivos

- Evaluar una reducción de al menos 30 % en la mediana del tiempo de búsqueda y asignación frente al método informal, mediante comparación académica controlada.
- Centralizar el ciclo completo del servicio, con responsables, estados, plazos e historial verificable.
- Seleccionar candidatos pertinentes mediante reglas transparentes y proteger la información mediante permisos por rol y relación con el servicio.
- Entregar un MVP verificable mediante escenarios BDD, pruebas y aceptación documentada de incrementos.

### 3. Alcance y exclusiones

**Incluye:** registro y acceso de clientes, técnicos y administradores; verificación limitada; tres especialidades y aproximadamente 30 subcategorías; solicitudes con fotos, ubicación y horario; matching con pesos editables; rondas de hasta tres candidatos y SLA de 10 minutos; elección del cliente, reasignación y pendiente hasta 24 horas; agenda, reprogramación y un técnico principal más uno adicional; finalización, calificación en 48 horas, edición y apelación; notificaciones, administración, auditoría y reportes. La solicitud desde un perfil conserva la decisión del cliente sobre alternativas. Los pagos se limitan al registro del método; el comprobante simulado y los detalles económicos siguen pendientes de ratificación.

**Excluye:** ejecución física del servicio, verificación documental integral, pagos reales, facturación tributaria, chat integrado, aplicación móvil nativa, geolocalización real, cuentas empresariales con empleados, notificaciones externas productivas y operación comercial 24x7. No se ofrece certificación normativa.

### 4. Interesados y gobierno

Clientes y técnicos aportan necesidades y participan en validaciones; los administradores supervisan el servicio. El equipo está integrado por Jesus Oscar Delgado Janampa, Karen Jandre Mayhuasca Huanca y James Pimentel Chumbes. El asesor, Dr. Maglioni Arana Caparachin, aprueba requerimientos e incrementos y resuelve discrepancias. El responsable del backlog está por designar. Los cambios de alcance se registran, evalúan y someten a aprobación.

### 5. Gestión por procesos y entregables

La gestión toma como referencia PMBOK y el enfoque por procesos de ISO 9001: cada proceso identifica entradas, responsable, salida y controles; sus resultados se revisan para corregir desviaciones y mejorar.

| Proceso | Entrada y responsable | Salida y control |
|---|---|---|
| Solicitar y seleccionar | Necesidad del cliente; cliente y plataforma. | Solicitud y elección; validación, ranking y SLA. |
| Atender y cerrar | Servicio asignado; técnico y cliente. | Reporte y evaluación; estados, plazos e historial. |
| Supervisar y mejorar | Incidencias e indicadores; administrador y equipo. | Decisiones y correcciones; auditoría y seguimiento. |

**Entregables:** análisis y diseño técnico; MVP de los tres roles; catálogo y datos sintéticos; documentación de API y datos; pruebas con evidencias; guía de operación y recuperación; demostración e informe de aceptación. La revisión y mejora se realizan en cada iteración.

<!-- SALTO DE PÁGINA -->

### 6. Supuestos y restricciones

Se supone disponibilidad del equipo, asesor y voluntarios. La cobertura propuesta es Huancayo, El Tambo y Chilca, por ratificar. Siguen pendientes los límites de solicitudes y determinadas reglas de elección, cancelación, doble atención y retención de datos.

Se aplicarán Scrum, BDD, SOLID y DevSecOps con las tecnologías del diseño técnico. La demostración hacia la semana 12 empleará datos sintéticos y servicios externos de prueba. Presupuesto, capacidad y calendario detallado están por acordar. Las normas orientan la gestión y calidad; no acreditan certificación.

### 7. Riesgos principales y respuesta

| Riesgo | Respuesta prevista |
|---|---|
| Alcance superior a la capacidad del equipo junior. | Priorizar incrementos verificables y controlar cambios. |
| Ambigüedad en reglas o vencimientos. | Resolver pendientes antes de aceptar el flujo afectado y probar límites. |
| Doble asignación o reasignación incorrecta. | Controles de concurrencia, auditoría y pruebas de operaciones simultáneas. |
| Exposición de datos o abuso de permisos. | Acceso mínimo por rol, archivos privados y pruebas de denegación. |
| Fallos de notificación o tareas temporizadas. | Reintentos controlados, recuperación y monitoreo de vencimientos. |
| No demostrar el beneficio esperado. | Comparación reproducible, evidencia de resultados y declaración de limitaciones. |

### 8. Hitos por iteración

Secuencia propuesta, sin duración de sprints aprobada. Seguridad, pruebas, documentación y revisión acompañan cada incremento.

| Iteración | Hito verificable |
|---|---|
| I1 | Alcance y decisiones iniciales revisados; acceso y permisos básicos demostrables. |
| I2 | Catálogo, cobertura, disponibilidad y solicitud en cinco pasos operativos. |
| I3 | Matching, ofertas, elección, SLA, reasignación y expiración verificables. |
| I4 | Agenda, atención, reprogramación y participación adicional trazables. |
| I5 | Calificación, apelaciones, administración, comunicados y reportes integrados. |
| I6 | Validación integral, recuperación ensayada y demostración académica aceptada. |

### 9. Criterios de éxito y aceptación

- **Beneficio:** mediana de búsqueda y asignación al menos 30 % menor; muestra y protocolo pendientes. Los técnicos de prueba limitan la generalización.
- **Funcionamiento:** historias priorizadas aceptadas, recorrido completo por rol y evidencia de reglas, permisos, plazos y acciones sensibles.
- **Usabilidad:** cinco pasos y mediana de hasta tres minutos para registrar una solicitud; SUS de al menos 70; uso responsivo en Chrome, Edge y Firefox.
- **Rendimiento:** matching de hasta tres segundos y prueba con 200 usuarios concurrentes, bajo condiciones acordadas. Disponibilidad objetivo de 99 % en la ventana de demostración aún por ratificar.
- **Calidad:** más de 60 casos ejecutados, cobertura mínima de 70 % en matching, notificación y calificación; resultados, defectos y correcciones trazables. Métrica de cobertura y umbral de defectos por precisar.
- **Gobierno:** aceptación del asesor con evidencias y documentación vigente. Las metas no representan resultados obtenidos.

**Base documental:** Fuente 0 - Contexto maestro; CANVAS de análisis del MVP v1.0; CANVAS de Diseño Técnico v1.0 y aclaraciones del usuario. Este resumen no reemplaza sus reglas ni resuelve los pendientes registrados.
