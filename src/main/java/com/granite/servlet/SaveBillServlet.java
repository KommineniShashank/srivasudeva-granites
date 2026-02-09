package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/saveBill")
public class SaveBillServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billDate = request.getParameter("billDate");

        String[] graniteNames = request.getParameterValues("graniteName[]");
        String[] quantities   = request.getParameterValues("quantity[]");
        String[] prices       = request.getParameterValues("price[]");
        String[] rowTotals    = request.getParameterValues("rowTotal[]");

        double discount   = parseDouble(request.getParameter("discount"));
        double transport  = parseDouble(request.getParameter("transport"));
        double gstPercent = parseDouble(request.getParameter("gstPercent"));

        boolean loadingEnabled = request.getParameter("loadingFlag") != null;

        if (billDate == null || graniteNames == null || graniteNames.length == 0) {
            response.sendRedirect("billing.jsp?error=Invalid bill data");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {

            con.setAutoCommit(false);

            /* ======================
               1️⃣ TOTALS
               ====================== */
            double subTotal = 0;
            double totalSqft = 0;

            for (int i = 0; i < graniteNames.length; i++) {
                subTotal += parseDouble(rowTotals[i]);
                totalSqft += parseDouble(quantities[i]);
            }

            double gstAmount = subTotal * gstPercent / 100;
            double loadingCharge = loadingEnabled ? totalSqft * 3 : 0;

            double grandTotal =
                    subTotal + gstAmount + loadingCharge + transport - discount;

            /* ======================
               2️⃣ INSERT BILL
               ====================== */
            String billSql =
                "INSERT INTO bills " +
                "(bill_date, sub_total, gst_percent, gst_amount, loading_charge, discount, transport, grand_total) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement billPs =
                con.prepareStatement(billSql, Statement.RETURN_GENERATED_KEYS);

            billPs.setDate(1, Date.valueOf(billDate));
            billPs.setDouble(2, subTotal);
            billPs.setDouble(3, gstPercent);
            billPs.setDouble(4, gstAmount);
            billPs.setDouble(5, loadingCharge);
            billPs.setDouble(6, discount);
            billPs.setDouble(7, transport);
            billPs.setDouble(8, grandTotal);
            billPs.executeUpdate();

            ResultSet rs = billPs.getGeneratedKeys();
            rs.next();
            int billId = rs.getInt(1);

            /* ======================
               3️⃣ PREPARED STATEMENTS
               ====================== */
            PreparedStatement detailPs = con.prepareStatement(
                "INSERT INTO bill_details (bill_id, granite_name, quantity, price, total_amount) VALUES (?, ?, ?, ?, ?)");

            PreparedStatement checkStockPs = con.prepareStatement(
                "SELECT stock FROM granite_stock WHERE LOWER(granite_name) = LOWER(?)");

            PreparedStatement updateStockPs = con.prepareStatement(
                "UPDATE granite_stock SET stock = stock - ? WHERE LOWER(granite_name) = LOWER(?)");

            PreparedStatement stockTxnPs = con.prepareStatement(
                "INSERT INTO granite_stock_txn (granite_name, qty, txn_type, txn_date, remark) VALUES (?, ?, 'OUT', ?, ?)");

            /* ======================
               4️⃣ PROCESS EACH ITEM
               ====================== */
            for (int i = 0; i < graniteNames.length; i++) {

                String granite = graniteNames[i].trim();
                double qty     = parseDouble(quantities[i]);
                double price   = parseDouble(prices[i]);
                double total   = parseDouble(rowTotals[i]);

                // 📄 BILL DETAILS (ALWAYS SAVE)
                detailPs.setInt(1, billId);
                detailPs.setString(2, granite);
                detailPs.setDouble(3, qty);
                detailPs.setDouble(4, price);
                detailPs.setDouble(5, total);
                detailPs.executeUpdate();

                // 🔍 CHECK STOCK (OPTIONAL)
                checkStockPs.setString(1, granite);
                ResultSet stockRs = checkStockPs.executeQuery();

                if (stockRs.next()) {

                    double available = stockRs.getDouble("stock");

                    // ✔ Cut stock ONLY if enough
                    if (available >= qty) {

                        updateStockPs.setDouble(1, qty);
                        updateStockPs.setString(2, granite);
                        updateStockPs.executeUpdate();

                        stockTxnPs.setString(1, granite);
                        stockTxnPs.setDouble(2, qty);
                        stockTxnPs.setDate(3, Date.valueOf(billDate));
                        stockTxnPs.setString(4, "Bill #" + billId);
                        stockTxnPs.executeUpdate();
                    }
                }
                // else → granite not in stock → no cut, no error
            }

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error saving bill", e);
        }

        response.sendRedirect("viewBills");
    }

    private double parseDouble(String val) {
        try {
            return (val == null || val.trim().isEmpty()) ? 0 : Double.parseDouble(val);
        } catch (Exception e) {
            return 0;
        }
    }
}
