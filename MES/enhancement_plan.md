# Enhancement Plan: Auth, PLC, and UI Polish

## 1. Multi-User Authentication
**Goal**: Secure the system so different roles (Operator, Admin, Accountant) access their specific modules.

### Backend Changes
- **Database**: Add `User` table (`username`, `email`, `hashed_password`, `role`).
- **Security**: Install `python-jose` and `passlib`.
- **Logic**: Create `src/auth/` module with `router.py` (Login/Register) and `dependencies.py` (get_current_user).
- **Protection**: Wrap sensitive API endpoints (e.g., `create_order`, `generate_invoice`) with `Depends(get_current_user)`.

### Frontend Changes
- **Context**: Create `AuthProvider` context to manage JWT token.
- **UI**: Build a modern `LoginScreen.jsx`.
- **Routing**: Add `PrivateRoute` wrapper.

## 2. PLC Hardware Support
**Goal**: Enable real connection to industrial hardware via OPC-UA.

### Implementation
- **Refactor**: Rename `opcua_client.py` to `opcua_manager.py`.
- **Library**: Add `asyncua` dependency.
- **Logic**: Implement a `RealOpcUaClient` class that attempts actual TCP connections.
- **Config**: Add `config.py` toggle `USE_MOCK_HARDWARE=True/False`.

## 3. Modern UI Polish ("Premium Aesthetic")
**Goal**: Elevate the "Scientific Minimalist" look to a "Modern Enterprise" standard.

### Design System Updates
- **Glassmorphism**: Add semi-transparent sidebar and card backgrounds with backdrop blur.
- **Animations**: Add Framer Motion (or simple CSS transitions) for page loads and hover states.
- **Typography**: Refine font weights and tracking.
- **Components**:
    - **Sidebar**: Floating navigation with active glow.
    - **Dashboard**: Gradient accents on key metrics.
    - **Tables**: Modernized table rows (Invoices) with better spacing and hover effects.
