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
import java.util.HashSet;
@WebServlet("/faculty_info")
public class FacultyInfo extends HttpServlet{
    private static DBConn dbConn = new DBConn();
    private static Util util = new Util();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        // get parameter
        String name = request.getParameter("facultyName");
        String dept = request.getParameter("dept");
        String title = request.getParameter("title");
        // first check if dept exists if not adds to the database
        util.insertDepartment(dbConn, dept);

        // insert faculty to faculty table
        String insertFaculty = "INSERT INTO faculty VALUES (?,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(insertFaculty);
        try {
            stmt.setString(1,name);
            stmt.setString(2, title);
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }
        dbConn.executePreparedStatement(stmt);

        // insert (faculty, dept) into faculty_dept table
        String insertFacultyDept = "INSERT INTO faculty_dept VALUES (?,?)";
        stmt = dbConn.getPreparedStatment(insertFacultyDept);
        try{
            stmt.setString(1,name);
            stmt.setString(2,dept);
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }
        dbConn.executePreparedStatement(stmt);

        dbConn.closeConnections();

        // go back to original form to add another faculty
        RequestDispatcher rd = request.getRequestDispatcher("/faculty.jsp");
        rd.forward(request, response);
    }
}
