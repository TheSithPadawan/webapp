<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/21/19
  Time: 10:19 PM
  To change this template use File | Settings | File Templates.

  This jsp displays all classes in the database
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
<jsp:include page="menu.jsp"/>
<%
    DBConn dbConn = new DBConn();
    dbConn.openConnection();
    String query = "SELECT courseid, title, quarter, year from class";
    dbConn.executeQuery(query);
    ResultSet rs = dbConn.getResultSet();
%>
<form action="/class_roster" method="post">
    <div class="container">
        <div class="form-group">
            <label>Currently Enrolled Students</label>
            <select name="class" class="form-control">
                <% while (rs.next()) { %>
                <option value="<%=rs.getString("title")%>"><%=rs.getString("courseid")%> | <%=rs.getString("title")%> | <%=rs.getString("quarter")%>
                    | <%=rs.getString("year")%></option>
                <% } %>
            </select>
        </div>

        <input type="submit" class="btn btn-primary">
    </div>
</form>
</body>
</html>
