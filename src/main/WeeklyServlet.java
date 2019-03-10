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
import java.io.PrintWriter;

@WebServlet("/weekly")
public class WeeklyServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String day = request.getParameter("day");
        String timeStart = request.getParameter("time_start");
        String timeEnd = request.getParameter("time_end");
        String building = request.getParameter("building");
        String room = request.getParameter("room");
        String typeMeeting = request.getParameter("type_meeting");
        Boolean required = Boolean.parseBoolean(request.getParameter("required_meeting"));
        String sectionID = request.getParameter("sectionID");

        dbConn.openConnection();
        PreparedStatement stmtHas = dbConn.getPreparedStatment("INSERT INTO has_weekly_meetings VALUES(?, ?::day_enum, ?::TIME, ?::TIME, ?, ?, ?::meeting_enum, ?)");
        try {
            stmtHas.setString(1, sectionID);
            stmtHas.setString(2, day);
            stmtHas.setString(3, timeStart);
            stmtHas.setString(4, timeEnd);
            stmtHas.setString(5, building);
            stmtHas.setString(6, room);
            stmtHas.setString(7, typeMeeting);
            stmtHas.setBoolean(8, required);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean resultHas = dbConn.executePreparedStatement(stmtHas);
        if (!resultHas) {
            System.out.println("has weekly statement failed");
            String exception = dbConn.getException();

            response.setStatus(400);
            response.setHeader("Content-Type", "text/plain");
            PrintWriter writer = response.getWriter();
            writer.write(exception);
            writer.flush();

            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();
    }
}
