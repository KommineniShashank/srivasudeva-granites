package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalBills = 0;
        double totalSales = 0;
        double totalGST = 0;
        double nonGST = 0;

        List<Map<String, Object>> graniteSummary = new ArrayList<>();

        try (Connection con = DBUtil.getConnection()) {

            // 🔹 Total Bills & Total Sales
            String billSql =
                "SELECT COUNT(*) AS billCount, " +
                "COALESCE(SUM(grand_total), 0) AS sales " +
                "FROM bills";

            PreparedStatement ps = con.prepareStatement(billSql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalBills = rs.getInt("billCount");
                totalSales = rs.getDouble("sales");
            }

            // 🔹 GST & Non-GST Breakdown
            String gstSql =
                "SELECT " +
                "COALESCE(SUM(gst_amount), 0) AS gstTotal, " +
                "COALESCE(SUM(total_amount - gst_amount), 0) AS nonGstTotal " +
                "FROM bill_details";

            ps = con.prepareStatement(gstSql);
            rs = ps.executeQuery();

            if (rs.next()) {
                totalGST = rs.getDouble("gstTotal");
                nonGST = rs.getDouble("nonGstTotal");
            }

            // 🔹 Granite-wise Sales Summary
            String graniteSql =
                "SELECT granite_name, " +
                "SUM(quantity) AS totalQty, " +
                "SUM(total_amount) AS totalAmount " +
                "FROM bill_details " +
                "GROUP BY granite_name " +
                "ORDER BY totalQty DESC";

            ps = con.prepareStatement(graniteSql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("graniteName", rs.getString("granite_name"));
                row.put("quantity", rs.getDouble("totalQty"));
                row.put("amount", rs.getDouble("totalAmount"));
                graniteSummary.add(row);
            }

        } catch (Exception e) {
            throw new ServletException("Error loading dashboard data", e);
        }

        // 🔹 Send data to JSP
        request.setAttribute("totalBills", totalBills);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalGST", totalGST);
        request.setAttribute("nonGST", nonGST);
        request.setAttribute("graniteSummary", graniteSummary);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }
}
