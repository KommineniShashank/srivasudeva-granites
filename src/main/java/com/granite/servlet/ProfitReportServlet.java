package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/profitReport")
public class ProfitReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        double totalSales = 0;
        double totalExpenses = 0;
        double totalPurchaseCost = 0;

        try (Connection con = DBUtil.getConnection()) {

            /* 🔹 TOTAL SALES */
            String salesSql =
                "SELECT COALESCE(SUM(grand_total), 0) FROM bills";
            PreparedStatement ps1 = con.prepareStatement(salesSql);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                totalSales = rs1.getDouble(1);
            }

            /* 🔹 TOTAL EXPENSES */
            String expenseSql =
                "SELECT COALESCE(SUM(amount), 0) FROM expenses";
            PreparedStatement ps2 = con.prepareStatement(expenseSql);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                totalExpenses = rs2.getDouble(1);
            }

            /* 🔹 TOTAL PURCHASE COST (IMPORTANT) */
            String purchaseSql =
                "SELECT COALESCE(SUM(bd.quantity * gm.purchase_price), 0) " +
                "FROM bill_details bd " +
                "JOIN granite_master gm " +
                "ON bd.granite_name = gm.granite_name";

            PreparedStatement ps3 = con.prepareStatement(purchaseSql);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                totalPurchaseCost = rs3.getDouble(1);
            }

        } catch (SQLException e) {
            throw new ServletException("Error calculating profit report", e);
        }

        /* 🔹 NET PROFIT */
        double netProfit = totalSales - totalExpenses - totalPurchaseCost;

        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalExpenses", totalExpenses);
        request.setAttribute("totalPurchaseCost", totalPurchaseCost);
        request.setAttribute("netProfit", netProfit);

        request.getRequestDispatcher("/profitReport.jsp")
               .forward(request, response);
    }
}
