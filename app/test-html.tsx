import React, { useState } from 'react';

export default function TestHtmlRoute() {
    const [count, setCount] = useState(0);

    return (
        <div style={{ padding: 50, backgroundColor: 'orange' }}>
            <h1>Test HTML Route</h1>
            <p style={{ fontSize: 40, fontWeight: 'bold' }}>{count}</p>
            <button
                onClick={() => {
                    console.log('Clicked HTML button');
                    setCount(c => c + 1);
                }}
                style={{ fontSize: 20, padding: 10 }}
            >
                Increment HTML
            </button>
        </div>
    );
}
