<%@ page import="main.DBConn" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/23/19
  Time: 11:24 AM
  To change this template use File | Settings | File Templates.

  Check remaining degree requirements for a student and a
  degree type
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

    <title>Degree Requirements</title>
</head>
<body>
    <jsp:include page="menu.jsp"/>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">Category Types</th>
            <th>Remaining Units</th>
        </tr>
        </thead>

    <tbody>
    <%
        int current_units;
        String ssn = (String) request.getAttribute("ssn");
        String dept_name = (String) request.getAttribute("dept_name");
        System.out.println("department name " + dept_name);
        DBConn dbConn = new DBConn();
        dbConn.openConnection();

        // compute what the student already has
        String view1 = "SELECT category_has_courses.department, category_has_courses.category_type, sum(h2.units) as sum\n" +
                "INTO fullfilled_reqs\n" +
                "FROM (student join has_taken h2 on student.studentid = h2.studentid)\n" +
                "  join category_has_courses on category_has_courses.courseid = h2.courseid\n" +
                "where student.ssn =?\n" +
                "group by category_has_courses.category_type, category_has_courses.department\n" +
                "HAVING category_has_courses.department =?";

        PreparedStatement stmt = dbConn.getPreparedStatment(view1);
        stmt.setInt(1, Integer.parseInt(ssn));
        stmt.setString(2, dept_name);
        stmt.executeUpdate();

        // compute the table for degree requirement based by department name
        // here BS is hardcoded as the specification says this query only needs to help undergrads
        // meaning that they are getting BS degree
        String view2 = "SELECT category2.dept_name, category2.category_type, category2.units INTO degree_reqs\n" +
                "FROM degree join degree_has_categories category2 on degree.dept_name = category2.dept_name and degree.deg_type = category2.deg_type\n" +
                "where degree.dept_name =? and degree.deg_type = 'BS'";
        stmt = dbConn.getPreparedStatment(view2);
        stmt.setString(1, dept_name);
        stmt.executeUpdate();

        String view3 = "SELECT degree_reqs.category_type, COALESCE(degree_reqs.units - fullfilled_reqs.sum, degree_reqs.units) as remt\n" +
                "INTO results FROM degree_reqs left join fullfilled_reqs\n" +
                "    on degree_reqs.category_type = fullfilled_reqs.category_type";
        Statement st = dbConn.getStatement();
        st.execute(view3);

        // display results
        String query = "SELECT * FROM results";
        dbConn.executeQuery(query);
        ResultSet rs = dbConn.getResultSet();
        current_units = 0;
        while (rs.next()){
            current_units += rs.getInt("remt"); %>
            <tr>
                <td scope="row"><%=rs.getString("category_type")%></td>
                <td><%=rs.getInt("remt")%></td>
            </tr>
    <% }
    %>
    </tbody>
    </table>
    <%
        String clean_up = "DROP TABLE fullfilled_reqs, degree_reqs, results";
        st = dbConn.getStatement();
        st.execute(clean_up);
        rs.close();
        dbConn.closeConnections();
    %>
    <br>
    Remaining Units to Satisfy Degree Requirement: <%=current_units%>
</body>
</html>
