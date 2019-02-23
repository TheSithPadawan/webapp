<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/22/19
  Time: 11:32 PM
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

    <title>Student Grade History</title>
</head>
<body>
<jsp:include page="index.jsp"/>

<%
   String ssn = (String) request.getAttribute("ssn");
   System.out.println("getting the grade report for student with ssn " + ssn);
%>
<table>
    <tr>
        <th>Course ID</th>
        <th>Section ID</th>
        <th>Quarter</th>
        <th>Year</th>
        <th>Grade</th>
        <th>Units</th>
    </tr>
    <%
        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        String query = "SELECT courseid, sectionid, quarter, year, grade, units\n" +
              "  FROM has_taken left join student on has_taken.studentid = student.studentid\n" +
              "where student.ssn = ?";
        PreparedStatement stmt = dbConn.getPreparedStatment(query);
        stmt.setInt(1, Integer.parseInt(ssn));
        ResultSet rs = stmt.executeQuery();
        while (rs.next()){ %>

    <tr>
        <td><%=rs.getString("courseid")%></td>
        <td><%=rs.getString("sectionid")%></td>
        <td><%=rs.getString("quarter")%></td>
        <td><%=rs.getString("year")%></td>
        <td><%=rs.getString("grade")%></td>
        <td><%=rs.getInt("units")%></td>
    </tr>
    <% }
    %>
</table>
<br>
<table>
    <tr>
        <th>Quarter</th>
        <th>Year</th>
        <th>GPA</th>
    </tr>
    <%
        query = "SELECT quarter, year, sum(has_taken.units * grade_conversion.number_grade)/sum(has_taken.units) as gpa\n" +
                "FROM (student join has_taken on student.studentid = has_taken.studentid)\n" +
                "left join grade_conversion\n" +
                "  on has_taken.grade = grade_conversion.letter_grade\n" +
                "where student.ssn = ? \n" +
                "GROUP BY has_taken.quarter, has_taken.year";
        stmt = dbConn.getPreparedStatment(query);
        stmt.setInt(1, Integer.parseInt(ssn));
        rs = stmt.executeQuery();
        while (rs.next()){ %>
    <tr>
        <td><%=rs.getString("quarter")%></td>
        <td><%=rs.getString("year")%></td>
        <td><%=rs.getFloat("gpa")%></td>
    </tr>
    <% }
    %>
</table>
<br>
<table>
    <tr>
        <th>Overall GPA</th>
    </tr>
    <%
        query = "SELECT sum(has_taken.units * grade_conversion.number_grade)/sum(has_taken.units) as gpa\n" +
                "FROM (student join has_taken on student.studentid = has_taken.studentid)\n" +
                "  left join grade_conversion\n" +
                "    on has_taken.grade = grade_conversion.letter_grade\n" +
                "where student.ssn = ?";
        stmt = dbConn.getPreparedStatment(query);
        stmt.setInt(1, Integer.parseInt(ssn));
        rs = stmt.executeQuery();
        while (rs.next()){ %>
    <tr>
        <td><%=rs.getFloat("gpa")%></td>
    </tr>
    <% }
    %>
</table>
</body>
</html>
