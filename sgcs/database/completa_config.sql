-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para sgcs
CREATE DATABASE IF NOT EXISTS `sgcs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `sgcs`;

-- Volcando estructura para tabla sgcs.accesos
CREATE TABLE IF NOT EXISTS `accesos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` char(36) NOT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `accion` varchar(100) DEFAULT NULL,
  `recurso` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `accesos_usuario_id_foreign` (`usuario_id`),
  CONSTRAINT `accesos_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.accesos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.ajustes_cronograma
CREATE TABLE IF NOT EXISTS `ajustes_cronograma` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `proyecto_id` varchar(255) NOT NULL,
  `tipo_ajuste` enum('manual','automatico','solicitud_cambio') NOT NULL DEFAULT 'automatico',
  `estado` enum('propuesto','aprobado','aplicado','rechazado','revertido') NOT NULL DEFAULT 'propuesto',
  `desviaciones_detectadas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`desviaciones_detectadas`)),
  `ruta_critica` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`ruta_critica`)),
  `recursos_sobrecargados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`recursos_sobrecargados`)),
  `estrategia` varchar(50) DEFAULT NULL,
  `ajustes_propuestos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`ajustes_propuestos`)),
  `ajustes_aplicados` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`ajustes_aplicados`)),
  `dias_recuperados` int(11) NOT NULL DEFAULT 0,
  `recursos_afectados` int(11) NOT NULL DEFAULT 0,
  `score_solucion` decimal(5,2) DEFAULT NULL,
  `costo_adicional_estimado` decimal(8,2) DEFAULT NULL,
  `aprobado_por` char(36) DEFAULT NULL,
  `aprobado_en` timestamp NULL DEFAULT NULL,
  `motivo_ajuste` text DEFAULT NULL,
  `notas_rechazo` text DEFAULT NULL,
  `creado_por` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ajustes_cronograma_aprobado_por_foreign` (`aprobado_por`),
  KEY `ajustes_cronograma_creado_por_foreign` (`creado_por`),
  KEY `ajustes_cronograma_proyecto_id_estado_index` (`proyecto_id`,`estado`),
  KEY `ajustes_cronograma_created_at_index` (`created_at`),
  CONSTRAINT `ajustes_cronograma_aprobado_por_foreign` FOREIGN KEY (`aprobado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ajustes_cronograma_creado_por_foreign` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ajustes_cronograma_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.ajustes_cronograma: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.auditorias
CREATE TABLE IF NOT EXISTS `auditorias` (
  `id` char(36) NOT NULL,
  `tipo_entidad` varchar(100) DEFAULT NULL,
  `entidad_id` char(36) DEFAULT NULL,
  `accion` varchar(100) DEFAULT NULL,
  `usuario_id` char(36) DEFAULT NULL,
  `detalles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`detalles`)),
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `auditorias_usuario_id_foreign` (`usuario_id`),
  CONSTRAINT `auditorias_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.auditorias: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.comite_cambios
CREATE TABLE IF NOT EXISTS `comite_cambios` (
  `id` char(36) NOT NULL,
  `proyecto_id` char(36) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `quorum` int(11) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `comite_cambios_proyecto_id_foreign` (`proyecto_id`),
  CONSTRAINT `comite_cambios_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.comite_cambios: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.elementos_configuracion
CREATE TABLE IF NOT EXISTS `elementos_configuracion` (
  `id` char(36) NOT NULL,
  `codigo_ec` varchar(50) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `proyecto_id` char(36) NOT NULL,
  `tipo` enum('DOCUMENTO','CODIGO','SCRIPT_BD','CONFIGURACION','OTRO') NOT NULL DEFAULT 'OTRO',
  `version_actual_id` char(36) DEFAULT NULL,
  `creado_por` char(36) DEFAULT NULL,
  `estado` enum('PENDIENTE','BORRADOR','EN_REVISION','APROBADO','LIBERADO','OBSOLETO') NOT NULL DEFAULT 'PENDIENTE',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `elementos_configuracion_codigo_ec_unique` (`codigo_ec`),
  KEY `elementos_configuracion_proyecto_id_foreign` (`proyecto_id`),
  KEY `elementos_configuracion_creado_por_foreign` (`creado_por`),
  KEY `elementos_configuracion_version_actual_id_foreign` (`version_actual_id`),
  CONSTRAINT `elementos_configuracion_creado_por_foreign` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `elementos_configuracion_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `elementos_configuracion_version_actual_id_foreign` FOREIGN KEY (`version_actual_id`) REFERENCES `versiones_ec` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.elementos_configuracion: ~22 rows (aproximadamente)
INSERT INTO `elementos_configuracion` (`id`, `codigo_ec`, `titulo`, `descripcion`, `proyecto_id`, `tipo`, `version_actual_id`, `creado_por`, `estado`, `creado_en`, `actualizado_en`) VALUES
	('06033ffd-5653-4604-9cce-0916194d2749', 'EC-2025-004', 'Plan de Pruebas', 'Estrategia de testing, casos de prueba y matriz de trazabilidad', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'DOCUMENTO', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', 'CASC-EC-003', 'Diagrama ER', 'Diagrama Entidad-Relación de la base de lkjkljkl', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'DOCUMENTO', NULL, NULL, 'APROBADO', '2025-11-04 08:59:50', '2025-11-04 09:31:38'),
	('077232ad-a398-4c6c-89b3-f37a870f6b16', 'EC-2025-003', 'Código Fuente', 'Implementación del código fuente del sistema', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'CODIGO', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('10af7132-a4df-4dfa-975e-fa609efb0b62', 'SCRUM-EC-004', 'API Auth Module', 'Módulo de autenticación con JWT', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('1a8cbddf-f06c-4c17-8541-37ccd7654dbc', 'CASC-EC-008', 'Plan de Pruebas', 'Documento de estrategia de testing', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('23266920-3577-4801-b265-3460e7f955ae', 'CASC-EC-001', 'Documento de Requisitos', 'SRS - Especificación de Requisitos de Software', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('26727f7a-4f94-4654-982a-97d3fa15f3a2', 'EC-2025-002', 'Diseño de Arquitectura', 'Diseño técnico y arquitectónico del sistema', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'DOCUMENTO', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('350f9024-522a-48ca-8960-d40230180aee', 'SCRUM-EC-007', 'Test Suite - Auth', 'Pruebas unitarias para autenticación', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('37e8d318-22b6-45b6-bb5b-bd38e84e8f9f', 'SCRUM-EC-002', 'User Story - Login', 'Historia: Como usuario quiero iniciar sesión', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('4905852c-3d63-4837-ac13-b63b7bd181b6', 'CASC-EC-002', 'Diseño Arquitectónico', 'SAD - Especificación de Arquitectura de Software', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('54e82749-8bdb-4c8b-8c2a-f8933bacad59', 'SCRUM-EC-003', 'User Story - CRUD Pedidos', 'Historia: Como usuario quiero gestionar pedidos', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('594a712a-3bd4-431d-9c8b-7a3f845fb1b8', 'EC-2025-001', 'Documento de Requisitos (SRS)', 'Especificación de requisitos del sistema (Software Requirements Specification)', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'DOCUMENTO', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('5e9f6946-e158-41b7-ad32-5fd7a67d1e61', 'CASC-EC-007', 'Script BD Inicial', 'Script de creación de base de datos', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'SCRIPT_BD', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('73555a44-1567-40f3-b739-074dee5f94b2', 'SCRUM-EC-008', 'Sprint 1 - Docs', 'Documentación del Sprint 1', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('7e0e82df-e45c-49e6-9557-c9b2ebdfd84d', 'SCRUM-EC-001', 'Product Backlog', 'Lista priorizada de historias de usuario', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('908dd934-d3e0-4a53-b2f1-faebb80c0408', 'CASC-EC-006', 'Módulo Inventario', 'Gestión de inventario y almacén', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('b04e8a2a-d0c3-4eac-aeb0-ebafffa1b5b9', 'EC-2025-005', 'Manual de Usuario', 'Documentación para usuarios finales del sistema', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'DOCUMENTO', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('c682d045-99a4-4d2d-b07b-264c16be2e43', 'SCRUM-EC-006', 'Pedidos Controller', 'Controlador para gestión de pedidos', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('ce8ab9e1-5441-4cff-8bb3-0472d522e405', 'CASC-EC-004', 'Manual de Usuario', 'Guía completa para el usuario final', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'DOCUMENTO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('d921381c-2ab5-4fc7-8999-9f11dd7951c8', 'SCRUM-EC-005', 'Frontend Login Component', 'Componente React para login', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('e0633357-8c06-48df-9a24-9badaba026d1', 'CASC-EC-005', 'Módulo Core ERP', 'Módulo principal del sistema ERP', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'CODIGO', NULL, NULL, 'PENDIENTE', '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('e59181da-8d5e-41ac-bde9-fd1adaf61275', 'EC-2025-006', 'Scripts de Base de Datos', 'Scripts SQL de creación y migración de base de datos', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'SCRIPT_BD', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'PENDIENTE', '2025-11-04 09:06:23', '2025-11-04 09:06:23');

-- Volcando estructura para tabla sgcs.equipos
CREATE TABLE IF NOT EXISTS `equipos` (
  `id` char(36) NOT NULL,
  `proyecto_id` char(36) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `lider_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `equipos_proyecto_id_foreign` (`proyecto_id`),
  KEY `equipos_lider_id_foreign` (`lider_id`),
  CONSTRAINT `equipos_lider_id_foreign` FOREIGN KEY (`lider_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `equipos_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.equipos: ~3 rows (aproximadamente)
INSERT INTO `equipos` (`id`, `proyecto_id`, `nombre`, `lider_id`) VALUES
	('301b382c-7166-429e-90c5-bb944ccd62aa', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 'Equipo Cascada', '0fe41d2f-e361-48b6-9673-b83ebdb6e676'),
	('d70567e5-b715-4bbe-af25-d6a6fedd6148', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'Equipo Principal - propopopo código se generará autom', '0fe41d2f-e361-48b6-9673-b83ebdb6e676'),
	('dc7dc783-d85c-46f6-9685-959aed1080d5', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'Equipo Scrum', '4f045f7e-8581-4311-96e6-9b14becf58b7');

-- Volcando estructura para tabla sgcs.fases_metodologia
CREATE TABLE IF NOT EXISTS `fases_metodologia` (
  `id_fase` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_metodologia` bigint(20) unsigned NOT NULL,
  `nombre_fase` varchar(100) NOT NULL,
  `orden` int(11) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_fase`),
  KEY `fases_metodologia_id_metodologia_foreign` (`id_metodologia`),
  CONSTRAINT `fases_metodologia_id_metodologia_foreign` FOREIGN KEY (`id_metodologia`) REFERENCES `metodologias` (`id_metodologia`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.fases_metodologia: ~17 rows (aproximadamente)
INSERT INTO `fases_metodologia` (`id_fase`, `id_metodologia`, `nombre_fase`, `orden`, `descripcion`) VALUES
	(1, 1, 'Product Backlog', 1, 'Repositorio de historias de usuario pendientes'),
	(2, 1, 'Sprint Planning', 2, 'Planificación y selección de historias para el sprint'),
	(3, 1, 'In Progress', 3, 'Tareas en desarrollo activo durante el sprint'),
	(4, 1, 'In Review', 4, 'Revisión de código y validación de criterios de aceptación'),
	(5, 1, 'Done', 5, 'Historias completadas y aceptadas'),
	(6, 2, 'Requisitos', 1, 'Recolección y definición de requerimientos del sistema'),
	(7, 2, 'Análisis', 2, 'Análisis detallado de requisitos y especificaciones'),
	(8, 2, 'Diseño', 3, 'Diseño arquitectónico y detallado del sistema'),
	(9, 2, 'Implementación', 4, 'Codificación y desarrollo del sistema'),
	(10, 2, 'Pruebas', 5, 'Testing, validación y verificación del sistema'),
	(11, 2, 'Despliegue', 6, 'Implementación y puesta en producción'),
	(12, 2, 'Mantenimiento', 7, 'Soporte y mantenimiento post-despliegue'),
	(13, 3, 'Backlog', 1, 'Tareas pendientes por iniciar'),
	(14, 3, 'Selected for Dev', 2, 'Tareas seleccionadas para desarrollo'),
	(15, 3, 'In Progress', 3, 'Trabajo en curso'),
	(16, 3, 'Review', 4, 'En revisión de calidad'),
	(17, 3, 'Done', 5, 'Completado y entregado');

-- Volcando estructura para tabla sgcs.historial_ajustes_tareas
CREATE TABLE IF NOT EXISTS `historial_ajustes_tareas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ajuste_id` bigint(20) unsigned NOT NULL,
  `tarea_id` bigint(20) unsigned NOT NULL,
  `fecha_inicio_anterior` date DEFAULT NULL,
  `fecha_fin_anterior` date DEFAULT NULL,
  `duracion_anterior` int(11) DEFAULT NULL,
  `responsable_anterior` char(36) DEFAULT NULL,
  `horas_estimadas_anterior` decimal(8,2) DEFAULT NULL,
  `fecha_inicio_nueva` date DEFAULT NULL,
  `fecha_fin_nueva` date DEFAULT NULL,
  `duracion_nueva` int(11) DEFAULT NULL,
  `responsable_nuevo` char(36) DEFAULT NULL,
  `horas_estimadas_nueva` decimal(8,2) DEFAULT NULL,
  `tipo_cambio` varchar(50) NOT NULL,
  `impacto_estimado` text DEFAULT NULL,
  `aplicado` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `historial_ajustes_tareas_responsable_anterior_foreign` (`responsable_anterior`),
  KEY `historial_ajustes_tareas_responsable_nuevo_foreign` (`responsable_nuevo`),
  KEY `historial_ajustes_tareas_ajuste_id_index` (`ajuste_id`),
  KEY `historial_ajustes_tareas_tarea_id_index` (`tarea_id`),
  CONSTRAINT `historial_ajustes_tareas_ajuste_id_foreign` FOREIGN KEY (`ajuste_id`) REFERENCES `ajustes_cronograma` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_ajustes_tareas_responsable_anterior_foreign` FOREIGN KEY (`responsable_anterior`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `historial_ajustes_tareas_responsable_nuevo_foreign` FOREIGN KEY (`responsable_nuevo`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `historial_ajustes_tareas_tarea_id_foreign` FOREIGN KEY (`tarea_id`) REFERENCES `tareas_proyecto` (`id_tarea`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.historial_ajustes_tareas: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.impedimentos
CREATE TABLE IF NOT EXISTS `impedimentos` (
  `id_impedimento` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_proyecto` char(36) NOT NULL,
  `id_sprint` bigint(20) unsigned DEFAULT NULL,
  `id_usuario_reporta` char(36) NOT NULL,
  `id_usuario_asignado` char(36) DEFAULT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `prioridad` enum('baja','media','alta','critica') NOT NULL DEFAULT 'media',
  `estado` enum('abierto','en_progreso','resuelto','cerrado') NOT NULL DEFAULT 'abierto',
  `fecha_reporte` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_resolucion` timestamp NULL DEFAULT NULL,
  `solucion` text DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_impedimento`),
  KEY `impedimentos_id_proyecto_foreign` (`id_proyecto`),
  KEY `impedimentos_id_usuario_reporta_foreign` (`id_usuario_reporta`),
  KEY `impedimentos_id_usuario_asignado_foreign` (`id_usuario_asignado`),
  CONSTRAINT `impedimentos_id_proyecto_foreign` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `impedimentos_id_usuario_asignado_foreign` FOREIGN KEY (`id_usuario_asignado`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `impedimentos_id_usuario_reporta_foreign` FOREIGN KEY (`id_usuario_reporta`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.impedimentos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.items_cambio
CREATE TABLE IF NOT EXISTS `items_cambio` (
  `id` char(36) NOT NULL,
  `solicitud_cambio_id` char(36) NOT NULL,
  `ec_id` char(36) NOT NULL,
  `version_actual_ec_id` char(36) DEFAULT NULL,
  `version_propuesta` varchar(50) DEFAULT NULL,
  `nota` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `items_cambio_solicitud_cambio_id_foreign` (`solicitud_cambio_id`),
  KEY `items_cambio_ec_id_foreign` (`ec_id`),
  KEY `items_cambio_version_actual_ec_id_foreign` (`version_actual_ec_id`),
  CONSTRAINT `items_cambio_ec_id_foreign` FOREIGN KEY (`ec_id`) REFERENCES `elementos_configuracion` (`id`),
  CONSTRAINT `items_cambio_solicitud_cambio_id_foreign` FOREIGN KEY (`solicitud_cambio_id`) REFERENCES `solicitudes_cambio` (`id`) ON DELETE CASCADE,
  CONSTRAINT `items_cambio_version_actual_ec_id_foreign` FOREIGN KEY (`version_actual_ec_id`) REFERENCES `versiones_ec` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.items_cambio: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.items_liberacion
CREATE TABLE IF NOT EXISTS `items_liberacion` (
  `id` char(36) NOT NULL,
  `liberacion_id` char(36) NOT NULL,
  `ec_id` char(36) DEFAULT NULL,
  `version_ec_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `items_liberacion_liberacion_id_foreign` (`liberacion_id`),
  KEY `items_liberacion_ec_id_foreign` (`ec_id`),
  KEY `items_liberacion_version_ec_id_foreign` (`version_ec_id`),
  CONSTRAINT `items_liberacion_ec_id_foreign` FOREIGN KEY (`ec_id`) REFERENCES `elementos_configuracion` (`id`),
  CONSTRAINT `items_liberacion_liberacion_id_foreign` FOREIGN KEY (`liberacion_id`) REFERENCES `liberaciones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `items_liberacion_version_ec_id_foreign` FOREIGN KEY (`version_ec_id`) REFERENCES `versiones_ec` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.items_liberacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.liberaciones
CREATE TABLE IF NOT EXISTS `liberaciones` (
  `id` char(36) NOT NULL,
  `proyecto_id` char(36) NOT NULL,
  `etiqueta` varchar(50) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_liberacion` date DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `liberaciones_proyecto_id_foreign` (`proyecto_id`),
  CONSTRAINT `liberaciones_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.liberaciones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.metodologias
CREATE TABLE IF NOT EXISTS `metodologias` (
  `id_metodologia` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_metodologia`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.metodologias: ~3 rows (aproximadamente)
INSERT INTO `metodologias` (`id_metodologia`, `nombre`, `tipo`, `descripcion`) VALUES
	(1, 'Scrum', 'ágil', 'Framework ágil basado en sprints, roles definidos y entregas iterativas'),
	(2, 'Cascada', 'secuencial', 'Metodología tradicional con fases secuenciales y entregables por etapa'),
	(3, 'Kanban', 'ágil', 'Sistema visual de gestión de flujo continuo con límites WIP');

-- Volcando estructura para tabla sgcs.miembros_ccb
CREATE TABLE IF NOT EXISTS `miembros_ccb` (
  `ccb_id` char(36) NOT NULL,
  `usuario_id` char(36) NOT NULL,
  `rol_en_ccb` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ccb_id`,`usuario_id`),
  KEY `miembros_ccb_usuario_id_foreign` (`usuario_id`),
  CONSTRAINT `miembros_ccb_ccb_id_foreign` FOREIGN KEY (`ccb_id`) REFERENCES `comite_cambios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `miembros_ccb_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.miembros_ccb: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.miembros_equipo
CREATE TABLE IF NOT EXISTS `miembros_equipo` (
  `equipo_id` char(36) NOT NULL,
  `usuario_id` char(36) NOT NULL,
  `rol_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`equipo_id`,`usuario_id`,`rol_id`),
  KEY `miembros_equipo_usuario_id_foreign` (`usuario_id`),
  KEY `miembros_equipo_rol_id_foreign` (`rol_id`),
  CONSTRAINT `miembros_equipo_equipo_id_foreign` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`),
  CONSTRAINT `miembros_equipo_rol_id_foreign` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `miembros_equipo_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.miembros_equipo: ~8 rows (aproximadamente)
INSERT INTO `miembros_equipo` (`equipo_id`, `usuario_id`, `rol_id`) VALUES
	('301b382c-7166-429e-90c5-bb944ccd62aa', '4f045f7e-8581-4311-96e6-9b14becf58b7', 2),
	('301b382c-7166-429e-90c5-bb944ccd62aa', '60a17106-69d7-40e1-b749-cd1f5ec40c31', 4),
	('301b382c-7166-429e-90c5-bb944ccd62aa', 'b15cf851-1d78-49ba-89de-d6200e3b07ad', 3),
	('d70567e5-b715-4bbe-af25-d6a6fedd6148', '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 4),
	('d70567e5-b715-4bbe-af25-d6a6fedd6148', '5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', 3),
	('dc7dc783-d85c-46f6-9685-959aed1080d5', '0fe41d2f-e361-48b6-9673-b83ebdb6e676', 3),
	('dc7dc783-d85c-46f6-9685-959aed1080d5', '5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', 3),
	('dc7dc783-d85c-46f6-9685-959aed1080d5', '60a17106-69d7-40e1-b749-cd1f5ec40c31', 4);

-- Volcando estructura para tabla sgcs.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.migrations: ~13 rows (aproximadamente)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '2024_01_01_000001_create_roles_table', 1),
	(3, '2024_01_01_000002_create_proyectos_table', 1),
	(4, '2024_01_01_000003_create_elementos_configuracion_table', 1),
	(5, '2024_01_01_000004_create_liberaciones_table', 1),
	(6, '2024_01_01_000005_create_solicitudes_cambio_table', 1),
	(7, '2024_01_01_000006_create_auditorias_table', 1),
	(8, '2025_10_16_000001_add_fields_to_tareas_proyecto', 1),
	(9, '2025_10_30_000001_create_ajustes_cronograma_table', 1),
	(10, '2025_10_30_000002_create_historial_ajustes_tareas_table', 1),
	(11, '2025_10_30_000003_add_cronograma_inteligente_fields_to_tareas_proyecto', 1),
	(12, '2025_10_30_174538_add_impedimento_base_to_solicitudes_cambio_table', 1),
	(13, '2025_10_30_174732_create_impedimentos_table', 1);

-- Volcando estructura para tabla sgcs.notificaciones
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id` char(36) NOT NULL,
  `usuario_id` char(36) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `datos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos`)),
  `leida` tinyint(1) NOT NULL DEFAULT 0,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `notificaciones_usuario_id_foreign` (`usuario_id`),
  CONSTRAINT `notificaciones_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.notificaciones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.password_reset_tokens: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.plantillas_ec
CREATE TABLE IF NOT EXISTS `plantillas_ec` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `metodologia_id` bigint(20) unsigned NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `tipo` enum('DOCUMENTO','CODIGO','SCRIPT_BD','CONFIGURACION','OTRO') NOT NULL DEFAULT 'DOCUMENTO',
  `descripcion` text DEFAULT NULL,
  `orden` int(11) NOT NULL DEFAULT 1,
  `es_recomendado` tinyint(1) NOT NULL DEFAULT 1,
  `tarea_nombre` varchar(255) DEFAULT NULL,
  `tarea_descripcion` text DEFAULT NULL,
  `porcentaje_inicio` decimal(5,2) NOT NULL DEFAULT 0.00,
  `porcentaje_fin` decimal(5,2) NOT NULL DEFAULT 100.00,
  `relaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`relaciones`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plantillas_ec_metodologia_id_foreign` (`metodologia_id`),
  CONSTRAINT `plantillas_ec_metodologia_id_foreign` FOREIGN KEY (`metodologia_id`) REFERENCES `metodologias` (`id_metodologia`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.plantillas_ec: ~14 rows (aproximadamente)
INSERT INTO `plantillas_ec` (`id`, `metodologia_id`, `nombre`, `tipo`, `descripcion`, `orden`, `es_recomendado`, `tarea_nombre`, `tarea_descripcion`, `porcentaje_inicio`, `porcentaje_fin`, `relaciones`, `created_at`, `updated_at`) VALUES
	(1, 1, 'Product Backlog', 'DOCUMENTO', 'Repositorio central de historias de usuario y requisitos del producto', 1, 1, 'Crear historias de usuario iniciales', 'Definir las primeras historias de usuario del proyecto basadas en los requisitos del Product Owner', 0.00, 20.00, NULL, '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(2, 1, 'Sprint Backlog', 'DOCUMENTO', 'Planificación y seguimiento de sprints del proyecto', 2, 1, 'Planificar primer sprint', 'Seleccionar historias de usuario del Product Backlog y planificar el primer sprint', 20.00, 40.00, '[{"nombre":"Product Backlog","tipo":"DEPENDE_DE"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(3, 1, 'Repositorio de Código', 'CODIGO', 'Control de versiones del código fuente del proyecto', 3, 1, 'Configurar repositorio Git', 'Inicializar repositorio Git, configurar branches (main, develop) y establecer reglas de commit', 0.00, 10.00, NULL, '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(4, 1, 'Documentación Técnica', 'DOCUMENTO', 'Documentación del sistema, APIs y guías de desarrollo', 4, 1, 'Crear README y documentación inicial', 'Documentar configuración del proyecto, estructura de carpetas y guías para desarrolladores', 40.00, 60.00, '[{"nombre":"Repositorio de C\\u00f3digo","tipo":"REFERENCIA"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(5, 1, 'Definition of Done (DoD)', 'DOCUMENTO', 'Criterios de aceptación y definición de "terminado" para el equipo', 5, 0, 'Definir criterios de DoD del equipo', 'Establecer los criterios que debe cumplir una historia de usuario para considerarse terminada', 0.00, 15.00, '[{"nombre":"Product Backlog","tipo":"REFERENCIA"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(6, 1, 'Retrospectivas', 'DOCUMENTO', 'Registro de retrospectivas y acciones de mejora del equipo', 6, 0, 'Preparar template de retrospectivas', 'Crear formato estándar para documentar retrospectivas de cada sprint', 60.00, 80.00, '[{"nombre":"Sprint Backlog","tipo":"REFERENCIA"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(7, 2, 'Documento de Requisitos (SRS)', 'DOCUMENTO', 'Especificación de requisitos del sistema (Software Requirements Specification)', 1, 1, 'Recopilar y documentar requisitos', 'Realizar entrevistas con stakeholders y documentar todos los requisitos funcionales y no funcionales', 0.00, 15.00, NULL, '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(8, 2, 'Diseño de Arquitectura', 'DOCUMENTO', 'Diseño técnico y arquitectónico del sistema', 2, 1, 'Diseñar arquitectura del sistema', 'Crear diagramas UML, arquitectura de componentes, diseño de base de datos y especificaciones técnicas', 15.00, 30.00, '[{"nombre":"Documento de Requisitos (SRS)","tipo":"DEPENDE_DE"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(9, 2, 'Código Fuente', 'CODIGO', 'Implementación del código fuente del sistema', 3, 1, 'Configurar estructura del proyecto', 'Inicializar proyecto, configurar dependencias y establecer estructura de carpetas según diseño', 30.00, 60.00, '[{"nombre":"Dise\\u00f1o de Arquitectura","tipo":"DEPENDE_DE"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(10, 2, 'Plan de Pruebas', 'DOCUMENTO', 'Estrategia de testing, casos de prueba y matriz de trazabilidad', 4, 1, 'Elaborar plan de pruebas', 'Definir estrategia de testing, diseñar casos de prueba y crear matriz de trazabilidad de requisitos', 50.00, 70.00, '[{"nombre":"Documento de Requisitos (SRS)","tipo":"REFERENCIA"},{"nombre":"C\\u00f3digo Fuente","tipo":"DEPENDE_DE"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(11, 2, 'Manual de Usuario', 'DOCUMENTO', 'Documentación para usuarios finales del sistema', 5, 1, 'Redactar manual de usuario', 'Crear guías de uso, tutoriales y documentación para usuarios finales del sistema', 70.00, 85.00, '[{"nombre":"C\\u00f3digo Fuente","tipo":"REFERENCIA"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(12, 2, 'Scripts de Base de Datos', 'SCRIPT_BD', 'Scripts SQL de creación y migración de base de datos', 6, 1, 'Crear scripts de base de datos', 'Desarrollar scripts DDL/DML para creación de tablas, procedimientos y carga inicial de datos', 25.00, 35.00, '[{"nombre":"Dise\\u00f1o de Arquitectura","tipo":"DERIVADO_DE"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(13, 2, 'Plan de Despliegue', 'DOCUMENTO', 'Estrategia y procedimientos para despliegue en producción', 7, 0, 'Elaborar plan de despliegue', 'Documentar procedimientos de instalación, configuración y despliegue en ambientes productivos', 85.00, 95.00, '[{"nombre":"C\\u00f3digo Fuente","tipo":"REFERENCIA"},{"nombre":"Scripts de Base de Datos","tipo":"REFERENCIA"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47'),
	(14, 2, 'Acta de Aceptación', 'DOCUMENTO', 'Documento formal de aceptación del proyecto por el cliente', 8, 0, 'Preparar acta de aceptación', 'Preparar documento formal para firma de aceptación del cliente', 95.00, 100.00, '[{"nombre":"Plan de Pruebas","tipo":"REQUERIDO_POR"},{"nombre":"Manual de Usuario","tipo":"REQUERIDO_POR"}]', '2025-11-04 08:59:47', '2025-11-04 08:59:47');

-- Volcando estructura para tabla sgcs.proyectos
CREATE TABLE IF NOT EXISTS `proyectos` (
  `id` char(36) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_metodologia` bigint(20) unsigned NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `link_repositorio` varchar(255) DEFAULT NULL,
  `creado_por` char(36) NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `proyectos_codigo_unique` (`codigo`),
  KEY `proyectos_id_metodologia_foreign` (`id_metodologia`),
  KEY `proyectos_creado_por_foreign` (`creado_por`),
  CONSTRAINT `proyectos_creado_por_foreign` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `proyectos_id_metodologia_foreign` FOREIGN KEY (`id_metodologia`) REFERENCES `metodologias` (`id_metodologia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.proyectos: ~3 rows (aproximadamente)
INSERT INTO `proyectos` (`id`, `codigo`, `nombre`, `descripcion`, `id_metodologia`, `fecha_inicio`, `fecha_fin`, `link_repositorio`, `creado_por`, `creado_en`, `actualizado_en`) VALUES
	('2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 'PRO-2025-001', 'propopopo código se generará autom', 'asasasasasasasasasasasas', 2, '2025-11-04', '2026-01-04', NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 09:06:23', '2025-11-04 09:06:23'),
	('9f717ea3-622f-4755-b7f5-4983ef9a9940', 'CASCADA-DEMO', 'Sistema ERP Empresarial', 'Proyecto demo con metodología Cascada para sistema empresarial', 2, NULL, NULL, 'https://github.com/demo/cascada-project', '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 08:59:50', '2025-11-04 07:18:23'),
	('f8f729eb-e9ba-432e-86af-d7229d69e6a6', 'SCRUM-DEMO', 'Sistema de Gestión Ágil', 'Proyecto demo con metodología Scrum para gestión de pedidos', 1, NULL, NULL, 'https://github.com/demo/scrum-project', '4f045f7e-8581-4311-96e6-9b14becf58b7', '2025-11-04 08:59:50', '2025-11-04 08:59:50');

-- Volcando estructura para tabla sgcs.relaciones_ec
CREATE TABLE IF NOT EXISTS `relaciones_ec` (
  `id` char(36) NOT NULL,
  `desde_ec` char(36) NOT NULL,
  `hacia_ec` char(36) NOT NULL,
  `tipo_relacion` enum('DEPENDE_DE','DERIVADO_DE','REFERENCIA','REQUERIDO_POR') NOT NULL,
  `nota` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `relaciones_ec_desde_ec_foreign` (`desde_ec`),
  KEY `relaciones_ec_hacia_ec_foreign` (`hacia_ec`),
  CONSTRAINT `relaciones_ec_desde_ec_foreign` FOREIGN KEY (`desde_ec`) REFERENCES `elementos_configuracion` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relaciones_ec_hacia_ec_foreign` FOREIGN KEY (`hacia_ec`) REFERENCES `elementos_configuracion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.relaciones_ec: ~7 rows (aproximadamente)
INSERT INTO `relaciones_ec` (`id`, `desde_ec`, `hacia_ec`, `tipo_relacion`, `nota`) VALUES
	('097f4742-69d4-4262-8677-a5a59ad83d9d', '073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', '4905852c-3d63-4837-ac13-b63b7bd181b6', 'DERIVADO_DE', 'El diagrama ER deriva del diseño arquitectónico'),
	('27bbdcd2-0e95-4c05-8555-b1c34c8cdae6', '5e9f6946-e158-41b7-ad32-5fd7a67d1e61', '073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', 'DERIVADO_DE', 'El script SQL deriva del diagrama ER'),
	('39d5fe02-a51c-47c1-aad7-54702759e0ad', 'e59181da-8d5e-41ac-bde9-fd1adaf61275', '26727f7a-4f94-4654-982a-97d3fa15f3a2', 'DERIVADO_DE', 'Relación automática desde plantilla: Scripts de Base de Datos'),
	('57ca4c35-bb30-4d39-9236-7daab0cba399', '26727f7a-4f94-4654-982a-97d3fa15f3a2', '594a712a-3bd4-431d-9c8b-7a3f845fb1b8', 'DEPENDE_DE', 'Relación automática desde plantilla: Diseño de Arquitectura'),
	('58b748f1-1244-41f4-ba08-43b181ff3fda', '37e8d318-22b6-45b6-bb5b-bd38e84e8f9f', '7e0e82df-e45c-49e6-9557-c9b2ebdfd84d', 'DERIVADO_DE', 'User Story deriva del Product Backlog'),
	('69223f0a-d418-41b2-aa16-d54aabaa1c23', '077232ad-a398-4c6c-89b3-f37a870f6b16', '26727f7a-4f94-4654-982a-97d3fa15f3a2', 'DEPENDE_DE', 'Relación automática desde plantilla: Código Fuente'),
	('6e8859b1-9532-4fe8-98f3-b9d12cb0a4e2', '4905852c-3d63-4837-ac13-b63b7bd181b6', '23266920-3577-4801-b265-3460e7f955ae', 'DERIVADO_DE', 'El diseño deriva de los requisitos'),
	('6f70f86e-990c-4402-9e76-4bdb0f3973bf', 'b04e8a2a-d0c3-4eac-aeb0-ebafffa1b5b9', '077232ad-a398-4c6c-89b3-f37a870f6b16', 'REFERENCIA', 'Relación automática desde plantilla: Manual de Usuario'),
	('77d220de-3975-4b1f-a34d-fd399878ce06', '06033ffd-5653-4604-9cce-0916194d2749', '077232ad-a398-4c6c-89b3-f37a870f6b16', 'DEPENDE_DE', 'Relación automática desde plantilla: Plan de Pruebas'),
	('83576482-1b04-4a30-b7d8-f1833c909f3c', 'd921381c-2ab5-4fc7-8999-9f11dd7951c8', '10af7132-a4df-4dfa-975e-fa609efb0b62', 'DEPENDE_DE', 'Frontend depende de la API Auth'),
	('a88d55dc-fb92-4606-b38d-f20781861caa', '06033ffd-5653-4604-9cce-0916194d2749', '594a712a-3bd4-431d-9c8b-7a3f845fb1b8', 'REFERENCIA', 'Relación automática desde plantilla: Plan de Pruebas'),
	('beffe5d5-fb74-40f6-ad37-5e279335a229', 'e0633357-8c06-48df-9a24-9badaba026d1', '4905852c-3d63-4837-ac13-b63b7bd181b6', 'DEPENDE_DE', 'El módulo Core depende del diseño'),
	('c74872e1-522f-4764-a74c-15fee06ba059', '10af7132-a4df-4dfa-975e-fa609efb0b62', '37e8d318-22b6-45b6-bb5b-bd38e84e8f9f', 'DEPENDE_DE', 'API Auth implementa la User Story de Login');

-- Volcando estructura para tabla sgcs.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_nombre_unique` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.roles: ~7 rows (aproximadamente)
INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `created_at`, `updated_at`) VALUES
	(1, 'administrador', 'Administrador del sistema con acceso completo', NULL, NULL),
	(2, 'lider', 'Líder de proyecto con permisos de gestión', NULL, NULL),
	(3, 'desarrollador', 'Desarrollador con acceso a elementos de configuración', NULL, NULL),
	(4, 'tester', 'Tester con acceso a casos de prueba y elementos de QA', NULL, NULL),
	(5, 'documentador', 'Documentador con acceso a documentos y artefactos', NULL, NULL),
	(6, 'auditor', 'Auditor con acceso de solo lectura para revisiones', NULL, NULL),
	(7, 'cliente', 'Cliente con acceso limitado para seguimiento', NULL, NULL);

-- Volcando estructura para tabla sgcs.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) NOT NULL,
  `usuario_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_usuario_id_index` (`usuario_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.sessions: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.solicitudes_cambio
CREATE TABLE IF NOT EXISTS `solicitudes_cambio` (
  `id` char(36) NOT NULL,
  `proyecto_id` char(36) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `descripcion_cambio` text DEFAULT NULL,
  `motivo_cambio` text DEFAULT NULL,
  `prioridad` enum('BAJA','MEDIA','ALTA','CRITICA') NOT NULL DEFAULT 'MEDIA',
  `estado` enum('ABIERTA','EN_REVISION','APROBADA','RECHAZADA','IMPLEMENTADA','CERRADA') NOT NULL DEFAULT 'ABIERTA',
  `solicitante_id` char(36) DEFAULT NULL,
  `origen_cambio` varchar(255) DEFAULT NULL,
  `resumen_impacto` text DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `solicitudes_cambio_proyecto_id_foreign` (`proyecto_id`),
  KEY `solicitudes_cambio_solicitante_id_foreign` (`solicitante_id`),
  CONSTRAINT `solicitudes_cambio_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `solicitudes_cambio_solicitante_id_foreign` FOREIGN KEY (`solicitante_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.solicitudes_cambio: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.tareas_proyecto
CREATE TABLE IF NOT EXISTS `tareas_proyecto` (
  `id_tarea` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `prioridad` int(11) NOT NULL DEFAULT 3,
  `story_points` int(11) DEFAULT NULL COMMENT 'Solo para Scrum',
  `sprint` varchar(50) DEFAULT NULL COMMENT 'Solo para Scrum',
  `horas_estimadas` decimal(8,2) DEFAULT NULL COMMENT 'Más usado en Cascada',
  `entregable` varchar(255) DEFAULT NULL COMMENT 'Específico de Cascada',
  `criterios_aceptacion` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`criterios_aceptacion`)),
  `notas` text DEFAULT NULL,
  `creado_por` char(36) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_proyecto` char(36) NOT NULL,
  `id_fase` bigint(20) unsigned NOT NULL,
  `id_ec` char(36) DEFAULT NULL,
  `responsable` char(36) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `duracion_minima` int(11) DEFAULT NULL COMMENT 'Duración mínima posible en días',
  `es_ruta_critica` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Indica si la tarea está en la ruta crítica',
  `holgura_dias` int(11) NOT NULL DEFAULT 0 COMMENT 'Días de holgura (slack) - 0 para ruta crítica',
  `fecha_inicio_original` date DEFAULT NULL COMMENT 'Fecha original antes de ajustes automáticos',
  `fecha_fin_original` date DEFAULT NULL COMMENT 'Fecha original antes de ajustes automáticos',
  `puede_paralelizarse` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Indica si la tarea puede ejecutarse en paralelo con otras',
  `dependencias` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'IDs de tareas de las que depende esta tarea' CHECK (json_valid(`dependencias`)),
  `progreso_real` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Porcentaje de progreso real (0-100)',
  PRIMARY KEY (`id_tarea`),
  KEY `tareas_proyecto_id_proyecto_foreign` (`id_proyecto`),
  KEY `tareas_proyecto_id_fase_foreign` (`id_fase`),
  KEY `tareas_proyecto_responsable_foreign` (`responsable`),
  KEY `tareas_proyecto_id_ec_foreign` (`id_ec`),
  KEY `tareas_proyecto_creado_por_foreign` (`creado_por`),
  KEY `tareas_proyecto_es_ruta_critica_index` (`es_ruta_critica`),
  KEY `tareas_proyecto_fecha_inicio_fecha_fin_index` (`fecha_inicio`,`fecha_fin`),
  CONSTRAINT `tareas_proyecto_creado_por_foreign` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tareas_proyecto_id_ec_foreign` FOREIGN KEY (`id_ec`) REFERENCES `elementos_configuracion` (`id`),
  CONSTRAINT `tareas_proyecto_id_fase_foreign` FOREIGN KEY (`id_fase`) REFERENCES `fases_metodologia` (`id_fase`),
  CONSTRAINT `tareas_proyecto_id_proyecto_foreign` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `tareas_proyecto_responsable_foreign` FOREIGN KEY (`responsable`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.tareas_proyecto: ~20 rows (aproximadamente)
INSERT INTO `tareas_proyecto` (`id_tarea`, `nombre`, `descripcion`, `prioridad`, `story_points`, `sprint`, `horas_estimadas`, `entregable`, `criterios_aceptacion`, `notas`, `creado_por`, `creado_en`, `actualizado_en`, `id_proyecto`, `id_fase`, `id_ec`, `responsable`, `fecha_inicio`, `fecha_fin`, `estado`, `duracion_minima`, `es_ruta_critica`, `holgura_dias`, `fecha_inicio_original`, `fecha_fin_original`, `puede_paralelizarse`, `dependencias`, `progreso_real`) VALUES
	(1, 'Crear Product Backlog', 'Tarea del proyecto Scrum: Crear Product Backlog', 3, 2, 'Sprint 1', 4.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 1, '7e0e82df-e45c-49e6-9557-c9b2ebdfd84d', '5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', '2025-11-04', '2025-11-05', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(2, 'Sprint Planning - Sprint 1', 'Tarea del proyecto Scrum: Sprint Planning - Sprint 1', 3, 3, 'Sprint 1', 6.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 2, 'c682d045-99a4-4d2d-b07b-264c16be2e43', '60a17106-69d7-40e1-b749-cd1f5ec40c31', '2025-11-06', '2025-11-07', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(3, 'Implementar API Auth', 'Tarea del proyecto Scrum: Implementar API Auth', 3, 8, 'Sprint 1', 20.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 3, 'c682d045-99a4-4d2d-b07b-264c16be2e43', '60a17106-69d7-40e1-b749-cd1f5ec40c31', '2025-11-08', '2025-11-13', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(4, 'Diseñar UI Login', 'Tarea del proyecto Scrum: Diseñar UI Login', 2, 5, 'Sprint 1', 12.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 3, '54e82749-8bdb-4c8b-8c2a-f8933bacad59', '60a17106-69d7-40e1-b749-cd1f5ec40c31', '2025-11-14', '2025-11-17', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(5, 'Code Review - Auth Module', 'Tarea del proyecto Scrum: Code Review - Auth Module', 2, 2, 'Sprint 1', 4.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 4, '37e8d318-22b6-45b6-bb5b-bd38e84e8f9f', '5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', '2025-11-18', '2025-11-19', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(6, 'Deploy Sprint 1', 'Tarea del proyecto Scrum: Deploy Sprint 1', 3, 3, 'Sprint 1', 6.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50', 'f8f729eb-e9ba-432e-86af-d7229d69e6a6', 5, '73555a44-1567-40f3-b739-074dee5f94b2', '5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', '2025-11-20', '2025-11-21', 'pendiente', NULL, 0, 0, NULL, NULL, 0, NULL, 0.00),
	(7, 'Levantamiento de Requisitos', 'Tarea del proyecto Cascada: Levantamiento de Requisitos', 3, 5, NULL, 16.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 04:28:42', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 6, '23266920-3577-4801-b265-3460e7f955ae', '60a17106-69d7-40e1-b749-cd1f5ec40c31', '2025-11-04', '2025-11-07', 'pendiente', NULL, 0, 7, NULL, NULL, 0, NULL, 0.00),
	(8, 'Análisis de Viabilidad', 'Tarea del proyecto Cascada: Análisis de Viabilidad', 2, 3, NULL, 8.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 04:28:42', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 7, '23266920-3577-4801-b265-3460e7f955ae', '4f045f7e-8581-4311-96e6-9b14becf58b7', '2025-11-08', '2025-11-10', 'pendiente', NULL, 0, 8, NULL, NULL, 0, NULL, 0.00),
	(9, 'Diseño de Arquitectura', 'Tarea del proyecto Cascada: Diseño de Arquitectura', 3, 8, NULL, 20.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 05:31:48', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 8, '073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', 'b15cf851-1d78-49ba-89de-d6200e3b07ad', '2025-11-11', '2025-11-16', 'completado', NULL, 0, 5, NULL, NULL, 0, NULL, 0.00),
	(10, 'Diseño de Base de Datos', 'Tarea del proyecto Cascada: Diseño de Base de Datos', 3, 5, NULL, 12.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 05:34:50', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 8, '5e9f6946-e158-41b7-ad32-5fd7a67d1e61', 'b15cf851-1d78-49ba-89de-d6200e3b07ad', '2025-11-17', '2025-11-20', 'pendiente', NULL, 0, 7, NULL, NULL, 0, NULL, 0.00),
	(11, 'Desarrollo Módulo Core', 'Tarea del proyecto Cascada: Desarrollo Módulo Core', 3, 13, NULL, 40.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 04:28:42', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 9, '073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', '60a17106-69d7-40e1-b749-cd1f5ec40c31', '2025-11-21', '2025-12-01', 'pendiente', NULL, 1, 0, NULL, NULL, 0, NULL, 0.00),
	(12, 'Pruebas de Integración', 'Tarea del proyecto Cascada: Pruebas de Integración', 2, 5, NULL, 16.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 04:28:42', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 10, '073d8cd2-f1f6-4ea5-b4d7-ed2ad9b79b24', 'b15cf851-1d78-49ba-89de-d6200e3b07ad', '2025-12-02', '2025-12-06', 'pendiente', NULL, 0, 6, NULL, NULL, 0, NULL, 0.00),
	(13, 'Deploy a Producción', 'Tarea del proyecto Cascada: Deploy a Producción', 3, 3, NULL, 8.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 05:23:30', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 11, '908dd934-d3e0-4a53-b2f1-faebb80c0408', 'b15cf851-1d78-49ba-89de-d6200e3b07ad', '2025-12-07', '2025-12-09', 'Pendiente', NULL, 0, 8, NULL, NULL, 0, NULL, 0.00),
	(14, 'Soporte Post-Despliegue', 'Tarea del proyecto Cascada: Soporte Post-Despliegue', 1, 2, NULL, 8.00, NULL, NULL, 'Generado automáticamente', NULL, '2025-11-04 08:59:50', '2025-11-04 04:28:42', '9f717ea3-622f-4755-b7f5-4983ef9a9940', 12, '5e9f6946-e158-41b7-ad32-5fd7a67d1e61', '4f045f7e-8581-4311-96e6-9b14becf58b7', '2025-12-10', '2025-12-13', 'pendiente', NULL, 0, 7, NULL, NULL, 0, NULL, 0.00),
	(15, 'Recopilar y documentar requisitos', 'Realizar entrevistas con stakeholders y documentar todos los requisitos funcionales y no funcionales', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:04', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, '594a712a-3bd4-431d-9c8b-7a3f845fb1b8', NULL, '2025-11-04', '2025-11-13', 'pendiente', NULL, 0, 10, NULL, NULL, 0, NULL, 0.00),
	(16, 'Diseñar arquitectura del sistema', 'Crear diagramas UML, arquitectura de componentes, diseño de base de datos y especificaciones técnicas', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:04', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, '26727f7a-4f94-4654-982a-97d3fa15f3a2', NULL, '2025-11-13', '2025-11-22', 'pendiente', NULL, 0, 10, NULL, NULL, 0, NULL, 0.00),
	(17, 'Configurar estructura del proyecto', 'Inicializar proyecto, configurar dependencias y establecer estructura de carpetas según diseño', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:05', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, '077232ad-a398-4c6c-89b3-f37a870f6b16', NULL, '2025-11-22', '2025-12-11', 'pendiente', NULL, 1, 0, NULL, NULL, 0, NULL, 0.00),
	(18, 'Elaborar plan de pruebas', 'Definir estrategia de testing, diseñar casos de prueba y crear matriz de trazabilidad de requisitos', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:06', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, '06033ffd-5653-4604-9cce-0916194d2749', NULL, '2025-12-05', '2025-12-17', 'pendiente', NULL, 0, 7, NULL, NULL, 0, NULL, 0.00),
	(19, 'Redactar manual de usuario', 'Crear guías de uso, tutoriales y documentación para usuarios finales del sistema', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:07', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, 'b04e8a2a-d0c3-4eac-aeb0-ebafffa1b5b9', NULL, '2025-12-17', '2025-12-26', 'pendiente', NULL, 0, 10, NULL, NULL, 0, NULL, 0.00),
	(20, 'Crear scripts de base de datos', 'Desarrollar scripts DDL/DML para creación de tablas, procedimientos y carga inicial de datos', 3, NULL, NULL, NULL, NULL, NULL, NULL, '0fe41d2f-e361-48b6-9673-b83ebdb6e676', '2025-11-04 04:06:23', '2025-11-04 05:31:07', '2187c77c-8d78-4c3a-b0c0-2f6bec2b9f77', 6, 'e59181da-8d5e-41ac-bde9-fd1adaf61275', NULL, '2025-11-19', '2025-11-25', 'pendiente', NULL, 0, 13, NULL, NULL, 0, NULL, 0.00);

-- Volcando estructura para tabla sgcs.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` char(36) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `correo_verificado_en` timestamp NULL DEFAULT NULL,
  `nombre_completo` varchar(255) NOT NULL,
  `contrasena_hash` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `google2fa_secret` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_correo_unique` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.usuarios: ~5 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `correo`, `correo_verificado_en`, `nombre_completo`, `contrasena_hash`, `activo`, `remember_token`, `google2fa_secret`, `creado_en`, `actualizado_en`) VALUES
	('0fe41d2f-e361-48b6-9673-b83ebdb6e676', 'lider@demo.com', '2025-11-04 08:59:49', 'Líder Demo', '$2y$12$hCjYPlvarcXmcKkMhgEXle5.mIfkg9MqwnullB7kQ2c0G8.KVOqa2', 1, NULL, NULL, '2025-11-04 08:59:49', '2025-11-04 08:59:49'),
	('4f045f7e-8581-4311-96e6-9b14becf58b7', 'admin@demo.com', '2025-11-04 08:59:49', 'Admin Demo', '$2y$12$mbqqC89Ebl2SbTrtyFLQw.H4G3JSsYkIcBaKpsiqawmTmd5xh1bie', 1, NULL, NULL, '2025-11-04 08:59:49', '2025-11-04 08:59:49'),
	('5d96e2d1-1a7f-4829-976f-6d07a66e9ce1', 'dev1@demo.com', '2025-11-04 08:59:49', 'Desarrollador 1', '$2y$12$uwQNR/FfTk8d56jCtl6qFOxgo9p9lCvXfRGmN0pHxD.QP6US9vH2a', 1, NULL, NULL, '2025-11-04 08:59:49', '2025-11-04 08:59:49'),
	('60a17106-69d7-40e1-b749-cd1f5ec40c31', 'tester@demo.com', '2025-11-04 08:59:50', 'Tester Demo', '$2y$12$Bhg3TVINQFe0yk.gSw4k9ekpTNrUREbaOxlsNdY32SyPop4S7IRIS', 1, NULL, NULL, '2025-11-04 08:59:50', '2025-11-04 08:59:50'),
	('b15cf851-1d78-49ba-89de-d6200e3b07ad', 'dev2@demo.com', '2025-11-04 08:59:49', 'Desarrollador 2', '$2y$12$f3nLYd6yvlwca7RXAVwy3e/uYjsmDTKaUWsJhJREyzVDQ.YXWPxbG', 1, NULL, NULL, '2025-11-04 08:59:49', '2025-11-04 08:59:49');

-- Volcando estructura para tabla sgcs.usuarios_roles
CREATE TABLE IF NOT EXISTS `usuarios_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` char(36) NOT NULL,
  `rol_id` bigint(20) unsigned NOT NULL,
  `proyecto_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usuarios_roles_usuario_id_foreign` (`usuario_id`),
  KEY `usuarios_roles_rol_id_foreign` (`rol_id`),
  KEY `usuarios_roles_proyecto_id_foreign` (`proyecto_id`),
  CONSTRAINT `usuarios_roles_proyecto_id_foreign` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `usuarios_roles_rol_id_foreign` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `usuarios_roles_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.usuarios_roles: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.versiones_ec
CREATE TABLE IF NOT EXISTS `versiones_ec` (
  `id` char(36) NOT NULL,
  `ec_id` char(36) NOT NULL,
  `version` varchar(50) NOT NULL,
  `registro_cambios` text DEFAULT NULL,
  `commit_id` char(36) DEFAULT NULL,
  `metadatos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadatos`)),
  `estado` enum('PENDIENTE','BORRADOR','REVISION','APROBADO','LIBERADO','DEPRECADO') NOT NULL DEFAULT 'PENDIENTE',
  `creado_por` char(36) DEFAULT NULL,
  `aprobado_por` char(36) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `aprobado_en` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `versiones_ec_ec_id_foreign` (`ec_id`),
  KEY `versiones_ec_creado_por_foreign` (`creado_por`),
  KEY `versiones_ec_aprobado_por_foreign` (`aprobado_por`),
  CONSTRAINT `versiones_ec_aprobado_por_foreign` FOREIGN KEY (`aprobado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `versiones_ec_creado_por_foreign` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `versiones_ec_ec_id_foreign` FOREIGN KEY (`ec_id`) REFERENCES `elementos_configuracion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.versiones_ec: ~0 rows (aproximadamente)

-- Volcando estructura para tabla sgcs.votos_ccb
CREATE TABLE IF NOT EXISTS `votos_ccb` (
  `id` char(36) NOT NULL,
  `ccb_id` char(36) NOT NULL,
  `solicitud_cambio_id` char(36) NOT NULL,
  `usuario_id` char(36) NOT NULL,
  `voto` enum('APROBAR','RECHAZAR','ABSTENERSE') NOT NULL,
  `comentario` text DEFAULT NULL,
  `votado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `votos_ccb_ccb_id_foreign` (`ccb_id`),
  KEY `votos_ccb_solicitud_cambio_id_foreign` (`solicitud_cambio_id`),
  KEY `votos_ccb_usuario_id_foreign` (`usuario_id`),
  CONSTRAINT `votos_ccb_ccb_id_foreign` FOREIGN KEY (`ccb_id`) REFERENCES `comite_cambios` (`id`),
  CONSTRAINT `votos_ccb_solicitud_cambio_id_foreign` FOREIGN KEY (`solicitud_cambio_id`) REFERENCES `solicitudes_cambio` (`id`),
  CONSTRAINT `votos_ccb_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla sgcs.votos_ccb: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
