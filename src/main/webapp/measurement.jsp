<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Granite Measurement Calculator</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/measurement.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
</head>

<body data-context-path="<%= request.getContextPath() %>">

<jsp:include page="navbar.jsp"/>

<div class="container">
    <h2>Granite Measurement Calculator</h2>

    <div class="slab-input">
        <input type="number" id="slabCount" placeholder="Number of slabs">
        <button type="button" class="btn generate" id="generateRowsButton">Generate</button>
        <button type="button" class="btn pdf" id="downloadPdfButton">Download PDF</button>
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

    <div class="actions">
        <button type="button" class="add-btn" id="addToBillButton">Add to Bill</button>
    </div>
</div>

<script>
function getContextPath() {
    return document.body.dataset.contextPath || "";
}

function generateRows() {
    const count = parseInt(document.getElementById("slabCount").value, 10);
    const tbody = document.getElementById("slabBody");
    tbody.innerHTML = "";

    if (!count || count <= 0) {
        alert("Enter number of slabs");
        return;
    }

    for (let i = 1; i <= count; i += 1) {
        tbody.innerHTML +=
            "<tr>" +
            "<td>" + i + "</td>" +
            "<td><input type=\"number\" class=\"dimension-input\"></td>" +
            "<td><input type=\"number\" class=\"dimension-input\"></td>" +
            "<td class=\"sqft\">0.00</td>" +
            "</tr>";
    }
}

function calculate() {
    let total = 0;
    document.querySelectorAll("#slabBody tr").forEach((row) => {
        const length = parseFloat(row.children[1].children[0].value) || 0;
        const width = parseFloat(row.children[2].children[0].value) || 0;
        const sqft = (length * width) / 144;
        row.children[3].innerText = sqft.toFixed(2);
        total += sqft;
    });
    document.getElementById("totalSqft").innerText = total.toFixed(2);
}

function addToBill() {
    const qty = parseFloat(document.getElementById("totalSqft").innerText) || 0;
    if (qty <= 0) {
        alert("Calculate measurement first");
        return;
    }
    window.location.href = getContextPath() + "/billing.jsp?qty=" + encodeURIComponent(qty.toFixed(2));
}

function generatePdf() {
    const totalSqft = parseFloat(document.getElementById("totalSqft").innerText) || 0;
    if (totalSqft <= 0) {
        alert("Calculate measurement first");
        return;
    }
    html2pdf().from(document.querySelector(".container")).save("Granite_Measurement.pdf");
}

window.generateRows = generateRows;
window.calculate = calculate;
window.addToBill = addToBill;
window.generatePdf = generatePdf;

document.addEventListener("DOMContentLoaded", () => {
    const slabBody = document.getElementById("slabBody");
    const generateButton = document.getElementById("generateRowsButton");
    const pdfButton = document.getElementById("downloadPdfButton");
    const addToBillButton = document.getElementById("addToBillButton");

    if (slabBody) {
        slabBody.addEventListener("input", (event) => {
            if (event.target.matches(".dimension-input")) {
                calculate();
            }
        });
    }

    if (generateButton) {
        generateButton.addEventListener("click", generateRows);
    }

    if (pdfButton) {
        pdfButton.addEventListener("click", generatePdf);
    }

    if (addToBillButton) {
        addToBillButton.addEventListener("click", addToBill);
    }
});
</script>
</body>
</html>
