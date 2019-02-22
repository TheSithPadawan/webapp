package main;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/class_roster")
public class AllClassServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String classTitle = request.getParameter("class");
        System.out.println(classTitle);

        request.setAttribute("title", classTitle);
        RequestDispatcher rd = request.getRequestDispatcher("/roster.jsp");
        rd.forward(request, response);
    }
}
