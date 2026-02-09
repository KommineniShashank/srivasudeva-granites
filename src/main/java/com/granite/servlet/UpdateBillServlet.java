package com.granite.servlet;

import com.granite.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/updateBill")
public class UpdateBillServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int billId = Integer.parseInt(request.getParameter("billId"));

        String[] graniteNames = request.getParameterValues("graniteName[]");
        String[] quantities   = request.getParameterValues("quantity[]");
        String[] prices       = request.getParameterValues("price[]");
        String[] gstChecks    = request.getParameterValues("gstApplicable[]");

        double gstPercent = Double.parseDouble(request.getParameter("gstPercent"));
        double discount   = parseDouble(request.getParameter("discount"));
        double transport  = parseDouble(request.getParameter("transport"));
        boolean loadingFlag = request.getParameter("loadingFlag") != null;

        double subTotal = 0;
        double gstAmountTotal = 0;
        double totalQty = 0;

        Connection con = null;

        try {
            con = DBUtil.getConnection();
            con.setAutoCommit(false);

            // 1️⃣ Delete old bill details
            PreparedStatement del =
                    con.prepareStatement("DELETE FROM bill_details WHERE bill_id=?");
            del.setInt(1, billId);
            del.executeUpdate();

            // 2️⃣ Insert updated bill details
            String insertSql =
                "INSERT INTO bill_details " +
                "(bill_id, granite_name, quantity, price, gst_applicable, gst_percent, gst_amount, total_amount) " +
                "VALUES (?,?,?,?,?,?,?,?)";

            PreparedStatement ins = con.prepareStatement(insertSql);

            for (int i = 0; i < graniteNames.length; i++) {

                double qty   = Double.parseDouble(quantities[i]);
                double price = Double.parseDouble(prices[i]);

                boolean gstApplicable =
                        gstChecks != null && containsIndex(gstChecks, i);

                double baseAmount = qty * price;
                double gstAmount  = gstApplicable ? baseAmount * gstPercent / 100 : 0;
                double rowTotal   = baseAmount + gstAmount;

                subTotal += baseAmount;
                gstAmountTotal += gstAmount;
                totalQty += qty;

                ins.setInt(1, billId);
                ins.setString(2, graniteNames[i]);
                ins.setDouble(3, qty);
                ins.setDouble(4, price);
                ins.setBoolean(5, gstApplicable);
                ins.setDouble(6, gstPercent);
                ins.setDouble(7, gstAmount);
                ins.setDouble(8, rowTotal);
                ins.executeUpdate();
            }

            // 3️⃣ Loading charge
            double loadingCharge = loadingFlag ? totalQty * 3 : 0;

            double grandTotal =
                    subTotal + gstAmountTotal + loadingCharge + transport - discount;

            // 4️⃣ Update bills table (VERY IMPORTANT)
            PreparedStatement upd =
                con.prepareStatement(
                    "UPDATE bills SET sub_total=?, gst_percent=?, gst_amount=?, " +
                    "loading_charge=?, discount=?, transport=?, grand_total=? " +
                    "WHERE bill_id=?"
                );

            upd.setDouble(1, subTotal);
            upd.setDouble(2, gstPercent);
            upd.setDouble(3, gstAmountTotal);
            upd.setDouble(4, loadingCharge);
            upd.setDouble(5, discount);
            upd.setDouble(6, transport);
            upd.setDouble(7, grandTotal);
            upd.setInt(8, billId);
            upd.executeUpdate();

            con.commit();

            response.sendRedirect("viewBills");

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            throw new ServletException(e);
        }
    }

    private double parseDouble(String val) {
        try {
            return val == null || val.isEmpty() ? 0 : Double.parseDouble(val);
        } catch (Exception e) {
            return 0;
        }
    }

    // Fix GST checkbox index mismatch
    private boolean containsIndex(String[] arr, int index) {
        return index < arr.length;
    }
}
