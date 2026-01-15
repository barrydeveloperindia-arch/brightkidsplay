'use client';

import { useState, useRef } from 'react';
import { UploadCloud, FileText, CheckCircle, AlertCircle, Loader2 } from 'lucide-react';

export function ImportWidget() {
    const [isDragging, setIsDragging] = useState(false);
    const [status, setStatus] = useState<'idle' | 'uploading' | 'success' | 'error'>('idle');
    const [message, setMessage] = useState('');
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleDrag = (e: React.DragEvent) => {
        e.preventDefault();
        e.stopPropagation();
        if (e.type === 'dragenter' || e.type === 'dragover') {
            setIsDragging(true);
        } else if (e.type === 'dragleave') {
            setIsDragging(false);
        }
    };

    const handleDrop = (e: React.DragEvent) => {
        e.preventDefault();
        e.stopPropagation();
        setIsDragging(false);

        if (e.dataTransfer.files && e.dataTransfer.files[0]) {
            handleUpload(e.dataTransfer.files[0]);
        }
    };

    const handleUpload = async (file: File) => {
        if (file.type !== 'application/pdf') {
            setStatus('error');
            setMessage('Only PDF files are supported');
            return;
        }

        setStatus('uploading');
        const formData = new FormData();
        formData.append('file', file);

        try {
            const res = await fetch('http://localhost:8000/api/v1/import/upload', {
                method: 'POST',
                body: formData,
            });
            const data = await res.json();

            if (res.ok) {
                setStatus('success');
                setMessage(`Processed ${data.results.processed} transactions`);
                // Reset after 3 seconds
                setTimeout(() => {
                    setStatus('idle');
                    setMessage('');
                    // Optional: Trigger global refresh?
                    window.location.reload();
                }, 3000);
            } else {
                setStatus('error');
                setMessage('Upload failed');
            }
        } catch (err) {
            setStatus('error');
            setMessage('Network error');
        }
    };

    return (
        <div
            className={`
                relative overflow-hidden rounded-3xl border-2 border-dashed p-8 transition-all duration-200 h-64 flex flex-col items-center justify-center text-center
                ${isDragging ? 'border-black bg-gray-50' : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50/50'}
                ${status === 'success' ? 'border-green-500 bg-green-50' : ''}
                ${status === 'error' ? 'border-red-500 bg-red-50' : ''}
            `}
            onDragEnter={handleDrag}
            onDragLeave={handleDrag}
            onDragOver={handleDrag}
            onDrop={handleDrop}
            onClick={() => status === 'idle' && fileInputRef.current?.click()}
        >
            <input
                type="file"
                ref={fileInputRef}
                className="hidden"
                accept=".pdf"
                onChange={(e) => e.target.files?.[0] && handleUpload(e.target.files[0])}
            />

            {status === 'idle' && (
                <>
                    <div className="w-16 h-16 bg-white rounded-2xl shadow-sm mb-4 flex items-center justify-center text-gray-400">
                        <UploadCloud className="w-8 h-8" />
                    </div>
                    <h3 className="font-semibold text-gray-900 mb-1">Import Statement</h3>
                    <p className="text-sm text-gray-500 max-w-[200px]">Drag & drop PDF statement or click to browse</p>
                </>
            )}

            {status === 'uploading' && (
                <>
                    <Loader2 className="w-10 h-10 text-black animate-spin mb-4" />
                    <p className="font-medium text-gray-900">Processing Statement...</p>
                    <p className="text-xs text-gray-500 mt-1">Extracting transactions</p>
                </>
            )}

            {status === 'success' && (
                <>
                    <CheckCircle className="w-12 h-12 text-green-500 mb-4" />
                    <h3 className="font-semibold text-green-700">Import Complete!</h3>
                    <p className="text-sm text-green-600">{message}</p>
                </>
            )}

            {status === 'error' && (
                <>
                    <AlertCircle className="w-12 h-12 text-red-500 mb-4" />
                    <h3 className="font-semibold text-red-700">Import Failed</h3>
                    <p className="text-sm text-red-600">{message}</p>
                </>
            )}
        </div>
    );
}
