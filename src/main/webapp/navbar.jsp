<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/navbar.css">

<div class="navbar">
    <a class="brand" href="<%= request.getContextPath() %>/">
        Sri Vasudeva Granites
    </a>

    <div class="menu-toggle">Menu</div>

    <div class="nav-links" id="navLinks">
        <a href="<%= request.getContextPath() %>/billing.jsp">New Bill</a>
        <a href="<%= request.getContextPath() %>/viewBills">View Bills</a>
        <a href="<%= request.getContextPath() %>/measurement.jsp">Measurement</a>
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/viewGraniteStock">Granite Stock</a>
        <a href="<%= request.getContextPath() %>/stockInOut.jsp">Stock In / Out</a>
        <a href="<%= request.getContextPath() %>/viewExpenses">Expenses</a>
        <a href="<%= request.getContextPath() %>/profitReport">Profit Report</a>
        <a class="logout" href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<script>
function toggleMenu() {
    const navLinks = document.getElementById("navLinks");
    if (navLinks) {
        navLinks.classList.toggle("show");
    }
}

window.toggleMenu = toggleMenu;

document.addEventListener("DOMContentLoaded", () => {
    const toggle = document.querySelector(".menu-toggle");
    if (toggle) {
        toggle.addEventListener("click", toggleMenu);
    }
});
</script>
