<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/20/19
  Time: 9:37 PM
  To change this template use File | Settings | File Templates.
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
<jsp:include page="menu.jsp"/>
<table class="table">
    <thead>
        <tr>
            <th scope="col">Course ID</th>
            <th scope="col">Course Title</th>
            <th scope="col">Section ID</th>
            <th scope="col">Quarter</th>
            <th scope="col">Year</th>
            <th scope="col">Units</th>
        </tr>
    </thead>
    <tbody>

<%
    String ssn = (String) request.getAttribute("ssn");
    System.out.println("ssn is " + ssn);
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT students_enrolled.studentid, class.title, has_sections.courseid, has_sections.sectionid,\n" +
            "  class.quarter, class.year, students_enrolled.units, students_enrolled.grading_option\n" +
            "  FROM students_enrolled INNER JOIN has_sections on students_enrolled.sectionid = has_sections.sectionid\n" +
            "  AND students_enrolled.quarter = has_sections.quarter AND students_enrolled.year = has_sections.year\n" +
            "  INNER JOIN student on student.studentid = students_enrolled.studentid\n" +
            "  INNER JOIN class on has_sections.courseid = class.courseid AND has_sections.quarter =\n" +
            "      class.quarter and has_sections.year = class.year\n" +
            "WHERE students_enrolled.quarter = 'WI' AND students_enrolled.year = 2019 AND student.ssn = ?";
    PreparedStatement stmt = dbConn.getPreparedStatment(query);
    stmt.setInt(1, Integer.parseInt(ssn));
    ResultSet rs = stmt.executeQuery();
    while (rs.next()){ %>
        <tr>
            <td scope="row"><%=rs.getString("courseid")%></td>
            <td><%=rs.getString("title")%></td>
            <td><%=rs.getString("sectionid")%></td>
            <td><%=rs.getString("quarter")%></td>
            <td><%=rs.getString("year")%></td>
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
