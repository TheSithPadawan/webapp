<%--
  Created by IntelliJ IDEA.
  User: miaor
  Date: 2/8/19
  Time: 3:15 PM
  To change this template use File | Settings | File Templates.
--%>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>

<%
    String studentID = (String) request.getAttribute("studentid");
%>
<!------ Include the above in your HEAD tag ---------->

<form>
    <div class="container">
        <table name="table" id="myTable" class=" table order-list" >
            <thead>
            <tr>
                <td>StudentID</td>
                <td>Quarter</td>
                <td>Year</td>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td class="col-sm-4">
                    <input type="text" name="studentid" class="form-control" />
                </td>
                <td class="col-sm-4">
                    <input type="mail" name="quarter"  class="form-control"/>
                </td>
                <td class="col-sm-3">
                    <input type="text" name="year"  class="form-control"/>
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

            cols += '<td><input type="text" class="form-control" name="studentid' + counter + '"/></td>';
            cols += '<td><input type="text" class="form-control" name="quarter' + counter + '"/></td>';
            cols += '<td><input type="text" class="form-control" name="year' + counter + '"/></td>';

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



    function calculateRow(row) {
        var price = +row.find('input[name^="price"]').val();

    }

    function calculateGrandTotal() {
        var grandTotal = 0;
        $("table.order-list").find('input[name^="price"]').each(function () {
            grandTotal += +$(this).val();
        });
        $("#grandtotal").text(grandTotal.toFixed(2));
    }
    const btn_submit = document.getElementById("submit_btn");
    btn_submit.addEventListener('click', (event) => {
        event.preventDefault();
        submit();
    });
    function submit (){
        let inputList = document.getElementsByTagName('input');
        let arr = [];
        let currentObj = {};

        for (let i = 0; i < inputList.length; i++) {
            let element = inputList.item(i);
            let elementName = element.name;

            if (elementName.startsWith('studentid')) {
                currentObj['studentid'] = element.value;
            } else if (elementName.startsWith('quarter')) {
                currentObj['quarter'] = element.value;
            } else if (elementName.startsWith('year')) {
                currentObj['year'] = element.value;
                arr.push(currentObj);
                currentObj = {};
            }
        }

        let jsonStr = JSON.stringify(arr);
        console.log(jsonStr);
        fetch('/attend', {
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