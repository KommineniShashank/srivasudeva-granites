<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Granite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/addGranite.css">
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Add Granite</h2>

    <form action="<%= request.getContextPath() %>/addGranite" method="post">
        <label>Granite Name</label>
        <input type="text"
               name="graniteName"
               placeholder="Eg: Black Galaxy"
               required>

        <label>Unit</label>
        <select name="unit" required>
            <option value="sqft">Sq Ft</option>
            <option value="ton">Ton</option>
            <option value="slab">Slab</option>
        </select>

        <label>Opening Stock</label>
        <input type="number"
               step="0.01"
               min="0"
               name="openingStock"
               value="0"
               required>

        <button type="submit">Save Granite</button>
    </form>
</div>

</body>
</html>
