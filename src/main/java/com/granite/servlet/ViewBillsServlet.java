package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/viewBills")
public class ViewBillsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> bills = new ArrayList<>();

        String billIdParam = request.getParameter("billId");
        String amountParam = request.getParameter("amount");

        StringBuilder sql = new StringBuilder(
            "SELECT bill_id, bill_date, sub_total, discount, transport, grand_total " +
            "FROM bills WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        /* 🔍 Search by Bill ID */
        if (billIdParam != null && !billIdParam.trim().isEmpty()) {
            sql.append(" AND bill_id = ?");
            params.add(Integer.parseInt(billIdParam));
        }

        /* 🔍 Search by Grand Total */
        if (amountParam != null && !amountParam.trim().isEmpty()) {
            sql.append(" AND grand_total >= ?");
            params.add(Double.parseDouble(amountParam));
        }

        sql.append(" ORDER BY bill_id DESC");

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            /* set parameters dynamically */
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> bill = new HashMap<>();

                bill.put("billId", rs.getInt("bill_id"));
                bill.put("billDate", rs.getDate("bill_date"));
                bill.put("subTotal", rs.getDouble("sub_total"));
                bill.put("discount", rs.getDouble("discount"));
                bill.put("transport", rs.getDouble("transport"));
                bill.put("grandTotal", rs.getDouble("grand_total"));

                bills.add(bill);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading bills", e);
        }

        request.setAttribute("bills", bills);
        request.getRequestDispatcher("viewBills.jsp")
               .forward(request, response);
    }
}
