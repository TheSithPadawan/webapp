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

@WebServlet("/textbook")
public class TextbookServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long isbn = Long.parseLong(request.getParameter("isbn"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");

        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("INSERT INTO textbook VALUES(?, ?, ?)");
        try {
            stmt.setLong(1, isbn);
            stmt.setString(2, title);
            stmt.setString(3, author);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        boolean result = dbConn.executePreparedStatement(stmt);
        if (!result) {
            System.out.println("statement failed!");
            dbConn.closeConnections();
            return;
        }

        dbConn.closeConnections();
    }
}
