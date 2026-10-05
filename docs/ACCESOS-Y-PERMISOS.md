# Accesos y permisos

El mismo formulario de inicio de sesión abre el panel correspondiente al rol guardado en el servidor. El registro público solo admite usuario (client) y técnico (technician). No se puede elegir ser administrador al registrarse.

| Rol | Alcance |
| --- | --- |
| Usuario | Crear solicitudes y confirmar, cancelar o calificar sus propios servicios. Editar su nombre. |
| Técnico | Gestionar disponibilidad; responder ofertas recibidas; iniciar y finalizar trabajos asignados. Editar su nombre, tarifa de visita y zonas de cobertura. |
| Administrador | Verificar técnicos, supervisar solicitudes, buscar cuentas, suspender/reactivar accesos y consultar el historial y la matriz de permisos. Editar su nombre. |

Los permisos se validan en Laravel antes de procesar cada acción, además de las comprobaciones de titularidad y estado del servicio. Los roles desconocidos no tienen acceso. El técnico recibe la dirección únicamente tras la confirmación y solo si tiene ese servicio asignado.

La tarifa y cobertura se editan desde «Mi tarifa y cobertura». Laravel identifica al técnico por su sesión, incluye siempre la zona principal y bloquea cambios mientras existan ofertas pendientes o atenciones propuestas, confirmadas o en ejecución. Este formulario no permite modificar la verificación, calificación ni los datos de otro técnico. Las especialidades verificadas siguen bajo revisión administrativa.

## Preparación

Desde backend/api, con la base de datos configurada, ejecutar:

    php artisan migrate
    php artisan marketplace:admin

El segundo comando solicita nombre, correo y contraseña para crear un administrador. No hay contraseña predeterminada. Los administradores no se suspenden desde el panel; su gestión queda a cargo del responsable del sistema.

Suspender revoca las sesiones existentes. No se permite suspender una cuenta que tenga solicitudes pendientes o atenciones activas. Reactivar no recupera tokens anteriores ni activa automáticamente la disponibilidad del técnico. Los cambios registran administrador, cuenta, fecha y acción. El panel muestra los 50 cambios más recientes.

Desde Iniciar sesión, el enlace «Explorar los tres perfiles en la demo» abre #demo y permite alternar los tres paneles. La demo usa datos ficticios en localStorage y no ofrece seguridad real. Las cuentas reales requieren Laravel y la migración aplicada.

## Verificación

    cd frontend/web
    npm test
    npm run build

    cd backend/api
    php artisan test

Las pruebas del backend usan SQLite en memoria, sin modificar la base de datos real.

## Registro en esta computadora

El entorno local está configurado en backend/api/.env con SQLite persistente en backend/api/database/local.sqlite. Ambos archivos están excluidos de Git. PostgreSQL continúa siendo la configuración de referencia para despliegue.

Para volver a iniciar la API después de reiniciar la computadora, desde backend/api:

    php artisan serve --host=127.0.0.1 --port=3000

En otra terminal, desde la misma carpeta:

    php artisan schedule:work

Mantén también Vite activo desde frontend/web con npm run dev. El formulario de registro necesita la API activa, incluso si llegaste a él desde la demo. Los técnicos registrados quedan pendientes de verificación por un administrador.
