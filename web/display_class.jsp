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
<jsp:include page="index.jsp"/>
<table>
<tr>
    <th>Course ID</th>
    <th>Course Title</th>
    <th>Section ID</th>
    <th>Quarter</th>
    <th>Year</th>
    <th>Units</th>
</tr>
<%
    String ssn = (String) request.getAttribute("ssn");
    System.out.println("ssn is " + ssn);
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT is_taking.courseid, students_enrolled.sectionid, class.title, is_taking.quarter, is_taking.year, students_enrolled.units\n" +
            "FROM is_taking, students_enrolled, class, student, has_sections\n" +
            "where is_taking.studentid = students_enrolled.studentid\n" +
            "      and\n" +
            "      is_taking.courseid = class.courseid\n" +
            "      and\n" +
            "      class.quarter = 'WI' and class.year = 2019\n" +
            "      and\n" +
            "      student.studentid = is_taking.studentid\n" +
            "      and\n" +
            "      has_sections.courseid = is_taking.courseid and has_sections.sectionid = students_enrolled.sectionid\n" +
            "      and student.ssn = ?";
    PreparedStatement stmt = dbConn.getPreparedStatment(query);
    stmt.setInt(1, Integer.parseInt(ssn));
    ResultSet rs = stmt.executeQuery();
    while (rs.next()){ %>
        <tr>
            <td><%=rs.getString("courseid")%></td>
            <td><%=rs.getString("title")%></td>
            <td><%=rs.getString("sectionid")%></td>
            <td><%=rs.getString("quarter")%></td>
            <td><%=rs.getString("year")%></td>
            <td><%=rs.getInt("units")%></td>
        </tr>
    <% }
    %>
</table>
<%
    rs.close();
    dbConn.closeConnections();
%>
</body>
</html>
