<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Add Expense</title>

<!-- MOBILE SUPPORT -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

/* FORM CARD */
.container {
    width: 440px;
    max-width: 94%;
    margin: 70px auto;
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px);
    padding: 34px 32px;
    border-radius: 22px;
    box-shadow: 0 30px 60px rgba(0,0,0,0.45);
}

/* TITLE */
h2 {
    text-align: center;
    margin-bottom: 28px;
    font-size: 26px;
    font-weight: 700;
    color: #0f172a;
}

/* LABEL */
label {
    font-weight: 600;
    display: block;
    margin-bottom: 6px;
    color: #1e293b;
    font-size: 14px;
}

/* INPUTS */
input, select {
    width: 100%;
    padding: 14px;
    margin-bottom: 18px;
    border-radius: 12px;
    border: 1px solid #d1d5db;
    font-size: 15px;
    background: #f8fafc;
    transition: all 0.25s ease;
}

input::placeholder {
    color: #9ca3af;
}

input:focus,
select:focus {
    outline: none;
    border-color: #6366f1;
    background: #ffffff;
    box-shadow: 0 0 0 3px rgba(99,102,241,0.18);
}

/* BUTTON */
button {
    width: 100%;
    padding: 16px;
    margin-top: 10px;
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

button:hover {
    transform: translateY(-2px) scale(1.04);
    box-shadow: 0 28px 55px rgba(34,197,94,0.6);
}

/* MOBILE */
@media (max-width: 500px) {
    .container {
        margin: 40px auto;
        padding: 28px 22px;
    }

    h2 {
        font-size: 22px;
    }
}
</style>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>💸 Add Expense</h2>

    <form action="<%= request.getContextPath() %>/addExpense" method="post">

        <!-- EXPENSE TYPE -->
        <label>Expense Type</label>
        <input type="text"
               name="expenseType"
               placeholder="Electricity, Rent, Diesel"
               required>

        <!-- AMOUNT -->
        <label>Amount</label>
        <input type="number"
               step="0.01"
               name="amount"
               placeholder="Enter amount"
               required>

        <!-- DATE -->
        <label>Expense Date</label>
        <input type="date"
               name="expenseDate"
               required>

        <!-- REMARK -->
        <label>Remark</label>
        <input type="text"
               name="remark"
               placeholder="Optional">

        <button type="submit">💾 Save Expense</button>
    </form>
</div>

</body>
</html>
