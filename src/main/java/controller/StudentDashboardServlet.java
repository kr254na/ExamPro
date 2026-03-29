package controller;

import dao.BatchDao;
import dao.ExamDao;
import model.Batch;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User student = (User) session.getAttribute("user");
        int studentId = student.getId();

        BatchDao batchDao = new BatchDao();
        ExamDao examDao = new ExamDao();
        List<Batch> joinedBatches = batchDao.getBatchesByStudent(studentId);

        int joinedCount = joinedBatches.size();

        int pendingExams = 0;
        int completedExams = 0;

        request.setAttribute("joinedBatches", joinedBatches);
        request.setAttribute("joinedBatchesCount", joinedCount);
        request.setAttribute("pendingExamsCount", pendingExams);
        request.setAttribute("completedExamsCount", completedExams);

        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }
}