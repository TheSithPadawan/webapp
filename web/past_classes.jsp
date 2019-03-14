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

        <title>Grade Entry Form</title>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM class";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();

            DBConn dbConn2 = new DBConn();
            dbConn2.openConnection();
            String query2 = "SELECT * FROM student";
            dbConn2.executeQuery(query2);
            ResultSet rs2 = dbConn2.getResultSet();
        %>
        <br>

        <div class="container">
            <b>Choose student, course, class, quarter, and year</b>
            <br>
            <div class="form-group">
                <label>Student ID</label>
                <select id="select_studentID" class="form-control">
                    <% while (rs2.next()) { %>
                        <option value="<%=rs2.getString("studentID")%>"><%=rs2.getString("studentID")%></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Course ID</label>
                <select id="select_courseID" class="form-control">
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("courseID") + " | " + rs.getString("quarter") + " | " + rs.getString("year")%>"> <%=rs.getString("courseID") + " | " + rs.getString("quarter") + " | " + rs.getString("year")%> </option>
                    <% } %>
                </select>
            </div>

            <input id="btn_submit" type="button" class="btn btn-primary" onclick="submit()" value="Submit">
        </div>

        <script>
            const selectStudent = document.getElementById('select_studentID');
            const selectCourse = document.getElementById('select_courseID');
            const btnSubmit = document.getElementById('btn_submit');

            function submit() {
                let student = selectStudent.value;
                let course = selectCourse.value;
                let arr = course.split(' | ');
                let courseID = arr[0];
                let quarter = arr[1];
                let year =  arr[2];
                let bodyStr = $.param({
                    'studentID': student,
                    'courseID': courseID,
                    'quarter': quarter,
                    'year': year
                });
                console.log(bodyStr);

                window.location.href = '/past_classes_section.jsp?' + bodyStr;
            }
        </script>
    </body>
</html>
