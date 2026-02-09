<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Profit Report</title>

<!-- ✅ IMPORTANT FOR MOBILE -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

/* MAIN CONTAINER */
.container {
    width: 94%;
    max-width: 1200px;
    margin: 30px auto 80px;
}

/* TITLE */
h2 {
    text-align: center;
    color: #f8fafc;
    margin-bottom: 42px;
    font-size: 30px;
    font-weight: 700;
    letter-spacing: 0.6px;
}

/* CARD GRID */
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 28px;
}

/* CARD */
.card {
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 30px 24px;
    border-radius: 24px;
    text-align: center;
    box-shadow: 0 30px 60px rgba(0,0,0,0.4);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

/* TOP ACCENT STRIP */
.card::before {
    content: "";
    position: absolute;
    inset: 0 0 auto 0;
    height: 7px;
}

.sales-card::before    { background: linear-gradient(90deg, #22c55e, #16a34a); }
.purchase-card::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
.expense-card::before  { background: linear-gradient(90deg, #dc2626, #ef4444); }
.profit-card::before   { background: linear-gradient(90deg, #2563eb, #4f46e5); }

/* HOVER (DESKTOP ONLY FEEL) */
.card:hover {
    transform: translateY(-10px) scale(1.03);
    box-shadow: 0 40px 80px rgba(0,0,0,0.55);
}

/* ICON */
.icon {
    font-size: 38px;
    margin-bottom: 14px;
}

/* TEXT */
.card h3 {
    margin: 12px 0;
    font-size: 18px;
    font-weight: 600;
    color: #334155;
}

.value {
    font-size: 30px;
    font-weight: 700;
    letter-spacing: 0.5px;
}

/* COLORS */
.green  { color: #16a34a; }
.orange { color: #f59e0b; }
.red    { color: #dc2626; }
.blue   { color: #2563eb; }

/* ================= MOBILE ================= */
@media (max-width: 768px) {

    h2 {
        font-size: 24px;
        margin-bottom: 30px;
    }

    .cards {
        gap: 20px;
    }

    .card {
        padding: 26px 20px;
    }

    .value {
        font-size: 26px;
    }

    .icon {
        font-size: 34px;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>📊 Profit & Loss Report</h2>

    <div class="cards">

        <div class="card sales-card">
            <div class="icon">💰</div>
            <h3>Total Sales</h3>
            <div class="value green">
                ₹ <%= request.getAttribute("totalSales") %>
            </div>
        </div>

        <div class="card purchase-card">
            <div class="icon">🧱</div>
            <h3>Total Purchase Cost</h3>
            <div class="value orange">
                ₹ <%= request.getAttribute("totalPurchaseCost") %>
            </div>
        </div>

        <div class="card expense-card">
            <div class="icon">💸</div>
            <h3>Total Expenses</h3>
            <div class="value red">
                ₹ <%= request.getAttribute("totalExpenses") %>
            </div>
        </div>

        <div class="card profit-card">
            <div class="icon">📈</div>
            <h3>Net Profit</h3>
            <div class="value blue">
                ₹ <%= request.getAttribute("netProfit") %>
            </div>
        </div>

    </div>
</div>

</body>
</html>
