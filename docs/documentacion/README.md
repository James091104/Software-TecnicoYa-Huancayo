# TécnicoYa Huancayo - Documentación v2.0

Fecha: 29/09/2026. Colección adaptada al marketplace de servicios técnicos; no es un proyecto de salud.

17 PDF, 86 páginas. La versión anterior se conserva en `historico/v1-previa-2026-09-29/`; originales académicos, matrices RF/RNF y plan consolidado previo permanecen en sus carpetas.

## Documentos base

- [Análisis del MVP y sustento científico](01-Analisis-del-MVP-TecnicoYa-Huancayo.pdf) (19 páginas).
- [Análisis detallado: matching y asistencia](02-Analisis-MVP-Matching-y-Asistencia.pdf) (4 páginas).
- [Backlog técnico de implementación](03-Backlog-tecnico-de-implementacion.pdf) (11 páginas).
- [Diccionario de datos físico: PostgreSQL](04-Diccionario-de-datos-fisico-PostgreSQL.pdf) (9 páginas).
- [Diccionario conceptual y contratos de datos](05-Diccionario-conceptual-y-contratos.pdf) (4 páginas).
- [Diseño técnico: React, Laravel, FastAPI y PostgreSQL](06-Diseno-tecnico-arquitectura.pdf) (4 páginas).
- [Diseño técnico: integración, servidor y calidad](07-Diseno-tecnico-integracion-servidor-y-pruebas.pdf) (4 páginas).

## Iteraciones

- [Iteración 1: Base de datos: núcleo del marketplace](08-Iteracion-01-Base-de-datos.pdf) (3 páginas).
- [Iteración 2: Autenticación, roles y aislamiento de datos](09-Iteracion-02-Autenticacion-roles-y-permisos.pdf) (3 páginas).
- [Iteración 3: Habilitación y condiciones del servicio](10-Iteracion-03-Habilitacion-y-condiciones-del-servicio.pdf) (3 páginas).
- [Iteración 4: Matching, disponibilidad y ciclo de solicitudes](11-Iteracion-04-Matching-disponibilidad-y-solicitudes.pdf) (3 páginas).
- [Iteración 5: Frontend de técnico, administrador y UX](12-Iteracion-05-Frontend-tecnico-y-administrador.pdf) (3 páginas).
- [Iteración 6: Asistente determinista y registro guiado](13-Iteracion-06-Asistente-determinista-sin-LLM.pdf) (3 páginas).
- [Iteración 7: LLM opcional: parseo y controles](14-Iteracion-07-LLM-parseo-y-controles.pdf) (3 páginas).
- [Iteración 8: Frontend cliente y flujo completo](15-Iteracion-08-Frontend-cliente-y-flujo-integral.pdf) (3 páginas).
- [Iteración 9: Pagos y operación productiva: extensión condicionada](16-Iteracion-09-Pagos-y-operacion-productiva.pdf) (3 páginas).
- [Iteración 10: Seguridad, calidad y despliegue previo al lanzamiento](17-Iteracion-10-Seguridad-calidad-y-despliegue.pdf) (4 páginas).

## Qué cambió respecto de la lista de referencia

- Los dos análisis son definición del MVP con evidencia y análisis detallado del flujo.
- Los dos diccionarios son físico PostgreSQL y conceptual/contratos. No se migró a MySQL.
- Los dos diseños técnicos son arquitectura e integración/servidor/calidad. No se generaron duplicados «(1)».
- La iteración 2 documenta roles y propiedad; no inventa multitenencia.
- La iteración 3 trata habilitación y condiciones, sin suscripción obligatoria.
- La agenda sanitaria se adapta al matching y disponibilidad inmediata.
- I06, I07 e I09 son ampliaciones propuestas (asistente, LLM y pagos), no código existente.
- Cada iteración distingue preparación, frontend, Laravel, Python, datos, pruebas, despliegue y criterios de salida.

## Sustento científico

32 archivos, 30 documentos únicos y dos duplicados exactos (A04=A03, A16=A15). Se extrajo texto de 894 páginas; 813 sin duplicados. La revisión es crítica de un corpus proporcionado, no revisión sistemática exhaustiva.
Las fichas del documento 01 incluyen método, hallazgo, limitaciones, aplicación y páginas de origen. No trasladar porcentajes de otros países/ciudades a Huancayo.
- Copias íntegras: `fuentes/articulos/Axx.pdf`.
- Inventario con SHA-256, origen y duplicados: `fuentes/articulos/manifest.json`.
- Matriz: `trazabilidad/v2/articulos.csv`.
- Estructura editable y diccionario: `editables/v2/`.

## Pruebas y estado de implementación

El documento 07 y la iteración 10 organizan el plan transversal de pruebas; el maestro previo se conserva en el histórico. Las matrices RF/RNF originales no se marcan aprobadas automáticamente. Evidencias de nuevas iteraciones: `evidencias/v2/I01` a `I10`, inicialmente no ejecutadas.
Referencias de calidad: ISO 9001:2026 (edición publicada según ficha oficial consultada), ISO/IEC 25010:2023, ISO/IEC/IEEE 29148:2018 y 29119-3:2021, WCAG 2.2 y ASVS. Alineación documental no significa certificación.

## Regeneración y revisión

Desde la raíz: `python scripts/generar-documentacion-v2.py` genera los 17 PDF en `tmp/pdfs/v2-final/`. Requiere ReportLab, pypdf y Arial de Windows. El generador es la fuente de autoría; JSON conserva la estructura editable de la versión.
Renderizar y revisar páginas antes de instalar una revisión. `scripts/publicar-documentacion-v2.py` conserva la colección anterior y copia los resultados revisados. No ejecutar este publicador para otra versión sin actualizar explícitamente el destino histórico.

## Control de fuentes

Los PDF de referencia sanitaria no se proporcionaron: se adaptó la estructura de sus títulos, no se atribuye una lectura de su contenido. Los archivos en `C:/Users/James/Documents/articulos` se leyeron y copiaron sin modificaciones. No se cambió el código de la aplicación en esta revisión documental.
