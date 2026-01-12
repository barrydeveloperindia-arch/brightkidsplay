import { StyleSheet, Text, View, TouchableOpacity, ScrollView, Dimensions } from 'react-native';
import { useRouter } from 'expo-router';
import { StickerId, useStickerStore } from '@/store/use-sticker-store';

const { width } = Dimensions.get('window');

// Sticker Metadata
const STICKERS: { id: StickerId; emoji: string; name: string }[] = [
    { id: 'leo-gold', emoji: '🦁', name: 'Golden Leo' },
    { id: 'mia-star', emoji: '🐒', name: 'Mia Star' },
    { id: 'hoot-smart', emoji: '🦉', name: 'Smart Hoot' },
    { id: 'abc-master', emoji: '🅰️', name: 'ABC Master' },
];

export default function StickerBookScreen() {
    const router = useRouter();
    const { isUnlocked } = useStickerStore();

    return (
        <View style={styles.container}>
            <View style={styles.header}>
                <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
                    <Text style={styles.backText}>← Back</Text>
                </TouchableOpacity>
                <Text style={styles.title}>My Sticker Book</Text>
            </View>

            <ScrollView contentContainerStyle={styles.grid}>
                {STICKERS.map((sticker) => {
                    const unlocked = isUnlocked(sticker.id);
                    return (
                        <View key={sticker.id} style={[styles.slot, unlocked ? styles.unlocked : styles.locked]}>
                            <Text style={styles.stickerEmoji}>
                                {unlocked ? sticker.emoji : '🔒'}
                            </Text>
                            <Text style={styles.stickerName}>
                                {unlocked ? sticker.name : '???'}
                            </Text>
                        </View>
                    );
                })}
            </ScrollView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#FFE4B5', // Moccasin
        paddingTop: 50,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 20,
        marginBottom: 30,
    },
    backBtn: {
        backgroundColor: '#fff',
        padding: 10,
        borderRadius: 20,
        marginRight: 20,
        shadowColor: "#000",
        shadowOpacity: 0.1,
        shadowRadius: 2,
    },
    backText: { fontWeight: 'bold' },
    title: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#8B4513', // SaddleBrown
    },
    grid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
        gap: 20,
        padding: 20,
    },
    slot: {
        width: width * 0.4,
        height: width * 0.4,
        borderRadius: 20,
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 4,
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.2,
        shadowRadius: 3,
        elevation: 5,
    },
    unlocked: {
        backgroundColor: '#fff',
        borderColor: '#FFD700', // Gold border
    },
    locked: {
        backgroundColor: 'rgba(255,255,255,0.5)',
        borderColor: '#ccc',
    },
    stickerEmoji: {
        fontSize: 60,
        marginBottom: 10,
    },
    stickerName: {
        fontSize: 16,
        fontWeight: 'bold',
        color: '#333',
    }
});
