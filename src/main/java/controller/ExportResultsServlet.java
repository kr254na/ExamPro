package controller;

import dao.ResultDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/export-results")
public class ExportResultsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User teacher = (User) session.getAttribute("user");

        int bId = request.getParameter("batchId") != null ? Integer.parseInt(request.getParameter("batchId")) : 0;
        int eId = request.getParameter("examId") != null ? Integer.parseInt(request.getParameter("examId")) : 0;

        ResultDao resultDao = new ResultDao();
        List<Map<String, Object>> results = resultDao.getResultsForTeacher(teacher.getId(), bId, eId);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=Exam_Results_" + System.currentTimeMillis() + ".csv");

        try (PrintWriter writer = response.getWriter()) {

            writer.println("Student Username,Assessment,Classroom,Subject,Date,Score,Percentage,Status");

            for (Map<String, Object> res : results) {
                String status = (Double)res.get("percentage") >= 40 ? "PASSED" : "FAILED";

                writer.printf("%s,%s,%s,%s,%s,%s,%s%%,%s%n",
                        res.get("studentName"),
                        res.get("examTitle"),
                        res.get("batchName"),
                        res.get("subjectName"),
                        res.get("date"),
                        res.get("correct") + "/" + res.get("total"),
                        res.get("percentage"),
                        status
                );
            }
        }
    }
}