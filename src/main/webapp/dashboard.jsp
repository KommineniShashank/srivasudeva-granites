<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    Object totalBillsObj = request.getAttribute("totalBills");
    Object totalSalesObj = request.getAttribute("totalSales");
    Object totalGSTObj   = request.getAttribute("totalGST");
    Object nonGSTObj     = request.getAttribute("nonGST");

    String totalBills = totalBillsObj != null ? totalBillsObj.toString() : "0";
    String totalSales = totalSalesObj != null ? totalSalesObj.toString() : "0.00";
    String totalGST   = totalGSTObj   != null ? totalGSTObj.toString()   : "0.00";
    String nonGST     = nonGSTObj     != null ? nonGSTObj.toString()     : "0.00";
%>

<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* {
    box-sizing: border-box;
}

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

/* MAIN CONTAINER */
.container {
    width: 94%;
    max-width: 1300px;
    margin: 40px auto 80px;
}

/* TITLES */
h2 {
    font-size: 28px;
    font-weight: 700;
    color: #f8fafc;
    margin-bottom: 20px;
}

/* SUMMARY CARDS */
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 28px;
    margin-bottom: 40px;
}

.card {
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 28px 26px;
    border-radius: 22px;
    text-align: center;
    box-shadow: 0 30px 60px rgba(0,0,0,0.35);
    transition: all 0.35s ease;
    position: relative;
    overflow: hidden;
}

/* Gradient strip */
.card::before {
    content: "";
    position: absolute;
    inset: 0 0 auto 0;
    height: 6px;
    background: linear-gradient(90deg, #22c55e, #2563eb, #7c3aed);
}

.card:hover {
    transform: translateY(-12px) scale(1.03);
    box-shadow: 0 45px 90px rgba(0,0,0,0.45);
}

.card h3 {
    font-size: 18px;
    font-weight: 600;
    color: #0f172a;
    margin-bottom: 14px;
}

/* VALUES */
.value {
    font-size: 28px;
    font-weight: 700;
    color: #16a34a;
    letter-spacing: 0.5px;
}

/* GRANITE SUMMARY */
.section {
    margin-top: 40px;
}

.section h2 {
    margin-bottom: 16px;
}

/* TABLE */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 520px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: #ffffff;
    padding: 14px;
    font-size: 13px;
    letter-spacing: 1px;
    text-transform: uppercase;
    text-align: center;
}

td {
    background: rgba(255,255,255,0.96);
    padding: 14px;
    text-align: center;
    border-radius: 14px;
    font-size: 14px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.12);
}

tr:hover td {
    background: #f8fafc;
}

/* EMPTY ROW */
td[colspan] {
    font-weight: 600;
    color: #475569;
}

/* ================= MOBILE OPTIMIZATION ================= */
@media (max-width: 768px) {

    .container {
        margin-top: 20px;
    }

    h2 {
        font-size: 22px;
        margin-bottom: 14px;
    }

    .cards {
        gap: 16px;
    }

    .card {
        padding: 20px 16px;
    }

    .card h3 {
        font-size: 15px;
    }

    .value {
        font-size: 22px;
    }

    th, td {
        font-size: 12px;
        padding: 10px;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">

    <h2>📊 Sales Dashboard</h2>

    <!-- SUMMARY CARDS -->
    <div class="cards">
        <div class="card">
            <h3>🧾 Total Bills</h3>
           <div class="value"><%= totalBills %></div>
        </div>

        <div class="card">
            <h3>💰 Total Sales</h3>
            <div class="value">₹ <%= totalSales %></div>
        </div>

        <div class="card">
            <h3>🧮 GST Collected</h3>
           <div class="value">₹ <%= totalGST %></div>

        </div>

        <div class="card">
            <h3>📦 Non-GST Amount</h3>
            <div class="value">₹ <%= nonGST %></div>
        </div>
    </div>

    <!-- GRANITE SUMMARY -->
    <div class="section">
        <h2>🧱 Granite Sales Summary</h2>

        <div class="table-wrapper">
            <table>
                <tr>
                    <th>Granite Name</th>
                    <th>Total Quantity Sold</th>
                    <th>Total Amount (₹)</th>
                </tr>

                <%
                    List<Map<String, Object>> graniteSummary =
                            (List<Map<String, Object>>) request.getAttribute("graniteSummary");

                    if (graniteSummary != null && !graniteSummary.isEmpty()) {
                        for (Map<String, Object> row : graniteSummary) {
                %>
                <tr>
                    <td><%= row.get("graniteName") %></td>
                    <td><%= row.get("quantity") %></td>
                    <td>₹ <%= row.get("amount") %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="3">No granite sales data</td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>

</div>

</body>
</html>
