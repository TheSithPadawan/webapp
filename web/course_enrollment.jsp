<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/9/19
  Time: 9:55 AM
  To change this template use File | Settings | File Templates.

  Use this form to enroll student to a course
--%>


<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>

<form action="/enroll" method="post">
    <div class="container">
        <div class="form-group">
            <label>StudentID</label>
            <input class="form-control" name="studentid">
        </div>
        <div class="form-group">
            <label>CourseID</label>
            <input class="form-control" name="courseid">
        </div>
        <div class="form-group">
            <label>Grading Option</label>
            <select class="form-control" name="gradingOption">
                <option value="letter">Letter</option>
                <option value="su">S/U</option>
                <option value="both">Both</option>
            </select>
        </div>
        <div class="form-group">
            <label>SectionID</label>
            <input class="form-control" name="sectionid">
        </div>
        <div class="form-group">
            <label>Units</label>
            <input class="form-control" name="units">
        </div>
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
</form>