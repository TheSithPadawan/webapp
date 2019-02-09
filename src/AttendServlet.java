import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;

@WebServlet("/attend")
public class AttendServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException,
            IOException {
        System.out.println("out");

    }
}