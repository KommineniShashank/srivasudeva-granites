<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<style>
/* ================= NAVBAR BASE ================= */
.navbar {
    position: sticky;
    top: 0;
    z-index: 1000;

    display: flex;
    align-items: center;

    padding: 14px 20px;

    background: rgba(15, 23, 42, 0.92);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);

    box-shadow: 0 15px 35px rgba(0,0,0,0.35);
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

/* BRAND */
.brand {
    font-size: 18px;
    font-weight: 700;
    letter-spacing: 0.6px;
    color: #facc15;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 6px;
}

.brand:hover {
    color: #fde047;
}

/* HAMBURGER */
.menu-toggle {
    display: none;
    font-size: 26px;
    color: #facc15;           /* bright & visible */
    cursor: pointer;
    margin-left: auto;
    padding: 6px 10px;
    border-radius: 8px;
}

.menu-toggle:hover {
    background: rgba(255,255,255,0.15);
}

/* NAV LINKS WRAPPER */
.nav-links {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-left: 20px;
    flex: 1;
}

/* LINKS */
.nav-links a {
    color: #e5e7eb;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;

    padding: 10px 14px;
    border-radius: 12px;

    transition: all 0.25s ease;
    white-space: nowrap;
}

.nav-links a:hover {
    background: rgba(255,255,255,0.12);
    color: #ffffff;
    transform: translateY(-1px);
}

/* LOGOUT */
.nav-links a.logout {
    margin-left: auto;
    background: linear-gradient(135deg, #dc2626, #ef4444);
    color: #ffffff;
    padding: 10px 18px;
    box-shadow: 0 12px 25px rgba(220,38,38,0.45);
}

.nav-links a.logout:hover {
    background: linear-gradient(135deg, #b91c1c, #dc2626);
    transform: scale(1.05);
}

/* ================= MOBILE ================= */
@media (max-width: 768px) {

    .navbar {
        flex-wrap: wrap;
        padding: 14px 16px;
    }

    .menu-toggle {
        display: block;
    }

    .nav-links {
        display: none;
        flex-direction: column;
        width: 100%;
        margin-top: 12px;
        gap: 4px;
    }

    .nav-links a {
        width: 100%;
        text-align: left;
        padding: 12px 14px;
    }

    .nav-links a.logout {
        margin-left: 0;
    }

    .nav-links.show {
        display: flex;
    }
}
</style>

<script>
function toggleMenu() {
    document.getElementById("navLinks").classList.toggle("show");
}
</script>

<div class="navbar">

    <!-- BRAND -->
    <a class="brand" href="<%= request.getContextPath() %>/">
        🧱 Sri Vasudeva Granites
    </a>

    <!-- HAMBURGER -->
    <div class="menu-toggle" onclick="toggleMenu()">☰</div>

    <!-- NAV LINKS -->
    <div class="nav-links" id="navLinks">
        <a href="<%= request.getContextPath() %>/billing.jsp">➕ New Bill</a>
        <a href="<%= request.getContextPath() %>/viewBills">📋 View Bills</a>
       <a href="<%= request.getContextPath() %>/measurement.jsp">
    📐 Measurement
</a>

        <a href="<%= request.getContextPath() %>/dashboard">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/viewGraniteStock">📦 Granite Stock</a>
        <a href="<%= request.getContextPath() %>/stockInOut.jsp">📦 Stock In / Out</a>
        <a href="<%= request.getContextPath() %>/viewExpenses">💸 Expenses</a>
        <a href="<%= request.getContextPath() %>/profitReport">💰 Profit Report</a>

        <a class="logout" href="<%= request.getContextPath() %>/logout">🚪 Logout</a>
    </div>

</div>
