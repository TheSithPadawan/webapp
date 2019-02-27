<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
    <head>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

        <title>Textbook Entry Form</title>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <form action="/textbook" method="POST">
            <div class="container">
                <div class="form-group">
                    <label>ISBN</label>
                    <input type="number" name="isbn" class="form-control">
                </div>

                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" class="form-control">
                </div>

                <div class="form-group">
                    <label>Author</label>
                    <input type="text" name="author" class="form-control">
                </div>

                <input type="submit" id="btn_submit" value="Submit" class="btn btn-primary">
            </div>
        </form>
    </body>
</html>
