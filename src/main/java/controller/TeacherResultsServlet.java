package controller;

import dao.BatchDao;
import dao.ExamDao;
import dao.ResultDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/view-results")
public class TeacherResultsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        int batchId = request.getParameter("batchId") != null ? Integer.parseInt(request.getParameter("batchId")) : 0;
        int examId = request.getParameter("examId") != null ? Integer.parseInt(request.getParameter("examId")) : 0;

        User teacher = (User) session.getAttribute("user");
        ResultDao dao = new ResultDao();

        List<Map<String, Object>> examResults = dao.getResultsForTeacher(teacher.getId(), batchId, examId);
        int totalSubmissions = examResults.size();
        double totalPercentage = 0;
        double highestScore = 0;

        for (Map<String, Object> res : examResults) {
            double p = (Double) res.get("percentage");
            totalPercentage += p;
            if (p > highestScore) highestScore = p;
        }

        BatchDao batchDao = new BatchDao();
        ExamDao examDao = new ExamDao();
        request.setAttribute("allBatches", batchDao.getBatchesByTeacher(teacher.getId()));
        request.setAttribute("allExams", examDao.getExamsByTeacher(teacher.getId()));

        double average = totalSubmissions > 0 ? (totalPercentage / totalSubmissions) : 0;
        request.setAttribute("totalSubmissions", totalSubmissions);
        request.setAttribute("classAverage", Math.round(average));
        request.setAttribute("highestScore", highestScore);
        request.setAttribute("examResults", examResults);
        request.getRequestDispatcher("/view-results.jsp").forward(request, response);
    }
}