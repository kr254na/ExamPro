package controller;

import dao.QuestionDao;
import model.Question;

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

@WebServlet("/exam")
public class QuestionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession();

        List<Question> qList = (List<Question>) session.getAttribute("questions");

        if(qList == null){
            QuestionDao questionDao = new QuestionDao();
            qList = questionDao.getQuestions(10);
            session.setAttribute("questions",qList);
            session.setAttribute("currentIdx",0);
            int examDurationMinutes = 1;
            long endTime = System.currentTimeMillis() + (examDurationMinutes * 60 * 1000);
            session.setAttribute("endTime", endTime);
        }

        String selectedAnswer = req.getParameter("answer");
        Map<Integer,String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if(userAnswers == null){
            userAnswers = new HashMap<>();
            session.setAttribute("userAnswers",userAnswers);
        }
        Map<Integer, Boolean> reviewMap = (Map<Integer, Boolean>) session.getAttribute("reviewMap");
        if (reviewMap == null) {
            reviewMap = new HashMap<>();
            session.setAttribute("reviewMap", reviewMap);
        }
        String action = req.getParameter("action");
        Object idxObj = session.getAttribute("currentIdx");
        int currentIdx = (idxObj != null) ? (int) idxObj : 0;
        if(selectedAnswer!=null){
            userAnswers.put(currentIdx,selectedAnswer);
        }
        if ("jump".equals(action)) {
            String jumpIdxStr = req.getParameter("index");
            if (jumpIdxStr != null) {
                try {
                    int requestedIdx = Integer.parseInt(jumpIdxStr);
                    if (requestedIdx >= 0 && requestedIdx < qList.size()) {
                        currentIdx = requestedIdx;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid jump index format: " + jumpIdxStr);
                }
            }
        }
        else if("next".equals(action) && currentIdx < qList.size()-1){
            currentIdx++;
        }
        else if("prev".equals(action) && currentIdx > 0){
            currentIdx--;
        }
        else if ("review".equals(action)) {
            reviewMap.put(currentIdx, true);
        }

        session.setAttribute("currentIdx",currentIdx);
        req.setAttribute("currentIdx", currentIdx);
        if(qList != null && !qList.isEmpty()){
            req.setAttribute("currentQuestion", qList.get(currentIdx));
        }
        req.getRequestDispatcher("question.jsp").forward(req,res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect("index.jsp");
            return;
        }

        List<Question> qList = (List<Question>) session.getAttribute("questions");
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");

        int score = 0;
        int attempted = 0;

        if (qList != null) {
            attempted = (userAnswers != null) ? userAnswers.size() : 0;
            for (int i = 0; i < qList.size(); i++) {
                String correct = qList.get(i).getCorrectAnswer();
                String userResponse = (userAnswers != null) ? userAnswers.get(i) : null;

                if (correct != null && correct.equalsIgnoreCase(userResponse)) {
                    score++;
                }
            }
        }

        req.setAttribute("score", score);
        req.setAttribute("totalQuestions", (qList != null) ? qList.size() : 0);
        req.setAttribute("attempted", attempted);

        session.invalidate();
        req.getRequestDispatcher("result.jsp").forward(req, res);
    }
}
