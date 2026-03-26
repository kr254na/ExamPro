package controller;

import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        String role = req.getParameter("role");

        User newUser = new User();
        newUser.setUsername(user);
        newUser.setPassword(pass);
        newUser.setRole(role);

        UserDao userDao = new UserDao();

        boolean isSuccess = userDao.register(newUser);

        if (isSuccess) {
            res.sendRedirect("login.jsp?registered=true");
        } else {
            res.sendRedirect("register.jsp?error=exists");
        }
    }
}