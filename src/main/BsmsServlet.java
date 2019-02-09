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

@WebServlet("/bsms_info")
public class BsmsServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String dept = request.getParameter("dept");
        String studentid = request.getParameter("button");
        String major = request.getParameter("major");
        String minor = request.getParameter("minor");
        String college = request.getParameter("college");

        // Prepare statement and post to DB
        dbConn.openConnection();
        String insert = "INSERT INTO undergrad VALUES(?,?,?,?)";
        PreparedStatement stmt1 = dbConn.getPreparedStatment(insert);
        try {
            stmt1.setString(1, studentid);
            stmt1.setString(2, major);
            stmt1.setString(3, minor);
            stmt1.setString(4, college);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        String insertMS = "INSERT INTO ms VALUES(?,?)";
        PreparedStatement stmt2 = dbConn.getPreparedStatment(insertMS);
        try{
            stmt2.setString(1, studentid);
            stmt2.setString(2, dept);
        } catch (SQLException ex){
            ex.printStackTrace();
        }

        String insertBSMS = "INSERT INTO bsms VALUES(?)";
        PreparedStatement stmt3 = dbConn.getPreparedStatment(insertBSMS);
        try {
            stmt3.setString(1, studentid);
        }catch (SQLException ex){
            ex.printStackTrace();
        }
        dbConn.executePreparedStatement(stmt1);
        dbConn.executePreparedStatement(stmt2);
        dbConn.executePreparedStatement(stmt3);
        dbConn.closeConnections();

        RequestDispatcher rd = request.getRequestDispatcher("/attend.jsp");
        request.setAttribute("studentid", studentid);
        rd.forward(request, response);
    }
}
