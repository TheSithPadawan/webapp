<%@ page import="main.DBConn" %>
<%@ page import="java.sql.PreparedStatement" %>
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

        <title>Course Entry Form</title>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM course";
            PreparedStatement stmt = dbConn.getScrollableReadOnlyPreparedStatment(query);
            ResultSet rs = stmt.executeQuery();
        %>

        <script>
            const courseArr = [];
            <% while (rs.next()) { %>
                courseArr.push('<%=rs.getString("courseID")%>');
            <% }
                rs.beforeFirst();
            %>
        </script>

        <div class="container">
            <div class="form-group">
                <label>Course ID:</label>
                <input type="text" id="input_courseid" name="courseID" class="form-control">
            </div>

            <div class="form-group">
                <label>Lab</label>
                <input type="checkbox" id="check_lab" name="lab" class="form-check-input">
            </div>

            <div class="form-group">
                <label>Min Units</label>
                <input type="number" id="input_min_units" name="units_min" class="form-control">
            </div>

            <div class="form-group">
                <label>Max Units</label>
                <input type="number" id="input_max_units" name="units_max" class="form-control">
            </div>

            <div class="form-group">
                <label>Grading Option</label>
                <select id="select_option" name="grading_option" class="form-control">
                    <option value="Letter">Letter</option>
                    <option value="S/U">S/U</option>
                    <option value="Both">Both</option>
                </select>
            </div>

            <div class="form-group">
                <label>Consent</label>
                <input type="checkbox" id="check_consent" name="consent" class="form-check-input">
            </div>

            <div class="form-group">
                <label>Department</label>
                <input type="text" id="input_department" name="department" class="form-control">
            </div>

            <div class="form-group">
                <label>Prerequisite Courses (hold Ctrl to select multiple)</label>
                <select name="courseID" class="form-control" id="select_pre" multiple>
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("courseID")%>"><%=rs.getString("courseID")%></option>
                    <% }
                        rs.beforeFirst();
                    %>
                </select>
            </div>

            <input type="button" id="btn_submit" value="Submit" class="btn btn-primary" onclick="submit()">
        </div>

        <script>
            const inputCourseID = document.getElementById('input_courseid');
            const inputLab = document.getElementById('check_lab');
            const inputMin = document.getElementById('input_min_units');
            const inputMax = document.getElementById('input_max_units');
            const inputOption = document.getElementById('select_option');
            const inputConsent = document.getElementById('check_consent');
            const inputDept = document.getElementById('input_department');
            const inputPre = document.getElementById('select_pre');
            const btnSubmit = document.getElementById('btn_submit');

            function submit() {
                let courseID = inputCourseID.value.trim();
                let lab = inputLab.checked;
                let min = inputMin.value;
                let max = inputMax.value;
                let option = inputOption.value;
                let consent = inputConsent.checked;
                let dept = inputDept.value;
                let preArr = [];
                let pres = inputPre.options;
                for (let pre of pres) {
                    if (pre.selected) {
                        preArr.push(pre.value);
                    }
                }

                if (courseID === '' || min === '' || max === '' || max < min ||
                    dept === '') {
                    alert('Invalid input.');
                    return;
                } else if (preArr.includes(courseID)) {
                    alert('Cannot have self as prerequisite.');
                    return;
                }

                let preStr = '';
                for (let i = 0; i < preArr.length; i++) {
                    preStr += preArr[i];
                    if (i !== preArr.length - 1) {
                        preStr += '|';
                    }
                }

                let bodyStr = $.param({
                    'courseID': courseID,
                    'lab': lab,
                    'units_min': min,
                    'units_max': max,
                    'consent': consent,
                    'department': dept,
                    'grading_option': option,
                });

                if (preStr !== '') {
                    preStr = $.param({
                        'prereqs': preStr
                    });

                    bodyStr += '&' + preStr;
                }

                console.log(bodyStr);

                fetch('/course', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'manual',
                    body: bodyStr
                }).then((response) => {
                    location.href = 'course_entry_category.jsp';
                });
            }
        </script>
    </body>
</html>
