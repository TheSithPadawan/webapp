import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.Buffer;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;

import com.google.gson.GsonBuilder;

@WebServlet("/attend")
public class AttendServlet extends HttpServlet{
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException,
            IOException {
        // read post request
        StringBuilder sb = new StringBuilder();
        BufferedReader br = request.getReader();
        String str;
        while ((str = br.readLine()) != null){
            sb.append(str);
        }
        String jsonStr = sb.toString();
        final GsonBuilder builder = new GsonBuilder();
        Attend[] arr = builder.create().fromJson(jsonStr, Attend[].class);

        // insert into database
        String insert = "INSERT INTO attends VALUES (?,?,?)";
        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment(insert);
        for (int i = 0; i < arr.length; i++){
            System.out.println(arr[i].studentid);
            System.out.println(arr[i].quarter);
            System.out.println(arr[i].year);
            try {
                stmt.setString(1, arr[i].studentid);
                stmt.setString(2, arr[i].quarter);
                stmt.setInt(3, arr[i].year);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            boolean result = dbConn.executePreparedStatement(stmt);
            System.out.println(result);
        }
        dbConn.closeConnections();
    }
}