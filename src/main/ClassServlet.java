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

@WebServlet("/class")
public class ClassServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID");
        String title = request.getParameter("title");
        String quarter = request.getParameter("quarter");
        Integer year = Integer.parseInt(request.getParameter("year"));

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO class VALUES(?, ? ,?::quarter_enum, ?)");
        try {
            stmt.setString(1, courseID);
            stmt.setString(2, title);
            stmt.setString(3, quarter);
            stmt.setInt(4, year);
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

        RequestDispatcher rd = request.getRequestDispatcher("/section_entry.jsp");
        rd.forward(request, response);
    }
}
