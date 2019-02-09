<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>


    <body>
        <jsp:include page="index.jsp"/>

        <form action="/course" method="POST">
            <table>
                <caption>New Course</caption>
                <tr>
                    <td>
                        <label>Course ID:</label>
                        <input type="text" id="new_courseid" name="courseID">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Lab</label>
                        <input type="checkbox" id="new_lab" name="lab">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Min Units</label>
                        <input type="number" id="new_min_units" name="units_min">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Max Units</label>
                        <input type="number" id="new_max_units" name="units_max">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Consent</label>
                        <input type="checkbox" id="new_consent" name="consent">
                    </td>
                </tr>

                <tr>
                    <td>
                        <input type="submit" id="btn_submit" value="Submit">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
