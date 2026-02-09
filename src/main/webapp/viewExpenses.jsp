<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Expenses</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

/* MAIN CONTAINER */
.container {
    width: 94%;
    max-width: 1300px;
    margin: 30px auto 80px;
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 28px;
    border-radius: 22px;
    box-shadow: 0 30px 70px rgba(0,0,0,0.4);
}

/* TOP BAR */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 22px;
    gap: 12px;
    flex-wrap: wrap;
}

h2 {
    font-size: 26px;
    font-weight: 700;
    color: #0f172a;
}

/* BUTTONS */
.btn {
    padding: 12px 22px;
    border-radius: 30px;
    color: white;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    display: inline-block;
    transition: all 0.3s ease;
    text-align: center;
}

.add {
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    box-shadow: 0 18px 35px rgba(79,70,229,0.45);
}

.export {
    background: linear-gradient(135deg, #16a34a, #22c55e);
    box-shadow: 0 18px 35px rgba(34,197,94,0.45);
}

.btn:hover {
    transform: translateY(-2px) scale(1.05);
}

/* TABLE WRAPPER */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

/* TABLE */
table {
    width: 100%;
    min-width: 600px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    padding: 14px;
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: white;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1px;
    text-align: center;
}

td {
    padding: 14px;
    background: #ffffff;
    text-align: center;
    border-radius: 14px;
    font-size: 14px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.1);
}

tr:hover td {
    background: #f8fafc;
}

/* ACTION BUTTONS */
.actions {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 6px;
}

.action {
    padding: 10px 16px;
    border-radius: 20px;
    color: white;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.25s ease;
}

.edit {
    background: linear-gradient(135deg, #f59e0b, #fbbf24);
}

.delete {
    background: linear-gradient(135deg, #dc2626, #ef4444);
}

.action:hover {
    transform: scale(1.08);
}

/* TOTAL BOX */
.total-box {
    text-align: right;
    font-size: 20px;
    margin-top: 22px;
    font-weight: 700;
    color: #dc2626;
}

/* EMPTY STATE */
td[colspan] {
    font-weight: 600;
    color: #475569;
}

/* ================= MOBILE ================= */
@media (max-width: 768px) {

    h2 {
        font-size: 22px;
    }

    .btn {
        width: 100%;
    }

    .total-box {
        text-align: left;
        font-size: 18px;
    }

    table {
        min-width: 520px;
    }

    .actions {
        flex-direction: column;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">

    <div class="top-bar">
        <h2>💸 Expense List</h2>

        <div style="display:flex; gap:10px; flex-wrap:wrap;">
            <a class="btn add" href="<%= request.getContextPath() %>/addExpense.jsp">➕ Add Expense</a>
            <a class="btn export" href="<%= request.getContextPath() %>/exportExpensesExcel">📥 Export Excel</a>
        </div>
    </div>

    <div class="table-wrapper">
        <table>
            <tr>
                <th>Date</th>
                <th>Category</th>
                <th>Description</th>
                <th>Amount (₹)</th>
                <th>Actions</th>
            </tr>

            <%
                List<Map<String, Object>> expenses =
                        (List<Map<String, Object>>) request.getAttribute("expenses");

                if (expenses != null && !expenses.isEmpty()) {
                    for (Map<String, Object> row : expenses) {
            %>
            <tr>
                <td><%= row.get("date") %></td>
                <td><%= row.get("category") %></td>
                <td><%= row.get("description") %></td>
                <td>₹ <%= row.get("amount") %></td>
                <td>
                    <div class="actions">
                        <a class="action edit"
                           href="<%= request.getContextPath() %>/editExpense.jsp?id=<%= row.get("id") %>&date=<%= row.get("date") %>&category=<%= row.get("category") %>&amount=<%= row.get("amount") %>&remark=<%= row.get("description") %>">
                            Edit
                        </a>

<a class="action delete"
   href="javascript:void(0)"
   onclick="openExpenseDeleteModal(<%= row.get("id") %>)">
   Delete
</a>


                    </div>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5">No expenses recorded</td>
            </tr>
            <% } %>
        </table>
    </div>

    <div class="total-box">
        Total Expense: ₹ <%= request.getAttribute("totalExpense") %>
    </div>

</div>
<div id="expenseDeleteModal" style="display:none; position:fixed; inset:0;
background:rgba(0,0,0,0.6); align-items:center; justify-content:center; z-index:9999;">

  <div style="background:white; padding:24px; border-radius:16px;
  width:320px; text-align:center;">
    <h3>Delete Expense</h3>
    <p>Are you sure you want to delete this expense?</p>

    <button onclick="confirmExpenseDelete()"
      style="background:#dc2626;color:white;padding:10px 18px;
      border:none;border-radius:8px;">Yes, Delete</button>

    <button onclick="closeExpenseDeleteModal()"
      style="margin-left:10px;padding:10px 18px;">Cancel</button>
  </div>
</div>
<script>
let deleteExpenseId = null;

function openExpenseDeleteModal(id) {
    deleteExpenseId = id;
    document.getElementById("expenseDeleteModal").style.display = "flex";
}

function closeExpenseDeleteModal() {
    document.getElementById("expenseDeleteModal").style.display = "none";
}

function confirmExpenseDelete() {
    window.location.href =
      "<%= request.getContextPath() %>/deleteExpense?id=" + deleteExpenseId;
}
</script>


</body>
</html>
