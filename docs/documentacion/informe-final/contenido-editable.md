# CAPÍTULO 1
# INFORMACIÓN GENERAL DEL PROYECTO
## 1.1 Resumen Ejecutivo
TécnicoYa Huancayo es un marketplace web de dos lados que conecta a hogares y micro y pequeñas empresas con técnicos independientes en cómputo, refrigeración comercial y electricidad. El problema de diseño consiste en organizar una búsqueda que suele distribuirse entre referencias personales, llamadas y mensajes, sin un registro común de disponibilidad, propuestas y cumplimiento. La magnitud de este problema en Huancayo requiere validación de campo; los antecedentes nacionales e internacionales permiten fundamentar la solución, pero no reemplazan esa medición local.

La plataforma concentra el registro de la falla, la selección de candidatos, la respuesta del técnico, la confirmación del cliente, la ejecución y la calificación del servicio. La propuesta considera verificación administrativa de técnicos, permisos por rol y propiedad del recurso, y plazos configurables. El matching utiliza cercanía por zona, tarifa de visita, calificación y experiencia. Los pesos y plazos son decisiones del proyecto que deben evaluarse con usuarios; no son valores prescritos por los artículos científicos.

La implementación utiliza React y Vite para la interfaz, Laravel para la API y las transacciones, FastAPI para el ranking y PostgreSQL como base de datos prevista para el despliegue. Existe una demostración independiente en localStorage. El modelo organizacional se ordena por procesos y responsabilidades, tomando como referencia ISO 9001; la calidad del producto y la documentación de pruebas se orientan mediante ISO/IEC 25010 e ISO/IEC/IEEE 29119-3, respectivamente, sin atribuir una certificación al proyecto.

Al 30 de septiembre de 2026 se verificaron 55 pruebas automatizadas aprobadas: 33 de frontend, 19 de Laravel y 3 de Python. Laravel se ensayó sobre SQLite en memoria; por ello, estos resultados no demuestran todavía la operación integrada sobre PostgreSQL. La cobertura de sentencias de app.py fue 100 % sobre 40 sentencias; este valor no representa la cobertura global. Permanecen pendientes el análisis SonarQube, el ensayo de despliegue, la carga, la aceptación local y ampliar el conjunto hasta superar 60 pruebas. El informe desarrolla el avance hasta el capítulo 13 con esas diferencias expresamente identificadas.
## 1.2 Introducción
Los mercados digitales deben facilitar el encuentro entre oferta y demanda y reducir la incertidumbre de una transacción entre personas que no se conocen. Einav et al. (2015) sitúan la búsqueda, el matching y la reputación entre las decisiones centrales de estas plataformas. En servicios técnicos, la decisión también involucra especialidad, cobertura territorial y disponibilidad; una lista de contactos por sí sola no controla todo el ciclo de atención.

TécnicoYa se desarrolla como proyecto académico de Ingeniería de Software y Pruebas y Calidad de Software de la Universidad Continental. Integra análisis de procesos, requisitos, arquitectura, implementación y evaluación. La asistencia de IA se utiliza como apoyo a la elaboración y revisión de artefactos, siempre sujeta a contraste con fuentes, inspección del código y pruebas. No se confunde la generación de código con la aceptación del producto.

El objetivo general es desarrollar y evaluar un marketplace web que permita gestionar de forma trazable solicitudes de servicios técnicos para MYPES y hogares de Huancayo. Se establecen los siguientes objetivos específicos y evidencias de logro.
| Objetivo | Evidencia prevista | Situación del avance |
| OE-01 Caracterizar el problema y sus procesos | Antecedentes, AS-IS y TO-BE contrastados con participantes locales | Análisis documental y modelos disponibles; contraste de campo pendiente |
| OE-02 Formalizar alcance, requisitos y reglas | Matrices RF/RNF, permisos y criterios de aceptación | Catálogo documentado; discrepancias identificadas |
| OE-03 Implementar el flujo principal | Registro, ranking, oferta, confirmación, atención y calificación | Código y pruebas parciales disponibles |
| OE-04 Proteger el acceso y la integridad | Pruebas negativas por rol, propiedad y estado | Pruebas API aprobadas en SQLite; auditoría integral pendiente |
| OE-05 Evaluar calidad y reproducibilidad | Logs, cobertura, SonarQube, contenedores y aceptación | 55 pruebas aprobadas; evaluación productiva pendiente |

Los capítulos 2 y 3 desarrollan contexto y procesos; los capítulos 4 y 5 establecen requisitos, alcance y calidad; los capítulos 6 y 7 describen diseño y arquitectura. El capítulo 8 organiza la construcción mediante fases con asistencia de IA y control humano. Los capítulos 9 y 10 abordan repositorio y contenedores. Los capítulos 11 a 13 presentan estrategia de pruebas, automatización y resultados medidos. Las referencias y anexos permiten rastrear las afirmaciones y reproducir las verificaciones.
# CAPÍTULO 2
# CONTEXTO ORGANIZACIONAL Y ANÁLISIS DEL PROBLEMA
## 2.1 Contexto de la Organización
La unidad de análisis es la operación propuesta de TécnicoYa, no una empresa de reparación con empleados propios. En un lado participan hogares y responsables de MYPES; en el otro, técnicos independientes. Un administrador supervisa la habilitación y las cuentas. La prestación física se realiza fuera del software; la plataforma registra decisiones y estados. No se acredita aún una entidad comercial operativa ni una relación laboral con los técnicos.

El catálogo inicial comprende reparación de computadoras, redes, WiFi e impresoras; refrigeración comercial; e instalaciones eléctricas. La configuración actual contempla Huancayo, El Tambo, Chilca, Pilcomayo y Huancán como zonas de atención. Esta lista es un catálogo del sistema y no demuestra cobertura efectiva ni disponibilidad de profesionales en todos esos lugares.

El producto se ofrece conceptualmente como servicio web accesible por navegador. El carácter SaaS describe el canal de entrega; no implica que exista una suscripción, un esquema multitenant o un ERP. El MVP se concentra en intermediación y seguimiento, sin contabilidad, recursos humanos ni inventario empresarial.
### 2.1.1 Mapa de procesos y responsabilidades
La orientación por procesos requiere identificar entradas, responsables, actividades, salidas y controles. ISO (2026) sirve como referencia de gestión de calidad; el mapa siguiente es una adaptación propia al negocio, no una declaración de conformidad ni una reproducción de cláusulas de la norma.
@figure mapa|Mapa propuesto de procesos de TécnicoYa|Elaboración propia. Los códigos vinculan el mapa con los procedimientos del capítulo 3 y el anexo A.
| Tipo | Proceso | Responsable propuesto | Salida controlada |
| Estratégico | E01 Dirección y alcance del producto | Responsable del producto | Objetivos y prioridades aprobados |
| Estratégico | E02 Gestión de calidad y riesgos | Responsable de calidad | Criterios de aceptación y riesgos revisados |
| Principal | P01 Alta y habilitación de técnicos | Administrador | Perfil habilitado o rechazado con motivo |
| Principal | P02 Registro de necesidad | Cliente | Solicitud válida y confirmada |
| Principal | P03 Matching y respuesta | Sistema y técnico | Oferta aceptada o espera registrada |
| Principal | P04 Confirmación y atención | Cliente y técnico | Servicio confirmado, iniciado y finalizado |
| Principal | P05 Calificación e historial | Cliente y sistema | Reseña válida y promedio consistente |
| Apoyo | A01 Identidad y control de acceso | Administrador y API | Cuenta y sesión autorizadas |
| Apoyo | A02 Infraestructura y respaldo | Responsable de operaciones | Entorno recuperable y registro de operación |
| Apoyo | A03 Soporte e incidencias | Administrador | Incidencia clasificada y seguimiento |
| Apoyo | A04 Configuración y documentación | Equipo de desarrollo | Versión trazable de código y documentos |

Los cargos de producto, calidad y operaciones expresan responsabilidades necesarias. La asignación nominal del equipo debe acordarse; no se atribuyen funciones o aprobaciones a integrantes sin evidencia. Los procesos de soporte e incidencias son procedimientos propuestos y no módulos completos ya implementados.
### 2.1.2 Estado del arte y transferencia al proyecto
El corpus proporcionado contiene 32 PDF y 30 documentos únicos; dos pares son duplicados exactos. Se realizó una revisión documental crítica, diferenciando investigaciones, revisiones, documentos de trabajo y prototipos. El inventario y las fichas se conservan en docs/documentacion/fuentes/articulos y trazabilidad/v2. La revisión no se presenta como búsqueda sistemática exhaustiva ni como metaanálisis.

