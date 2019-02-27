<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %><%--
  Use this page to view enrolled students for quarter
  this will link to checking the conflicted schedule
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

    <title>Enrolled Students</title>
</head>
<body>
<jsp:include page="menu.jsp"/>
<%
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT\n" +
            "student.studentid, student.ssn, student.firstname, student.middlename, student.lastname\n" +
            "FROM student WHERE student.enrollment = True";
    dbConn.executeQuery(query);
    ResultSet rs = dbConn.getResultSet();
%>

<form action="/grade_report" method="post" name="form1" id="form1">
    <div class="container">
        <div class="form-group">
            <label>Currently Enrolled Students</label>
            <select name="get_student" class="form-control">
                <% while (rs.next()) { %>
                <option value="<%=rs.getString("ssn")%>"><%=rs.getString("ssn")%> | <%=rs.getString("firstname")%>
                    | <%=rs.getString("middlename")%> | <%=rs.getString("lastname")%></option>
                <% } %>
            </select>
        </div>
        <input type="submit" name="check_schedule" class="btn btn-primary" value="Check Schedule Conflict">
    </div>
</form>

</body>
</html>
