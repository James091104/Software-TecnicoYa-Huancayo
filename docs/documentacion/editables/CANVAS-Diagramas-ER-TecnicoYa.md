# CANVAS | Diagramas E-R de TécnicoYa Huancayo

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


| Diagrama | Tablas propias | Atributos propios | FK físicas | Archivo |
|---|---:|---:|---:|---|
| 1. Usuarios, perfiles y catálogo | 27 | 233 | 45 | [ER-01-Usuarios-Perfiles-Catalogo.mmd](ER-01-Usuarios-Perfiles-Catalogo.mmd) |
| 2. Solicitudes, asignaciones, atención y pagos | 23 | 253 | 67 | [ER-02-Solicitudes-Atencion-Pagos.mmd](ER-02-Solicitudes-Atencion-Pagos.mmd) |
| 3. Calificación, comunicados, reglas de negocio, soporte y auditoría | 29 | 246 | 43 | [ER-03-Calificacion-Reglas-Administracion.mmd](ER-03-Calificacion-Reglas-Administracion.mmd) |

## 1. Usuarios, perfiles y catálogo

```mermaid
erDiagram
    direction TB
    %% TecnicoYa Huancayo - D1: Usuarios, perfiles y catálogo
    %% FK fisicas: etiqueta FK. LOGICA/POLI/DERIVA: no crean FK.
    %% UK puede formar parte de una UQ compuesta; ver comentario del atributo.

    %% roles: Independiente; modulo F
    roles["roles"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(40) code UK "NOT NULL"
        varchar(80) name "NOT NULL"
        tinyint_unsigned active "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% permissions: Independiente; modulo F
    permissions["permissions"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(100) code UK "NOT NULL"
        varchar(255) description "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% users: Dependiente; modulo F
    users["users"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned role_id FK "NOT NULL; roles.id"
        varchar(255) name "NOT NULL"
        varchar(254) email UK "NOT NULL"
        varchar(255) password "NOT NULL"
        varchar(20) phone "NULL"
        datetime(6) email_verified_at "NULL"
        tinyint_unsigned is_active "NOT NULL"
        int_unsigned auth_version "NOT NULL"
        datetime(6) anonymized_at "NULL"
        varchar(100) remember_token "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% role_permissions: Pivot; modulo F
    role_permissions["role_permissions"] {
        bigint_unsigned role_id PK, FK "NOT NULL; PK compuesta; roles.id"
        bigint_unsigned permission_id PK, FK "NOT NULL; PK compuesta; permissions.id"
        datetime(6) created_at "NOT NULL"
    }

    %% user_permissions: Pivot; modulo F
    user_permissions["user_permissions"] {
        bigint_unsigned user_id PK, FK "NOT NULL; PK compuesta; users.id"
        bigint_unsigned permission_id PK, FK "NOT NULL; PK compuesta; permissions.id"
        bigint_unsigned granted_by FK "NOT NULL; users.id"
        datetime(6) granted_at "NOT NULL"
    }

    %% client_profiles: Dependiente; modulo F
    client_profiles["client_profiles"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned user_id FK, UK "NOT NULL; users.id"
        varchar(32) client_type "NOT NULL"
        varchar(180) business_name "NULL"
        bigint_unsigned default_district_id FK "NULL; districts.id"
        text default_address "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% client_blocks: Dependiente; modulo F
    client_blocks["client_blocks"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned client_id FK "NOT NULL; client_profiles.id"
        bigint_unsigned blocked_by FK "NOT NULL; users.id"
        text reason "NOT NULL"
        datetime(6) blocked_at "NOT NULL"
        datetime(6) expires_at "NULL"
        bigint_unsigned lifted_by FK "NULL; users.id"
        datetime(6) lifted_at "NULL"
        text lift_reason "NULL"
        varchar(32) status "NOT NULL"
        bigint_unsigned active_client_id UK "NULL; GENERADA"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_profiles: Dependiente; modulo F/A
    technician_profiles["technician_profiles"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned user_id FK, UK "NOT NULL; users.id"
        varchar(32) provider_type "NOT NULL"
        varchar(180) display_name "NOT NULL"
        text bio "NULL"
        varchar(32) status "NOT NULL"
        varchar(32) verification_status "NOT NULL"
        int_unsigned experience_years "NOT NULL"
        bigint_unsigned primary_district_id FK "NULL; districts.id"
        tinyint_unsigned available_now "NOT NULL"
        varchar(20) whatsapp "NULL"
        datetime(6) verified_at "NULL"
        bigint_unsigned verified_by FK "NULL; users.id"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_reviews: Dependiente; modulo F
    technician_reviews["technician_reviews"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        bigint_unsigned reviewer_id FK "NOT NULL; users.id"
        varchar(32) decision "NOT NULL"
        text reason "NOT NULL"
        json checklist "NOT NULL"
        datetime(6) reviewed_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% technician_status_events: Dependiente; modulo F
    technician_status_events["technician_status_events"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        bigint_unsigned actor_id FK "NOT NULL; users.id"
        varchar(32) from_status "NOT NULL"
        varchar(32) to_status "NOT NULL"
        text reason "NOT NULL"
        datetime(6) occurred_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% media_files: Dependiente; modulo F
    media_files["media_files"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned owner_id FK "NOT NULL; users.id"
        varchar(40) disk UK "NOT NULL; UQ(disk,storage_key)"
        varchar(255) storage_key UK "NOT NULL; UQ(disk,storage_key)"
        varchar(255) original_name "NOT NULL"
        varchar(120) mime_type "NOT NULL"
        bigint_unsigned byte_size "NOT NULL"
        char(64) sha256 "NOT NULL"
        varchar(32) visibility "NOT NULL"
        varchar(32) scan_status "NOT NULL"
        datetime(6) retired_at "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_documents: Dependiente; modulo F
    technician_documents["technician_documents"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        bigint_unsigned media_id FK, UK "NOT NULL; media_files.id"
        varchar(60) document_type "NOT NULL"
        varchar(32) review_status "NOT NULL"
        bigint_unsigned reviewed_by FK "NULL; users.id"
        datetime(6) reviewed_at "NULL"
        text review_note "NULL"
        datetime(6) valid_until "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% review_documents: Pivot; modulo F
    review_documents["review_documents"] {
        bigint_unsigned review_id PK, FK "NOT NULL; PK compuesta; technician_reviews.id"
        bigint_unsigned document_id PK, FK "NOT NULL; PK compuesta; technician_documents.id"
        datetime(6) created_at "NOT NULL"
    }

    %% portfolio_items: Dependiente; modulo F
    portfolio_items["portfolio_items"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        bigint_unsigned subcategory_id FK "NULL; subcategories.id"
        varchar(160) title "NOT NULL"
        text description "NULL"
        date performed_on "NULL"
        varchar(32) status "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% portfolio_images: Pivot; modulo F
    portfolio_images["portfolio_images"] {
        bigint_unsigned portfolio_id PK, FK, UK "NOT NULL; PK compuesta; UQ(portfolio_id,position); portfolio_items.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        int_unsigned position UK "NOT NULL; UQ(portfolio_id,position)"
        varchar(180) caption "NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% specialties: Independiente; modulo F
    specialties["specialties"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(40) code UK "NOT NULL"
        varchar(120) name "NOT NULL"
        text description "NULL"
        bigint_unsigned hero_media_id FK "NULL; media_files.id"
        tinyint_unsigned active "NOT NULL"
        int_unsigned display_order "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% subcategories: Dependiente; modulo F/A
    subcategories["subcategories"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned specialty_id FK, UK "NOT NULL; UQ(specialty_id,name); specialties.id"
        varchar(80) code UK "NOT NULL"
        varchar(180) name UK "NOT NULL; UQ(specialty_id,name)"
        text description "NULL"
        bigint_unsigned carousel_media_id FK "NULL; media_files.id"
        decimal reference_fee "DECIMAL(12,2); NULL"
        char(3) currency "NOT NULL"
        int_unsigned estimated_minutes "NULL"
        tinyint_unsigned active "NOT NULL"
        int_unsigned display_order "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% districts: Independiente; modulo F/A
    districts["districts"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(12) code UK "NOT NULL"
        varchar(120) name UK "NOT NULL"
        tinyint_unsigned active "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% district_distances: Pivot; modulo B
    district_distances["district_distances"] {
        bigint_unsigned from_district_id PK, FK "NOT NULL; PK compuesta; districts.id"
        bigint_unsigned to_district_id PK, FK "NOT NULL; PK compuesta; districts.id"
        decimal distance_km "DECIMAL(8,3); NOT NULL"
        varchar(255) source "NOT NULL"
        datetime(6) measured_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_specialties: Pivot; modulo A/F
    technician_specialties["technician_specialties"] {
        bigint_unsigned technician_id PK, FK "NOT NULL; PK compuesta; technician_profiles.id"
        bigint_unsigned specialty_id PK, FK "NOT NULL; PK compuesta; specialties.id"
        varchar(32) verification_status "NOT NULL"
        bigint_unsigned reviewed_by FK "NULL; users.id"
        datetime(6) reviewed_at "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_services: Pivot; modulo A/B
    technician_services["technician_services"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK, UK "NOT NULL; UQ(technician_id,subcategory_id); technician_profiles.id"
        bigint_unsigned subcategory_id FK, UK "NOT NULL; UQ(technician_id,subcategory_id); subcategories.id"
        decimal reference_fee "DECIMAL(12,2); NOT NULL"
        char(3) currency "NOT NULL"
        int_unsigned experience_years "NOT NULL"
        tinyint_unsigned active "NOT NULL"
        int_unsigned current_rate_version "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% service_rate_versions: Dependiente; modulo A/F
    service_rate_versions["service_rate_versions"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_service_id FK, UK "NOT NULL; UQ(technician_service_id,version_no); technician_services.id"
        int_unsigned version_no UK "NOT NULL; UQ(technician_service_id,version_no)"
        decimal reference_fee "DECIMAL(12,2); NOT NULL"
        char(3) currency "NOT NULL"
        bigint_unsigned changed_by FK "NOT NULL; users.id"
        text reason "NULL"
        datetime(6) effective_from "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% technician_districts: Pivot; modulo A/B
    technician_districts["technician_districts"] {
        bigint_unsigned technician_id PK, FK "NOT NULL; PK compuesta; technician_profiles.id"
        bigint_unsigned district_id PK, FK "NOT NULL; PK compuesta; districts.id"
        tinyint_unsigned active "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% availability_slots: Dependiente; modulo A/D
    availability_slots["availability_slots"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        varchar(32) kind "NOT NULL"
        tinyint_unsigned weekday "NULL"
        time local_start "NULL"
        time local_end "NULL"
        date valid_from "NULL"
        date valid_until "NULL"
        datetime(6) starts_at "NULL"
        datetime(6) ends_at "NULL"
        varchar(60) timezone "NOT NULL"
        tinyint_unsigned active "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% technician_pauses: Dependiente; modulo A/B
    technician_pauses["technician_pauses"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        datetime(6) starts_at "NOT NULL"
        datetime(6) ends_at "NULL"
        datetime(6) cancelled_at "NULL"
        varchar(255) reason "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% sessions: Dependiente; modulo Infraestructura
    sessions["sessions"] {
        varchar(255) id PK "NOT NULL"
        bigint_unsigned user_id FK "NULL; users.id"
        varchar(45) ip_address "NULL"
        text user_agent "NULL"
        longtext payload "NOT NULL"
        int last_activity "NOT NULL"
    }

    %% password_reset_tokens: Dependiente; modulo Infraestructura
    password_reset_tokens["password_reset_tokens"] {
        varchar(254) email PK "NOT NULL"
        varchar(255) token "NOT NULL"
        datetime(6) created_at "NULL"
    }

    %% Entidades compartidas: solo identificador; definicion completa en su diagrama propietario.
    %% Relaciones fisicas: cada linea corresponde a una FK del diccionario.
    roles ||..o{ users : "FK role_id"
    roles ||--o{ role_permissions : "FK role_id"
    permissions ||--o{ role_permissions : "FK permission_id"
    users ||--o{ user_permissions : "FK user_id"
    permissions ||--o{ user_permissions : "FK permission_id"
    users ||..o{ user_permissions : "FK granted_by"
    users ||..o| client_profiles : "FK user_id"
    districts |o..o{ client_profiles : "FK default_district_id"
    client_profiles ||..o{ client_blocks : "FK client_id"
    users ||..o{ client_blocks : "FK blocked_by"
    users |o..o{ client_blocks : "FK lifted_by"
    users ||..o| technician_profiles : "FK user_id"
    districts |o..o{ technician_profiles : "FK primary_district_id"
    users |o..o{ technician_profiles : "FK verified_by"
    technician_profiles ||..o{ technician_reviews : "FK technician_id"
    users ||..o{ technician_reviews : "FK reviewer_id"
    technician_profiles ||..o{ technician_status_events : "FK technician_id"
    users ||..o{ technician_status_events : "FK actor_id"
    users ||..o{ media_files : "FK owner_id"
    technician_profiles ||..o{ technician_documents : "FK technician_id"
    media_files ||..o| technician_documents : "FK media_id"
    users |o..o{ technician_documents : "FK reviewed_by"
    technician_reviews ||--o{ review_documents : "FK review_id"
    technician_documents ||--o{ review_documents : "FK document_id"
    technician_profiles ||..o{ portfolio_items : "FK technician_id"
    subcategories |o..o{ portfolio_items : "FK subcategory_id"
    portfolio_items ||--o{ portfolio_images : "FK portfolio_id"
    media_files ||--o{ portfolio_images : "FK media_id"
    media_files |o..o{ specialties : "FK hero_media_id"
    specialties ||..o{ subcategories : "FK specialty_id"
    media_files |o..o{ subcategories : "FK carousel_media_id"
    districts ||--o{ district_distances : "FK from_district_id"
    districts ||--o{ district_distances : "FK to_district_id"
    technician_profiles ||--o{ technician_specialties : "FK technician_id"
    specialties ||--o{ technician_specialties : "FK specialty_id"
    users |o..o{ technician_specialties : "FK reviewed_by"
    technician_profiles ||..o{ technician_services : "FK technician_id"
    subcategories ||..o{ technician_services : "FK subcategory_id"
    technician_services ||..o{ service_rate_versions : "FK technician_service_id"
    users ||..o{ service_rate_versions : "FK changed_by"
    technician_profiles ||--o{ technician_districts : "FK technician_id"
    districts ||--o{ technician_districts : "FK district_id"
    technician_profiles ||..o{ availability_slots : "FK technician_id"
    technician_profiles ||..o{ technician_pauses : "FK technician_id"
    users |o..o{ sessions : "FK user_id"

    %% Dependencia logica por correo; no hay FK nativa en el driver.
    users ||..o| password_reset_tokens : "LOGICA email sin FK"
```


