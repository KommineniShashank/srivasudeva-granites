<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Expenses</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/viewExpenses.css">
</head>

<body data-context-path="<%= request.getContextPath() %>">

<jsp:include page="navbar.jsp"/>

<div class="container">
    <div class="top-bar">
        <h2>Expense List</h2>

        <div class="button-group">
            <a class="btn add" href="<%= request.getContextPath() %>/addExpense.jsp">Add Expense</a>
            <a class="btn export" href="<%= request.getContextPath() %>/exportExpensesExcel">Export Excel</a>
        </div>
    </div>

    <div class="table-wrapper">
        <table>
            <tr>
                <th>Date</th>
                <th>Category</th>
                <th>Description</th>
                <th>Amount (Rs)</th>
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
                <td>Rs <%= row.get("amount") %></td>
                <td>
                    <div class="actions">
                        <a class="action edit"
                           href="<%= request.getContextPath() %>/editExpense.jsp?id=<%= row.get("id") %>&date=<%= row.get("date") %>&category=<%= row.get("category") %>&amount=<%= row.get("amount") %>&remark=<%= row.get("description") %>">
                            Edit
                        </a>

                        <button
                            type="button"
                            class="action delete action-button"
                            data-expense-id="<%= row.get("id") %>">
                            Delete Expense
                        </button>
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
        Total Expense: Rs <%= request.getAttribute("totalExpense") %>
    </div>

</div>

<div id="expenseDeleteModal" class="modal-backdrop">
    <div class="modal-card">
        <h3>Delete Expense</h3>
        <p>Are you sure you want to permanently delete this expense?</p>

        <button class="modal-danger" id="confirmExpenseDeleteButton" type="button">Delete Expense</button>
        <button class="modal-secondary" id="cancelExpenseDeleteButton" type="button">Cancel</button>
    </div>
</div>

<script>
let deleteExpenseId = null;

function getContextPath() {
    return document.body.dataset.contextPath || "";
}

function openExpenseDeleteModal(id) {
    deleteExpenseId = id;
    document.getElementById("expenseDeleteModal").classList.add("show");
}

function closeExpenseDeleteModal() {
    document.getElementById("expenseDeleteModal").classList.remove("show");
}

function confirmExpenseDelete() {
    if (deleteExpenseId == null) {
        return;
    }
    window.location.href = getContextPath() + "/deleteExpense?id=" + deleteExpenseId;
}

window.openExpenseDeleteModal = openExpenseDeleteModal;
window.closeExpenseDeleteModal = closeExpenseDeleteModal;
window.confirmExpenseDelete = confirmExpenseDelete;

document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", (event) => {
        const deleteLink = event.target.closest("[data-expense-id]");
        if (deleteLink) {
            event.preventDefault();
            openExpenseDeleteModal(deleteLink.dataset.expenseId);
        }

        if (event.target.id === "confirmExpenseDeleteButton") {
            confirmExpenseDelete();
        }

        if (event.target.id === "cancelExpenseDeleteButton") {
            closeExpenseDeleteModal();
        }
    });
});
</script>
</body>
</html>
