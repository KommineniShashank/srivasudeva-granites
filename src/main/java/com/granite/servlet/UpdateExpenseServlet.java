package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/updateExpense")
public class UpdateExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String date = request.getParameter("date");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            double amount = Double.parseDouble(request.getParameter("amount"));

            try (Connection con = DBUtil.getConnection()) {

                String sql =
                    "UPDATE expenses SET expense_date=?, expense_type=?, remark=?, amount=? " +
                    "WHERE id=?";

                PreparedStatement ps = con.prepareStatement(sql);
                ps.setDate(1, Date.valueOf(date));
                ps.setString(2, category);
                ps.setString(3, description);
                ps.setDouble(4, amount);
                ps.setInt(5, id);

                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/viewExpenses");

        } catch (Exception e) {
            throw new ServletException("Error updating expense", e);
        }
    }
}
