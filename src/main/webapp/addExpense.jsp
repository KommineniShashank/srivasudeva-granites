<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Add Expense</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/addExpense.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Add Expense</h2>

    <form action="<%= request.getContextPath() %>/addExpense" method="post">
        <label>Expense Type</label>
        <input type="text"
               name="expenseType"
               placeholder="Electricity, Rent, Diesel"
               required>

        <label>Amount</label>
        <input type="number"
               step="0.01"
               name="amount"
               placeholder="Enter amount"
               required>

        <label>Expense Date</label>
        <input type="date"
               name="expenseDate"
               required>

        <label>Remark</label>
        <input type="text"
               name="remark"
               placeholder="Optional">

        <button type="submit">Save Expense</button>
    </form>
</div>

</body>
</html>
