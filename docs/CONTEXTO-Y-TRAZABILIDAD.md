# Contexto y trazabilidad académica

## Contexto confirmado por el usuario

Proyecto central de Ingeniería de Software y Pruebas y Calidad de Software, Ingeniería de Sistemas e Informática, Universidad Continental. El informe académico acompaña el producto; no se ha generado ni supuesto el contenido de los Formatos 01 al 06, ya que sus plantillas no fueron entregadas.

## Problema y AS-IS / TO-BE

AS-IS: recomendaciones dispersas, WhatsApp y avisos físicos; dificultad para comparar tarifa, historial y disponibilidad, sin seguimiento consistente.

TO-BE: solicitud estructurada → ranking de perfiles verificados → notificación a hasta tres candidatos → aceptación → confirmación del cliente → ejecución → finalización → calificación. Los vencimientos provocan reasignación y todos los pasos quedan trazados.

## Requisitos y evidencia implementada

| ID | Requisito | Implementación / prueba |
| --- | --- | --- |
| RF-01 | Registro e ingreso por rol | AuthController, middleware ApiToken; alta de admin pública rechazada |
| RF-02 | Solicitud por rubro y zona | Formulario React y validación Laravel |
| RF-03 | Matching ponderado con desempate | matching.js, Matching.php, python/api/app.py; fixture común |
| RF-04 | Máximo 3 notificaciones y 10 minutos | demo.js y Marketplace.php; tests de ofertas y vencimiento |
| RF-05 | Pendiente máximo 24 horas | pendingUntil; prueba de cierre sin cobertura |
| RF-06 | Cliente confirma y técnico ejecuta | Máquina de estados y permisos; recorrido completo probado |
| RF-07 | Calificación única dentro de 48 horas | ratingUntil; prueba de límite exacto |
| RF-08 | Verificación y disponibilidad | Panel administrativo / técnico; filtros de elegibilidad |
| RF-09 | Supervisión y cobertura | Panel por zona y especialidad; historial de eventos |
| RF-10 | Demo independiente del backend | localStorage separado y rotulado; recorrido verificado en navegador |
| RNF-01 | Reglas coherentes en tres lenguajes | JSON canónico, copias verificables y ranking común |
| RNF-02 | Autorización y aislamiento de solicitudes | Token con hash, permisos en API y pruebas de cliente ajeno |
| RNF-03 | Tolerancia a caída de Python | Timeout y fallback PHP probado |
| RNF-04 | Accesibilidad y adaptación | Foco visible, etiquetas, móvil, reducción de movimiento |

## Decisiones pendientes de validación académica

La normalización de cercanía por zona, la tarifa de visita, la experiencia máxima de 10 años y el tratamiento de perfiles nuevos están documentados en TECNICOYA.md. Son decisiones implementadas para completar la especificación, no resultados de entrevistas ni requisitos inventados atribuidos al usuario. La verificación de credenciales de un técnico corresponde al administrador; no se simula una comprobación automática de identidad.

No se han generado resultados ficticios de encuestas, entrevistas, pruebas institucionales ni porcentajes de calidad. PostgreSQL, concurrencia multiinstancia, seguridad de despliegue y Quality Gates requieren validación en el laboratorio.
