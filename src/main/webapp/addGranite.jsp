<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Granite</title>

    <style>
        body {
            font-family: Segoe UI, Arial;
            background: #f4f6f9;
        }
        .container {
            width: 400px;
            margin: 60px auto;
            background: white;
            padding: 25px;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        label {
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #3498db;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
        }
        button:hover {
            background: #2980b9;
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>🧱 Add Granite</h2>

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
