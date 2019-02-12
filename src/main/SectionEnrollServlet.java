package main;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/section_enroll")
public class SectionEnrollServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // read post request
        StringBuilder sb = new StringBuilder();
        BufferedReader br = request.getReader();
        String str;
        while ((str = br.readLine()) != null){
            sb.append(str);
        }
        String jsonStr = sb.toString();
        final GsonBuilder builder = new GsonBuilder();

        EnrollSection es = builder.create().fromJson(jsonStr, EnrollSection.class);

        dbConn.openConnection();
        // first check if the section is full
        // get enrollment limit for current section
        int[] limit = new int[2];
        PreparedStatement stmt = dbConn.getPreparedStatment("SELECT * FROM sections WHERE sectionid = ?");
        try {
            stmt.setString(1, es.sectionID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()){
                limit[0] = rs.getInt("enrollment_limit");
            }
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }

        // get the number of currently enrolled student
        stmt = dbConn.getPreparedStatment("SELECT Count(*) FROM students_enrolled WHERE sectionid = ?");
        try {
            stmt.setString(1, es.sectionID);
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
            query = "INSERT INTO students_enrolled VALUES (?,?,?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, es.studentID);
                stmt.setString(2,es.sectionID);
                stmt.setString(3,es.grading);
                stmt.setInt(4, es.units);
            }catch (SQLException ex){
                System.out.println("Failed to insert statement " + query);
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);

            // add to student's load in current quarter
            query = "INSERT INTO is_taking VALUES (?,?,?::quarter_enum,?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, es.studentID);
                stmt.setString(2,es.courseID);
                stmt.setString(3,"WI");
                stmt.setInt(4,2019);
                stmt.setInt(5, es.units);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        } else {
            query = "INSERT INTO students_waitlisted VALUES (?,?)";
            stmt = dbConn.getPreparedStatment(query);
            try {
                stmt.setString(1, es.studentID);
                stmt.setString(2,es.sectionID);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        }
        dbConn.closeConnections();

//        RequestDispatcher rd = request.getRequestDispatcher("/course_enrollment.jsp");
//        rd.forward(request, response);

    }
}

class EnrollSection{
    String courseID;
    String sectionID;
    String studentID;
    String grading;
    int units;
}