<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.granite.util.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%!
    private String escapeJs(String value) {
        if (value == null) {
            return "";
        }
        return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "\\r")
            .replace("\n", "\\n");
    }
%>
<%
    String qtyParam = request.getParameter("qty");
    List<Map<String, Object>> graniteOptions = new ArrayList<>();

    try (Connection con = DBUtil.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT names.granite_name, " +
             "COALESCE(gm.purchase_price, latest_prices.price, 0) AS price " +
             "FROM (" +
             "    SELECT granite_name FROM granite_master " +
             "    UNION " +
             "    SELECT granite_name FROM granite_stock " +
             "    UNION " +
             "    SELECT granite_name FROM bill_details" +
             ") names " +
             "LEFT JOIN granite_master gm ON gm.granite_name = names.granite_name " +
             "LEFT JOIN (" +
             "    SELECT bd.granite_name, bd.price " +
             "    FROM bill_details bd " +
             "    INNER JOIN (" +
             "        SELECT granite_name, MAX(detail_id) AS max_detail_id " +
             "        FROM bill_details " +
             "        GROUP BY granite_name" +
             "    ) recent ON recent.max_detail_id = bd.detail_id" +
             ") latest_prices ON latest_prices.granite_name = names.granite_name " +
             "WHERE names.granite_name IS NOT NULL AND TRIM(names.granite_name) <> '' " +
             "ORDER BY names.granite_name");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> granite = new HashMap<>();
            granite.put("name", rs.getString("granite_name"));
            granite.put("price", rs.getDouble("price"));
            graniteOptions.add(granite);
        }
    } catch (Exception e) {
        throw new RuntimeException("Failed to load granite options", e);
    }

    StringBuilder graniteOptionsJson = new StringBuilder("[");
    for (int i = 0; i < graniteOptions.size(); i++) {
        Map<String, Object> granite = graniteOptions.get(i);
        if (i > 0) {
            graniteOptionsJson.append(",");
        }
        graniteOptionsJson.append("{\"name\":\"")
            .append(escapeJs((String) granite.get("name")))
            .append("\",\"price\":")
            .append(granite.get("price"))
            .append("}");
    }
    graniteOptionsJson.append("]");
%>
<!DOCTYPE html>
<html>
<head>
<title>Granite Billing</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/mobile.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/billing.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
<h2>Sri Vasudeva Granites</h2>

<form action="<%= request.getContextPath() %>/saveBill" method="post">

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
<td>
<div class="granite-selector">
<input type="text" name="graniteName[]" class="granite-name" placeholder="Enter granite name" autocomplete="off" required>
</div>
</td>

<td>
<input class="qty" name="quantity[]" value="<%= qtyParam != null ? qtyParam : "" %>" required>
</td>

<td>
<input class="price" name="price[]" placeholder="Enter price" required>
</td>

<td>
<span class="rowTotal">0.00</span>
<input type="hidden" class="rowTotalInput" name="rowTotal[]">
</td>

<td>
<button type="button" class="remove remove-row">X</button>
</td>
</tr>
</table>
</div>

<div class="row-actions">
<button type="button" class="add-row">Add Row</button>
</div>

<br>

<label>GST %</label>
<input type="number" id="gstPercent" name="gstPercent" value="0">

<br><br>
<label>
<input type="checkbox" id="loadingFlag" name="loadingFlag">
Loading and Unloading (Rs 3 / Sq.Ft)
</label>

<br><br>
<label>Discount</label>
<input type="number" id="discount" name="discount">

<label>Transport</label>
<input type="number" id="transport" name="transport">

<div class="summary">
<p><span>Sub Total</span><span>Rs <span id="subTotalText">0.00</span></span></p>
<p><span>GST Amount</span><span>Rs <span id="gstAmountText">0.00</span></span></p>
<p><span>Loading</span><span>Rs <span id="loadingText">0.00</span></span></p>
<p class="total"><span>Grand Total</span><span>Rs <span id="grandTotalText">0.00</span></span></p>
</div>

<input type="hidden" id="grandTotal" name="grandTotal">

<br>
<button class="add">Save Bill</button>

</form>
</div>

<script>
const graniteOptions = <%= graniteOptionsJson.toString() %>;

function updateGranitePrice(row) {
    const graniteName = row.querySelector(".granite-name").value.trim().toLowerCase();
    const matchingGranite = graniteOptions.find((granite) =>
        granite.name && granite.name.trim().toLowerCase() === graniteName
    );

    row.querySelector(".price").value = matchingGranite
        ? Number(matchingGranite.price || 0).toFixed(2)
        : "";
    calculateBill();
}

function resetRow(row) {
    row.querySelector(".granite-name").value = "";
    row.querySelector(".qty").value = "";
    row.querySelector(".price").value = "";
    row.querySelector(".rowTotal").innerText = "0.00";
    row.querySelector(".rowTotalInput").value = "";
}

function calculateBill() {
    let subTotal = 0;
    let totalQty = 0;

    document.querySelectorAll(".itemRow").forEach((row) => {
        const qty = parseFloat(row.querySelector(".qty").value) || 0;
        const price = parseFloat(row.querySelector(".price").value) || 0;
        const total = qty * price;

        row.querySelector(".rowTotal").innerText = total.toFixed(2);
        row.querySelector(".rowTotalInput").value = total.toFixed(2);

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
    document.getElementById("grandTotal").value = grandTotal.toFixed(2);
}

function addRow() {
    const table = document.querySelector("table");
    const firstRow = document.querySelector(".itemRow");
    const newRow = firstRow.cloneNode(true);

    resetRow(newRow);

    table.appendChild(newRow);
    calculateBill();
}

window.calculateBill = calculateBill;
window.addRow = addRow;

document.addEventListener("DOMContentLoaded", () => {
    calculateBill();

    document.addEventListener("input", (event) => {
        if (
            event.target.matches(".granite-name") ||
            event.target.matches(".qty") ||
            event.target.matches(".price") ||
            event.target.matches("#gstPercent") ||
            event.target.matches("#discount") ||
            event.target.matches("#transport")
        ) {
            if (event.target.matches(".granite-name")) {
                const row = event.target.closest(".itemRow");
                row.querySelector(".rowTotal").innerText = "0.00";
                row.querySelector(".rowTotalInput").value = "";
                updateGranitePrice(row);
            }
            calculateBill();
        }
    });

    document.addEventListener("change", (event) => {
        if (event.target.matches("#loadingFlag")) {
            calculateBill();
        }
    });

    document.addEventListener("click", (event) => {
        if (event.target.matches(".add-row")) {
            addRow();
        }

        if (event.target.matches(".remove-row")) {
            event.target.closest("tr").remove();
            calculateBill();
            return;
        }
    });

    const form = document.querySelector("form");
    const saveButton = document.querySelector(".add");

    if (form && saveButton) {
        form.addEventListener("submit", () => {
            saveButton.disabled = true;
            saveButton.innerText = "Saving...";
        });
    }
});
</script>
</body>
</html>