Velásquez Chacón (2025) estudió 267 MYPES de Arequipa y encontró barreras de conocimiento y capacitación para la adopción digital. Este antecedente orienta formularios breves, mensajes comprensibles y acompañamiento durante el alta. Su contexto no permite estimar automáticamente el nivel de adopción de Huancayo. Navarro Rossel y Tang Gómez (2019) desarrollaron una propuesta peruana de conexión entre hogares y técnicos, con encuestas a 56 responsables de hogares y 53 técnicos; constituye un antecedente próximo del problema de intermediación, aunque corresponde a Lima y a otro periodo.

La revisión de Luca (2017) relaciona el diseño de reputación e información visible con la confianza entre participantes. TécnicoYa adopta una calificación vinculada a un servicio propio y diferencia la habilitación administrativa del promedio recibido. Demsyn-Jones (2022), a partir de un estudio aplicado en Thumbtack, advierte que la posición en los resultados afecta el comportamiento y puede sesgar las señales del ranking. Por ello, la exposición de técnicos nuevos y la distribución de oportunidades requieren evaluación; el ordenamiento actual no se declara imparcial solo por ser reproducible.

Aveklouris et al. (2021) estudian matemáticamente el matching con participantes heterogéneos que pueden abandonar la espera. El aporte permite comprender el compromiso entre rapidez y calidad de asignación. No valida un plazo específico de diez minutos ni las ponderaciones 35/20/30/15. Dedema y Rosenbaum (2024), mediante una revisión que codificó 132 trabajos, muestran que la gestión algorítmica y las asimetrías de información son también problemas sociotécnicos. La decisión de mantener revisión humana y mecanismos de explicación deriva de ese riesgo.

Para la arquitectura, Bejarano Gavilanes (2022) documentó una aplicación de servicios técnicos e inventario con Laravel y MySQL. El antecedente demuestra una aplicación posible del framework en un dominio afín, pero no establece superioridad frente a PostgreSQL. La decisión del proyecto es conservar el monorepo y las migraciones existentes, evitando introducir una migración tecnológica sin necesidad comprobada.

Para el método de construcción, Peng et al. (2023) realizaron un experimento con 95 programadores sobre una tarea de servidor HTTP. El resultado apoya evaluar asistencia de IA bajo condiciones controladas; no acredita que TécnicoYa haya obtenido el mismo incremento de productividad ni que la IA reemplace revisión, pruebas o responsabilidad profesional. Se selecciona ese artículo como antecedente de apoyo al desarrollo, no como una nueva metodología normativa.
## 2.2 Identificación del Problema
El problema central es la falta de un flujo integrado y verificable para localizar, seleccionar y dar seguimiento a un técnico adecuado. La información fragmentada obliga al cliente a repetir su necesidad y dificulta comparar condiciones; el técnico carece de un historial común y de un canal estructurado para responder. La administración propuesta tampoco dispone de una vista consolidada de solicitudes y cobertura cuando el proceso ocurre fuera de la plataforma.
| Causa analizada | Consecuencia esperada | Respuesta del diseño |
| Información dispersa e incompleta | Repetición de contactos y selección incierta | Solicitud estructurada y perfil comparable |
| Disponibilidad no verificable | Espera sin límite y abandono | Ofertas con vencimiento y espera máxima |
| Reputación no vinculada al servicio | Dificultad para valorar antecedentes | Reseña por servicio finalizado y propio |
| Ausencia de registro de decisiones | Conflictos difíciles de reconstruir | Eventos de solicitud y auditoría administrativa |
| Permisos insuficientes | Exposición o modificación de datos ajenos | Autorización por rol, propiedad y estado |

Estas relaciones constituyen el diagnóstico de diseño que debe contrastarse con entrevistas y observación local. Se propone registrar tiempo de búsqueda, número de contactos, disponibilidad obtenida y motivos de abandono, antes y después de un piloto comparable. No se afirma una reducción porcentual de tiempos, pérdidas económicas o fallas sin esa línea base. En electricidad y refrigeración, el sistema facilita contacto y seguimiento; no certifica la seguridad de la intervención física ni sustituye el juicio del profesional.
# CAPÍTULO 3
# ANÁLISIS DE PROCESOS DE NEGOCIO
## 3.1 Descripción del Proceso Actual
El AS-IS representa el escenario informal descrito en el proyecto original, sujeto a contraste de campo. Un cliente detecta una falla, busca referencias y contacta a uno o varios técnicos. Cada técnico solicita detalles, informa condiciones y acepta o rechaza según su disponibilidad. Si no hay respuesta, el cliente inicia otra búsqueda. La coordinación y el pago ocurren por canales separados y el resultado puede quedar sin registro estructurado.

Las entradas son la descripción de la falla, ubicación y referencias disponibles. La salida es una atención acordada o una necesidad no resuelta. El cliente asume la mayor carga de búsqueda; el técnico evalúa especialidad y tiempo disponible. No existe un administrador central en este escenario ni una garantía común de respuesta. Los mensajes o llamadas no se tratan como una base de datos interoperable.
## 3.2 Modelado del Proceso Actual AS-IS
@figure asis|Proceso actual de búsqueda y coordinación|Elaboración propia a partir del escenario del proyecto. Modelo analítico por validar con participantes; no representa observación cronometrada.

El flujo utiliza actividades y decisiones para representar la coordinación informal del servicio. La formalización detallada debe emplear BPMN 2.0.2 (Object Management Group [OMG], 2013). En un modelo de colaboración, cliente y prestador se representan como participantes separados y sus intercambios como mensajes; los flujos de secuencia permanecen dentro de cada participante. La figura es una síntesis del procedimiento, no un archivo Bizagi validado.
## 3.3 Problemas del Proceso Actual
| Código | Punto crítico | Riesgo | Indicador para validar |
| P1 | Descripción incompleta de la falla | Contacto con especialidad incorrecta | Solicitudes que requieren aclaración / solicitudes observadas |
| P2 | Consulta manual de disponibilidad | Espera y repetición de contactos | Mediana de contactos hasta obtener respuesta |
| P3 | Condiciones no comparables | Decisión basada en datos insuficientes | Propuestas con tarifa y zona informadas / propuestas |
| P4 | Ausencia de confirmación registrada | Confusión sobre quién atenderá | Casos con confirmación identificable / casos |
| P5 | Historial no estructurado | Dificultad para aprender de incidencias | Servicios con resultado registrado / servicios |

Los indicadores se definen como instrumentos del piloto y no como resultados ya obtenidos. El número de diagramas se determina por los procesos y variantes necesarios; producir una cantidad fija de modelos sin correspondencia con el alcance no agrega evidencia. Cada proceso del mapa cuenta con una ficha de procedimiento en el anexo A, desde la cual pueden elaborarse modelos BPMN detallados en Bizagi.
## 3.4 Modelado del Proceso Propuesto TO-BE
@figure tobe|Proceso propuesto de solicitud y atención|Elaboración propia conforme a Marketplace.php y domain/rules.json. La verificación previa del técnico es condición de elegibilidad.

El cliente registra rubro, zona, dirección y descripción. Laravel valida la identidad y los datos, crea la solicitud y calcula candidatos elegibles. Se consideran solo técnicos verificados, disponibles, del rubro y con cobertura en la zona. El servicio genera hasta tres ofertas pendientes simultáneas; cada una vence como máximo a los diez minutos y nunca más allá del límite de disponibilidad de la solicitud.

La primera aceptación válida reserva al técnico, cancela las otras ofertas y deja una propuesta pendiente de confirmación del cliente. Aceptar como técnico no equivale a comenzar el trabajo. El cliente confirma la tarifa de visita; después, únicamente el técnico asignado puede iniciar y finalizar la atención. El cliente puede calificar de 1 a 5 durante las 48 horas siguientes a la finalización. La dirección se oculta al técnico hasta la confirmación de una asignación propia.

Ante rechazo o vencimiento, el sistema busca otros candidatos sin reenviar la misma solicitud al técnico ya descartado. Si no encuentra nuevos elegibles, mantiene la solicitud pendiente hasta completar 24 horas desde su creación. Transcurrido ese plazo pasa a no asignada. Los vencimientos se evalúan con tiempo del servidor y una tarea programada; el navegador no constituye la autoridad temporal del modo API.
### 3.4.1 Reglas de negocio verificables
| Regla | Valor o condición | Evidencia de implementación |
| RN-01 Respuesta | Máximo 10 minutos por oferta | responseMinutes y expires_at |
| RN-02 Simultaneidad | Máximo 3 ofertas pendientes por solicitud | maxSimultaneous y dispatch |
| RN-03 Espera | 24 horas desde creación, sin reiniciar por reasignación | pendingHours y pending_until |
| RN-04 Calificación | Una calificación propia antes de 48 horas | ratingHours y acción rate |
| RN-05 Ponderación | Zona 35 %, tarifa 20 %, calificación 30 %, experiencia 15 % | domain/rules.json |
| RN-06 Desempate actual | Calificación descendente; luego ID ascendente | rank en Python y Matching en PHP |
| RN-07 Integridad | Un técnico reservado no acepta otro servicio incompatible | Disponibilidad y bloqueo transaccional |
| RN-08 Autorización | Rol, propiedad y estado habilitan cada transición | Permissions y Marketplace |

