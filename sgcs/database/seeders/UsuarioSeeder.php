<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\Usuario;

class UsuarioSeeder extends Seeder
{
    public function run(): void
    {
        // Usuarios demo para los dos proyectos
        Usuario::firstOrCreate(['correo' => 'admin@demo.com'], [
            'id' => Str::uuid()->toString(),
            'nombre_completo' => 'Admin Demo',
            'contrasena_hash' => Hash::make('admin123'),
            'correo_verificado_en' => now(),
        ]);

        Usuario::firstOrCreate(['correo' => 'lider@demo.com'], [
            'id' => Str::uuid()->toString(),
            'nombre_completo' => 'Líder Demo',
            'contrasena_hash' => Hash::make('lider123'),
            'correo_verificado_en' => now(),
        ]);

        Usuario::firstOrCreate(['correo' => 'dev1@demo.com'], [
            'id' => Str::uuid()->toString(),
            'nombre_completo' => 'Desarrollador 1',
            'contrasena_hash' => Hash::make('dev123'),
            'correo_verificado_en' => now(),
        ]);

        Usuario::firstOrCreate(['correo' => 'dev2@demo.com'], [
            'id' => Str::uuid()->toString(),
            'nombre_completo' => 'Desarrollador 2',
            'contrasena_hash' => Hash::make('dev123'),
            'correo_verificado_en' => now(),
        ]);

        Usuario::firstOrCreate(['correo' => 'tester@demo.com'], [
            'id' => Str::uuid()->toString(),
            'nombre_completo' => 'Tester Demo',
            'contrasena_hash' => Hash::make('test123'),
            'correo_verificado_en' => now(),
        ]);
    }
}
