<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Materialized View - CPG</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>
        <table class="table table-hover">
            <thead>
            <tr>
                <th scope="col">Course ID</th>
                <th scope="col">Faculty Name</th>
                <th scope="col"># of A</th>
                <th scope="col"># of B</th>
                <th scope="col"># of C</th>
                <th scope="col"># of D</th>
                <th scope="col"># of Other</th>
            </tr>
            </thead>
            <tbody>
                <%
                    DBConn dbConn = new DBConn();
                    dbConn.openConnection();
                    String query = "SELECT * FROM cpg";
                    dbConn.executeQuery(query);
                    ResultSet rs = dbConn.getResultSet();
                    while (rs.next()){
                %>
                <tr>
                    <td scope="row"><%=rs.getString("courseid")%></td>
                    <td><%=rs.getString("faculty_name")%></td>
                    <td><%=rs.getString("a")%></td>
                    <td><%=rs.getString("b")%></td>
                    <td><%=rs.getString("c")%></td>
                    <td><%=rs.getString("d")%></td>
                    <td><%=rs.getString("other")%></td>
                </tr>
            </tbody>
            <% }
            %>
        </table>

        <%
            rs.close();
            dbConn.closeConnections();
        %>

        <script>
            setInterval(() => {
                location.reload();
            }, 1000);
        </script>
    </body>
</html>
