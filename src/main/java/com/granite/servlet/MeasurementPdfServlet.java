package com.granite.servlet;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/measurementPdf")
public class MeasurementPdfServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String data = request.getParameter("data");
            String totalSqft = request.getParameter("totalSqft");

            JSONArray slabs = new JSONArray(data);

            response.setContentType("application/pdf");
            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=Granite_Measurement.pdf"
            );

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // 🔹 Title
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Paragraph title = new Paragraph("Sri Vasudeva Granites\nMeasurement Report\n\n", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            // 🔹 Table
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.setSpacingBefore(15);

            table.addCell("Slab No");
            table.addCell("Length (in)");
            table.addCell("Width (in)");
            table.addCell("Sq.Ft");

            for (int i = 0; i < slabs.length(); i++) {
                JSONObject slab = slabs.getJSONObject(i);
                table.addCell(String.valueOf(slab.getInt("slab")));
                table.addCell(slab.getString("length"));
                table.addCell(slab.getString("width"));
                table.addCell(slab.getString("sqft"));
            }

            document.add(table);

            // 🔹 Total
            document.add(new Paragraph("\n"));
            Font totalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
            Paragraph total = new Paragraph("Total Sq.Ft : " + totalSqft, totalFont);
            total.setAlignment(Element.ALIGN_RIGHT);
            document.add(total);

            document.close();

        } catch (Exception e) {
            throw new ServletException("Measurement PDF generation failed", e);
        }
    }
}
