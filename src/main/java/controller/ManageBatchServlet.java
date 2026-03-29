package controller;

import dao.BatchDao;
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

@WebServlet("/batch")
public class ManageBatchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User currentTeacher = (User) session.getAttribute("user");
        BatchDao batchDao = new BatchDao();
        List<Batch> batches = batchDao.getBatchesByTeacher(currentTeacher.getId());
        request.setAttribute("myBatches",batches);
        request.getRequestDispatcher("manage-batches.jsp").forward(request,response);
    }
}
