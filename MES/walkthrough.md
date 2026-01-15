# Englabs MES Implementation Walkthrough

This document outlines the implemented components of the Englabs On-Premise MES.

## 1. Module A: Intelligent Dispatching ("The Brain")
**Location**: `src/dispatch/`
- **`agent.py`**: Cognitive dispatch agent using vector memory.
- **`llm_client.py`**: Simulated Local LLM connector.

## 2. Module B: Shop Floor Execution ("The Body")
**Location**: `src/shop_floor/`
- **`iot_gateway/opcua_client.py`**: Mocked telemetry stream.
- **`digital_twin/service.py`**: Real-time state aggregation.

## 3. Module C: Automated Billing ("The Ledger")
**Location**: `src/financials/`
- **`costing/engine.py`**: Dynamic job costing.
- **`invoicing/generator.py`**: Trigger-based invoice generator. Now integrated with Module D.

## 4. Module D: Internal ERP Core ("The General Ledger")
**Location**: `src/financials/erp/`

An internal Double-Entry Bookkeeping system that replaces external ERP dependency.

- **`general_ledger.py`**: The core accounting engine. It manages the Chart of Accounts and validates that every Journal Entry is balanced (Debits = Credits).
- **`src/database/schema.sql`**: Extended to include `accounts`, `journal_entries`, and `journal_lines`.

**Verification**:
Run the ERP test logic:
```powershell
python -m tests.test_module_d
```
You should see "SUCCESS: Double Entry Validated" where Accounts Receivable increases and Sales Revenue increases by the same amount.

## Next Steps
1.  **UI Extension**: Add a "General Ledger" view to the frontend to visualize the `journal_entries` table.
2.  **Reporting**: Build a Balance Sheet and P&L report generator using the new SQL tables.
