import { Link, router } from 'expo-router';
import { StyleSheet, Text, View, TouchableOpacity, Dimensions } from 'react-native';

import { SafeAreaView } from 'react-native-safe-area-context';

export default function WelcomeScreen() {
    return (
        <SafeAreaView style={styles.container}>
            <View style={styles.content}>
                <Text style={styles.title}>Bright Kids</Text>
                <Text style={styles.subtitle}>School</Text>

                <View style={styles.mascotPlaceholder}>
                    <Text style={styles.mascotText}>🦁</Text>
                </View>

                <TouchableOpacity
                    style={styles.button}
                    onPress={() => router.push('/level1')}
                >
                    <Text style={styles.buttonText}>START!</Text>
                </TouchableOpacity>
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#87CEEB', // SkyBlue match
    },
    content: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        padding: 20,
    },
    title: {
        fontSize: 48,
        fontWeight: 'bold',
        color: '#fff',
        marginBottom: 10,
        textShadowColor: 'rgba(0,0,0,0.2)',
        textShadowRadius: 3,
    },
    subtitle: {
        fontSize: 32,
        fontWeight: '600',
        color: '#006400', // DarkGreen
        marginBottom: 50,
    },
    mascotPlaceholder: {
        width: 150,
        height: 150,
        borderRadius: 75,
        backgroundColor: '#FFF',
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: 60,
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 5,
        },
        shadowOpacity: 0.34,
        shadowRadius: 6.27,
        elevation: 10,
    },
    mascotText: {
        fontSize: 80,
    },
    button: {
        backgroundColor: '#FF6F61', // Coral button for contrast
        paddingHorizontal: 60,
        paddingVertical: 20,
        borderRadius: 50,
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 4,
        },
        shadowOpacity: 0.30,
        shadowRadius: 4.65,
        elevation: 8,
    },
    buttonText: {
        color: 'white',
        fontSize: 32,
        fontWeight: 'bold',
        letterSpacing: 2,
    }
});
