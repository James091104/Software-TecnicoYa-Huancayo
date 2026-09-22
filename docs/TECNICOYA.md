# TécnicoYa Huancayo

Marketplace de dos lados para hogares y MYPES de Huancayo. Conecta clientes con técnicos independientes verificados en cómputo, refrigeración comercial y electricidad. No es un taller único.

## Arquitectura y módulos

- `frontend/web/`: React + Vite; landing, cliente, técnico y administración. Demo local y modo API.
- `backend/api/`: Laravel 12; autenticación con tokens revocables, permisos por rol, solicitudes, ofertas, plazos y calificaciones. PostgreSQL como fuente de verdad.
- `python/api/`: FastAPI; ranking de técnicos vía `POST /match`.
- `database/`: esquema PostgreSQL de referencia. Las migraciones Laravel son el mecanismo de instalación recomendado.
- `domain/rules.json`: fuente única de reglas. Copias idénticas en cada módulo para construir contenedores independientes.
- `docs/legacy/`: implementación Express y Python de orientación anterior, conservada como referencia, fuera de las carpetas detectadas por DevOps.

## Demo sin servidores

Abre `TecnicoYa.code-workspace` en VS Code. Requiere Node.js 22 o superior.

```powershell
cd frontend/web
npm ci
npm run dev
```

Abre http://localhost:5173. La demo funciona sin PHP, Python ni base de datos. Usa localStorage con la clave `tecnicoya.marketplace.v1`, separada de los datos del prototipo anterior. Todos los nombres, tarifas, experiencia y calificaciones iniciales son ficticios; no representan profesionales contratables.

Recorrido sugerido:
1. En **Soy cliente**, registra una falla.
2. En **Soy técnico**, selecciona un perfil notificado y acepta.
3. Vuelve a **Soy cliente** y confirma la propuesta.
4. En **Soy técnico**, inicia y finaliza el servicio.
5. En **Soy cliente**, califica.
6. En **Administración**, revisa perfiles y cobertura.

La demo procesa plazos mientras está abierta y los recalcula al volver. No existe un proceso de JavaScript ejecutándose cuando cierras el navegador; los vencimientos no se pierden. Usa **Mi cuenta** para operar contra Laravel; los datos de demo nunca se envían automáticamente a la API.

## Backend real

Requisitos: PHP 8.2+, Composer, extensión `pdo_pgsql`, PostgreSQL. En esta máquina PHP tiene SQLite, pero no pdo_pgsql habilitado; utiliza Docker o habilita la extensión para conectar PostgreSQL. No se cambió la configuración global de PHP.

```powershell
cd backend/api
composer install
Copy-Item .env.example .env
php artisan key:generate
```

Configura `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` en `.env`. Después:

```powershell
php artisan migrate
php artisan marketplace:admin
php artisan serve --host=127.0.0.1 --port=3000
```

El comando de administrador solicita nombre, correo y contraseña sin mostrarlos en pantalla. No se crean administradores con contraseñas predeterminadas. Las cuentas públicas solo pueden ser cliente o técnico. Los técnicos nuevos comienzan sin verificar y no disponibles; administración debe habilitarlos.

En otra terminal, mantén activo el procesador de plazos:

```powershell
cd backend/api
php artisan schedule:work
```

La tarea se programa cada segundo. Las acciones de la API también comprueban los plazos del servidor antes de aceptar cambios, de modo que una oferta vencida no pueda aceptarse aunque el proceso programado se retrase.

## Motor Python

En un entorno virtual activado:

```powershell
cd python/api
python -m pip install -r requirements.txt
python -m uvicorn app:app --host 127.0.0.1 --port 8000
```

Laravel consulta `PYTHON_URL` con un límite de dos segundos. Ante caída, respuesta inválida o reglas incompatibles, utiliza el ranking PHP. No almacena solicitudes en Python.

## Reglas y normalización

Edita únicamente `domain/rules.json` y ejecuta:

```powershell
python scripts/sync-rules.py
python scripts/sync-rules.py --check
```

