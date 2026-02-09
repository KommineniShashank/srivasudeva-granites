package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/editBill")
public class EditBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int billId = Integer.parseInt(request.getParameter("billId"));

        try (Connection con = DBUtil.getConnection()) {

            /* ================= BILL MASTER ================= */
            PreparedStatement billPs = con.prepareStatement(
                "SELECT bill_date, gst_percent, discount, transport " +
                "FROM bills WHERE bill_id=?"
            );
            billPs.setInt(1, billId);

            ResultSet billRs = billPs.executeQuery();

            if (billRs.next()) {
                request.setAttribute("billDate", billRs.getDate("bill_date"));
                request.setAttribute("gstPercent", billRs.getDouble("gst_percent"));
                request.setAttribute("discount", billRs.getDouble("discount"));
                request.setAttribute("transport", billRs.getDouble("transport"));
            }

            /* ================= BILL ITEMS ================= */
            PreparedStatement itemPs = con.prepareStatement(
                "SELECT granite_name, quantity, price " +
                "FROM bill_details WHERE bill_id=?"
            );
            itemPs.setInt(1, billId);

            ResultSet rs = itemPs.executeQuery();

            List<Map<String, Object>> items = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("granite", rs.getString("granite_name"));
                row.put("quantity", rs.getDouble("quantity"));
                row.put("price", rs.getDouble("price"));
                items.add(row);
            }

            request.setAttribute("billId", billId);
            request.setAttribute("items", items);

            request.getRequestDispatcher("editBill.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
