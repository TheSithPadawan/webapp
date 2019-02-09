<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/5/19
  Time: 10:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Undergrad Entry Form</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
</head>
<body>
<%
    String studentID = (String) request.getAttribute("studentid");
%>
<div class="alert alert-primary" role="alert">
    Fill out More Information For Student <%= studentID%>
</div>
<div class="container">
    <form name="undergradInfo" stype="width:300px" action = "/undergrad_info" method = "post">
        <div class="form-group">
            <label>Major</label>
            <input type="major" class="form-control" name="major">
        </div>
        <div class="form-group">
            <label>Minor</label>
            <input type="minor" class="form-control" name="minor">
        </div>
        <div class="form-group">
            <label>College</label>
            <input type="college" class="form-control" name="college">
        </div>
        <button type="submit" class="btn btn-primary" name="button" value=<%=studentID %>>Next</button>
    </form>
</div>
</body>
</html>
