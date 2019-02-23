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
        RequestDispatcher rd = request.getRequestDispatcher("/student_grade.jsp");
        rd.forward(request, response);
    }
}
