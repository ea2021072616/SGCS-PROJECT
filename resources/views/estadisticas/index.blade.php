<x-app-layout>
    <div class="py-8 bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">

            <!-- Header -->
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                <div class="h-2 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>
                <div class="p-8">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-900 mb-2">
                                📊 Estadísticas y Análisis
                            </h1>
                            <p class="text-gray-600">Métricas y progreso de todos tus proyectos</p>
                        </div>
                        <div class="text-right">
                            <p class="text-sm text-gray-500">Última actualización</p>
                            <p class="text-lg font-semibold text-gray-900">{{ now()->format('d/m/Y H:i') }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Indicadores Principales -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Total Proyectos -->
                <div class="bg-white rounded-xl shadow-sm border border-indigo-100 p-6 hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-gradient-to-br from-indigo-400 to-indigo-500 rounded-xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                            </svg>
                        </div>
                    </div>
                    <h3 class="text-indigo-600 text-sm font-semibold mb-1">Total Proyectos</h3>
                    <p class="text-4xl font-bold text-indigo-700">{{ $totalProyectos }}</p>
                    <div class="mt-3 flex gap-2">
                        <span class="text-xs px-2 py-1 bg-green-50 text-green-600 rounded">{{ $proyectosActivos }} activos</span>
                        <span class="text-xs px-2 py-1 bg-blue-50 text-blue-600 rounded">{{ $proyectosCompletados }} completos</span>
                    </div>
                </div>

                <!-- Total Tareas -->
                <div class="bg-white rounded-xl shadow-sm border border-purple-100 p-6 hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-purple-500 rounded-xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                            </svg>
                        </div>
                    </div>
                    <h3 class="text-purple-600 text-sm font-semibold mb-1">Total Tareas</h3>
                    <p class="text-4xl font-bold text-purple-700">{{ $totalTareas }}</p>
                    <div class="mt-3">
                        <span class="text-xs px-2 py-1 bg-green-50 text-green-600 rounded">{{ $tareasCompletadas }} completadas</span>
                    </div>
                </div>

                <!-- Total Liberaciones -->
                <div class="bg-white rounded-xl shadow-sm border border-teal-100 p-6 hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-gradient-to-br from-teal-400 to-teal-500 rounded-xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
                            </svg>
                        </div>
                    </div>
                    <h3 class="text-teal-600 text-sm font-semibold mb-1">Liberaciones</h3>
                    <p class="text-4xl font-bold text-teal-700">{{ $totalLiberaciones }}</p>
                </div>

                <!-- Ítems de Cambio -->
                <div class="bg-white rounded-xl shadow-sm border border-pink-100 p-6 hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-gradient-to-br from-pink-400 to-pink-500 rounded-xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/>
                            </svg>
                        </div>
                    </div>
                    <h3 class="text-pink-600 text-sm font-semibold mb-1">Ítems de Cambio</h3>
                    <p class="text-4xl font-bold text-pink-700">{{ $totalCambios }}</p>
                    <div class="mt-3">
                        <span class="text-xs px-2 py-1 bg-green-50 text-green-600 rounded">{{ $cambiosAprobados }} aprobados</span>
                    </div>
                </div>
            </div>

            <!-- Gráficas -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

                <!-- Progreso de Proyectos -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="bg-gradient-to-r from-indigo-400 to-purple-500 p-6">
                        <h2 class="text-xl font-bold text-white">📈 Progreso de Proyectos</h2>
                        <p class="text-sm text-indigo-50">Porcentaje de completitud de tareas</p>
                    </div>
                    <div class="p-6">
                        <canvas id="progresoProyectosChart" height="300"></canvas>
                    </div>
                </div>

                <!-- Distribución de Tareas -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="bg-gradient-to-r from-purple-400 to-pink-500 p-6">
                        <h2 class="text-xl font-bold text-white">🎯 Distribución de Tareas</h2>
                        <p class="text-sm text-purple-50">Por estado actual</p>
                    </div>
                    <div class="p-6">
                        <canvas id="distribucionTareasChart" height="300"></canvas>
                    </div>
                </div>

                <!-- Liberaciones por Mes -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="bg-gradient-to-r from-teal-400 to-cyan-500 p-6">
                        <h2 class="text-xl font-bold text-white">🚀 Liberaciones por Mes</h2>
                        <p class="text-sm text-teal-50">Últimos 6 meses</p>
                    </div>
                    <div class="p-6">
                        <canvas id="liberacionesMesChart" height="300"></canvas>
                    </div>
                </div>

                <!-- Proyectos por Metodología -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <div class="bg-gradient-to-r from-pink-400 to-rose-500 p-6">
                        <h2 class="text-xl font-bold text-white">📋 Proyectos por Metodología</h2>
                        <p class="text-sm text-pink-50">Distribución</p>
                    </div>
                    <div class="p-6">
                        <canvas id="metodologiasChart" height="300"></canvas>
                    </div>
                </div>

            </div>

        </div>
    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <script>
        // ============================================
        // 📈 GRÁFICA: Progreso de Proyectos (Barras Horizontales)
        // ============================================
        const proyectosData = @json($proyectosConProgreso);

        new Chart(document.getElementById('progresoProyectosChart'), {
            type: 'bar',
            data: {
                labels: proyectosData.map(p => p.codigo),
                datasets: [{
                    label: 'Progreso (%)',
                    data: proyectosData.map(p => p.progreso),
                    backgroundColor: 'rgba(99, 102, 241, 0.8)',
                    borderColor: 'rgba(99, 102, 241, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const proyecto = proyectosData[context.dataIndex];
                                return `${context.parsed.x}% - ${proyecto.tareas_completadas}/${proyecto.total_tareas} tareas`;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                }
            }
        });

        // ============================================
        // 🎯 GRÁFICA: Distribución de Tareas (Pastel)
        // ============================================
        const distribucionData = @json($distribucionTareas);

        new Chart(document.getElementById('distribucionTareasChart'), {
            type: 'doughnut',
            data: {
                labels: distribucionData.map(d => d.estado),
                datasets: [{
                    data: distribucionData.map(d => d.cantidad),
                    backgroundColor: [
                        'rgba(34, 197, 94, 0.8)',  // Verde - Completadas
                        'rgba(251, 191, 36, 0.8)', // Amarillo - En Progreso
                        'rgba(239, 68, 68, 0.8)'   // Rojo - Pendientes
                    ],
                    borderColor: [
                        'rgba(34, 197, 94, 1)',
                        'rgba(251, 191, 36, 1)',
                        'rgba(239, 68, 68, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // ============================================
        // 🚀 GRÁFICA: Liberaciones por Mes (Línea)
        // ============================================
        const liberacionesData = @json($liberacionesPorMes);

        new Chart(document.getElementById('liberacionesMesChart'), {
            type: 'line',
            data: {
                labels: liberacionesData.map(l => l.mes),
                datasets: [{
                    label: 'Liberaciones',
                    data: liberacionesData.map(l => l.cantidad),
                    backgroundColor: 'rgba(20, 184, 166, 0.2)',
                    borderColor: 'rgba(20, 184, 166, 1)',
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });

        // ============================================
        // 📋 GRÁFICA: Proyectos por Metodología (Pastel)
        // ============================================
        const metodologiasData = @json($proyectosPorMetodologia);

        new Chart(document.getElementById('metodologiasChart'), {
            type: 'pie',
            data: {
                labels: metodologiasData.map(m => m.nombre),
                datasets: [{
                    data: metodologiasData.map(m => m.cantidad),
                    backgroundColor: [
                        'rgba(236, 72, 153, 0.8)',
                        'rgba(168, 85, 247, 0.8)',
                        'rgba(59, 130, 246, 0.8)',
                        'rgba(34, 197, 94, 0.8)',
                        'rgba(251, 146, 60, 0.8)'
                    ],
                    borderColor: [
                        'rgba(236, 72, 153, 1)',
                        'rgba(168, 85, 247, 1)',
                        'rgba(59, 130, 246, 1)',
                        'rgba(34, 197, 94, 1)',
                        'rgba(251, 146, 60, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
</x-app-layout>
