package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/textbook_section")
public class TextbookSectionServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionID = request.getParameter("sectionID");
        Long isbn = Long.parseLong(request.getParameter("isbn"));
        Boolean required = Boolean.parseBoolean(request.getParameter("is_required"));

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO has_textbook VALUES(?, ?, ?)");
        try {
            stmt.setString(1, sectionID);
            stmt.setLong(2, isbn);
            stmt.setBoolean(3, required);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean result = dbConn.executePreparedStatement(stmt);
        if (!result) {
            System.out.println("statement failed!");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();

        response.sendRedirect("/textbook_section.jsp");
    }
}
