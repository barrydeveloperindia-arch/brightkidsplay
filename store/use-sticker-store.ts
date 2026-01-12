import { create } from 'zustand';
import { createJSONStorage, persist } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';

export type StickerId = 'leo-gold' | 'mia-star' | 'hoot-smart' | 'abc-master';

interface StickerState {
    unlockedStickers: StickerId[];
    unlockSticker: (id: StickerId) => void;
    isUnlocked: (id: StickerId) => boolean;
}

export const useStickerStore = create<StickerState>()(
    persist(
        (set, get) => ({
            unlockedStickers: [],
            unlockSticker: (id) => {
                const current = get().unlockedStickers;
                if (!current.includes(id)) {
                    set({ unlockedStickers: [...current, id] });
                }
            },
            isUnlocked: (id) => get().unlockedStickers.includes(id),
        }),
        {
            name: 'sticker-storage',
            storage: createJSONStorage(() =>
                Platform.OS === 'web' ? localStorage : AsyncStorage
            ),
        }
    )
);
