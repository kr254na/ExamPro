package controller;

import dao.BatchDao;
import model.Batch;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/batch/view-students")
public class ViewBatchStudentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int batchId = Integer.parseInt(request.getParameter("id"));

        BatchDao batchDao = new BatchDao();

        Batch batch = batchDao.getBatchById(batchId);

        List<User> students = batchDao.getStudentsInBatch(batchId);

        request.setAttribute("batch", batch);
        request.setAttribute("students", students);

        request.getRequestDispatcher("/view-batch-students.jsp").forward(request, response);
    }
}