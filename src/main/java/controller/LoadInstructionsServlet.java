package controller;

import dao.ExamDao;
import model.Exam;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/student/exam-instructions")
public class LoadInstructionsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String examIdStr = request.getParameter("id");
        if (examIdStr == null || examIdStr.isEmpty()) {
            response.sendRedirect("/student/dashboard");
            return;
        }

        try {
            int examId = Integer.parseInt(examIdStr);
            ExamDao dao = new ExamDao();

            Exam exam = dao.getExamById(examId);

            if (exam != null) {
                request.setAttribute("exam", exam);
                request.getRequestDispatcher("/exam-instructions.jsp").forward(request, response);
            } else {
                response.sendRedirect("/student/dashboard?error=exam_not_found");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("/student/dashboard");
        }
    }
}