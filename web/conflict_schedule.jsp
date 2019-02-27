<%@ page import="main.DBConn" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/26/19
  Time: 12:29 PM
  To change this template use File | Settings | File Templates.

  Use this page to display conflicted schedule
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

    <title>Schedule Conflicts</title>

<body>
<jsp:include page="index.jsp"/>
<table class="table">
    <thead>
    <tr>
        <th scope="col">Course ID</th>
        <th scope="col">Section ID</th>
        <th scope="col">Course Title</th>
    </tr>
    </thead>
    <tbody>

    <%
        String ssn = (String) request.getAttribute("ssn");
        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        // this creates a view for a student's current schedule
        String view1 = "SELECT has_sections.courseid, has_sections.sectionid, has_weekly_meetings.day, has_weekly_meetings.time_start,\n" +
                "  has_weekly_meetings.time_end INTO current_schedule\n" +
                "FROM students_enrolled inner join has_sections on students_enrolled.sectionid = has_sections.sectionid\n" +
                "JOIN has_weekly_meetings on students_enrolled.sectionid = has_weekly_meetings.sectionid\n" +
                "  JOIN student on student.studentid = students_enrolled.studentid\n" +
                "where has_sections.quarter = 'WI' and has_sections.year = 2019 and student.ssn = ?";
        PreparedStatement stmt = dbConn.getPreparedStatment(view1);
        stmt.setInt(1, Integer.parseInt(ssn));
        stmt.executeUpdate();

        // this creates a view of the schedule for all classes offered in current quarter
        String view2 = "SELECT has_sections.courseid, has_sections.sectionid, has_weekly_meetings.day, has_weekly_meetings.time_start,\n" +
                "  has_weekly_meetings.time_end INTO class_schedule\n" +
                "  FROM has_sections INNER JOIN has_weekly_meetings on has_sections.sectionid = has_weekly_meetings.sectionid\n" +
                "WHERE has_sections.quarter = 'WI' and has_sections.year = 2019";
        Statement st = dbConn.getStatement();
        st.execute(view2);

        // this creates a view of the schedule for all classes that the student is not taking this quarter
        String view3 = "SELECT class_schedule.* INTO not_taking\n" +
                "  FROM class_schedule\n" +
                "WHERE NOT EXISTS (\n" +
                "  SELECT * FROM current_schedule WHERE current_schedule.courseid = class_schedule.courseid\n" +
                ")";
        st = dbConn.getStatement();
        st.execute(view3);

        // this returns the result of conflicting class schedule (courseid, sectionid, title)
        String query = "SELECT not_taking.courseid, not_taking.sectionid, class.title\n" +
                "  FROM current_schedule INNER JOIN not_taking on not_taking.day = current_schedule.day\n" +
                "  AND not_taking.time_start < current_schedule.time_end AND not_taking.time_end > current_schedule.time_start\n" +
                "  INNER JOIN class on not_taking.courseid = class.courseid AND class.quarter = 'WI' and class.year = 2019\n" +
                "  GROUP BY not_taking.courseid, not_taking.sectionid, class.title";
        stmt = dbConn.getPreparedStatment(query);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()){
    %>
    <tr>
        <td scope="row"><%=rs.getString("courseid")%></td>
        <td><%=rs.getString("sectionid")%></td>
        <td><%=rs.getString("title")%></td>
    </tr>
    <% }
    %>
    </tbody>
</table>
<%
    String clean_up = "DROP TABLE current_schedule, not_taking, class_schedule";
    st = dbConn.getStatement();
    st.execute(clean_up);
    rs.close();
    dbConn.closeConnections();
%>
</body>
</html>
