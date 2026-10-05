# Subcategorías conectadas al marketplace

Fecha: 4 de octubre de 2026.

## Alcance implementado

Se conectaron las 30 subcategorías del catálogo visual con las solicitudes, el perfil del técnico y el matching. Este incremento cubre el filtrado por subcategoría de RF-10; no supone la implementación completa del contexto maestro.

- Cliente: selecciona una subcategoría obligatoria del rubro elegido. Cambiar el rubro limpia la selección. El historial muestra el nombre de la subcategoría.
- Técnico: declara los servicios que atiende en «Mi tarifa y cobertura». Solo puede elegir subcategorías activas de sus especialidades. Las ofertas pendientes y los trabajos activos bloquean estos cambios, igual que la tarifa y cobertura.
- Matching: además de los filtros existentes, exige que el técnico esté activo y atienda la subcategoría solicitada. Los pesos, el desempate y el límite de tres ofertas se mantienen.
- Demo: conserva la selección en localStorage. Los perfiles ficticios iniciales tienen servicios de ejemplo explícitos.
- API: valida el rubro y la subcategoría, persiste la selección y transmite el filtro a FastAPI. El respaldo PHP aplica el mismo filtro.
- Carrusel: obtiene nombres, imágenes y estado activo del mismo catálogo utilizado por los formularios. Mantiene el intervalo de 2,5 segundos y las pausas por interacción, visibilidad y movimiento reducido.

## Catálogo y arquitectura

La fuente es `domain/rules.json`: 11 servicios de cómputo, 9 de refrigeración y 10 de electricidad. Cada entrada tiene identificador estable, especialidad, nombre, imagen y estado `active`. Los identificadores incluyen la especialidad para evitar colisiones entre servicios como mantenimiento preventivo.

Después de editar el catálogo, ejecutar desde la raíz:

```powershell
python scripts/sync-rules.py
python scripts/sync-rules.py --check
```

Las copias se distribuyen a React, Laravel y FastAPI. La arquitectura mantiene PostgreSQL y Python; no se ha realizado una migración a MySQL ni eliminado el microservicio.

La administración visual del catálogo, las tarifas por subcategoría y el resto de ampliaciones del contexto maestro quedan pendientes. Por ahora, el catálogo se administra en el archivo fuente y requiere sincronización y actualización de los servicios.

## Datos existentes

Migración: `backend/api/database/migrations/2026_10_04_000004_add_subcategories.php`.

Añade `technicians.subcategories` y `requests.subcategory`, ambas anulables para conservar los registros anteriores. Fue aplicada correctamente a la base configurada en este entorno. En otros entornos debe ejecutarse `php artisan migrate` desde `backend/api` antes de utilizar el código actualizado.

No se atribuyen servicios automáticamente a técnicos existentes. Deben entrar a su perfil, marcar las subcategorías que atienden y guardar. Esto también aplica a perfiles previamente guardados en la demo: no es necesario borrar localStorage.

Las solicitudes anteriores sin subcategoría muestran «Sin subcategoría (solicitud anterior)» y conservan el matching por rubro. Las solicitudes nuevas requieren una subcategoría válida y activa. Si no hay candidatos con esa habilidad, siguen el flujo existente de pendiente de disponibilidad.

## Verificación realizada

- React/Vitest: 38 pruebas aprobadas; incluye selección y reinicio del formulario, persistencia en demo y exclusión de técnicos sin la habilidad requerida.
- Laravel: 21 pruebas aprobadas, 174 aserciones; incluye rechazo de subcategorías inválidas, persistencia, permisos de perfil y compatibilidad con solicitudes anteriores. Estas pruebas usan SQLite en memoria; no equivalen a una validación de despliegue PostgreSQL.
- Python: 4 pruebas aprobadas; incluye coincidencia por subcategoría, técnicos inactivos y compatibilidad anterior.
- Compilación de producción de Vite completada correctamente.
- Sincronización de reglas y fixtures comprobada.
- Tras proteger el carrusel frente a un catálogo vacío, sus dos pruebas se ejecutaron nuevamente y aprobaron.

Los resultados son verificaciones automatizadas locales; no certifican rendimiento de producción ni cumplimiento de todos los objetivos académicos.
