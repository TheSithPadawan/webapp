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
    </head>

    <body>
        <jsp:include page="index.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM sections";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();
        %>

        <br>
        <div class="container">
            <label>Section ID: </label>
            <select id="input_sectionID" class="form-control">
                <% while (rs.next()) { %>
                    <option value="<%=rs.getString("sectionID")%>"><%=rs.getString("sectionID")%></option>
                <% } %>
            </select>

            <table class="table order-list">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Start (hh:mm[am|pm])</th>
                        <th>End (hh:mm[am|pm])</th>
                        <th>Building</th>
                        <th>Room</th>
                    </tr>

                    <tr>
                        <td>
                            <input class="form-control" type="date" id="input_date">
                        </td>

                        <td>
                            <input class="form-control" id="input_start" type="text">
                        </td>

                        <td>
                            <input class="form-control" id="input_end" type="text">
                        </td>

                        <td>
                            <input class="form-control" id="input_building" type="text">
                        </td>

                        <td>
                            <input class="form-control" id="input_room" type="text">
                        </td>
                    </tr>
                </thead>
            </table>
            <br>
            <input type="button" class="btn btn-primary" id="btn_submit" value="Submit">
        </div>

        <script>
            const timeRegexStr = String.raw`([0-9]{1,2}):([0-9]{2})(am|pm|AM|PM)`;
            const timeRegex = new RegExp(timeRegexStr);
            const btnSubmit = document.getElementById('btn_submit');
            const inputSection = document.getElementById('input_sectionID');

            $(document).ready(() => {
                btnSubmit.addEventListener('click', validateAndSubmit);
            });

            function validateAndSubmit() {
                let sectionID = inputSection.value;
                let date = document.getElementById('input_date').value;
                let start = document.getElementById('input_start').value;
                let end = document.getElementById('input_end').value;
                let building = document.getElementById('input_building').value;
                let room = document.getElementById('input_room').value;

                let startArr = timeRegex.exec(start);
                let endArr = timeRegex.exec(end);

                if (date === '' || start === '' || end === '' || building === '' || room === '' ||
                    startArr === null || endArr === null) {
                    alert('Invalid info');
                    return;
                }

                let startTime = startArr[0];
                let endTime = endArr[0];

                let currentStr = $.param({
                    'sectionID': sectionID,
                    'date_of': date,
                    'time_start': startTime,
                    'time_end': endTime,
                    'building': building,
                    'room': room
                });

                fetch('/review', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'manual',
                    body: currentStr
                })
                .then((response) => {
                    location.reload();
                });
            }
        </script>
    </body>
</html>