## 2. Solicitudes, asignaciones, atención y pagos

```mermaid
erDiagram
    direction TB
    %% TecnicoYa Huancayo - D2: Solicitudes, asignaciones, atención y pagos
    %% FK fisicas: etiqueta FK. LOGICA/POLI/DERIVA: no crean FK.
    %% UK puede formar parte de una UQ compuesta; ver comentario del atributo.

    %% service_requests: Dependiente; modulo A/D
    service_requests["service_requests"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned client_id FK "NOT NULL; client_profiles.id"
        bigint_unsigned subcategory_id FK "NOT NULL; subcategories.id"
        bigint_unsigned district_id FK "NOT NULL; districts.id"
        text description "NOT NULL"
        text address "NOT NULL"
        varchar(32) mode "NOT NULL"
        datetime(6) preferred_start_at "NULL"
        datetime(6) preferred_end_at "NULL"
        varchar(32) source "NOT NULL"
        bigint_unsigned target_technician_id FK "NULL; technician_profiles.id"
        varchar(32) status "NOT NULL"
        decimal reference_fee_snapshot "DECIMAL(12,2); NULL"
        char(3) currency "NOT NULL"
        bigint_unsigned rule_version_id FK "NULL; rule_versions.id"
        datetime(6) submitted_at "NULL"
        datetime(6) pending_since "NULL"
        datetime(6) pending_expires_at "NULL"
        int_unsigned search_generation "NOT NULL"
        datetime(6) cancelled_at "NULL"
        text cancellation_reason "NULL"
        datetime(6) closed_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% request_attachments: Pivot; modulo A
    request_attachments["request_attachments"] {
        bigint_unsigned request_id PK, FK, UK "NOT NULL; PK compuesta; UQ(request_id,position); service_requests.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        bigint_unsigned uploaded_by FK "NOT NULL; users.id"
        int_unsigned position UK "NOT NULL; UQ(request_id,position)"
        varchar(180) caption "NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% request_events: Dependiente; modulo D
    request_events["request_events"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK "NOT NULL; service_requests.id"
        bigint_unsigned actor_id FK "NULL; users.id"
        varchar(80) event_type "NOT NULL"
        varchar(32) from_status "NULL"
        varchar(32) to_status "NULL"
        text summary "NOT NULL"
        json metadata "NULL"
        datetime(6) occurred_at "NOT NULL"
        varchar(64) correlation_id "NOT NULL"
        int_unsigned request_version "NOT NULL"
    }

    %% matching_runs: Dependiente; modulo B
    matching_runs["matching_runs"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK, UK "NOT NULL; UQ(request_id,generation); service_requests.id"
        bigint_unsigned rule_version_id FK "NOT NULL; rule_versions.id"
        int_unsigned generation UK "NOT NULL; UQ(request_id,generation)"
        datetime(6) started_at "NOT NULL"
        datetime(6) finished_at "NULL"
        varchar(32) status "NOT NULL"
        json rules_snapshot "NOT NULL"
        varchar(60) algorithm_version "NOT NULL"
        int_unsigned duration_ms "NULL"
        varchar(80) failure_code "NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% matching_candidates: Pivot; modulo B
    matching_candidates["matching_candidates"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned matching_run_id FK, UK "NOT NULL; UQ(matching_run_id,technician_id); UQ(matching_run_id,rank_position); matching_runs.id"
        bigint_unsigned technician_id FK, UK "NOT NULL; UQ(matching_run_id,technician_id); technician_profiles.id"
        bigint_unsigned technician_service_id FK "NOT NULL; technician_services.id"
        tinyint_unsigned eligible "NOT NULL"
        varchar(80) exclusion_code "NULL"
        decimal proximity_factor "DECIMAL(9,6); NULL"
        decimal price_factor "DECIMAL(9,6); NULL"
        decimal rating_factor "DECIMAL(9,6); NULL"
        decimal experience_factor "DECIMAL(9,6); NULL"
        decimal score "DECIMAL(9,6); NULL"
        int_unsigned rank_position UK "NULL; UQ(matching_run_id,rank_position)"
        json input_snapshot "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% offer_rounds: Dependiente; modulo C
    offer_rounds["offer_rounds"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK, UK "NOT NULL; UQ(request_id,round_no); service_requests.id"
        bigint_unsigned matching_run_id FK "NULL; matching_runs.id"
        int_unsigned round_no UK "NOT NULL; UQ(request_id,round_no)"
        int_unsigned generation "NOT NULL"
        varchar(32) kind "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) opened_at "NOT NULL"
        datetime(6) expires_at "NOT NULL"
        datetime(6) closed_at "NULL"
        bigint_unsigned active_request_id UK "NULL; GENERADA"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% offers: Dependiente; modulo C
    offers["offers"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned round_id FK, UK "NOT NULL; UQ(round_id,technician_id); offer_rounds.id"
        bigint_unsigned technician_id FK, UK "NOT NULL; UQ(round_id,technician_id); technician_profiles.id"
        bigint_unsigned matching_candidate_id FK "NULL; matching_candidates.id"
        bigint_unsigned service_rate_version_id FK "NULL; service_rate_versions.id"
        decimal reference_fee_snapshot "DECIMAL(12,2); NOT NULL"
        char(3) currency "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) available_at "NOT NULL"
        datetime(6) expires_at "NOT NULL"
        datetime(6) responded_at "NULL"
        text response_reason "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% additional_technician_proposals: Dependiente; modulo D
    additional_technician_proposals["additional_technician_proposals"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK "NOT NULL; service_requests.id"
        bigint_unsigned proposed_by_participation_id FK "NOT NULL; participations.id"
        bigint_unsigned proposed_technician_id FK "NOT NULL; technician_profiles.id"
        text reason "NOT NULL"
        varchar(32) status "NOT NULL"
        bigint_unsigned client_decided_by FK "NULL; users.id"
        datetime(6) client_decided_at "NULL"
        bigint_unsigned offer_id FK "NULL; offers.id"
        bigint_unsigned open_request_id UK "NULL; GENERADA"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% participations: Dependiente; modulo D
    participations["participations"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK, UK "NOT NULL; UQ(request_id,occupied_slot); UQ(request_id,current_technician_id); service_requests.id"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        bigint_unsigned offer_id FK, UK "NOT NULL; offers.id"
        varchar(32) slot "NOT NULL"
        varchar(32) status "NOT NULL"
        bigint_unsigned authorized_by FK "NOT NULL; users.id"
        datetime(6) assigned_at "NOT NULL"
        datetime(6) started_at "NULL"
        datetime(6) completed_at "NULL"
        datetime(6) ended_at "NULL"
        decimal reference_fee_snapshot "DECIMAL(12,2); NOT NULL"
        char(3) currency "NOT NULL"
        varchar(32) rating_status "NOT NULL"
        datetime(6) rating_due_at "NULL"
        bigint_unsigned replaces_id FK "NULL; participations.id"
        varchar(32) occupied_slot UK "NULL; GENERADA; UQ(request_id,occupied_slot)"
        bigint_unsigned current_technician_id UK "NULL; GENERADA; UQ(request_id,current_technician_id)"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% appointments: Dependiente; modulo D
    appointments["appointments"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned participation_id FK, UK "NOT NULL; participations.id"
        bigint_unsigned technician_id FK "NOT NULL; technician_profiles.id"
        datetime(6) starts_at "NOT NULL"
        datetime(6) ends_at "NOT NULL"
        varchar(32) status "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% reschedule_requests: Dependiente; modulo D
    reschedule_requests["reschedule_requests"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned appointment_id FK "NOT NULL; appointments.id"
        bigint_unsigned proposed_by FK "NOT NULL; users.id"
        datetime(6) original_start_at "NOT NULL"
        datetime(6) original_end_at "NOT NULL"
        datetime(6) proposed_start_at "NOT NULL"
        datetime(6) proposed_end_at "NOT NULL"
        text reason "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) expires_at "NOT NULL"
        datetime(6) resolved_at "NULL"
        bigint_unsigned open_appointment_id UK "NULL; GENERADA"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% reschedule_responses: Pivot; modulo D
    reschedule_responses["reschedule_responses"] {
        bigint_unsigned reschedule_id PK, FK "NOT NULL; PK compuesta; reschedule_requests.id"
        bigint_unsigned user_id PK, FK "NOT NULL; PK compuesta; users.id"
        varchar(32) decision "NOT NULL"
        datetime(6) responded_at "NOT NULL"
    }

    %% service_reports: Dependiente; modulo D
    service_reports["service_reports"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned participation_id FK, UK "NOT NULL; participations.id"
        bigint_unsigned author_id FK "NOT NULL; users.id"
        text work_description "NOT NULL"
        text result_description "NOT NULL"
        datetime(6) submitted_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% service_report_evidence: Pivot; modulo D
    service_report_evidence["service_report_evidence"] {
        bigint_unsigned report_id PK, FK, UK "NOT NULL; PK compuesta; UQ(report_id,position); service_reports.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        int_unsigned position UK "NOT NULL; UQ(report_id,position)"
        varchar(180) caption "NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% incidents: Dependiente; modulo D/F
    incidents["incidents"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK "NOT NULL; service_requests.id"
        bigint_unsigned participation_id FK "NULL; participations.id"
        bigint_unsigned reported_by FK "NOT NULL; users.id"
        varchar(60) type "NOT NULL"
        text description "NOT NULL"
        varchar(32) status "NOT NULL"
        bigint_unsigned reviewed_by FK "NULL; users.id"
        text resolution "NULL"
        datetime(6) resolved_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% incident_evidence: Pivot; modulo D/F
    incident_evidence["incident_evidence"] {
        bigint_unsigned incident_id PK, FK "NOT NULL; PK compuesta; incidents.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        datetime(6) created_at "NOT NULL"
    }

    %% reassignment_records: Dependiente; modulo C/F
    reassignment_records["reassignment_records"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK "NOT NULL; service_requests.id"
        bigint_unsigned previous_participation_id FK "NULL; participations.id"
        bigint_unsigned new_participation_id FK "NULL; participations.id"
        bigint_unsigned target_technician_id FK "NULL; technician_profiles.id"
        bigint_unsigned actor_id FK "NULL; users.id"
        varchar(32) origin "NOT NULL"
        text reason "NOT NULL"
        bigint_unsigned incident_id FK "NULL; incidents.id"
        bigint_unsigned new_round_id FK "NULL; offer_rounds.id"
        varchar(32) status "NOT NULL"
        datetime(6) resolved_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% payment_methods: Independiente; modulo F
    payment_methods["payment_methods"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(40) code UK "NOT NULL"
        varchar(100) name "NOT NULL"
        tinyint_unsigned active "NOT NULL"
        int_unsigned display_order "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% user_payment_methods: Pivot; modulo F
    user_payment_methods["user_payment_methods"] {
        bigint_unsigned user_id PK, FK "NOT NULL; PK compuesta; users.id"
        bigint_unsigned payment_method_id PK, FK "NOT NULL; PK compuesta; payment_methods.id"
        varchar(80) label "NULL"
        tinyint_unsigned is_default "NOT NULL"
        bigint_unsigned default_user_id UK "NULL; GENERADA"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% request_payment_methods: Dependiente; modulo F
    request_payment_methods["request_payment_methods"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned request_id FK, UK "NOT NULL; service_requests.id"
        bigint_unsigned payment_method_id FK "NOT NULL; payment_methods.id"
        bigint_unsigned selected_by FK "NOT NULL; users.id"
        datetime(6) selected_at "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% simulated_payments: Dependiente; modulo F
    simulated_payments["simulated_payments"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned participation_id FK "NOT NULL; participations.id"
        bigint_unsigned payment_method_id FK "NOT NULL; payment_methods.id"
        bigint_unsigned created_by FK "NOT NULL; users.id"
        decimal amount "DECIMAL(12,2); NOT NULL"
        char(3) currency "NOT NULL"
        varchar(32) status "NOT NULL"
        tinyint_unsigned is_simulated "NOT NULL"
        varchar(80) simulation_reference UK "NOT NULL"
        bigint_unsigned confirmed_by FK "NULL; users.id"
        datetime(6) confirmed_at "NULL"
        datetime(6) confirmation_due_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% simulated_payment_events: Dependiente; modulo F
    simulated_payment_events["simulated_payment_events"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned simulated_payment_id FK "NOT NULL; simulated_payments.id"
        bigint_unsigned actor_id FK "NOT NULL; users.id"
        varchar(32) from_status "NULL"
        varchar(32) to_status "NOT NULL"
        text reason "NOT NULL"
        datetime(6) occurred_at "NOT NULL"
    }

    %% simulated_receipts: Dependiente; modulo F
    simulated_receipts["simulated_receipts"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned simulated_payment_id FK "NOT NULL; simulated_payments.id"
        bigint_unsigned media_id FK, UK "NOT NULL; media_files.id"
        varchar(80) reference UK "NOT NULL"
        datetime(6) issued_at "NOT NULL"
        tinyint_unsigned is_simulated "NOT NULL"
        json snapshot "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% Entidades compartidas: solo identificador; definicion completa en su diagrama propietario.
    %% client_profiles: Dependiente; modulo F
    client_profiles["client_profiles (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% districts: Independiente; modulo F/A
    districts["districts (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% media_files: Dependiente; modulo F
    media_files["media_files (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% rule_versions: Dependiente; modulo F
    rule_versions["rule_versions (ref. D3)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D3"
    }

    %% service_rate_versions: Dependiente; modulo A/F
    service_rate_versions["service_rate_versions (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% subcategories: Dependiente; modulo F/A
    subcategories["subcategories (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% technician_profiles: Dependiente; modulo F/A
    technician_profiles["technician_profiles (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% technician_services: Pivot; modulo A/B
    technician_services["technician_services (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% users: Dependiente; modulo F
    users["users (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% Relaciones fisicas: cada linea corresponde a una FK del diccionario.
    client_profiles ||..o{ service_requests : "FK client_id"
    subcategories ||..o{ service_requests : "FK subcategory_id"
    districts ||..o{ service_requests : "FK district_id"
    technician_profiles |o..o{ service_requests : "FK target_technician_id"
    rule_versions |o..o{ service_requests : "FK rule_version_id"
    service_requests ||--o{ request_attachments : "FK request_id"
    media_files ||--o{ request_attachments : "FK media_id"
    users ||..o{ request_attachments : "FK uploaded_by"
    service_requests ||..o{ request_events : "FK request_id"
    users |o..o{ request_events : "FK actor_id"
    service_requests ||..o{ matching_runs : "FK request_id"
    rule_versions ||..o{ matching_runs : "FK rule_version_id"
    matching_runs ||..o{ matching_candidates : "FK matching_run_id"
    technician_profiles ||..o{ matching_candidates : "FK technician_id"
    technician_services ||..o{ matching_candidates : "FK technician_service_id"
    service_requests ||..o{ offer_rounds : "FK request_id"
    matching_runs |o..o{ offer_rounds : "FK matching_run_id"
    offer_rounds ||..o{ offers : "FK round_id"
    technician_profiles ||..o{ offers : "FK technician_id"
    matching_candidates |o..o{ offers : "FK matching_candidate_id"
    service_rate_versions |o..o{ offers : "FK service_rate_version_id"
    service_requests ||..o{ additional_technician_proposals : "FK request_id"
    participations ||..o{ additional_technician_proposals : "FK proposed_by_participation_id"
    technician_profiles ||..o{ additional_technician_proposals : "FK proposed_technician_id"
    users |o..o{ additional_technician_proposals : "FK client_decided_by"
    offers |o..o{ additional_technician_proposals : "FK offer_id"
    service_requests ||..o{ participations : "FK request_id"
    technician_profiles ||..o{ participations : "FK technician_id"
    offers ||..o| participations : "FK offer_id"
    users ||..o{ participations : "FK authorized_by"
    participations |o..o{ participations : "FK replaces_id"
    participations ||..o| appointments : "FK participation_id"
    technician_profiles ||..o{ appointments : "FK technician_id"
    appointments ||..o{ reschedule_requests : "FK appointment_id"
    users ||..o{ reschedule_requests : "FK proposed_by"
    reschedule_requests ||--o{ reschedule_responses : "FK reschedule_id"
    users ||--o{ reschedule_responses : "FK user_id"
    participations ||..o| service_reports : "FK participation_id"
    users ||..o{ service_reports : "FK author_id"
    service_reports ||--o{ service_report_evidence : "FK report_id"
    media_files ||--o{ service_report_evidence : "FK media_id"
    service_requests ||..o{ incidents : "FK request_id"
    participations |o..o{ incidents : "FK participation_id"
    users ||..o{ incidents : "FK reported_by"
    users |o..o{ incidents : "FK reviewed_by"
    incidents ||--o{ incident_evidence : "FK incident_id"
    media_files ||--o{ incident_evidence : "FK media_id"
    service_requests ||..o{ reassignment_records : "FK request_id"
    participations |o..o{ reassignment_records : "FK previous_participation_id"
    participations |o..o{ reassignment_records : "FK new_participation_id"
    technician_profiles |o..o{ reassignment_records : "FK target_technician_id"
    users |o..o{ reassignment_records : "FK actor_id"
    incidents |o..o{ reassignment_records : "FK incident_id"
    offer_rounds |o..o{ reassignment_records : "FK new_round_id"
    users ||--o{ user_payment_methods : "FK user_id"
    payment_methods ||--o{ user_payment_methods : "FK payment_method_id"
    service_requests ||..o| request_payment_methods : "FK request_id"
    payment_methods ||..o{ request_payment_methods : "FK payment_method_id"
    users ||..o{ request_payment_methods : "FK selected_by"
    participations ||..o{ simulated_payments : "FK participation_id"
    payment_methods ||..o{ simulated_payments : "FK payment_method_id"
    users ||..o{ simulated_payments : "FK created_by"
    users |o..o{ simulated_payments : "FK confirmed_by"
    simulated_payments ||..o{ simulated_payment_events : "FK simulated_payment_id"
    users ||..o{ simulated_payment_events : "FK actor_id"
    simulated_payments ||..o{ simulated_receipts : "FK simulated_payment_id"
    media_files ||..o| simulated_receipts : "FK media_id"
```


