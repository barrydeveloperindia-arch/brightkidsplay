'use client';

import { useEffect, useState } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend, LineChart, Line } from 'recharts';
import { Wallet, Filter } from 'lucide-react';

interface TrendPoint {
    period: string;
    spend: number;
}

interface CardAnalytics {
    account_name: string;
    total_spend: number;
    trend: TrendPoint[];
}

export default function AnalysisPage() {
    const [data, setData] = useState<CardAnalytics[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedYear, setSelectedYear] = useState<number>(new Date().getFullYear());

    useEffect(() => {
        setLoading(true);
        fetch(`http://localhost:8000/api/v1/analytics/card-trends?period_type=month&year=${selectedYear}`)
            .then(res => res.json())
            .then(data => {
                setData(data);
                setLoading(false);
            })
            .catch(err => {
                console.error(err);
                setLoading(false);
            });
    }, [selectedYear]);

    // Transform logic for Combined Chart:
    // Need array of objects: { period: '2023-01', 'HDFC': 500, 'SBI': 200 }

    // 1. Collect all unique periods
    const allPeriods = Array.from(new Set(data.flatMap(d => d.trend.map(t => t.period)))).sort();

    // 2. Build chart data
    const chartData = allPeriods.map(period => {
        const point: any = { period };
        data.forEach(card => {
            const match = card.trend.find(t => t.period === period);
            point[card.account_name] = match ? match.spend : 0;
        });
        return point;
    });

    const colors = ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6'];

    return (
        <div className="flex h-screen bg-gray-50/50">
            {/* Sidebar (Simplified copy for now, normally a component) */}
            <aside className="w-64 bg-white border-r border-gray-100 hidden md:block">
                <div className="p-6">
                    <h1 className="text-xl font-bold tracking-tight text-black flex items-center gap-2">
                        <Wallet className="w-6 h-6" />
                        FinApp
                    </h1>
                </div>
                <nav className="px-4 space-y-1">
                    <a href="/" className="flex items-center gap-3 w-full px-3 py-2 text-sm font-medium text-gray-500 hover:text-black hover:bg-gray-50 rounded-md">
                        Overview
                    </a>
                    <a href="/analysis" className="flex items-center gap-3 w-full px-3 py-2 text-sm font-medium bg-gray-100 text-black rounded-md">
                        Analysis
                    </a>
                </nav>
            </aside>

            <main className="flex-1 overflow-y-auto p-8">
                <header className="flex justify-between items-center mb-8">
                    <h2 className="text-2xl font-bold text-gray-900">Deep Analytics</h2>
                    <div className="flex gap-2">
                        <select
                            value={selectedYear}
                            onChange={(e) => setSelectedYear(Number(e.target.value))}
                            className="px-4 py-2 bg-white border border-gray-200 rounded-lg text-sm font-medium shadow-sm hover:bg-gray-50 outline-none focus:ring-2 focus:ring-black"
                        >
                            <option value={2026}>2026</option>
                            <option value={2025}>2025</option>
                            <option value={2024}>2024</option>
                            <option value={2023}>2023</option>
                        </select>
                    </div>
                </header>

                <div className="space-y-8">
                    {/* Comparative Chart */}
                    <section className="bg-white p-6 rounded-xl border border-gray-100 shadow-sm h-96">
                        <h3 className="text-lg font-semibold text-gray-700 mb-6">Card Performance Comparison</h3>
                        <ResponsiveContainer width="100%" height="100%">
                            <LineChart data={chartData}>
                                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E5E7EB" />
                                <XAxis dataKey="period" axisLine={false} tickLine={false} tick={{ fontSize: 12 }} />
                                <YAxis axisLine={false} tickLine={false} tickFormatter={(v) => `₹${v / 1000}k`} />
                                <Tooltip />
                                <Legend />
                                {data.map((card, idx) => (
                                    <Line
                                        key={card.account_name}
                                        type="monotone"
                                        dataKey={card.account_name}
                                        stroke={colors[idx % colors.length]}
                                        strokeWidth={3}
                                        dot={false}
                                    />
                                ))}
                            </LineChart>
                        </ResponsiveContainer>
                    </section>

                    {/* Card Stats Grid */}
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {data.map((card, idx) => (
                            <div key={card.account_name} className="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
                                <div className="flex justify-between items-start mb-4">
                                    <div>
                                        <p className="text-sm text-gray-500">Card Name</p>
                                        <h4 className="text-lg font-bold text-gray-900">{card.account_name}</h4>
                                    </div>
                                    <div className="w-3 h-3 rounded-full" style={{ backgroundColor: colors[idx % colors.length] }}></div>
                                </div>
                                <div className="space-y-2">
                                    <p className="text-3xl font-bold text-black">₹{card.total_spend.toLocaleString('en-IN')}</p>
                                    <p className="text-xs text-gray-400">Total Spend (Selected Period)</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </main>
        </div>
    );
}
