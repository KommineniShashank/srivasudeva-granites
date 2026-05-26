<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Edit Expense</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/editExpense.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="box">
    <h2>Edit Expense</h2>

    <form action="<%= request.getContextPath() %>/updateExpense" method="post">
        <input type="hidden" name="id" value="<%= request.getParameter("id") %>">

        <label>Date</label>
        <input type="date" name="date"
               value="<%= request.getParameter("date") %>" required>

        <label>Category</label>
        <input type="text" name="category"
               value="<%= request.getParameter("category") %>" required>

        <label>Description</label>
        <input type="text" name="description"
               value="<%= request.getParameter("remark") %>" required>

        <label>Amount</label>
        <input type="number" step="0.01" inputmode="decimal"
               name="amount"
               value="<%= request.getParameter("amount") %>" required>

        <button type="submit">Update Expense</button>
    </form>
</div>

</body>
</html>
