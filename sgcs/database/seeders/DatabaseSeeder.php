<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            MetodologiasSeeder::class,          // 1. Metodologías y Fases
            PlantillasECSeeder::class,          // 2. Plantillas EC (NUEVO)
            RolesSeeder::class,                 // 3. Roles
            UsuarioSeeder::class,               // 4. Usuarios
            ProyectoSeeder::class,              // 5. Proyectos (Scrum y Cascada)
            EquipoSeeder::class,                // 6. Equipos y Miembros
            ElementoConfiguracionSeeder::class, // 7. ECs y Relaciones
            TareasProyectoSeeder::class,        // 8. Tareas por proyecto
        ]);

        $this->command->info('✅ Base de datos poblada con proyectos Scrum y Cascada completos');
    }
}
