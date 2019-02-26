<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/22/19
  Time: 11:25 PM
  To change this template use File | Settings | File Templates.
  Use this page to view all students and select a student to compute GPA
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

    <title>All Students</title>
</head>
<body>
    <jsp:include page="index.jsp"/>
    <%
        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        String query = "SELECT\n" +
                "student.studentid, student.ssn, student.firstname, student.middlename, student.lastname\n" +
                "FROM student";
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

            <%
                query = "SELECT * FROM degree";
                dbConn.executeQuery(query);
                rs = dbConn.getResultSet();
            %>

                <div class="form-group">
                    <label>Degree Selections</label>
                    <select name="get_degree" class="form-control">
                        <% while (rs.next()) { %>
                        <option value="<%=rs.getString("dept_name")%>"><%=rs.getString("dept_name")%> | <%=rs.getString("deg_type")%></option>
                        <% } %>
                    </select>
                </div>

            <input type="submit" name="check_grade" class="btn btn-primary" value="Check Grade Report">
            <input type="submit" name="check_degree" class="btn btn-primary" value="Check Graduation Requirement">
        </div>
    </form>

</body>
</html>
