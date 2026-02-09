<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Granite Stock</title>

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
    max-width: 1200px;
    margin: 30px auto 80px;
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 28px;
    border-radius: 22px;
    box-shadow: 0 30px 70px rgba(0,0,0,0.4);
}

/* TITLE */
h2 {
    margin-bottom: 22px;
    font-size: 26px;
    font-weight: 700;
    color: #0f172a;
}

/* TABLE WRAPPER */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

/* TABLE */
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
    letter-spacing: 1px;
    text-transform: uppercase;
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

/* DELETE BUTTON */
.delete-btn {
    padding: 12px 20px;
    background: linear-gradient(135deg, #dc2626, #ef4444);
    color: white;
    border: none;
    border-radius: 26px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    box-shadow: 0 12px 25px rgba(220,38,38,0.45);
    transition: all 0.25s ease;
}

.delete-btn:hover {
    transform: translateY(-2px) scale(1.05);
    box-shadow: 0 20px 40px rgba(239,68,68,0.6);
}

/* EMPTY STATE */
.empty {
    text-align: center;
    font-weight: 600;
    color: #64748b;
    background: #f8fafc;
    border-radius: 14px;
}

/* MOBILE */
@media (max-width: 768px) {
    h2 {
        font-size: 22px;
    }

    table {
        min-width: 480px;
    }

    td, th {
        font-size: 13px;
        padding: 12px;
    }

    .delete-btn {
        width: 100%;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>📦 Granite Stock</h2>

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
                    <form action="deleteGraniteStock" method="post"
                          onsubmit="return confirm('Are you sure you want to delete this granite stock?');">
                        <input type="hidden" name="graniteName"
                               value="<%= g.get("graniteName") %>">
                        <button type="submit" class="delete-btn">🗑 Delete</button>
                    </form>
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

</body>
</html>
