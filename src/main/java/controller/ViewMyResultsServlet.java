package controller;

import dao.ResultDao;
import model.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

@WebServlet("/student/results")
public class ViewMyResultsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        ResultDao dao = new ResultDao();
        List<Map<String, Object>> history = dao.getStudentResults(user.getId());

        request.setAttribute("history", history);
        request.getRequestDispatcher(request.getContextPath()+"/results-history.jsp")
                .forward(request, response);
    }
}