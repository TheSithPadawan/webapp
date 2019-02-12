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

@WebServlet("/ms_info")
public class MsServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();
    private static Util util = new Util();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String dept = request.getParameter("dept");
        String studentid = request.getParameter("button");
        // insert department first
        util.insertDepartment(dbConn, dept);

        // Prepare statement and post to DB
        dbConn.openConnection();
        String insert = "INSERT INTO ms VALUES(?,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(insert);
        try {
            stmt.setString(1, studentid);
            stmt.setString(2, dept);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        dbConn.executePreparedStatement(stmt);
        dbConn.closeConnections();

        RequestDispatcher rd = request.getRequestDispatcher("/attend.jsp");
        request.setAttribute("studentid", studentid);
        rd.forward(request, response);

    }
}
