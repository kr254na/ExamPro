package controller;

import dao.ExamDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/delete-exam")
public class DeleteExamServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ExamDao dao = new ExamDao();

            if (dao.deleteExam(id)) {
                response.sendRedirect("/my-exams?status=deleted");
            } else {
                response.sendRedirect("/my-exams?error=delete_failed");
            }
        } catch (Exception e) {
            response.sendRedirect("/my-exams?error=invalid_id");
        }
    }
}
