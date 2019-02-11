function createNewRow(index) {
    if (index === undefined) {
        return;
    }

    let inner = `
        <tr id="${index}_tr">
            <td>
                <select class="form-control" id="${index}_day">
                    <option value="M">Monday</option>
                    <option value="Tu">Tuesday</option>
                    <option value="W">Wednesday</option>
                    <option value="Th">Thursday</option>
                    <option value="F">Friday</option>
                    <option value="Sa">Saturday</option>
                    <option value="Su">Sunday</option>
                </select>
            </td>

            <td>
                <input class="form-control" id="${index}_start" type="text">
            </td>

            <td>
                <input class="form-control" id="${index}_end" type="text">
            </td>

            <td>
                <input class="form-control" id="${index}_building" type="text">
            </td>

            <td>
                <input class="form-control" id="${index}_room" type="text">
            </td>

            <td>
                <select class="form-control" id="${index}_type">
                    <option value="LE">Lecture</option>
                    <option value="DI">Discussion</option>
                    <option value="LA">Lab</option>
                </select>
            </td>

            <td>
                <input class="form-check-input" id="${index}_required" type="checkbox">
            </td>

            <td>
                <input type="button" class="ibtnDel btn btn-md btn-danger" id="${index}_del" value="Delete">
            </td>
        </tr>
    `;

    return inner;
}
