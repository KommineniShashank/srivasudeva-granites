<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
</head>

<body>

<div class="login-box">
    <h2>Srivasudeva Granites<br>and Tiles</h2>

    <form action="login" method="post">
        <input type="text"
               name="username"
               placeholder="Username"
               inputmode="text"
               autocomplete="username"
               required>

        <input type="password"
               name="password"
               placeholder="Password"
               autocomplete="current-password"
               required>

        <button type="submit">Login</button>
    </form>

    <% if (request.getParameter("error") != null) { %>
        <div class="error">Invalid username or password</div>
    <% } %>
</div>

</body>
</html>
