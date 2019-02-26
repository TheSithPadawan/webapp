/*
This servlet handles post request from
displaying all students; for queries related to
checking student grade and undergrad graduation requirement
checking for student schedule conflict
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
            // only deal with BS degree on this page
            String degree_selected = request.getParameter("get_degree");
            request.setAttribute("dept_name", degree_selected);
            System.out.println(degree_selected);
            RequestDispatcher rd = request.getRequestDispatcher("/degree_req.jsp");
            rd.forward(request, response);
        }else if (request.getParameter("check_schedule") != null){
            System.out.println("Got the request");
            System.out.println("ssn " + studentssn);
            RequestDispatcher rd = request.getRequestDispatcher("/conflict_schedule.jsp");
            rd.forward(request, response);
        }
    }
}
