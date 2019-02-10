package main;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/*
todo:
1. add department field to specify course offered by a department
2. add category field to link course to category (operates the category_has_courses table)
 */

@WebServlet("/course")
public class CourseServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID");
        Boolean lab = Boolean.parseBoolean(request.getParameter("lab"));
        Integer units_min = Integer.parseInt(request.getParameter("units_min"));
        Integer units_max = Integer.parseInt(request.getParameter("units_max"));
        Boolean consent = Boolean.parseBoolean(request.getParameter("consent"));

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO course VALUES(?,?,?,?,?)");
        try {
            stmt.setString(1, courseID);
            stmt.setBoolean(2, lab);
            stmt.setInt(3, units_min);
            stmt.setInt(4, units_max);
            stmt.setBoolean(5, consent);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean result = dbConn.executePreparedStatement(stmt);
        if (!result) {
            // TODO:
            System.out.println("statement failed!");
        }

        dbConn.closeConnections();
    }

    /*
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID");
        Boolean lab = Boolean.parseBoolean(request.getParameter("lab"));
        Integer units_min = Integer.parseInt(request.getParameter("units_min"));
        Integer units_max = Integer.parseInt(request.getParameter("units_max"));
        Boolean consent = Boolean.parseBoolean(request.getParameter("consent"));

        if (courseID == null) {
            throw new IllegalArgumentException("courseID");
        }

        PreparedStatement stmt = dbConn.getPreparedStatment(
            "UPDATE course SET lab=?, units_min=?, units_max=?, consent=?, WHERE courseID=?");
        try {
            stmt.setBoolean(1, lab);
            stmt.setInt(2, units_min);
            stmt.setInt(3, units_max);
            stmt.setBoolean(4, consent);
            stmt.setString(5, courseID);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean result = dbConn.executePreparedStatement(stmt);
        if (!result) {
            // TODO:
            System.out.println("statement failed!");
        }

        dbConn.closeConnections();
    }
    */
}
