<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>All Bills</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/mobile.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/viewBills.css">
</head>

<body data-context-path="<%= request.getContextPath() %>">

<jsp:include page="navbar.jsp"/>

<div class="container">
    <div class="top-bar">
        <h2>Bills List</h2>

        <div>
            <a class="btn dashboard" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a class="btn newbill" href="<%= request.getContextPath() %>/billing.jsp">New Bill</a>
        </div>
    </div>

    <div class="search-box">
        <form method="get" action="<%= request.getContextPath() %>/viewBills">
            <input type="number" name="billId" placeholder="Bill ID"
                   value="<%= request.getParameter("billId") != null ? request.getParameter("billId") : "" %>">

            <input type="number" step="0.01" name="amount" placeholder="Amount >="
                   value="<%= request.getParameter("amount") != null ? request.getParameter("amount") : "" %>">

            <button type="submit">Search</button>
            <a href="<%= request.getContextPath() %>/viewBills">Reset</a>
        </form>
    </div>

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
            <td>Rs <%= bill.get("grandTotal") %></td>
            <td>
                <div class="actions">
                    <a class="action view"
                       href="<%= request.getContextPath() %>/viewBillDetails?billId=<%= bill.get("billId") %>">View</a>

                    <a class="action invoice"
                       href="<%= request.getContextPath() %>/invoice?id=<%= bill.get("billId") %>">Invoice</a>

                    <a class="action edit"
                       href="<%= request.getContextPath() %>/editBill?billId=<%= bill.get("billId") %>">Edit</a>

                    <button
                        type="button"
                        class="action delete action-button"
                        data-bill-id="<%= bill.get("billId") %>">Delete Bill</button>
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

<div id="billDeleteModal" class="modal-backdrop">
    <div class="modal-card">
        <h3>Delete Bill</h3>
        <p>Are you sure you want to permanently delete this bill?</p>

        <button class="modal-danger" id="confirmBillDeleteButton" type="button">Delete Bill</button>
        <button class="modal-secondary" id="cancelBillDeleteButton" type="button">Cancel</button>
    </div>
</div>

<script>
let deleteBillId = null;

function getContextPath() {
    return document.body.dataset.contextPath || "";
}

function openBillDeleteModal(id) {
    deleteBillId = id;
    document.getElementById("billDeleteModal").classList.add("show");
}

function closeBillDeleteModal() {
    document.getElementById("billDeleteModal").classList.remove("show");
}

function confirmBillDelete() {
    if (deleteBillId == null) {
        return;
    }
    window.location.href = getContextPath() + "/deleteBill?billId=" + deleteBillId;
}

document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", (event) => {
        const deleteLink = event.target.closest("[data-bill-id]");
        if (deleteLink) {
            event.preventDefault();
            openBillDeleteModal(deleteLink.dataset.billId);
        }

        if (event.target.id === "confirmBillDeleteButton") {
            confirmBillDelete();
        }

        if (event.target.id === "cancelBillDeleteButton") {
            closeBillDeleteModal();
        }
    });
});
</script>
</body>
</html>
