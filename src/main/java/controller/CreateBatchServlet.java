package controller;

import dao.BatchDao;
import model.Batch;
import model.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/batch/new")
public class CreateBatchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        request.getRequestDispatcher("/create-batch.jsp").forward(request,response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String batchName = request.getParameter("batchName");
        String batchCode = request.getParameter("batchCode");
        int teacherId = ((User) session.getAttribute("user")).getId();

        Batch newBatch = new Batch();
        newBatch.setBatchName(batchName);
        newBatch.setBatchCode(batchCode);
        newBatch.setTeacherId(teacherId);

        BatchDao dao = new BatchDao();
        if (dao.createBatch(newBatch)) {
            response.sendRedirect("/batch?success=batch_created");
        } else {
            response.sendRedirect("/create-batch.jsp?error=failed");
        }
    }
}
