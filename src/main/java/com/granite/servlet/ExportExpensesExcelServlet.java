package com.granite.servlet;

import com.granite.util.DBUtil;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/exportExpensesExcel")
public class ExportExpensesExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader(
                "Content-Disposition", "attachment; filename=expenses.xlsx");

        try (Workbook workbook = new XSSFWorkbook();
             Connection con = DBUtil.getConnection()) {

            Sheet sheet = workbook.createSheet("Expenses");

            // 🔹 Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            // 🔹 Header Row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"Date", "Category", "Description", "Amount"};

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 🔹 Data
            String sql =
                "SELECT expense_date, expense_type, remark, amount FROM expenses ORDER BY expense_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int rowNum = 1;
            double total = 0;

            while (rs.next()) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(rs.getDate("expense_date").toString());
                row.createCell(1).setCellValue(rs.getString("expense_type"));
                row.createCell(2).setCellValue(rs.getString("remark"));
                row.createCell(3).setCellValue(rs.getDouble("amount"));
                total += rs.getDouble("amount");
            }

            // 🔹 Total Row
            Row totalRow = sheet.createRow(rowNum);
            totalRow.createCell(2).setCellValue("TOTAL");
            totalRow.createCell(3).setCellValue(total);

            // 🔹 Auto size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());

        } catch (Exception e) {
            throw new ServletException("Error exporting expenses", e);
        }
    }
}
