<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/9/19
  Time: 5:38 PM
  To change this template use File | Settings | File Templates.

  Use this form to submit basic degree information
--%>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<jsp:include page="menu.jsp"/>

<form>
    <div class="container">
        <div class="form-group">
            <label>Department</label>
            <input class="form-control" id="department">
        </div>
        <div class="form-group">
            <label>Total Units</label>
            <input class="form-control" id="totalUnits">
        </div>
        <div class="form-group">
            <label>Degree Type</label>
            <select class="form-control" id="program">
                <option value="BS">BS</option>
                <option value="BSMS">BSMS</option>
                <option value="MS">MS</option>
                <option value="PhD">PhD</option>
            </select>
        </div>
    </div>
    <button class="btn btn-primary" id="submit_btn">Submit</button>
</form>

<script>
    const btn_submit = document.getElementById("submit_btn");
    btn_submit.addEventListener('click', (event) => {
        event.preventDefault();
        submit();
    });
    function submit (){
        let department = document.getElementById('department').value;
        let total_units = document.getElementById('totalUnits').value;
        let program = document.getElementById('program');
        let selection = program.options[program.selectedIndex].text;
        window.location = "/degree_category.jsp?dept=" + department+"&total_units="+total_units+
        "&program="+selection;
    }

</script>