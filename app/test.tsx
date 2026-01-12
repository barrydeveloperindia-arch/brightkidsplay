import React, { useState } from 'react';
import { View, Text, Button } from 'react-native';

export default function TestRoute() {
    const [count, setCount] = useState(0);

    return (
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: 'lime' }}>
            <Text style={{ fontSize: 24, marginBottom: 20 }}>Test Route</Text>
            <Text style={{ fontSize: 40, fontWeight: 'bold' }}>{count}</Text>
            <Button title="Increment" onPress={() => setCount(c => c + 1)} />
        </View>
    );
}
