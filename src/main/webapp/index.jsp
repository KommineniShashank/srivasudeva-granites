<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Srivasudeva Granites</title>

<!-- ✅ VERY IMPORTANT FOR MOBILE -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- ✅ GLOBAL MOBILE CSS -->
<link rel="stylesheet" href="css/mobile.css">

<style>
* {
    box-sizing: border-box;
}

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background:
        radial-gradient(circle at top left, #1e3c72, #2a5298),
        linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    min-height: 100vh;
    color: #111827;
}

/* ✅ FIX: prevent navbar overlap on mobile */
@media (max-width: 768px) {
    body {
        padding-top: 64px;
    }
}

/* HERO */
.hero {
    padding: 90px 20px 80px;
    text-align: center;
    color: #ffffff;
    position: relative;
    overflow: hidden;
}

.hero::before,
.hero::after {
    content: "";
    position: absolute;
    border-radius: 50%;
    filter: blur(90px);
    opacity: 0.45;
}

.hero::before {
    width: 300px;
    height: 300px;
    background: #38bdf8;
    top: -80px;
    left: -80px;
}

.hero::after {
    width: 260px;
    height: 260px;
    background: #a78bfa;
    bottom: -80px;
    right: -80px;
}

.hero h1 {
    font-size: 44px;
    font-weight: 700;
    letter-spacing: 1px;
    margin-bottom: 12px;
}

.hero p {
    font-size: 18px;
    opacity: 0.9;
}

/* CONTAINER */
.container {
    width: 94%;
    max-width: 1350px;
    margin: -60px auto 80px;
    position: relative;
    z-index: 2;
}

/* CARD GRID */
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 34px;
}

/* CARD */
.card {
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    border-radius: 22px;
    padding: 34px 26px;
    text-align: center;
    position: relative;
    overflow: hidden;
    box-shadow: 0 25px 60px rgba(0,0,0,0.18);
    transition: all 0.4s ease;
}

/* Top Accent */
.card::before {
    content: "";
    position: absolute;
    inset: 0 0 auto 0;
    height: 6px;
    background: linear-gradient(90deg, #6366f1, #22c55e, #06b6d4);
}

/* Glow */
.card::after {
    content: "";
    position: absolute;
    width: 160px;
    height: 160px;
    background: radial-gradient(circle, rgba(99,102,241,0.35), transparent 60%);
    top: -40px;
    right: -40px;
    opacity: 0;
    transition: 0.4s;
}

.card:hover::after {
    opacity: 1;
}

.card:hover {
    transform: translateY(-16px) scale(1.03);
    box-shadow: 0 45px 90px rgba(0,0,0,0.35);
}

/* Card Content */
.card h3 {
    margin: 18px 0 12px;
    font-size: 22px;
    font-weight: 600;
    color: #0f172a;
}

.card p {
    font-size: 14px;
    color: #475569;
    margin-bottom: 26px;
    line-height: 1.6;
    min-height: 48px;
}

/* Button */
.card a {
    display: inline-block;
    padding: 12px 26px;
    font-size: 14px;
    font-weight: 600;
    border-radius: 30px;
    text-decoration: none;
    color: #ffffff;
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    box-shadow: 0 20px 40px rgba(37,99,235,0.45);
    transition: all 0.35s ease;
}

.card a:hover {
    transform: translateY(-2px) scale(1.05);
    box-shadow: 0 35px 65px rgba(79,70,229,0.6);
}

/* Footer */
footer {
    text-align: center;
    padding: 22px;
    font-size: 14px;
    color: #cbd5f5;
    background: transparent;
    margin-top: 60px;
}

/* Responsive text */
@media (max-width: 768px) {
    .hero h1 {
        font-size: 34px;
    }
}
</style>
</head>

<body>

<!-- NAVBAR -->
<jsp:include page="navbar.jsp"/>

<!-- HERO -->
<div class="hero">
    <h1>🧱 Sri Vasudeva Granites & Tiles</h1>
    <p>Billing • Stock • Measurement • Profit • Business Control</p>
</div>

<!-- CARDS -->
<div class="container">
    <div class="cards">

        <div class="card">
            <h3>🧾 New Bill</h3>
            <p>Create granite bills with GST and automatic stock updates</p>
            <a href="billing.jsp">Create Bill</a>
        </div>

        <div class="card">
            <h3>📋 View Bills</h3>
            <p>View, edit, print invoices and manage billing history</p>
            <a href="viewBills">View Bills</a>
        </div>

        <div class="card">
            <h3>📐 Measurement</h3>
            <p>Slab-wise square feet calculator for granite</p>
            <a href="measurement.jsp">Open Calculator</a>
        </div>

        <div class="card">
            <h3>📊 Dashboard</h3>
            <p>Sales, GST, granite-wise and monthly summaries</p>
            <a href="dashboard">Open Dashboard</a>
        </div>

        <div class="card">
            <h3>🧱 Granite Stock</h3>
            <p>Live stock availability of all granite types</p>
            <a href="viewGraniteStock">View Stock</a>
        </div>

        <div class="card">
            <h3>📦 Stock In / Out</h3>
            <p>Purchase stock entries and manual adjustments</p>
            <a href="stockInOut.jsp">Manage Stock</a>
        </div>

        <div class="card">
            <h3>💸 Expenses</h3>
            <p>Track daily, monthly and category-wise expenses</p>
            <a href="viewExpenses">View Expenses</a>
        </div>

        <div class="card">
            <h3>💰 Profit Report</h3>
            <p>Complete profit & loss analysis of your business</p>
            <a href="profitReport">View Profit</a>
        </div>

    </div>
</div>

<footer>
    © 2026 Srivasudeva Granites | Internal Business Management System
</footer>

</body>
</html>
