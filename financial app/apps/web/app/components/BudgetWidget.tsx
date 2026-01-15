'use client';

import { useEffect, useState } from 'react';
import { Plus } from 'lucide-react';
import { BudgetEditor } from './BudgetEditor';

interface BudgetProgress {
    category: string;
    limit: number;
    spend: number;
    percentage: number;
}

export function BudgetWidget() {
    const [budgets, setBudgets] = useState<BudgetProgress[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const date = new Date();
        const month = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;

        fetch(`http://localhost:8000/api/v1/budgets/progress?month=${month}`)
            .then(res => res.json())
            .then(data => {
                setBudgets(data);
                setLoading(false);
            })
            .catch(err => {
                console.error("Failed to fetch budgets", err);
                setLoading(false);
            });
    }, []);

    const [showEditor, setShowEditor] = useState(false);

    const refresh = () => {
        setLoading(true);
        const date = new Date();
        const month = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;

        fetch(`http://localhost:8000/api/v1/budgets/progress?month=${month}`)
            .then(res => res.json())
            .then(data => {
                setBudgets(data);
                setLoading(false);
            })
            .catch(err => {
                console.error("Failed to fetch budgets", err);
                setLoading(false);
            });
    };

    if (loading) return <div className="h-full flex items-center justify-center text-gray-400 text-sm">Loading budgets...</div>;

    return (
        <>
            <div className="space-y-4">
                {budgets.length === 0 ? (
                    <div className="h-full flex flex-col items-center justify-center text-gray-400 text-sm gap-2 py-8">
                        <span className="text-gray-300 bg-gray-50 p-3 rounded-full"><Plus className="w-5 h-5" /></span>
                        <p>No budgets set for this month</p>
                        <button onClick={() => setShowEditor(true)} className="text-blue-600 font-medium text-xs hover:underline">Set a Budget</button>
                    </div>
                ) : (
                    <>
                        <div className="flex justify-between items-center mb-2">
                            <span className="text-xs text-gray-400 font-medium">{budgets.length} Active Budgets</span>
                            <button onClick={() => setShowEditor(true)} className="text-xs text-blue-600 hover:text-blue-700 font-medium flex items-center gap-1">
                                <Plus className="w-3 h-3" /> Add
                            </button>
                        </div>
                        {budgets.map((b) => (
                            <div key={b.category} className="space-y-1">
                                <div className="flex justify-between text-xs font-medium">
                                    <span className="text-gray-700">{b.category}</span>
                                    <span className={b.spend > b.limit ? 'text-red-600' : 'text-gray-500'}>
                                        {Math.round(b.percentage)}%
                                    </span>
                                </div>

                                <div className="h-2 w-full bg-gray-100 rounded-full overflow-hidden">
                                    <div
                                        className={`h-full rounded-full ${b.percentage >= 100 ? 'bg-red-500' :
                                            b.percentage >= 80 ? 'bg-yellow-500' : 'bg-green-500'
                                            }`}
                                        style={{ width: `${Math.min(b.percentage, 100)}%` }}
                                    />
                                </div>

                                <div className="flex justify-between text-[10px] text-gray-400">
                                    <span>₹{b.spend.toLocaleString('en-IN')} spent</span>
                                    <span>₹{b.limit.toLocaleString('en-IN')} limit</span>
                                </div>
                            </div>
                        ))}
                    </>
                )}
            </div>

            <BudgetEditor
                isOpen={showEditor}
                onClose={() => setShowEditor(false)}
                onSuccess={refresh}
            />
        </>
    );
}
