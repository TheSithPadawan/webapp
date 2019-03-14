<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 3/9/19
  Time: 9:52 AM
  To change this template use File | Settings | File Templates.
  Link student past grade to materialized view
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Materialized View -- Decision Support I</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <div class="form-check">
            <input id="check_autorefresh" type="checkbox" class="form-check-input">
            <label class="form-check-label" for="check_autorefresh">
                Auto refresh
            </label>
        </div>
        <br>

        <table class="table">
            <thead>
            <tr>
                <th scope="col">Course ID</th>
                <th scope="col">Faculty Name</th>
                <th scope="col">Quarter</th>
                <th scope="col">Year</th>
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
                    String query = "SELECT * FROM grade_aggregate";
                    dbConn.executeQuery(query);
                    ResultSet rs = dbConn.getResultSet();
                    while (rs.next()){
                %>
                <tr>
                    <td scope="row"><%=rs.getString("courseid")%></td>
                    <td><%=rs.getString("faculty_name")%></td>
                    <td><%=rs.getString("quarter")%></td>
                    <td><%=rs.getInt("year")%></td>
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
            const checkAutoRefresh = document.getElementById('check_autorefresh');
            let intervalId = undefined;

            $(document).ready(function() {
                let autoRefresh = localStorage.getItem('autoRefresh') === 'true' || localStorage.getItem('autoRefresh') === true;
                if (autoRefresh === null || autoRefresh === undefined || typeof autoRefresh !== 'boolean') {
                    autoRefresh = false;
                    localStorage.setItem('autoRefresh', false);
                }

                console.log('ready auto refresh: ', autoRefresh);
                if (autoRefresh) {
                    intervalId = setInterval(() => {
                        location.reload();
                    }, 2000);
                }

                checkAutoRefresh.checked = autoRefresh;

                checkAutoRefresh.addEventListener('change', (event) => {
                    console.log('event listener auto refresh: ', event.target.checked);
                    localStorage.setItem('autoRefresh', event.target.checked);
                    if (event.target.checked) {
                        intervalId = setInterval(() => {
                            console.log('refreshing');
                            location.reload();
                        }, 2000);
                    } else {
                        clearInterval(intervalId);
                        intervalId = undefined;
                    }
                });
            });
        </script>
    </body>
</html>
