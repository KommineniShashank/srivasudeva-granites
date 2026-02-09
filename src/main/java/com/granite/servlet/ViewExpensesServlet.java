package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/viewExpenses")
public class ViewExpensesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> expenses = new ArrayList<>();
        double totalExpense = 0;

        try (Connection con = DBUtil.getConnection()) {

            String sql =
                "SELECT id, expense_date, expense_type, remark, amount " +
                "FROM expenses ORDER BY expense_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();

                row.put("id", rs.getInt("id"));                      // ✅ REQUIRED
                row.put("date", rs.getDate("expense_date"));
                row.put("category", rs.getString("expense_type"));
                row.put("description", rs.getString("remark"));
                row.put("amount", rs.getDouble("amount"));

                totalExpense += rs.getDouble("amount");
                expenses.add(row);
            }

        } catch (SQLException e) {
            throw new ServletException("Error loading expenses", e);
        }

        request.setAttribute("expenses", expenses);
        request.setAttribute("totalExpense", totalExpense);

        request.getRequestDispatcher("viewExpenses.jsp")
               .forward(request, response);
    }
}
