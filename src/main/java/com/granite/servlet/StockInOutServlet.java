package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/stockInOut")
public class StockInOutServlet extends HttpServlet {

    /* ===============================
       LOAD GRANITE LIST
       =============================== */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> graniteList = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(
                         "SELECT granite_name FROM granite_stock ORDER BY granite_name");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                graniteList.add(rs.getString("granite_name"));
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.setAttribute("graniteList", graniteList);
        request.getRequestDispatcher("stockInOut.jsp").forward(request, response);
    }

    /* ===============================
       SAVE STOCK IN / OUT
       =============================== */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String graniteName = request.getParameter("graniteName").trim();
        String txnType     = request.getParameter("txnType"); // IN / OUT
        double qty         = Double.parseDouble(request.getParameter("qty"));
        String dateStr     = request.getParameter("txnDate");
        String remark      = request.getParameter("remark");

        String unit = "sqft";

        try (Connection con = DBUtil.getConnection()) {

            con.setAutoCommit(false);

            /* ===============================
               1️⃣ CHECK EXISTING STOCK
               =============================== */
            double currentStock = 0;
            boolean exists = false;

            String checkSql =
                "SELECT stock FROM granite_stock " +
                "WHERE LOWER(TRIM(granite_name)) = LOWER(TRIM(?)) FOR UPDATE";

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setString(1, graniteName);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    exists = true;
                    currentStock = rs.getDouble("stock");
                }
            }

            /* ❌ PREVENT INVALID OUT */
            if ("OUT".equalsIgnoreCase(txnType)) {
                if (!exists || currentStock < qty) {
                    con.rollback();
                    response.sendRedirect(
                        "stockInOut.jsp?error=Insufficient stock");
                    return;
                }
            }

            /* ===============================
               2️⃣ INSERT TRANSACTION
               =============================== */
            String txnSql =
                "INSERT INTO granite_stock_txn " +
                "(granite_name, qty, txn_type, txn_date, remark) " +
                "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(txnSql)) {
                ps.setString(1, graniteName);
                ps.setDouble(2, qty);
                ps.setString(3, txnType);
                ps.setDate(4, Date.valueOf(dateStr));
                ps.setString(5, remark);
                ps.executeUpdate();
            }

            /* ===============================
               3️⃣ UPDATE / INSERT STOCK
               =============================== */
            if (exists) {

                String updateSql =
                    "UPDATE granite_stock SET stock = stock " +
                    ("IN".equalsIgnoreCase(txnType) ? "+ ?" : "- ?") +
                    " WHERE LOWER(TRIM(granite_name)) = LOWER(TRIM(?))";

                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setDouble(1, qty);
                    ps.setString(2, graniteName);
                    ps.executeUpdate();
                }

            } else {
                // First-time stock IN only
                String insertSql =
                    "INSERT INTO granite_stock (granite_name, unit, stock) " +
                    "VALUES (?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setString(1, graniteName);
                    ps.setString(2, unit);
                    ps.setDouble(3, qty);
                    ps.executeUpdate();
                }
            }

            con.commit();

        } catch (Exception e) {
            throw new ServletException(e);
        }

        response.sendRedirect("viewGraniteStock");
    }
}
