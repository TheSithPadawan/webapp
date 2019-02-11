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

        <title>Class Entry Form</title>
    </head>

    <body>
        <jsp:include page="index.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM course";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();
        %>

        <br>
        <form action="/class" method="post">
            <div class="container">
                <div class="form-group">
                    <label>Course ID</label>
                    <select name="courseID">
                        <% while (rs.next()) { %>
                            <option value="<%=rs.getString("courseID")%>"><%=rs.getString("courseID")%></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Title</label>
                    <input type="text" class="form-control" name="title">
                </div>

                <div class="form-group">
                    <label>Quarter</label>
                    <select class="form-control" name="quarter">
                        <option value="SP">Spring</option>
                        <option value="SU1">Summer Session 1</option>
                        <option value="SU2">Summer Session 2</option>
                        <option value="FA">Fall</option>
                        <option value="WI">Winter</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Year</label>
                    <input type="number" class="form-control" name="year">
                </div>

                <input type="submit" class="btn btn-primary">
            </div>
        </form>
    </body>
</html>
