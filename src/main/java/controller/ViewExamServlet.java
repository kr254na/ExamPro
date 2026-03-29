package controller;

import dao.ExamDao;
import model.Exam;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-exams")
public class ViewExamServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            resp.sendRedirect("/login.jsp");
            return;
        }

        User currentTeacher = (User) session.getAttribute("user");
        ExamDao examDao = new ExamDao();
        List<Exam> exams = examDao.getExamsByTeacher(currentTeacher.getId());
        req.setAttribute("myExams",exams);
        req.getRequestDispatcher("view-exams.jsp").forward(req,resp);
    }
}
