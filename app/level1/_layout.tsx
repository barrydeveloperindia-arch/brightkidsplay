import { Stack } from 'expo-router';

export default function Level1Layout() {
    return (
        <Stack>
            <Stack.Screen
                name="index"
                options={{
                    headerShown: true,
                    headerTitle: 'Level 1 Map',
                    headerStyle: { backgroundColor: '#4169E1' },
                    headerTintColor: '#fff',
                    headerTitleStyle: { fontWeight: 'bold', fontSize: 24 },
                }}
            />
            <Stack.Screen
                name="literacy/letter-monster"
                options={{ headerShown: false }}
            />
        </Stack>
    );
}
