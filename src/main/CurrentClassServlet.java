package main;

import sun.misc.Request;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/current_class")
public class CurrentClassServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ssn = request.getParameter("student_ssn");
        System.out.println("ssn selected " + ssn);
        // pass the ssn to
        request.setAttribute("ssn", ssn);

        // redirect to another jsp
        RequestDispatcher rd = request.getRequestDispatcher("/display_class.jsp");
        rd.forward(request, response);
    }
}