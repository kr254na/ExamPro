package controller;

import dao.AssignmentDao;
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

@WebServlet("/student/batch-exams")
public class StudentBatchExamsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect("/student/dashboard?error=invalid_batch");
                return;
            }

            int batchId = Integer.parseInt(idParam);
            User user = (User) session.getAttribute("user");
            int studentId = user.getId();

            AssignmentDao assignmentDao = new AssignmentDao();
            List<Exam> batchExams = assignmentDao.getAssignmentsByBatch(batchId,studentId);
            request.setAttribute("exams", batchExams);
            request.setAttribute("currentBatchId", batchId);

            request.getRequestDispatcher("/student-batch-exams.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/student/dashboard?error=bad_request");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/student/dashboard?error=server_error");
        }
    }
}