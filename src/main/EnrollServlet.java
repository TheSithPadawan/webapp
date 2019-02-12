package main;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
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
        String gradingOption = request.getParameter("gradingOption");

        // go back to original form to add another faculty
        System.out.println(studentID);
        System.out.println(courseID);
        request.setAttribute("courseid", courseID);
        request.setAttribute("studentid", studentID);
        request.setAttribute("gradingOption", gradingOption);
        RequestDispatcher rd = request.getRequestDispatcher("/enroll_section.jsp");
        rd.forward(request, response);
    }
}