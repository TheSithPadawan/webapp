<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html>
    <head>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

        <title>Previous Course ID Entry Form</title>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM course";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();
        %>
        <br>
        <form action="/previous_courseid" method="post">
            <div class="container">
                <div class="form-group">
                    <label>Current Course ID</label>
                    <select name="courseID">
                        <% while (rs.next()) { %>
                            <option value="<%=rs.getString("courseID")%>"><%=rs.getString("courseID")%></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Previous Course ID</label>
                    <input type="text" class="form-control" name="prev_id">
                </div>

                <input type="submit" class="btn btn-primary">
            </div>
        </form>
    </body>
</html>
