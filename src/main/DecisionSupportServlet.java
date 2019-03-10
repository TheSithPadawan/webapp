package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import com.google.gson.Gson;
import com.google.gson.*;

@WebServlet("/decision_support")
public class DecisionSupportServlet extends HttpServlet {
    private static DBConn dbConn = new DBConn();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String metric = (request.getParameter("metric"));
        if (metric == null || metric.isEmpty()) {
            metric = null;
        }
        String courseID = (request.getParameter("courseID"));
        if (courseID == null || courseID.isEmpty()) {
            courseID = null;
        }
        String professor = (request.getParameter("professor"));
        if (professor == null || professor.isEmpty()) {
            professor = null;
        }
        String quarter = (request.getParameter("quarter"));
        if (quarter == null || quarter.isEmpty()) {
            quarter = null;
        }
        String yearStr = (request.getParameter("year"));
        if (yearStr == null || yearStr.isEmpty()) {
            yearStr = null;
        }
        Integer year = null;
        if (yearStr != null) {
            year = Integer.parseInt(yearStr);
        }

        dbConn.openConnection();
        String query = null;
        if (metric.equals("Letter")) {
            if (professor != null && quarter != null && year != null) {
                System.out.println("prof qtr year");
                String formatQuery =
                    "SELECT faculty_taught.courseID, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{A+,A,A-}')) AS A, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{B+,B,B-}')) AS B, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{C+,C,C-}')) AS C, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = 'D') AS D, " +
                    "    COUNT(*) FILTER (WHERE NOT has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other " +
                    "FROM faculty_taught " +
                    "JOIN has_taken " +
                    "    ON faculty_taught.courseID = has_taken.courseID AND faculty_taught.quarter = has_taken.quarter AND faculty_taught.year = has_taken.year " +
                    "JOIN taught_by " +
                    "    ON has_taken.sectionID = taught_by.sectionID AND taught_by.faculty_name = faculty_taught.faculty_name " +
                    "WHERE faculty_taught.faculty_name = '%s' AND faculty_taught.courseID = '%s' AND faculty_taught.quarter = '%s'::quarter_enum AND faculty_taught.year = %d" +
                    "GROUP BY faculty_taught.courseID";
                query = String.format(formatQuery, professor, courseID, quarter, year);
            } else if (professor != null) {
                System.out.println("prof");
                String formatQuery =
                    "SELECT faculty_taught.courseID, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{A+,A,A-}')) AS A, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{B+,B,B-}')) AS B, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{C+,C,C-}')) AS C, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = 'D') AS D, " +
                    "    COUNT(*) FILTER (WHERE NOT has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other " +
                    "FROM faculty_taught " +
                    "JOIN has_taken " +
                    "    ON faculty_taught.courseID = has_taken.courseID AND faculty_taught.quarter = has_taken.quarter AND faculty_taught.year = has_taken.year " +
                    "JOIN taught_by " +
                    "    ON has_taken.sectionID = taught_by.sectionID AND taught_by.faculty_name = faculty_taught.faculty_name " +
                    "WHERE faculty_taught.faculty_name = '%s' AND faculty_taught.courseID = '%s' " +
                    "GROUP BY faculty_taught.courseID";
                query = String.format(formatQuery, professor, courseID);
            } else {
                System.out.println("course");
                String formatQuery =
                    "SELECT has_taken.courseID, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{A+,A,A-}')) AS A, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{B+,B,B-}')) AS B, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = ANY ('{C+,C,C-}')) AS C, " +
                    "    COUNT(*) FILTER (WHERE has_taken.grade = 'D') AS D, " +
                    "    COUNT(*) FILTER (WHERE NOT has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D}')) AS other " +
                    "FROM has_taken " +
                    "WHERE has_taken.courseID = '%s' " +
                    "GROUP BY has_taken.courseID";
                query = String.format(formatQuery, courseID);
            }
        } else if (metric.equals("GPA")) {
            System.out.println("gpa");
            String formatQuery =
                "SELECT faculty_taught.courseID, AVG(grade_conversion.number_grade) AS avg_gpa " +
                "FROM faculty_taught " +
                "JOIN has_taken " +
                "    ON faculty_taught.courseID = has_taken.courseID AND faculty_taught.quarter = has_taken.quarter AND faculty_taught.year = has_taken.year " +
                "JOIN taught_by " +
                "    ON has_taken.sectionID = taught_by.sectionID AND taught_by.faculty_name = faculty_taught.faculty_name " +
                "JOIN grade_conversion " +
                "    ON has_taken.grade = grade_conversion.letter_grade " +
                "WHERE faculty_taught.faculty_name = '%s' AND faculty_taught.courseID = '%s' " +
                "GROUP BY faculty_taught.courseID";
            query = String.format(formatQuery, professor, courseID);
        }

        if (query == null) {
            dbConn.closeConnections();
            response.sendError(400);
            return;
        }

        // System.out.println(query);

        dbConn.executeQuery(query);
        ResultSet rs = dbConn.getResultSet();
        if (rs == null) {
            System.out.println("statement failed!");
            dbConn.closeConnections();
            response.sendError(400);
            return;
        }

        Gson gson = new Gson();
        JsonArray jsonArray = new JsonArray();
        try {
            while (rs.next()) {
                JsonObject obj = new JsonObject();
                for (int index = 1; index < rs.getMetaData().getColumnCount() + 1; index++) {
                    obj.add(rs.getMetaData().getColumnLabel(index), gson.toJsonTree(rs.getObject(index)));
                }

                jsonArray.add(obj);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendError(400);
            return;
        }

        dbConn.closeConnections();
        response.setStatus(200);
        response.setHeader("Content-Type", "application/json");
        PrintWriter writer = response.getWriter();
        writer.write(gson.toJson(jsonArray));
        writer.flush();
    }
}
