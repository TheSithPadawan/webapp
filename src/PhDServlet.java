
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/phd_info")
public class PhDServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String dept = request.getParameter("dept");
        String studentid = request.getParameter("button");
        String advisor = request.getParameter("advisor");
        String type = request.getParameter("type");

        // Prepare statement and post to DB
        dbConn.openConnection();
        String insert = "INSERT INTO phd VALUES(?,?,?,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(insert);
        try {
            stmt.setString(1, studentid);
            stmt.setString(2, dept);
            stmt.setString(3, advisor);
            stmt.setString(4, type);
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
