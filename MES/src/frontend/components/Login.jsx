import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';

export default function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const { login } = useAuth();

    const handleSubmit = async (e) => {
        e.preventDefault();
        const success = await login(username, password);
        if (!success) {
            setError('Invalid credentials');
        }
    };

    return (
        <div className="min-h-screen bg-gray-100 flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-300">
            <div className="bg-white/70 backdrop-blur-md p-8 rounded-2xl shadow-xl w-full max-w-md border border-white/50">
                <div className="mb-8 text-center">
                    <h1 className="text-3xl font-light text-gray-900 tracking-tight">Englabs<span className="font-bold text-englabs-blue">MES</span></h1>
                    <p className="text-gray-500 text-sm mt-2">Secure Operator Access</p>
                </div>

                <form onSubmit={handleSubmit} className="space-y-6">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Username</label>
                        <input
                            type="text"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            className="w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-englabs-blue focus:border-transparent outline-none transition bg-white/50"
                            placeholder="operator"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-englabs-blue focus:border-transparent outline-none transition bg-white/50"
                            placeholder="••••••••"
                        />
                    </div>

                    {error && <div className="text-red-500 text-sm text-center">{error}</div>}

                    <button
                        type="submit"
                        className="w-full bg-englabs-blue text-white py-2 rounded-lg hover:bg-blue-700 transition shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
                    >
                        Sign In
                    </button>
                </form>

                <div className="mt-6 text-center text-xs text-gray-400">
                    Protected by Englabs Sentinel • v2.0
                </div>
            </div>
        </div>
    );
}
