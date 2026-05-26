<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Invoice - Sri Vasudeva Granites</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/invoice.css">
</head>

<body>

<%
    DecimalFormat df = new DecimalFormat("#0.00");

    Integer billId = (Integer) request.getAttribute("billId");
    Date billDate = (Date) request.getAttribute("billDate");

    double subTotal = request.getAttribute("subTotal") != null ? (Double) request.getAttribute("subTotal") : 0;
    double cgstPercent = request.getAttribute("cgstPercent") != null ? (Double) request.getAttribute("cgstPercent") : 0;
    double sgstPercent = request.getAttribute("sgstPercent") != null ? (Double) request.getAttribute("sgstPercent") : 0;
    double cgstAmount = request.getAttribute("cgstAmount") != null ? (Double) request.getAttribute("cgstAmount") : 0;
    double sgstAmount = request.getAttribute("sgstAmount") != null ? (Double) request.getAttribute("sgstAmount") : 0;
    double loadingCharge = request.getAttribute("loadingCharge") != null ? (Double) request.getAttribute("loadingCharge") : 0;
    double discount = request.getAttribute("discount") != null ? (Double) request.getAttribute("discount") : 0;
    double transport = request.getAttribute("transport") != null ? (Double) request.getAttribute("transport") : 0;
    double grandTotal = request.getAttribute("grandTotal") != null ? (Double) request.getAttribute("grandTotal") : 0;

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
        <p class="contact">7382150709 | 8125668290</p>
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
            <td>Rs <%= df.format(row.get("price")) %></td>
            <td>Rs <%= df.format(row.get("total")) %></td>
        </tr>
        <% }} %>
    </table>

    <table class="summary">
        <tr><td class="label">Sub Total</td><td class="value">Rs <%= df.format(subTotal) %></td></tr>
        <tr><td class="label">CGST (<%= cgstPercent %>%)</td><td class="value">Rs <%= df.format(cgstAmount) %></td></tr>
        <tr><td class="label">SGST (<%= sgstPercent %>%)</td><td class="value">Rs <%= df.format(sgstAmount) %></td></tr>
        <tr><td class="label">Loading Unloading Charges</td><td class="value">Rs <%= df.format(loadingCharge) %></td></tr>
        <tr class="discount-row"><td class="label">Discount</td><td class="value">- Rs <%= df.format(discount) %></td></tr>
        <tr class="transport-row"><td class="label">Transport</td><td class="value">+ Rs <%= df.format(transport) %></td></tr>
        <tr class="grand"><td class="label">Grand Total</td><td class="value">Rs <%= df.format(grandTotal) %></td></tr>
    </table>

    <div class="thank-you">
        Thank you for your business<br>
        <strong>Sri Vasudeva Granites</strong>
    </div>
</div>

<div class="print-btn">
    <button id="printInvoiceButton" type="button">Print / Save as PDF</button>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const printButton = document.getElementById("printInvoiceButton");
    if (printButton) {
        printButton.addEventListener("click", () => window.print());
    }
});
</script>
</body>
</html>
