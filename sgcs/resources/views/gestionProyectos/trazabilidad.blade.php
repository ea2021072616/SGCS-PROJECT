<x-app-layout>
    <x-slot name="header">
        <div class="flex justify-between items-center">
            <div>
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                    Trazabilidad del Proyecto
                </h2>
                <p class="text-sm text-gray-600 mt-1">
                    {{ $proyecto->codigo }} - {{ $proyecto->nombre }}
                </p>
            </div>
            <div class="flex gap-2">
                <a href="{{ route('proyectos.show', $proyecto) }}" class="btn btn-ghost btn-sm">
                    <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    Volver al Proyecto
                </a>
            </div>
        </div>
    </x-slot>

    <div class="py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

            @if($elementos->isEmpty())
                <div class="alert alert-info">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span class="text-gray-900">Este proyecto no tiene elementos de configuración todavía.</span>
                </div>
            @else
                <!-- Leyenda de tipos de relación -->
                <div class="card bg-white shadow-md border border-gray-200 mb-6">
                    <div class="card-body text-gray-900">
                        <h3 class="font-bold text-lg mb-3">
                            <svg class="w-6 h-6 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            Leyenda de Relaciones
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-3">
                            <div class="flex items-center gap-2">
                                <span class="badge badge-error badge-sm">DEPENDE_DE</span>
                                <span class="text-sm text-gray-700">Requiere otro elemento</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="badge badge-warning badge-sm">DERIVADO_DE</span>
                                <span class="text-sm text-gray-700">Extensión de otro</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="badge badge-info badge-sm">REFERENCIA</span>
                                <span class="text-sm text-gray-700">Hace referencia</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="badge badge-success badge-sm">REQUERIDO_POR</span>
                                <span class="text-sm text-gray-700">Es requerido</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gráfico Jerárquico -->
                <div class="card bg-white shadow-md border border-gray-200">
                    <div class="card-body text-gray-900">
                        <h3 class="font-bold text-lg mb-6">
                            <svg class="w-6 h-6 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                            </svg>
                            Diagrama de Niveles
                        </h3>

                        @foreach($niveles as $nivelNum => $elementosIds)
                            <div class="mb-8">
                                <!-- Nivel Header -->
                                <div class="flex items-center gap-3 mb-4">
                                    <div class="badge badge-lg bg-gradient-to-r from-blue-500 to-purple-500 text-white font-bold">
                                        Nivel {{ $nivelNum }}
                                    </div>
                                    @if($nivelNum === 0)
                                        <span class="text-sm text-gray-600">Elementos base (sin dependencias)</span>
                                    @else
                                        <span class="text-sm text-gray-600">Dependen del nivel anterior</span>
                                    @endif
                                </div>

                                <!-- Elementos del Nivel -->
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 ml-6">
                                    @foreach($elementosIds as $elementoId)
                                        @php
                                            $elemento = $elementos->firstWhere('id', $elementoId);
                                        @endphp
                                        @if($elemento)
                                            <div class="card bg-gradient-to-br from-gray-50 to-white border-2 border-gray-300 hover:border-blue-400 hover:shadow-lg transition-all duration-200">
                                                <div class="card-body p-4">
                                                    <!-- Header -->
                                                    <div class="flex items-start justify-between mb-2">
                                                        <span class="badge {{ $elemento->tipoBadge }} badge-sm">
                                                            {{ $elemento->tipo }}
                                                        </span>
                                                        <span class="text-xs text-gray-500">{{ $elemento->codigo_ec }}</span>
                                                    </div>

                                                    <!-- Título -->
                                                    <h4 class="font-bold text-sm text-gray-900 mb-2 line-clamp-2">
                                                        {{ $elemento->titulo }}
                                                    </h4>

                                                    <!-- Estado -->
                                                    <div class="mb-3">
                                                        <span class="badge badge-outline badge-xs {{
                                                            $elemento->estado === 'LIBERADO' ? 'badge-success' :
                                                            ($elemento->estado === 'APROBADO' ? 'badge-info' :
                                                            ($elemento->estado === 'EN_REVISION' ? 'badge-warning' : 'badge-ghost'))
                                                        }}">
                                                            {{ $elemento->estado }}
                                                        </span>
                                                    </div>

                                                    <!-- Relaciones -->
                                                    @if($elemento->relacionesDesde->isNotEmpty() || $elemento->relacionesHacia->isNotEmpty())
                                                        <div class="divider my-2"></div>
                                                        <div class="text-xs space-y-1">
                                                            @if($elemento->relacionesDesde->isNotEmpty())
                                                                <div class="flex items-center gap-1 text-blue-600">
                                                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/>
                                                                    </svg>
                                                                    <span>{{ $elemento->relacionesDesde->count() }} salientes</span>
                                                                </div>
                                                            @endif
                                                            @if($elemento->relacionesHacia->isNotEmpty())
                                                                <div class="flex items-center gap-1 text-green-600">
                                                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                                                    </svg>
                                                                    <span>{{ $elemento->relacionesHacia->count() }} entrantes</span>
                                                                </div>
                                                            @endif
                                                        </div>
                                                    @endif

                                                    <!-- Botón Ver Detalles -->
                                                    <div class="card-actions justify-end mt-3">
                                                        <a href="{{ route('proyectos.elementos.relaciones.index', [$proyecto, $elemento]) }}"
                                                           class="btn btn-xs btn-outline">
                                                            Ver Detalles
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        @endif
                                    @endforeach
                                </div>

                                <!-- Conector visual -->
                                @if($nivelNum < count($niveles) - 1)
                                    <div class="flex justify-center my-4">
                                        <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
                                        </svg>
                                    </div>
                                @endif
                            </div>
                        @endforeach

                    </div>
                </div>

                <!-- Estadísticas -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
                    <div class="stat bg-white shadow border border-gray-200">
                        <div class="stat-figure text-primary">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                        </div>
                        <div class="stat-title text-gray-600">Total EC</div>
                        <div class="stat-value text-gray-900">{{ $elementos->count() }}</div>
                    </div>

                    <div class="stat bg-white shadow border border-gray-200">
                        <div class="stat-figure text-success">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"/>
                            </svg>
                        </div>
                        <div class="stat-title text-gray-600">Relaciones</div>
                        <div class="stat-value text-gray-900">
                            {{ $elementos->sum(fn($e) => $e->relacionesDesde->count()) }}
                        </div>
                    </div>

                    <div class="stat bg-white shadow border border-gray-200">
                        <div class="stat-figure text-info">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                            </svg>
                        </div>
                        <div class="stat-title text-gray-600">Niveles</div>
                        <div class="stat-value text-gray-900">{{ count($niveles) }}</div>
                    </div>

                    <div class="stat bg-white shadow border border-gray-200">
                        <div class="stat-figure text-warning">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"/>
                            </svg>
                        </div>
                        <div class="stat-title text-gray-600">Elem. Base</div>
                        <div class="stat-value text-gray-900">{{ count($niveles[0] ?? []) }}</div>
                    </div>
                </div>
            @endif

        </div>
    </div>
</x-app-layout>
