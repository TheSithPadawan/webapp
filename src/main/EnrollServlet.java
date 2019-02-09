package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/enroll")
public class EnrollServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentID = request.getParameter("studentid");
        String courseID = request.getParameter("courseid");
        //todo: need to change to dropdown list
        String sectionID = request.getParameter("sectionid");
        String gradingOption = request.getParameter("gradingOption");
        int units = Integer.parseInt(request.getParameter("units"));
        int[] limit = new int[2];

        dbConn.openConnection();
        // first check if the section is full
        // get enrollment limit for current section
        PreparedStatement stmt = dbConn.getPreparedStatment("SELECT * FROM sections WHERE sectionid = ?");
        try {
            stmt.setString(1, sectionID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()){
                limit[0] = rs.getInt("enrollment_limit");
            }
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }

        // get currently enrolled student
        stmt = dbConn.getPreparedStatment("SELECT Count(*) FROM students_enrolled WHERE sectionid = ?");
        try {
            stmt.setString(1, sectionID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()){
                limit[1] = rs.getInt(1);
            }
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }

        // if currently enrolled < limit --> enroll current student
        // else: add current student to the wait list
        String query = "";
        if (limit[1] < limit[0]){
            query = "INSERT INTO students_enrolled VALUES (?,?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, studentID);
                stmt.setString(2,sectionID);
                stmt.setString(3,gradingOption);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);

            // add to student's load in current quarter
            query = "INSERT INTO is_taking VALUES (?,?,?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, studentID);
                stmt.setString(2,courseID);
                stmt.setString(3,"Winter");
                stmt.setInt(4,2019);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        } else {
            query = "INSERT INTO students_waitlisted VALUES (?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, studentID);
                stmt.setString(2,sectionID);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        }
        dbConn.closeConnections();

        // go back to original form to add another faculty
        RequestDispatcher rd = request.getRequestDispatcher("/course_enrollment.jsp");
        rd.forward(request, response);
    }
}