package controller;

import dao.QuestionDao;
import model.Question;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentTeacher = (User) session.getAttribute("user");
        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String correctAnswer = request.getParameter("correctAnswer");

        Question newQuestion = new Question();
        newQuestion.setQuestionText(questionText);
        newQuestion.setOptionA(optionA);
        newQuestion.setOptionB(optionB);
        newQuestion.setOptionC(optionC);
        newQuestion.setOptionD(optionD);
        newQuestion.setSubjectId(subjectId);
        newQuestion.setCorrectAnswer(correctAnswer);
        newQuestion.setCreatedBy(currentTeacher.getId());

        QuestionDao questionDao = new QuestionDao();
        boolean isSaved = questionDao.addQuestion(newQuestion);

        if (isSaved) {
            response.sendRedirect("add-question.jsp?success=true");
        } else {
            response.sendRedirect("add-question.jsp?error=database");
        }
    }
}