El requisito histórico RF-09 solicita antigüedad como desempate adicional, mientras el código usa ID; la decisión final requiere alineación formal. También RF-24 pide cierre automático sin reseña, pero el estado actual permanece completed y la API rechaza una calificación fuera de plazo. Registrar ambas diferencias evita presentar el TO-BE deseado como cumplimiento total del software.
# CAPÍTULO 4
# ANÁLISIS DE REQUERIMIENTOS DEL SISTEMA
## 4.1 Identificación de Actores del Sistema
El cliente representa a una persona del hogar o a un responsable de MYPE. El técnico independiente ofrece especialidades y cobertura y controla su disponibilidad una vez habilitado. El administrador verifica perfiles, supervisa cuentas y solicitudes y gestiona anuncios. El motor de matching es un componente interno y no un usuario con permisos comerciales. El responsable de operaciones administra el entorno de ejecución fuera de la interfaz del marketplace.
| Operación | Cliente | Técnico | Administrador |
| Crear solicitud | Propia | No | No |
| Confirmar, cancelar o calificar | Propia y estado permitido | No | No |
| Responder oferta | No | Oferta propia vigente | No |
| Iniciar y finalizar atención | No | Asignación propia | No |
| Editar perfil | Propio | Propio, con restricciones | Propio |
| Habilitar técnicos y suspender cuentas | No | No | Sí, con restricciones |
| Publicar anuncios por audiencia | No | No | Sí |

La interfaz presenta solo acciones pertinentes, pero la decisión de autorización pertenece a la API. El registro público admite cliente o técnico; no permite autogenerar una cuenta administradora. La suspensión revoca sesiones y la reactivación exige iniciar sesión nuevamente. Los técnicos no pueden editar su verificación ni modificar condiciones de servicio con ofertas pendientes o atenciones activas.
## 4.2 Requerimientos Funcionales
Se conserva la numeración RF-01 a RF-33 del informe previo. El estado distingue núcleo implementado, implementación parcial, discrepancia y extensión pendiente. La inspección de código no sustituye la aceptación integral de un requerimiento; las pruebas asociadas deben conservar precondiciones, pasos, resultado esperado y evidencia.
@rf

Las mejoras de permisos, suspensión de cuentas, edición del perfil técnico y anuncios se incorporan como extensiones trazables del control de acceso y la administración. No se renumeran los RF históricos ni se amplía silenciosamente su significado. Se proponen RF-34 gestión segura de cuentas, RF-35 condiciones del perfil técnico y RF-36 anuncios segmentados, con las pruebas API y de componentes existentes como evidencia parcial.
### 4.2.1 Historias de usuario prioritarias
| Historia | Necesidad | Criterio de aceptación |
| HU-01 Cliente | Registrar una falla y solicitar atención | Datos válidos crean una solicitud propia; errores no generan solicitudes incompletas |
| HU-02 Técnico | Responder una oportunidad disponible | Solo puede aceptar su oferta vigente; al aceptar se cancelan las restantes |
| HU-03 Cliente | Revisar y confirmar al técnico propuesto | Confirma solo su solicitud en proposed; se conserva la tarifa acordada |
| HU-04 Técnico | Registrar inicio y finalización | Solo el asignado modifica confirmed e in_progress en orden válido |
| HU-05 Cliente | Calificar un servicio recibido | Una reseña propia de 1 a 5 dentro de la ventana; repetición rechazada |
| HU-06 Administrador | Controlar acceso y habilitación | Cliente o técnico reciben 403 al intentar acciones administrativas |

Las historias se refinan con ejemplos concretos antes de comprometer trabajo. Una historia completada exige código, revisión, pruebas pertinentes, actualización documental y evidencia; una interfaz visible sin controles de servidor no cumple la definición de terminado.
## 4.3 Requerimientos no Funcionales
Se mantienen los 14 RNF de origen. Los umbrales son compromisos de evaluación del proyecto y no valores impuestos por ISO. La nomenclatura histórica de usabilidad y portabilidad se conserva para trazabilidad, mientras la evaluación se adapta al modelo de calidad de producto de ISO/IEC 25010:2023 (ISO/IEC, 2023).
@rnf

Para RNF-01 se propone medir latencia extremo a extremo del matching con percentil 95, volumen de candidatos y carga identificados, conservando 3 segundos como referencia del informe. El conflicto con otra fuente que menciona 5 segundos debe aprobarse antes de cerrar el requisito. RNF-12 debe precisar cobertura de líneas y ramas por módulo; el porcentaje de casos aprobados no equivale a cobertura de código.
## 4.4 Casos de Uso del Sistema
Los casos de uso se mantienen como vista de interacción solicitada por la estructura. Su notación se sustenta en UML 2.5.1 (OMG, 2017), que es una especificación primaria. No se les atribuye una validación empírica ni se incluyen acciones ausentes del alcance como si estuvieran disponibles.
@figure casos|Vista de actores y casos de uso principales|Elaboración propia. Se muestran asociaciones actor-función; el detalle de permisos se aplica en la API.
| Caso | Actor y precondición | Flujo principal | Excepción principal |
| CU-01 Acceder | Cuenta activa o registro público permitido | Validar credenciales, emitir sesión y cargar rol | Credenciales inválidas o cuenta suspendida |
| CU-02 Solicitar | Cliente autenticado | Registrar falla y activar matching | Datos incompletos o zona inválida |
| CU-03 Responder | Técnico habilitado con oferta | Consultar, aceptar o rechazar | Oferta vencida o técnico reservado |
| CU-04 Confirmar | Cliente propietario | Revisar propuesta y confirmar | Solicitud ajena o estado incompatible |
| CU-05 Atender | Técnico asignado | Iniciar y completar | Otro técnico intenta actuar |
| CU-06 Calificar | Cliente con servicio completado | Enviar puntuación y actualizar historial | Duplicado, valor inválido o plazo vencido |
| CU-07 Administrar | Administrador activo | Verificar, supervisar y controlar cuentas | Autoadministración insegura o atención activa |

CU-03 es crítico porque varias ofertas pueden coexistir. La postcondición de una aceptación es una sola propuesta registrada y disponibilidad reservada. CU-06 requiere actualizar solicitud y promedio en una transacción para evitar dobles calificaciones. Estas condiciones guían las pruebas de concurrencia pendientes sobre PostgreSQL.
# CAPÍTULO 5
# PLANIFICACIÓN DEL PROYECTO Y PLAN DE CALIDAD
## 5.1 Alcance del Proyecto
El núcleo incluye acceso por roles, registro de solicitudes, matching por rubro y zona, ofertas temporales, confirmación del cliente, ejecución por el técnico asignado, calificación y supervisión administrativa. La verificación se entiende como habilitación administrada por la plataforma; aún debe definirse y auditarse el procedimiento documental de evaluación de identidad y competencia.

Se excluyen del núcleo cobro con pasarela, suscripción, facturación electrónica, logística de repuestos, inventario, aplicación móvil nativa y diagnóstico automático. La agenda horaria, apelaciones formales, evidencias fotográficas, coordinación de varios técnicos, chat y parser LLM son extensiones o brechas documentadas, no logros del MVP. Tampoco se promete atención inmediata en toda zona configurada.
### 5.1.1 Organización del desarrollo con asistencia de IA
Se adopta una organización incremental compatible con Scrum, con revisión humana de cada artefacto. Schwaber y Sutherland (2020) sustentan la inspección, adaptación y responsabilidad del equipo. Para este informe, los apartados de desarrollo se organizan en cuatro fases: base técnica, flujo funcional, permisos y experiencia, y evaluación. Las diez iteraciones del expediente complementario son paquetes de planificación y no actas de sprints ejecutados.

Peng et al. (2023) se utiliza como antecedente para evaluar la asistencia de IA. El flujo propuesto es formular necesidad y criterio de aceptación, aportar contexto verificable, solicitar una propuesta limitada, revisar el cambio, ejecutar pruebas y documentar la decisión. El equipo conserva responsabilidad sobre los requisitos, el código y la aceptación. No se afirma que el artículo defina estas fases ni que haber aportado un documento a una conversación equivalga a entrenar un modelo.
| Hito | Entregable | Condición de paso |
| H1 Análisis | Procesos, alcance y RF/RNF | Revisión de inconsistencias y aceptación del alcance |
| H2 Diseño | Arquitectura, contratos y modelo de datos | Revisión de permisos y transiciones |
| H3 Construcción | Incremento funcional por capas | Pruebas pertinentes y revisión del cambio |
| H4 Calidad | Logs, métricas y defectos | Sin defectos críticos abiertos y brechas declaradas |
| H5 Despliegue de ensayo | Contenedores, migraciones y smoke | Restauración y funcionamiento reproducibles |

