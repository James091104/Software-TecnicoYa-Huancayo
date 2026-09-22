# python/

Directorio para servicios y microservicios en Python.
Cada subdirectorio dentro de `python/` es descubierto, construido y probado automáticamente por el Framework DevOps.

---

## 🐍 Matriz de Comandos Python

| Framework | Comando en el Pipeline (CI) | Comando Local del Estudiante | ¿Qué evalúa y prueba? | Archivo para SonarQube |
|---|---|---|---|---|
| **FastAPI** | `pytest -v --cov=. --cov-report=xml:coverage.xml` | `pytest` | Schemas Pydantic, dependencias (`Depends`) y rutas con TestClient (HTTPX). | `coverage.xml` |
| **Flask** | `pytest -v --cov=. --cov-report=xml:coverage.xml` | `pytest` | Blueprints, contextos de aplicación/petición y respuestas JSON. | `coverage.xml` |
| **Django** | `python manage.py test --noinput` | `python manage.py test` | Modelos ORM, validadores de Formularios/Serializers y vistas Django REST. | `.coverage` / XML |
| **Litestar** | `pytest -v --cov=. --cov-report=xml:coverage.xml` | `pytest` | Controladores de alta velocidad y serialización con Msgspec. | `coverage.xml` |
| **Sanic** | `pytest -v --cov=. --cov-report=xml:coverage.xml` | `pytest` | Handlers asíncronos y ciclo de eventos asyncio. | `coverage.xml` |
| **Tornado** | `pytest -v --cov=. --cov-report=xml:coverage.xml` | `pytest` | Endpoints no bloqueantes y manejo de WebSockets. | `coverage.xml` |

---

## ⚙️ Activación de un Módulo
Para que un servicio Python sea construido y desplegado automáticamente, debe contener estos 3 archivos:
1. `requirements.txt` o `pyproject.toml` con las dependencias del proyecto.
2. `Dockerfile` configurado con `ARG PORT`, `ENV PORT=${PORT}` y comando de ejecución en `$PORT`.
3. `.env.example` con la variable `PORT=8000` y configuraciones necesarias.

## Puerto Asignado por Defecto
* `8000` (Rango de puertos python: 8000 - 8099)
