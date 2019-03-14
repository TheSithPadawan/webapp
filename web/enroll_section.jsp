<%@ page import="main.DBConn" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/11/19
  Time: 12:25 PM
  To change this template use File | Settings | File Templates.

  Usage: use this form to enroll a student to a specific section
  for current quarter
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
    <%
        String courseID = request.getParameter("courseid");
        String studentID = request.getParameter("studentid");
        String gradingOption = request.getParameter("gradingOption");
        System.out.println(courseID);
        DBConn dbConn = new DBConn();
        dbConn.openConnection();
        PreparedStatement stmt = dbConn.getPreparedStatment("SELECT sectionid FROM has_sections WHERE courseid = ? AND quarter=?::quarter_enum AND year=?");
        stmt.setString(1, courseID);
        stmt.setString(2, "WI");
        stmt.setInt(3, 2019);
        ResultSet rs = stmt.executeQuery();

        PreparedStatement numUnits = dbConn.getPreparedStatment("SELECT units_min, units_max FROM course WHERE courseid=?");
        numUnits.setString(1, courseID);
        ResultSet unitsResult = numUnits.executeQuery();
        int minUnit = 0, maxUnit = 0;
        while (unitsResult.next()){
            minUnit = unitsResult.getInt("units_min");
            maxUnit = unitsResult.getInt("units_max");
        }
    %>
    <form action="/section_enroll" method="post">
        <div class="container">
            <div class="form-group">
                <label>Sections</label>
                <select name="sectionID" id="sectionID">
                    <% while (rs.next()) {
                        System.out.println(rs.getString("sectionid"));
                    %>
                    <option value="<%=rs.getString("sectionid")%>"><%=rs.getString("sectionid")%></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Units</label>
                <select name="units" id="units">
                    <% for (int i = minUnit; i <= maxUnit; i++){
                        System.out.println(i);
                    %>
                    <option value="<%=i%>"><%=i%></option>
                    <% } %>
                </select>
            </div>
        </div>
        <button class="btn btn-primary" id="submit_btn">Submit</button>
    </form>
</body>
</html>

<script>
    const btn_submit = document.getElementById("submit_btn");
    btn_submit.addEventListener('click', (event) => {
        event.preventDefault();
        submit();
    });

    function submit() {
        let id = "<%=studentID%>";
        let course = "<%=courseID%>";
        let grade = "<%=gradingOption%>";
        const section = document.getElementById("sectionID").value;
        const units = document.getElementById("units").value;
        console.log(section);
        console.log(units);
        let jsonStr = {
            "studentID": id,
            "courseID": course,
            "grading": grade,
            "sectionID": section,
            "units": units
        }
        jsonStr = JSON.stringify(jsonStr);
        console.log(jsonStr);
        fetch('/section_enroll', {
            method: 'POST',
            body: jsonStr,
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then((response) => {
                if (!response.ok || response.statusCode !== 200) {
                    return response.text();
                } else {
                    // response from POST
                    window.location.href="/course_enrollment.jsp";
                    return undefined;
                }
            })
            .then((text) => {
                if (text === undefined) {
                    return;
                }

                console.error(text);

                alert('Enrollment failed:\n' + text);
            });
    }
</script>

