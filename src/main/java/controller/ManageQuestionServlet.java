package controller;

import dao.QuestionDao;
import dao.SubjectDao;
import dto.QuestionDto;
import model.Question;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/manage-questions")
public class ManageQuestionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        User currentTeacher = (User) session.getAttribute("user");
        QuestionDao questionDao = new QuestionDao();
        List<Question> questions = questionDao.getQuestionsByTeacher(currentTeacher.getId());
        List<QuestionDto> questionDtos = Question.mapQuestionsToQuestionDtos(questions);
        session.setAttribute("questions",questionDtos);
        req.getRequestDispatcher("manage-questions.jsp").forward(req, res);
    }
}
