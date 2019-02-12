<%@ page import="main.DBConn" %>
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

        <title>Textbook-Section Entry Form</title>
    </head>

    <body>
        <jsp:include page="index.jsp"/>

        <%
            DBConn dbConn = new DBConn();
            dbConn.openConnection();
            String query = "SELECT * FROM sections";
            dbConn.executeQuery(query);
            ResultSet rs = dbConn.getResultSet();

            DBConn dbConn2 = new DBConn();
            dbConn2.openConnection();
            String query2 = "SELECT * FROM textbook";
            dbConn2.executeQuery(query2);
            ResultSet rs2 = dbConn2.getResultSet();
        %>

        <div class="container">
            <div class="form-group">
                <label>Section ID</label>
                <select name="sectionID" id="select_sectionID" class="form-control">
                    <% while (rs.next()) { %>
                        <option value="<%=rs.getString("sectionID")%>"><%=rs.getString("sectionID")%></option>
                    <% }  %>
                </select>
            </div>

            <div class="form-group">
                <label>ISBN</label>
                <select name="isbn" id="select_isbn" class="form-control">
                    <% while (rs2.next()) { %>
                        <option value="<%=rs2.getString("isbn")%>"><%=rs2.getString("isbn")%></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Required</label>
                <input id="checkbox_required" type="checkbox" name="is_required" class="form-check-input" checked="true">
            </div>

            <input type="button" id="btn_submit" value="Submit" class="btn btn-primary" onclick="submit()">
        </div>

        <script>
            const selectSectionID = document.getElementById('select_sectionID');
            const selectISBN = document.getElementById('select_isbn');
            const checkboxRequired = document.getElementById('checkbox_required');

            function submit() {
                let bodyStr = $.param({
                    'sectionID': selectSectionID.value,
                    'isbn': selectISBN.value,
                    'is_required': (checkboxRequired.checked ? 'true': 'false')
                });

                fetch('/textbook_section', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    redirect: 'manual',
                    body: bodyStr
                });
            }
        </script>
    </body>
</html>
