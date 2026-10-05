-- TécnicoYa Huancayo: MySQL 8.4 / InnoDB. DISEÑO PROPUESTO, NO EJECUTADO.
-- No ejecutar en una base existente. Revisar pendientes del documento y generar migraciones.
-- Sin CREATE DATABASE, USE, DROP, datos personales ni credenciales.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_as_cs;
SET time_zone = '+00:00';

-- Independiente / F: Roles base del producto.
CREATE TABLE `roles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(40) NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_roles_code` (`code`),
  CONSTRAINT `ck_roles_1` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / F: Acciones autorizables.
CREATE TABLE `permissions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_permissions_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Identidad y acceso; no contiene datos específicos de atención.
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(254) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email_verified_at` DATETIME(6) NULL,
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `auth_version` INT UNSIGNED NOT NULL DEFAULT 1,
  `anonymized_at` DATETIME(6) NULL,
  `remember_token` VARCHAR(100) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `ix_users_role_id_is_active` (`role_id`, `is_active`),
  CONSTRAINT `ck_users_1` CHECK (`is_active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Relación muchos a muchos entre rol y permiso.
CREATE TABLE `role_permissions` (
  `role_id` BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `ix_role_permissions_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Permisos excepcionales de administración por usuario.
CREATE TABLE `user_permissions` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  `granted_by` BIGINT UNSIGNED NOT NULL,
  `granted_at` DATETIME(6) NOT NULL,
  PRIMARY KEY (`user_id`, `permission_id`),
  KEY `ix_user_permissions_permission_id` (`permission_id`),
  KEY `ix_user_permissions_granted_by` (`granted_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Datos del cliente MYPE u hogar.
CREATE TABLE `client_profiles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `client_type` VARCHAR(32) NOT NULL,
  `business_name` VARCHAR(180) NULL,
  `default_district_id` BIGINT UNSIGNED NULL,
  `default_address` TEXT NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_client_profiles_user_id` (`user_id`),
  KEY `ix_client_profiles_default_district_id` (`default_district_id`),
  CONSTRAINT `ck_client_profiles_1` CHECK (`client_type` IN ('household','mype'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Historial explícito de bloqueos y levantamientos.
CREATE TABLE `client_blocks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` BIGINT UNSIGNED NOT NULL,
  `blocked_by` BIGINT UNSIGNED NOT NULL,
  `reason` TEXT NOT NULL,
  `blocked_at` DATETIME(6) NOT NULL,
  `expires_at` DATETIME(6) NULL,
  `lifted_by` BIGINT UNSIGNED NULL,
  `lifted_at` DATETIME(6) NULL,
  `lift_reason` TEXT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'active',
  `active_client_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status = 'active' THEN client_id ELSE NULL END) STORED,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_client_blocks_active_client_id` (`active_client_id`),
  KEY `ix_client_blocks_client_id_blocked_at` (`client_id`, `blocked_at`),
  KEY `ix_client_blocks_status_expires_at` (`status`, `expires_at`),
  KEY `ix_client_blocks_blocked_by` (`blocked_by`),
  KEY `ix_client_blocks_lifted_by` (`lifted_by`),
  CONSTRAINT `ck_client_blocks_1` CHECK (`status` IN ('active','lifted','expired')),
  CONSTRAINT `ck_client_blocks_2` CHECK (expires_at IS NULL OR expires_at > blocked_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F/A: Prestador independiente o empresa de una cuenta.
CREATE TABLE `technician_profiles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `provider_type` VARCHAR(32) NOT NULL DEFAULT 'independent',
  `display_name` VARCHAR(180) NOT NULL,
  `bio` TEXT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending_verification',
  `verification_status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `experience_years` INT UNSIGNED NOT NULL DEFAULT 0,
  `primary_district_id` BIGINT UNSIGNED NULL,
  `available_now` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `whatsapp` VARCHAR(20) NULL,
  `verified_at` DATETIME(6) NULL,
  `verified_by` BIGINT UNSIGNED NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_technician_profiles_user_id` (`user_id`),
  KEY `ix_technician_profiles_status_verification_status_86ea8e11a5` (`status`, `verification_status`, `available_now`),
  KEY `ix_technician_profiles_primary_district_id` (`primary_district_id`),
  KEY `ix_technician_profiles_verified_by` (`verified_by`),
  CONSTRAINT `ck_technician_profiles_1` CHECK (`provider_type` IN ('independent','company')),
  CONSTRAINT `ck_technician_profiles_2` CHECK (`status` IN ('pending_verification','active','inactive','suspended')),
  CONSTRAINT `ck_technician_profiles_3` CHECK (`verification_status` IN ('pending','approved','rejected')),
  CONSTRAINT `ck_technician_profiles_4` CHECK (`available_now` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Decisiones de revisión del prestador, inmutables.
CREATE TABLE `technician_reviews` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `reviewer_id` BIGINT UNSIGNED NOT NULL,
  `decision` VARCHAR(32) NOT NULL,
  `reason` TEXT NOT NULL,
  `checklist` JSON NOT NULL,
  `reviewed_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_technician_reviews_technician_id_reviewed_at` (`technician_id`, `reviewed_at`),
  KEY `ix_technician_reviews_reviewer_id` (`reviewer_id`),
  CONSTRAINT `ck_technician_reviews_1` CHECK (`decision` IN ('approve','reject','request_changes'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Cambios operativos y motivos de suspensión.
CREATE TABLE `technician_status_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `actor_id` BIGINT UNSIGNED NOT NULL,
  `from_status` VARCHAR(32) NOT NULL,
  `to_status` VARCHAR(32) NOT NULL,
  `reason` TEXT NOT NULL,
  `occurred_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_technician_status_events_technician_id_occurred_at` (`technician_id`, `occurred_at`),
  KEY `ix_technician_status_events_actor_id` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Metadatos de archivo; los bytes se guardan fuera de MySQL.
CREATE TABLE `media_files` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `owner_id` BIGINT UNSIGNED NOT NULL,
  `disk` VARCHAR(40) NOT NULL,
  `storage_key` VARCHAR(255) NOT NULL,
  `original_name` VARCHAR(255) NOT NULL,
  `mime_type` VARCHAR(120) NOT NULL,
  `byte_size` BIGINT UNSIGNED NOT NULL,
  `sha256` CHAR(64) NOT NULL,
  `visibility` VARCHAR(32) NOT NULL DEFAULT 'private',
  `scan_status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `retired_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_media_files_disk_storage_key` (`disk`, `storage_key`),
  KEY `ix_media_files_owner_id_created_at` (`owner_id`, `created_at`),
  KEY `ix_media_files_scan_status_created_at` (`scan_status`, `created_at`),
  CONSTRAINT `ck_media_files_1` CHECK (`visibility` IN ('private','public')),
  CONSTRAINT `ck_media_files_2` CHECK (`scan_status` IN ('pending','clean','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Documento privado presentado para verificación.
CREATE TABLE `technician_documents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `document_type` VARCHAR(60) NOT NULL,
  `review_status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `reviewed_by` BIGINT UNSIGNED NULL,
  `reviewed_at` DATETIME(6) NULL,
  `review_note` TEXT NULL,
  `valid_until` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_technician_documents_media_id` (`media_id`),
  KEY `ix_technician_documents_technician_id_review_status` (`technician_id`, `review_status`),
  KEY `ix_technician_documents_reviewed_by` (`reviewed_by`),
  CONSTRAINT `ck_technician_documents_1` CHECK (`review_status` IN ('pending','approved','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Documentos efectivamente examinados en una revisión.
CREATE TABLE `review_documents` (
  `review_id` BIGINT UNSIGNED NOT NULL,
  `document_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`review_id`, `document_id`),
  KEY `ix_review_documents_document_id` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Trabajo publicado en el portafolio del técnico.
CREATE TABLE `portfolio_items` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `subcategory_id` BIGINT UNSIGNED NULL,
  `title` VARCHAR(160) NOT NULL,
  `description` TEXT NULL,
  `performed_on` DATE NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'draft',
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_portfolio_items_technician_id_status_created_at` (`technician_id`, `status`, `created_at`),
  KEY `ix_portfolio_items_subcategory_id` (`subcategory_id`),
  CONSTRAINT `ck_portfolio_items_1` CHECK (`status` IN ('draft','published','retired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Galería ordenada de imágenes de un trabajo.
CREATE TABLE `portfolio_images` (
  `portfolio_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `position` INT UNSIGNED NOT NULL DEFAULT 0,
  `caption` VARCHAR(180) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`portfolio_id`, `media_id`),
  UNIQUE KEY `uq_portfolio_images_portfolio_id_position` (`portfolio_id`, `position`),
  KEY `ix_portfolio_images_media_id` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / F: Tres especialidades base del marketplace.
CREATE TABLE `specialties` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(40) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `description` TEXT NULL,
  `hero_media_id` BIGINT UNSIGNED NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_specialties_code` (`code`),
  KEY `ix_specialties_active_display_order` (`active`, `display_order`),
  KEY `ix_specialties_hero_media_id` (`hero_media_id`),
  CONSTRAINT `ck_specialties_1` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F/A: Catálogo de aproximadamente 30 servicios con foto del carrusel.
CREATE TABLE `subcategories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `specialty_id` BIGINT UNSIGNED NOT NULL,
  `code` VARCHAR(80) NOT NULL,
  `name` VARCHAR(180) NOT NULL,
  `description` TEXT NULL,
  `carousel_media_id` BIGINT UNSIGNED NULL,
  `reference_fee` DECIMAL(12,2) NULL,
  `currency` CHAR(3) NOT NULL DEFAULT 'PEN',
  `estimated_minutes` INT UNSIGNED NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subcategories_code` (`code`),
  UNIQUE KEY `uq_subcategories_specialty_id_name` (`specialty_id`, `name`),
  KEY `ix_subcategories_specialty_id_active_display_order` (`specialty_id`, `active`, `display_order`),
  KEY `ix_subcategories_carousel_media_id` (`carousel_media_id`),
  CONSTRAINT `ck_subcategories_1` CHECK (`reference_fee` >= 0),
  CONSTRAINT `ck_subcategories_2` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / F/A: Cobertura por distritos, sin geolocalización personal.
CREATE TABLE `districts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(12) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_districts_code` (`code`),
  UNIQUE KEY `uq_districts_name` (`name`),
  CONSTRAINT `ck_districts_1` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / B: Referencia dirigida de distancia aproximada entre centros de distrito.
CREATE TABLE `district_distances` (
  `from_district_id` BIGINT UNSIGNED NOT NULL,
  `to_district_id` BIGINT UNSIGNED NOT NULL,
  `distance_km` DECIMAL(8,3) NOT NULL,
  `source` VARCHAR(255) NOT NULL,
  `measured_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`from_district_id`, `to_district_id`),
  KEY `ix_district_distances_to_district_id` (`to_district_id`),
  CONSTRAINT `ck_district_distances_1` CHECK (distance_km >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / A/F: Especialidades declaradas y revisadas del técnico.
CREATE TABLE `technician_specialties` (
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `specialty_id` BIGINT UNSIGNED NOT NULL,
  `verification_status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `reviewed_by` BIGINT UNSIGNED NULL,
  `reviewed_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`technician_id`, `specialty_id`),
  KEY `ix_technician_specialties_specialty_id` (`specialty_id`),
  KEY `ix_technician_specialties_reviewed_by` (`reviewed_by`),
  CONSTRAINT `ck_technician_specialties_1` CHECK (`verification_status` IN ('pending','approved','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / A/B: Relación técnico-subcategoría con condiciones y tarifa vigente.
CREATE TABLE `technician_services` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `subcategory_id` BIGINT UNSIGNED NOT NULL,
  `reference_fee` DECIMAL(12,2) NOT NULL,
  `currency` CHAR(3) NOT NULL DEFAULT 'PEN',
  `experience_years` INT UNSIGNED NOT NULL DEFAULT 0,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `current_rate_version` INT UNSIGNED NOT NULL DEFAULT 1,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_technician_services_technician_id_subcategory_id` (`technician_id`, `subcategory_id`),
  KEY `ix_technician_services_subcategory_id_active_technician_id` (`subcategory_id`, `active`, `technician_id`),
  CONSTRAINT `ck_technician_services_1` CHECK (`reference_fee` >= 0),
  CONSTRAINT `ck_technician_services_2` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / A/F: Historial inmutable de tarifas declaradas.
CREATE TABLE `service_rate_versions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_service_id` BIGINT UNSIGNED NOT NULL,
  `version_no` INT UNSIGNED NOT NULL,
  `reference_fee` DECIMAL(12,2) NOT NULL,
  `currency` CHAR(3) NOT NULL,
  `changed_by` BIGINT UNSIGNED NOT NULL,
  `reason` TEXT NULL,
  `effective_from` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_service_rate_versions_technician_service_id_version_no` (`technician_service_id`, `version_no`),
  KEY `ix_service_rate_versions_technician_service_id_ef_705262497c` (`technician_service_id`, `effective_from`),
  KEY `ix_service_rate_versions_changed_by` (`changed_by`),
  CONSTRAINT `ck_service_rate_versions_1` CHECK (`reference_fee` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / A/B: Distritos atendidos por técnico.
CREATE TABLE `technician_districts` (
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `district_id` BIGINT UNSIGNED NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`technician_id`, `district_id`),
  KEY `ix_technician_districts_district_id` (`district_id`),
  CONSTRAINT `ck_technician_districts_1` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / A/D: Horario declarado recurrente o franja puntual.
CREATE TABLE `availability_slots` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `kind` VARCHAR(32) NOT NULL,
  `weekday` TINYINT UNSIGNED NULL,
  `local_start` TIME NULL,
  `local_end` TIME NULL,
  `valid_from` DATE NULL,
  `valid_until` DATE NULL,
  `starts_at` DATETIME(6) NULL,
  `ends_at` DATETIME(6) NULL,
  `timezone` VARCHAR(60) NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_availability_slots_technician_id_active_weekday` (`technician_id`, `active`, `weekday`),
  KEY `ix_availability_slots_technician_id_starts_at` (`technician_id`, `starts_at`),
  CONSTRAINT `ck_availability_slots_1` CHECK (`kind` IN ('weekly','one_off')),
  CONSTRAINT `ck_availability_slots_2` CHECK (weekday BETWEEN 1 AND 7),
  CONSTRAINT `ck_availability_slots_3` CHECK (`active` IN (0,1)),
  CONSTRAINT `ck_availability_slots_4` CHECK ((kind='weekly' AND weekday IS NOT NULL AND local_start IS NOT NULL AND local_end IS NOT NULL AND local_end>local_start AND valid_from IS NOT NULL AND starts_at IS NULL AND ends_at IS NULL) OR (kind='one_off' AND weekday IS NULL AND local_start IS NULL AND local_end IS NULL AND valid_from IS NULL AND valid_until IS NULL AND starts_at IS NOT NULL AND ends_at IS NOT NULL AND ends_at>starts_at)),
  CONSTRAINT `ck_availability_slots_5` CHECK (valid_until IS NULL OR valid_until >= valid_from)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / A/B: Pausas temporales de recepción de trabajo.
CREATE TABLE `technician_pauses` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `starts_at` DATETIME(6) NOT NULL,
  `ends_at` DATETIME(6) NULL,
  `cancelled_at` DATETIME(6) NULL,
  `reason` VARCHAR(255) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_technician_pauses_technician_id_starts_at_ends_at` (`technician_id`, `starts_at`, `ends_at`),
  CONSTRAINT `ck_technician_pauses_1` CHECK (ends_at IS NULL OR ends_at > starts_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / F: Definiciones de parámetros editables del negocio.
CREATE TABLE `rule_parameters` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(80) NOT NULL,
  `value_type` VARCHAR(32) NOT NULL,
  `unit` VARCHAR(30) NOT NULL,
  `description` TEXT NOT NULL,
  `min_value` DECIMAL(14,4) NULL,
  `max_value` DECIMAL(14,4) NULL,
  `required` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `editable` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rule_parameters_code` (`code`),
  CONSTRAINT `ck_rule_parameters_1` CHECK (`value_type` IN ('integer','decimal','boolean','string')),
  CONSTRAINT `ck_rule_parameters_2` CHECK (`required` IN (0,1)),
  CONSTRAINT `ck_rule_parameters_3` CHECK (`editable` IN (0,1)),
  CONSTRAINT `ck_rule_parameters_4` CHECK (min_value IS NULL OR max_value IS NULL OR min_value <= max_value)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Versiones de configuración; publicación no sobrescribe anteriores.
CREATE TABLE `rule_versions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `version_no` INT UNSIGNED NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'draft',
  `created_by` BIGINT UNSIGNED NOT NULL,
  `published_by` BIGINT UNSIGNED NULL,
  `change_reason` TEXT NOT NULL,
  `effective_at` DATETIME(6) NULL,
  `published_at` DATETIME(6) NULL,
  `content_hash` CHAR(64) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rule_versions_version_no` (`version_no`),
  KEY `ix_rule_versions_status_effective_at` (`status`, `effective_at`),
  KEY `ix_rule_versions_created_by` (`created_by`),
  KEY `ix_rule_versions_published_by` (`published_by`),
  CONSTRAINT `ck_rule_versions_1` CHECK (`status` IN ('draft','published','retired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Valor de cada parámetro dentro de una versión.
CREATE TABLE `rule_values` (
  `rule_version_id` BIGINT UNSIGNED NOT NULL,
  `parameter_id` BIGINT UNSIGNED NOT NULL,
  `value_json` JSON NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`rule_version_id`, `parameter_id`),
  KEY `ix_rule_values_parameter_id` (`parameter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F/B: Los cuatro pesos de una versión; suma comprobable en una fila.
CREATE TABLE `matching_weights` (
  `rule_version_id` BIGINT UNSIGNED NOT NULL,
  `proximity_pct` DECIMAL(5,2) NOT NULL,
  `price_pct` DECIMAL(5,2) NOT NULL,
  `rating_pct` DECIMAL(5,2) NOT NULL,
  `experience_pct` DECIMAL(5,2) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`rule_version_id`),
  CONSTRAINT `ck_matching_weights_1` CHECK (proximity_pct BETWEEN 0 AND 100),
  CONSTRAINT `ck_matching_weights_2` CHECK (price_pct BETWEEN 0 AND 100),
  CONSTRAINT `ck_matching_weights_3` CHECK (rating_pct BETWEEN 0 AND 100),
  CONSTRAINT `ck_matching_weights_4` CHECK (experience_pct BETWEEN 0 AND 100),
  CONSTRAINT `ck_matching_weights_5` CHECK (proximity_pct + price_pct + rating_pct + experience_pct = 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / A/D: Solicitud del cliente; datos privados y fotografía de tarifa/reglas.
CREATE TABLE `service_requests` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` BIGINT UNSIGNED NOT NULL,
  `subcategory_id` BIGINT UNSIGNED NOT NULL,
  `district_id` BIGINT UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `address` TEXT NOT NULL,
  `mode` VARCHAR(32) NOT NULL DEFAULT 'asap',
  `preferred_start_at` DATETIME(6) NULL,
  `preferred_end_at` DATETIME(6) NULL,
  `source` VARCHAR(32) NOT NULL DEFAULT 'automatic',
  `target_technician_id` BIGINT UNSIGNED NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'registered',
  `reference_fee_snapshot` DECIMAL(12,2) NULL,
  `currency` CHAR(3) NOT NULL DEFAULT 'PEN',
  `rule_version_id` BIGINT UNSIGNED NULL,
  `submitted_at` DATETIME(6) NULL,
  `pending_since` DATETIME(6) NULL,
  `pending_expires_at` DATETIME(6) NULL,
  `search_generation` INT UNSIGNED NOT NULL DEFAULT 0,
  `cancelled_at` DATETIME(6) NULL,
  `cancellation_reason` TEXT NULL,
  `closed_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_service_requests_client_id_created_at` (`client_id`, `created_at`),
  KEY `ix_service_requests_status_pending_expires_at` (`status`, `pending_expires_at`),
  KEY `ix_service_requests_subcategory_id_district_id_status` (`subcategory_id`, `district_id`, `status`),
  KEY `ix_service_requests_district_id` (`district_id`),
  KEY `ix_service_requests_target_technician_id` (`target_technician_id`),
  KEY `ix_service_requests_rule_version_id` (`rule_version_id`),
  CONSTRAINT `ck_service_requests_1` CHECK (`mode` IN ('asap','scheduled')),
  CONSTRAINT `ck_service_requests_2` CHECK (`source` IN ('automatic','profile')),
  CONSTRAINT `ck_service_requests_3` CHECK (`status` IN ('registered','sent','pending_availability','assigned','in_progress','completed','closed','unrated','cancelled','expired')),
  CONSTRAINT `ck_service_requests_4` CHECK (`reference_fee_snapshot` >= 0),
  CONSTRAINT `ck_service_requests_5` CHECK ((mode='asap' AND preferred_start_at IS NULL AND preferred_end_at IS NULL) OR (mode='scheduled' AND preferred_start_at IS NOT NULL AND preferred_end_at IS NOT NULL AND preferred_end_at>preferred_start_at)),
  CONSTRAINT `ck_service_requests_6` CHECK ((source='automatic' AND target_technician_id IS NULL) OR (source='profile' AND target_technician_id IS NOT NULL)),
  CONSTRAINT `ck_service_requests_7` CHECK ((pending_since IS NULL AND pending_expires_at IS NULL) OR (pending_since IS NOT NULL AND pending_expires_at IS NOT NULL AND pending_expires_at > pending_since))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / A: Galería de evidencias de la falla.
CREATE TABLE `request_attachments` (
  `request_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `uploaded_by` BIGINT UNSIGNED NOT NULL,
  `position` INT UNSIGNED NOT NULL DEFAULT 0,
  `caption` VARCHAR(180) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`request_id`, `media_id`),
  UNIQUE KEY `uq_request_attachments_request_id_position` (`request_id`, `position`),
  KEY `ix_request_attachments_media_id` (`media_id`),
  KEY `ix_request_attachments_uploaded_by` (`uploaded_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Historial cronológico del servicio, append-only.
CREATE TABLE `request_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `actor_id` BIGINT UNSIGNED NULL,
  `event_type` VARCHAR(80) NOT NULL,
  `from_status` VARCHAR(32) NULL,
  `to_status` VARCHAR(32) NULL,
  `summary` TEXT NOT NULL,
  `metadata` JSON NULL,
  `occurred_at` DATETIME(6) NOT NULL,
  `correlation_id` VARCHAR(64) NOT NULL,
  `request_version` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_request_events_request_id_occurred_at_id` (`request_id`, `occurred_at`, `id`),
  KEY `ix_request_events_actor_id` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / B: Ejecución reproducible del ranking.
CREATE TABLE `matching_runs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `rule_version_id` BIGINT UNSIGNED NOT NULL,
  `generation` INT UNSIGNED NOT NULL,
  `started_at` DATETIME(6) NOT NULL,
  `finished_at` DATETIME(6) NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'running',
  `rules_snapshot` JSON NOT NULL,
  `algorithm_version` VARCHAR(60) NOT NULL,
  `duration_ms` INT UNSIGNED NULL,
  `failure_code` VARCHAR(80) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_matching_runs_request_id_generation` (`request_id`, `generation`),
  KEY `ix_matching_runs_status_started_at` (`status`, `started_at`),
  KEY `ix_matching_runs_rule_version_id` (`rule_version_id`),
  CONSTRAINT `ck_matching_runs_1` CHECK (`status` IN ('running','completed','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / B: Factores y posición de un técnico en una ejecución.
CREATE TABLE `matching_candidates` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `matching_run_id` BIGINT UNSIGNED NOT NULL,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `technician_service_id` BIGINT UNSIGNED NOT NULL,
  `eligible` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `exclusion_code` VARCHAR(80) NULL,
  `proximity_factor` DECIMAL(9,6) NULL,
  `price_factor` DECIMAL(9,6) NULL,
  `rating_factor` DECIMAL(9,6) NULL,
  `experience_factor` DECIMAL(9,6) NULL,
  `score` DECIMAL(9,6) NULL,
  `rank_position` INT UNSIGNED NULL,
  `input_snapshot` JSON NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_matching_candidates_matching_run_id_technician_id` (`matching_run_id`, `technician_id`),
  UNIQUE KEY `uq_matching_candidates_matching_run_id_rank_position` (`matching_run_id`, `rank_position`),
  KEY `ix_matching_candidates_matching_run_id_eligible_score` (`matching_run_id`, `eligible`, `score`),
  KEY `ix_matching_candidates_technician_id` (`technician_id`),
  KEY `ix_matching_candidates_technician_service_id` (`technician_service_id`),
  CONSTRAINT `ck_matching_candidates_1` CHECK (`eligible` IN (0,1)),
  CONSTRAINT `ck_matching_candidates_2` CHECK (proximity_factor BETWEEN 0 AND 1),
  CONSTRAINT `ck_matching_candidates_3` CHECK (price_factor BETWEEN 0 AND 1),
  CONSTRAINT `ck_matching_candidates_4` CHECK (rating_factor BETWEEN 0 AND 1),
  CONSTRAINT `ck_matching_candidates_5` CHECK (experience_factor BETWEEN 0 AND 1),
  CONSTRAINT `ck_matching_candidates_6` CHECK (score BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / C: Ronda de invitaciones con versión de búsqueda y vencimiento.
CREATE TABLE `offer_rounds` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `matching_run_id` BIGINT UNSIGNED NULL,
  `round_no` INT UNSIGNED NOT NULL,
  `generation` INT UNSIGNED NOT NULL,
  `kind` VARCHAR(32) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'open',
  `opened_at` DATETIME(6) NOT NULL,
  `expires_at` DATETIME(6) NOT NULL,
  `closed_at` DATETIME(6) NULL,
  `active_request_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status IN ('open','awaiting_choice') AND kind <> 'additional' THEN request_id ELSE NULL END) STORED,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_offer_rounds_request_id_round_no` (`request_id`, `round_no`),
  UNIQUE KEY `uq_offer_rounds_active_request_id` (`active_request_id`),
  KEY `ix_offer_rounds_status_expires_at` (`status`, `expires_at`),
  KEY `ix_offer_rounds_matching_run_id` (`matching_run_id`),
  CONSTRAINT `ck_offer_rounds_1` CHECK (`kind` IN ('automatic','direct','manual','additional')),
  CONSTRAINT `ck_offer_rounds_2` CHECK (`status` IN ('open','awaiting_choice','closed','withdrawn')),
  CONSTRAINT `ck_offer_rounds_3` CHECK (expires_at > opened_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / C: Invitación individual; aceptación no equivale a asignación.
CREATE TABLE `offers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `round_id` BIGINT UNSIGNED NOT NULL,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `matching_candidate_id` BIGINT UNSIGNED NULL,
  `service_rate_version_id` BIGINT UNSIGNED NULL,
  `reference_fee_snapshot` DECIMAL(12,2) NOT NULL,
  `currency` CHAR(3) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `available_at` DATETIME(6) NOT NULL,
  `expires_at` DATETIME(6) NOT NULL,
  `responded_at` DATETIME(6) NULL,
  `response_reason` TEXT NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_offers_round_id_technician_id` (`round_id`, `technician_id`),
  KEY `ix_offers_technician_id_status_expires_at` (`technician_id`, `status`, `expires_at`),
  KEY `ix_offers_status_expires_at` (`status`, `expires_at`),
  KEY `ix_offers_matching_candidate_id` (`matching_candidate_id`),
  KEY `ix_offers_service_rate_version_id` (`service_rate_version_id`),
  CONSTRAINT `ck_offers_1` CHECK (`reference_fee_snapshot` >= 0),
  CONSTRAINT `ck_offers_2` CHECK (`status` IN ('pending','accepted','rejected','expired','withdrawn')),
  CONSTRAINT `ck_offers_3` CHECK (expires_at > available_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Propuesta de un único técnico adicional.
CREATE TABLE `additional_technician_proposals` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `proposed_by_participation_id` BIGINT UNSIGNED NOT NULL,
  `proposed_technician_id` BIGINT UNSIGNED NOT NULL,
  `reason` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending_client',
  `client_decided_by` BIGINT UNSIGNED NULL,
  `client_decided_at` DATETIME(6) NULL,
  `offer_id` BIGINT UNSIGNED NULL,
  `open_request_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status IN ('pending_client','approved','awaiting_technician') THEN request_id ELSE NULL END) STORED,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_additional_technician_proposals_open_request_id` (`open_request_id`),
  KEY `ix_additional_technician_proposals_request_id` (`request_id`),
  KEY `ix_additional_technician_proposals_proposed_by_pa_e82fed3fca` (`proposed_by_participation_id`),
  KEY `ix_additional_technician_proposals_proposed_technician_id` (`proposed_technician_id`),
  KEY `ix_additional_technician_proposals_client_decided_by` (`client_decided_by`),
  KEY `ix_additional_technician_proposals_offer_id` (`offer_id`),
  CONSTRAINT `ck_additional_technician_proposals_1` CHECK (`status` IN ('pending_client','rejected','approved','awaiting_technician','accepted','withdrawn'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Asignación/atención por técnico; permite principal y adicional, además de historial de sustituciones.
CREATE TABLE `participations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `offer_id` BIGINT UNSIGNED NOT NULL,
  `slot` VARCHAR(32) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'assigned',
  `authorized_by` BIGINT UNSIGNED NOT NULL,
  `assigned_at` DATETIME(6) NOT NULL,
  `started_at` DATETIME(6) NULL,
  `completed_at` DATETIME(6) NULL,
  `ended_at` DATETIME(6) NULL,
  `reference_fee_snapshot` DECIMAL(12,2) NOT NULL,
  `currency` CHAR(3) NOT NULL,
  `rating_status` VARCHAR(32) NOT NULL DEFAULT 'not_open',
  `rating_due_at` DATETIME(6) NULL,
  `replaces_id` BIGINT UNSIGNED NULL,
  `occupied_slot` VARCHAR(32) GENERATED ALWAYS AS (CASE WHEN status NOT IN ('cancelled','replaced') THEN slot ELSE NULL END) STORED,
  `current_technician_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status NOT IN ('cancelled','replaced') THEN technician_id ELSE NULL END) STORED,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_participations_offer_id` (`offer_id`),
  UNIQUE KEY `uq_participations_request_id_occupied_slot` (`request_id`, `occupied_slot`),
  UNIQUE KEY `uq_participations_request_id_current_technician_id` (`request_id`, `current_technician_id`),
  KEY `ix_participations_technician_id_status_assigned_at` (`technician_id`, `status`, `assigned_at`),
  KEY `ix_participations_rating_status_rating_due_at` (`rating_status`, `rating_due_at`),
  KEY `ix_participations_authorized_by` (`authorized_by`),
  KEY `ix_participations_replaces_id` (`replaces_id`),
  CONSTRAINT `ck_participations_1` CHECK (`slot` IN ('primary','additional')),
  CONSTRAINT `ck_participations_2` CHECK (`status` IN ('assigned','in_progress','completed','cancelled','replaced')),
  CONSTRAINT `ck_participations_3` CHECK (`reference_fee_snapshot` >= 0),
  CONSTRAINT `ck_participations_4` CHECK (`rating_status` IN ('not_open','open','rated','unrated')),
  CONSTRAINT `ck_participations_5` CHECK (completed_at IS NULL OR (started_at IS NOT NULL AND completed_at >= started_at)),
  CONSTRAINT `ck_participations_6` CHECK (rating_due_at IS NULL OR (completed_at IS NOT NULL AND rating_due_at > completed_at))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Reserva concreta de agenda vinculada a participación.
CREATE TABLE `appointments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `participation_id` BIGINT UNSIGNED NOT NULL,
  `technician_id` BIGINT UNSIGNED NOT NULL,
  `starts_at` DATETIME(6) NOT NULL,
  `ends_at` DATETIME(6) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'confirmed',
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_appointments_participation_id` (`participation_id`),
  KEY `ix_appointments_technician_id_status_starts_at_ends_at` (`technician_id`, `status`, `starts_at`, `ends_at`),
  CONSTRAINT `ck_appointments_1` CHECK (`status` IN ('confirmed','completed','cancelled')),
  CONSTRAINT `ck_appointments_2` CHECK (ends_at > starts_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Propuesta de nueva franja con copia de la anterior.
CREATE TABLE `reschedule_requests` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `appointment_id` BIGINT UNSIGNED NOT NULL,
  `proposed_by` BIGINT UNSIGNED NOT NULL,
  `original_start_at` DATETIME(6) NOT NULL,
  `original_end_at` DATETIME(6) NOT NULL,
  `proposed_start_at` DATETIME(6) NOT NULL,
  `proposed_end_at` DATETIME(6) NOT NULL,
  `reason` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `expires_at` DATETIME(6) NOT NULL,
  `resolved_at` DATETIME(6) NULL,
  `open_appointment_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status='pending' THEN appointment_id ELSE NULL END) STORED,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_reschedule_requests_open_appointment_id` (`open_appointment_id`),
  KEY `ix_reschedule_requests_status_expires_at` (`status`, `expires_at`),
  KEY `ix_reschedule_requests_appointment_id` (`appointment_id`),
  KEY `ix_reschedule_requests_proposed_by` (`proposed_by`),
  CONSTRAINT `ck_reschedule_requests_1` CHECK (`status` IN ('pending','accepted','rejected','expired','withdrawn')),
  CONSTRAINT `ck_reschedule_requests_2` CHECK (original_end_at > original_start_at),
  CONSTRAINT `ck_reschedule_requests_3` CHECK (proposed_end_at > proposed_start_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / D: Respuestas de las contrapartes requeridas para una reprogramación.
CREATE TABLE `reschedule_responses` (
  `reschedule_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `decision` VARCHAR(32) NOT NULL,
  `responded_at` DATETIME(6) NOT NULL,
  PRIMARY KEY (`reschedule_id`, `user_id`),
  KEY `ix_reschedule_responses_user_id` (`user_id`),
  CONSTRAINT `ck_reschedule_responses_1` CHECK (`decision` IN ('accept','reject'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D: Reporte de cierre de la atención de cada técnico.
CREATE TABLE `service_reports` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `participation_id` BIGINT UNSIGNED NOT NULL,
  `author_id` BIGINT UNSIGNED NOT NULL,
  `work_description` TEXT NOT NULL,
  `result_description` TEXT NOT NULL,
  `submitted_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_service_reports_participation_id` (`participation_id`),
  KEY `ix_service_reports_author_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / D: Galería privada de evidencias de la atención.
CREATE TABLE `service_report_evidence` (
  `report_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `position` INT UNSIGNED NOT NULL DEFAULT 0,
  `caption` VARCHAR(180) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`report_id`, `media_id`),
  UNIQUE KEY `uq_service_report_evidence_report_id_position` (`report_id`, `position`),
  KEY `ix_service_report_evidence_media_id` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / D/F: Inasistencia, cancelación técnica u otro problema de servicio.
CREATE TABLE `incidents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `participation_id` BIGINT UNSIGNED NULL,
  `reported_by` BIGINT UNSIGNED NOT NULL,
  `type` VARCHAR(60) NOT NULL,
  `description` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'open',
  `reviewed_by` BIGINT UNSIGNED NULL,
  `resolution` TEXT NULL,
  `resolved_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_incidents_request_id_created_at` (`request_id`, `created_at`),
  KEY `ix_incidents_status_created_at` (`status`, `created_at`),
  KEY `ix_incidents_participation_id` (`participation_id`),
  KEY `ix_incidents_reported_by` (`reported_by`),
  KEY `ix_incidents_reviewed_by` (`reviewed_by`),
  CONSTRAINT `ck_incidents_1` CHECK (`status` IN ('open','under_review','resolved','dismissed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / D/F: Archivos de respaldo de incidencia.
CREATE TABLE `incident_evidence` (
  `incident_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`incident_id`, `media_id`),
  KEY `ix_incident_evidence_media_id` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / C/F: Trazabilidad de reasignación automática o administrativa.
CREATE TABLE `reassignment_records` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `previous_participation_id` BIGINT UNSIGNED NULL,
  `new_participation_id` BIGINT UNSIGNED NULL,
  `target_technician_id` BIGINT UNSIGNED NULL,
  `actor_id` BIGINT UNSIGNED NULL,
  `origin` VARCHAR(32) NOT NULL,
  `reason` TEXT NOT NULL,
  `incident_id` BIGINT UNSIGNED NULL,
  `new_round_id` BIGINT UNSIGNED NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'awaiting_response',
  `resolved_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_reassignment_records_request_id_created_at` (`request_id`, `created_at`),
  KEY `ix_reassignment_records_origin_created_at` (`origin`, `created_at`),
  KEY `ix_reassignment_records_previous_participation_id` (`previous_participation_id`),
  KEY `ix_reassignment_records_new_participation_id` (`new_participation_id`),
  KEY `ix_reassignment_records_target_technician_id` (`target_technician_id`),
  KEY `ix_reassignment_records_actor_id` (`actor_id`),
  KEY `ix_reassignment_records_incident_id` (`incident_id`),
  KEY `ix_reassignment_records_new_round_id` (`new_round_id`),
  CONSTRAINT `ck_reassignment_records_1` CHECK (`origin` IN ('automatic','manual')),
  CONSTRAINT `ck_reassignment_records_2` CHECK (`status` IN ('awaiting_response','awaiting_choice','assigned','failed','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / E: Reseña y puntaje canónicos actuales de una participación.
CREATE TABLE `ratings` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `participation_id` BIGINT UNSIGNED NOT NULL,
  `author_id` BIGINT UNSIGNED NOT NULL,
  `score` TINYINT UNSIGNED NOT NULL,
  `comment` TEXT NOT NULL,
  `current_version_no` INT UNSIGNED NOT NULL DEFAULT 1,
  `status` VARCHAR(32) NOT NULL DEFAULT 'active',
  `first_rated_at` DATETIME(6) NOT NULL,
  `editable_until` DATETIME(6) NOT NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ratings_participation_id` (`participation_id`),
  KEY `ix_ratings_author_id_first_rated_at` (`author_id`, `first_rated_at`),
  CONSTRAINT `ck_ratings_1` CHECK (score BETWEEN 1 AND 5),
  CONSTRAINT `ck_ratings_2` CHECK (`status` IN ('active','annulled')),
  CONSTRAINT `ck_ratings_3` CHECK (editable_until > first_rated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / E: Contenido histórico inmutable de cada versión de reseña.
CREATE TABLE `rating_versions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating_id` BIGINT UNSIGNED NOT NULL,
  `version_no` INT UNSIGNED NOT NULL,
  `score` TINYINT UNSIGNED NOT NULL,
  `comment` TEXT NOT NULL,
  `changed_by` BIGINT UNSIGNED NOT NULL,
  `change_kind` VARCHAR(32) NOT NULL,
  `reason` TEXT NULL,
  `changed_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rating_versions_rating_id_version_no` (`rating_id`, `version_no`),
  KEY `ix_rating_versions_rating_id_changed_at` (`rating_id`, `changed_at`),
  KEY `ix_rating_versions_changed_by` (`changed_by`),
  CONSTRAINT `ck_rating_versions_1` CHECK (score BETWEEN 1 AND 5),
  CONSTRAINT `ck_rating_versions_2` CHECK (`change_kind` IN ('initial','client_edit','admin_adjust','admin_annul'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / E: Respuesta identificada del técnico a una reseña.
CREATE TABLE `rating_replies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating_id` BIGINT UNSIGNED NOT NULL,
  `author_id` BIGINT UNSIGNED NOT NULL,
  `text` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'published',
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rating_replies_rating_id` (`rating_id`),
  KEY `ix_rating_replies_author_id` (`author_id`),
  CONSTRAINT `ck_rating_replies_1` CHECK (`status` IN ('published','hidden'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / E: Solicitud de revisión de una calificación.
CREATE TABLE `rating_appeals` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rating_id` BIGINT UNSIGNED NOT NULL,
  `submitted_by` BIGINT UNSIGNED NOT NULL,
  `submitted_version_id` BIGINT UNSIGNED NOT NULL,
  `reason` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'open',
  `submitted_at` DATETIME(6) NOT NULL,
  `appeal_deadline_at` DATETIME(6) NULL,
  `open_rating_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status IN ('open','under_review') THEN rating_id ELSE NULL END) STORED,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rating_appeals_open_rating_id` (`open_rating_id`),
  KEY `ix_rating_appeals_status_submitted_at` (`status`, `submitted_at`),
  KEY `ix_rating_appeals_rating_id` (`rating_id`),
  KEY `ix_rating_appeals_submitted_by` (`submitted_by`),
  KEY `ix_rating_appeals_submitted_version_id` (`submitted_version_id`),
  CONSTRAINT `ck_rating_appeals_1` CHECK (`status` IN ('open','under_review','resolved','withdrawn'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / E: Archivos privados para sustentar una apelación.
CREATE TABLE `appeal_evidence` (
  `appeal_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`appeal_id`, `media_id`),
  KEY `ix_appeal_evidence_media_id` (`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / E/F: Resolución administrativa de apelación.
CREATE TABLE `rating_resolutions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `appeal_id` BIGINT UNSIGNED NOT NULL,
  `reviewed_version_id` BIGINT UNSIGNED NOT NULL,
  `resolved_by` BIGINT UNSIGNED NOT NULL,
  `decision` VARCHAR(32) NOT NULL,
  `reason` TEXT NOT NULL,
  `result_version_id` BIGINT UNSIGNED NULL,
  `resolved_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rating_resolutions_appeal_id` (`appeal_id`),
  KEY `ix_rating_resolutions_reviewed_version_id` (`reviewed_version_id`),
  KEY `ix_rating_resolutions_resolved_by` (`resolved_by`),
  KEY `ix_rating_resolutions_result_version_id` (`result_version_id`),
  CONSTRAINT `ck_rating_resolutions_1` CHECK (`decision` IN ('maintain','adjust','annul'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Polimórfica / F/C: Bandeja persistida por usuario, con referencia a distintos recursos del dominio.
CREATE TABLE `notifications` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_uuid` CHAR(36) NOT NULL,
  `recipient_id` BIGINT UNSIGNED NOT NULL,
  `event_type` VARCHAR(80) NOT NULL,
  `subject_type` VARCHAR(40) NOT NULL,
  `subject_id` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(160) NOT NULL,
  `data` JSON NOT NULL,
  `read_at` DATETIME(6) NULL,
  `withdrawn_at` DATETIME(6) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notifications_event_uuid_recipient_id` (`event_uuid`, `recipient_id`),
  KEY `ix_notifications_recipient_id_read_at_created_at` (`recipient_id`, `read_at`, `created_at`),
  KEY `ix_notifications_subject_type_subject_id` (`subject_type`, `subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F/C: Intentos de entrega por canal, independientes de lectura.
CREATE TABLE `notification_attempts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_id` BIGINT UNSIGNED NOT NULL,
  `channel` VARCHAR(32) NOT NULL,
  `attempt_no` TINYINT UNSIGNED NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'queued',
  `scheduled_at` DATETIME(6) NOT NULL,
  `attempted_at` DATETIME(6) NULL,
  `failure_code` VARCHAR(80) NULL,
  `provider_reference` VARCHAR(160) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_notification_attempts_notification_id_channel_attempt_no` (`notification_id`, `channel`, `attempt_no`),
  KEY `ix_notification_attempts_status_scheduled_at` (`status`, `scheduled_at`),
  CONSTRAINT `ck_notification_attempts_1` CHECK (`channel` IN ('in_app','email','push')),
  CONSTRAINT `ck_notification_attempts_2` CHECK (attempt_no BETWEEN 1 AND 4),
  CONSTRAINT `ck_notification_attempts_3` CHECK (`status` IN ('queued','delivered','failed','skipped'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Preferencias por usuario, canal y tipo de evento.
CREATE TABLE `notification_preferences` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `channel` VARCHAR(32) NOT NULL,
  `topic` VARCHAR(80) NOT NULL,
  `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`user_id`, `channel`, `topic`),
  CONSTRAINT `ck_notification_preferences_1` CHECK (`channel` IN ('in_app','email','push')),
  CONSTRAINT `ck_notification_preferences_2` CHECK (`enabled` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Comunicados con imagen y vigencia.
CREATE TABLE `announcements` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(160) NOT NULL,
  `body` TEXT NOT NULL,
  `image_id` BIGINT UNSIGNED NULL,
  `link_url` VARCHAR(2048) NULL,
  `link_label` VARCHAR(80) NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'draft',
  `starts_at` DATETIME(6) NULL,
  `duration_days` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  `ends_at` DATETIME(6) GENERATED ALWAYS AS (DATE_ADD(starts_at, INTERVAL duration_days DAY)) STORED,
  `priority` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_by` BIGINT UNSIGNED NOT NULL,
  `updated_by` BIGINT UNSIGNED NOT NULL,
  `retired_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_announcements_status_starts_at_ends_at` (`status`, `starts_at`, `ends_at`),
  KEY `ix_announcements_image_id` (`image_id`),
  KEY `ix_announcements_created_by` (`created_by`),
  KEY `ix_announcements_updated_by` (`updated_by`),
  CONSTRAINT `ck_announcements_1` CHECK (`status` IN ('draft','published','retired')),
  CONSTRAINT `ck_announcements_2` CHECK (duration_days > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Roles destinatarios de un comunicado.
CREATE TABLE `announcement_audiences` (
  `announcement_id` BIGINT UNSIGNED NOT NULL,
  `role_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`announcement_id`, `role_id`),
  KEY `ix_announcement_audiences_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / F: Catálogo de métodos declarables; no credenciales financieras.
CREATE TABLE `payment_methods` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(40) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_payment_methods_code` (`code`),
  CONSTRAINT `ck_payment_methods_1` CHECK (`active` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Métodos favoritos del cliente, no instrumentos bancarios.
CREATE TABLE `user_payment_methods` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `payment_method_id` BIGINT UNSIGNED NOT NULL,
  `label` VARCHAR(80) NULL,
  `is_default` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `default_user_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN is_default=1 THEN user_id ELSE NULL END) STORED,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`user_id`, `payment_method_id`),
  UNIQUE KEY `uq_user_payment_methods_default_user_id` (`default_user_id`),
  KEY `ix_user_payment_methods_payment_method_id` (`payment_method_id`),
  CONSTRAINT `ck_user_payment_methods_1` CHECK (`is_default` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Método seleccionado para una solicitud.
CREATE TABLE `request_payment_methods` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `request_id` BIGINT UNSIGNED NOT NULL,
  `payment_method_id` BIGINT UNSIGNED NOT NULL,
  `selected_by` BIGINT UNSIGNED NOT NULL,
  `selected_at` DATETIME(6) NOT NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_request_payment_methods_request_id` (`request_id`),
  KEY `ix_request_payment_methods_payment_method_id` (`payment_method_id`),
  KEY `ix_request_payment_methods_selected_by` (`selected_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Registro de pago ficticio solicitado expresamente para la demostración.
CREATE TABLE `simulated_payments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `participation_id` BIGINT UNSIGNED NOT NULL,
  `payment_method_id` BIGINT UNSIGNED NOT NULL,
  `created_by` BIGINT UNSIGNED NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `currency` CHAR(3) NOT NULL DEFAULT 'PEN',
  `status` VARCHAR(32) NOT NULL DEFAULT 'simulated_pending',
  `is_simulated` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `simulation_reference` VARCHAR(80) NOT NULL,
  `confirmed_by` BIGINT UNSIGNED NULL,
  `confirmed_at` DATETIME(6) NULL,
  `confirmation_due_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_simulated_payments_simulation_reference` (`simulation_reference`),
  KEY `ix_simulated_payments_participation_id_created_at` (`participation_id`, `created_at`),
  KEY `ix_simulated_payments_status_created_at` (`status`, `created_at`),
  KEY `ix_simulated_payments_payment_method_id` (`payment_method_id`),
  KEY `ix_simulated_payments_created_by` (`created_by`),
  KEY `ix_simulated_payments_confirmed_by` (`confirmed_by`),
  CONSTRAINT `ck_simulated_payments_1` CHECK (`amount` >= 0),
  CONSTRAINT `ck_simulated_payments_2` CHECK (`status` IN ('simulated_pending','simulated_declared','simulated_confirmed','simulated_void')),
  CONSTRAINT `ck_simulated_payments_3` CHECK (`is_simulated` IN (0,1)),
  CONSTRAINT `ck_simulated_payments_4` CHECK (is_simulated = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Historia inmutable de cambios de un pago simulado.
CREATE TABLE `simulated_payment_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `simulated_payment_id` BIGINT UNSIGNED NOT NULL,
  `actor_id` BIGINT UNSIGNED NOT NULL,
  `from_status` VARCHAR(32) NULL,
  `to_status` VARCHAR(32) NOT NULL,
  `reason` TEXT NOT NULL,
  `occurred_at` DATETIME(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_simulated_payment_events_simulated_payment_id_occurred_at` (`simulated_payment_id`, `occurred_at`),
  KEY `ix_simulated_payment_events_actor_id` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Constancia de demostración sin validez tributaria ni prueba de cobro.
CREATE TABLE `simulated_receipts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `simulated_payment_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `reference` VARCHAR(80) NOT NULL,
  `issued_at` DATETIME(6) NOT NULL,
  `is_simulated` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `snapshot` JSON NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_simulated_receipts_reference` (`reference`),
  UNIQUE KEY `uq_simulated_receipts_media_id` (`media_id`),
  KEY `ix_simulated_receipts_simulated_payment_id` (`simulated_payment_id`),
  CONSTRAINT `ck_simulated_receipts_1` CHECK (`is_simulated` IN (0,1)),
  CONSTRAINT `ck_simulated_receipts_2` CHECK (is_simulated = 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Bandeja de ayuda e incidencias de usuario; sin chat integrado.
CREATE TABLE `support_tickets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `opened_by` BIGINT UNSIGNED NOT NULL,
  `request_id` BIGINT UNSIGNED NULL,
  `subject` VARCHAR(180) NOT NULL,
  `description` TEXT NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'open',
  `priority` VARCHAR(32) NOT NULL DEFAULT 'normal',
  `assigned_admin_id` BIGINT UNSIGNED NULL,
  `resolved_at` DATETIME(6) NULL,
  `closed_at` DATETIME(6) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_support_tickets_opened_by_created_at` (`opened_by`, `created_at`),
  KEY `ix_support_tickets_assigned_admin_id_status` (`assigned_admin_id`, `status`),
  KEY `ix_support_tickets_status_created_at` (`status`, `created_at`),
  KEY `ix_support_tickets_request_id` (`request_id`),
  CONSTRAINT `ck_support_tickets_1` CHECK (`status` IN ('open','in_progress','resolved','closed')),
  CONSTRAINT `ck_support_tickets_2` CHECK (`priority` IN ('low','normal','high'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Seguimiento y resolución del ticket.
CREATE TABLE `support_ticket_updates` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ticket_id` BIGINT UNSIGNED NOT NULL,
  `author_id` BIGINT UNSIGNED NOT NULL,
  `kind` VARCHAR(32) NOT NULL,
  `body` TEXT NOT NULL,
  `is_internal` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `new_status` VARCHAR(32) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_support_ticket_updates_ticket_id_created_at` (`ticket_id`, `created_at`),
  KEY `ix_support_ticket_updates_author_id` (`author_id`),
  CONSTRAINT `ck_support_ticket_updates_1` CHECK (`kind` IN ('note','status_change','resolution')),
  CONSTRAINT `ck_support_ticket_updates_2` CHECK (`is_internal` IN (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Evidencias adjuntas al ticket.
CREATE TABLE `support_attachments` (
  `ticket_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `uploaded_by` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`ticket_id`, `media_id`),
  KEY `ix_support_attachments_media_id` (`media_id`),
  KEY `ix_support_attachments_uploaded_by` (`uploaded_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Polimórfica / F: Registro append-only de acciones sensibles sobre recursos heterogéneos.
CREATE TABLE `audit_entries` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `actor_id` BIGINT UNSIGNED NULL,
  `actor_kind` VARCHAR(32) NOT NULL,
  `action` VARCHAR(100) NOT NULL,
  `permission_used` VARCHAR(100) NULL,
  `subject_type` VARCHAR(60) NOT NULL,
  `subject_id` BIGINT UNSIGNED NULL,
  `reason` TEXT NOT NULL,
  `before_values` JSON NULL,
  `after_values` JSON NULL,
  `correlation_id` VARCHAR(64) NOT NULL,
  `occurred_at` DATETIME(6) NOT NULL,
  `source_code` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  KEY `ix_audit_entries_subject_type_subject_id_occurred_at` (`subject_type`, `subject_id`, `occurred_at`),
  KEY `ix_audit_entries_actor_id_occurred_at` (`actor_id`, `occurred_at`),
  KEY `ix_audit_entries_action_occurred_at` (`action`, `occurred_at`),
  KEY `ix_audit_entries_correlation_id` (`correlation_id`),
  CONSTRAINT `ck_audit_entries_1` CHECK (`actor_kind` IN ('user','system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Trabajos largos consultables, como exportaciones.
CREATE TABLE `operations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `requested_by` BIGINT UNSIGNED NOT NULL,
  `type` VARCHAR(60) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `parameters` JSON NOT NULL,
  `started_at` DATETIME(6) NULL,
  `finished_at` DATETIME(6) NULL,
  `failure_code` VARCHAR(80) NULL,
  `version` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `ix_operations_requested_by_created_at` (`requested_by`, `created_at`),
  KEY `ix_operations_status_created_at` (`status`, `created_at`),
  CONSTRAINT `ck_operations_1` CHECK (`status` IN ('pending','running','completed','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F: Resultado privado de un reporte.
CREATE TABLE `export_files` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `operation_id` BIGINT UNSIGNED NOT NULL,
  `media_id` BIGINT UNSIGNED NOT NULL,
  `format` VARCHAR(32) NOT NULL,
  `expires_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_export_files_operation_id` (`operation_id`),
  UNIQUE KEY `uq_export_files_media_id` (`media_id`),
  KEY `ix_export_files_expires_at` (`expires_at`),
  CONSTRAINT `ck_export_files_1` CHECK (`format` IN ('pdf','xlsx'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Polimórfica / F/transversal: Eventos duraderos confirmados con el negocio, pendientes de publicación.
CREATE TABLE `outbox_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_uuid` CHAR(36) NOT NULL,
  `event_type` VARCHAR(100) NOT NULL,
  `aggregate_type` VARCHAR(60) NOT NULL,
  `aggregate_id` BIGINT UNSIGNED NOT NULL,
  `aggregate_version` INT UNSIGNED NOT NULL,
  `schema_version` INT UNSIGNED NOT NULL DEFAULT 1,
  `payload` JSON NOT NULL,
  `occurred_at` DATETIME(6) NOT NULL,
  `available_at` DATETIME(6) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `published_at` DATETIME(6) NULL,
  `attempts` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_outbox_events_event_uuid` (`event_uuid`),
  KEY `ix_outbox_events_status_available_at` (`status`, `available_at`),
  KEY `ix_outbox_events_aggregate_type_aggregate_id_aggr_7513efd9b8` (`aggregate_type`, `aggregate_id`, `aggregate_version`),
  CONSTRAINT `ck_outbox_events_1` CHECK (`status` IN ('pending','processing','published','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Pivot / F: Control por evento y destinatario para publicación privada.
CREATE TABLE `outbox_deliveries` (
  `outbox_event_id` BIGINT UNSIGNED NOT NULL,
  `recipient_id` BIGINT UNSIGNED NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'pending',
  `attempts` INT UNSIGNED NOT NULL DEFAULT 0,
  `next_attempt_at` DATETIME(6) NULL,
  `sent_at` DATETIME(6) NULL,
  `failure_code` VARCHAR(80) NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`outbox_event_id`, `recipient_id`),
  KEY `ix_outbox_deliveries_status_next_attempt_at` (`status`, `next_attempt_at`),
  KEY `ix_outbox_deliveries_recipient_id` (`recipient_id`),
  CONSTRAINT `ck_outbox_deliveries_1` CHECK (`status` IN ('pending','sent','failed','skipped'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / F/transversal: Evita duplicación de comandos por reintento.
CREATE TABLE `idempotency_records` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `operation` VARCHAR(160) NOT NULL,
  `key_hash` CHAR(64) NOT NULL,
  `request_hash` CHAR(64) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'processing',
  `response_status` SMALLINT UNSIGNED NULL,
  `response_body` JSON NULL,
  `expires_at` DATETIME(6) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_idempotency_records_user_id_operation_key_hash` (`user_id`, `operation`, `key_hash`),
  KEY `ix_idempotency_records_expires_at` (`expires_at`),
  CONSTRAINT `ck_idempotency_records_1` CHECK (`status` IN ('processing','completed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / Infraestructura: Sesiones de Laravel para la SPA.
CREATE TABLE `sessions` (
  `id` VARCHAR(255) NOT NULL,
  `user_id` BIGINT UNSIGNED NULL,
  `ip_address` VARCHAR(45) NULL,
  `user_agent` TEXT NULL,
  `payload` LONGTEXT NOT NULL,
  `last_activity` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_sessions_last_activity` (`last_activity`),
  KEY `ix_sessions_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Dependiente / Infraestructura: Tokens temporales de recuperación; identidad lógica por correo.
CREATE TABLE `password_reset_tokens` (
  `email` VARCHAR(254) NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / Infraestructura: Cola de trabajos Laravel persistida en MySQL.
CREATE TABLE `jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` VARCHAR(255) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `attempts` TINYINT UNSIGNED NOT NULL,
  `reserved_at` INT UNSIGNED NULL,
  `available_at` INT UNSIGNED NOT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_jobs_queue` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / Infraestructura: Errores de trabajos conservados para diagnóstico.
CREATE TABLE `failed_jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(255) NOT NULL,
  `connection` TEXT NOT NULL,
  `queue` TEXT NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `exception` LONGTEXT NOT NULL,
  `failed_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_failed_jobs_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / Infraestructura: Caché de base de datos Laravel; datos reconstruibles.
CREATE TABLE `cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`),
  KEY `ix_cache_expiration` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / Infraestructura: Bloqueos temporales del driver de caché.
CREATE TABLE `cache_locks` (
  `key` VARCHAR(255) NOT NULL,
  `owner` VARCHAR(255) NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`),
  KEY `ix_cache_locks_expiration` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- Independiente / Infraestructura: Registro del esquema aplicado por Laravel.
CREATE TABLE `migrations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` VARCHAR(255) NOT NULL,
  `batch` INT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- FK añadidas al final para resolver dependencias circulares del DDL. No elimina la necesidad de ordenar INSERT.
ALTER TABLE `users` ADD CONSTRAINT `fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `role_permissions` ADD CONSTRAINT `fk_role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `role_permissions` ADD CONSTRAINT `fk_role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `user_permissions` ADD CONSTRAINT `fk_user_permissions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `user_permissions` ADD CONSTRAINT `fk_user_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `user_permissions` ADD CONSTRAINT `fk_user_permissions_granted_by` FOREIGN KEY (`granted_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `client_profiles` ADD CONSTRAINT `fk_client_profiles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `client_profiles` ADD CONSTRAINT `fk_client_profiles_default_district_id` FOREIGN KEY (`default_district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `client_blocks` ADD CONSTRAINT `fk_client_blocks_client_id` FOREIGN KEY (`client_id`) REFERENCES `client_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `client_blocks` ADD CONSTRAINT `fk_client_blocks_blocked_by` FOREIGN KEY (`blocked_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `client_blocks` ADD CONSTRAINT `fk_client_blocks_lifted_by` FOREIGN KEY (`lifted_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_profiles` ADD CONSTRAINT `fk_technician_profiles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_profiles` ADD CONSTRAINT `fk_technician_profiles_primary_district_id` FOREIGN KEY (`primary_district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_profiles` ADD CONSTRAINT `fk_technician_profiles_verified_by` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_reviews` ADD CONSTRAINT `fk_technician_reviews_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_reviews` ADD CONSTRAINT `fk_technician_reviews_reviewer_id` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_status_events` ADD CONSTRAINT `fk_technician_status_events_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_status_events` ADD CONSTRAINT `fk_technician_status_events_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `media_files` ADD CONSTRAINT `fk_media_files_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_documents` ADD CONSTRAINT `fk_technician_documents_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_documents` ADD CONSTRAINT `fk_technician_documents_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_documents` ADD CONSTRAINT `fk_technician_documents_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `review_documents` ADD CONSTRAINT `fk_review_documents_review_id` FOREIGN KEY (`review_id`) REFERENCES `technician_reviews` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `review_documents` ADD CONSTRAINT `fk_review_documents_document_id` FOREIGN KEY (`document_id`) REFERENCES `technician_documents` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `portfolio_items` ADD CONSTRAINT `fk_portfolio_items_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `portfolio_items` ADD CONSTRAINT `fk_portfolio_items_subcategory_id` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `portfolio_images` ADD CONSTRAINT `fk_portfolio_images_portfolio_id` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolio_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `portfolio_images` ADD CONSTRAINT `fk_portfolio_images_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `specialties` ADD CONSTRAINT `fk_specialties_hero_media_id` FOREIGN KEY (`hero_media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `subcategories` ADD CONSTRAINT `fk_subcategories_specialty_id` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `subcategories` ADD CONSTRAINT `fk_subcategories_carousel_media_id` FOREIGN KEY (`carousel_media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `district_distances` ADD CONSTRAINT `fk_district_distances_from_district_id` FOREIGN KEY (`from_district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `district_distances` ADD CONSTRAINT `fk_district_distances_to_district_id` FOREIGN KEY (`to_district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_specialties` ADD CONSTRAINT `fk_technician_specialties_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_specialties` ADD CONSTRAINT `fk_technician_specialties_specialty_id` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_specialties` ADD CONSTRAINT `fk_technician_specialties_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_services` ADD CONSTRAINT `fk_technician_services_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_services` ADD CONSTRAINT `fk_technician_services_subcategory_id` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_rate_versions` ADD CONSTRAINT `fk_service_rate_versions_technician_service_id` FOREIGN KEY (`technician_service_id`) REFERENCES `technician_services` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_rate_versions` ADD CONSTRAINT `fk_service_rate_versions_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_districts` ADD CONSTRAINT `fk_technician_districts_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_districts` ADD CONSTRAINT `fk_technician_districts_district_id` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `availability_slots` ADD CONSTRAINT `fk_availability_slots_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `technician_pauses` ADD CONSTRAINT `fk_technician_pauses_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rule_versions` ADD CONSTRAINT `fk_rule_versions_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rule_versions` ADD CONSTRAINT `fk_rule_versions_published_by` FOREIGN KEY (`published_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rule_values` ADD CONSTRAINT `fk_rule_values_rule_version_id` FOREIGN KEY (`rule_version_id`) REFERENCES `rule_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rule_values` ADD CONSTRAINT `fk_rule_values_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `rule_parameters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_weights` ADD CONSTRAINT `fk_matching_weights_rule_version_id` FOREIGN KEY (`rule_version_id`) REFERENCES `rule_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_requests` ADD CONSTRAINT `fk_service_requests_client_id` FOREIGN KEY (`client_id`) REFERENCES `client_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_requests` ADD CONSTRAINT `fk_service_requests_subcategory_id` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_requests` ADD CONSTRAINT `fk_service_requests_district_id` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_requests` ADD CONSTRAINT `fk_service_requests_target_technician_id` FOREIGN KEY (`target_technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_requests` ADD CONSTRAINT `fk_service_requests_rule_version_id` FOREIGN KEY (`rule_version_id`) REFERENCES `rule_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_attachments` ADD CONSTRAINT `fk_request_attachments_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_attachments` ADD CONSTRAINT `fk_request_attachments_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_attachments` ADD CONSTRAINT `fk_request_attachments_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_events` ADD CONSTRAINT `fk_request_events_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_events` ADD CONSTRAINT `fk_request_events_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_runs` ADD CONSTRAINT `fk_matching_runs_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_runs` ADD CONSTRAINT `fk_matching_runs_rule_version_id` FOREIGN KEY (`rule_version_id`) REFERENCES `rule_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_candidates` ADD CONSTRAINT `fk_matching_candidates_matching_run_id` FOREIGN KEY (`matching_run_id`) REFERENCES `matching_runs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_candidates` ADD CONSTRAINT `fk_matching_candidates_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `matching_candidates` ADD CONSTRAINT `fk_matching_candidates_technician_service_id` FOREIGN KEY (`technician_service_id`) REFERENCES `technician_services` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offer_rounds` ADD CONSTRAINT `fk_offer_rounds_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offer_rounds` ADD CONSTRAINT `fk_offer_rounds_matching_run_id` FOREIGN KEY (`matching_run_id`) REFERENCES `matching_runs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offers` ADD CONSTRAINT `fk_offers_round_id` FOREIGN KEY (`round_id`) REFERENCES `offer_rounds` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offers` ADD CONSTRAINT `fk_offers_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offers` ADD CONSTRAINT `fk_offers_matching_candidate_id` FOREIGN KEY (`matching_candidate_id`) REFERENCES `matching_candidates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `offers` ADD CONSTRAINT `fk_offers_service_rate_version_id` FOREIGN KEY (`service_rate_version_id`) REFERENCES `service_rate_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `additional_technician_proposals` ADD CONSTRAINT `fk_additional_technician_proposals_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `additional_technician_proposals` ADD CONSTRAINT `fk_additional_technician_proposals_proposed_by_pa_a6ed9d7213` FOREIGN KEY (`proposed_by_participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `additional_technician_proposals` ADD CONSTRAINT `fk_additional_technician_proposals_proposed_technician_id` FOREIGN KEY (`proposed_technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `additional_technician_proposals` ADD CONSTRAINT `fk_additional_technician_proposals_client_decided_by` FOREIGN KEY (`client_decided_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `additional_technician_proposals` ADD CONSTRAINT `fk_additional_technician_proposals_offer_id` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `participations` ADD CONSTRAINT `fk_participations_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `participations` ADD CONSTRAINT `fk_participations_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `participations` ADD CONSTRAINT `fk_participations_offer_id` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `participations` ADD CONSTRAINT `fk_participations_authorized_by` FOREIGN KEY (`authorized_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `participations` ADD CONSTRAINT `fk_participations_replaces_id` FOREIGN KEY (`replaces_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `appointments` ADD CONSTRAINT `fk_appointments_participation_id` FOREIGN KEY (`participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `appointments` ADD CONSTRAINT `fk_appointments_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reschedule_requests` ADD CONSTRAINT `fk_reschedule_requests_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reschedule_requests` ADD CONSTRAINT `fk_reschedule_requests_proposed_by` FOREIGN KEY (`proposed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reschedule_responses` ADD CONSTRAINT `fk_reschedule_responses_reschedule_id` FOREIGN KEY (`reschedule_id`) REFERENCES `reschedule_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reschedule_responses` ADD CONSTRAINT `fk_reschedule_responses_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_reports` ADD CONSTRAINT `fk_service_reports_participation_id` FOREIGN KEY (`participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_reports` ADD CONSTRAINT `fk_service_reports_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_report_evidence` ADD CONSTRAINT `fk_service_report_evidence_report_id` FOREIGN KEY (`report_id`) REFERENCES `service_reports` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `service_report_evidence` ADD CONSTRAINT `fk_service_report_evidence_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incidents` ADD CONSTRAINT `fk_incidents_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incidents` ADD CONSTRAINT `fk_incidents_participation_id` FOREIGN KEY (`participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incidents` ADD CONSTRAINT `fk_incidents_reported_by` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incidents` ADD CONSTRAINT `fk_incidents_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incident_evidence` ADD CONSTRAINT `fk_incident_evidence_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `incidents` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `incident_evidence` ADD CONSTRAINT `fk_incident_evidence_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_previous_participation_id` FOREIGN KEY (`previous_participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_new_participation_id` FOREIGN KEY (`new_participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_target_technician_id` FOREIGN KEY (`target_technician_id`) REFERENCES `technician_profiles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `incidents` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `reassignment_records` ADD CONSTRAINT `fk_reassignment_records_new_round_id` FOREIGN KEY (`new_round_id`) REFERENCES `offer_rounds` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `ratings` ADD CONSTRAINT `fk_ratings_participation_id` FOREIGN KEY (`participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `ratings` ADD CONSTRAINT `fk_ratings_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_versions` ADD CONSTRAINT `fk_rating_versions_rating_id` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_versions` ADD CONSTRAINT `fk_rating_versions_changed_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_replies` ADD CONSTRAINT `fk_rating_replies_rating_id` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_replies` ADD CONSTRAINT `fk_rating_replies_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_appeals` ADD CONSTRAINT `fk_rating_appeals_rating_id` FOREIGN KEY (`rating_id`) REFERENCES `ratings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_appeals` ADD CONSTRAINT `fk_rating_appeals_submitted_by` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_appeals` ADD CONSTRAINT `fk_rating_appeals_submitted_version_id` FOREIGN KEY (`submitted_version_id`) REFERENCES `rating_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `appeal_evidence` ADD CONSTRAINT `fk_appeal_evidence_appeal_id` FOREIGN KEY (`appeal_id`) REFERENCES `rating_appeals` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `appeal_evidence` ADD CONSTRAINT `fk_appeal_evidence_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_resolutions` ADD CONSTRAINT `fk_rating_resolutions_appeal_id` FOREIGN KEY (`appeal_id`) REFERENCES `rating_appeals` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_resolutions` ADD CONSTRAINT `fk_rating_resolutions_reviewed_version_id` FOREIGN KEY (`reviewed_version_id`) REFERENCES `rating_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_resolutions` ADD CONSTRAINT `fk_rating_resolutions_resolved_by` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `rating_resolutions` ADD CONSTRAINT `fk_rating_resolutions_result_version_id` FOREIGN KEY (`result_version_id`) REFERENCES `rating_versions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `notifications` ADD CONSTRAINT `fk_notifications_recipient_id` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `notification_attempts` ADD CONSTRAINT `fk_notification_attempts_notification_id` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `notification_preferences` ADD CONSTRAINT `fk_notification_preferences_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `announcements` ADD CONSTRAINT `fk_announcements_image_id` FOREIGN KEY (`image_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `announcements` ADD CONSTRAINT `fk_announcements_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `announcements` ADD CONSTRAINT `fk_announcements_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `announcement_audiences` ADD CONSTRAINT `fk_announcement_audiences_announcement_id` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `announcement_audiences` ADD CONSTRAINT `fk_announcement_audiences_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `user_payment_methods` ADD CONSTRAINT `fk_user_payment_methods_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `user_payment_methods` ADD CONSTRAINT `fk_user_payment_methods_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_payment_methods` ADD CONSTRAINT `fk_request_payment_methods_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_payment_methods` ADD CONSTRAINT `fk_request_payment_methods_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `request_payment_methods` ADD CONSTRAINT `fk_request_payment_methods_selected_by` FOREIGN KEY (`selected_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payments` ADD CONSTRAINT `fk_simulated_payments_participation_id` FOREIGN KEY (`participation_id`) REFERENCES `participations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payments` ADD CONSTRAINT `fk_simulated_payments_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payments` ADD CONSTRAINT `fk_simulated_payments_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payments` ADD CONSTRAINT `fk_simulated_payments_confirmed_by` FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payment_events` ADD CONSTRAINT `fk_simulated_payment_events_simulated_payment_id` FOREIGN KEY (`simulated_payment_id`) REFERENCES `simulated_payments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_payment_events` ADD CONSTRAINT `fk_simulated_payment_events_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_receipts` ADD CONSTRAINT `fk_simulated_receipts_simulated_payment_id` FOREIGN KEY (`simulated_payment_id`) REFERENCES `simulated_payments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `simulated_receipts` ADD CONSTRAINT `fk_simulated_receipts_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_tickets` ADD CONSTRAINT `fk_support_tickets_opened_by` FOREIGN KEY (`opened_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_tickets` ADD CONSTRAINT `fk_support_tickets_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_tickets` ADD CONSTRAINT `fk_support_tickets_assigned_admin_id` FOREIGN KEY (`assigned_admin_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_ticket_updates` ADD CONSTRAINT `fk_support_ticket_updates_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_ticket_updates` ADD CONSTRAINT `fk_support_ticket_updates_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_attachments` ADD CONSTRAINT `fk_support_attachments_ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_attachments` ADD CONSTRAINT `fk_support_attachments_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `support_attachments` ADD CONSTRAINT `fk_support_attachments_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `audit_entries` ADD CONSTRAINT `fk_audit_entries_actor_id` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `operations` ADD CONSTRAINT `fk_operations_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `export_files` ADD CONSTRAINT `fk_export_files_operation_id` FOREIGN KEY (`operation_id`) REFERENCES `operations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `export_files` ADD CONSTRAINT `fk_export_files_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_files` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `outbox_deliveries` ADD CONSTRAINT `fk_outbox_deliveries_outbox_event_id` FOREIGN KEY (`outbox_event_id`) REFERENCES `outbox_events` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `outbox_deliveries` ADD CONSTRAINT `fk_outbox_deliveries_recipient_id` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `idempotency_records` ADD CONSTRAINT `fk_idempotency_records_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `sessions` ADD CONSTRAINT `fk_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Vista dependiente de consulta. La API debe filtrar por rol y pertenencia.
CREATE SQL SECURITY INVOKER VIEW `v_service_history` AS
SELECT r.id AS request_id, r.client_id, r.subcategory_id, r.district_id,
       r.status AS request_status, r.submitted_at,
       p.id AS participation_id, p.technician_id, p.slot,
       p.status AS participation_status, p.assigned_at, p.completed_at,
       CASE WHEN p.id IS NULL THEN r.reference_fee_snapshot ELSE p.reference_fee_snapshot END AS reference_fee,
       CASE WHEN p.id IS NULL THEN r.currency ELSE p.currency END AS currency,
       rt.id AS rating_id,
       CASE WHEN rt.status = 'active' THEN rt.score ELSE NULL END AS rating_score,
       rt.status AS rating_status
FROM service_requests r
LEFT JOIN participations p ON p.request_id = r.id
LEFT JOIN ratings rt ON rt.participation_id = p.id;
