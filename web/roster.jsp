<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/21/19
  Time: 10:28 PM
  To change this template use File | Settings | File Templates.

  Use this to display the roster for a class
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

    <title>All Classes</title>
</head>

<body>
<jsp:include page="index.jsp"/>
<table class="table">
    <thead>
        <tr>
            <th scope="col">Student SSN</th>
            <th scope="col">Student ID</th>
            <th scope="col">First Name</th>
            <th scope="col">Middle Name</th>
            <th scope="col">Last Name</th>
            <th scope="col">Residency</th>
            <th scope="col">Grading Option</th>
            <th scope="col">Units</th>
    </tr>
    </thead>
    <tbody>

<%
    String classTitle = (String) request.getAttribute("title");
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT student.ssn, student.studentid, student.firstname, student.middlename, student.lastname, student.residency,\n" +
            "  students_enrolled.grading_option, students_enrolled.units\n" +
            "FROM class, students_enrolled, student, has_sections\n" +
            "where\n" +
            "  class.courseid = has_sections.courseid\n" +
            "and\n" +
            "  has_sections.sectionid = students_enrolled.sectionid\n" +
            "and\n" +
            "  student.studentid = students_enrolled.studentid\n" +
            "and\n" +
            "  class.title=?\n" +
            "and\n" +
            "  class.quarter = 'WI'\n" +
            "and\n" +
            "  class.year = 2019";
    PreparedStatement stmt = dbConn.getPreparedStatment(query);
    stmt.setString(1, classTitle);
    ResultSet rs = stmt.executeQuery();
    while (rs.next()){ %>
    <tr>
        <td scope="row"><%=rs.getInt("ssn")%></td>
        <td><%=rs.getString("studentid")%></td>
        <td><%=rs.getString("firstname")%></td>
        <td><%=rs.getString("middlename")%></td>
        <td><%=rs.getString("lastname")%></td>
        <td><%=rs.getString("residency")%></td>
        <td><%=rs.getString("grading_option")%></td>
        <td><%=rs.getInt("units")%></td>
    </tr>
<% }
%>
    </tbody>
</table>
<%
    rs.close();
    dbConn.closeConnections();
%>

</body>
</html>
