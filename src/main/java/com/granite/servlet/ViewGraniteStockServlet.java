package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

@WebServlet("/viewGraniteStock")
public class ViewGraniteStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> graniteList = new ArrayList<>();

        try (Connection con = DBUtil.getConnection()) {

            // ✅ CALCULATE STOCK FROM TRANSACTION TABLE
            String sql =
                "SELECT granite_name, 'sqft' AS unit, " +
                "SUM(CASE " +
                "    WHEN txn_type = 'IN' THEN qty " +
                "    WHEN txn_type = 'OUT' THEN -qty " +
                "END) AS stock " +
                "FROM granite_stock_txn " +
                "GROUP BY granite_name " +
                "ORDER BY granite_name";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("graniteName", rs.getString("granite_name"));
                row.put("unit", rs.getString("unit"));
                row.put("stock", rs.getDouble("stock"));
                graniteList.add(row);
            }

        } catch (Exception e) {
            throw new ServletException("Failed to load granite stock", e);
        }

        request.setAttribute("graniteList", graniteList);
        request.getRequestDispatcher("/viewGraniteStock.jsp")
               .forward(request, response);
    }
}
