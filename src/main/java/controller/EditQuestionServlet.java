package controller;

import dao.QuestionDao;
import dao.SubjectDao;
import dto.QuestionDto;
import model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/edit")
public class EditQuestionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        Question q = new QuestionDao().getQuestionById(id);
        QuestionDto questionDto = Question.mapQuestionToQuestionDto(q);
        req.setAttribute("question", questionDto);
        SubjectDao subjectDao = new SubjectDao();
        req.setAttribute("subjects", subjectDao.getAllSubjects());
        req.getRequestDispatcher("edit-question.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String questionText = request.getParameter("questionText");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String correctAnswer = request.getParameter("correctAnswer");

            Question updatedQuestion = new Question();
            updatedQuestion.setId(id);
            updatedQuestion.setQuestionText(questionText);
            updatedQuestion.setOptionA(optionA);
            updatedQuestion.setOptionB(optionB);
            updatedQuestion.setOptionC(optionC);
            updatedQuestion.setOptionD(optionD);
            updatedQuestion.setSubjectId(subjectId);
            updatedQuestion.setCorrectAnswer(correctAnswer);

            dao.QuestionDao qDao = new dao.QuestionDao();
            boolean isUpdated = qDao.updateQuestion(updatedQuestion);

            if (isUpdated) {
                response.sendRedirect("/manage-questions?update=success");
            } else {
                response.sendRedirect("edit-question.jsp?id=" + id + "&error=failed");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
}