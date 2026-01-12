const API_BASE = "http://127.0.0.1:8000";
let isLiveMode = false; // Default to MOCK

function getHeaders() {
    return {
        "x-mode": isLiveMode ? "LIVE" : "MOCK"
    };
}

// Fetch Summary Data
async function fetchSummary() {
    try {
        const response = await fetch(`${API_BASE}/data/summary`, { headers: getHeaders() });
        const data = await response.json();

        // Update KPIs
        document.getElementById("net-worth-display").innerText = `₹ ${data.net_worth.toLocaleString()}`;
        document.getElementById("account-count-display").innerText = data.account_count;

        // Simple heuristic for Assets vs Liabilities for "Total Assets" KPI (or just Net Worth repeat for now)
        // Let's sum only positive balances for "Total Assets"
        const totalAssets = data.accounts_breakdown.reduce((sum, acc) => acc.balance > 0 ? sum + acc.balance : sum, 0);
        document.getElementById("assets-display").innerText = `₹ ${totalAssets.toLocaleString()}`;

        // Render Accounts List
        const accountsList = document.getElementById("accounts-list");
        accountsList.innerHTML = "";

        data.accounts_breakdown.forEach(acc => {
            const item = document.createElement("div");
            item.className = "account-item";
            const bankInitial = acc.type === "CREDIT_CARD" ? "CC" : (acc.bank_name ? acc.bank_name[0] : "B");

            item.innerHTML = `
                <div class="account-icon-name">
                    <div class="bank-logo">${bankInitial}</div>
                    <div class="account-details">
                        <h4>${acc.type.replace('_', ' ')}</h4>
                        <p>${acc.masked_number}</p>
                    </div>
                </div>
                <div class="account-balance">
                    <h4 style="color: ${acc.balance >= 0 ? 'var(--success-color)' : 'var(--danger-color)'}">
                        ₹ ${acc.balance.toLocaleString()}
                    </h4>
                </div>
            `;
            accountsList.appendChild(item);
        });

        renderChart(data.accounts_breakdown);

    } catch (error) {
        console.error("Error fetching summary:", error);
    }
}

// Fetch Transactions
async function fetchTransactions() {
    try {
        const response = await fetch(`${API_BASE}/data/transactions`, { headers: getHeaders() });
        const txns = await response.json();

        const tbody = document.getElementById("txns-table-body");
        tbody.innerHTML = "";

        // Show top 10
        txns.slice(0, 10).forEach(txn => {
            const row = document.createElement("tr");
            const date = new Date(txn.date).toLocaleDateString();
            const amount = parseFloat(txn.amount);
            const isDebit = txn.txn_type === "DEBIT";

            row.innerHTML = `
                <td>${date}</td>
                <td>${txn.description}</td>
                <td><span class="type-badge ${isDebit ? 'type-debit' : 'type-credit'}">${txn.txn_type}</span></td>
                <td style="font-weight: 600; color: ${isDebit ? 'var(--text-primary)' : 'var(--success-color)'}">
                    ${isDebit ? '-' : '+'} ₹ ${Math.abs(amount).toLocaleString()}
                </td>
            `;
            tbody.appendChild(row);
        });

    } catch (error) {
        console.error("Error fetching transactions:", error);
    }
}

// Render Chart
let chartInstance = null;

function renderChart(accounts) {
    const ctx = document.getElementById('portfolioChart').getContext('2d');

    // Group by Type
    const dataByType = {};
    accounts.forEach(acc => {
        // Only chart positive assets for the pie chart usually, or split
        // Let's chart everything absolute value for "Distribution"
        if (!dataByType[acc.type]) dataByType[acc.type] = 0;
        dataByType[acc.type] += Math.abs(acc.balance);
    });

    const labels = Object.keys(dataByType).map(k => k.replace('_', ' '));
    const dataValues = Object.values(dataByType);

    if (chartInstance) chartInstance.destroy();

    chartInstance = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: dataValues,
                backgroundColor: [
                    '#6366f1',
                    '#a855f7',
                    '#ec4899',
                    '#10b981'
                ],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        color: '#9ca3af',
                        font: {
                            family: 'Outfit'
                        }
                    }
                }
            }
        }
    });
}

// Mock Consent Initiation
async function initiateConsent() {
    const mobile = prompt(`Enter Mobile Number for ${isLiveMode ? 'LIVE' : 'MOCK'} Bank:`, "9999999999");
    if (mobile) {
        try {
            // 1. Create Consent
            const res1 = await fetch(`${API_BASE}/consent/create?mobile_number=${mobile}`, {
                method: 'POST',
                headers: getHeaders()
            });
            const consent = await res1.json();
            alert(`Consent Created! ID: ${consent.id}\nStatus: ${consent.status}`);

            if (isLiveMode) {
                alert("In LIVE mode, you would now receive a notification to approve consent. Once approved, click OK to fetch data.");
            }

            // 2. Fetch Data immediately (assuming auto-approved in mock, or user clicked OK after approving in live)
            await fetch(`${API_BASE}/data/fetch/${consent.id}`, { headers: getHeaders() });
            alert("Data Fetched Successfully! Refreshing Dashboard...");

            fetchSummary();
            fetchTransactions();

        } catch (e) {
            alert("Error in flow: " + e);
        }
    }
}

document.getElementById("refresh-btn").addEventListener("click", () => {
    fetchSummary();
    fetchTransactions();
});

// Toggle Logic
const modeSwitch = document.getElementById("mode-switch");
const modeLabel = document.getElementById("mode-label");

modeSwitch.addEventListener("change", (e) => {
    isLiveMode = e.target.checked;
    modeLabel.innerText = isLiveMode ? "LIVE MODE" : "MOCK MODE";
    modeLabel.style.color = isLiveMode ? "var(--success-color)" : "var(--accent-color)";

    // Refresh to show data relevant to mode? 
    // Actually, DB is shared, but fetch logic changes. 
    // Ideally we might clear UI or assume DB matches the last fetch.
    // For now simple refresh.
    fetchSummary();
    fetchTransactions();
});

// Initial Load
fetchSummary();
fetchTransactions();
