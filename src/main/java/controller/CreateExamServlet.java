package controller;

import dao.ExamDao;
import dao.QuestionDao;
import dto.QuestionDto;
import model.Exam;
import model.Question;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/exam/new")
public class CreateExamServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            resp.sendRedirect("/login.jsp");
            return;
        }

        User currentTeacher = (User) session.getAttribute("user");
        QuestionDao questionDao = new QuestionDao();
        List<Question> questions = questionDao.getQuestionsByTeacher(currentTeacher.getId());
        List<QuestionDto> questionDtos = Question.mapQuestionsToQuestionDtos(questions);
        session.setAttribute("myQuestions",questionDtos);
        req.getRequestDispatcher("/create-exam.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String title = request.getParameter("examTitle");
        int duration = Integer.parseInt(request.getParameter("duration"));
        String subjectName = request.getParameter("subjectName");
        String[] questionIdsArray = request.getParameterValues("selectedQuestions");

        if (questionIdsArray == null || questionIdsArray.length == 0) {
            response.sendRedirect("/create-exam.jsp?error=no_questions");
            return;
        }

        try {
            User currentTeacher = (User) session.getAttribute("user");

            Exam newExam = new Exam();
            newExam.setExamTitle(title);
            newExam.setDuration(duration);
            newExam.setSubjectName(subjectName);
            newExam.setTeacherId(currentTeacher.getId());
            List<Integer> qList = new ArrayList<>();
            for (String id : questionIdsArray) {
                qList.add(Integer.parseInt(id));
            }
            newExam.setQuestionIds(qList);

            ExamDao examDao = new ExamDao();
            boolean isCreated = examDao.createExam(newExam);

            if (isCreated) {
                response.sendRedirect("/teacher-dashboard?examSuccess=true");
            } else {
                response.sendRedirect("/create-exam.jsp?error=db_fail");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("/create-exam.jsp?error=invalid_input");
        } catch (SQLException e) {
            response.sendRedirect("/create-exam.jsp?error=db_fail");
        }
    }
}
