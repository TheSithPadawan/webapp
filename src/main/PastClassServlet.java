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

@WebServlet("/past_class")
public class PastClassServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentID = request.getParameter("studentID");
        String courseID = request.getParameter("courseID");
        String sectionID = request.getParameter("sectionID");
        String quarter = request.getParameter("quarter");
        Integer year = Integer.parseInt(request.getParameter("year"));
        String gradingOption = request.getParameter("option");
        String grade = request.getParameter("grade");
        Integer units = Integer.parseInt(request.getParameter("units"));

        // has_taken
        // students_enrolled

        dbConn.openConnection();

        try {
            // validate grading option
            dbConn.executeQuery("SELECT * FROM course_grading_option WHERE courseID='" + courseID + "'");
            ResultSet rset = dbConn.getResultSet();
            if (!rset.next()) {
                System.out.println("Couldn't find course");
                dbConn.closeConnections();
                return;
            }

            String validOption = rset.getString("option").toLowerCase();
            if (!validOption.equals("both")) {
               if (!gradingOption.toLowerCase().equals(validOption)) {
                   System.out.println("invalid grade option");
                   dbConn.closeConnections();
                   return;
               }
            }

            // validate units
            dbConn.executeQuery("SELECT * FROM course WHERE courseID='" + courseID + "'");
            rset = dbConn.getResultSet();
            rset.next();
            int min = rset.getInt("units_min");
            int max = rset.getInt("units_max");
            if (!(units >= min && units <= max)) {
                System.out.println("units out of bounds");
                dbConn.closeConnections();
                return;
            }
        } catch (SQLException ex) {
            System.out.println("error during validation");
            ex.printStackTrace();
            return;
        }

        /*
            change here to upsert statement to support updating a student's grade
            insert will fail if update has been executed
         */
        String query = "UPDATE has_taken SET grade = ? WHERE studentid = ? AND sectionid = ?;\n" +
                "INSERT INTO has_taken (studentid, courseid, sectionid, quarter, year, grade, units)\n" +
                "  SELECT ?, ?, ?, ?::quarter_enum, ?, ?, ?\n" +
                "  WHERE NOT EXISTS (SELECT * FROM has_taken WHERE studentid = ? AND sectionid = ?)";
        PreparedStatement stmtTaken = dbConn.getPreparedStatment(query);
        PreparedStatement stmtEnrolled = dbConn.getPreparedStatment("INSERT INTO students_enrolled VALUES(?, ?, ?, ?, ?::quarter_enum, ?)");
        try {
            stmtTaken.setString(1, grade);
            stmtTaken.setString(2, studentID);
            stmtTaken.setString(3, sectionID);
            stmtTaken.setString(4, studentID);
            stmtTaken.setString(5, courseID);
            stmtTaken.setString(6, sectionID);
            stmtTaken.setString(7, quarter);
            stmtTaken.setInt(8, year);
            stmtTaken.setString(9, grade);
            stmtTaken.setInt(10, units);
            stmtTaken.setString(11, studentID);
            stmtTaken.setString(12, sectionID);

            stmtEnrolled.setString(1, studentID);
            stmtEnrolled.setString(2, sectionID);
            stmtEnrolled.setString(3, gradingOption);
            stmtEnrolled.setInt(4, units);
            stmtEnrolled.setString(5, quarter);
            stmtEnrolled.setInt(6, year);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean resultTaken = dbConn.executePreparedStatement(stmtTaken);
        if (!resultTaken) {
            System.out.println("taken statement failed!");
            dbConn.closeConnections();
            return;
        }

        boolean resultEnrolled = dbConn.executePreparedStatement(stmtEnrolled);
        if (!resultEnrolled) {
            System.out.println("enrolled statement failed");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();
    }
}
