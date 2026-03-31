package controller;

import dao.ExamDao;
import dao.QuestionDao;
import model.Exam;
import model.Question;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@WebServlet("/student/start-exam")
public class StartExamServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try {
            int examId = Integer.parseInt(request.getParameter("examId"));

            ExamDao examDao = new ExamDao();
            List<Question> examQuestions = examDao.getQuestionsByExamId(examId);
            Exam exam = new Exam();
            exam = examDao.getExamById(examId);
            int durationMinutes = exam.getDuration();
            session.setMaxInactiveInterval(durationMinutes * 60);

            if (examQuestions != null && !examQuestions.isEmpty()) {

                Collections.shuffle(examQuestions);

                session.setAttribute("currentExamTitle",exam.getExamTitle());
                session.setAttribute("currentExamQuestions", examQuestions);
                session.setAttribute("currentExamId", examId);
                session.setAttribute("totalQuestions", examQuestions.size());
                Map<Integer, String> answeredMap = new HashMap<>();
                session.setAttribute("answeredMap", answeredMap);
                Set<Integer> reviewSet = new HashSet<>();
                session.setAttribute("reviewSet", reviewSet);
                long endTime = System.currentTimeMillis() + (durationMinutes * 60 * 1000);
                session.setAttribute("examEndTime", endTime);
                response.sendRedirect(request.getContextPath() + "/student/live-test?q=" + 1);
            } else {
                response.sendRedirect("/student/dashboard?error=no_questions");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/student/dashboard?error=init_failed");
        }
    }
}