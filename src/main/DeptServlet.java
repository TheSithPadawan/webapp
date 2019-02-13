package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


@WebServlet("/dept")
public class DeptServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();
    private static Util util = new Util();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String departmentName = request.getParameter("dept");
        util.insertDepartment(dbConn, departmentName);

        RequestDispatcher rd = request.getRequestDispatcher("/department.jsp");
        rd.forward(request, response);
    }
}