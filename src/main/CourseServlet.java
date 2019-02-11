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
        String courseID = request.getParameter("courseID").replaceAll("\\|", " ");
        Boolean lab = Boolean.parseBoolean(request.getParameter("lab"));
        Integer units_min = Integer.parseInt(request.getParameter("units_min"));
        Integer units_max = Integer.parseInt(request.getParameter("units_max"));
        Boolean consent = Boolean.parseBoolean(request.getParameter("consent"));
        String department = request.getParameter("department");
        String category = request.getParameter("category");
        String gradingOption = request.getParameter("grading_option");

        dbConn.openConnection();
        PreparedStatement stmtCourse = dbConn.getPreparedStatment("INSERT INTO course VALUES(?,?,?,?,?)");
        PreparedStatement stmtDept = dbConn.getPreparedStatment("INSERT INTO course_offered VALUES(?,?)");
        PreparedStatement stmtCat = dbConn.getPreparedStatment("INSERT INTO category_has_courses VALUES(?,?)");
        PreparedStatement stmtGrade = dbConn.getPreparedStatment("INSERT INTO course_grading_option VALUES(?,?)");
        try {
            stmtCourse.setString(1, courseID);
            stmtCourse.setBoolean(2, lab);
            stmtCourse.setInt(3, units_min);
            stmtCourse.setInt(4, units_max);
            stmtCourse.setBoolean(5, consent);

            stmtDept.setString(1, courseID);
            stmtDept.setString(2, department);

            stmtCat.setString(1, category);
            stmtCat.setString(2, courseID);

            stmtGrade.setString(1, courseID);
            stmtGrade.setString(2, gradingOption);
        } catch (SQLException ex) {
            ex.printStackTrace();
            return;
        }

        boolean resultCourse = dbConn.executePreparedStatement(stmtCourse);
        if (!resultCourse) {
            System.out.println("course statement failed!");
            dbConn.closeConnections();
            return;
        }

        boolean resultDept = dbConn.executePreparedStatement(stmtDept);
        if (!resultDept) {
            System.out.println("offered statement failed!");
            // PreparedStatement stmt = dbConn.getPreparedStatment("DELETE FROM course WHERE courseID=?");
            // try {
            //     stmt.setString(1, courseID);
            // } catch (SQLException ex) {
            //     ex.printStackTrace();
            //     dbConn.closeConnections();
            //     return;
            // }
            // dbConn.executePreparedStatement(stmt);
            dbConn.closeConnections();
            return;
        }

        boolean resultCat = dbConn.executePreparedStatement(stmtCat);
        if (!resultCat) {
            System.out.println("category statement failed!");
            // PreparedStatement stmt = dbConn.getPreparedStatment("DELETE FROM course WHERE courseID=?");
            // PreparedStatement stmt2 = dbConn.getPreparedStatment("DELETE FROM course_offered WHERE courseID=? AND category_type=?");
            // try {
            //     stmt.setString(1, courseID);
            //     stmt2.setString(1, courseID);
            //     stmt2.setString(2, department);
            // } catch (SQLException ex) {
            //     ex.printStackTrace();
            //     dbConn.closeConnections();
            //     return;
            // }

            // dbConn.executePreparedStatement(stmt2);
            // dbConn.executePreparedStatement(stmt);
            dbConn.closeConnections();
            return;
        }

        boolean resultGrade = dbConn.executePreparedStatement(stmtGrade);
        if (!resultGrade) {
            System.out.println("grade statement failed!");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();

        response.sendRedirect("/class_entry.jsp");
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