La indicación académica de semana 10, semana 12 y semana 13 se trata como hitos relativos al calendario del curso. No se asignan fechas de cumplimiento retroactivas. La puesta en producción corresponde al alcance posterior del capítulo 14 y requiere evidencias propias.
## 5.2 Herramientas Tecnológicas del Proyecto
| Componente | Herramienta observada | Uso |
| Interfaz | React 18 y Vite 5 | Componentes, formularios, landing y paneles |
| API | Laravel 12 y PHP 8.2 o superior | Identidad, permisos, transacciones y estados |
| Ranking | FastAPI y Python | POST /match y validación del contrato |
| Persistencia prevista | PostgreSQL 16 | Entorno integrado definido en Compose |
| Base de ensayo API | SQLite en memoria | Aislamiento de pruebas PHPUnit |
| Pruebas de interfaz y dominio | Vitest y Testing Library | Componentes y lógica JavaScript |
| Pruebas de API y ranking | PHPUnit y pytest | Contratos, reglas, límites y permisos |
| Versiones y entorno | Git, GitHub, VS Code y Docker | Código, revisión y empaquetado |

La selección combina necesidades del dominio, restricciones del laboratorio y activos existentes. Ningún artículo demuestra que esta combinación sea universalmente óptima. El caso Laravel de Bejarano Gavilanes (2022) orienta una alternativa técnica; la inclusión de Python responde al servicio de ranking existente y a la arquitectura académica. Su costo de mantenimiento debe medirse frente al beneficio de aislamiento.
## 5.3 Normas y Estándares de Calidad
| Referencia | Aplicación delimitada | Evidencia del proyecto |
| ISO 9001:2026 | Gestión por procesos y mejora | Mapa, responsables, indicadores y revisión de riesgos |
| ISO/IEC 25010:2023 | Modelo de calidad del producto | RNF y matriz de evaluación del capítulo 13 |
| ISO/IEC/IEEE 29119-3:2021 | Documentación de pruebas | Casos, resultados, incidencias y trazabilidad |
| BPMN 2.0.2 | Descripción de procesos | AS-IS, TO-BE y fichas de procedimiento |
| UML 2.5.1 | Vistas de interacción y estructura | Casos, secuencia y relaciones |
| Scrum Guide 2020 | Organización e inspección del trabajo | Backlog, revisión y criterios de terminado |

Se consultaron las fichas públicas de las normas ISO y las especificaciones abiertas citadas; la aplicación no equivale a auditoría de conformidad. La ficha oficial registra ISO 9001:2026 como edición vigente al corte del informe (ISO, 2026). Las menciones imprecisas a “ISO 290000” o “2007” no se adoptan como normas identificadas: para pruebas se utiliza la referencia verificable 29119-3:2021. SonarQube es una herramienta de análisis y no certifica por sí mismo ISO 9001 ni ISO/IEC 25010.
## 5.4 Plan de Pruebas del Proyecto
El plan prioriza autorización, integridad de asignación, plazos y calificación. Su unidad de registro es el caso con identificador, requisito, riesgo, precondiciones, datos sintéticos, pasos, resultado esperado, resultado observado, versión y evidencia. ISO/IEC/IEEE (2021) orienta la organización documental; los criterios concretos son decisiones del equipo.
| Nivel | Objeto | Técnica | Evidencia requerida |
| Unidad | Fórmula, filtros y permisos | Particiones, límites y fixture compartido | Resultado de suite y datos |
| Integración | API, persistencia y Python | Contratos, errores y fallback | HTTP, estado anterior y posterior |
| Sistema | Flujo de los tres roles | Recorrido completo en navegador | Capturas y trazas de API |
| Seguridad | Rol, propiedad y sesión | Pruebas negativas y abuso de estados | Rechazo y ausencia de modificación |
| Aceptación | Tareas de cliente y técnico | Piloto con participantes locales | Acta, tiempos y observaciones |
| Operación | Contenedor, backup y recuperación | Ensayo de despliegue y restauración | Log, configuración y smoke |

Entrada: requisito revisado, entorno aislado, datos sintéticos y versión identificada. Salida: casos críticos aprobados, defectos clasificados, regresión ejecutada y evidencia revisada. Un bloqueo impide cerrar la prueba; una excepción debe registrar riesgo y aprobación. Se conserva la meta académica de más de 60 pruebas: hay 55 ejecutadas y se proponen ocho casos adicionales, todavía no ejecutados, en el anexo C.
### 5.4.1 Uso controlado de prompts
Prompt propuesto para una historia: «Contexto: TécnicoYa, React, Laravel, FastAPI y PostgreSQL. Implementa únicamente la historia y el criterio adjuntos. Respeta domain/rules.json, permisos por rol y propiedad. Describe cambios, riesgos y casos de prueba. No declares una prueba aprobada sin su salida ni inventes resultados de producción».

Prompt propuesto para revisión: «Contrasta el requisito con código, migración y test. Indica archivo y condición que lo demuestra. Separa implementado, parcial, ausente y no verificado. Revisa límites de 10 minutos, 24 horas y 48 horas y acceso de usuarios ajenos. Propón el menor cambio compatible con el contrato».

Estos prompts son instrumentos para uso futuro. El registro debe conservar entrada, herramienta o modelo usado, propuesta, decisión humana, diff y ejecución. No se presenta una reconstrucción de conversaciones como evidencia histórica de TDD.
## 5.5 Lineamientos de Seguridad Informática
La API valida las entradas, limita solicitudes y comprueba cuenta activa, rol, propiedad y estado. Las contraseñas se almacenan mediante hash; hashing no es cifrado reversible. Los tokens de acceso son revocables y se almacena su hash en la base. El frontend conserva la sesión en sessionStorage, por lo que la prevención de XSS sigue siendo necesaria. Ocultar botones no protege un endpoint.

La dirección se revela al técnico asignado solo tras confirmación. Los registros de prueba usan identidades ficticias y no incluyen secretos. El despliegue debe incorporar HTTPS en el punto de entrada, secretos fuera del repositorio, base de datos sin puerto público, registros sanitizados y respaldo con restauración ensayada. La protección perimetral depende del entorno elegido; no se declara instalada por existir un Dockerfile.
| Riesgo | Prioridad | Tratamiento y verificación |
| R01 Acceso a solicitudes ajenas | Alta | Matriz de permisos y pruebas negativas de API |
| R02 Doble asignación o reseña | Alta | Transacciones y prueba concurrente en PostgreSQL |
| R03 Divergencia JS, PHP y Python | Alta | Reglas centralizadas y fixture compartido |
| R04 Exposición de dirección o credenciales | Alta | Minimización, TLS y revisión de respuestas/logs |
| R05 Ausencia de técnicos | Media | Espera controlada, vencimiento y mensaje claro |
| R06 Sesgo de ranking y exclusión de nuevos perfiles | Media | Medir exposición, revisar pesos y explicar criterios |
| R07 Pérdida de base de datos | Alta | Copia, restauración y prueba de integridad |
| R08 Cambio generado por IA sin revisión | Alta | Revisión humana, tests y trazabilidad del cambio |
# CAPÍTULO 6
# DISEÑO DEL SISTEMA
## 6.1 Arquitectura Conceptual del Sistema
La presentación captura acciones y muestra estados; la API gobierna la identidad y el ciclo de vida; la base conserva la información transaccional; el servicio Python calcula un ranking a partir de datos suministrados por Laravel. Esta separación permite probar el cálculo sin conceder al microservicio autoridad sobre cuentas o solicitudes.
@figure arquitectura|Arquitectura conceptual y límites de confianza|Elaboración propia conforme al monorepo. La demo local es un modo separado de la API.

Laravel calcula también un resultado local y verifica la respuesta Python. Si el servicio no responde, devuelve datos malformados o utiliza reglas incompatibles, utiliza el fallback PHP. En el estado actual existe trabajo duplicado de cálculo; debe medirse antes de atribuir ventajas de rendimiento al microservicio. La función JavaScript sirve a la demostración, no valida transacciones reales.
## 6.2 Modelo UML del Sistema
El modelo lógico relaciona Usuario con PerfilTécnico, Solicitud y Token; Solicitud con Oferta y una calificación opcional; Administrador con eventos de acceso y anuncios. No se crea una entidad física ratings independiente: la calificación actual está en requests y el promedio agregado en technicians. Separar la vista conceptual de la persistencia evita documentar tablas inexistentes.
@figure secuencia|Secuencia de aceptación y confirmación|Elaboración propia en vista simplificada de secuencia UML. La reserva y cancelación de ofertas se realizan en la transacción de aceptación.

