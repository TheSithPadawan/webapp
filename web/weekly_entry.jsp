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
        <script src="util.js"></script>
    </head>

    <body>
        <%
            String sectionID = request.getParameter("sectionID");
        %>

        <script>
            const sectionID = '<%=sectionID%>';
        </script>

        <br>
        <div class="container">
            <table id="table_main" class="table order-list">
                <caption>Section ID: <%=sectionID%></caption>
                <thead>
                    <tr>
                        <th>Day</th>
                        <th>Start (hh:mm[am|pm])</th>
                        <th>End (hh:mm[am|pm])</th>
                        <th>Building</th>
                        <th>Room</th>
                        <th>Type</th>
                        <th>Required</th>
                    </tr>
                </thead>
            </table>
            <input type="button" class="btn" id="btn_add" value="Add Weekly">
            <br>
            <input type="button" class="btn btn-primary" id="btn_submit" value="Submit">
        </div>


        <script>
            const timeRegexStr = String.raw`([0-9]{1,2}):([0-9]{2})(am|pm|AM|PM)`;
            const timeRegex = new RegExp(timeRegexStr);
            const tableMain = document.getElementById('table_main');
            const btnSubmit = document.getElementById('btn_submit');
            var currentIndex = 0;
            var validIndex = {};

            $(document).ready(() => {
                validIndex[currentIndex] = true;
                let newRow = createNewRow(currentIndex++);
                $("table.order-list").append(newRow);

                $("#btn_add").on('click', () => {
                    console.log('adding row');
                    validIndex[currentIndex] = true;
                    let newRow = createNewRow(currentIndex++);
                    $("table.order-list").append(newRow);
                });

                $("table.order-list").on("click", ".ibtnDel", function (event) {
                    console.log('deleting row');
                    let closestTr = $(this).closest("tr");
                    let trId = closestTr.attr('id');
                    let id = trId.split('_tr')[0];
                    validIndex[id] = undefined;
                    closestTr.remove();
                });

                btnSubmit.addEventListener('click', validateAndSubmit);
            });

            async function validateAndSubmit() {
                let weeklyArr = [];
                for (let id in validIndex) {
                    if (!validIndex.hasOwnProperty(id) || validIndex[id] === undefined) {
                        continue;
                    }

                    let day = document.getElementById(id + '_day').value;
                    let start = document.getElementById(id + '_start').value;
                    let end = document.getElementById(id + '_end').value;
                    let building = document.getElementById(id + '_building').value;
                    let room = document.getElementById(id + '_room').value;
                    let type = document.getElementById(id + '_type').value;
                    let required = document.getElementById(id + '_required').checked;

                    let startArr = timeRegex.exec(start);
                    let endArr = timeRegex.exec(end);

                    if (day === '' || start === '' || end === '' || building === '' || room === '' ||
                        type === '' || startArr === null || endArr === null) {
                        alert('Invalid info');
                        return;
                    }

                    let startTime = startArr[0];
                    let endTime = endArr[0];

                    let currentStr = $.param({
                        'sectionID': sectionID,
                        'day': day,
                        'time_start': startTime,
                        'time_end': endTime,
                        'building': building,
                        'room': room,
                        'type_meeting': type,
                        'required_meeting': (required ? 'true' : 'false')
                    });
                    console.log(currentStr);
                    weeklyArr.push(currentStr);
                }

                if (weeklyArr.length === 0) {
                    alert('Invalid info');
                    return;
                }

                for (let weekly of weeklyArr) {
                    await fetch('/weekly', {
                        method: 'POST',
                        headers: {
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        redirect: 'manual',
                        body: weekly
                    });
                }

                location.reload();
            }
        </script>
    </body>
</html>
