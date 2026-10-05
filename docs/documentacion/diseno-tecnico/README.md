# Diseño técnico y datos

Arquitectura vigente: [TECNICOYA](../../TECNICOYA.md). Fuente de reglas: `domain/rules.json` desde la raíz. Contratos e implementación: `backend/api/routes`, `backend/api/app`, `python/api/app.py`. Datos: `backend/api/database/migrations` y `database`. Despliegue propuesto: `infrastructure/docker-compose.yml` y `.gitlab-ci.yml`.

Cada cambio de datos debe registrar motivo, migración, compatibilidad API, prueba de integridad, respaldo y reversión. SQLite de tests no valida bloqueo/concurrencia de PostgreSQL. Los cambios visuales de acceso y scroll no equivalen a nuevos despliegues.
