<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Srivasudeva Granites</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/mobile.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="hero">
    <h1>Sri Vasudeva Granites and Tiles</h1>
    <p>Billing • Stock • Measurement • Profit • Business Control</p>
</div>

<div class="container">
    <div class="cards">
        <div class="card">
            <h3>New Bill</h3>
            <p>Create granite bills with GST and automatic stock updates</p>
            <a href="<%= request.getContextPath() %>/billing.jsp">Create Bill</a>
        </div>

        <div class="card">
            <h3>View Bills</h3>
            <p>View, edit, print invoices and manage billing history</p>
            <a href="<%= request.getContextPath() %>/viewBills">View Bills</a>
        </div>

        <div class="card">
            <h3>Measurement</h3>
            <p>Slab-wise square feet calculator for granite</p>
            <a href="<%= request.getContextPath() %>/measurement.jsp">Open Calculator</a>
        </div>

        <div class="card">
            <h3>Dashboard</h3>
            <p>Sales, GST, granite-wise and monthly summaries</p>
            <a href="<%= request.getContextPath() %>/dashboard">Open Dashboard</a>
        </div>

        <div class="card">
            <h3>Granite Stock</h3>
            <p>Live stock availability of all granite types</p>
            <a href="<%= request.getContextPath() %>/viewGraniteStock">View Stock</a>
        </div>

        <div class="card">
            <h3>Stock In / Out</h3>
            <p>Purchase stock entries and manual adjustments</p>
            <a href="<%= request.getContextPath() %>/stockInOut.jsp">Manage Stock</a>
        </div>

        <div class="card">
            <h3>Expenses</h3>
            <p>Track daily, monthly and category-wise expenses</p>
            <a href="<%= request.getContextPath() %>/viewExpenses">View Expenses</a>
        </div>

        <div class="card">
            <h3>Profit Report</h3>
            <p>Complete profit and loss analysis of your business</p>
            <a href="<%= request.getContextPath() %>/profitReport">View Profit</a>
        </div>
    </div>
</div>

<footer>
    © 2026 Srivasudeva Granites | Internal Business Management System
</footer>

</body>
</html>
