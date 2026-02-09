<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>

<!-- ✅ VERY IMPORTANT FOR MOBILE -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    min-height: 100vh;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
}

/* LOGIN CARD */
.login-box {
    width: 380px;
    max-width: 100%;
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 36px 34px;
    border-radius: 24px;
    box-shadow: 0 35px 80px rgba(0,0,0,0.45);
    text-align: center;
}

/* TITLE */
.login-box h2 {
    margin-bottom: 26px;
    font-size: 22px;
    font-weight: 700;
    color: #0f172a;
    line-height: 1.4;
}

/* INPUTS */
.login-box input {
    width: 100%;
    padding: 16px;
    margin: 14px 0;
    border-radius: 14px;
    border: 1px solid #d1d5db;
    font-size: 15px;
    background: #f8fafc;
    transition: all 0.25s ease;
}

.login-box input::placeholder {
    color: #9ca3af;
}

.login-box input:focus {
    outline: none;
    border-color: #2563eb;
    background: #ffffff;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.2);
}

/* BUTTON */
.login-box button {
    width: 100%;
    padding: 16px;
    margin-top: 20px;
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: white;
    border: none;
    font-size: 17px;
    font-weight: 700;
    border-radius: 40px;
    cursor: pointer;
    box-shadow: 0 18px 40px rgba(34,197,94,0.45);
    transition: all 0.3s ease;
}

.login-box button:hover {
    transform: translateY(-2px) scale(1.04);
    box-shadow: 0 28px 55px rgba(34,197,94,0.6);
}

/* ERROR */
.error {
    margin-top: 18px;
    padding: 12px;
    background: #fee2e2;
    color: #dc2626;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
}

/* MOBILE */
@media (max-width: 420px) {
    .login-box {
        padding: 28px 22px;
    }

    .login-box h2 {
        font-size: 20px;
    }
}
</style>
</head>

<body>

<div class="login-box">
    <h2>🔐 Srivasudeva Granites<br>and Tiles</h2>

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
        <div class="error">❌ Invalid username or password</div>
    <% } %>
</div>

</body>
</html>
