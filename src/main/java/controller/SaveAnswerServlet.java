package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet("/student/save-answer")
public class SaveAnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try {

            int currentIndex = Integer.parseInt(request.getParameter("nextIdx")) - 1;
            String selectedOption = request.getParameter("answer");

            @SuppressWarnings("unchecked")
            Map<Integer, String> answeredMap = (Map<Integer, String>) session.getAttribute("answeredMap");

            if (answeredMap == null) {
                answeredMap = new HashMap<>();
            }

            String mode = request.getParameter("mode");
            Set<Integer> reviewSet = (Set<Integer>) session.getAttribute("reviewSet");
            int qIndex = currentIndex;

            if ("review".equals(mode)) {
                if (reviewSet.contains(qIndex)) {
                    reviewSet.remove(qIndex);
                } else {
                    reviewSet.add(qIndex);
                }
            }
            else {
                if (selectedOption != null && !selectedOption.isEmpty()) {
                    answeredMap.put(currentIndex, selectedOption);
                } else {
                    answeredMap.remove(currentIndex);
                }
            }
            session.setAttribute("reviewSet", reviewSet);
            session.setAttribute("answeredMap", answeredMap);

            response.sendRedirect(request.getContextPath() + "/student/live-test?q=" + currentIndex);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/student/dashboard?error=save_failed");
        }
    }
}