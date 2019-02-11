<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
    <head>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

        <title>Course Entry Form</title>
    </head>

    <body>
        <jsp:include page="index.jsp"/>

        <form action="/course" method="POST">
            <div class="container">
                <div class="form-group">
                    <label>Course ID:</label>
                    <input type="text" id="new_courseid" name="courseID" class="form-control">
                </div>

                <div class="form-group">
                    <label>Lab</label>
                    <input type="checkbox" id="new_lab" name="lab" class="form-check-input">
                </div>

                <div class="form-group">
                    <label>Min Units</label>
                    <input type="number" id="new_min_units" name="units_min" class="form-control">
                </div>

                <div class="form-group">
                    <label>Max Units</label>
                    <input type="number" id="new_max_units" name="units_max" class="form-control">
                </div>

                <div class="form-group">
                    <label>Grading Option</label>
                    <select name="grading_option">
                        <option value="Letter">Letter</option>
                        <option value="S/U">S/U</option>
                        <option value="Both">Both</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Consent</label>
                    <input type="checkbox" id="new_consent" name="consent" class="form-check-input">
                </div>

                <div class="form-group">
                    <label>Department</label>
                    <input type="text" id="department" name="department" class="form-control">
                </div>

                <div class="form-group">
                    <label>Category</label>
                    <input type="text" id="category" name="category" class="form-control">
                </div>

                <input type="submit" id="btn_submit" value="Submit" class="btn btn-primary">
            </div>
        </form>
    </body>
</html>
