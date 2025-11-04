<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            Grafo de Trazabilidad de Elementos de Configuración
        </h2>
        <p class="text-sm text-gray-600 mt-1">
            Proyecto: <span class="font-mono font-bold">{{ $proyecto->nombre }}</span>
        </p>
    </x-slot>

    <div class="py-8 flex flex-col items-center justify-center min-h-[80vh] bg-gray-50">
        <div class="mb-4 flex gap-2">
            <button id="btnJerarquico" class="btn btn-sm bg-blue-600 text-white hover:bg-blue-700">Jerárquico</button>
            <button id="btnCircular" class="btn btn-sm bg-green-600 text-white hover:bg-green-700">Circular</button>
        </div>
        <div class="relative w-full flex justify-center">
            <div id="ec-graph" style="height: 700px; width: 1100px; border:1px solid #ccc; background: #fff;"></div>
            <div id="cy-graph" style="height: 700px; width: 1100px; border:1px solid #ccc; background: #fff; display:none; position:absolute; left:0; top:0;"></div>
        </div>
    </div>
    <link href="https://unpkg.com/vis-network/styles/vis-network.min.css" rel="stylesheet" type="text/css" />
    <link href="https://unpkg.com/cytoscape/dist/cytoscape.min.css" rel="stylesheet" type="text/css" />
    <script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
    <script src="https://unpkg.com/cytoscape/dist/cytoscape.min.js"></script>
    <script>
        let network = null;
        let nodes = null;
        let edges = null;
        let rawNodes = null;
        let cy = null;
        function drawGraph(layoutType) {
            if (!nodes || !edges) return;
            if (layoutType === 'jerarquico') {
                document.getElementById('ec-graph').style.display = '';
                document.getElementById('cy-graph').style.display = 'none';
                let options = {
                    edges: { arrows: 'to', font: { align: 'middle' } },
                    nodes: { shape: 'box', font: { size: 16 } },
                    layout: {
                        hierarchical: {
                            enabled: true,
                            direction: 'UD',
                            sortMethod: 'directed',
                            nodeSpacing: 200,
                            levelSeparation: 150,
                            treeSpacing: 300,
                            parentCentralization: true
                        }
                    },
                    physics: false
                };
                let data = { nodes, edges };
                if (network) network.destroy();
                network = new vis.Network(document.getElementById('ec-graph'), data, options);
                setTimeout(() => {
                    network.moveTo({ position: { x: 0, y: 0 }, scale: 1, animation: true });
                }, 300);
            } else if (layoutType === 'circular') {
                document.getElementById('ec-graph').style.display = 'none';
                document.getElementById('cy-graph').style.display = '';
                // Convertir datos a formato Cytoscape
                let nodeArr = rawNodes ? [...rawNodes] : nodes.get();
                let edgeArr = edges.get();
                let cyElements = [];
                // Detectar nodo raíz (sin edges entrantes)
                let edgeTargets = new Set(edgeArr.map(e => e.to.toString()));
                let root = nodeArr.find(n => !edgeTargets.has(n.id.toString())) || nodeArr[0];
                nodeArr.forEach(n => {
                    // Si es el nodo raíz, label = nombre del proyecto
                    if (n.id === root.id) {
                        cyElements.push({ data: { id: n.id.toString(), label: "{{ $proyecto->nombre }}" }, classes: 'central' });
                    } else {
                        cyElements.push({ data: { id: n.id.toString(), label: n.label } });
                    }
                });
                edgeArr.forEach(e => {
                    cyElements.push({ data: { id: e.from + '_' + e.to, source: e.from.toString(), target: e.to.toString(), label: e.label || '' } });
                });
                if (cy) cy.destroy();
                cy = cytoscape({
                    container: document.getElementById('cy-graph'),
                    elements: cyElements,
                    style: [
                        {
                            selector: 'node.central',
                            style: {
                                'background-color': '#222',
                                'label': 'data(label)',
                                'color': '#fff',
                                'font-size': '22px',
                                'font-weight': 'bold',
                                'width': '90px',
                                'height': '90px',
                                'text-valign': 'center',
                                'text-halign': 'center',
                                'text-wrap': 'wrap',
                                'text-max-width': 120,
                                'border-width': 4,
                                'border-color': '#007bff'
                            }
                        },
                        {
                            selector: 'node',
                            style: {
                                'background-color': '#007bff',
                                'label': 'data(label)',
                                'color': '#fff',
                                'text-valign': 'center',
                                'text-halign': 'center',
                                'font-size': '16px',
                                'width': '60px',
                                'height': '60px',
                                'text-wrap': 'wrap',
                                'text-max-width': 80
                            }
                        },
                        {
                            selector: 'node:selected',
                            style: {
                                'background-color': '#222',
                                'font-size': '18px',
                                'font-weight': 'bold'
                            }
                        },
                        {
                            selector: 'edge',
                            style: {
                                'width': 2,
                                'line-color': '#bbb',
                                'target-arrow-color': '#bbb',
                                'target-arrow-shape': 'triangle',
                                'curve-style': 'bezier',
                                'label': 'data(label)',
                                'font-size': '12px',
                                'text-background-color': '#fff',
                                'text-background-opacity': 1,
                                'text-background-padding': 2
                            }
                        }
                    ],
                    layout: {
                        name: 'concentric',
                        concentric: function(node) {
                            // Nodo raíz al centro
                            if (node.hasClass('central')) return 2;
                            return 1;
                        },
                        levelWidth: function(nodes) { return 1; },
                        minNodeSpacing: 120,
                        startAngle: 3 * Math.PI / 2,
                        clockwise: true,
                        equidistant: true,
                        animate: true
                    }
                });
            }
        }
        document.addEventListener('DOMContentLoaded', function() {
            fetch("{{ route('proyectos.elementos.grafo', ['proyecto' => $proyecto->id]) }}")
                .then(response => response.json())
                .then(data => {
                    rawNodes = data.nodes;
                    nodes = new vis.DataSet(data.nodes);
                    edges = new vis.DataSet(data.edges);
                    drawGraph('jerarquico');
                });
            document.getElementById('btnJerarquico').onclick = function() { drawGraph('jerarquico'); };
            document.getElementById('btnCircular').onclick = function() { drawGraph('circular'); };
        });
    </script>
</x-app-layout>
