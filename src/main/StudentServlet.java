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

@WebServlet("/student_entry")
public class StudentServlet extends HttpServlet{
    private static DBConn dbConn = new DBConn();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String ssn = request.getParameter("ssn");
        String id = request.getParameter("studentid");
        String firstName = request.getParameter("firstname");
        String middleName = request.getParameter("middlename");
        String lastName = request.getParameter("lastname");
        String residency = request.getParameter("residency");
        String status = request.getParameter("program");
        Boolean enrolled = request.getParameter("enrollment") != null;
        String prevDept = request.getParameter("prevDept");
        String degType = request.getParameter("type");

        // Prepare statement and post to DB
        dbConn.openConnection();
        String insert = "INSERT INTO student VALUES(?,?,?,?,?,?,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(insert);
        try{
            stmt.setInt(1, Integer.parseInt(ssn));
            stmt.setString(2, residency);
            stmt.setString(3, id);
            stmt.setString(4, firstName);
            if (middleName.length() > 0){
                stmt.setString(5, middleName);
            }else{
                stmt.setString(5, null);
            }
            stmt.setString(6, lastName);
            stmt.setBoolean(7, enrolled);
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        boolean res = dbConn.executePreparedStatement(stmt);
        System.out.println(res);
        String insertDeg = "INSERT INTO student_previous_degree VALUES (?, ?, ?)";
        PreparedStatement insertStmt = dbConn.getPreparedStatment(insertDeg);
        if (prevDept.length() > 0 && degType.length() > 0){
            try {
                insertStmt.setString(1, id);
                insertStmt.setString(2, prevDept);
                insertStmt.setString(3, degType);
            }catch (SQLException ex){
                ex.printStackTrace();
            }
        }
        boolean result = dbConn.executePreparedStatement(insertStmt);
        System.out.println(result);
        dbConn.closeConnections();

        request.setAttribute("studentid", id);
        // forward to the correct page
        if (status.equals("undergrad")){
            RequestDispatcher rd = request.getRequestDispatcher("/undergrad.jsp");
            rd.forward(request, response);
        }else if (status.equals("ms")){
            RequestDispatcher rd = request.getRequestDispatcher("/ms.jsp");
            rd.forward(request, response);
        }else if (status.equals("phd")){
            RequestDispatcher rd = request.getRequestDispatcher("/phd.jsp");
            rd.forward(request, response);
        }else if (status.equals("bsms")){
            RequestDispatcher rd = request.getRequestDispatcher("/bsms.jsp");
            rd.forward(request, response);
        }
    }
}