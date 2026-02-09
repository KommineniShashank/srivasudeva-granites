package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/addGranite")
public class AddGraniteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String graniteName = request.getParameter("graniteName");
        String unit = request.getParameter("unit");
        String openingStockStr = request.getParameter("openingStock");

        double openingStock = 0;
        if (openingStockStr != null && !openingStockStr.isEmpty()) {
            openingStock = Double.parseDouble(openingStockStr);
        }

        try (Connection con = DBUtil.getConnection()) {

            String sql =
                "INSERT INTO granite_stock (granite_name, unit, stock) VALUES (?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, graniteName);
            ps.setString(2, unit);
            ps.setDouble(3, openingStock);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new ServletException(e);
        }

        // Redirect to view stock page (we’ll create next)
        response.sendRedirect("viewGraniteStock");
    }
}
