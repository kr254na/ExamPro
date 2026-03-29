package controller;

import dao.ExamDao;
import model.Exam;
import model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-exam-details")
public class ViewExamDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int examId = Integer.parseInt(req.getParameter("id"));

        ExamDao dao = new ExamDao();
        Exam exam = dao.getExamById(examId);
        List<Question> questions = dao.getQuestionsByExamId(examId);

        req.setAttribute("exam", exam);
        req.setAttribute("questions", questions);
        req.getRequestDispatcher("view-exam-details.jsp").forward(req, res);
    }
}