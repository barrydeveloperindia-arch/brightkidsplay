# Englabs On-Premise MES

Secure, On-Premise Manufacturing Execution System with Digital Thread Architecture.

## System Overview

This system is designed around three core modules and a unified Digital Thread database.

### Module A: Intelligent Dispatching (The Brain)
- **Location**: `src/dispatch/`
- **Key Components**: Memory-Augmented Dispatch Agent, Interference Detection.
- **Logic**: `src/dispatch/agent.py` contains the pseudocode for the AI-driven dispatching agent using local LLM and vector memory.

### Module B: Manufacturing Execution (The Body)
- **Location**: `src/shop_floor/`
- **Sub-modules**:
  - `iot_gateway/`: OPC-UA clients and machine telemetry handlers.
  - `digital_traveler/`: Mobile-responsive operator interface.
  - `digital_twin/`: Real-time shop floor visualization.

### Module C: Automated Billing (The Ledger)
- **Location**: `src/financials/`
- **Sub-modules**:
  - `costing/`: Real-time job costing engine.
  - `invoicing/`: Trigger-based invoice generation and ERP sync.

## Database (The Digital Thread)
- **Location**: `src/database/`
- **Schema**: `src/database/schema.sql` defines the `machines`, `orders`, `dispatch_queue`, and `invoices` tables.

## Frontend & Design System
- **Location**: `src/frontend/`
- **Config**: `tailwind.config.js` defines the "Englabs Minimalist White" design system.
- **Theme**: Pure white backgrounds, dark grey text, and specific Englabs functional colors (Blue, Green, Red).

## Getting Started
1. Initialize the PostgreSQL database using `src/database/schema.sql`.
2. Configure the Local LLM endpoint in `src/dispatch/config.py` (to be created).
3. Run the scaffolding scripts to deploy the containerized services.
