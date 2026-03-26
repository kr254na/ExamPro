package controller;

import dao.SubjectDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/prepare-question")
public class PrepareQuestionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        SubjectDao dao = new SubjectDao();
        request.setAttribute("subjects", dao.getAllSubjects());

        request.getRequestDispatcher("add-question.jsp").forward(request, response);
    }
}