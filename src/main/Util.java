package main;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;

public class Util {

    public static void insertDepartment(DBConn dbConn, String dept){
        // first check if dept exists if not adds to the database
        dbConn.openConnection();
        String query = "SELECT * FROM department";
        dbConn.getPreparedStatment(query);
        dbConn.executeQuery(query);
        ResultSet rs = dbConn.getResultSet();
        HashSet<String> depts = new HashSet<>();
        PreparedStatement stmt;
        try {
            while(rs.next()){
                depts.add(rs.getString("name"));
            }
        }catch (SQLException ex){
            System.out.println(ex.getMessage());
        }
        if (!depts.contains(dept)){
            String insertDept = "INSERT INTO department VALUES (?)";
            stmt = dbConn.getPreparedStatment(insertDept);
            try {
                stmt.setString(1, dept);
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            dbConn.executePreparedStatement(stmt);
        }

    }
}