Los estados permitidos son searching, pending_availability, proposed, confirmed, in_progress, completed, rated, cancelled y unassigned. Los dos primeros pueden alternarse mientras exista ventana de búsqueda. Una solicitud confirmada admite inicio del técnico o cancelación del cliente antes de ejecución. La finalización libera disponibilidad. Una calificación vencida se rechaza sin crear una puntuación ficticia.
| Transición | Actor | Precondición | Efecto |
| searching a proposed | Técnico | Oferta propia vigente y disponibilidad | Reserva y cancelación de otras ofertas |
| proposed a confirmed | Cliente | Propiedad de solicitud | Confirmación de propuesta |
| confirmed a in_progress | Técnico | Asignación propia | Inicio de atención |
| in_progress a completed | Técnico | Asignación propia | Plazo de calificación y liberación |
| completed a rated | Cliente | Propiedad y plazo válido | Promedio y reseña únicos |
| Búsqueda a unassigned | Sistema | Vencimiento de 24 horas | Cierre de búsqueda sin asignación |
## 6.3 Diseño de Interfaces de Usuario
La landing presenta los tres rubros con una secuencia visual vinculada al desplazamiento. El acceso a cuenta se separa del contenido promocional. La pantalla de autenticación ofrece inicio de sesión y registro; el registro administrativo no forma parte del formulario público. Tras autenticarse, la aplicación muestra las acciones del rol.
@figure interfaz|Organización funcional de las pantallas|Esquema propio de navegación y composición; no es captura de ejecución ni prototipo Figma.

El panel cliente concentra solicitud, propuesta, estados e historial. El panel técnico muestra ofertas, atención asignada, disponibilidad y condiciones de servicio. Administración controla habilitación, cuentas, cobertura y anuncios. Los mensajes de error deben explicar cómo corregir la entrada y preservar el contenido escrito cuando sea posible. La prueba de accesibilidad comprende teclado, foco, contraste, etiquetas y preferencia de movimiento reducido.

La experiencia audiovisual no debe retrasar el acceso al servicio ni impedir la lectura. Se consideran carga diferida de secuencias, pausa fuera de pantalla y respeto de movimiento reducido. Las pruebas de componentes y desplazamiento verifican parte de esa lógica, pero no reemplazan la inspección en dispositivos y navegadores reales.
## 6.4 Diseño de Base de Datos
@figure datos|Relaciones principales de persistencia|Elaboración propia a partir de las tres migraciones Laravel existentes. Las cardinalidades reflejan el diseño de claves y relaciones.
@schema

users almacena identidad y rol; technicians vincula un único perfil a un usuario; requests pertenece a un cliente y puede referir al técnico asignado; offers registra cada invitación a un técnico. api_tokens contiene sesiones revocables; access_events registra acciones sobre cuentas; announcements guarda comunicaciones segmentadas. La integridad de una reseña y el promedio se mantiene mediante la acción transaccional de calificación.

Las migraciones declaran campos JSON para listas y eventos; la aplicación serializa y deserializa sus valores. La representación efectiva depende del motor: las pruebas SQLite no demuestran el comportamiento de PostgreSQL. Una migración a JSONB o a tablas normalizadas debe justificarse y probarse. Las migraciones son la fuente ejecutable; database/init.sql es una referencia anterior y puede carecer de incorporaciones recientes. La restauración y las restricciones deben validarse en PostgreSQL, porque el comportamiento de tipos y bloqueo difiere de SQLite.
# CAPÍTULO 7
# ARQUITECTURA TECNOLÓGICA DEL SISTEMA
## 7.1 Tecnologías del Frontend
frontend/web contiene App.jsx, Auth.jsx, Marketplace.jsx y componentes de cuenta, anuncios y perfil técnico. React organiza estados y vistas; Vite prepara el entorno y el build. La navegación utiliza fragmentos de URL y estado de la aplicación; no se atribuye React Router al proyecto. La llamada a /api se centraliza en marketplace-api.js, que añade el token y gestiona errores y expiración de sesión.

El modo demo usa almacenamiento local y datos ficticios; el modo cuenta comunica con Laravel. La existencia de una demo funcional no demuestra persistencia central, autorización de servidor o atención por técnicos reales. Las pruebas Vitest separan lógica de dominio, formularios, anuncios, permisos y experiencia visual.
## 7.2 Tecnologías del Backend
backend/api implementa rutas HTTP, controladores, middleware, servicios y migraciones. AuthController gestiona registro, login y logout. ApiToken valida la sesión. MarketplaceController recibe acciones; Permissions aplica autorización por rol; Marketplace valida propiedad, transiciones y transacciones. Matching comunica con FastAPI y comprueba compatibilidad del ranking.
| Endpoint | Acceso | Contrato principal |
| GET /api/health | Público | Estado básico del servicio |
| POST /api/register | Limitado por frecuencia | Cuenta cliente o técnico; sin rol admin público |
| POST /api/login | Limitado por frecuencia | Credenciales y sesión revocable |
| POST /api/logout | Token | Revocación de la sesión |
| GET /api/state | Token | Estado filtrado por actor |
| POST /api/actions/{action} | Token y permiso | Acción autorizada sobre recurso y estado |
| POST /match en Python | Servicio interno previsto | Ranking y versión de reglas |

La integración de Python tiene timeout total de dos segundos y de conexión de un segundo según Matching.php. El resultado remoto se compara con el cálculo PHP en IDs, versión y puntajes. Esta defensa favorece coherencia, aunque reduce el beneficio de descargar cómputo al microservicio.
### 7.2.1 Fórmula del ranking
El puntaje es S = 0,35P + 0,20T + 0,30C + 0,15E. P vale 1 en la zona principal y 0,5 en una zona adicional cubierta. T = (tarifa máxima - tarifa del técnico) / (tarifa máxima - tarifa mínima), entre elegibles; cuando todas las tarifas son iguales T vale 1. C es el promedio entre 5. E es la experiencia entre 10 años, limitada a 1. Se redondea a seis decimales y se ordena por puntaje, calificación e identificador.

La cercanía es una aproximación categórica; no representa kilómetros, GPS ni rutas. Un perfil nuevo tiene cero reseñas y promedio cero. Esa decisión puede desfavorecer a nuevos participantes y debe evaluarse. El aporte de Aveklouris et al. (2021) justifica examinar tiempos de espera y calidad de asignación; la fórmula exacta es una decisión local, no una implementación de su optimización matemática.
## 7.3 Base de Datos del Sistema
La infraestructura declara postgres:16-alpine y un volumen persistente. Laravel se conecta con variables DB_CONNECTION, DB_HOST, DB_PORT, DB_NAME, DB_USER y DB_PASSWORD según la configuración del proyecto. No se incrustan contraseñas en el documento. Las tres migraciones definen núcleo, control de acceso y anuncios. Las pruebas de esta revisión usan exclusivamente SQLite en memoria configurado por phpunit.xml.

Se requieren migraciones y restauración sobre una copia aislada antes del despliegue. Deben probarse claves foráneas, unicidad, actualización de promedio y aceptación concurrente. Ejecutar migrate:fresh o semillas sobre una base con datos reales no es un procedimiento aceptable de actualización.
## 7.4 Infraestructura de Desarrollo
El trabajo se realiza en Visual Studio Code y un monorepo con frontend/web, backend/api, python/api, database, domain, infrastructure y docs. Cada módulo posee manifiesto, Dockerfile y .env.example para adaptarse al laboratorio DevOps. Node y npm gestionan frontend; Composer gestiona PHP; pip y requirements.txt gestionan Python. Los locks y manifiestos identifican las dependencias que deben revisarse por versión.

El servidor de ensayo debe separar entrada web, API, motor de ranking y persistencia. El dimensionamiento no puede deducirse de un artículo sobre otro producto o de una etiqueta de procesador. Se propone iniciar con carga base de 20 usuarios y aumentar hasta 200 en un entorno identificado, midiendo p50, p95, errores, CPU, RAM y saturación. La selección de recursos se realizará con esos resultados y con el costo de operación.
# CAPÍTULO 8
# DESARROLLO DEL SISTEMA
## 8.1 Fase 1 Configuración Inicial del Proyecto
La primera fase comprende estructura de carpetas, manifiestos, configuración de entorno, esquema inicial, reglas compartidas y repositorio. Es una organización retrospectiva de artefactos observados, no un acta de sprint. El commit local identificado es 86862f5, del 22 de septiembre de 2026. Existen modificaciones posteriores sin registrar en un nuevo commit al corte, por lo que se usa un manifiesto de hashes para identificar el árbol ensayado.

