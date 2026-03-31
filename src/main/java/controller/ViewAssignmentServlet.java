package controller;

import dao.AssignmentDao;
import dao.ExamDao;
import model.ExamAssignment;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/assignments")
public class ViewAssignmentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User teacher = (User) session.getAttribute("user");
        AssignmentDao dao = new AssignmentDao();
        List<ExamAssignment> assignments = dao.getAssignmentsByTeacher(teacher.getId());

        request.setAttribute("assignments", assignments);
        request.getRequestDispatcher("/view-assignments.jsp").forward(request, response);
    }
}
