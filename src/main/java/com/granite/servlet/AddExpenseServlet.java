package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addExpense")
public class AddExpenseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String expenseType = request.getParameter("expenseType");
        String amountStr   = request.getParameter("amount");
        String expenseDate = request.getParameter("expenseDate");
        String remark      = request.getParameter("remark");

        if (expenseType == null || amountStr == null || expenseDate == null) {
            throw new ServletException("Expense data missing");
        }

        double amount = Double.parseDouble(amountStr);

        try (Connection con = DBUtil.getConnection()) {

            String sql =
                "INSERT INTO expenses (expense_type, amount, expense_date, remark) " +
                "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, expenseType);
            ps.setDouble(2, amount);
            ps.setDate(3, Date.valueOf(expenseDate));
            ps.setString(4, remark);

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Error saving expense", e);
        }

        response.sendRedirect("viewExpenses");
    }
}
