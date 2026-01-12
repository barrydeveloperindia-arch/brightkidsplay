import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { useStickerStore } from '@/store/use-sticker-store';

// Simple letters data
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');

export default function LetterMonsterGame() {
    const router = useRouter();
    const [score, setScore] = useState(0);
    const [level, setLevel] = useState(1);
    const [targetLetter, setTargetLetter] = useState('A');
    const [options, setOptions] = useState<string[]>([]);
    const [feedback, setFeedback] = useState<string>('IDLE');
    const [debugMsg, setDebugMsg] = useState<string>('Init...');
    const { unlockSticker, isUnlocked } = useStickerStore();

    useEffect(() => {
        generateNewRound();
    }, []);

    const generateNewRound = () => {
        console.log("GENERATE START");
        setDebugMsg('Gen Start');
        try {
            // Pick a random target
            if (!ALPHABET || ALPHABET.length === 0) {
                setDebugMsg('Alpha Empty');
                return;
            }

            const randomTarget = ALPHABET[Math.floor(Math.random() * ALPHABET.length)];
            console.log("Target:", randomTarget);
            setTargetLetter(randomTarget);

            // Pick 2 distractors
            let newOptions = [randomTarget];
            while (newOptions.length < 3) {
                const randomDist = ALPHABET[Math.floor(Math.random() * ALPHABET.length)];
                if (!newOptions.includes(randomDist)) {
                    newOptions.push(randomDist);
                }
            }
            console.log("New Opts:", newOptions);
            // Shuffle
            const shuffled = newOptions.sort(() => Math.random() - 0.5);
            setOptions([...shuffled]); // Spread to ensure new ref
            setFeedback('IDLE');
            setDebugMsg('Gen Done: ' + shuffled.join(','));
        } catch (e: any) {
            console.error("GEN ERROR", e);
            setDebugMsg('Err: ' + e.message);
        }
    };

    const handlePress = (letter: string) => {
        if (feedback !== 'IDLE') return; // Prevent double taps

        if (letter === targetLetter) {
            // Correct!
            setFeedback('YUM!');
            const newScore = score + 1;
            setScore(newScore);

            // ZPD Logic: Increase difficulty every 3 points
            if (newScore % 3 === 0) {
                setLevel(prev => prev + 1);
            }

            // Reward Logic: Unlock 'leo-gold' at 5 points
            if (newScore === 5 && !isUnlocked('leo-gold')) {
                unlockSticker('leo-gold');
                Alert.alert("New Sticker!", "You unlocked Golden Leo! 🦁 go check your Sticker Book!");
            }

            // Wait then reload
            setTimeout(() => {
                generateNewRound();
            }, 1000);

        } else {
            // Wrong
            setFeedback('Blech!');

            setTimeout(() => {
                setFeedback('IDLE');
            }, 500);
        }
    };

    return (
        <View style={styles.container}>
            <View>
                <Text style={styles.score}>Score: {score}</Text>
                <Text style={{ color: 'red', fontSize: 12, backgroundColor: 'white' }}>Debug: {debugMsg}</Text>
                <Text style={{ color: 'blue', fontSize: 12, backgroundColor: 'white' }}>Opts: {JSON.stringify(options)}</Text>
                <TouchableOpacity onPress={generateNewRound} style={{ padding: 5, backgroundColor: 'yellow' }}>
                    <Text>FORCE GEN</Text>
                </TouchableOpacity>
            </View>

            {/* Monster Area */}
            <View style={styles.monsterArea}>
                <View style={styles.monster}>
                    <Text style={styles.monsterText}>
                        {feedback === 'YUM!' ? '😋' : feedback === 'Blech!' ? '😣' : '🦁'}
                    </Text>
                </View>
                <View style={styles.bubble}>
                    <Text style={styles.instruction}>
                        Feed me the letter <Text style={styles.targetLetter}>{targetLetter}</Text>!
                    </Text>
                </View>
            </View>

            {/* Options Area */}
            <View style={styles.optionsGrid}>
                {options.map((letter, index) => (
                    <TouchableOpacity
                        key={index}
                        style={styles.optionBtn}
                        onPress={() => handlePress(letter)}
                    >
                        <Text style={styles.optionText}>{letter}</Text>
                    </TouchableOpacity>
                ))}
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#87CEEB', // SkyBlue
        paddingTop: 50,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal: 20,
        marginBottom: 40,
    },
    backBtn: {
        backgroundColor: 'rgba(255,255,255,0.5)',
        padding: 10,
        borderRadius: 20,
    },
    backText: {
        fontWeight: 'bold',
        color: '#333',
    },
    score: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#fff',
        textShadowColor: 'rgba(0, 0, 0, 0.3)',
        textShadowOffset: { width: 1, height: 1 },
        textShadowRadius: 2,
    },
    monsterArea: {
        alignItems: 'center',
        marginBottom: 60,
    },
    monster: {
        width: 150,
        height: 150,
        backgroundColor: '#FFD700',
        borderRadius: 75,
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 5,
        borderColor: '#FFA500',
        marginBottom: 20,
    },
    monsterText: {
        fontSize: 80,
    },
    bubble: {
        backgroundColor: '#fff',
        padding: 15,
        borderRadius: 20,
        borderBottomLeftRadius: 0,
    },
    instruction: {
        fontSize: 20,
        color: '#333',
    },
    targetLetter: {
        fontWeight: 'bold',
        color: '#FF4500',
        fontSize: 24,
    },
    optionsGrid: {
        flexDirection: 'row',
        justifyContent: 'center',
        gap: 20,
        flexWrap: 'wrap',
        backgroundColor: 'rgba(255,0,0,0.2)', // Debug red background
        minHeight: 100, // Force height
        width: '100%', // Force width
    },
    optionBtn: {
        width: 80,
        height: 80,
        backgroundColor: '#FF6347', // Tomato
        borderRadius: 40, // Circle
        alignItems: 'center',
        justifyContent: 'center',
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 4.65,
        elevation: 8,
    },
    optionText: {
        fontSize: 40,
        fontWeight: 'bold',
        color: 'white',
    }
});
