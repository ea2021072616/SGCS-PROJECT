<?php

namespace App\Http\Controllers;

use App\Models\Proyecto;
use App\Models\Usuario;
use App\Models\Equipo;
use App\Models\MiembroEquipo;
use App\Models\Metodologia;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $usuarioId = Auth::user()->id;

        // 📊 INDICADORES GENERALES

        // 1. Proyectos que YO creé
        $proyectosCreados = Proyecto::where('creado_por', $usuarioId)->count();

        // 2. Proyectos donde SOY miembro (a través de equipos)
        $proyectosAsignados = Proyecto::whereHas('equipos.miembros', function ($query) use ($usuarioId) {
            $query->where('usuario_id', $usuarioId);
        })->count();

        // 3. TODOS mis proyectos (creados + asignados sin duplicar)
        $misProyectosIds = Proyecto::where('creado_por', $usuarioId)
            ->orWhereHas('equipos.miembros', function ($query) use ($usuarioId) {
                $query->where('usuario_id', $usuarioId);
            })
            ->pluck('id');

        // 4. Total de liberaciones en mis proyectos
        $totalLiberaciones = DB::table('liberaciones')
            ->whereIn('proyecto_id', $misProyectosIds)
            ->count();

        // 5. Liberaciones este mes
        $liberacionesMes = DB::table('liberaciones')
            ->whereIn('proyecto_id', $misProyectosIds)
            ->whereMonth('fecha_liberacion', now()->month)
            ->whereYear('fecha_liberacion', now()->year)
            ->count();

        // 📁 TODOS MIS PROYECTOS (creados + asignados, máximo 10 recientes)
        $todosProyectosCollection = Proyecto::with(['equipos' => function($query) use ($usuarioId) {
                $query->withCount('miembros')
                      ->with(['miembros' => function($q) use ($usuarioId) {
                          $q->where('usuario_id', $usuarioId);
                      }]);
            }])
            ->whereIn('id', $misProyectosIds)
            ->orderBy('creado_en', 'desc')
            ->limit(10)
            ->get();

        // Resolver nombres de metodologías en batch para evitar N+1
        $metodologiaIds = $todosProyectosCollection->pluck('id_metodologia')->filter()->unique()->values()->all();
        $metodologiasMap = Metodologia::whereIn('id_metodologia', $metodologiaIds)->get()->keyBy('id_metodologia')->map(function($m) { return $m->nombre; });

        $misProyectos = $todosProyectosCollection->map(function($proyecto) use ($metodologiasMap, $usuarioId) {
                // Calcular progreso real basado en tareas
                $totalTareas = $proyecto->tareas()->count();
                $tareasCompletadas = $proyecto->tareas()
                    ->whereIn('estado', ['COMPLETADA', 'Done', 'DONE'])
                    ->count();

                $progreso = $totalTareas > 0
                    ? round(($tareasCompletadas / $totalTareas) * 100, 1)
                    : 0;

                $metNombre = $metodologiasMap[$proyecto->id_metodologia] ?? 'No especificada';

                // Determinar mi rol en el proyecto
                $miRol = 'Creador';
                $nombreEquipo = null;

                if ($proyecto->creado_por != $usuarioId) {
                    // Soy miembro, buscar mi rol
                    $miEquipo = $proyecto->equipos->first();
                    if ($miEquipo && $miEquipo->miembros->isNotEmpty()) {
                        $miembro = $miEquipo->miembros->first();
                        $rolId = $miembro->pivot->rol_id;
                        $miRol = \App\Models\Rol::find($rolId)->nombre ?? 'Miembro';
                        $nombreEquipo = $miEquipo->nombre;
                    }
                }

                return [
                    'id' => $proyecto->id,
                    'codigo' => $proyecto->codigo,
                    'nombre' => $proyecto->nombre,
                    'id_metodologia' => $proyecto->id_metodologia,
                    'metodologia' => $metNombre,
                    'total_equipos' => $proyecto->equipos->count(),
                    'total_miembros' => $proyecto->equipos->sum('miembros_count'),
                    'progreso' => $progreso,
                    'estado' => 'Activo', // temporal
                    'iniciales' => $this->getIniciales($proyecto->nombre),
                    'mi_rol' => $miRol,
                    'nombre_equipo' => $nombreEquipo,
                    'es_creador' => $proyecto->creado_por == $usuarioId,
                ];
            });

        return view('dashboard', compact(
            'proyectosCreados',
            'proyectosAsignados',
            'totalLiberaciones',
            'liberacionesMes',
            'misProyectos'
        ));
    }

    /**
     * Generar iniciales del nombre del proyecto
     */
    private function getIniciales($nombre)
    {
        $palabras = explode(' ', $nombre);
        if (count($palabras) >= 2) {
            return strtoupper(substr($palabras[0], 0, 1) . substr($palabras[1], 0, 1));
        }
        return strtoupper(substr($nombre, 0, 2));
    }
}
