import React from 'react';

const InvoiceRow = ({ id, client, date, amount, status }) => (
    <tr className="border-b border-gray-100 hover:bg-gray-50 transition">
        <td className="py-4 px-4 font-mono text-sm text-gray-600">{id}</td>
        <td className="py-4 px-4 font-medium text-gray-900">{client}</td>
        <td className="py-4 px-4 text-gray-500">{date}</td>
        <td className="py-4 px-4 font-mono text-gray-900">${amount}</td>
        <td className="py-4 px-4">
            <span className={`px-2 py-1 text-xs rounded-full ${status === 'PAID' ? 'bg-green-100 text-green-800' :
                    status === 'SYNCED' ? 'bg-blue-100 text-blue-800' :
                        'bg-yellow-100 text-yellow-800'
                }`}>
                {status}
            </span>
        </td>
    </tr>
);

export default function Invoices() {
    return (
        <div>
            <header className="mb-8 flex justify-between">
                <div>
                    <h1 className="text-3xl font-light text-gray-900">Financials</h1>
                    <p className="text-gray-500 mt-1">Automated Costing & ERP Sync</p>
                </div>
                <div className="text-right">
                    <div className="text-sm text-gray-500">Current Period Revenue</div>
                    <div className="text-2xl font-bold text-englabs-green">$12,450.00</div>
                </div>
            </header>

            <div className="bg-white rounded-lg shadow-englabs-card overflow-hidden">
                <table className="w-full text-left">
                    <thead className="bg-gray-50 text-xs uppercase tracking-wider text-gray-500">
                        <tr>
                            <th className="py-3 px-4 font-medium">Invoice ID</th>
                            <th className="py-3 px-4 font-medium">Client</th>
                            <th className="py-3 px-4 font-medium">Date Generated</th>
                            <th className="py-3 px-4 font-medium">Total</th>
                            <th className="py-3 px-4 font-medium">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <InvoiceRow id="INV-1718001" client="SpaceX Corp" date="Today" amount="1,035.00" status="SYNCED" />
                        <InvoiceRow id="INV-1717942" client="General Electric" date="Yesterday" amount="4,500.00" status="PAID" />
                        <InvoiceRow id="INV-1717880" client="Englabs Internal" date="Jan 12" amount="120.50" status="DRAFT" />
                    </tbody>
                </table>
            </div>
        </div>
    );
}