El entregable de esta fase es un conjunto de módulos reconocibles por el laboratorio. domain/rules.json establece la fuente de reglas y scripts/sync-rules.py sincroniza las copias. El criterio de salida es instalar dependencias, validar la estructura y comprobar coherencia de reglas. No se afirma un despliegue aprobado solo porque los archivos estén presentes.
## 8.2 Fase 2 Desarrollo de Funcionalidades Básicas
La segunda fase agrupa identidad, creación de solicitudes y cálculo del ranking. La interfaz captura los datos y Laravel controla validación y persistencia. Python ofrece /match; PHP conserva una alternativa ante indisponibilidad. La fixture compartida permite contrastar IDs y puntajes entre implementaciones y detectar divergencia de reglas.

El ciclo completo exige que una solicitud no se convierta en atención sin respuesta del técnico y confirmación del cliente. Por ello, las acciones y estados se desarrollan como una secuencia controlada. Los formularios deben informar errores y la API rechazar transiciones inválidas aunque el usuario altere la petición manualmente.
## 8.3 Fase 3 Implementación de Módulos Funcionales
Los módulos de cliente, técnico y administrador incorporan seguimiento, ofertas, atención, calificación y supervisión. Las mejoras observadas incluyen suspensión de cuentas con revocación de sesiones, protección de administradores, restricciones de edición del perfil técnico, ocultamiento de dirección y anuncios por audiencia. La verificación técnica se concentra en que ninguna acción pueda ejecutarse solo por conocer el identificador de un recurso ajeno.
| Incremento observado | Archivos o componentes | Validación disponible |
| Acceso y cuenta | Auth, AccountPanel, ApiToken y Permissions | Pruebas negativas y revocación |
| Perfil técnico | TechnicianProfile y acción technician-profile | Edición propia y bloqueo por atención |
| Flujo de servicio | Marketplace y Matching | Ciclo, plazos y fallback |
| Anuncios | Announcements y servicio homónimo | Audiencia, validación y administración |
| Landing audiovisual | Componentes de video y scroll | Pruebas de lógica visual y movimiento |

La existencia de estas funciones no cierra automáticamente RF-03, RF-05, RF-20, RF-21, RF-26, RF-29 o RF-32. Esas funciones requieren implementaciones o validaciones adicionales que se conservan en el backlog. Se evita equiparar anuncios internos con notificaciones push, SMS o WhatsApp.
## 8.4 Fases Posteriores y Control de Cambios
La siguiente fase prioriza evaluación integrada, concurrencia, SonarQube, despliegue de ensayo y aceptación local antes de ampliar negocio. Las propuestas de asistente determinista, parser LLM y pagos permanecen condicionadas a su aprobación. El ranking vigente es determinista y no requiere un LLM para asignar técnicos.

Cada cambio seguirá un ciclo de criterio de aceptación, prueba que exponga el fallo cuando corresponda, implementación mínima y refactorización. Solo una ejecución conservada de RED y GREEN acredita ese ciclo TDD. Para funciones preexistentes sin historial de fallo previo, las pruebas agregadas son de caracterización o regresión. Esta distinción preserva la evidencia de construcción sin fabricar una secuencia histórica.

El control de asistencia de IA registra propósito, archivos autorizados, reglas, propuesta y revisión. El equipo verifica que no se introduzcan permisos, datos o servicios ajenos al alcance. El incremento se considera terminado cuando pasa revisión, pruebas relevantes, actualización de contratos y documentación, y cuando existe una evidencia de entrega reproducible.
# CAPÍTULO 9
# CONTROL DE VERSIONES Y GESTIÓN DEL REPOSITORIO
## 9.1 Repositorio del Proyecto
El repositorio configurado en origin es https://github.com/James091104/Software-TecnicoYa-Huancayo.git. La rama local observada es main. La lectura del remoto configurado no acredita que todos los archivos locales hayan sido publicados. El monorepo permite relacionar frontend, API, Python, reglas y documentación bajo una misma versión de referencia.

Se conservan fuentes académicas, matrices y evidencias en docs/documentacion. Las carpetas de documentación histórica no sustituyen el control de versiones del código. Los secretos y datos personales deben quedar fuera del repositorio; los archivos .env.example describen variables sin credenciales operativas.
## 9.2 Estrategia de Control de Versiones
Se propone registrar cambios pequeños por necesidad verificable, con mensaje que describa problema y resultado. Antes de consolidar un incremento se revisan diff, pruebas, contratos y documentación. El pull request debe incluir alcance, riesgos y evidencia, y no afirmar validaciones no ejecutadas. Esta estrategia se prescribe para próximas entregas; no se atribuye un historial de revisiones inexistente.
## 9.3 Gestión de Ramas del Proyecto
La evidencia local muestra main; no se constató un flujo ya ejecutado con develop y ramas de funcionalidad. Para trabajo futuro se propone una rama corta por cambio, revisión y retorno a main mediante integración controlada. Los cambios en reglas compartidas deben incluir sincronización y prueba en los tres lenguajes. La etiqueta de entrega se crea después de verificar el conjunto integrado, no antes.
## 9.4 Registro de Commits Relevantes
| Identificador | Fecha | Descripción | Alcance de la evidencia |
| 86862f5 | 22/09/2026 | Commit inicial del nuevo proyecto | Commit presente en el historial local |
| Árbol de trabajo del 30/09/2026 | 30/09/2026 | Cambios posteriores y documentación | Identificado por manifiesto de hashes; no es un commit |

El historial disponible contiene el commit inicial y el árbol local conserva cambios posteriores. La evidencia de esta revisión incluye rutas y SHA-256 del código de prueba y los reportes. Registrar un commit posterior permitirá repetir el ensayo con una referencia más simple. Las actas de revisión, responsable y aceptación permanecen como evidencias a incorporar por el equipo.
# CAPÍTULO 10
# DOCKERIZACIÓN Y DESPLIEGUE DE MÓDULOS
## 10.1 Introducción a Docker en el Proyecto
Los contenedores empaquetan dependencias y permiten describir un entorno común. El proyecto dispone de Dockerfiles por módulo y de infrastructure/docker-compose.yml. Estos archivos constituyen configuración disponible; en la verificación del 30/09/2026 Docker no pudo conectarse al motor local DockerDesktopLinuxEngine. Por tanto, este capítulo documenta diseño e instrucciones reproducibles, no un despliegue validado.

La entrega por módulos cumple la organización del laboratorio: React, Laravel y FastAPI son servicios independientes y PostgreSQL conserva los datos. La base y el ranking no deben publicarse directamente a Internet. Un proxy con TLS y controles de red se configura en el entorno de implantación; no está demostrado por la configuración local.
## 10.2 Dockerización del Backend
El Dockerfile de Laravel parte de php:8.2-cli-bookworm, instala pdo_pgsql y dependencias con Composer, copia la aplicación y ejecuta como www-data. El entrypoint inicia schedule:work y artisan serve, y gestiona señales de terminación. El scheduler es necesario para revisar vencimientos sin depender de que un navegador permanezca abierto.

El arranque actual utiliza el servidor de desarrollo de Artisan. Antes de producción debe evaluarse un servidor de aplicaciones adecuado, proxy y supervisión de procesos. La prueba de contenedor debe verificar permisos de storage, disponibilidad de la API, funcionamiento del scheduler, salida ante fallo y logs sin secretos. La imagen Python usa Python 3.12 y Uvicorn; su prueba debe comprobar health y contrato /match.
## 10.3 Dockerización del Frontend
El frontend utiliza una construcción multietapa con Node 22: npm ci y npm run build generan dist; una segunda etapa conserva los recursos y server.mjs. El servidor sirve el sitio y canaliza /api hacia el backend mediante API_URL. El navegador no debe conocer el nombre interno de Docker de la API; la comunicación se resuelve por el servidor web.

La validación debe comprobar que los recursos audiovisuales se sirvan con rutas correctas, que la carga no bloquee el formulario y que la sesión funcione con el proxy. La imagen construida debe corresponder al mismo código documentado y probado. No se copia una configuración .env con secretos a una imagen pública.
## 10.4 Orquestación con Docker Compose
| Servicio | Configuración disponible | Verificación pendiente |
| database | PostgreSQL 16, volumen y healthcheck | Persistencia, migraciones y restauración |
| matching | Build de python/api, puerto interno 8000 | Contrato, timeout y fallback |
| api | Build de backend/api, puerto interno 3000 | Health, identidad, scheduler y transacciones |
| web | Build de frontend/web, puerto publicado 5173 | Acceso, proxy y recorrido de roles |

