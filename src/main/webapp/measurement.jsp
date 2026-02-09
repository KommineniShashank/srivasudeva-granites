<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Granite Measurement Calculator</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
* { box-sizing: border-box; }

body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

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

h2 {
    text-align: center;
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 28px;
}

.slab-input {
    display: flex;
    gap: 14px;
    justify-content: center;
    align-items: center;
    margin-bottom: 28px;
    padding: 18px;
    background: linear-gradient(135deg, #f8fafc, #eef2ff);
    border-radius: 18px;
    flex-wrap: wrap;
}

.slab-input input {
    width: 130px;
    padding: 12px;
    border-radius: 12px;
    border: 1px solid #d1d5db;
    text-align: center;
}

.btn {
    padding: 12px 24px;
    border-radius: 30px;
    border: none;
    font-weight: 600;
    cursor: pointer;
    color: white;
}

.generate { background: linear-gradient(135deg, #2563eb, #4f46e5); }
.pdf { background: linear-gradient(135deg, #7c3aed, #8b5cf6); }

table {
    width: 100%;
    min-width: 520px;
    border-collapse: separate;
    border-spacing: 0 14px;
}

th {
    background: linear-gradient(135deg, #0f172a, #1e293b);
    color: white;
    padding: 14px;
}

td {
    background: white;
    padding: 14px;
    text-align: center;
    border-radius: 14px;
}

input {
    width: 110px;
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #d1d5db;
    text-align: center;
}

.sqft { font-weight: 700; color: #16a34a; }

#totalSqft {
    font-size: 22px;
    color: #2563eb;
}

.add-btn {
    margin-top: 30px;
    padding: 16px 36px;
    font-size: 16px;
    background: linear-gradient(135deg, #16a34a, #22c55e);
    color: white;
    border-radius: 40px;
    border: none;
    font-weight: 700;
}
</style>

<!-- ✅ LOAD PDF LIB FIRST -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

<script>
function generateRows() {
    const count = document.getElementById("slabCount").value;
    const tbody = document.getElementById("slabBody");
    tbody.innerHTML = "";

    if (!count || count <= 0) {
        alert("Enter number of slabs");
        return;
    }

    for (let i = 1; i <= count; i++) {
        tbody.innerHTML += `
        <tr>
            <td>${i}</td>
            <td><input type="number" oninput="calculate()"></td>
            <td><input type="number" oninput="calculate()"></td>
            <td class="sqft">0.00</td>
        </tr>`;
    }
}

function calculate() {
    let total = 0;
    document.querySelectorAll("#slabBody tr").forEach(row => {
        const l = parseFloat(row.children[1].children[0].value) || 0;
        const w = parseFloat(row.children[2].children[0].value) || 0;
        const sqft = (l * w) / 144;
        row.children[3].innerText = sqft.toFixed(2);
        total += sqft;
    });
    document.getElementById("totalSqft").innerText = total.toFixed(2);
}

function addToBill() {
    const qty = document.getElementById("totalSqft").innerText;
    if (qty <= 0) {
        alert("Calculate measurement first");
        return;
    }
    window.location.href = "billing.jsp?qty=" + encodeURIComponent(qty);
}

function generatePdf() {
    const totalSqft = document.getElementById("totalSqft").innerText;

    if (totalSqft <= 0) {
        alert("Calculate measurement first");
        return;
    }

    html2pdf().from(document.querySelector(".container")).save("Granite_Measurement.pdf");
}
</script>
</head>

<body>

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>🧮 Granite Measurement Calculator</h2>

    <div class="slab-input">
        <input type="number" id="slabCount" placeholder="Number of slabs">
        <button class="btn generate" onclick="generateRows()">Generate</button>
        <button class="btn pdf" onclick="generatePdf()">📄 Download PDF</button>
    </div>

    <table>
        <thead>
            <tr>
                <th>Slab</th>
                <th>Length (in)</th>
                <th>Width (in)</th>
                <th>Sq.Ft</th>
            </tr>
        </thead>
        <tbody id="slabBody"></tbody>
        <tfoot>
            <tr>
                <td colspan="3">TOTAL SQ.FT</td>
                <td id="totalSqft">0.00</td>
            </tr>
        </tfoot>
    </table>

    <div style="text-align:center;">
        <button class="add-btn" onclick="addToBill()">➕ Add to Bill</button>
    </div>
</div>

</body>
</html>
