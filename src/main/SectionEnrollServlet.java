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
    //TODO: Catch the enrollment limit exceeded from database trigger then add to waitlist
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

        String query = "INSERT INTO students_enrolled VALUES (?,?,?,?,?::quarter_enum,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(query);
        try {
            stmt.setString(1, es.studentID);
            stmt.setString(2, es.sectionID);
            stmt.setString(3, es.grading);
            stmt.setInt(4, es.units);
            stmt.setString(5, "WI");
            stmt.setInt(6, 2019);
        } catch (SQLException ex) {
            System.out.println("Failed to insert statement " + query);
            System.out.println(ex.getMessage());
        }
        dbConn.executePreparedStatement(stmt);

        // add to student's load in current quarter
        query = "INSERT INTO is_taking VALUES (?,?,?::quarter_enum,?,?)";
        stmt = dbConn.getPreparedStatment(query);
        try {
            stmt.setString(1, es.studentID);
            stmt.setString(2, es.courseID);
            stmt.setString(3, "WI");
            stmt.setInt(4, 2019);
            stmt.setInt(5, es.units);
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        dbConn.executePreparedStatement(stmt);
        dbConn.closeConnections();
    }
}

class EnrollSection{
    String courseID;
    String sectionID;
    String studentID;
    String grading;
    int units;
}