El Compose exige APP_KEY y DB_PASSWORD mediante variables de entorno. La base posee healthcheck; la API depende de su estado saludable. La API y matching no publican puertos al host en este archivo. El diseño requiere además comprobar arranque y recuperación ante indisponibilidad del ranking y del backend.
```text
docker compose -f infrastructure/docker-compose.yml config --quiet
docker compose -f infrastructure/docker-compose.yml build
docker compose -f infrastructure/docker-compose.yml up -d
docker compose -f infrastructure/docker-compose.yml exec api php artisan migrate --force
docker compose -f infrastructure/docker-compose.yml ps
```
La secuencia se ejecuta en un entorno de ensayo con variables previamente configuradas y sin datos reales. Antes de migrar una base existente se requiere respaldo y revisión. El cierre exige registrar salida de build, estado de servicios, versión, migración, smoke del flujo y restauración. No se exponen claves en capturas ni se considera exitoso un despliegue solo por recibir una página HTML.
# CAPÍTULO 11
# ESTRATEGIA DE PRUEBAS DE SOFTWARE
## 11.1 Enfoque de Pruebas del Proyecto
El enfoque es basado en riesgo y trazabilidad. Se priorizan pérdida de integridad, acceso ajeno, asignaciones duplicadas, vencimientos y calificaciones. Las pruebas unitarias permiten comprobar reglas; la integración controla el contrato y la persistencia; las pruebas de sistema y aceptación evalúan el recorrido del usuario. La estrategia complementa el plan del capítulo 5 con selección de datos, ejecución y tratamiento de resultados.

TDD se adopta para nuevos cambios cuando se conserva una prueba fallida previa y su posterior aprobación. No se infiere TDD de la mera existencia de archivos test. La asistencia de IA puede proponer casos o código, pero el oráculo procede de reglas y criterios aceptados. Una respuesta del modelo no constituye evidencia de ejecución.
## 11.2 Niveles de Pruebas Aplicados
| Nivel | Evidencia actual | Límite |
| Lógica y componentes JavaScript | 33 pruebas Vitest | jsdom y lógica local; no E2E productivo |
| API y persistencia de ensayo | 19 pruebas PHPUnit | SQLite en memoria; no comportamiento concurrente PostgreSQL |
| Ranking y contrato Python | 3 pruebas pytest | Fixture y casos acotados; no carga real |
| Sistema integrado | Plan de recorrido de roles | Pendiente de ejecución sobre servicios reales |
| Aceptación y operación | Criterios e instrumentos definidos | Pendientes de participantes y entorno |

Los resultados de los tres primeros niveles se obtuvieron el 30/09/2026 y se detallan en el capítulo 13. Su suma permite contar pruebas ejecutadas, pero no demuestra que todos los RF/RNF estén cubiertos. Se conserva por separado el catálogo de 33 RF y 14 RNF del plan original.
## 11.3 Tipos de Pruebas Ejecutadas
La suite verifica autorización, sesión, propiedades del perfil, restricciones administrativas, ciclo de atención, plazos, fallback, validación de anuncios, formularios y comportamiento de componentes visuales. Se utilizan fixtures y datos sintéticos. Las pruebas negativas comprueban rechazo de acciones incompatibles y no solo el caso exitoso.

Para los plazos se requiere verificar instantes anterior, exacto y posterior al límite; para rating, extremos 1 y 5, fuera de rango, duplicado y usuario ajeno; para matching, cero elegibles, empate, tarifas iguales, perfiles no verificados y zonas fuera de cobertura. Los casos existentes no se amplían verbalmente a todas estas combinaciones: las no implementadas quedan como pendientes explícitos.

No se ejecutaron en esta revisión pruebas de penetración, carga de 200 usuarios, continuidad mensual, restauración productiva o evaluación SUS. Tampoco se informa cobertura global de frontend y Laravel. La revisión de evidencia debe evitar convertir una advertencia de dependencia en un fallo de negocio sin reproducir su impacto.
## 11.4 Plan de Ejecución de Pruebas
| Momento | Actividad | Responsable por función | Registro |
| Antes del cambio | Revisar criterio y riesgo; fijar fixture | Producto y desarrollo | Historia y caso |
| Durante construcción | Unidad, integración y negativas | Desarrollo | Salida y commit o hash |
| Antes de integrar | Regresión pertinente y revisión | Revisor técnico | Informe y defectos |
| Antes de entregar | Sistema, accesibilidad y despliegue | Calidad y operaciones | Acta y logs |
| Durante piloto | Aceptación, tiempos y percepción | Calidad y participantes | Datos anonimizados |

Las personas responsables y fechas concretas se asignan en la planificación del equipo. Para cada ejecución se registra entorno y versión; si un caso falla se abre defecto con severidad, pasos y resultado observado. Después de corregir se repite el caso y la regresión pertinente. El criterio de salida no admite defectos críticos abiertos ni una medición pendiente presentada como aprobada.
# CAPÍTULO 12
# AUTOMATIZACIÓN DE PRUEBAS
## 12.1 Herramientas de Automatización
Vitest ejecuta las pruebas JavaScript y React; Testing Library permite interactuar con componentes en un entorno simulado. PHPUnit ejecuta la suite Feature de Laravel. pytest y TestClient verifican el ranking y el contrato FastAPI; pytest-cov registra cobertura de app.py. Las herramientas indicadas corresponden a los manifiestos actuales, no a los ejemplos Cypress y Jest de la versión anterior del informe.

Los reportes se guardan en JSON o JUnit XML para conservar nombres y resultados por caso. La evidencia incluye SHA-256 y el árbol de trabajo al corte. Estos formatos permiten incorporar resultados a integración continua más adelante, sin afirmar que el pipeline remoto ya se ejecutó.
## 12.2 Configuración del Entorno de Pruebas
Laravel usa APP_ENV=testing y DB_DATABASE=:memory: con SQLite, tal como fija phpunit.xml. Esto evita operar sobre solicitudes reales. Python requiere las versiones del requirements.txt; frontend utiliza package-lock.json. Los datos del ensayo no representan técnicos contratables.
```text
cd frontend/web
npm ci
npm test -- --reporter=json --outputFile=vitest.json

cd backend/api
composer install
php artisan test --log-junit=phpunit.xml

cd python/api
python -m pytest -q --junitxml=pytest.xml --cov=app --cov-report=json
```
Cada bloque parte de la raíz del repositorio antes de entrar al módulo correspondiente. En esta revisión se usaron runtimes locales disponibles y una ruta de dependencias Python aislada. La ejecución reproducible debe documentar versiones y no sustituir el entorno de pruebas por credenciales de producción.
## 12.3 Scripts de Pruebas Automatizadas
El ejemplo siguiente reproduce la intención del caso real test_shared_fixture: comparar orden e igualdad de puntajes con un resultado esperado independiente guardado en matching-fixture.json. No basta con comparar una función consigo misma.
```python
def test_shared_fixture():
    f = json.loads(Path(__file__).with_name('matching-fixture.json').read_text())
    result = rank(MatchRequest(**f['request'], technicians=f['technicians']))
    assert [t['id'] for t in result] == f['expectedIds']
    assert [t['score'] for t in result] == f['expectedScores']
```
En Laravel, permission_matrix_denies_every_other_role_action recorre acciones no autorizadas; authenticated_lifecycle_and_rating verifica el flujo autenticado; pending_offers_and_assigned_work_lock_service_terms comprueba que las condiciones de un técnico no cambien con compromisos activos. Los nombres completos y resultados se conservan en el anexo B.

En frontend, las pruebas de acceso, anuncios, perfil técnico y formularios verifican interacciones y restricciones visibles. Las pruebas de video y scroll controlan aspectos de carga y animación. Su ambiente simulado no mide nitidez percibida, fluidez en hardware real ni accesibilidad completa.
## 12.4 Ejecución Automática de Pruebas
El repositorio contiene una inclusión de pipeline GitLab del laboratorio, mientras origin apunta a GitHub. La presencia de .gitlab-ci.yml no ejecuta por sí sola GitLab CI sobre GitHub. Se debe confirmar el proyecto de laboratorio, permisos del include y mecanismo de integración antes de afirmar automatización remota.

La secuencia propuesta de pipeline es instalar dependencias, verificar reglas compartidas, ejecutar suites, generar reportes, construir imágenes y desplegar en QA con smoke. Una etapa fallida debe bloquear la siguiente. El análisis SonarQube importará los reportes compatibles y conservará versión del analizador, perfil de calidad, exclusiones y commit. El sistema actual permite ejecución local de suites; la evidencia de pipeline queda pendiente.
# CAPÍTULO 13
# MÉTRICAS DE CALIDAD
## 13.1 Ejecución de Casos de Pruebas
La ejecución del 30/09/2026 obtuvo 55 pruebas aprobadas y cero pruebas fallidas: 33 Vitest, 19 PHPUnit y 3 pytest. PHPUnit reportó 157 aserciones; las aserciones no se suman como casos adicionales. La identidad del software es el árbol local basado en 86862f5 con modificaciones posteriores, registrado mediante manifiesto de hashes. No corresponde atribuir todos los resultados exclusivamente al commit inicial.
@metrics

