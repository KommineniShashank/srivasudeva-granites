package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/deleteExpense")
public class DeleteExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            throw new ServletException("Expense ID missing");
        }

        int id = Integer.parseInt(idStr);

        try (Connection con = DBUtil.getConnection()) {

            String sql = "DELETE FROM expenses WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Error deleting expense", e);
        }

        response.sendRedirect("viewExpenses");
    }
}
