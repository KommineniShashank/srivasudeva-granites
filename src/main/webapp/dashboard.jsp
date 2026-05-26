<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    Object totalBillsObj = request.getAttribute("totalBills");
    Object totalSalesObj = request.getAttribute("totalSales");
    Object totalGSTObj = request.getAttribute("totalGST");
    Object nonGSTObj = request.getAttribute("nonGST");

    String totalBills = totalBillsObj != null ? totalBillsObj.toString() : "0";
    String totalSales = totalSalesObj != null ? totalSalesObj.toString() : "0.00";
    String totalGST = totalGSTObj != null ? totalGSTObj.toString() : "0.00";
    String nonGST = nonGSTObj != null ? nonGSTObj.toString() : "0.00";
%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Sales Dashboard</h2>

    <div class="cards">
        <div class="card">
            <h3>Total Bills</h3>
            <div class="value"><%= totalBills %></div>
        </div>

        <div class="card">
            <h3>Total Sales</h3>
            <div class="value">Rs <%= totalSales %></div>
        </div>

        <div class="card">
            <h3>GST Collected</h3>
            <div class="value">Rs <%= totalGST %></div>
        </div>

        <div class="card">
            <h3>Non-GST Amount</h3>
            <div class="value">Rs <%= nonGST %></div>
        </div>
    </div>

    <div class="section">
        <h2>Granite Sales Summary</h2>

        <div class="table-wrapper">
            <table>
                <tr>
                    <th>Granite Name</th>
                    <th>Total Quantity Sold</th>
                    <th>Total Amount (Rs)</th>
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
                    <td>Rs <%= row.get("amount") %></td>
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
