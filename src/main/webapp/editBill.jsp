<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Edit Bill</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/editBill.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
<h2>Edit Bill</h2>

<form action="<%= request.getContextPath() %>/updateBill" method="post">

<input type="hidden" name="billId" value="${billId}">

<label>Bill Date</label>
<input type="date" name="billDate" value="${billDate}" required>

<div class="table-wrapper">
<table>
<tr>
    <th>Granite</th>
    <th>Qty</th>
    <th>Price</th>
    <th>Total</th>
</tr>

<%
List<Map<String, Object>> items =
        (List<Map<String, Object>>) request.getAttribute("items");

if (items != null) {
    for (Map<String, Object> row : items) {
%>
<tr class="itemRow">
    <td><input name="graniteName[]" value="<%= row.get("granite") %>" required></td>
    <td><input class="qty" name="quantity[]" value="<%= row.get("quantity") %>" required></td>
    <td><input class="price" name="price[]" value="<%= row.get("price") %>" required></td>
    <td>Rs <span class="rowTotal">0.00</span></td>
</tr>
<%
    }
}
%>
</table>
</div>

<br>

<label>GST %</label>
<input type="number" id="gstPercent" name="gstPercent" value="${gstPercent}">

<br><br>
<label>
<input type="checkbox" id="loadingFlag"
<%= Boolean.TRUE.equals(request.getAttribute("loadingFlag")) ? "checked" : "" %>>
 Loading and Unloading (Rs 3 / Sq.Ft)
</label>

<br><br>
<label>Discount</label>
<input type="number" id="discount" name="discount" value="${discount}">

<label>Transport</label>
<input type="number" id="transport" name="transport" value="${transport}">

<div class="summary">
<p><span>Sub Total</span><span>Rs <span id="subTotalText">0.00</span></span></p>
<p><span>GST Amount</span><span>Rs <span id="gstAmountText">0.00</span></span></p>
<p><span>Loading</span><span>Rs <span id="loadingText">0.00</span></span></p>
<p class="total"><span>Grand Total</span><span>Rs <span id="grandTotalText">0.00</span></span></p>
</div>

<button type="submit">Update Bill</button>

</form>
</div>

<script>
function calculateBill() {
    let subTotal = 0;
    let totalQty = 0;

    document.querySelectorAll(".itemRow").forEach((row) => {
        const qty = parseFloat(row.querySelector(".qty").value) || 0;
        const price = parseFloat(row.querySelector(".price").value) || 0;
        const total = qty * price;

        row.querySelector(".rowTotal").innerText = total.toFixed(2);
        subTotal += total;
        totalQty += qty;
    });

    const gstPercent = parseFloat(document.getElementById("gstPercent").value) || 0;
    const gstAmount = (subTotal * gstPercent) / 100;
    const loading = document.getElementById("loadingFlag").checked ? totalQty * 3 : 0;
    const discount = parseFloat(document.getElementById("discount").value) || 0;
    const transport = parseFloat(document.getElementById("transport").value) || 0;
    const grandTotal = subTotal + gstAmount + loading + transport - discount;

    document.getElementById("subTotalText").innerText = subTotal.toFixed(2);
    document.getElementById("gstAmountText").innerText = gstAmount.toFixed(2);
    document.getElementById("loadingText").innerText = loading.toFixed(2);
    document.getElementById("grandTotalText").innerText = grandTotal.toFixed(2);
}

window.calculateBill = calculateBill;

document.addEventListener("DOMContentLoaded", () => {
    calculateBill();

    document.addEventListener("input", (event) => {
        if (
            event.target.matches(".qty") ||
            event.target.matches(".price") ||
            event.target.matches("#gstPercent") ||
            event.target.matches("#discount") ||
            event.target.matches("#transport")
        ) {
            calculateBill();
        }
    });

    document.addEventListener("change", (event) => {
        if (event.target.matches("#loadingFlag")) {
            calculateBill();
        }
    });
});
</script>
</body>
</html>
