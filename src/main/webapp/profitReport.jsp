<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Profit Report</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/profitReport.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Profit and Loss Report</h2>

    <div class="cards">
        <div class="card sales-card">
            <div class="icon">Sales</div>
            <h3>Total Sales</h3>
            <div class="value green">
                Rs <%= request.getAttribute("totalSales") %>
            </div>
        </div>

        <div class="card purchase-card">
            <div class="icon">Purchase</div>
            <h3>Total Purchase Cost</h3>
            <div class="value orange">
                Rs <%= request.getAttribute("totalPurchaseCost") %>
            </div>
        </div>

        <div class="card expense-card">
            <div class="icon">Expense</div>
            <h3>Total Expenses</h3>
            <div class="value red">
                Rs <%= request.getAttribute("totalExpenses") %>
            </div>
        </div>

        <div class="card profit-card">
            <div class="icon">Profit</div>
            <h3>Net Profit</h3>
            <div class="value blue">
                Rs <%= request.getAttribute("netProfit") %>
            </div>
        </div>
    </div>
</div>

</body>
</html>
