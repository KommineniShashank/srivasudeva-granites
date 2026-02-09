package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/deleteGraniteStock")
public class DeleteGraniteStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String graniteName = request.getParameter("graniteName");

        if (graniteName == null || graniteName.trim().isEmpty()) {
            response.sendRedirect("viewGraniteStock");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {

            // 1️⃣ Delete from granite_stock table
            String sql = "DELETE FROM granite_stock WHERE granite_name = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, graniteName);
            ps.executeUpdate();

            // 2️⃣ Optional (recommended): delete history as well
            String txnSql = "DELETE FROM granite_stock_txn WHERE granite_name = ?";
            PreparedStatement ps2 = con.prepareStatement(txnSql);
            ps2.setString(1, graniteName);
            ps2.executeUpdate();

        } catch (Exception e) {
            throw new ServletException("Failed to delete granite stock", e);
        }

        // ✅ Go back to stock list
        response.sendRedirect("viewGraniteStock");
    }
}
