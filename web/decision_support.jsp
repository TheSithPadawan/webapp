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

        <title>Decision Support</title>
    </head>

    <%
        String metric = (request.getParameter("metric"));
        if (metric == null || metric.isEmpty()) {
            metric = null;
        }
        String courseID = (request.getParameter("courseID"));
        if (courseID == null || courseID.isEmpty()) {
            courseID = null;
        }
        String professor = (request.getParameter("professor"));
        if (professor == null || professor.isEmpty()) {
            professor = null;
        }
        String quarter = (request.getParameter("quarter"));
        if (quarter == null || quarter.isEmpty()) {
            quarter = null;
        }
        String yearStr = (request.getParameter("year"));
        if (yearStr == null || yearStr.isEmpty()) {
            yearStr = null;
        }
        Integer year = null;
        if (yearStr != null) {
            year = Integer.parseInt(yearStr);
        }

        DBConn dbConnCourse = new DBConn();
        dbConnCourse.openConnection();
        String queryCourse = "SELECT * FROM course";
        dbConnCourse.executeQuery(queryCourse);
        ResultSet rsCourse = dbConnCourse.getResultSet();

        DBConn dbConnProf = null;
        ResultSet rsProf = null;
        if (courseID != null) {
            dbConnProf = new DBConn();
            dbConnProf.openConnection();
            String queryProf = String.format("SELECT * FROM faculty_taught WHERE courseID='%s'", courseID);
            dbConnProf.executeQuery(queryProf);
            rsProf = dbConnProf.getResultSet();
        }

        DBConn dbConnQtr = null;
        ResultSet rsQtr = null;
        if (courseID != null && professor != null) {
            dbConnQtr = new DBConn();
            dbConnQtr.openConnection();
            String queryQtr = String.format("SELECT * FROM faculty_taught WHERE courseID='%s' AND faculty_name='%s'", courseID, professor);
            dbConnQtr.executeQuery(queryQtr);
            rsQtr = dbConnQtr.getResultSet();
        }
    %>

    <script>
        const paramMetric = <% if (metric == null) {out.print("null");} else {out.print("'" + metric + "'");} %>;

        const paramCourseID = <% if (courseID == null) {out.print("null");} else {out.print("'" + courseID + "'");} %>;

        const paramProfessor = <% if (professor == null) {out.print("null");} else {out.print("'" + professor + "'");} %>;

        const paramQuarter = <% if (quarter == null) {out.print("null");} else {out.print("'" + quarter + "'");} %>;

        const paramYear = <% if (year == null) {out.print("null");} else {out.print(year);} %>;
    </script>

    <body>
        <jsp:include page="index.jsp"/>

        <div class="container">
            <label>Metric</label>
            <select id="select_metric" class="form-control">
                <option value="Letter">Letter</option>
                <option value="GPA">GPA</option>
            </select>
            <br>

            <label>Course ID</label>
            <select id="select_courseid" class="form-control">
                <option value="" selected>Select a value</option>
                <% while (rsCourse.next()) { %>
                    <option value="<%=rsCourse.getString("courseID")%>"><%=rsCourse.getString("courseID")%></option>
                <% } %>
            </select>
            <br>

            <label>Professor</label>
            <select id="select_professor" class="form-control">
                <option value="" selected>Select a value</option>
                <% while (rsProf != null && rsProf.next()) { %>
                    <option value="<%=rsProf.getString("faculty_name")%>"><%=rsProf.getString("faculty_name")%></option>
                <% } %>
            </select>
            <br>

            <label>Quarter/Year</label>
            <select id="select_qtr" class="form-control">
                <option value="" selected>Select a value</option>
                <% while (rsQtr != null && rsQtr.next()) { %>
                    <option value="<%=rsQtr.getString("quarter")%> <%=rsQtr.getString("year")%>"><%=rsQtr.getString("quarter")%> <%=rsQtr.getString("year")%></option>
                <% } %>
            </select>
            <br>

            <input type="button" onclick="submit()" value="Submit" class="btn btn-primary">

            <br><br>

            <pre><code id="code_output"></code></pre>
        </div>

        <script>
            const selectMetric = document.getElementById('select_metric');
            const selectCourseID = document.getElementById('select_courseid');
            const selectProf = document.getElementById('select_professor');
            const selectQtr = document.getElementById('select_qtr');
            const codeOutput = document.getElementById('code_output');

            let prevResult = localStorage.getItem('prevResult');
            if (prevResult !== null) {
                codeOutput.innerText = prevResult;
                prevResult = null;
                localStorage.removeItem('prevResult');
            }

            $(document).ready(function() {
                if (paramMetric !== null) {
                    selectMetric.value = paramMetric;

                    if (paramMetric === 'GPA') {
                        selectQtr.value = '';
                        selectQtr.disabled = true;
                    }
                }

                if (paramCourseID !== null) {
                    selectCourseID.value = paramCourseID;
                }

                if (paramProfessor !== null) {
                    selectProf.value = paramProfessor;
                }

                if (paramQuarter !== null && paramYear !== null) {
                    selectQtr.value = paramQuarter + ' ' + paramYear;
                }
            });

            function submit() {
                let metric = selectMetric.value;
                let courseID = selectCourseID.value;
                let prof = selectProf.value;
                let qtrYearArr = selectQtr.value.split(' ');
                let quarter = qtrYearArr[0];
                let year = qtrYearArr[1];

                let bodyStr = $.param({
                    'metric': metric,
                    'courseID': courseID,
                    'professor': prof,
                    'quarter': quarter,
                    'year': year,
                });
                console.log(bodyStr);

                fetch ('/decision_support?' + bodyStr, {
                    'method': 'GET',
                    'headers': {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    'redirect': 'manual'
                })
                .then((response) => {
                    if (response.status === 200 && response.ok) {
                        return response.json();
                    } else {
                        alert('Something went wrong. Check your values.');
                    }
                })
                .then((json) => {
                    console.log(JSON.stringify(json));
                    localStorage.setItem('prevResult', JSON.stringify(json, undefined, 4));
                    location.href = 'decision_support.jsp?' + bodyStr;
                });
            }
        </script>
    </body>
</html>