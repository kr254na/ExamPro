package controller;

import dao.ResultDao;
import model.Question;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/submit-exam")
public class SubmitExamServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentExamQuestions") == null) {
            response.sendRedirect("dashboard");
            return;
        }

        @SuppressWarnings("unchecked")
        List<Question> questions = (List<Question>) session.getAttribute("currentExamQuestions");

        @SuppressWarnings("unchecked")
        Map<Integer, String> answeredMap = (Map<Integer, String>) session.getAttribute("answeredMap");

        int examId = (Integer) session.getAttribute("currentExamId");
        User user = (User) session.getAttribute("user");

        int correctCount = 0;
        int totalQuestions = questions.size();

        for (int i = 1; i <= totalQuestions; i++) {
            String studentChoice = answeredMap.get(i);
            String correctChoice = questions.get(i - 1).getCorrectAnswer();

            if (studentChoice != null && studentChoice.equalsIgnoreCase(correctChoice)) {
                correctCount++;
            }
        }

        double percentage = ((double) correctCount / totalQuestions) * 100;

        ResultDao resultDao = new ResultDao();
        boolean isSaved = resultDao.insertResult(user.getId(), examId, totalQuestions, correctCount, percentage);

        if (isSaved) {
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("score", correctCount);
            resultMap.put("total", totalQuestions);
            resultMap.put("correct", correctCount);
            resultMap.put("wrong", totalQuestions - correctCount);
            resultMap.put("percentage", Math.round(percentage * 100.0) / 100.0);

            session.setAttribute("result", resultMap);

            session.removeAttribute("currentExamQuestions");
            session.removeAttribute("answeredMap");
            session.removeAttribute("reviewSet");
            session.removeAttribute("currentExamId");
            session.removeAttribute("examEndTime");

            response.sendRedirect(request.getContextPath() + "/exam-result.jsp");
        } else {
            response.sendRedirect("/student/dashboard?error=already_submitted_or_error");
        }

    }
}