- Respuesta del técnico: 10 minutos. La oferta vence exactamente en su fecha límite.
- Máximo de ofertas pendientes simultáneas: 3 por solicitud.
- Disponibilidad: 24 horas desde la creación de la solicitud, sin reiniciar la ventana al reasignar.
- Calificación: 48 horas desde la finalización; una sola calificación de 1 a 5 por servicio.
- Ponderación: cercanía 35%, tarifa 20%, calificación 30%, experiencia 15%.
- Desempate: calificación promedio descendente; si también coincide, identificador ascendente para un resultado estable.

Decisiones de implementación donde el contexto no fijaba fórmula: se filtran técnicos verificados, disponibles, del rubro y con cobertura en la zona. Cercanía vale 1 en su zona principal y 0,5 en una zona adicional; NO son distancias GPS. Tarifa normalizada inversamente entre mínimo y máximo de candidatos elegibles (si son iguales, 1 para todos). Calificación se divide entre 5; experiencia se limita a 10 años y se divide entre 10. Puntaje y promedio se redondean a seis decimales. Un perfil nuevo tiene promedio 0 y se identifica como sin reseñas. La tarifa es de visita; otros trabajos se acuerdan antes de ejecutarlos.

No se vuelve a notificar al mismo técnico para la misma solicitud tras rechazo o expiración. Si no hay nuevos candidatos, permanece pendiente hasta 24 horas. Al aceptar un técnico, se cancelan las otras ofertas, se reserva su disponibilidad y se espera confirmación del cliente. Esto evita asignaciones dobles. Una cancelación previa a la ejecución o una finalización libera al técnico.

## Estados y notificaciones

`pending_availability → searching → proposed → confirmed → in_progress → completed → rated`

También existen `cancelled` y `unassigned`. Se conserva un historial de eventos. Las notificaciones son internas: ofertas en la bandeja del técnico; no hay envío automático de WhatsApp, SMS, correo o push. El cliente ve sus solicitudes; el técnico ve las que le fueron ofrecidas o asignadas; el administrador supervisa todas. Laravel comprueba permisos; cambiar de rol libremente solo es posible en la demo.

Las transiciones se ejecutan en transacciones con bloqueo de solicitudes y técnicos para proteger las aceptaciones. La prueba local usa SQLite en memoria; las garantías de concurrencia PostgreSQL deben validarse en el entorno del laboratorio.

## Validación

```powershell
cd frontend/web
npm test
npm run build
cd ../../backend/api
php artisan test
cd ../../python/api
python -m pytest -q
```

Las tres implementaciones comparan su ranking contra la misma referencia `domain/matching-fixture.json` (copiada en cada módulo). Se verifican exclusiones, empate, plazos, estados, permisos y comportamiento del video. No se afirma haber aprobado SonarQube, pruebas de carga ni el Quality Gate institucional.

## Contenedores y laboratorio

Cada módulo tiene manifiesto, Dockerfile y .env.example. Se conserva `.gitlab-ci.yml` y `project.yml`; completa los autores reales antes de entregar. Hay un ejemplo en `infrastructure/docker-compose.yml`. Define APP_KEY y DB_PASSWORD como variables del entorno, construye con `docker compose -f infrastructure/docker-compose.yml build`, levanta PostgreSQL, ejecuta `docker compose -f infrastructure/docker-compose.yml run --rm api php artisan migrate --force` y luego inicia los servicios. El contenedor API ejecuta también el scheduler. Este servidor está preparado para el laboratorio; para producción pública usa un servidor PHP y una configuración TLS gestionados.

No ejecutes `database/init.sql` y después la migración que crea las mismas tablas. El SQL es referencia/instalación manual alternativa; `seeds.sql` no inventa usuarios reales. Se mantiene PostgreSQL sin credenciales en el repositorio. La API real, Docker y el despliegue institucional aún requieren configuración en el entorno destino.

## Diseño conservado

Video local de la habitación en loop, sin interfaz durante la introducción. El contenido aparece en 00:04:19 a 24 fps (4,7917 segundos). Con movimiento reducido o error de reproducción se muestra directamente la página. Se mantiene Barlow, Instrument Serif, texto blanco y controles de vidrio. La landing explica el marketplace, sus rubros, el matching, el proceso y la diferencia entre demo y cuenta real.
