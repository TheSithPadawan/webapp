<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/12/19
  Time: 4:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <head>
        <title>Section Entry Form</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    </head>
</head>
<body>
<jsp:include page="index.jsp"/>

<form action = "/dept" method = "post">
    <div class="container">
        <div class="form-group">
            <label>Department</label>
            <input class="form-control" name="dept">
        </div>
        <button class="btn btn-primary" id="submit_btn">Submit</button>
    </div>
</form>

</body>
</html>
