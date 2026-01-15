import React, { useMemo } from 'react';
import { View, Text, SectionList, TouchableOpacity, Platform } from 'react-native';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { styled } from 'nativewind';

// Styled Components (NativeWind)
const Container = styled(View, 'flex-1 bg-white px-4 pt-6');
const Header = styled(Text, 'text-2xl font-bold text-black mb-4 tracking-tight');
const SectionHeader = styled(Text, 'text-xs font-semibold text-gray-400 uppercase tracking-widest mt-6 mb-2');
const TransactionCard = styled(TouchableOpacity, 'flex-row justify-between items-center py-4 border-b border-gray-100');
const MerchantName = styled(Text, 'text-base font-medium text-black');
const CategoryLabel = styled(Text, 'text-xs text-gray-500 mt-1');
const Amount = styled(Text, 'text-base font-semibold');

// Types
type Transaction = {
    id: string;
    merchant: string;
    category: string;
    amount: number;
    date: string; // ISO String
    status: 'PENDING' | 'POSTED';
};

// API URL based on Platform (Android Emulator vs iOS/Web)
const API_URL = Platform.OS === 'android'
    ? 'http://10.0.2.2:8000/api/v1'
    : 'http://localhost:8000/api/v1';

// Helper to group by date (Simple version)
const groupTransactions = (txns: Transaction[]) => {
    const groups: { title: string; data: Transaction[] }[] = [];
    const today = new Date().toDateString();
    const yesterday = new Date(Date.now() - 86400000).toDateString();

    const sortedTxns = [...txns].sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());

    const grouped = sortedTxns.reduce((acc, txn) => {
        const dateObj = new Date(txn.date);
        let title = dateObj.toDateString();

        if (title === today) title = 'Today';
        if (title === yesterday) title = 'Yesterday';

        if (!acc[title]) acc[title] = [];
        acc[title].push(txn);
        return acc;
    }, {} as Record<string, Transaction[]>);

    Object.keys(grouped).forEach(key => {
        groups.push({ title: key, data: grouped[key] });
    });

    return groups;
};

export default function RecentTransactions() {
    const queryClient = useQueryClient();

    // 1. Fetch Transactions (Real API)
    const { data: transactions = [] } = useQuery({
        queryKey: ['transactions'],
        queryFn: async () => {
            const response = await fetch(`${API_URL}/transactions/`);
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.json();

            // Map Backend API to UI Model
            return data.map((txn: any) => ({
                id: txn.id,
                merchant: txn.description, // Backend uses 'description'
                category: txn.category,
                amount: txn.amount,
                date: txn.iso_date || txn.date, // Prefer ISO
                status: 'POSTED' // All backend txns are posted
            }));
        },
    });

    const sections = useMemo(() => groupTransactions(transactions), [transactions]);

    return (
        <Container>
            <Header>Recent Transactions</Header>

            <SectionList
                sections={sections}
                keyExtractor={(item) => item.id}
                renderSectionHeader={({ section: { title } }) => (
                    <SectionHeader>{title}</SectionHeader>
                )}
                renderItem={({ item }) => (
                    <TransactionCard>
                        <View>
                            <MerchantName>{item.merchant}</MerchantName>
                            <CategoryLabel>{item.category}</CategoryLabel>
                        </View>
                        <Amount className={item.amount > 0 ? 'text-green-600' : 'text-black'}>
                            {item.amount > 0 ? '+' : ''}{item.amount.toFixed(2)}
                        </Amount>
                    </TransactionCard>
                )}
                stickySectionHeadersEnabled={false}
                contentContainerStyle={{ paddingBottom: 50 }}
                showsVerticalScrollIndicator={false}
            />
        </Container>
    );
}

