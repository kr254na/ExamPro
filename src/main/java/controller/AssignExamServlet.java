package controller;

import dao.AssignmentDao;
import dao.BatchDao;
import dao.ExamDao;
import model.Batch;
import model.Exam;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/exam/assign")
public class AssignExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User teacher = (User) session.getAttribute("user");
        ExamDao examDao = new ExamDao();

        List<Exam> myExams = examDao.getExamsByTeacher(teacher.getId());

        request.setAttribute("myExams", myExams);

        request.setAttribute("selectedBatchId", request.getParameter("batchId"));

        request.getRequestDispatcher("/assign-exam.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int examId = Integer.parseInt(request.getParameter("examId"));
        int batchId = Integer.parseInt(request.getParameter("batchId"));

        AssignmentDao assignmentDao = new AssignmentDao();

        boolean success = assignmentDao.assignExamToBatch(examId,batchId);

        if (success) {
            response.sendRedirect("/batch?status=exam_assigned");
        } else {
            response.sendRedirect("/exam/assign?error=assignment_failed");
        }
    }
}