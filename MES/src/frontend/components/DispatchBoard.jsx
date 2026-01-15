import React, { useState, useEffect } from 'react';

// Mock Data for Prototype
const MOCK_QUEUE = [
    { id: 'JOB-101', part: 'Tesla Bracket v9', machine: 'CNC-HighPerf-05', status: 'QUEUED', eta: '2h 30m' },
    { id: 'JOB-102', part: 'Prototype Gear', machine: '3D-Printer-02', status: 'PRINTING', eta: '45m' },
];

export default function DispatchBoard() {
    const [queue, setQueue] = useState(MOCK_QUEUE);

    const handleManualOverride = () => {
        alert("Manual Override: Drag and Drop functionality would activate here.");
    };

    return (
        <div>
            <header className="mb-8 flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-light text-gray-900">Dispatch Request</h1>
                    <p className="text-gray-500 mt-1">Intelligent Order Allocation</p>
                </div>
                <button
                    onClick={handleManualOverride}
                    className="bg-englabs-blue text-white px-6 py-2 rounded-md hover:bg-blue-700 transition"
                >
                    + New Order
                </button>
            </header>

            {/* Grid Layout for Board */}
            <div className="grid grid-cols-3 gap-6">

                {/* Column 1: Incoming / AI Planning */}
                <div className="bg-gray-50 p-6 rounded-lg border border-gray-100 min-h-[500px]">
                    <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-4">Pending Planning</h2>
                    <div className="bg-white p-4 shadow-englabs-card rounded-md mb-3 border-l-4 border-gray-300">
                        <h3 className="font-bold">ORD-2091</h3>
                        <p className="text-sm text-gray-600">Aero Strut x4</p>
                        <div className="mt-2 text-xs text-englabs-blue bg-blue-50 inline-block px-2 py-1 rounded">
                            AI Analyzing Geometry...
                        </div>
                    </div>
                </div>

                {/* Column 2: Scheduled / Queued */}
                <div className="bg-gray-50 p-6 rounded-lg border border-gray-100">
                    <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-4">Production Queue</h2>
                    {queue.map(job => (
                        <div key={job.id} className="bg-white p-4 shadow-englabs-card rounded-md mb-3 border-l-4 border-englabs-blue">
                            <div className="flex justify-between">
                                <h3 className="font-bold">{job.id}</h3>
                                <span className="text-xs text-gray-400">{job.machine}</span>
                            </div>
                            <p className="text-sm text-gray-600 mt-1">{job.part}</p>
                            <div className="mt-3 flex justify-between items-center text-xs">
                                <span className="text-gray-500">ETA: {job.eta}</span>
                                <span className={`px-2 py-1 rounded ${job.status === 'PRINTING' ? 'bg-green-50 text-green-700' : 'bg-gray-100'}`}>
                                    {job.status}
                                </span>
                            </div>
                        </div>
                    ))}
                </div>

                {/* Column 3: Completed */}
                <div className="bg-gray-50 p-6 rounded-lg border border-gray-100">
                    <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-4">Ready for QC</h2>
                </div>
            </div>
        </div>
    );
}
