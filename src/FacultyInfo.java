import sun.tools.asm.CatchData;

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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        // get parameter
        String name = request.getParameter("facultyName");
        String dept = request.getParameter("dept");

        // first check if dept exists if not adds to the database
        dbConn.openConnection();
        String query = "SELECT * FROM department";
        dbConn.getPreparedStatment(query);
        dbConn.executeQuery(query);
        ResultSet rs = dbConn.getResultSet();
        HashSet<String> depts = new HashSet<>();
        PreparedStatement stmt;
        try {
            while(rs.next()){
                depts.add(rs.getString("name"));
            }
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }
        if (!depts.contains(dept)){
            String insertDept = "INSERT INTO department VALUES (?)";
            stmt = dbConn.getPreparedStatment(insertDept);
            try {
                stmt.setString(1, dept);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        }

        // insert faculty to faculty table
        String insertFaculty = "INSERT INTO faculty VALUES (?)";
        stmt = dbConn.getPreparedStatment(insertFaculty);
        try {
            stmt.setString(1,name);
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

    }
}
