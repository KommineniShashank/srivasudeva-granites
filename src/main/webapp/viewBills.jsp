<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>All Bills</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/mobile.css">

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
    background: rgba(255,255,255,0.95);
    backdrop-filter: blur(16px);
    padding: 26px 28px;
    border-radius: 22px;
    box-shadow: 0 30px 70px rgba(0,0,0,0.4);
}

/* HEADER */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    gap: 12px;
    flex-wrap: wrap;
}

h2 {
    font-size: 26px;
    font-weight: 700;
    color: #0f172a;
}

/* HEADER BUTTONS */
.btn {
    padding: 12px 22px;
    border-radius: 30px;
    color: #ffffff;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    margin-left: 6px;
    display: inline-block;
    transition: all 0.3s ease;
}

.dashboard {
    background: linear-gradient(135deg, #22c55e, #16a34a);
    box-shadow: 0 20px 40px rgba(34,197,94,0.45);
}

.newbill {
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    box-shadow: 0 20px 40px rgba(79,70,229,0.45);
}

.btn:hover {
    transform: translateY(-2px) scale(1.05);
}

/* SEARCH BOX */
.search-box {
    background: linear-gradient(135deg, #f8fafc, #eef2ff);
    padding: 20px;
    border-radius: 18px;
    margin: 26px 0;
}

.search-box form {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
}

.search-box input {
    padding: 10px 14px;
    border-radius: 10px;
    border: 1px solid #d1d5db;
    font-size: 14px;
}

.search-box button {
    padding: 10px 20px;
    border-radius: 24px;
    border: none;
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: #ffffff;
    font-weight: 600;
    cursor: pointer;
}

.search-box a {
    font-size: 14px;
    font-weight: 600;
    color: #475569;
    text-decoration: none;
}

/* TABLE */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 520px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    padding: 14px;
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: #ffffff;
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
    box-shadow: 0 15px 35px rgba(0,0,0,0.08);
    font-size: 14px;
}

/* ACTION BUTTONS */
.actions {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 6px;
}

a.action {
    text-decoration: none;
    padding: 8px 14px;
    border-radius: 20px;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.25s ease;
}

.view { background: linear-gradient(135deg, #2563eb, #3b82f6); }
.invoice { background: linear-gradient(135deg, #7c3aed, #8b5cf6); }
.edit { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.delete { background: linear-gradient(135deg, #dc2626, #ef4444); }

a.action:hover {
    transform: scale(1.08);
}

/* NO DATA */
td[colspan] {
    background: #f8fafc;
    color: #475569;
    font-weight: 600;
}

/* ================= MOBILE ================= */
@media (max-width: 768px) {

    h2 {
        font-size: 22px;
    }

    .btn {
        width: 100%;
        margin-left: 0;
        text-align: center;
    }

    .search-box form {
        flex-direction: column;
        align-items: stretch;
    }

    .search-box input,
    .search-box button {
        width: 100%;
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

    <!-- HEADER -->
    <div class="top-bar">
        <h2>📋 Bills List</h2>

        <div>
            <a class="btn dashboard" href="<%= request.getContextPath() %>/dashboard">📊 Dashboard</a>
            <a class="btn newbill" href="<%= request.getContextPath() %>/billing.jsp">➕ New Bill</a>
        </div>
    </div>

    <!-- SEARCH -->
    <div class="search-box">
        <form method="get" action="<%= request.getContextPath() %>/viewBills">

            <input type="number" name="billId" placeholder="Bill ID"
                   value="<%= request.getParameter("billId") != null ? request.getParameter("billId") : "" %>">

            <input type="number" step="0.01" name="amount" placeholder="Amount ≥"
                   value="<%= request.getParameter("amount") != null ? request.getParameter("amount") : "" %>">

            <button type="submit">Search</button>
            <a href="<%= request.getContextPath() %>/viewBills">Reset</a>
        </form>
    </div>

    <!-- TABLE -->
    <div class="table-wrapper">
    <table>
        <tr>
            <th>Bill ID</th>
            <th>Date</th>
            <th>Grand Total</th>
            <th>Actions</th>
        </tr>

        <%
            List<Map<String, Object>> bills =
                    (List<Map<String, Object>>) request.getAttribute("bills");

            if (bills != null && !bills.isEmpty()) {
                for (Map<String, Object> bill : bills) {
        %>
        <tr>
            <td><%= bill.get("billId") %></td>
            <td><%= bill.get("billDate") %></td>
            <td>₹ <%= bill.get("grandTotal") %></td>
            <td>
                <div class="actions">
                    <a class="action view"
                       href="<%= request.getContextPath() %>/viewBillDetails?billId=<%= bill.get("billId") %>">View</a>

                    <a class="action invoice"
                       href="<%= request.getContextPath() %>/invoice?id=<%= bill.get("billId") %>">Invoice</a>

                    <a class="action edit"
                       href="<%= request.getContextPath() %>/editBill?billId=<%= bill.get("billId") %>">Edit</a>

                    <a class="action delete"
   href="javascript:void(0)"
   onclick="openDeleteModal(<%= bill.get("billId") %>)">Delete</a>

                </div>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="4">No bills found</td>
        </tr>
        <% } %>
    </table>
    </div>

</div>
<div id="deleteModal" style="display:none; position:fixed; inset:0;
background:rgba(0,0,0,0.6); align-items:center; justify-content:center;">

  <div style="background:white; padding:24px; border-radius:16px;
  width:320px; text-align:center;">
    <h3>Delete Bill</h3>
    <p>Are you sure you want to delete this bill?</p>

    <button onclick="confirmDelete()"
      style="background:#dc2626;color:white;padding:10px 18px;
      border:none;border-radius:8px;">Yes, Delete</button>

    <button onclick="closeDeleteModal()"
      style="margin-left:10px;padding:10px 18px;">Cancel</button>
  </div>
</div>
<script>
let deleteBillId = null;

function openDeleteModal(id) {
    deleteBillId = id;
    document.getElementById("deleteModal").style.display = "flex";
}

function closeDeleteModal() {
    document.getElementById("deleteModal").style.display = "none";
}

function confirmDelete() {
    window.location.href =
      "<%= request.getContextPath() %>/deleteBill?billId=" + deleteBillId;
}
</script>

</body>
</html>
