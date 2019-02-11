package main;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/probation")
public class ProbationServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("studentID");
        String quarter = request.getParameter("quarter");
        Integer year = Integer.parseInt(request.getParameter("year"));
        String reason = request.getParameter("reason");

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO probation VALUES(?,?::quarter_enum,?,?)");
        try {
            stmt.setString(1, courseID);
            stmt.setString(2, quarter);
            stmt.setInt(3, year);
            stmt.setString(4, reason);
        } catch (SQLException ex) {
            ex.printStackTrace();
            return;
        }

        boolean result = dbConn.executePreparedStatement(stmt);
        if (!result) {
            System.out.println("statement failed!");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();

        response.sendRedirect("/probation.jsp");
    }
}
