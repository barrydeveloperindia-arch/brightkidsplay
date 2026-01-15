import React from 'react';

const MachineCard = ({ name, id, status, temp }) => (
    <div className="bg-white rounded-lg shadow-englabs-card p-6 border border-gray-100 flex flex-col justify-between h-64">
        <div>
            <div className="flex justify-between items-start mb-4">
                <div>
                    <h3 className="text-lg font-bold text-gray-900">{name}</h3>
                    <p className="text-xs text-gray-500 font-mono">{id}</p>
                </div>
                <div className={`w-3 h-3 rounded-full ${status === 'RUNNING' ? 'bg-englabs-green animate-pulse' : 'bg-englabs-red'}`} />
            </div>

            <div className="space-y-2">
                <div className="flex justify-between text-sm">
                    <span className="text-gray-500">Status</span>
                    <span className="font-medium">{status}</span>
                </div>
                <div className="flex justify-between text-sm">
                    <span className="text-gray-500">Temperature</span>
                    <span className="font-medium">{temp}°C</span>
                </div>
                <div className="flex justify-between text-sm">
                    <span className="text-gray-500">Spindle Load</span>
                    <span className="font-medium">62%</span>
                </div>
            </div>
        </div>

        {/* Visualization Placeholder */}
        <div className="bg-gray-50 h-20 rounded border border-dashed border-gray-300 flex items-center justify-center text-xs text-gray-400">
            [ 3D Digital Twin View ]
        </div>
    </div>
);

export default function ShopFloor() {
    return (
        <div>
            <header className="mb-8">
                <h1 className="text-3xl font-light text-gray-900">Shop Floor Live</h1>
                <p className="text-gray-500 mt-1">Real-time Telemetry & Twin Visualization</p>
            </header>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <MachineCard name="5-Axis Mill A" id="CNC-HighPerf-05" status="RUNNING" temp="42.5" />
                <MachineCard name="Standard Mill B" id="CNC-001" status="IDLE" temp="22.0" />
                <MachineCard name="Stratasys F120" id="3D-Printer-02" status="RUNNING" temp="210.0" />
            </div>
        </div>
    );
}
