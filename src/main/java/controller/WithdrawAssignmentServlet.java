package controller;

import dao.AssignmentDao;
import dao.ExamDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/exam/withdraw")
public class WithdrawAssignmentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null) {
            int assignmentId = Integer.parseInt(idParam);
            AssignmentDao dao = new AssignmentDao();

            boolean success = dao.withdrawAssignment(assignmentId);

            if (success) {
                response.sendRedirect("/assignments?status=withdrawn");
            } else {
                response.sendRedirect("/assignments?error=withdraw_failed");
            }
        } else {
            response.sendRedirect("/assignments");
        }
    }
}