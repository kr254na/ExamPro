package controller;

import model.Question;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/student/live-test")
public class LiveTestServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentExamQuestions") == null) {
            response.sendRedirect("/login.jsp?error=session_expired");
            return;
        }

        int currentIndex = 1;
        try {
            String qParam = request.getParameter("q");
            if (qParam != null) {
                currentIndex = Integer.parseInt(qParam);
            }
        } catch (NumberFormatException e) {
            currentIndex = 1;
        }

        @SuppressWarnings("unchecked")
        List<Question> questions = (List<Question>) session.getAttribute("currentExamQuestions");
        int totalQuestions = questions.size();

        if (currentIndex < 1) currentIndex = 1;
        if (currentIndex > totalQuestions) currentIndex = totalQuestions;

        @SuppressWarnings("unchecked")
        Map<Integer, String> answeredMap = (Map<Integer, String>) session.getAttribute("answeredMap");

        int answeredCount = (answeredMap != null) ? answeredMap.size() : 0;
        int progressPercent = (int) (((double) answeredCount / totalQuestions) * 100);

        request.setAttribute("currentQuestion", questions.get(currentIndex-1));
        request.setAttribute("currentIndex", currentIndex);
        request.setAttribute("answeredCount", progressPercent);

        String selectedAnswer = (answeredMap != null) ? answeredMap.get(currentIndex) : null;
        request.setAttribute("selectedAnswer", selectedAnswer);

        request.setAttribute("answeredMap", answeredMap);

        request.getRequestDispatcher("/take-exam.jsp").forward(request, response);
    }
}