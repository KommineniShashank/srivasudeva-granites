<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Stock In / Out</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/stockInOut.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Stock In / Out</h2>

    <form action="<%= request.getContextPath() %>/stockInOut" method="post">
        <label>Granite Name</label>
        <input type="text"
               name="graniteName"
               placeholder="Type granite name (eg: Black)"
               required>

        <label>Transaction Type</label>
        <select name="txnType" required>
            <option value="IN">Stock IN</option>
            <option value="OUT">Stock OUT</option>
        </select>

        <label>Quantity (Sq.Ft)</label>
        <input type="number"
               step="0.01"
               inputmode="decimal"
               name="qty"
               placeholder="Enter quantity"
               required>

        <label>Date</label>
        <input type="date" name="txnDate" required>

        <label>Remark</label>
        <input type="text" name="remark" placeholder="Optional">

        <button type="submit">Save Stock</button>
    </form>
</div>

</body>
</html>
