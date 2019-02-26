package main;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseID = request.getParameter("courseID").replaceAll("\\|", " ");
        String department = request.getParameter("department");
        String category = request.getParameter("category");

        dbConn.openConnection();

        PreparedStatement stmtCat = dbConn.getPreparedStatment("INSERT INTO category_has_courses VALUES(?,?,?)");
        try {
            stmtCat.setString(1, department);
            stmtCat.setString(2, category);
            stmtCat.setString(3, courseID);
        } catch (SQLException ex) {
            ex.printStackTrace();
            return;
        }

        boolean resultCat = dbConn.executePreparedStatement(stmtCat);
        if (!resultCat) {
            System.out.println("category statement failed!");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();
    }
}
