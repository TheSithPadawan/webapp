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

        <title>Course Category Entry Form</title>
    </head>

    <body>
        <jsp:include page="index.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM course";
            PreparedStatement stmt = dbConn.getScrollableReadOnlyPreparedStatment(query);
            ResultSet rs = stmt.executeQuery();

            DBConn dbConnCat = new DBConn();
            dbConnCat.openConnection();
            String queryCat = "SELECT * FROM degree_has_categories";
            dbConnCat.executeQuery(queryCat);
            ResultSet rsCat = dbConnCat.getResultSet();
        %>

        <div class="container">
            <div class="form-group">
                <label>Course ID:</label>
                <select id="select_courseID" class="form-control">
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("courseID")%>"><%=rs.getString("courseID")%></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Department and Category:</label>
                <select class="form-control" id="select_category" multiple>
                    <% while (rsCat.next()) { %>
                        <option value="<%=rsCat.getString("dept_name")%>|<%=rsCat.getString("category_type")%>">Dept: <%=rsCat.getString("dept_name")%> | Category:<%=rsCat.getString("category_type")%></option>
                    <% } %>
                </select>
            </div>

            <input type="button" id="btn_submit" value="Submit" class="btn btn-primary" onclick="submit()">
        </div>

        <script>
            const selectCourseID = document.getElementById('select_courseID');
            const selectCategory = document.getElementById('select_category');
            const btnSubmit = document.getElementById('btn_submit');

            async function submit() {
                let courseID = selectCourseID.value;
                if (courseID === '') {
                    alert('Invalid input.');
                    return;
                }

                let catValArr = $('#select_category').val();;
                if (catValArr.length === 0) {
                    location.href = 'class_entry.jsp';
                }

                for (let deptCat of catValArr) {
                    let arr = deptCat.split('|');
                    let dept = arr[0];
                    let cat = arr[1];

                    let bodyStr = $.param({
                        'courseID': courseID,
                        'department': dept,
                        'category': cat
                    });

                    console.log(bodyStr);

                    await fetch('/category', {
                        method: 'POST',
                        headers: {
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        redirect: 'manual',
                        body: bodyStr
                    });
                }

                location.href = 'class_entry.jsp';
            }
        </script>
    </body>
</html>
