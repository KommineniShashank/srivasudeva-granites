package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/viewBillDetails")
public class ViewBillDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int billId = Integer.parseInt(request.getParameter("billId"));

        try (Connection con = DBUtil.getConnection()) {

            /* ===== BILL SUMMARY ===== */
            String billSql =
                "SELECT bill_date, sub_total, gst_percent, gst_amount, " +
                "loading_charge, discount, transport, grand_total " +
                "FROM bills WHERE bill_id=?";

            PreparedStatement ps = con.prepareStatement(billSql);
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("billId", billId);
                request.setAttribute("billDate", rs.getDate("bill_date"));
                request.setAttribute("subTotal", rs.getDouble("sub_total"));
                request.setAttribute("gstPercent", rs.getDouble("gst_percent"));
                request.setAttribute("gstAmount", rs.getDouble("gst_amount"));
                request.setAttribute("loadingCharge", rs.getDouble("loading_charge"));
                request.setAttribute("discount", rs.getDouble("discount"));
                request.setAttribute("transport", rs.getDouble("transport"));
                request.setAttribute("grandTotal", rs.getDouble("grand_total"));
            }

            /* ===== ITEMS ===== */
            String itemSql =
                "SELECT granite_name, quantity, price, total_amount " +
                "FROM bill_details WHERE bill_id=?";

            PreparedStatement ips = con.prepareStatement(itemSql);
            ips.setInt(1, billId);
            ResultSet irs = ips.executeQuery();

            List<Map<String, Object>> items = new ArrayList<>();

            while (irs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("granite", irs.getString("granite_name"));
                row.put("qty", irs.getDouble("quantity"));
                row.put("price", irs.getDouble("price"));
                row.put("total", irs.getDouble("total_amount"));
                items.add(row);
            }

            request.setAttribute("items", items);

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("viewBillDetails.jsp").forward(request, response);
    }
}
