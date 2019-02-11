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
        PreparedStatement stmtWeekly = dbConn.getPreparedStatment("INSERT INTO weekly_meetings VALUES(?::day_enum, ?::TIME, ?::TIME, ?, ?, ?::meeting_enum, ?)");
        PreparedStatement stmtHas = dbConn.getPreparedStatment("INSERT INTO has_weekly_meetings VALUES(?, ?::day_enum, ?::TIME, ?::TIME, ?, ?)");
        try {
            stmtWeekly.setString(1, day);
            stmtWeekly.setString(2, timeStart);
            stmtWeekly.setString(3, timeEnd);
            stmtWeekly.setString(4, building);
            stmtWeekly.setString(5, room);
            stmtWeekly.setString(6, typeMeeting);
            stmtWeekly.setBoolean(7, required);

            stmtHas.setString(1, sectionID);
            stmtHas.setString(2, day);
            stmtHas.setString(3, timeStart);
            stmtHas.setString(4, timeEnd);
            stmtHas.setString(5, building);
            stmtHas.setString(6, room);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean resultWeekly = dbConn.executePreparedStatement(stmtWeekly);
        if (!resultWeekly) {
            System.out.println("weekly statement failed!");
            dbConn.closeConnections();
            return;
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
