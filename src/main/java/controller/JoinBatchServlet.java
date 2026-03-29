package controller;

import dao.BatchDao;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/student/join-batch")
public class JoinBatchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String batchCode = request.getParameter("batchCode");
        User student = (User) session.getAttribute("user");
        int studentId = student.getId();

        if (batchCode == null || batchCode.trim().isEmpty()) {
            response.sendRedirect("/student/dashboard?error=empty_code");
            return;
        }

        batchCode = batchCode.trim().toUpperCase();

        BatchDao dao = new BatchDao();
        String result = dao.joinBatch(studentId, batchCode);

        switch (result) {
            case "SUCCESS":
                response.sendRedirect("/student/dashboard?status=joined");
                break;
            case "INVALID_CODE":
                response.sendRedirect("/student/dashboard?error=not_found");
                break;
            case "ALREADY_JOINED":
                response.sendRedirect("/student/dashboard?error=already_member");
                break;
            default:
                response.sendRedirect("/student/dashboard?error=system_error");
                break;
        }
    }
}