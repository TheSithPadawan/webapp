<!DOCTYPE html>
<html lang="en">
<head>
    <title>Student Entry Form</title>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>

<div class="container">
    <form name="basicInfo" stype="width:300px" action = "/student_entry" method = "post">
        <div class="form-group">
            <label>SSN</label>
            <input type="ssn" class="form-control" name="ssn" id ="ssn">
        </div>
        <div class="form-group">
            <label>Residency</label>
            <select class="form-control" name="residency" id="residency">
                <option value="CA US">CA US</option>
                <option value="Non-CA US">Non-CA US</option>
                <option value="Foreign">Foreign</option>
            </select>
        </div>
        <div class="form-group">
            <label>Student Id</label>
            <input type="studentid" class="form-control" name="studentid" id ="studentid">
        </div>
        <div class="form-group">
            <label>First Name</label>
            <input type="firstname" class="form-control" name="firstname" id ="firstname">
        </div>
        <div class="form-group">
            <label>Middle Name</label>
            <input type="middlename" class="form-control" name="middlename" id ="middlename">
        </div>
        <div class="form-group">
            <label>Last Name</label>
            <input type="lastname" class="form-control" name="lastname" id ="lastname">
        </div>
        <div class="form-group">
            <label>Enrollment</label>
            <input type="checkbox" class="form-check-input" name="enrollment" id ="enrollment">
        </div>
        <div class="form-group">
            <label>Program</label>
            <select class="form-control" name="program" id="program">
                <option value="undergrad">Undergrad</option>
                <option value="ms">MS</option>
                <option value="phd">PhD</option>
                <option value="bsms">BSMS</option>
            </select>
        </div>
        <div class="form-group">
            <label>Previous Degree: Department and Type</label>
            <input class="form-control" name="prevDept">
            <input clas="form-control" name="type">
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>

</div>