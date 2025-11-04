<x-app-layout>
    <x-slot name="scripts">
        <script src="/js/scrum-board.js"></script>
    </x-slot>
    <x-slot name="header">
        <div class="flex justify-between items-center">
            <div>
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                    🌀 Scrum Dashboard
                </h2>
                <p class="text-sm text-gray-600 mt-1">
                    {{ $proyecto->nombre }} • {{ $sprintActual }}
                </p>
            </div>
            <button onclick="modalNuevaTarea.showModal()" class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                + Nueva User Story
            </button>
        </div>
    </x-slot>

    <div class="py-6">
        <div class="max-w-full mx-auto px-4 sm:px-6 lg:px-8">

            <!-- Navegación Scrum -->
            <x-scrum.navigation :proyecto="$proyecto" active="dashboard" />

            <!-- Métricas del Sprint Actual -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-lg p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-blue-100 text-sm">Sprint Actual</p>
                            <p class="text-2xl font-bold">{{ $sprintActual }}</p>
                        </div>
                        <div class="text-3xl">🚀</div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm border p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm">Story Points</p>
                            <p class="text-2xl font-bold text-gray-900">{{ $storyPointsCompletados }}/{{ $totalStoryPoints }}</p>
                        </div>
                        <div class="text-3xl">📈</div>
                    </div>
                    <div class="mt-2">
                        <div class="w-full bg-gray-200 rounded-full h-2">
                            <div class="bg-green-500 h-2 rounded-full"
                                 style="width: {{ $totalStoryPoints > 0 ? ($storyPointsCompletados / $totalStoryPoints) * 100 : 0 }}%"></div>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm border p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm">Velocidad Estimada</p>
                            <p class="text-2xl font-bold text-gray-900">{{ $totalStoryPoints }}</p>
                        </div>
                        <div class="text-3xl">⚡</div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow-sm border p-4">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-600 text-sm">Sprints</p>
                            <p class="text-2xl font-bold text-gray-900">{{ $sprints->count() }}</p>
                        </div>
                        <div class="text-3xl">🔄</div>
                    </div>
                </div>
            </div>

            <!-- Selector de Sprint -->
            <div class="bg-white rounded-lg shadow-sm border mb-6 p-4">
                <div class="flex items-center gap-4">
                    <label class="text-sm font-medium text-gray-700">Sprint:</label>
                    <select id="sprintSelector" class="select select-bordered select-sm bg-white">
                        @foreach($sprints as $sprint)
                            <option value="{{ $sprint }}" {{ $sprint === $sprintActual ? 'selected' : '' }}>
                                {{ $sprint }}
                            </option>
                        @endforeach
                    </select>
                    <div class="flex-1"></div>
                    <button onclick="modalNuevoSprint.showModal()" class="btn btn-sm btn-outline">
                        + Nuevo Sprint
                    </button>
                </div>
            </div>

            <!-- Tablero Scrum Kanban -->
            <div class="bg-white rounded-lg shadow-sm border">
                <div class="p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Sprint Board - {{ $sprintActual }}</h3>

                    <div class="flex gap-4 overflow-x-auto pb-4" style="min-height: 60vh;">
                        @foreach($fases as $fase)
                        <div class="scrum-column flex-shrink-0" style="width: 320px;" data-fase-id="{{ $fase->id_fase }}">
                            <!-- Header de la columna -->
                            <div class="bg-gradient-to-r from-gray-50 to-gray-100 border border-gray-200 rounded-t-lg p-4">
                                <div class="flex items-center justify-between">
                                    <h4 class="font-bold text-gray-800">{{ $fase->nombre_fase }}</h4>
                                    @php
                                        $tareasSprintFase = $tareasPorSprint->get($sprintActual, collect())->where('id_fase', $fase->id_fase);
                                        $storyPointsFase = $tareasSprintFase->sum('story_points');
                                    @endphp
                                    <div class="flex gap-2">
                                        <span class="badge badge-sm bg-gray-200 text-gray-700">
                                            {{ $tareasSprintFase->count() }}
                                        </span>
                                        @if($storyPointsFase > 0)
                                            <span class="badge badge-sm bg-blue-100 text-blue-700">
                                                {{ $storyPointsFase }} pts
                                            </span>
                                        @endif
                                    </div>
                                </div>
                                <p class="text-xs text-gray-600 mt-1">{{ $fase->descripcion }}</p>
                            </div>

                            <!-- Lista de User Stories -->
                            <div class="scrum-tasks bg-gray-50 border-l border-r border-b border-gray-200 rounded-b-lg p-3 space-y-3" style="min-height: 400px;">
                                @forelse($tareasSprintFase as $tarea)
                                    <div class="scrum-card bg-white rounded-lg shadow-sm p-4 hover:shadow-md transition-shadow border-l-4 border-blue-400"
                                         draggable="true"
                                         data-tarea-id="{{ $tarea->id_tarea }}">

                                        <!-- Header de la tarjeta -->
                                        <div class="flex items-start justify-between mb-2">
                                            <div class="flex-1">
                                                <h5 class="font-semibold text-gray-900 text-sm leading-tight">
                                                    {{ $tarea->nombre }}
                                                </h5>
                                            </div>
                                            <div class="flex items-center gap-1 ml-2">
                                                @if($tarea->story_points)
                                                    <span class="inline-flex items-center justify-center w-6 h-6 bg-blue-100 text-blue-800 text-xs font-bold rounded-full">
                                                        {{ $tarea->story_points }}
                                                    </span>
                                                @endif
                                            </div>
                                        </div>

                                        <!-- Descripción -->
                                        @if($tarea->descripcion)
                                            <p class="text-xs text-gray-600 mb-3 line-clamp-2">{{ $tarea->descripcion }}</p>
                                        @endif

                                        <!-- Información del elemento de configuración -->
                                        @if($tarea->elementoConfiguracion)
                                            <div class="flex items-center gap-2 mb-3">
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                    📦 {{ $tarea->elementoConfiguracion->codigo_ec }}
                                                </span>
                                            </div>
                                        @endif

                                        <!-- Footer de la tarjeta -->
                                        <div class="flex items-center justify-between pt-2 border-t border-gray-100">
                                            <div class="flex items-center gap-2">
                                                @if($tarea->responsableUsuario)
                                                    <div class="flex items-center gap-1">
                                                        <div class="w-5 h-5 bg-gray-300 rounded-full flex items-center justify-center">
                                                            <span class="text-xs font-medium text-gray-700">
                                                                {{ substr($tarea->responsableUsuario->nombre, 0, 1) }}
                                                            </span>
                                                        </div>
                                                    </div>
                                                @endif

                                                @if($tarea->prioridad)
                                                    @php
                                                        $prioridadColor = $tarea->prioridad >= 8 ? 'bg-red-100 text-red-800' :
                                                                         ($tarea->prioridad >= 5 ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800');
                                                    @endphp
                                                    <span class="badge badge-xs {{ $prioridadColor }}">
                                                        P{{ $tarea->prioridad }}
                                                    </span>
                                                @endif
                                            </div>

                                            <button onclick="editarTarea({{ $tarea->id_tarea }})" class="text-gray-400 hover:text-gray-600">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>
                                @empty
                                    <div class="text-center py-8 text-gray-500">
                                        <p class="text-sm">No hay user stories en esta columna</p>
                                    </div>
                                @endforelse
                            </div>
                        </div>
                        @endforeach
                    </div>
                </div>
            </div>

            <!-- Burndown Chart -->
            <div class="bg-white rounded-lg shadow-sm border mt-6">
                <div class="p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">📈 Burndown Chart - {{ $sprintActual }}</h3>

                    <div class="h-64 bg-gray-50 rounded-lg flex items-center justify-center">
                        <div class="text-center text-gray-500">
                            <div class="text-4xl mb-2"></div>
                            <p>Gráfico Burndown Chart</p>
                            <p class="text-sm">Story Points restantes: {{ $totalStoryPoints - $storyPointsCompletados }}</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal Nueva User Story -->
    <dialog id="modalNuevaTarea" class="modal">
        <div class="modal-box w-11/12 max-w-2xl bg-white">
            <h3 class="font-bold text-lg text-black mb-4">Nueva User Story</h3>

            <form method="POST" action="{{ route('proyectos.tareas.store', $proyecto) }}">
                @csrf

                <!-- Nombre de la User Story -->
                <div class="form-control mb-4">
                    <label class="label"><span class="label-text text-black font-semibold">Como [usuario], quiero [funcionalidad] para [beneficio]</span></label>
                    <input type="text" name="nombre" class="input input-bordered w-full bg-white text-black"
                           placeholder="Ej: Como usuario, quiero poder registrarme para acceder al sistema" required>
                </div>

                <!-- Descripción/Criterios de Aceptación -->
                <div class="form-control mb-4">
                    <label class="label"><span class="label-text text-black font-semibold">Criterios de Aceptación</span></label>
                    <textarea name="descripcion" class="textarea textarea-bordered bg-white text-black" rows="4"
                              placeholder="Dado que... Cuando... Entonces..."></textarea>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <!-- Fase -->
                    <div class="form-control">
                        <label class="label"><span class="label-text text-black font-semibold">Estado</span></label>
                        <select name="id_fase" class="select select-bordered bg-white text-black" required>
                            @foreach($fases as $fase)
                                <option value="{{ $fase->id_fase }}">{{ $fase->nombre_fase }}</option>
                            @endforeach
                        </select>
                    </div>

                    <!-- Story Points -->
                    <div class="form-control">
                        <label class="label"><span class="label-text text-black font-semibold">Story Points</span></label>
                        <select name="story_points" class="select select-bordered bg-white text-black">
                            <option value="">Sin estimar</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="5">5</option>
                            <option value="8">8</option>
                            <option value="13">13</option>
                            <option value="21">21</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4 mt-4">
                    <!-- Sprint -->
                    <div class="form-control">
                        <label class="label"><span class="label-text text-black font-semibold">Sprint</span></label>
                        <select name="sprint" class="select select-bordered bg-white text-black">
                            <option value="">Product Backlog</option>
                            @foreach($sprints as $sprint)
                                <option value="{{ $sprint }}" {{ $sprint === $sprintActual ? 'selected' : '' }}>{{ $sprint }}</option>
                            @endforeach
                        </select>
                    </div>

                    <!-- Prioridad -->
                    <div class="form-control">
                        <label class="label"><span class="label-text text-black font-semibold">Prioridad</span></label>
                        <select name="prioridad" class="select select-bordered bg-white text-black">
                            <option value="1">1 - Muy Baja</option>
                            <option value="3">3 - Baja</option>
                            <option value="5" selected>5 - Media</option>
                            <option value="8">8 - Alta</option>
                            <option value="10">10 - Muy Alta</option>
                        </select>
                    </div>
                </div>

                <!-- Responsable -->
                <div class="form-control mt-4">
                    <label class="label"><span class="label-text text-black font-semibold">Responsable</span></label>
                    <select name="responsable" class="select select-bordered bg-white text-black">
                        <option value="">Sin asignar</option>
                        @foreach($miembrosEquipo as $miembro)
                            <option value="{{ $miembro->id }}">{{ $miembro->nombre }}</option>
                        @endforeach
                    </select>
                </div>

                <!-- Botones -->
                <div class="modal-action">
                    <button type="button" onclick="modalNuevaTarea.close()" class="btn btn-ghost">Cancelar</button>
                    <button type="submit" class="btn bg-blue-600 text-white hover:bg-blue-700">Crear User Story</button>
                </div>
            </form>
        </div>
        <form method="dialog" class="modal-backdrop">
            <button>Cerrar</button>
        </form>
    </dialog>

    <!-- Modal Nuevo Sprint -->
    <dialog id="modalNuevoSprint" class="modal">
        <div class="modal-box bg-white">
            <h3 class="font-bold text-lg text-black mb-4">Nuevo Sprint</h3>

            <div class="form-control mb-4">
                <label class="label"><span class="label-text text-black font-semibold">Nombre del Sprint</span></label>
                <input type="text" id="nombreNuevoSprint" class="input input-bordered w-full bg-white text-black"
                       placeholder="Sprint {{ $sprints->count() + 1 }}">
            </div>

            <div class="modal-action">
                <button type="button" onclick="modalNuevoSprint.close()" class="btn btn-ghost">Cancelar</button>
                <button type="button" onclick="crearNuevoSprint()" class="btn bg-blue-600 text-white hover:bg-blue-700">Crear Sprint</button>
            </div>
        </div>
        <form method="dialog" class="modal-backdrop">
            <button>Cerrar</button>
        </form>
    </dialog>

    <script>
        // Drag and Drop para el tablero Scrum
        document.addEventListener('DOMContentLoaded', function() {
            // Hacer cards arrastrarables
            document.querySelectorAll('.scrum-card').forEach(card => {
                card.addEventListener('dragstart', function(e) {
                    e.dataTransfer.setData('text/plain', this.dataset.tareaId);
                    this.style.opacity = '0.5';
                });
                card.addEventListener('dragend', function(e) {
                    this.style.opacity = '1';
                });
            });
            // Hacer columnas como drop zones
            document.querySelectorAll('.scrum-tasks').forEach(zone => {
                zone.addEventListener('dragover', function(e) {
                    e.preventDefault();
                    this.style.backgroundColor = '#e3f2fd';
                });
                zone.addEventListener('dragleave', function(e) {
                    this.style.backgroundColor = '#f8fafc';
                });
                zone.addEventListener('drop', function(e) {
                    e.preventDefault();
                    this.style.backgroundColor = '#f8fafc';
                    const tareaId = e.dataTransfer.getData('text/plain');
                    const nuevaFase = this.closest('.scrum-column').dataset.faseId;
                    actualizarFaseTarea(tareaId, nuevaFase, this);
                });
            });
        });

        function actualizarFaseTarea(tareaId, nuevaFase, dropZone) {
            fetch(`/proyectos/{{ $proyecto->id }}/tareas/${tareaId}/cambiar-fase`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify({ id_fase: nuevaFase })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Mover la tarjeta visualmente
                    const card = document.querySelector(`.scrum-card[data-tarea-id='${tareaId}']`);
                    if (card && dropZone) dropZone.appendChild(card);
                } else {
                    alert('Error al mover la tarea: ' + (data.message || ''));
                }
            })
            .catch(() => alert('Error al mover la tarea'));
        }

        // Modal de edición de tarea (básico)
        function editarTarea(tareaId) {
            window.location.href = `/proyectos/{{ $proyecto->id }}/tareas/${tareaId}/editar`;
        }

        function crearNuevoSprint() {
            const nombreSprint = document.getElementById('nombreNuevoSprint').value;
            if (nombreSprint.trim()) {
                // Implementar creación de nuevo sprint
                console.log(`Crear sprint: ${nombreSprint}`);
                modalNuevoSprint.close();
            }
        }

        // Cambio de sprint
        document.getElementById('sprintSelector')?.addEventListener('change', function() {
            const sprintSeleccionado = this.value;
            window.location.href = `{{ route('scrum.dashboard', $proyecto) }}?sprint=${sprintSeleccionado}`;
        });
    </script>

    <style>
        .scrum-column {
            background: #f8fafc;
            border-radius: 12px;
        }
        .scrum-card {
            cursor: move;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .scrum-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</x-app-layout>
