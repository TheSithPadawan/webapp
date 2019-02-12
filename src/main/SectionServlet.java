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

@WebServlet("/section")
public class SectionServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionID = request.getParameter("sectionID");
        System.out.println("enrollment_limit: " + request.getParameter("enrollment_limit"));
        Integer enrollment_limit = Integer.parseInt(request.getParameter("enrollment_limit"));
        String courseID = request.getParameter("courseID");
        String quarter = request.getParameter("quarter");
        Integer year = Integer.parseInt(request.getParameter("year"));
        String faculty = request.getParameter("faculty");

        dbConn.openConnection();
        PreparedStatement stmtSection = dbConn.getPreparedStatment("INSERT INTO sections VALUES(?, ?)");
        // PreparedStatement stmtSectionDel = dbConn.getPreparedStatment("DELETE FROM sections WHERE sectionID=?");
        PreparedStatement stmtHasSections = dbConn.getPreparedStatment("INSERT INTO has_sections VALUES(?, ?, ?::quarter_enum, ?)");
        // PreparedStatement stmtHasDel = dbConn.getPreparedStatment("DELETE FROM has_sections WHERE couresID=? AND sectionID=?");
        PreparedStatement stmtTaught = dbConn.getPreparedStatment("INSERT INTO taught_by VALUES(?, ?)");

        PreparedStatement stmtTaught2 = dbConn.getPreparedStatment("INSERT INTO faculty_taught VALUES(?, ?, ?::quarter_enum, ?)");;
        if ((year > 2019) || (year == 2019 && !quarter.equals("WI"))) {
            stmtTaught2 = dbConn.getPreparedStatment("INSERT INTO faculty_will_teach VALUES(?, ?, ?::quarter_enum, ?)");
        }

        try {
            stmtSection.setString(1, sectionID);
            stmtSection.setInt(2, enrollment_limit);
            // stmtSectionDel.setString(1, sectionID);

            stmtHasSections.setString(1, courseID);
            stmtHasSections.setString(2, sectionID);
            stmtHasSections.setString(3, quarter);
            stmtHasSections.setInt(4, year);
            // stmtHasDel.setString(1, courseID);
            // stmtHasDel.setString(2, sectionID);

            stmtTaught.setString(1, sectionID);
            stmtTaught.setString(2, faculty);

            stmtTaught2.setString(1, faculty);
            stmtTaught2.setString(2, courseID);
            stmtTaught2.setString(3, quarter);
            stmtTaught2.setInt(4, year);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean resultSection = dbConn.executePreparedStatement(stmtSection);
        if (!resultSection) {
            System.out.println("sections statement failed!");
            dbConn.closeConnections();
            return;
        }

        boolean resultHas = dbConn.executePreparedStatement(stmtHasSections);
        if (!resultHas) {
            System.out.println("has_sections statement failed!");
            // dbConn.executePreparedStatement(stmtSectionDel);
            dbConn.closeConnections();
            return;
        }

        boolean resultTaught = dbConn.executePreparedStatement(stmtTaught);
        if (!resultTaught) {
            System.out.println("taught_by statement failed!");
            // dbConn.executePreparedStatement(stmtSectionDel);
            // dbConn.executePreparedStatement(stmtHasDel);
            dbConn.closeConnections();
            return;
        }

        boolean resultTaught2 = dbConn.executePreparedStatement(stmtTaught2);
        if (!resultTaught2) {
            System.out.println("taught_by statement failed!");
            // dbConn.executePreparedStatement(stmtSectionDel);
            // dbConn.executePreparedStatement(stmtHasDel);
            dbConn.closeConnections();
        }

        dbConn.closeConnections();

        System.out.println("Redirecting");
        response.sendRedirect("/weekly_entry.jsp?sectionID=" + sectionID);

        // RequestDispatcher rd = request.getRequestDispatcher("/weekly_entry.jsp");
        // rd.forward(request, response);
    }
}
