package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;

import com.google.gson.Gson;
import com.google.gson.*;

@WebServlet("/ms_degree_requirements")
public class MSDegreeRequirements extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        Integer ssn = Integer.parseInt(request.getParameter("ssn"));
        String department = request.getParameter("department");

        Gson gson = new Gson();

        JsonObject retObject = new JsonObject();
        retObject.add("upcoming_courses", upcomingCourses(ssn, department));
        retObject.add("completed_categories", hasCompleted(ssn, department));
        retObject.add("degree_remaining_units", degreeRemainingUnits(ssn, department));
        retObject.add("category_remaining", categoryRemaining(ssn, department));

        response.setStatus(200);
        response.setHeader("Content-Type", "application/json");
        PrintWriter writer = response.getWriter();
        writer.write(gson.toJson(retObject));
        writer.flush();
    }

    private JsonArray upcomingCourses(Integer ssn, String department) {
        String query =
            "SELECT degree_has_categories.category_type AS concentration, faculty_will_teach.courseID, faculty_will_teach.quarter, faculty_will_teach.year " +
            "FROM faculty_will_teach " +
            "JOIN category_has_courses " +
            "    ON faculty_will_teach.courseID = category_has_courses.courseID " +
            "JOIN degree_has_categories " +
            "    ON degree_has_categories.dept_name = category_has_courses.department AND category_has_courses.category_type = degree_has_categories.category_type " +
            "WHERE category_has_courses.department = '%s' AND degree_has_categories.deg_type = 'MS' " +
            "        AND faculty_will_teach.courseID NOT IN ( " +
            "            SELECT has_taken.courseID " +
            "            FROM has_taken " +
            "            JOIN student " +
            "                ON has_taken.studentID = student.studentID " +
            "            WHERE student.ssn = %d " +
            "        )";
        String formattedQuery = String.format(query, department, ssn);
        // System.out.println(formattedQuery);

        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        dbConn.executeQuery(formattedQuery);
        ResultSet rs = dbConn.getResultSet();

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
        }

        return jsonArray;
    }

    private JsonArray hasCompleted(Integer ssn, String department) {
        String query =
            "SELECT degree_has_categories.category_type as concentration, SUM(has_taken.units) as completed_units, degree_has_categories.min_gpa AS min_gpa, (SUM(has_taken.units * grade_conversion.number_grade)/SUM(has_taken.units)) AS current_gpa " +
            "FROM degree_has_categories " +
            "JOIN category_has_courses " +
            "    ON degree_has_categories.dept_name = category_has_courses.department AND category_has_courses.category_type = degree_has_categories.category_type " +
            "JOIN has_taken " +
            "    ON category_has_courses.courseID = has_taken.courseID " +
            "JOIN student " +
            "    ON has_taken.studentID = student.studentID " +
            "JOIN grade_conversion " +
            "    ON has_taken.grade = grade_conversion.letter_grade " +
            "WHERE degree_has_categories.dept_name = '%s' AND student.ssn = %d AND degree_has_categories.deg_type = 'MS' AND NOT has_taken.grade = ANY ('{F,U,IN}') " +
            "GROUP BY degree_has_categories.category_type, degree_has_categories.units,  degree_has_categories.min_gpa " +
            "HAVING (SUM(has_taken.units) >= degree_has_categories.units) AND ((SUM(has_taken.units * grade_conversion.number_grade)/SUM(has_taken.units)) >= degree_has_categories.min_gpa) ";
        String formattedQuery = String.format(query, department, ssn);
        // System.out.println(formattedQuery);

        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        dbConn.executeQuery(formattedQuery);
        ResultSet rs = dbConn.getResultSet();

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
        }

        return jsonArray;
    }

    private JsonObject degreeRemainingUnits(Integer ssn, String department) {
        String query =
            "SELECT (degree.total_units - SUM(has_taken.units)) AS remaining_units " +
            "FROM degree, student " +
            "JOIN has_taken " +
            "    ON student.studentID = has_taken.studentID " +
            "WHERE degree.deg_type = 'MS' AND degree.dept_name = '%s' AND student.ssn = %d AND has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D,S}') " +
            "GROUP BY degree.total_units";
        String formattedQuery = String.format(query, department, ssn);

        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        dbConn.executeQuery(formattedQuery);
        ResultSet rs = dbConn.getResultSet();

        Gson gson = new Gson();
        JsonObject obj = new JsonObject();

        try {
            rs.next();
            obj.addProperty("remaining_units", rs.getInt("remaining_units"));
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return obj;
    }

    private JsonArray categoryRemaining(Integer ssn, String department) {
        String query =
            "SELECT degree_has_categories.category_type AS category, (degree_has_categories.units - SUM(has_taken.units)) AS remaining_units, " +
            "    degree_has_categories.min_gpa AS min_gpa, (SUM(has_taken.units * grade_conversion.number_grade)/SUM(has_taken.units)) as current_gpa " +
            "FROM degree_has_categories " +
            "JOIN category_has_courses " +
            "    ON degree_has_categories.dept_name = category_has_courses.department AND category_has_courses.category_type = degree_has_categories.category_type " +
            "JOIN has_taken " +
            "    ON category_has_courses.courseID = has_taken.courseID " +
            "JOIN student " +
            "    ON has_taken.studentID = student.studentID " +
            "JOIN grade_conversion " +
            "    ON has_taken.grade = grade_conversion.letter_grade " +
            "WHERE degree_has_categories.deg_type = 'MS' AND degree_has_categories.dept_name = '%s' AND student.ssn = %d AND has_taken.grade = ANY ('{A+,A,A-,B+,B,B-,C+,C,C-,D,S}') " +
            "GROUP BY degree_has_categories.category_type, degree_has_categories.units, degree_has_categories.min_gpa " +
            "HAVING (((degree_has_categories.units - SUM(has_taken.units)) > 0) OR ((SUM(has_taken.units * grade_conversion.number_grade)/SUM(has_taken.units)) < min_gpa))";
        String formattedQuery = String.format(query, department, ssn);

        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        dbConn.executeQuery(formattedQuery);
        ResultSet rs = dbConn.getResultSet();

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
        }

        return jsonArray;
    }
}
