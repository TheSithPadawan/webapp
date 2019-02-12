<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/8/19
  Time: 11:47 PM
  To change this template use File | Settings | File Templates.

  Use this form to add faculty to database
--%>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<jsp:include page="index.jsp"/>

<form action = "/faculty_info" method = "post">
    <div class="container">
        <div class="form-group">
            <label>Faculty Name</label>
            <input class="form-control" name="facultyName">
        </div>
        <div class="form-group">
            <label>Department</label>
            <input class="form-control" name="dept">
        </div>
        <div class="form-group">
            <label>Title</label>
            <input class="form-control" name="title">
        </div>
    </div>
    <button class="btn btn-primary" id="submit_btn">Submit</button>
</form>

