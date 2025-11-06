<x-app-layout>
    <div class="py-8 bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">

            <!-- Header Mejorado -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                <div class="relative">
                    <!-- Barra de color sutil arriba -->
                    <div class="h-2 bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500"></div>

                    <div class="p-8">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900 mb-2">
                                    Hola, <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">{{ Auth::user()->nombre_completo }}</span>
                                </h1>
                                <p class="text-gray-600">Bienvenido al panel. Aquí verás tus proyectos y acciones rápidas.</p>
                            </div>
                            <div>
                                @if (Route::has('proyectos.create'))
                                    <a href="{{ route('proyectos.create') }}" class="group inline-flex items-center gap-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-3 rounded-xl hover:shadow-lg hover:scale-105 transition-all duration-200 font-medium">
                                        <svg class="w-5 h-5 group-hover:rotate-90 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                        </svg>
                                        Nuevo Proyecto
                                    </a>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Indicadores con diseño moderno -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Proyectos Creados -->
                <div class="group bg-white rounded-2xl shadow-sm border border-blue-100 p-6 hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-blue-50 rounded-full -mr-16 -mt-16 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gradient-to-br from-blue-400 to-blue-500 rounded-xl flex items-center justify-center shadow-md shadow-blue-500/20">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                </svg>
                            </div>
                        </div>
                        <h3 class="text-blue-600 text-sm font-semibold mb-1">Proyectos Creados</h3>
                        <p class="text-4xl font-bold text-blue-700 mb-1">{{ $proyectosCreados }}</p>
                        <p class="text-xs text-blue-500">Proyectos que yo creé</p>
                    </div>
                </div>

                <!-- Proyectos Asignados -->
                <div class="group bg-white rounded-2xl shadow-sm border border-purple-100 p-6 hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-purple-50 rounded-full -mr-16 -mt-16 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-purple-500 rounded-xl flex items-center justify-center shadow-md shadow-purple-500/20">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                </svg>
                            </div>
                        </div>
                        <h3 class="text-purple-600 text-sm font-semibold mb-1">Proyectos Asignados</h3>
                        <p class="text-4xl font-bold text-purple-700 mb-1">{{ $proyectosAsignados }}</p>
                        <p class="text-xs text-purple-500">Soy miembro del equipo</p>
                    </div>
                </div>

                <!-- Total Liberaciones -->
                <div class="group bg-white rounded-2xl shadow-sm border border-teal-100 p-6 hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-teal-50 rounded-full -mr-16 -mt-16 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gradient-to-br from-teal-400 to-teal-500 rounded-xl flex items-center justify-center shadow-md shadow-teal-500/20">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
                                </svg>
                            </div>
                        </div>
                        <h3 class="text-teal-600 text-sm font-semibold mb-1">Total Liberaciones</h3>
                        <p class="text-4xl font-bold text-teal-700 mb-1">{{ $totalLiberaciones }}</p>
                        <p class="text-xs text-teal-500">Todas mis liberaciones</p>
                    </div>
                </div>

                <!-- Liberaciones Este Mes -->
                <div class="group bg-white rounded-2xl shadow-sm border border-pink-100 p-6 hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-pink-50 rounded-full -mr-16 -mt-16 group-hover:scale-150 transition-transform duration-500"></div>
                    <div class="relative">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 bg-gradient-to-br from-pink-400 to-pink-500 rounded-xl flex items-center justify-center shadow-md shadow-pink-500/20">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2-2v12a2 2 0 002 2z"/>
                                </svg>
                            </div>
                        </div>
                        <h3 class="text-pink-600 text-sm font-semibold mb-1">Liberaciones del Mes</h3>
                        <p class="text-4xl font-bold text-pink-700 mb-1">{{ $liberacionesMes }}</p>
                        <p class="text-xs text-pink-500">Este mes</p>
                    </div>
                </div>
            </div>

            <!-- Grid Principal: Proyectos unificados -->
            <div class="grid grid-cols-1 gap-8">

                <!-- MIS PROYECTOS (Creados + Asignados) -->
                <div class="bg-white rounded-2xl shadow-lg border border-indigo-100 overflow-hidden">
                    <!-- Header con gradiente -->
                    <div class="relative bg-gradient-to-r from-indigo-400 to-purple-500 border-b border-indigo-200">
                        <div class="p-6">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center shadow-md">
                                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                                        </svg>
                                    </div>
                                    <div>
                                        <h2 class="text-xl font-bold text-white">Mis Proyectos</h2>
                                        <p class="text-sm text-indigo-50">Todos los proyectos donde participo</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-2xl font-bold text-white">{{ $misProyectos->count() }}</p>
                                    <p class="text-sm text-indigo-100">proyectos activos</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="p-6">
                        @if($misProyectos->isEmpty())
                            <div class="text-center py-12">
                                <div class="w-20 h-20 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl flex items-center justify-center mx-auto mb-4">
                                    <svg class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                    </svg>
                                </div>
                                <p class="font-semibold text-gray-900 mb-1">No tienes proyectos aún</p>
                                <p class="text-sm text-gray-500">Crea o únete a un proyecto para comenzar</p>
                            </div>
                        @else
                            <div class="space-y-4">
                                @foreach($misProyectos as $proyecto)
                                    <a href="{{ route('proyectos.show', $proyecto['id']) }}" class="group block bg-white border border-indigo-100 rounded-xl p-5 hover:border-indigo-300 hover:shadow-lg hover:scale-[1.01] transition-all duration-200">
                                        <div class="flex items-start gap-4">
                                            <!-- Avatar con gradiente -->
                                            <div class="w-14 h-14 bg-gradient-to-br from-indigo-400 to-purple-500 rounded-xl flex items-center justify-center text-white font-bold text-lg shadow-md shadow-indigo-500/15 flex-shrink-0 group-hover:scale-105 transition-transform">
                                                {{ $proyecto['iniciales'] }}
                                            </div>

                                            <div class="flex-1 min-w-0">
                                                <div class="flex items-start justify-between gap-4 mb-3">
                                                    <div class="flex-1 min-w-0">
                                                        <h3 class="font-bold text-gray-900 group-hover:text-indigo-600 transition truncate">
                                                            {{ $proyecto['nombre'] }}
                                                        </h3>
                                                        <p class="text-sm text-gray-500 mt-0.5">
                                                            {{ $proyecto['codigo'] }} • {{ ucfirst($proyecto['metodologia'] ?? 'No especificada') }}
                                                        </p>
                                                    </div>
                                                    <div class="flex gap-2">
                                                        @if($proyecto['es_creador'])
                                                            <span class="px-3 py-1 bg-indigo-50 text-indigo-700 text-xs font-medium rounded-full whitespace-nowrap">
                                                                Creador
                                                            </span>
                                                        @else
                                                            <span class="px-3 py-1 bg-purple-50 text-purple-700 text-xs font-medium rounded-full whitespace-nowrap">
                                                                {{ $proyecto['mi_rol'] }}
                                                            </span>
                                                        @endif
                                                    </div>
                                                </div>

                                                <!-- Stats -->
                                                <div class="flex items-center gap-4 text-sm text-gray-600 mb-3">
                                                    <div class="flex items-center gap-1.5">
                                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                                        </svg>
                                                        <span>{{ $proyecto['total_miembros'] }}</span>
                                                    </div>
                                                    <div class="flex items-center gap-1.5">
                                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                                                        </svg>
                                                        <span>{{ $proyecto['total_equipos'] }}</span>
                                                    </div>
                                                    @if($proyecto['nombre_equipo'])
                                                        <div class="flex items-center gap-1.5">
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                                            </svg>
                                                            <span>{{ $proyecto['nombre_equipo'] }}</span>
                                                        </div>
                                                    @endif
                                                </div>

                                                <!-- Progress bar mejorada -->
                                                <div class="flex items-center gap-3">
                                                    <div class="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                                                        <div class="h-full bg-gradient-to-r from-indigo-500 to-purple-600 rounded-full transition-all duration-500" style="width: {{ $proyecto['progreso'] }}%"></div>
                                                    </div>
                                                    <span class="text-sm font-semibold text-gray-700 whitespace-nowrap">{{ $proyecto['progreso'] }}%</span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                @endforeach
                            </div>
                        @endif
                    </div>
                </div>

            </div>            <!-- Acciones Rápidas eliminadas por petición del usuario -->

        </div>
    </div>
</x-app-layout>
