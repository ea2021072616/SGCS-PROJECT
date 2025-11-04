<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RolesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Roles dignos de un SGCS profesional
        $roles = [
            [
                'nombre' => 'Gestor de Configuración',
                'descripcion' => 'Responsable de la gestión de configuración del software (SCM Manager)'
            ],
            [
                'nombre' => 'Administrador CCB',
                'descripcion' => 'Administrador del Comité de Control de Cambios (CCB Administrator)'
            ],
            [
                'nombre' => 'Líder de Proyecto',
                'descripcion' => 'Líder técnico y gestor del proyecto (Project Leader)'
            ],
            [
                'nombre' => 'Product Owner',
                'descripcion' => 'Dueño del producto, define prioridades y requisitos (PO)'
            ],
            [
                'nombre' => 'Scrum Master',
                'descripcion' => 'Facilitador del proceso Scrum y eliminador de impedimentos'
            ],
            [
                'nombre' => 'Desarrollador Senior',
                'descripcion' => 'Desarrollador con experiencia y capacidad de revisión de código'
            ],
            [
                'nombre' => 'Desarrollador',
                'descripcion' => 'Desarrollador de software con acceso a elementos de configuración'
            ],
            [
                'nombre' => 'Analista QA',
                'descripcion' => 'Analista de aseguramiento de calidad (Quality Assurance)'
            ],
            [
                'nombre' => 'Tester',
                'descripcion' => 'Responsable de pruebas y validación de software'
            ],
            [
                'nombre' => 'Arquitecto de Software',
                'descripcion' => 'Diseñador de arquitectura y decisiones técnicas estratégicas'
            ],
            [
                'nombre' => 'Auditor de Configuración',
                'descripcion' => 'Auditor de cumplimiento de procesos de gestión de configuración'
            ],
            [
                'nombre' => 'Release Manager',
                'descripcion' => 'Gestor de liberaciones y despliegues a producción'
            ]
        ];

        foreach ($roles as $rol) {
            DB::table('roles')->insertOrIgnore($rol);
        }
    }
}