package main;

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

import com.google.gson.GsonBuilder;

@WebServlet("/degree_category")
public class DegreeCategoryServlet extends HttpServlet{
    private static DBConn dbConn = new DBConn();
    private static Util util = new Util();

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

        // deserialize
        String jsonStr = sb.toString();
        final GsonBuilder builder = new GsonBuilder();
        DegreeCategory dct = builder.create().fromJson(jsonStr, DegreeCategory.class);
        System.out.println("here");
        // insert into degree database
        util.insertDepartment(dbConn, dct.department);
        dbConn.openConnection();
        String insert = "";
        PreparedStatement stmt;
        insert = "INSERT INTO degree VALUES (?,?,?)";
        stmt = dbConn.getPreparedStatment(insert);
        try {
            stmt.setString(1,dct.department);
            stmt.setString(2, dct.program);
            stmt.setInt(3, dct.total_units);
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }
        dbConn.executePreparedStatement(stmt);

        // insert into degree_has_categories database
        for(int i = 0; i < dct.categories.length; i++) {
            insert = "INSERT INTO degree_has_categories VALUES (?,?,?,?,?)";
            stmt = dbConn.getPreparedStatment(insert);
            try {
                stmt.setString(1, dct.department);
                stmt.setString(2, dct.program);
                stmt.setString(3, dct.categories[i].category);
                stmt.setInt(4,dct.categories[i].units);
                stmt.setInt(5, dct.categories[i].min_gpa);
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        }
        dbConn.closeConnections();
    }
}

class DegreeCategory{
    String department;
    String program;
    int total_units;
    Category[] categories;
}

class Category{
    String category;
    int units;
    int min_gpa;
}