package controller;

import dao.ExamDao;
import dao.QuestionDao;
import model.Exam;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/exam/update")
public class EditExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"TEACHER".equals(session.getAttribute("role"))) {
            response.sendRedirect("/login.jsp");
            return;
        }

        int examId = Integer.parseInt(request.getParameter("id"));
        int teacherId = ((model.User) request.getSession()
                .getAttribute("user"))
                .getId();

        ExamDao examDao = new ExamDao();
        QuestionDao qDao = new QuestionDao();

        request.setAttribute("exam", examDao.getExamById(examId));
        request.setAttribute("currentExamQuestions", examDao.getQuestionsByExamId(examId));
        request.setAttribute("fullBank", qDao.getQuestionsByTeacher(teacherId));

        request.getRequestDispatcher("/edit-exam.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int examId = Integer.parseInt(request.getParameter("examId"));
        String title = request.getParameter("examTitle");
        String subject = request.getParameter("subjectName");
        int duration = Integer.parseInt(request.getParameter("duration"));
        String[] selectedQuestions = request.getParameterValues("selectedQuestions");

        Exam exam = new Exam();
        exam.setExamId(examId);
        exam.setExamTitle(title);
        exam.setSubjectName(subject);
        exam.setDuration(duration);

        List<Integer> qIds = new ArrayList<>();
        if (selectedQuestions != null) {
            for (String id : selectedQuestions) {
                qIds.add(Integer.parseInt(id));
            }
        }
        exam.setQuestionIds(qIds);

        ExamDao dao = new ExamDao();
        try {
            if (dao.updateExam(exam)) {
                response.sendRedirect("/my-exams?status=updated");
            } else {
                response.sendRedirect("/exam/update?id=" + examId + "&error=fail");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}