<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String qtyParam = request.getParameter("qty");
%>
<!DOCTYPE html>
<html>
<head>
<title>Granite Billing</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/mobile.css">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    min-height: 100vh;
    margin: 0;
}

.container {
    width: 95%;
    max-width: 1300px;
    margin: 30px auto;
    padding: 30px;
    border-radius: 22px;
    background: rgba(255,255,255,0.95);
    backdrop-filter: blur(16px);
    box-shadow: 0 30px 70px rgba(0,0,0,0.4);
}

h2 {
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #0f172a;
}

/* ===== NORMAL INPUTS ===== */
input[type="date"],
input[type="number"] {
    width: 100%;
    padding: 14px;
    border-radius: 12px;
    border: 1px solid #d1d5db;
    background: #f9fafb;
    font-size: 14px;
}

input:focus {
    outline: none;
    background: #ffffff;
    border-color: #6366f1;
    box-shadow: 0 12px 30px rgba(99,102,241,0.3);
}
label {
    display: block;
    margin: 14px 0 6px;
    font-weight: 600;
    color: #0f172a;
}

.add:hover {
    opacity: 0.9;
    transform: translateY(-1px);
}

.remove:hover,
.add-row:hover {
    opacity: 0.9;
}

table tr:hover td {
    box-shadow: 0 18px 40px rgba(0,0,0,0.12);
    transition: 0.2s;
}


/* ===== TABLE ===== */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 620px;
    margin-top: 20px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    padding: 12px;
    font-size: 12px;
    text-transform: uppercase;
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: #ffffff;
    text-align: center;
}

td {
    padding: 14px;
    background: #ffffff;
    border-radius: 18px;
    text-align: center;
    box-shadow: 0 15px 35px rgba(0,0,0,0.08);
}

/* ===== UNDERLINE INPUT STYLE ===== */
td input {
    width: 100%;
    height: 38px;
    border: none;
    border-bottom: 2px solid #c7d2fe;
    background: transparent;
    outline: none;
    font-size: 15px;
    font-weight: 500;
    color: #0f172a;
    padding: 4px 6px;
    text-align: center;
    transition: all 0.25s ease;
}

td input[name="graniteName[]"] {
    text-align: left;
}

td input:focus {
    border-bottom: 2px solid #6366f1;
    box-shadow: 0 2px 0 rgba(99,102,241,0.35);
}

.rowTotal {
    font-weight: 600;
    color: #1e40af;
}

/* ===== BUTTONS ===== */
button {
    border: none;
    border-radius: 12px;
    cursor: pointer;
}

.add {
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: #ffffff;
    padding: 14px;
    font-size: 16px;
    font-weight: 600;
    width: 100%;
}

.remove {
    background: linear-gradient(135deg, #dc2626, #f87171);
    color: #ffffff;
    padding: 8px 12px;
    font-weight: 600;
}

.row-actions {
    margin-top: 20px;
    text-align: right;
}

.add-row {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    color: #ffffff;
    padding: 12px 24px;
    font-size: 14px;
    font-weight: 600;
    border-radius: 14px;
}

/* ===== SUMMARY ===== */
.summary {
    margin-top: 30px;
    padding: 24px;
    border-radius: 20px;
    background: linear-gradient(135deg, #1e3a8a, #1e40af);
    color: #ffffff;
}

.summary p {
    display: flex;
    justify-content: space-between;
    margin: 12px 0;
}

.total {
    font-size: 18px;
    font-weight: 700;
    border-top: 1px dashed rgba(255,255,255,0.4);
    padding-top: 14px;
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
        row.querySelector(".rowTotalInput").value = total.toFixed(2);

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
    document.getElementById("grandTotal").value = grandTotal.toFixed(2);
}

function addRow() {
    const table = document.querySelector("table");
    const firstRow = document.querySelector(".itemRow");
    const newRow = firstRow.cloneNode(true);

    newRow.querySelector(".qty").value = "";
    newRow.querySelector(".price").value = "";
    newRow.querySelector(".rowTotal").innerText = "0.00";
    newRow.querySelector(".rowTotalInput").value = "";

    table.appendChild(newRow);
    calculateBill();
}
</script>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
<h2>🧾 Sri Vasudeva Granites</h2>

<form action="saveBill" method="post">

<label>Bill Date</label>
<input type="date" name="billDate" required>

<div class="table-wrapper">
<table>
<tr>
<th>Granite</th>
<th>Qty</th>
<th>Price</th>
<th>Total</th>
<th>Action</th>
</tr>

<tr class="itemRow">
<td><input name="graniteName[]" required></td>

<td>
<input class="qty" name="quantity[]" value="<%= qtyParam != null ? qtyParam : "" %>" oninput="calculateBill()" required>
</td>

<td>
<input class="price" name="price[]" oninput="calculateBill()" required>
</td>

<td>
<span class="rowTotal">0.00</span>
<input type="hidden" class="rowTotalInput" name="rowTotal[]">
</td>

<td>
<button type="button" class="remove" onclick="this.closest('tr').remove();calculateBill()">X</button>
</td>
</tr>
</table>
</div>

<div class="row-actions">
<button type="button" class="add-row" onclick="addRow()">＋ Add Row</button>
</div>

<br>

<label>GST %</label>
<input type="number" id="gstPercent" name="gstPercent" oninput="calculateBill()" value="0">

<br><br>
<label>
<input type="checkbox" id="loadingFlag" name="loadingFlag" onchange="calculateBill()">
Loading & Unloading (₹3 / Sq.Ft)
</label>

<br><br>
<label>Discount</label>
<input type="number" id="discount" name="discount" oninput="calculateBill()">

<label>Transport</label>
<input type="number" id="transport" name="transport" oninput="calculateBill()">

<div class="summary">
<p><span>Sub Total</span><span>₹ <span id="subTotalText">0.00</span></span></p>
<p><span>GST Amount</span><span>₹ <span id="gstAmountText">0.00</span></span></p>
<p><span>Loading</span><span>₹ <span id="loadingText">0.00</span></span></p>
<p class="total"><span>Grand Total</span><span>₹ <span id="grandTotalText">0.00</span></span></p>
</div>

<input type="hidden" id="grandTotal" name="grandTotal">

<br>
<button class="add">💾 Save Bill</button>

</form>
</div>

<script>
calculateBill();
</script>
<script>
document.querySelector("form").addEventListener("submit", function () {
    const btn = document.querySelector(".add");
    btn.disabled = true;
    btn.innerText = "Saving...";
});
</script>


</body>
</html>
