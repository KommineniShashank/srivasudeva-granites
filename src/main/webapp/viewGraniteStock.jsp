<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Granite Stock</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/viewGraniteStock.css">
</head>

<body data-context-path="<%= request.getContextPath() %>">

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Granite Stock</h2>

    <div class="table-wrapper">
        <table>
            <tr>
                <th>Granite Name</th>
                <th>Unit</th>
                <th>Available Stock</th>
                <th>Action</th>
            </tr>

            <%
                List<Map<String, Object>> graniteList =
                    (List<Map<String, Object>>) request.getAttribute("graniteList");

                if (graniteList != null && !graniteList.isEmpty()) {
                    for (Map<String, Object> g : graniteList) {
            %>
            <tr>
                <td><%= g.get("graniteName") %></td>
                <td><%= g.get("unit") %></td>
                <td><%= g.get("stock") %></td>
                <td>
                    <div class="actions">
                        <button
                            type="button"
                            class="action delete action-button"
                            data-granite-name="<%= g.get("graniteName") %>">
                            Delete Stock
                        </button>
                    </div>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="4" class="empty">No granite stock found</td>
            </tr>
            <% } %>
        </table>
    </div>
</div>

<form id="deleteStockForm" action="<%= request.getContextPath() %>/deleteGraniteStock" method="post">
    <input type="hidden" id="deleteStockGraniteName" name="graniteName">
</form>

<div id="stockDeleteModal" class="modal-backdrop">
    <div class="modal-card">
        <h3>Delete Stock</h3>
        <p>Are you sure you want to permanently delete this stock?</p>

        <button class="modal-danger" id="confirmStockDeleteButton" type="button">Delete Stock</button>
        <button class="modal-secondary" id="cancelStockDeleteButton" type="button">Cancel</button>
    </div>
</div>

<script>
let selectedGraniteName = "";

function getContextPath() {
    return document.body.dataset.contextPath || "";
}

function openStockDeleteModal(graniteName) {
    selectedGraniteName = graniteName || "";
    document.getElementById("stockDeleteModal").classList.add("show");
}

function closeStockDeleteModal() {
    document.getElementById("stockDeleteModal").classList.remove("show");
}

function confirmStockDelete() {
    if (selectedGraniteName) {
        document.getElementById("deleteStockGraniteName").value = selectedGraniteName;
        document.getElementById("deleteStockForm").submit();
    }
}

document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", (event) => {
        const deleteButton = event.target.closest("[data-granite-name]");
        if (deleteButton) {
            event.preventDefault();
            openStockDeleteModal(deleteButton.dataset.graniteName);
        }

        if (event.target.id === "confirmStockDeleteButton") {
            confirmStockDelete();
        }

        if (event.target.id === "cancelStockDeleteButton") {
            closeStockDeleteModal();
        }
    });
});
</script>
</body>
</html>
