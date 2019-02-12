<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %><%--
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

<body>
<jsp:include page="index.jsp"/>

<%
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT * FROM course";
    dbConn.executeQuery(query);
    ResultSet rs = dbConn.getResultSet();
%>

<form action="/enroll" method="post">
    <div class="container">
        <div class="form-group">
            <label>StudentID</label>
            <input class="form-control" name="studentid" id="studentid">
        </div>
        <div class="form-group">
            <label>CourseID</label>
            <select name="courseid" id="courseid">
                <% while (rs.next()) { %>
                <option value="<%=rs.getString("courseID")%>"><%=rs.getString("courseID")%></option>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>Grading Option</label>
            <select class="form-control" name="gradingOption">
                <option value="Letter">Letter</option>
                <option value="S/U">S/U</option>
            </select>
        </div>
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
</form>
</body>