## 3. Calificación, comunicados, reglas de negocio, soporte y auditoría

```mermaid
erDiagram
    direction TB
    %% TecnicoYa Huancayo - D3: Calificación, comunicados, reglas de negocio, soporte y auditoría
    %% FK fisicas: etiqueta FK. LOGICA/POLI/DERIVA: no crean FK.
    %% UK puede formar parte de una UQ compuesta; ver comentario del atributo.

    %% ratings: Dependiente; modulo E
    ratings["ratings"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned participation_id FK, UK "NOT NULL; participations.id"
        bigint_unsigned author_id FK "NOT NULL; users.id"
        tinyint_unsigned score "NOT NULL"
        text comment "NOT NULL"
        int_unsigned current_version_no "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) first_rated_at "NOT NULL"
        datetime(6) editable_until "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% rating_versions: Dependiente; modulo E
    rating_versions["rating_versions"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned rating_id FK, UK "NOT NULL; UQ(rating_id,version_no); ratings.id"
        int_unsigned version_no UK "NOT NULL; UQ(rating_id,version_no)"
        tinyint_unsigned score "NOT NULL"
        text comment "NOT NULL"
        bigint_unsigned changed_by FK "NOT NULL; users.id"
        varchar(32) change_kind "NOT NULL"
        text reason "NULL"
        datetime(6) changed_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% rating_replies: Dependiente; modulo E
    rating_replies["rating_replies"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned rating_id FK, UK "NOT NULL; ratings.id"
        bigint_unsigned author_id FK "NOT NULL; users.id"
        text text "NOT NULL"
        varchar(32) status "NOT NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% rating_appeals: Dependiente; modulo E
    rating_appeals["rating_appeals"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned rating_id FK "NOT NULL; ratings.id"
        bigint_unsigned submitted_by FK "NOT NULL; users.id"
        bigint_unsigned submitted_version_id FK "NOT NULL; rating_versions.id"
        text reason "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) submitted_at "NOT NULL"
        datetime(6) appeal_deadline_at "NULL"
        bigint_unsigned open_rating_id UK "NULL; GENERADA"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% appeal_evidence: Pivot; modulo E
    appeal_evidence["appeal_evidence"] {
        bigint_unsigned appeal_id PK, FK "NOT NULL; PK compuesta; rating_appeals.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        datetime(6) created_at "NOT NULL"
    }

    %% rating_resolutions: Dependiente; modulo E/F
    rating_resolutions["rating_resolutions"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned appeal_id FK, UK "NOT NULL; rating_appeals.id"
        bigint_unsigned reviewed_version_id FK "NOT NULL; rating_versions.id"
        bigint_unsigned resolved_by FK "NOT NULL; users.id"
        varchar(32) decision "NOT NULL"
        text reason "NOT NULL"
        bigint_unsigned result_version_id FK "NULL; rating_versions.id"
        datetime(6) resolved_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% notifications: Polimórfica; modulo F/C
    notifications["notifications"] {
        bigint_unsigned id PK "NOT NULL; AI"
        char(36) event_uuid UK "NOT NULL; UQ(event_uuid,recipient_id)"
        bigint_unsigned recipient_id FK, UK "NOT NULL; UQ(event_uuid,recipient_id); users.id"
        varchar(80) event_type "NOT NULL"
        varchar(40) subject_type "NOT NULL; polimorfico SIN FK"
        bigint_unsigned subject_id "NOT NULL; polimorfico SIN FK"
        varchar(160) title "NOT NULL"
        json data "NOT NULL"
        datetime(6) read_at "NULL"
        datetime(6) withdrawn_at "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% notification_attempts: Dependiente; modulo F/C
    notification_attempts["notification_attempts"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned notification_id FK, UK "NOT NULL; UQ(notification_id,channel,attempt_no); notifications.id"
        varchar(32) channel UK "NOT NULL; UQ(notification_id,channel,attempt_no)"
        tinyint_unsigned attempt_no UK "NOT NULL; UQ(notification_id,channel,attempt_no)"
        varchar(32) status "NOT NULL"
        datetime(6) scheduled_at "NOT NULL"
        datetime(6) attempted_at "NULL"
        varchar(80) failure_code "NULL"
        varchar(160) provider_reference "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% notification_preferences: Pivot; modulo F
    notification_preferences["notification_preferences"] {
        bigint_unsigned user_id PK, FK "NOT NULL; PK compuesta; users.id"
        varchar(32) channel PK "NOT NULL; PK compuesta"
        varchar(80) topic PK "NOT NULL; PK compuesta"
        tinyint_unsigned enabled "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% announcements: Dependiente; modulo F
    announcements["announcements"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(160) title "NOT NULL"
        text body "NOT NULL"
        bigint_unsigned image_id FK "NULL; media_files.id"
        varchar(2048) link_url "NULL"
        varchar(80) link_label "NULL"
        varchar(32) status "NOT NULL"
        datetime(6) starts_at "NULL"
        smallint_unsigned duration_days "NOT NULL"
        datetime(6) ends_at "NULL; GENERADA"
        int_unsigned priority "NOT NULL"
        bigint_unsigned created_by FK "NOT NULL; users.id"
        bigint_unsigned updated_by FK "NOT NULL; users.id"
        datetime(6) retired_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% announcement_audiences: Pivot; modulo F
    announcement_audiences["announcement_audiences"] {
        bigint_unsigned announcement_id PK, FK "NOT NULL; PK compuesta; announcements.id"
        bigint_unsigned role_id PK, FK "NOT NULL; PK compuesta; roles.id"
        datetime(6) created_at "NOT NULL"
    }

    %% rule_parameters: Independiente; modulo F
    rule_parameters["rule_parameters"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(80) code UK "NOT NULL"
        varchar(32) value_type "NOT NULL"
        varchar(30) unit "NOT NULL"
        text description "NOT NULL"
        decimal min_value "DECIMAL(14,4); NULL"
        decimal max_value "DECIMAL(14,4); NULL"
        tinyint_unsigned required "NOT NULL"
        tinyint_unsigned editable "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% rule_versions: Dependiente; modulo F
    rule_versions["rule_versions"] {
        bigint_unsigned id PK "NOT NULL; AI"
        int_unsigned version_no UK "NOT NULL"
        varchar(32) status "NOT NULL"
        bigint_unsigned created_by FK "NOT NULL; users.id"
        bigint_unsigned published_by FK "NULL; users.id"
        text change_reason "NOT NULL"
        datetime(6) effective_at "NULL"
        datetime(6) published_at "NULL"
        char(64) content_hash "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% rule_values: Pivot; modulo F
    rule_values["rule_values"] {
        bigint_unsigned rule_version_id PK, FK "NOT NULL; PK compuesta; rule_versions.id"
        bigint_unsigned parameter_id PK, FK "NOT NULL; PK compuesta; rule_parameters.id"
        json value_json "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% matching_weights: Dependiente; modulo F/B
    matching_weights["matching_weights"] {
        bigint_unsigned rule_version_id PK, FK "NOT NULL; rule_versions.id"
        decimal proximity_pct "DECIMAL(5,2); NOT NULL"
        decimal price_pct "DECIMAL(5,2); NOT NULL"
        decimal rating_pct "DECIMAL(5,2); NOT NULL"
        decimal experience_pct "DECIMAL(5,2); NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% support_tickets: Dependiente; modulo F
    support_tickets["support_tickets"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned opened_by FK "NOT NULL; users.id"
        bigint_unsigned request_id FK "NULL; service_requests.id"
        varchar(180) subject "NOT NULL"
        text description "NOT NULL"
        varchar(32) status "NOT NULL"
        varchar(32) priority "NOT NULL"
        bigint_unsigned assigned_admin_id FK "NULL; users.id"
        datetime(6) resolved_at "NULL"
        datetime(6) closed_at "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% support_ticket_updates: Dependiente; modulo F
    support_ticket_updates["support_ticket_updates"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned ticket_id FK "NOT NULL; support_tickets.id"
        bigint_unsigned author_id FK "NOT NULL; users.id"
        varchar(32) kind "NOT NULL"
        text body "NOT NULL"
        tinyint_unsigned is_internal "NOT NULL"
        varchar(32) new_status "NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% support_attachments: Pivot; modulo F
    support_attachments["support_attachments"] {
        bigint_unsigned ticket_id PK, FK "NOT NULL; PK compuesta; support_tickets.id"
        bigint_unsigned media_id PK, FK "NOT NULL; PK compuesta; media_files.id"
        bigint_unsigned uploaded_by FK "NOT NULL; users.id"
        datetime(6) created_at "NOT NULL"
    }

    %% audit_entries: Polimórfica; modulo F
    audit_entries["audit_entries"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned actor_id FK "NULL; users.id"
        varchar(32) actor_kind "NOT NULL"
        varchar(100) action "NOT NULL"
        varchar(100) permission_used "NULL"
        varchar(60) subject_type "NOT NULL; polimorfico SIN FK"
        bigint_unsigned subject_id "NULL; polimorfico SIN FK"
        text reason "NOT NULL"
        json before_values "NULL"
        json after_values "NULL"
        varchar(64) correlation_id "NOT NULL"
        datetime(6) occurred_at "NOT NULL"
        varchar(100) source_code "NULL"
    }

    %% operations: Dependiente; modulo F
    operations["operations"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned requested_by FK "NOT NULL; users.id"
        varchar(60) type "NOT NULL"
        varchar(32) status "NOT NULL"
        json parameters "NOT NULL"
        datetime(6) started_at "NULL"
        datetime(6) finished_at "NULL"
        varchar(80) failure_code "NULL"
        int_unsigned version "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% export_files: Dependiente; modulo F
    export_files["export_files"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned operation_id FK, UK "NOT NULL; operations.id"
        bigint_unsigned media_id FK, UK "NOT NULL; media_files.id"
        varchar(32) format "NOT NULL"
        datetime(6) expires_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
    }

    %% outbox_events: Polimórfica; modulo F/transversal
    outbox_events["outbox_events"] {
        bigint_unsigned id PK "NOT NULL; AI"
        char(36) event_uuid UK "NOT NULL"
        varchar(100) event_type "NOT NULL"
        varchar(60) aggregate_type "NOT NULL; polimorfico SIN FK"
        bigint_unsigned aggregate_id "NOT NULL; polimorfico SIN FK"
        int_unsigned aggregate_version "NOT NULL"
        int_unsigned schema_version "NOT NULL"
        json payload "NOT NULL"
        datetime(6) occurred_at "NOT NULL"
        datetime(6) available_at "NOT NULL"
        varchar(32) status "NOT NULL"
        datetime(6) published_at "NULL"
        int_unsigned attempts "NOT NULL"
    }

    %% outbox_deliveries: Pivot; modulo F
    outbox_deliveries["outbox_deliveries"] {
        bigint_unsigned outbox_event_id PK, FK "NOT NULL; PK compuesta; outbox_events.id"
        bigint_unsigned recipient_id PK, FK "NOT NULL; PK compuesta; users.id"
        varchar(32) status "NOT NULL"
        int_unsigned attempts "NOT NULL"
        datetime(6) next_attempt_at "NULL"
        datetime(6) sent_at "NULL"
        varchar(80) failure_code "NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% idempotency_records: Dependiente; modulo F/transversal
    idempotency_records["idempotency_records"] {
        bigint_unsigned id PK "NOT NULL; AI"
        bigint_unsigned user_id FK, UK "NOT NULL; UQ(user_id,operation,key_hash); users.id"
        varchar(160) operation UK "NOT NULL; UQ(user_id,operation,key_hash)"
        char(64) key_hash UK "NOT NULL; UQ(user_id,operation,key_hash)"
        char(64) request_hash "NOT NULL"
        varchar(32) status "NOT NULL"
        smallint_unsigned response_status "NULL"
        json response_body "NULL"
        datetime(6) expires_at "NOT NULL"
        datetime(6) created_at "NOT NULL"
        datetime(6) updated_at "NOT NULL"
    }

    %% jobs: Independiente; modulo Infraestructura
    jobs["jobs"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(255) queue "NOT NULL"
        longtext payload "NOT NULL"
        tinyint_unsigned attempts "NOT NULL"
        int_unsigned reserved_at "NULL"
        int_unsigned available_at "NOT NULL"
        int_unsigned created_at "NOT NULL"
    }

    %% failed_jobs: Independiente; modulo Infraestructura
    failed_jobs["failed_jobs"] {
        bigint_unsigned id PK "NOT NULL; AI"
        varchar(255) uuid UK "NOT NULL"
        text connection "NOT NULL"
        text queue "NOT NULL"
        longtext payload "NOT NULL"
        longtext exception "NOT NULL"
        datetime(6) failed_at "NOT NULL"
    }

    %% cache: Independiente; modulo Infraestructura
    cache["cache"] {
        varchar(255) key PK "NOT NULL"
        mediumtext value "NOT NULL"
        int expiration "NOT NULL"
    }

    %% cache_locks: Independiente; modulo Infraestructura
    cache_locks["cache_locks"] {
        varchar(255) key PK "NOT NULL"
        varchar(255) owner "NOT NULL"
        int expiration "NOT NULL"
    }

    %% migrations: Independiente; modulo Infraestructura
    migrations["migrations"] {
        int_unsigned id PK "NOT NULL; AI"
        varchar(255) migration "NOT NULL"
        int batch "NOT NULL"
    }

    %% Entidades compartidas: solo identificador; definicion completa en su diagrama propietario.
    %% media_files: Dependiente; modulo F
    media_files["media_files (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% offers: Dependiente; modulo C
    offers["offers (ref. D2)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D2"
    }

    %% participations: Dependiente; modulo D
    participations["participations (ref. D2)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D2"
    }

    %% roles: Independiente; modulo F
    roles["roles (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% service_requests: Dependiente; modulo A/D
    service_requests["service_requests (ref. D2)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D2"
    }

    %% users: Dependiente; modulo F
    users["users (ref. D1)"] {
        bigint_unsigned id PK "NOT NULL; AI; referencia D1"
    }

    %% Vista derivada: NO tabla, NO PK/FK propias, NO escritura directa.
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
    }

    %% Relaciones fisicas: cada linea corresponde a una FK del diccionario.
    participations ||..o| ratings : "FK participation_id"
    users ||..o{ ratings : "FK author_id"
    ratings ||..o{ rating_versions : "FK rating_id"
    users ||..o{ rating_versions : "FK changed_by"
    ratings ||..o| rating_replies : "FK rating_id"
    users ||..o{ rating_replies : "FK author_id"
    ratings ||..o{ rating_appeals : "FK rating_id"
    users ||..o{ rating_appeals : "FK submitted_by"
    rating_versions ||..o{ rating_appeals : "FK submitted_version_id"
    rating_appeals ||--o{ appeal_evidence : "FK appeal_id"
    media_files ||--o{ appeal_evidence : "FK media_id"
    rating_appeals ||..o| rating_resolutions : "FK appeal_id"
    rating_versions ||..o{ rating_resolutions : "FK reviewed_version_id"
    users ||..o{ rating_resolutions : "FK resolved_by"
    rating_versions |o..o{ rating_resolutions : "FK result_version_id"
    users ||..o{ notifications : "FK recipient_id"
    notifications ||..o{ notification_attempts : "FK notification_id"
    users ||--o{ notification_preferences : "FK user_id"
    media_files |o..o{ announcements : "FK image_id"
    users ||..o{ announcements : "FK created_by"
    users ||..o{ announcements : "FK updated_by"
    announcements ||--o{ announcement_audiences : "FK announcement_id"
    roles ||--o{ announcement_audiences : "FK role_id"
    users ||..o{ rule_versions : "FK created_by"
    users |o..o{ rule_versions : "FK published_by"
    rule_versions ||--o{ rule_values : "FK rule_version_id"
    rule_parameters ||--o{ rule_values : "FK parameter_id"
    rule_versions ||--o| matching_weights : "FK rule_version_id"
    users ||..o{ support_tickets : "FK opened_by"
    service_requests |o..o{ support_tickets : "FK request_id"
    users |o..o{ support_tickets : "FK assigned_admin_id"
    support_tickets ||..o{ support_ticket_updates : "FK ticket_id"
    users ||..o{ support_ticket_updates : "FK author_id"
    support_tickets ||--o{ support_attachments : "FK ticket_id"
    media_files ||--o{ support_attachments : "FK media_id"
    users ||..o{ support_attachments : "FK uploaded_by"
    users |o..o{ audit_entries : "FK actor_id"
    users ||..o{ operations : "FK requested_by"
    operations ||..o| export_files : "FK operation_id"
    media_files ||..o| export_files : "FK media_id"
    outbox_events ||--o{ outbox_deliveries : "FK outbox_event_id"
    users ||--o{ outbox_deliveries : "FK recipient_id"
    users ||..o{ idempotency_records : "FK user_id"

    %% Polimorfismo XOR: cada notificacion apunta a UN destino segun subject_type.
    %% 0..1 por alternativa; exactamente un destino en conjunto. Sin FK nativa.
    service_requests |o..o{ notifications : "POLI XOR request"
    offers |o..o{ notifications : "POLI XOR offer"
    participations |o..o{ notifications : "POLI XOR participation"
    ratings |o..o{ notifications : "POLI XOR rating"
    rating_appeals |o..o{ notifications : "POLI XOR appeal"
    announcements |o..o{ notifications : "POLI XOR announcement"
    support_tickets |o..o{ notifications : "POLI XOR support_ticket"

    %% Derivacion de vista, no relaciones FK.
    service_requests ||..|{ v_service_history : "DERIVA solicitud"
    participations |o..|| v_service_history : "DERIVA participacion"
    ratings |o..|| v_service_history : "DERIVA resena"
```

## Relaciones que requieren lectura adicional

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

