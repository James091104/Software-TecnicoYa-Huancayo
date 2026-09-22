# TécnicoYa Huancayo

Marketplace para conectar hogares y MYPES con técnicos independientes verificados en cómputo, refrigeración comercial y electricidad.

| Módulo | Tecnología | Función |
| --- | --- | --- |
| frontend/web | React + Vite | Landing, tres roles y demo en localStorage |
| backend/api | Laravel | Autenticación, permisos, solicitudes y PostgreSQL |
| python/api | FastAPI | Ranking de matching con respaldo en PHP |

Abre `TecnicoYa.code-workspace` en Visual Studio Code.

**[Guía de ejecución y arquitectura](docs/TECNICOYA.md)** · **[Contexto académico y trazabilidad](docs/CONTEXTO-Y-TRAZABILIDAD.md)**

Para ver la demo: `cd frontend/web`, `npm ci`, `npm run dev`, y abre http://localhost:5173. No necesita backend.

Las reglas se editan en `domain/rules.json` y se sincronizan con `python scripts/sync-rules.py`. Los tres módulos siguen la convención del Laboratorio DevOps. La implementación anterior se conserva en `docs/legacy/`.
