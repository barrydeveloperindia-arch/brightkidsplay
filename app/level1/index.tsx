import { StyleSheet, Text, View, TouchableOpacity, ScrollView, Dimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useRouter } from 'expo-router';

const { width } = Dimensions.get('window');

export default function Level1Hub() {
    const router = useRouter();

    return (
        <View style={styles.container}>
            {/* Sky & Background */}
            <View style={styles.sky}>
                <View style={styles.cloud1}><Text style={styles.cloudText}>☁️</Text></View>
                <View style={styles.cloud2}><Text style={styles.cloudText}>☁️</Text></View>
            </View>

            <View style={styles.header}>
                <Text style={styles.greeting}>Map: Level 1</Text>
            </View>

            <ScrollView contentContainerStyle={styles.mapContent}>
                {/* Path Line (Simulated) */}
                <View style={styles.pathLine} />

                {/* Node 1: Literacy */}
                <View style={styles.nodeContainer}>
                    <TouchableOpacity
                        style={[styles.node, { backgroundColor: '#FF6F61' }]} // Coral
                        onPress={() => router.push('/level1/literacy/letter-monster')}
                    >
                        <Text style={styles.nodeIcon}>🅰️</Text>
                    </TouchableOpacity>
                    <View style={styles.labelTag}>
                        <Text style={styles.labelText}>Letters</Text>
                    </View>
                </View>

                {/* Node 2: Math (Offset right) */}
                <View style={[styles.nodeContainer, { marginLeft: 100 }]}>
                    <TouchableOpacity style={[styles.node, { backgroundColor: '#FFD700' }]}>
                        <Text style={styles.nodeIcon}>🍌</Text>
                    </TouchableOpacity>
                    <View style={styles.labelTag}>
                        <Text style={styles.labelText}>Math</Text>
                    </View>
                </View>

                {/* Node 3: SEL (Offset left) */}
                <View style={[styles.nodeContainer, { marginRight: 80 }]}>
                    <TouchableOpacity style={[styles.node, { backgroundColor: '#9370DB' }]}>
                        <Text style={styles.nodeIcon}>😊</Text>
                    </TouchableOpacity>
                    <View style={styles.labelTag}>
                        <Text style={styles.labelText}>Feelings</Text>
                    </View>
                </View>

                {/* Decoration: Tree */}
                <View style={styles.tree}>
                    <Text style={{ fontSize: 60 }}>🌳</Text>
                </View>

            </ScrollView>

            <View style={styles.footer}>
                <View style={styles.mascotContainer}>
                    <View style={styles.mascot}>
                        <Text style={{ fontSize: 30 }}>🦁</Text>
                    </View>
                    <Text style={styles.mascotText}>Good Job!</Text>
                </View>
                <TouchableOpacity
                    style={styles.stickerBtn}
                    onPress={() => router.push('/sticker-book')}
                >
                    <Text style={{ fontSize: 24 }}>📒</Text>
                    <Text style={styles.stickerBtnText}>Stickers</Text>
                </TouchableOpacity>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#87CEEB', // Sky Blue
    },
    sky: {
        position: 'absolute',
        top: 0,
        width: '100%',
        height: 200,
    },
    cloud1: { position: 'absolute', top: 40, left: 20 },
    cloud2: { position: 'absolute', top: 80, right: 40 },
    cloudText: { fontSize: 40, opacity: 0.8 },
    header: {
        paddingTop: 50,
        alignItems: 'center',
    },
    greeting: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#fff',
        textShadowColor: 'rgba(0,0,0,0.2)',
        textShadowRadius: 3,
    },
    mapContent: {
        paddingVertical: 40,
        alignItems: 'center',
        paddingBottom: 150, // Space for ground
    },
    pathLine: {
        position: 'absolute',
        top: 50,
        bottom: 50,
        width: 10,
        backgroundColor: '#F4A460', // SandyBrown path
        borderRadius: 5,
        opacity: 0.6,
    },
    nodeContainer: {
        alignItems: 'center',
        marginBottom: 60,
    },
    node: {
        width: 80,
        height: 80,
        borderRadius: 40,
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 4,
        borderColor: '#fff',
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 4.65,
        elevation: 8,
    },
    nodeIcon: {
        fontSize: 35,
    },
    labelTag: {
        backgroundColor: '#fff',
        paddingHorizontal: 12,
        paddingVertical: 5,
        borderRadius: 12,
        marginTop: 10,
        shadowColor: "#000",
        shadowOpacity: 0.1,
        shadowRadius: 2,
        elevation: 2,
    },
    labelText: {
        fontWeight: 'bold',
        color: '#555',
    },
    tree: {
        position: 'absolute',
        bottom: 100,
        right: 20,
    },
    footer: {
        position: 'absolute',
        bottom: 0,
        width: '100%',
        height: 120,
        backgroundColor: '#90EE90', // LightGreen
        borderTopLeftRadius: 30,
        borderTopRightRadius: 30,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between', // Spread mascot and button
        paddingHorizontal: 30,
        shadowColor: "#000",
        shadowOffset: { width: 0, height: -3 },
        shadowOpacity: 0.1,
        shadowRadius: 5,
        elevation: 10,
    },
    mascotContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    mascot: {
        marginRight: 10,
    },
    mascotText: {
        fontSize: 20,
        fontWeight: 'bold',
        color: '#006400', // DarkGreen
    },
    stickerBtn: {
        alignItems: 'center',
        backgroundColor: '#FFD700',
        padding: 10,
        borderRadius: 15,
        borderWidth: 2,
        borderColor: '#DAA520',
        shadowColor: "#000",
        shadowOffset: {
            width: 0,
            height: 2,
        },
        shadowOpacity: 0.25,
        shadowRadius: 3.84,
        elevation: 5,
    },
    stickerBtnText: {
        fontWeight: 'bold',
        color: '#8B4513',
        fontSize: 12,
    }
});
