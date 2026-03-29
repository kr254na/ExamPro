package controller;

import dao.BatchDao;
import dao.ExamDao;
import dao.QuestionDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/teacher-dashboard")
public class TeacherDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        QuestionDao qDao = new QuestionDao();
        int totalQuestions = qDao.getQuestionCountByTeacher(user.getId());
        ExamDao examDao = new ExamDao();
        BatchDao batchDao = new BatchDao();
        int totalBatches = batchDao.getTotalBatchesCountByTeacher(user.getId());
        int totalExams = examDao.getTotalExamsCountByTeacher(user.getId());
        req.setAttribute("totalQuestions", totalQuestions);
        req.setAttribute("totalExams",totalExams);
        req.setAttribute("totalBatches",totalBatches);
        req.getRequestDispatcher("teacher-dashboard.jsp").forward(req,res);
    }
}
