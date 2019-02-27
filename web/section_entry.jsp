<%@ page import="main.DBConn" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Section Entry Form</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
        <script
                src="https://code.jquery.com/jquery-3.3.1.min.js"
                integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                crossorigin="anonymous"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
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
            String instrQuery = "SELECT * FROM faculty";
            dbConn2.executeQuery(instrQuery);
            ResultSet rsFaculty = dbConn2.getResultSet();
        %>

        <div class="container">
            <div class="form-group">
                <label>Class</label>
                <select id="select_courseID" class="form-control">
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("courseID") + " | " + rs.getString("quarter") + " | " + rs.getString("year")%>"> <%=rs.getString("courseID") + " | " + rs.getString("quarter") + " | " + rs.getString("year")%> </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Section ID</label>
                <input type="text" class="form-control" name="sectionID" id="input_sectionID" oninput="validate()">
            </div>

            <div class="form-group">
                <label>Enrollment Limit</label>
                <input type="number" class="form-control" name="enrollment_limit" id="input_enroll" oninput="validate()">
            </div>

            <div class="form-group">
                <label>Select faculty</label>
                <%-- <br>
                <a href="faculty.jsp">Add faculty</a> --%>
                <select id="select_faculty" class="form-control">
                    <% while (rsFaculty.next()) { %>
                        <option value="<%=rsFaculty.getString("name")%>"> <%= rsFaculty.getString("name") %> </option>
                    <% } %>
                </select>
            </div>

            <button type="button" class="btn btn-primary" id="btn_submit" onclick="submit()" disabled>Submit</button>

            <br><hr>

            <%--<div class="embed-responsive embed-responsive-16by9">--%>
              <%--<iframe id="iframe_faculty" src="faculty.jsp" class="embed-responsive-item"></iframe>--%>
            <%--</div>--%>
        </div>

        <script>
            const selectCourse = document.getElementById('select_courseID');
            const inputSection = document.getElementById('input_sectionID');
            const inputEnroll = document.getElementById('input_enroll');
            const selectFaculty = document.getElementById('select_faculty');
            const btnSubmit = document.getElementById('btn_submit');
            const iframeFaculty = document.getElementById('iframe_faculty');

            $(document).ready(() => {
                $(iframeFaculty).on('load', () => {
                    iframeFaculty.onload = (() => {
                        window.location.href = '/section_entry.jsp';
                    });
                });
            });

            function validate() {
                let section = inputSection.value;
                let enroll = inputEnroll.value;
                if (section === '' || enroll === '') {
                    btnSubmit.disabled = true;
                    return;
                }

                btnSubmit.disabled = false;
            }

            function submit() {
                let section = inputSection.value;
                let enroll = inputEnroll.value;
                let course = selectCourse.value;
                let arr = course.split(' | ');
                let courseID = arr[0];
                let quarter = arr[1];
                let year =  arr[2];
                let faculty = selectFaculty.value;
                let bodyStr = $.param({
                    'sectionID': section,
                    'enrollment_limit': enroll,
                    'courseID': courseID,
                    'quarter': quarter,
                    'year': year,
                    'faculty': faculty
                });
                console.log(bodyStr);

                fetch('/section', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'follow',
                    body: bodyStr
                }).then((response) => {
                    window.location.href = response.url;
                });
            }
        </script>
    </body>
</html>
