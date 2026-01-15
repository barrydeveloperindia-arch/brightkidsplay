'use client';

import { useEffect, useState } from 'react';
import { ArrowUpRight, ArrowDownLeft } from 'lucide-react';

interface Transaction {
    id: string;
    date: string;
    description: string;
    amount: number;
    category: string;
    type: 'CREDIT' | 'DEBIT';
    merchant_normalized?: string;
    tags?: string[];
    account_id?: string;
}

export function RecentTransactions() {
    const [transactions, setTransactions] = useState<Transaction[]>([]);
    const [loading, setLoading] = useState(true);

    const [groupByCard, setGroupByCard] = useState(false);
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editTags, setEditTags] = useState<string>('');

    useEffect(() => {
        fetchTransactions();
    }, []);

    const fetchTransactions = () => {
        setLoading(true);
        fetch('http://localhost:8000/api/v1/transactions/')
            .then(res => res.json())
            .then(data => {
                setTransactions(data);
                setLoading(false);
            })
            .catch(err => {
                console.error("Failed to fetch transactions", err);
                setLoading(false);
            });
    };

    const handleSaveTags = async (id: string) => {
        console.log("Saving tags for", id, editTags);
        try {
            const tagsArray = editTags.split(',').map(t => t.trim()).filter(Boolean);
            await fetch(`http://localhost:8000/api/v1/transactions/${id}`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ tags: tagsArray })
            });
            setEditingId(null);
            fetchTransactions(); // Refresh
        } catch (e) {
            console.error("Update failed", e);
        }
    };

    // Grouping Logic
    const displayedTransactions = transactions; // Default flat
    // TODO: Ideally we group structure if groupByCard is true, but requires UI change.
    // For now, let's just sort by account if enabled? Or Filter?
    // Let's implement simple "Show Tags" and "Edit" first.

    if (loading) return <div className="p-4 text-sm text-gray-500">Loading transactions...</div>;

    return (
        <div className="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
            <div className="p-6 border-b border-gray-100 flex justify-between items-center">
                <h3 className="font-semibold text-gray-900">Recent Transactions</h3>
                <div className="flex items-center gap-2">
                    <button
                        onClick={() => setGroupByCard(!groupByCard)}
                        className={`text-xs px-3 py-1.5 rounded-md border font-medium transition-colors ${groupByCard ? 'bg-black text-white border-black' : 'text-gray-600 border-gray-200 hover:border-gray-300'
                            }`}
                    >
                        {groupByCard ? 'Grouped by Card' : 'Group by Card'}
                    </button>
                    <button onClick={fetchTransactions} className="text-gray-400 hover:text-black">
                        <ArrowDownLeft className="w-4 h-4 rotate-45" /> {/* Refresh Icon mock */}
                    </button>
                </div>
            </div>
            <div className="overflow-x-auto">
                <table className="w-full text-sm text-left">
                    <thead className="bg-gray-50 text-gray-500 font-medium">
                        <tr>
                            <th className="px-6 py-3">Description</th>
                            <th className="px-6 py-3">Date</th>
                            <th className="px-6 py-3">Category / Tags</th>
                            <th className="px-6 py-3 text-right">Amount</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {transactions.map((txn) => (
                            <tr key={txn.id} className="hover:bg-gray-50/50 transition-colors group">
                                <td className="px-6 py-4 font-medium text-gray-900">
                                    <div className="flex items-center gap-3">
                                        <div className={`w-8 h-8 rounded-full flex items-center justify-center ${txn.type === 'DEBIT' ? 'bg-red-50 text-red-600' : 'bg-green-50 text-green-600'
                                            }`}>
                                            {txn.type === 'DEBIT' ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownLeft className="w-4 h-4" />}
                                        </div>
                                        <div className="flex flex-col">
                                            <span>{txn.merchant_normalized || txn.description}</span>
                                            {groupByCard && txn.account_id && (
                                                <span className="text-xs text-gray-400 font-normal">Card: ...{txn.account_id.slice(-4)}</span>
                                            )}
                                        </div>
                                    </div>
                                </td>
                                <td className="px-6 py-4 text-gray-500">
                                    {new Date(txn.date).toLocaleDateString()}
                                </td>
                                <td className="px-6 py-4">
                                    <div className="flex flex-col gap-1 items-start">
                                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                            {txn.category}
                                        </span>
                                        <div className="flex flex-wrap gap-1">
                                            {txn.tags && txn.tags.map((tag, i) => (
                                                <span key={i} className="text-[10px] bg-blue-50 text-blue-600 px-1.5 rounded border border-blue-100">#{tag}</span>
                                            ))}
                                            {editingId === txn.id ? (
                                                <div className="flex items-center gap-1 mt-1">
                                                    <input
                                                        autoFocus
                                                        className="text-xs border rounded px-1 py-0.5 w-20"
                                                        value={editTags}
                                                        onChange={e => setEditTags(e.target.value)}
                                                        onBlur={() => handleSaveTags(txn.id)}
                                                        onKeyDown={e => e.key === 'Enter' && handleSaveTags(txn.id)}
                                                        placeholder="comma,sep"
                                                    />
                                                </div>
                                            ) : (
                                                <button
                                                    onClick={() => { setEditingId(txn.id); setEditTags(txn.tags?.join(', ') || ''); }}
                                                    className="opacity-0 group-hover:opacity-100 text-[10px] text-gray-400 hover:text-blue-500 underline decoration-dotted transition-opacity"
                                                >
                                                    + Tag
                                                </button>
                                            )}
                                        </div>
                                    </div>
                                </td>
                                <td className={`px-6 py-4 text-right font-medium ${txn.type === 'CREDIT' ? 'text-green-600' : 'text-gray-900'
                                    }`}>
                                    {txn.type === 'DEBIT' ? '-' : '+'}₹{Math.abs(txn.amount).toLocaleString('en-IN')}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
