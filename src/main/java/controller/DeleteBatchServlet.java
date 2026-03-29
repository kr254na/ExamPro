package controller;

import dao.BatchDao;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import javax.servlet.ServletException;

@WebServlet("/batch/delete")
public class DeleteBatchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int batchId = Integer.parseInt(idParam);
                BatchDao dao = new BatchDao();

                if (dao.deleteBatch(batchId)) {
                    response.sendRedirect("/batch?status=deleted");
                } else {
                    response.sendRedirect("/batch?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("/batch?error=invalid_id");
            }
        } else {
            response.sendRedirect("/batch");
        }
    }
}
