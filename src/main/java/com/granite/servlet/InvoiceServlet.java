package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int billId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBUtil.getConnection()) {

            String billSql =
                "SELECT bill_date, sub_total, gst_percent, gst_amount, " +
                "loading_charge, discount, transport, grand_total " +
                "FROM bills WHERE bill_id=?";

            PreparedStatement billPs = con.prepareStatement(billSql);
            billPs.setInt(1, billId);

            ResultSet rs = billPs.executeQuery();

            if (rs.next()) {

                double gstPercent = rs.getDouble("gst_percent");
                double gstAmount  = rs.getDouble("gst_amount");

                // ✅ Split GST
                double cgstPercent = gstPercent / 2;
                double sgstPercent = gstPercent / 2;
                double cgstAmount  = gstAmount / 2;
                double sgstAmount  = gstAmount / 2;

                request.setAttribute("billId", billId);
                request.setAttribute("billDate", rs.getDate("bill_date"));
                request.setAttribute("subTotal", rs.getDouble("sub_total"));

                request.setAttribute("cgstPercent", cgstPercent);
                request.setAttribute("sgstPercent", sgstPercent);
                request.setAttribute("cgstAmount", cgstAmount);
                request.setAttribute("sgstAmount", sgstAmount);

                request.setAttribute("loadingCharge", rs.getDouble("loading_charge"));
                request.setAttribute("discount", rs.getDouble("discount"));
                request.setAttribute("transport", rs.getDouble("transport"));
                request.setAttribute("grandTotal", rs.getDouble("grand_total"));
            }

            // ITEMS
            String itemSql =
                "SELECT granite_name, quantity, price, total_amount " +
                "FROM bill_details WHERE bill_id=?";

            PreparedStatement itemPs = con.prepareStatement(itemSql);
            itemPs.setInt(1, billId);

            ResultSet itemRs = itemPs.executeQuery();

            List<Map<String, Object>> items = new ArrayList<>();

            while (itemRs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("granite", itemRs.getString("granite_name"));
                row.put("qty", itemRs.getDouble("quantity"));
                row.put("price", itemRs.getDouble("price"));
                row.put("total", itemRs.getDouble("total_amount"));
                items.add(row);
            }

            request.setAttribute("items", items);

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("invoice.jsp").forward(request, response);
    }
}
