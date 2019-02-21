<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/20/19
  Time: 1:58 PM
  To change this template use File | Settings | File Templates.

  Use this form to select student X who enrolled
  in the current quarter
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

        <title>Current Classes</title>
    </head>

    <body>
    <jsp:include page="index.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT\n" +
"  a.studentid, student.ssn, student.firstname, student.middlename, student.lastname\n" +
"FROM student\n" +
"JOIN attends a on student.studentid = a.studentid\n" +
"  where a.quarter = 'WI' and a.year = 2019";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();
        %>
    <form action="/current_class" method="post">
        <div class="container">
            <div class="form-group">
                <label>Currently Enrolled Students</label>
                <select name="student_ssn" class="form-control">
                    <% while (rs.next()) { %>
                    <option value="<%=rs.getString("ssn")%>"><%=rs.getString("ssn")%> | <%=rs.getString("firstname")%>
                    | <%=rs.getString("middlename")%> | <%=rs.getString("lastname")%></option>
                    <% } %>
                </select>
            </div>

            <input type="submit" class="btn btn-primary">
        </div>
    </form>
</body>
</html>
