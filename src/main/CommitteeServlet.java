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

@WebServlet("/thesis_committee")
public class CommitteeServlet extends HttpServlet{
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException,
            IOException {
        System.out.println("GET!");

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
        StudentCommittee cmt = builder.create().fromJson(jsonStr, StudentCommittee.class);

        // insert into database
        dbConn.openConnection();
        String insert = "";
        PreparedStatement stmt;
        if (cmt.program.equals("MS")){
            insert = "INSERT INTO ms_thesis_committee VALUES (?,?)";
            stmt = dbConn.getPreparedStatment(insert);
            for (int i = 0; i < cmt.committee.length; i++){
                try {
                    stmt.setString(1,cmt.studentid);
                    stmt.setString(2, cmt.committee[i].faculty);
                }catch (SQLException ex){
                    System.out.println(ex.getMessage());
                }
                dbConn.executePreparedStatement(stmt);
            }
        }else{
            // check for phd candidate department
            stmt = dbConn.getPreparedStatment("SELECT department FROM phd WHERE studentID = ?");
            String[] dept = new String[1];
            try {
                stmt.setString(1, cmt.studentid);
                ResultSet rs = stmt.executeQuery();
                while (rs.next())
                {
                    dept[0] = rs.getString(1);
                }
                rs.close();
            }catch (SQLException ex){
                System.out.println(ex.getMessage());
            }
            // check number of out-department prof for this phd candidate
            System.out.println("student is from " + dept[0]);
            int inDeptCount = 0, outDeptCount = 0;
            for (int i = 0; i < cmt.committee.length; i++){
                if (cmt.committee[i].department.equals(dept[0])){
                    inDeptCount++;
                }else{
                    outDeptCount++;
                }
            }
            if (!(inDeptCount >= 1 && outDeptCount >= 1)){
                System.out.println("Unqualified thesis committee");
            }else{
                for (int i = 0; i < cmt.committee.length; i++){
                    insert = "INSERT INTO phd_thesis_committee_dept VALUES (?,?,?)";
                    stmt = dbConn.getPreparedStatment(insert);
                    try {
                        stmt.setString(1,cmt.studentid);
                        stmt.setString(2, cmt.committee[i].faculty);
                        stmt.setString(3, cmt.committee[i].department);
                    }catch (SQLException ex){
                        System.out.println(ex.getMessage());
                    }
                    dbConn.executePreparedStatement(stmt);
                }
            }
        }
        dbConn.closeConnections();
    }
}

class StudentCommittee{
    String studentid;
    String program;
    Committee[] committee;
}

class Committee{
    String faculty;
    String department;
}