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

        <title>Review Session Scheduling</title>
    </head>

    <body>
        <jsp:include page="menu.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM has_sections WHERE quarter='WI'::quarter_enum AND year=2019";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();
        %>

        <div class="container">
            <div class="form-group">
                <label>Course and Sections:</label>
                <select id="select_section" class="form-control">
                    <option value="" selected>Select a section</option>
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("sectionID")%>"><%=rs.getString("courseID")%> - <%=rs.getString("sectionID")%></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Start Date:</label>
                <input id="date_start" type="date" min="2019-01-07" max="2019-03-15">
            </div>

            <div class="form-group">
                <label>End Date:</label>
                <input id="date_end" type="date" min="2019-01-07" max="2019-03-15">
            </div>

            <input type="button" class="btn btn-primary" onclick="submit()" value="Submit">

            <samp><pre id="pre_sched"></pre></samp>
        </div>

        <script>
            const selectSection = document.getElementById('select_section');
            const dateStart = document.getElementById('date_start');
            const dateEnd = document.getElementById('date_end');
            const preSched = document.getElementById('pre_sched');

            function submit() {
                let sectionID = selectSection.value;
                let start = dateStart.value;
                let end = dateEnd.value;
                if (sectionID === '' || start === '' || end === '') {
                    alert('Invalid input.');
                    return;
                }

                let queryStr = $.param({
                    'sectionID': sectionID,
                    'start': start,
                    'end': end
                });

                console.log(queryStr);

                fetch('/review_schedule?' + queryStr, {
                    method: 'GET',
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'follow'
                }).then((response) => {
                    if (response.ok) {
                        return response.json();
                    } else {
                        alert('Something went wrong.');
                    }
                })
                .then((json) => {
                    let jsonStr = JSON.stringify(json, undefined, 4);
                    console.log(jsonStr);
                    preSched.innerText = jsonStr;
                });
            }
        </script>
    </body>
</html>
