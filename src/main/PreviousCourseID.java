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

@WebServlet("/previous_courseid")
public class PreviousCourseID extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID");
        String prevID = request.getParameter("prev_id");

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO previous_courseID VALUES(?, ?)");
        try {
            stmt.setString(1, courseID);
            stmt.setString(2, prevID);
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
    }
}
