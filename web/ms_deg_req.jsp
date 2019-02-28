<%@ page import="main.DBConn" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

    <title>MS Requirements</title>
</head>

<%
    DBConn dbConnStudent = new DBConn();
    dbConnStudent.openConnection();
    String queryStudent = "SELECT * FROM student JOIN ms ON student.studentID = ms.studentID";
    dbConnStudent.executeQuery(queryStudent);
    ResultSet rsStudent = dbConnStudent.getResultSet();

    DBConn dbMs = new DBConn();
    dbMs.openConnection();
    String queryMs = "SELECT * FROM degree WHERE deg_type = 'MS'";
    dbMs.executeQuery(queryMs);
    ResultSet rsMs = dbMs.getResultSet();
%>

<body>
    <jsp:include page="menu.jsp"/>

    <div class="container">
        <label>Student</label>
        <select id="select_student" class="form-control">
            <option value="" selected>Select a student</option>
            <% while (rsStudent.next()) {
                String first = rsStudent.getString("firstName");
                String middle = rsStudent.getString("middleName");
                String last = rsStudent.getString("lastName");
                String full = null;
                if (middle == null) {
                    full = first + " " + last;
                } else {
                    full = first + " " + middle + " " + last;
                }
                Integer ssn = rsStudent.getInt("ssn");
                %>
                <option value="<%=ssn%>"><%=full%></option>
            <% } %>
        </select>
        <br>

        <label>MS Degrees</label>
        <select id="select_ms" class="form-control">
            <option value="" selected>Select a MS degree</option>
            <% while (rsMs.next()) { %>
                <option value="<%=rsMs.getString("dept_name")%>"><%=rsMs.getString("dept_name")%></option>
            <% } %>
        </select>
        <br>

        <input id="btn_submit" type="button" value="Submit" class="btn btn-primary" onclick="submit()">
        <hr>

        <label>Remaining categories</label>
        <samp><pre id="pre_remaining_cat"></pre></samp>
        <br>

        <label>Remaining degree units</label>
        <samp><pre id="pre_remaining_deg"></pre></samp>
        <br>

        <label>Finished categories</label>
        <samp><pre id="pre_finished_cat"></pre></samp>
        <br>

        <label>Upcoming courses</label>
        <samp><pre id="upcoming_cat_courses"></pre></samp>

    </div>

    <script>
        const selectStudent = document.getElementById('select_student');
        const selectMs = document.getElementById('select_ms');
        const preRemainingCat = document.getElementById('pre_remaining_cat');
        const preRemainingDeg = document.getElementById('pre_remaining_deg');
        const preFinishedCat = document.getElementById('pre_finished_cat');
        const preUpcomingCatCourses = document.getElementById('upcoming_cat_courses');

        function view_grad() {
            let ssn = selectStudent.value;
            let ms = selectMs.value;

            if (ssn === '' || ms === '') {
                alert('Check your input.');
                return;
            }

            let bodyStr = $.param({
                'ssn': ssn,
                'dept_name': ms
            });
            console.log(bodyStr);

            location.href = 'ms_deg_req_units.jsp?' + bodyStr;
        }

        function submit() {
            preFinishedCat.innerText = '';
            preUpcomingCatCourses.innerText = '';

            let ssn = selectStudent.value;
            let ms = selectMs.value;

            if (ssn === '' || ms === '') {
                alert('Check your input.');
                return;
            }

            let bodyStr = $.param({
                'ssn': ssn,
                'department': ms
            });
            console.log(bodyStr);

            fetch('/ms_degree_requirements?' + bodyStr, {
                'method': 'GET',
                'headers': {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                'redirect': 'manual'
            })
            .then((response) => {
                if (response.ok) {
                    return response.json();
                } else {
                    alert('Check your input.');
                }
            })
            .then((json) => {
                console.log(JSON.stringify(json));
                let upcoming = json['upcoming_courses'];
                let upcomingStr = JSON.stringify(upcoming, undefined, 4);
                let finished = json['completed_categories'];
                let finishedStr = JSON.stringify(finished, undefined, 4);
                let catRemaining = json['category_remaining'];
                let catRemainingStr = JSON.stringify(catRemaining, undefined, 4);
                let degRemaining = json['degree_remaining_units'];
                let degRemainingStr = JSON.stringify(degRemaining, undefined, 4);

                preRemainingCat.innerText = catRemainingStr;
                preRemainingDeg.innerText = degRemainingStr;
                preFinishedCat.innerText = finishedStr;
                preUpcomingCatCourses.innerText = upcomingStr;
            });
        }
    </script>
</body>
</html>
