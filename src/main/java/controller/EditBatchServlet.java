package controller;

import dao.BatchDao;
import model.Batch;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/batch/edit")
public class EditBatchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null) {
            int batchId = Integer.parseInt(idParam);
            BatchDao dao = new BatchDao();
            Batch batch = dao.getBatchById(batchId);

            if (batch != null) {
                request.setAttribute("batch", batch);
                request.getRequestDispatcher("/edit-batch.jsp").forward(request, response);
            } else {
                response.sendRedirect("/batch?error=not_found");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int batchId = Integer.parseInt(request.getParameter("batchId"));
        String newName = request.getParameter("batchName");

        BatchDao dao = new BatchDao();
        if (dao.updateBatch(batchId, newName)) {
            response.sendRedirect("/batch?status=updated");
        } else {
            response.sendRedirect("/batch/edit?id=" + batchId + "&error=failed");
        }
    }
}
