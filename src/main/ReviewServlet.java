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

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("date_of");
        String timeStart = request.getParameter("time_start");
        String timeEnd = request.getParameter("time_end");
        String building = request.getParameter("building");
        String room = request.getParameter("room");
        String sectionID = request.getParameter("sectionID");

        dbConn.openConnection();
        PreparedStatement stmtHas = dbConn.getPreparedStatment("INSERT INTO has_review_section VALUES(?, ?::DATE, ?::TIME, ?::TIME, ?, ?)");
        try {
            stmtHas.setString(1, sectionID);
            stmtHas.setString(2, date);
            stmtHas.setString(3, timeStart);
            stmtHas.setString(4, timeEnd);
            stmtHas.setString(5, building);
            stmtHas.setString(6, room);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean resultHas = dbConn.executePreparedStatement(stmtHas);
        if (!resultHas) {
            System.out.println("has weekly statement failed");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();
    }
}
