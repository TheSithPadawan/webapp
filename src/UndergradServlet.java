import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/undergrad_info")
public class UndergradServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();
    private static boolean DEBUG = true;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {

        String major = request.getParameter("major");
        String minor = request.getParameter("minor");
        String college = request.getParameter("college");
        String studentid = request.getParameter("button");

        // Prepare statement and post to DB
        dbConn.openConnection();
        String insert = "INSERT INTO undergrad VALUES(?,?,?,?)";
        PreparedStatement stmt = dbConn.getPreparedStatment(insert);
        try {
            stmt.setString(1, studentid);
            stmt.setString(2, major);
            stmt.setString(3, minor);
            stmt.setString(4, college);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        dbConn.executePreparedStatement(stmt);
        dbConn.closeConnections();

        // go to the next step to fill out degree information
    }

}
