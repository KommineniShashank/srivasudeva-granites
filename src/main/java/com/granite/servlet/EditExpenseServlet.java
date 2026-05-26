package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editExpense")
public class EditExpenseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBUtil.getConnection()) {

            String sql = "SELECT * FROM expenses WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("id", rs.getInt("id"));
                request.setAttribute("date", rs.getDate("expense_date"));
                request.setAttribute("category", rs.getString("expense_type"));
                request.setAttribute("description", rs.getString("remark"));
                request.setAttribute("amount", rs.getDouble("amount"));
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("/editExpense.jsp")
               .forward(request, response);
    }
}
