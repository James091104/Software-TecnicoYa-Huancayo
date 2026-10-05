"""Deriva tres diagramas Mermaid del diccionario; no modifica esquema ni aplicación."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MODEL = json.loads((ROOT / 'Diccionario-MySQL-TecnicoYa.json').read_text(encoding='utf-8'))
TABLES = {t['name']: t for t in MODEL['tables']}
GROUPS = {
    1: '''roles permissions users role_permissions user_permissions client_profiles
        client_blocks technician_profiles technician_reviews technician_status_events
        media_files technician_documents review_documents portfolio_items portfolio_images
        specialties subcategories districts district_distances technician_specialties
        technician_services service_rate_versions technician_districts availability_slots
        technician_pauses sessions password_reset_tokens'''.split(),
    2: '''service_requests request_attachments request_events matching_runs matching_candidates
        offer_rounds offers additional_technician_proposals participations appointments
        reschedule_requests reschedule_responses service_reports service_report_evidence
        incidents incident_evidence reassignment_records payment_methods user_payment_methods
        request_payment_methods simulated_payments simulated_payment_events simulated_receipts'''.split(),
    3: '''ratings rating_versions rating_replies rating_appeals appeal_evidence rating_resolutions
        notifications notification_attempts notification_preferences announcements announcement_audiences
        rule_parameters rule_versions rule_values matching_weights support_tickets
        support_ticket_updates support_attachments audit_entries operations export_files
        outbox_events outbox_deliveries idempotency_records jobs failed_jobs cache cache_locks migrations'''.split(),
}
TITLES = {
    1: 'Usuarios, perfiles y catálogo',
    2: 'Solicitudes, asignaciones, atención y pagos',
    3: 'Calificación, comunicados, reglas de negocio, soporte y auditoría',
}
FILES = {
    1: 'ER-01-Usuarios-Perfiles-Catalogo.mmd',
    2: 'ER-02-Solicitudes-Atencion-Pagos.mmd',
    3: 'ER-03-Calificacion-Reglas-Administracion.mmd',
}
OWNER = {n: g for g, names in GROUPS.items() for n in names}
assert len(OWNER) == sum(map(len, GROUPS.values())) == len(TABLES)
assert set(OWNER) == set(TABLES)

# Referencias lógicas autorizadas explícitamente por el diccionario; no se marcan FK.
NOTIFICATION_TARGETS = {
    'request': 'service_requests', 'offer': 'offers', 'participation': 'participations',
    'rating': 'ratings', 'appeal': 'rating_appeals', 'announcement': 'announcements',
    'support_ticket': 'support_tickets',
}


def attribute(t, c, reference=False):
    """Mermaid no admite comas/espacios en tipos; conserva precisión SQL en comentario."""
    typ = c['type'].lower().replace(' ', '_')
    notes = []
    if ',' in typ:
        typ = typ.split('(')[0]
        notes.append(c['type'])
    keys = []
    if c['name'] in t['primary_key']:
        keys.append('PK')
    if c['reference']:
        keys.append('FK')
    # UK significa miembro de una restricción UNIQUE. No implica unicidad individual.
    unique_groups = [u for u in t['unique'] if c['name'] in u]
    if unique_groups:
        keys.append('UK')
    notes.append('NULL' if c['nullable'] else 'NOT NULL')
    if c['default'] == 'AUTO_INCREMENT':
        notes.append('AI')
    if c['generated']:
        notes.append('GENERADA')
    if len(t['primary_key']) > 1 and c['name'] in t['primary_key']:
        notes.append('PK compuesta')
    for group in unique_groups:
        if len(group) > 1:
            notes.append('UQ(' + ','.join(group) + ')')
    if c['reference']:
        notes.append(c['reference'])
    if t['classification'] == 'Polimórfica' and c['name'] in ('subject_type', 'subject_id', 'aggregate_type', 'aggregate_id'):
        notes.append('polimorfico SIN FK')
    if reference:
        notes.append('referencia D' + str(OWNER[t['name']]))
    assert re.fullmatch(r'[a-z][a-z0-9_()]*', typ), typ
    return f"        {typ} {c['name']}" + (' ' + ', '.join(keys) if keys else '') + ' "' + '; '.join(notes) + '"'


def entity(name, reference=False):
    t = TABLES[name]
    label = name + (f' (ref. D{OWNER[name]})' if reference else '')
    out = [f"    %% {name}: {t['classification']}; modulo {t['module']}", f'    {name}["{label}"] {{']
    cols = t['columns'] if not reference else [c for c in t['columns'] if c['name'] in t['primary_key']]
    out.extend(attribute(t, c, reference) for c in cols)
    out.append('    }')
    return out


def physical_edge(t, c):
    parent = c['reference'].split('.')[0]
    left = '|o' if c['nullable'] else '||'
    # UQ compuesta no convierte a cada FK miembro en una relación 1:1.
    singleton_unique = [c['name']] in [t['primary_key']] + t['unique']
    right = 'o|' if singleton_unique else 'o{'
    line = '--' if c['name'] in t['primary_key'] else '..'
    return f'    {parent} {left}{line}{right} {t["name"]} : "FK {c["name"]}"'


VIEW = '''    %% Vista derivada: NO tabla, NO PK/FK propias, NO escritura directa.
    v_service_history["v_service_history (VISTA)"] {
        bigint_unsigned request_id "NOT NULL; service_requests.id; SIN FK propia"
        bigint_unsigned client_id "NOT NULL"
        bigint_unsigned subcategory_id "NOT NULL"
        bigint_unsigned district_id "NOT NULL"
        varchar(32) request_status "NOT NULL"
        datetime(6) submitted_at "NULL"
        bigint_unsigned participation_id "NULL; SIN FK propia"
        bigint_unsigned technician_id "NULL"
        varchar(32) slot "NULL"
        varchar(32) participation_status "NULL"
        datetime(6) assigned_at "NULL"
        datetime(6) completed_at "NULL"
        decimal reference_fee "DECIMAL(12,2); NULL"
        char(3) currency "NOT NULL"
        bigint_unsigned rating_id "NULL; SIN FK propia"
        tinyint_unsigned rating_score "NULL"
        varchar(32) rating_status "NULL"
    }'''


def diagram(g):
    own = GROUPS[g]
    refs = {c['reference'].split('.')[0] for n in own for c in TABLES[n]['columns'] if c['reference']} - set(own)
    if g == 3:
        refs |= (set(NOTIFICATION_TARGETS.values()) | {'service_requests', 'participations'}) - set(own)
    out = ['erDiagram', '    direction TB', f'    %% TecnicoYa Huancayo - D{g}: {TITLES[g]}',
           '    %% FK fisicas: etiqueta FK. LOGICA/POLI/DERIVA: no crean FK.',
           '    %% UK puede formar parte de una UQ compuesta; ver comentario del atributo.', '']
    for n in own:
        out += entity(n) + ['']
    out += ['    %% Entidades compartidas: solo identificador; definicion completa en su diagrama propietario.']
    for n in sorted(refs):
        out += entity(n, reference=True) + ['']
    if g == 3:
        out += [VIEW, '']
    out += ['    %% Relaciones fisicas: cada linea corresponde a una FK del diccionario.']
    out += [physical_edge(TABLES[n], c) for n in own for c in TABLES[n]['columns'] if c['reference']]
    if g == 1:
        out += ['', '    %% Dependencia logica por correo; no hay FK nativa en el driver.',
                '    users ||..o| password_reset_tokens : "LOGICA email sin FK"']
    if g == 3:
        out += ['', '    %% Polimorfismo XOR: cada notificacion apunta a UN destino segun subject_type.',
                '    %% 0..1 por alternativa; exactamente un destino en conjunto. Sin FK nativa.']
        out += [f'    {table} |o..o{{ notifications : "POLI XOR {alias}"' for alias, table in NOTIFICATION_TARGETS.items()]
        out += ['', '    %% Derivacion de vista, no relaciones FK.',
                '    service_requests ||..|{ v_service_history : "DERIVA solicitud"',
                '    participations |o..|| v_service_history : "DERIVA participacion"',
                '    ratings |o..|| v_service_history : "DERIVA resena"']
    return '\n'.join(out) + '\n'


INTRO = '''# CANVAS | Diagramas E-R de TécnicoYa Huancayo

**Fuente:** [Diccionario de datos MySQL](CANVAS-Diccionario-Datos-MySQL-TecnicoYa.md), versión 1.0, y su modelo JSON. **Fecha:** 4 de octubre de 2026. **Estado:** diseño propuesto; no modifica la implementación ni migra la base.

Se incluyen las **79 tablas, sus 732 atributos y las 155 FK físicas**, distribuidas en tres diagramas; además se representa `v_service_history` como vista derivada. Cada tabla tiene una definición completa en un único diagrama. Una caja **ref. Dn** repite únicamente su PK para conectar un límite entre diagramas: no es una tabla nueva.

## Cómo leer la notación

| Símbolo | Significado |
|---|---|
| PK / FK / UK | Clave primaria / foránea física / miembro de restricción UNIQUE. |
| PK compuesta | Todos los atributos con PK forman juntos la clave primaria. |
| UQ(a,b) en comentario | La combinación es única; a o b por separado pueden repetirse. |
| `||` | Exactamente uno. |
| `|o` izquierda / `o|` derecha | Cero o uno. |
| `}o` izquierda / `o{` derecha | Cero o muchos. |
| `|{` derecha | Uno o muchos; usado en la derivación de historial, no para exigir hijos mediante una FK. |
| `--` | Relación identificadora: la FK del hijo forma parte de su PK. |
| `..` | Relación no identificadora; también se usa en enlaces lógicos etiquetados explícitamente. **No significa ausencia de FK.** |
| Etiqueta FK | Corresponde a una FK real del diccionario. El nombre identifica el campo del hijo. |
| LOGICA / POLI XOR / DERIVA | Dependencia lógica / destino polimórfico alternativo / origen de vista. No son FK físicas. |
| AI / GENERADA | AUTO_INCREMENT / columna calculada por MySQL. |

Las cardinalidades físicas se deducen de NULL, PK y UNIQUE: una FK NOT NULL exige un padre, una FK nullable permite ninguno; una FK individualmente única limita a un hijo por padre. La base no exige que un padre ya tenga hijos. Las restricciones UNIQUE sobre columnas generadas limitan estados activos, no el historial completo; por ello no se convierten en falsos vínculos 1:1.

Los tipos conservan tamaño cuando Mermaid lo permite (`varchar(180)`, `datetime(6)`). `bigint_unsigned` representa `BIGINT UNSIGNED`; `decimal` conserva su precisión MySQL exacta en el comentario. Se muestran todos los atributos, incluidos timestamps. Defaults, CHECK, índices y reglas transaccionales siguen en el diccionario.

Sintaxis conforme a la [referencia oficial de Mermaid erDiagram](https://mermaid.js.org/syntax/entityRelationshipDiagram.html). Se utilizan tipos explícitos y comentarios NULL para no depender de la notación opcional `?` de versiones más recientes.

## Distribución

'''

END = '''## Relaciones que requieren lectura adicional

1. **Usuarios y perfiles:** las FK únicas de `client_profiles.user_id` y `technician_profiles.user_id` permiten a cada tabla de perfil tener como máximo una fila por cuenta. La exclusión por rol se valida en la aplicación; no se deduce que ambas existan siempre. `admins.manage` sigue siendo un permiso, no otro rol.
2. **Roles y permisos:** las asociaciones M:N se muestran mediante sus pivots. `user_permissions.granted_by` es el administrador que concede, distinto del destinatario `user_id`.
3. **Verificación, estado y disponibilidad:** son dimensiones distintas. Horarios y pausas no sustituyen `verification_status` ni `status` del técnico. El catálogo mantiene los tres rubros y sus 30 subcategorías mediante filas, no 30 tablas diferentes.
4. **Tarifas:** `technician_services` es un pivot con atributos y PK sustituta. `service_rate_versions` conserva versiones. La solicitud, oferta y participación mantienen su referencia monetaria histórica; el diagrama no representa transferencias de dinero.
5. **Ofertas y asignaciones:** aceptar una oferta no crea por sí solo una participación. `participations.offer_id` único impide reutilizar la misma oferta para varias asignaciones. Las FK no garantizan por sí solas que candidato, técnico y solicitud pertenezcan al mismo flujo: se valida en transacción.
6. **Límites de negocio:** máximo tres ofertas simultáneas; puesto principal y como máximo un adicional vigentes. Las reasignaciones conservan registros históricos, por lo que una solicitud puede tener muchas participaciones históricas. No cambiar esa cardinalidad a «dos» ni interpretar el 0..N de ofertas como autorización ilimitada.
7. **Relojes:** los vencimientos de ofertas, pendiente de disponibilidad y calificación se guardan en los campos correspondientes. Una FK no implementa SLA ni ventanas de 24/48 horas; el backend y sus trabajos aplican las reglas del diccionario.
8. **Una atención, una reseña:** la UQ sobre `ratings.participation_id` permite una reseña canónica por atención y muchas versiones de su contenido. La identidad de la versión vigente se valida transaccionalmente. No hay una tabla adicional «reseñas» que duplique `ratings`.
9. **Referencias lógicas de versión:** `technician_services.(id,current_rate_version)` identifica lógicamente `service_rate_versions.(technician_service_id,version_no)`; `ratings.(id,current_version_no)` identifica `rating_versions.(rating_id,version_no)`. No son FK físicas en el modelo; se comprueban en la misma transacción. No se dibujan como FK adicionales.
10. **Notificaciones polimórficas:** las siete relaciones POLI XOR son alternativas. Por cada notificación se elige un único destino mediante `subject_type` y `subject_id`; no se requieren siete padres. `recipient_id` sí es FK normal. La integridad del destino depende del mapa cerrado de la aplicación.
11. **Auditoría y outbox:** `audit_entries.(subject_type,subject_id)` y `outbox_events.(aggregate_type,aggregate_id)` son referencias polimórficas sin FK. Un recurso permitido puede tener 0..N entradas/eventos. Cada evento requiere un destino lógico; auditoría permite 0..1 si la acción denegada no materializó recurso. El diccionario no enumera sus mapas completos de tipos: se conservan sin inventar enlaces a cada tabla ni crear una tabla artificial «recursos».
12. **Historial:** la vista combina solicitudes, participaciones y reseñas. Cada solicitud genera al menos una fila; una participación existente genera exactamente una. Si no hay participación o reseña, los campos correspondientes quedan NULL. Las líneas DERIVA explican esta consulta y no son restricciones de la base. No se agregan PK/FK ni índices propios a la vista.
13. **Infraestructura:** sesiones y recuperación están en D1; jobs, fallos, caché, bloqueos y migrations en D3. Las tablas sin FK se muestran aisladas deliberadamente. Payloads JSON/texto no se convierten en relaciones físicas imaginarias.
14. **Pagos simulados:** el grupo económico de D2 registra métodos y simulaciones, con `is_simulated=1` conforme al diccionario. No representa pasarela, cobro bancario ni comprobante fiscal.

## Alcance de la verificación

El generador comprueba que cada tabla tiene un único diagrama propietario, que no faltan columnas y que cada una de las 155 FK aparece exactamente una vez como relación física. Las referencias repetidas se excluyen de esos totales. También comprueba los 17 campos de la vista. No altera tablas, pendientes de negocio ni cardinalidades para simplificar el dibujo.

**Verificación de esta entrega (04/10/2026):** los tres archivos fueron analizados satisfactoriamente por `mermaid.parse` de Mermaid 11.13.0, con resultado `diagramType: er`. Es validación de sintaxis, no una afirmación de haber ejecutado el esquema SQL ni de haber revisado una exportación gráfica.

Para visualizar, abrir el archivo Markdown con un visor Mermaid o copiar un `.mmd` completo en un editor Mermaid. Cada archivo inicia con `erDiagram` y es independiente; **no concatenar tres bloques erDiagram en un mismo bloque de código**. Por el tamaño, se recomienda abrir cada diagrama por separado y utilizar zoom.
'''


def main():
    diagrams = {g: diagram(g) for g in GROUPS}
    fk_total = sum(bool(c['reference']) for t in TABLES.values() for c in t['columns'])
    assert sum(len(re.findall(r': "FK ', s)) for s in diagrams.values()) == fk_total
    counts = []
    for g, s in diagrams.items():
        for n in GROUPS[g]:
            block = s.split(f'    {n}["{n}"] {{\n', 1)[1].split('\n    }', 1)[0]
            assert len(block.splitlines()) == len(TABLES[n]['columns'])
        (ROOT / FILES[g]).write_text(s, encoding='utf-8')
        counts.append({'diagram': g, 'tables': len(GROUPS[g]),
                       'attributes': sum(len(TABLES[n]['columns']) for n in GROUPS[g]),
                       'physical_foreign_keys': len(re.findall(r': "FK ', s)), 'file': FILES[g]})
    md = [INTRO, '| Diagrama | Tablas propias | Atributos propios | FK físicas | Archivo |', '|---|---:|---:|---:|---|']
    for row in counts:
        g = row['diagram']
        md.append(f"| {g}. {TITLES[g]} | {row['tables']} | {row['attributes']} | {row['physical_foreign_keys']} | [{FILES[g]}]({FILES[g]}) |")
    for g, s in diagrams.items():
        md += ['', f'## {g}. {TITLES[g]}', '', '```mermaid', s.rstrip(), '```', '']
    md += [END]
    (ROOT / 'CANVAS-Diagramas-ER-TecnicoYa.md').write_text('\n'.join(md) + '\n', encoding='utf-8')
    print(json.dumps({'tables': len(TABLES), 'attributes': sum(len(t['columns']) for t in TABLES.values()),
                      'physical_foreign_keys': fk_total, 'diagrams': counts}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
