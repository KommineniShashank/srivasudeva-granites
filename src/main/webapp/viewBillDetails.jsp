<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Bill Details</title>

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

/* MAIN CARD */
.container {
    width: 94%;
    max-width: 1100px;
    margin: 30px auto 80px;
    background: rgba(255,255,255,0.97);
    backdrop-filter: blur(14px);
    padding: 28px;
    border-radius: 22px;
    box-shadow: 0 35px 80px rgba(0,0,0,0.45);
}

/* HEADER */
.header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 2px dashed #e5e7eb;
    padding-bottom: 16px;
    margin-bottom: 20px;
    gap: 12px;
}

.header h2 {
    margin: 0;
    font-size: 26px;
    font-weight: 700;
    color: #0f172a;
}

.header .meta {
    font-size: 14px;
    color: #475569;
}

/* TABLE WRAPPER */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

/* TABLE */
table {
    width: 100%;
    min-width: 520px;
    margin-top: 20px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    padding: 14px;
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: #ffffff;
    font-size: 13px;
    letter-spacing: 1px;
    text-transform: uppercase;
    text-align: center;
}

td {
    padding: 14px;
    background: #ffffff;
    text-align: center;
    border-radius: 14px;
    font-size: 14px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.08);
}

/* SUMMARY */
.summary {
    width: 420px;
    max-width: 100%;
    margin-left: auto;
    margin-top: 32px;
    padding: 24px;
    border-radius: 20px;
    background: linear-gradient(135deg, #f8fafc, #eef2ff);
    box-shadow: inset 0 1px 0 #ffffff;
}

.summary p {
    display: flex;
    justify-content: space-between;
    margin: 12px 0;
    font-size: 15px;
    color: #1e293b;
}

.summary p span:last-child {
    font-weight: 600;
}

.grand {
    font-size: 20px;
    font-weight: 700;
    margin-top: 16px;
    padding-top: 14px;
    border-top: 2px dashed #c7d2fe;
    color: #16a34a;
}

/* BACK BUTTON */
.back {
    display: inline-block;
    margin-top: 30px;
    padding: 14px 30px;
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: #ffffff;
    font-size: 15px;
    font-weight: 600;
    text-decoration: none;
    border-radius: 40px;
    box-shadow: 0 18px 40px rgba(79,70,229,0.45);
    transition: all 0.3s ease;
}

.back:hover {
    transform: translateY(-2px) scale(1.05);
}

/* ================= MOBILE ================= */
@media (max-width: 768px) {

    .header {
        flex-direction: column;
        align-items: flex-start;
    }

    .header h2 {
        font-size: 22px;
    }

    table {
        min-width: 480px;
    }

    .summary {
        margin-left: 0;
        width: 100%;
    }

    .back {
        width: 100%;
        text-align: center;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">

<%
    DecimalFormat df = new DecimalFormat("#0.00");

    Integer billId = (Integer) request.getAttribute("billId");
    Date billDate  = (Date) request.getAttribute("billDate");

    double subTotal      = request.getAttribute("subTotal") != null ? (Double) request.getAttribute("subTotal") : 0;
    double gstPercent    = request.getAttribute("gstPercent") != null ? (Double) request.getAttribute("gstPercent") : 0;
    double gstAmount     = request.getAttribute("gstAmount") != null ? (Double) request.getAttribute("gstAmount") : 0;
    double loadingCharge = request.getAttribute("loadingCharge") != null ? (Double) request.getAttribute("loadingCharge") : 0;
    double discount      = request.getAttribute("discount") != null ? (Double) request.getAttribute("discount") : 0;
    double transport     = request.getAttribute("transport") != null ? (Double) request.getAttribute("transport") : 0;
    double grandTotal    = request.getAttribute("grandTotal") != null ? (Double) request.getAttribute("grandTotal") : 0;

    List<Map<String, Object>> items =
        (List<Map<String, Object>>) request.getAttribute("items");
%>

<!-- HEADER -->
<div class="header">
    <h2>🧾 Bill #<%= billId %></h2>
    <div class="meta">
        Date<br>
        <b><%= billDate %></b>
    </div>
</div>

<!-- ITEMS -->
<div class="table-wrapper">
<table>
<tr>
    <th>Granite</th>
    <th>Qty (Sq.Ft)</th>
    <th>Price</th>
    <th>Total</th>
</tr>

<% if (items != null) {
    for (Map<String, Object> row : items) { %>
<tr>
    <td><%= row.get("granite") %></td>
    <td><%= df.format(row.get("qty")) %></td>
    <td>₹ <%= df.format(row.get("price")) %></td>
    <td>₹ <%= df.format(row.get("total")) %></td>
</tr>
<% }} %>
</table>
</div>

<!-- SUMMARY -->
<div class="summary">

<p>
    <span>Sub Total</span>
    <span>₹ <%= df.format(subTotal) %></span>
</p>

<% if (gstAmount > 0) { %>
<p>
    <span>GST (<%= df.format(gstPercent) %>%)</span>
    <span>₹ <%= df.format(gstAmount) %></span>
</p>
<% } %>

<% if (loadingCharge > 0) { %>
<p>
    <span>Loading & Unloading</span>
    <span>₹ <%= df.format(loadingCharge) %></span>
</p>
<% } %>

<% if (discount > 0) { %>
<p style="color:#ea580c;">
    <span>Discount</span>
    <span>− ₹ <%= df.format(discount) %></span>
</p>
<% } %>

<% if (transport > 0) { %>
<p style="color:#2563eb;">
    <span>Transport</span>
    <span>+ ₹ <%= df.format(transport) %></span>
</p>
<% } %>

<p class="grand">
    <span>Grand Total</span>
    <span>₹ <%= df.format(grandTotal) %></span>
</p>

</div>

<a class="back" href="viewBills">⬅ Back to Bills</a>

</div>
</body>
</html>
