package controller;

import dao.BatchDao;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/batch/remove-student")
public class RemoveStudentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String batchIdStr = request.getParameter("batchId");
        String studentIdStr = request.getParameter("studentId");

        if (batchIdStr != null && studentIdStr != null) {
            try {
                int batchId = Integer.parseInt(batchIdStr);
                int studentId = Integer.parseInt(studentIdStr);

                BatchDao dao = new BatchDao();

                if (dao.removeStudentFromBatch(batchId, studentId)) {
                    response.sendRedirect("/batch/view-students?id=" + batchId + "&status=removed");
                } else {
                    response.sendRedirect("/batch/view-students?id=" + batchId + "&error=failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("/batch?error=invalid_params");
            }
        } else {
            response.sendRedirect("/batch");
        }
    }
}