La relación de nombres de los 55 casos está en el anexo B. El resultado observado es local y acotado a los datos y entornos de prueba. Una tasa de aprobación de 100 % no demuestra ausencia de defectos, cumplimiento de 33 RF ni aceptación de 14 RNF. La meta de más de 60 casos todavía no se cumple: el anexo C propone ocho casos adicionales que elevarían el inventario a 63, pero su ejecución no forma parte de estos resultados.
## 13.2 Registro de Defectos
La suite ejecutada no reportó casos fallidos. La revisión documental y de configuración identifica brechas que requieren seguimiento. Se distinguen defectos reproducidos, discrepancias de requisito y bloqueos de entorno para no inflar una métrica de defectos del software con categorías diferentes.
| ID | Hallazgo | Tipo y prioridad | Acción y estado |
| D01 | RF-09 pide antigüedad; código usa ID al final del desempate | Discrepancia funcional, media | Acordar regla, actualizar contrato y probar; abierta |
| D02 | RF-24 pide cierre sin reseña; estado permanece completed | Discrepancia funcional, media | Definir estado de cierre y transición; abierta |
| D03 | Docker no conecta al motor local | Bloqueo de entorno, alta para despliegue | Iniciar/configurar motor y repetir ensayo; pendiente |
| D04 | No existe análisis SonarQube verificable | Brecha de evidencia, alta para evaluación | Ejecutar línea base y registrar medidas; pendiente |
| D05 | No hay validación concurrente sobre PostgreSQL | Riesgo de integridad, alta | Ejecutar carreras de aceptación y calificación; pendiente |
| D06 | pytest emite advertencia de deprecación de BlockingPortal | Compatibilidad de dependencia, baja | Revisar versiones compatibles y repetir suite; pendiente |

La severidad es una clasificación de revisión, no una etiqueta emitida por SonarQube. No se calcula tasa de defectos por KLOC con este registro porque faltan universo comparable, definición y resultados de análisis. Un cambio correctivo requiere evidencia antes/después sobre el mismo caso.
## 13.3 Métricas de Calidad del Software
La tasa de aprobación es aprobadas / ejecutadas × 100 = 55 / 55 × 100 = 100 %. La cobertura medida es 40 sentencias ejecutadas de 40 instrumentadas en python/api/app.py. No se midieron ramas en ese reporte ni cobertura del conjunto Laravel/React. El resultado no demuestra cumplimiento de RNF-12 en todos los módulos críticos.

Las métricas de latencia, carga, disponibilidad y satisfacción permanecen no medidas. Se propone registrar p50 y p95 por operación, porcentaje de errores HTTP y tasa de aceptación por zona. La disponibilidad exige una ventana de observación real; una prueba local breve no acredita 99 % mensual. La distribución de exposición y aceptación del ranking debe separarse de la rapidez del servidor.
### 13.3.1 Línea base y comparación SonarQube
SonarSource (s. f.) documenta métricas de calidad de código, como cobertura, duplicación y complejidad. Para TécnicoYa se requiere un análisis reproducible por versión y lenguaje, con perfil, exclusiones y resultados guardados. No existe al corte una línea base SonarQube ni una medición posterior; por tanto, la tabla siguiente define el registro pendiente y no expresa mejoras alcanzadas.
| Medida | Antes | Después | Condición de comparación |
| Incidencias por tipo y severidad | No medido | No medido | Mismo perfil y versión de analizador |
| Security hotspots revisados | No medido | No medido | Revisión humana registrada |
| Cobertura importada por módulo | No medido | No medido | Reportes y alcance equivalentes |
| Duplicación de líneas | No medido | No medido | Mismas exclusiones y código comparable |
| Complejidad y mantenibilidad | No medido | No medido | Identificar archivos y cambio correctivo |
| Estado del quality gate | No evaluado | No evaluado | Conservar condiciones configuradas |

El procedimiento consiste en congelar una versión A, ejecutar suites y análisis, clasificar hallazgos, corregir cambios priorizados y analizar una versión B con la misma configuración. Para medidas donde menor es mejor, la reducción relativa será (A - B) / A × 100 cuando A sea mayor que cero. Si la base es cero se informa diferencia absoluta. Para cobertura se informa diferencia en puntos porcentuales. No se alteran exclusiones para simular mejora.
## 13.4 Evaluación de Calidad basada en Estándares
El modelo de ISO/IEC 25010:2023 ofrece una referencia para evaluar calidad del producto; las características se contrastan con evidencia de TécnicoYa, sin equiparar una métrica aislada con conformidad completa (ISO/IEC, 2023). ISO 9001 orienta la gestión y mejora de procesos, mientras 29119-3 organiza los registros de pruebas. Son propósitos diferentes.
| Dimensión de evaluación | Evidencia disponible | Evaluación al corte |
| Adecuación funcional | Flujo, reglas y pruebas | Parcial; RF históricos aún pendientes |
| Eficiencia de desempeño | Fórmula y arquitectura identificadas | Carga y p95 no medidos |
| Compatibilidad | Contratos internos y fallback | Interoperación completa por ensayar |
| Capacidad de interacción | Formularios y pruebas de componentes | Piloto y accesibilidad manual pendientes |
| Fiabilidad | Control de estados y fallback | Recuperación y continuidad pendientes |
| Seguridad | Pruebas de rol, propiedad y sesión | Evidencia parcial; auditoría integral pendiente |
| Mantenibilidad | Módulos, fixtures y suites | SonarQube y cobertura global pendientes |
| Flexibilidad | Contenedores y configuración | Despliegue reproducible no verificado |
| Seguridad operacional | Límites del producto y atención por técnicos | Validación de riesgos de uso pendiente |

La evidencia disponible es parcial. SonarQube, despliegue, concurrencia y aceptación local siguen pendientes de evaluación.
# REFERENCIAS
@references
# ANEXOS
## Anexo A Fichas de procedimientos por proceso
Cada ficha resume entrada, secuencia, salida y control. Su finalidad es preparar el detalle BPMN en Bizagi y mantener correspondencia con el mapa del capítulo 2. No se declara la existencia de archivos .bpm validados ni se asignan aprobaciones pendientes.
@procedures
## Anexo B Inventario de pruebas ejecutadas
Los identificadores E01 a E55 son localizadores de este informe. Los nombres originales permiten localizar cada prueba en JSON o JUnit XML. Todas las filas corresponden a la ejecución del 30/09/2026 y estado aprobado. La evidencia original se conserva junto al informe en la carpeta evidencias-2026-09-30.
@tests
## Anexo C Casos adicionales propuestos
Los siguientes ocho casos están diseñados y no ejecutados. Se proponen para cubrir riesgos distintos y superar el mínimo académico sin confundir aserciones con pruebas. Su aprobación solo podrá registrarse después de una ejecución con evidencia.
| ID | Precondición y acción | Resultado esperado |
| N01 | PostgreSQL; dos técnicos aceptan simultáneamente la misma solicitud | Solo una propuesta persiste; la otra operación se rechaza sin doble reserva |
| N02 | PostgreSQL; un técnico acepta simultáneamente dos solicitudes | Solo una asignación válida; disponibilidad coherente |
| N03 | Cliente propietario envía dos calificaciones simultáneas | Una reseña y una actualización de promedio |
| N04 | Reiniciar API y scheduler con ofertas vencidas durante la caída | Vencimientos y reasignación se procesan sin prolongar 24 horas |
| N05 | Interrumpir Python y ejecutar solicitud real mediante API | Fallback mantiene orden y puntajes del fixture y registra el fallo |
| N06 | Crear backup de QA, restaurar en base vacía y comparar relaciones | Conteos, claves y recorrido del servicio íntegros |
| N07 | Recorrer con teclado registro, solicitud y confirmación en navegador real | Foco visible, orden lógico y mensajes accesibles |
| N08 | Ejecutar flujo E2E cliente, técnico y admin con API y PostgreSQL | Estado persistente, permisos y dirección revelada solo al confirmar |
## Anexo D Fuentes y trazabilidad del avance
@sources

Los resultados bibliográficos respaldan decisiones y riesgos; los logs respaldan únicamente las ejecuciones que registran. Las referencias académicas no prueban el rendimiento local. Los datos de producción, actas de aceptación, mediciones SonarQube y aprobación de cambios de alcance se incorporarán cuando existan.
