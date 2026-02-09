<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Edit Bill</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

.container {
    width: 95%;
    max-width: 1200px;
    margin: 30px auto 80px;
    background: rgba(255,255,255,0.96);
    padding: 28px;
    border-radius: 22px;
    box-shadow: 0 30px 70px rgba(0,0,0,0.45);
}

h2 {
    font-size: 24px;
    margin-bottom: 20px;
    color: #0f172a;
}

.table-wrapper { overflow-x: auto; }

table {
    width: 100%;
    min-width: 650px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    padding: 12px;
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: white;
    font-size: 12px;
    text-transform: uppercase;
    text-align: center;
}

td {
    padding: 12px;
    background: #ffffff;
    border-radius: 14px;
    text-align: center;
}

input {
    width: 100%;
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #d1d5db;
}

.rowTotal {
    font-weight: 600;
    color: #1e40af;
}

.summary {
    margin-top: 30px;
    padding: 22px;
    border-radius: 18px;
    background: linear-gradient(135deg, #1e3a8a, #1e40af);
    color: white;
}

.summary p {
    display: flex;
    justify-content: space-between;
    margin: 10px 0;
}

.total {
    font-size: 18px;
    font-weight: 700;
    border-top: 1px dashed rgba(255,255,255,0.4);
    padding-top: 12px;
}

button {
    margin-top: 25px;
    width: 100%;
    max-width: 360px;
    padding: 14px;
    font-size: 16px;
    font-weight: 700;
    border: none;
    border-radius: 30px;
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: white;
    cursor: pointer;
}
</style>

<script>
function calculateBill() {
    let subTotal = 0;
    let totalQty = 0;

    document.querySelectorAll(".itemRow").forEach(row => {
        let qty = parseFloat(row.querySelector(".qty").value) || 0;
        let price = parseFloat(row.querySelector(".price").value) || 0;
        let total = qty * price;

        row.querySelector(".rowTotal").innerText = total.toFixed(2);
        subTotal += total;
        totalQty += qty;
    });

    let gstPercent = parseFloat(document.getElementById("gstPercent").value) || 0;
    let gstAmount = subTotal * gstPercent / 100;

    let loading = document.getElementById("loadingFlag").checked ? totalQty * 3 : 0;
    let discount = parseFloat(document.getElementById("discount").value) || 0;
    let transport = parseFloat(document.getElementById("transport").value) || 0;

    let grandTotal = subTotal + gstAmount + loading + transport - discount;

    document.getElementById("subTotalText").innerText = subTotal.toFixed(2);
    document.getElementById("gstAmountText").innerText = gstAmount.toFixed(2);
    document.getElementById("loadingText").innerText = loading.toFixed(2);
    document.getElementById("grandTotalText").innerText = grandTotal.toFixed(2);
}
</script>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
<h2>✏️ Edit Bill</h2>

<form action="updateBill" method="post">

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
    <td><input class="qty" name="quantity[]" value="<%= row.get("quantity") %>" oninput="calculateBill()" required></td>
    <td><input class="price" name="price[]" value="<%= row.get("price") %>" oninput="calculateBill()" required></td>
    <td>₹ <span class="rowTotal">0.00</span></td>
</tr>
<%
    }
}
%>
</table>
</div>

<br>

<label>GST %</label>
<input type="number" id="gstPercent" name="gstPercent" value="${gstPercent}" oninput="calculateBill()">

<br><br>
<label>
<input type="checkbox" id="loadingFlag" onchange="calculateBill()"
<%= Boolean.TRUE.equals(request.getAttribute("loadingFlag")) ? "checked" : "" %>>
 Loading & Unloading (₹3 / Sq.Ft)
</label>

<br><br>
<label>Discount</label>
<input type="number" id="discount" name="discount" value="${discount}" oninput="calculateBill()">

<label>Transport</label>
<input type="number" id="transport" name="transport" value="${transport}" oninput="calculateBill()">

<div class="summary">
<p><span>Sub Total</span><span>₹ <span id="subTotalText">0.00</span></span></p>
<p><span>GST Amount</span><span>₹ <span id="gstAmountText">0.00</span></span></p>
<p><span>Loading</span><span>₹ <span id="loadingText">0.00</span></span></p>
<p class="total"><span>Grand Total</span><span>₹ <span id="grandTotalText">0.00</span></span></p>
</div>

<button type="submit">Update Bill</button>

</form>
</div>

<script>calculateBill();</script>

</body>
</html>
