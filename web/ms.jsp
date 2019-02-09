<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/6/19
  Time: 7:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MS Entry Form</title>
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
    <form name="msInfo" stype="width:300px" action = "/ms_info" method = "post">
        <div class="form-group">
            <label>Department</label>
            <input type="dept" class="form-control" name="dept">
        </div>
        <button type="submit" class="btn btn-primary" name="button" value=<%=studentID %>>Next</button>
    </form>
</div>
</body>
</html>

