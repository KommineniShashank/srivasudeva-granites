<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Invoice - Sri Vasudeva Granites</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 16px;
    color: #111827;
    background: #f8fafc;
}

.invoice {
    max-width: 900px;
    margin: auto;
    background: #ffffff;
    padding: 28px;
    border-radius: 12px;
    box-shadow: 0 20px 45px rgba(0,0,0,0.12);
}

.header {
    text-align: center;
    padding-bottom: 18px;
    border-bottom: 3px solid #1e293b;
}

.header h1 {
    margin: 0;
    font-size: 28px;
    font-weight: 700;
}

.header p {
    margin: 4px 0;
    font-size: 14px;
    color: #374151;
}

.contact {
    margin-top: 6px;
    font-weight: 600;
}

.bill-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 22px;
    gap: 12px;
    font-size: 14px;
}

.bill-info span {
    min-width: 160px;
    text-align: center;
}


table {
    width: 100%;
    margin-top: 24px;
    border-collapse: collapse;
}
th {
    letter-spacing: 0.6px;
}

td {
    vertical-align: middle;
}

th {
    background: #1e293b;
    color: #ffffff;
    padding: 12px;
    font-size: 13px;
}

td {
    padding: 12px;
    border: 1px solid #d1d5db;
    text-align: center;
    font-size: 14px;
}

tr:nth-child(even) {
    background: #f8fafc;
}

.summary {
    width: 45%;
    margin-left: auto;
    margin-top: 26px;
    border-collapse: collapse;
}

.summary td {
    padding: 10px;
    font-size: 15px;
}
.summary {
    background: #f8fafc;
    border-radius: 10px;
    padding: 12px;
}

.grand td {
    padding-top: 14px;
}


.label { text-align: left; }
.value { text-align: right; font-weight: 600; }

.grand {
    font-size: 20px;
    font-weight: 700;
    color: #15803d;
    border-top: 2px solid #1e293b;
}

@media print {
    .print-btn { display: none; }
}
.print-btn button {
    background: linear-gradient(135deg, #4f46e5, #2563eb);
    color: #ffffff;
    padding: 12px 28px;
    font-size: 14px;
    font-weight: 600;
    border: none;
    border-radius: 9999px; /* pill shape */
    cursor: pointer;
    transition: all 0.25s ease;
    box-shadow: 0 10px 25px rgba(37, 99, 235, 0.35);
}

.print-btn button:hover {
    transform: translateY(-1px);
    box-shadow: 0 14px 30px rgba(37, 99, 235, 0.45);
}

.print-btn button:active {
    transform: translateY(0);
}

</style>
</head>

<body>

<%
    DecimalFormat df = new DecimalFormat("#0.00");

    Integer billId = (Integer) request.getAttribute("billId");
    Date billDate  = (Date) request.getAttribute("billDate");

    double subTotal      = request.getAttribute("subTotal") != null ? (Double) request.getAttribute("subTotal") : 0;
    double cgstPercent   = request.getAttribute("cgstPercent") != null ? (Double) request.getAttribute("cgstPercent") : 0;
    double sgstPercent   = request.getAttribute("sgstPercent") != null ? (Double) request.getAttribute("sgstPercent") : 0;
    double cgstAmount    = request.getAttribute("cgstAmount") != null ? (Double) request.getAttribute("cgstAmount") : 0;
    double sgstAmount    = request.getAttribute("sgstAmount") != null ? (Double) request.getAttribute("sgstAmount") : 0;
    double loadingCharge = request.getAttribute("loadingCharge") != null ? (Double) request.getAttribute("loadingCharge") : 0;
    double discount      = request.getAttribute("discount") != null ? (Double) request.getAttribute("discount") : 0;
    double transport     = request.getAttribute("transport") != null ? (Double) request.getAttribute("transport") : 0;
    double grandTotal    = request.getAttribute("grandTotal") != null ? (Double) request.getAttribute("grandTotal") : 0;

    List<Map<String, Object>> items =
        (List<Map<String, Object>>) request.getAttribute("items");
%>

<div class="invoice">

<div class="header">
    <h1>SRI VASUDEVA GRANITES AND TILES</h1>
    <p>
        Survey No.113, Plot No.37, PNR Colony,<br>
        Janachaitanya, Ameenpur, Hyderabad, Telangana - 502032
    </p>
    <p><strong>GSTIN: 36ANRPK0153G1Z0</strong></p>
    <p class="contact">📞 7382150709 | 8125668290</p>
</div>

<div class="bill-info">
    <span>Bill No: <%= billId %></span>
    <span>Date: <%= billDate %></span>
</div>

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

<table class="summary">
<tr><td class="label">Sub Total</td><td class="value">₹ <%= df.format(subTotal) %></td></tr>
<tr><td class="label">CGST (<%= cgstPercent %>%)</td><td class="value">₹ <%= df.format(cgstAmount) %></td></tr>
<tr><td class="label">SGST (<%= sgstPercent %>%)</td><td class="value">₹ <%= df.format(sgstAmount) %></td></tr>
<tr><td class="label">Loading Unloading Charges</td><td class="value">₹ <%= df.format(loadingCharge) %></td></tr>
<tr><td class="label" style="color:#dc2626;">Discount</td><td class="value" style="color:#dc2626;">− ₹ <%= df.format(discount) %></td></tr>
<tr><td class="label" style="color:#15803d;">Transport</td><td class="value" style="color:#15803d;">+ ₹ <%= df.format(transport) %></td></tr>
<tr class="grand"><td class="label">Grand Total</td><td class="value">₹ <%= df.format(grandTotal) %></td></tr>
</table>

<div style="text-align:center; margin-top:30px;">
    Thank you for your business 🙏 <br>
    <strong>Sri Vasudeva Granites</strong>
</div>

</div>

<div class="print-btn" style="text-align:center; margin-top:20px;">
    <button onclick="window.print()">🖨️ Print / Save as PDF</button>
</div>

</body>
</html>
