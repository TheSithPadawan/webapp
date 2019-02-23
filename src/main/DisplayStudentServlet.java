/*
This servlet handles post request from
displaying all students
 */
package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/grade_report")
public class DisplayStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException {
        String studentssn = request.getParameter("get_student");

        request.setAttribute("ssn", studentssn);

        if (request.getParameter("check_grade") != null){
            RequestDispatcher rd = request.getRequestDispatcher("/student_grade.jsp");
            rd.forward(request, response);
        }else if (request.getParameter("check_degree") != null)
        {
            String degree_selected = request.getParameter("get_degree");
            String[] parts = degree_selected.split("|");
            String dept_name = parts[0];
            request.setAttribute("dept_name", dept_name);
            System.out.println(degree_selected);
            RequestDispatcher rd = request.getRequestDispatcher("/degree_req.jsp");
            rd.forward(request, response);
        }
    }
}
