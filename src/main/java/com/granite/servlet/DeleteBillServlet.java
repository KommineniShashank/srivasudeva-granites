package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/deleteBill")
public class DeleteBillServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int billId = Integer.parseInt(request.getParameter("billId"));

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);

            // 1️⃣ Delete bill details first (FK safety)
            PreparedStatement ps1 =
                    con.prepareStatement("DELETE FROM bill_details WHERE bill_id=?");
            ps1.setInt(1, billId);
            ps1.executeUpdate();

            // 2️⃣ Delete bill
            PreparedStatement ps2 =
                    con.prepareStatement("DELETE FROM bills WHERE bill_id=?");
            ps2.setInt(1, billId);
            ps2.executeUpdate();

            con.commit();
        } catch (Exception e) {
            throw new ServletException(e);
        }

        // 3️⃣ Redirect back
        response.sendRedirect("viewBills");
    }
}
