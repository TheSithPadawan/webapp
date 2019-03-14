<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/9/19
  Time: 3:21 PM
  To change this template use File | Settings | File Templates.

  Graduate students can use this to register for their thesis committee
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
            <label>StudentID</label>
            <input class="form-control" name="studentid" id="studentid">
        </div>
        <div class="form-group">
            <label>Program</label>
            <select class="form-control" name="program" id="program">
                <option value="MS">MS</option>
                <option value="PhD">PhD</option>
            </select>
        </div>
        <table name="table" id="myTable" class=" table order-list" >
            <thead>
            <tr>
                <td>Faculty</td>
                <td>Department</td>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td class="col-sm-4">
                    <input type="text" name="faculty" class="form-control" />
                </td>
                <td class="col-sm-4">
                    <input type="mail" name="dept"  class="form-control"/>
                </td>
                <td class="col-sm-2"><a class="deleteRow"></a>

                </td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="5" style="text-align: left;">
                    <input type="button" class="btn btn-lg btn-block " id="addrow" value="Add Row" />
                </td>
            </tr>
            <tr>
            </tr>
            </tfoot>
        </table>
    </div>
    <button class="btn btn-primary" id="submit_btn">Submit</button>
</form>

<script>
    $(document).ready(function () {
        var counter = 0;

        $("#addrow").on("click", function () {
            var newRow = $("<tr>");
            var cols = "";

            cols += '<td><input type="text" class="form-control" name="faculty' + counter + '"/></td>';
            cols += '<td><input type="text" class="form-control" name="dept' + counter + '"/></td>';
            cols += '<td><input type="button" class="ibtnDel btn btn-md btn-danger "  value="Delete"></td>';
            newRow.append(cols);
            $("table.order-list").append(newRow);
            counter++;
        });



        $("table.order-list").on("click", ".ibtnDel", function (event) {
            $(this).closest("tr").remove();
            counter -= 1
        });

    });

    const btn_submit = document.getElementById("submit_btn");
    btn_submit.addEventListener('click', (event) => {
        event.preventDefault();
        submit();
    });
    function submit (){
        // extract student id and program
        let studentid = document.getElementById('studentid').value;
        let program = document.getElementById('program');
        let selection = program.options[program.selectedIndex].text;

        let inputList = document.getElementsByTagName('input');
        console.log(inputList.length)
        let arr = [];
        let currentObj = {};

        for (let i = 0; i < inputList.length; i++) {
            let element = inputList.item(i);
            let elementName = element.name;

            if (elementName.startsWith('faculty')) {
                currentObj['faculty'] = element.value;
            } else if (elementName.startsWith('dept')) {
                currentObj['department'] = element.value;
                arr.push(currentObj);
                currentObj = {};
            }
        }

        console.log(arr);
        let jsonStr = {
            "studentid": studentid,
            "program": selection,
            "committee": arr,
        }

        jsonStr = JSON.stringify(jsonStr);

        console.log(jsonStr);
        fetch('/thesis_committee', {
            method: 'POST',
            body: jsonStr,
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then((response) => {
                // response from POST
                window.location.href="";
            });
    }

</script>