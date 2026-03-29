package controller;

import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        UserDao userDao = new UserDao();
        User loginUser = userDao.login(user, pass);

        if (loginUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", loginUser);
            session.setAttribute("role", loginUser.getRole());
            res.sendRedirect("/index.jsp");
        } else {
            res.sendRedirect("login.jsp?error=1");
        }
    }
}