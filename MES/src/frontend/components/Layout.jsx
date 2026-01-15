import React from 'react';
import { useAuth } from '../context/AuthContext';
import { NavLink } from 'react-router-dom';

const NavItem = ({ to, icon, label }) => (
    <NavLink
        to={to}
        className={({ isActive }) =>
            `flex items-center space-x-3 px-4 py-3 rounded-lg transition-all duration-200 group ${isActive
                ? 'bg-englabs-blue/10 text-englabs-blue shadow-sm'
                : 'text-gray-500 hover:bg-gray-50 hover:text-gray-900'
            }`
        }
    >
        <span className="text-xl">{icon}</span>
        <span className="font-medium text-sm">{label}</span>
    </NavLink>
);

export default function Layout({ children }) {
    const { user, logout } = useAuth();

    return (
        <div className="flex h-screen bg-[#F5F7FA] overflow-hidden font-sans text-gray-900 bg-[url('https://cdn.pixabay.com/photo/2018/03/10/12/00/chemistry-3213757_1280.jpg')] bg-cover bg-center bg-blend-overlay bg-opacity-90">

            {/* Glassmorphism Sidebar */}
            <aside className="w-64 glass-sidebar h-full flex flex-col z-10 shadow-xl">
                <div className="p-8">
                    <h1 className="text-2xl font-light tracking-tight text-gray-900">
                        Englabs<span className="font-bold text-englabs-blue">MES</span>
                    </h1>
                    <div className="mt-1 flex items-center space-x-2">
                        <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div>
                        <span className="text-xs uppercase tracking-widest text-gray-400">System Online</span>
                    </div>
                </div>

                <nav className="flex-1 px-4 space-y-2 mt-4">
                    <NavItem to="/" icon="📋" label="Dispatch Command" />
                    <NavItem to="/shop-floor" icon="🏭" label="Shop Floor Live" />
                    <NavItem to="/financials" icon="💰" label="Financial Ledger" />
                </nav>

                <div className="p-4 border-t border-gray-100 bg-white/40">
                    <div className="flex items-center space-x-3 mb-4">
                        <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-400 to-purple-500 flex items-center justify-center text-white font-bold text-xs">
                            {user?.username?.substring(0, 2).toUpperCase() || 'OP'}
                        </div>
                        <div className="flex-1">
                            <p className="text-sm font-medium text-gray-900">{user?.username || 'Operator'}</p>
                            <p className="text-xs text-gray-500 capitalize">{user?.role || 'Access Level 1'}</p>
                        </div>
                    </div>
                    <button
                        onClick={logout}
                        className="w-full text-xs text-red-500 hover:bg-red-50 py-2 rounded transition"
                    >
                        Sign Out
                    </button>
                </div>
            </aside>

            {/* Main Content Area */}
            <main className="flex-1 overflow-y-auto p-10 relative">
                <div className="max-w-7xl mx-auto animate-fade-in glass-panel rounded-3xl p-8 min-h-full">
                    {children}
                </div>
            </main>
        </div>
    );
}
