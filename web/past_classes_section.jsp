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
            String studentID = request.getParameter("studentID");
            String courseID = request.getParameter("courseID");
            String quarter = request.getParameter("quarter");
            String year = request.getParameter("year");

            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM has_sections WHERE courseID='" + courseID + "' AND quarter='" + quarter + "'::quarter_enum AND year=" + year;
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();

            DBConn dbConnCourse = new DBConn();
            dbConnCourse.openConnection();
            String queryCourse = "SELECT * FROM course WHERE courseID='" + courseID + "'";
            dbConnCourse.executeQuery(queryCourse);
            ResultSet rsCourse = dbConnCourse.getResultSet();
            rsCourse.next();
        %>

        <script>
            const studentID = '<%=studentID%>';
            const courseID = '<%=courseID%>';
            const quarter = '<%=quarter%>';
            const year = '<%=year%>';
        </script>

        <br>

        <div class="container">
            <b>Choose course, class, quarter, and year</b>
            <div class="form-group">
                <label>Section ID</label>
                <select id="select_sectionID" class="form-control">
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("sectionID")%>"><%=rs.getString("sectionID")%></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Units</label>
                <input oninput="validate()" type="number" id="input_units" min="<%=rsCourse.getInt("units_min")%>" max="<%=rsCourse.getInt("units_max")%>">
            </div>

            <div class="form-group">
                <label>Grading Option</label>
                <select id="select_option" class="form-control">
                    <option value="Letter">Letter</option>
                    <option value="S/U">S/U</option>
                </select>
            </div>

            <div class="form-group">
                <label>Grade</label>
                <input oninput="validate()" id="input_grade" type="text" maxlength="2">
            </div>

            <input onclick="submit()" id="btn_submit" type="button" class="btn btn-primary" value="Submit" disabled>
        </div>

        <script>
            const selectSection = document.getElementById('select_sectionID');
            const inputUnits = document.getElementById('input_units');
            const selectOption = document.getElementById('select_option');
            const inputGrade = document.getElementById('input_grade');
            const btnSubmit = document.getElementById('btn_submit');

            function validate() {
                let units = inputUnits.value;
                let grade = inputGrade.value;
                if (units === '' || grade === '') {
                    btnSubmit.disabled = true;
                    return;
                }

                btnSubmit.disabled = false;
            }

            function submit() {
                let section = selectSection.value;
                let option = selectOption.value;
                let grade = inputGrade.value;
                let units = inputUnits.value;

                let bodyStr = $.param({
                    'studentID': studentID,
                    'courseID': courseID,
                    'sectionID': section,
                    'quarter': quarter,
                    'year': year,
                    'option': option,
                    'grade': grade,
                    'units': units
                });
                console.log(bodyStr);

                fetch('/past_class', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'manual',
                    body: bodyStr
                }).then((response) => {
                    window.location.href = '/past_classes.jsp';
                });
            }
        </script>
    </body>
</html>
