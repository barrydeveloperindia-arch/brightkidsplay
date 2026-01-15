-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- 1. USERS Table
-- Stores core user profile information.
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store bcrypt/argon2 hash
    full_name VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. CONSENT_ARTEFACTS Table
-- Stores logs for Account Aggregator consents (DPDP Act Compliance).
CREATE TABLE consent_artefacts (
    consent_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    aa_consent_handle VARCHAR(255) NOT NULL, -- Handle from Setu/Anumati
    consent_status VARCHAR(50) NOT NULL, -- ACTIVE, REVOKED, PAUSED
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_to TIMESTAMP WITH TIME ZONE NOT NULL,
    data_consumer_id VARCHAR(100) NOT NULL,
    purpose_code VARCHAR(50), -- e.g., '101' for Wealth Management
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. ACCOUNTS Table
-- Linked bank accounts, credit cards, wallets. 
-- Can be linked via AA (Consent) or Manual (PDF Upload).
CREATE TABLE accounts (
    account_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    consent_id UUID REFERENCES consent_artefacts(consent_id), -- Nullable for manual accounts
    institution_id VARCHAR(50) NOT NULL, -- e.g., HDFC, ICICI
    institution_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- SAVINGS, CURRENT, CREDIT_CARD
    masked_account_number VARCHAR(50) NOT NULL,
    
    -- Financials (To be application-level encrypted in production)
    current_balance DECIMAL(19, 4), 
    
    status VARCHAR(50) DEFAULT 'ACTIVE',
    last_synced_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. MERCHANTS Table
-- Normalized merchant entities for clean UI.
CREATE TABLE merchants (
    merchant_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    raw_name_pattern VARCHAR(255), -- regex pattern e.g., 'IND*AMAZON.IN'
    normalized_name VARCHAR(100) NOT NULL, -- e.g., 'Amazon'
    logo_url VARCHAR(255),
    category_id VARCHAR(50), -- Link to a categories table (simplified here)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. TRANSACTIONS Table (Hypertable)
-- High-volume transaction data.
CREATE TABLE transactions (
    transaction_id UUID DEFAULT gen_random_uuid(),
    account_id UUID REFERENCES accounts(account_id) ON DELETE CASCADE,
    merchant_id UUID REFERENCES merchants(merchant_id), -- Nullable until normalized
    
    transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    currency VARCHAR(3) DEFAULT 'INR',
    description TEXT, -- Raw description from bank
    
    -- Architecture Specifics
    category VARCHAR(100), -- Predicted by LSTM
    type VARCHAR(20) CHECK (type IN ('DEBIT', 'CREDIT')),
    status VARCHAR(20) DEFAULT 'POSTED',
    
    -- Metadata from Parsers
    narration TEXT,
    reference_number VARCHAR(100),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Convert transactions table to TimescaleDB Hypertable
-- Partitioning by time (transaction_date) for efficient time-series queries.
SELECT create_hypertable('transactions', 'transaction_date');

-- Indexes for performance
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category ON transactions(category);
CREATE INDEX idx_merchants_normalized_name ON merchants(normalized_name);
