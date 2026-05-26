<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<title>Bill Details</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/viewBillDetails.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">

<%
    DecimalFormat df = new DecimalFormat("#0.00");

    Integer billId = (Integer) request.getAttribute("billId");
    Date billDate = (Date) request.getAttribute("billDate");

    double subTotal = request.getAttribute("subTotal") != null ? (Double) request.getAttribute("subTotal") : 0;
    double gstPercent = request.getAttribute("gstPercent") != null ? (Double) request.getAttribute("gstPercent") : 0;
    double gstAmount = request.getAttribute("gstAmount") != null ? (Double) request.getAttribute("gstAmount") : 0;
    double loadingCharge = request.getAttribute("loadingCharge") != null ? (Double) request.getAttribute("loadingCharge") : 0;
    double discount = request.getAttribute("discount") != null ? (Double) request.getAttribute("discount") : 0;
    double transport = request.getAttribute("transport") != null ? (Double) request.getAttribute("transport") : 0;
    double grandTotal = request.getAttribute("grandTotal") != null ? (Double) request.getAttribute("grandTotal") : 0;

    List<Map<String, Object>> items =
        (List<Map<String, Object>>) request.getAttribute("items");
%>

<div class="header">
    <h2>Bill #<%= billId %></h2>
    <div class="meta">
        Date<br>
        <b><%= billDate %></b>
    </div>
</div>

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
    <td>Rs <%= df.format(row.get("price")) %></td>
    <td>Rs <%= df.format(row.get("total")) %></td>
</tr>
<% }} %>
</table>
</div>

<div class="summary">
<p>
    <span>Sub Total</span>
    <span>Rs <%= df.format(subTotal) %></span>
</p>

<% if (gstAmount > 0) { %>
<p>
    <span>GST (<%= df.format(gstPercent) %>%)</span>
    <span>Rs <%= df.format(gstAmount) %></span>
</p>
<% } %>

<% if (loadingCharge > 0) { %>
<p>
    <span>Loading and Unloading</span>
    <span>Rs <%= df.format(loadingCharge) %></span>
</p>
<% } %>

<% if (discount > 0) { %>
<p class="discount-text">
    <span>Discount</span>
    <span>- Rs <%= df.format(discount) %></span>
</p>
<% } %>

<% if (transport > 0) { %>
<p class="transport-text">
    <span>Transport</span>
    <span>+ Rs <%= df.format(transport) %></span>
</p>
<% } %>

<p class="grand">
    <span>Grand Total</span>
    <span>Rs <%= df.format(grandTotal) %></span>
</p>

</div>

<a class="back" href="<%= request.getContextPath() %>/viewBills">Back to Bills</a>

</div>
</body>
</html>
