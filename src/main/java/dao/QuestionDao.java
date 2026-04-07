package dao;

import model.Question;
import util.ProdDbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao {
    public List<Question> getQuestions(int limit){
        List<Question> questions = new ArrayList<>();
        String sql = "Select * from questions order by rand() limit ?";
        try(Connection connection = ProdDbConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1,limit);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Question question = new Question();
                question.setId(rs.getInt("question_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOptionA(rs.getString("option_a"));
                question.setOptionB(rs.getString("option_b"));
                question.setOptionC(rs.getString("option_c"));
                question.setOptionD(rs.getString("option_d"));
                question.setSubjectId(Integer.parseInt(rs.getString("subject_id")));
                question.setCorrectAnswer(rs.getString("correct_option"));
                question.setCreatedBy(rs.getInt("created_by"));
                questions.add(question);
            }
        }
        catch(SQLException e){
            System.err.println("Error fetching questions: " + e.getMessage());
        }
        return questions;
    }

    public Question getQuestionById(int id) {
        Question q = null;
        String sql = "SELECT * FROM questions WHERE question_id = ?";
        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                q = new Question();
                q.setId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setCorrectAnswer(rs.getString("correct_option"));
                q.setSubjectId(rs.getInt("subject_id"));
                q.setCreatedBy(rs.getInt("created_by"));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching question: "+e.getMessage());
        }
        return q;
    }

    public List<Question> getQuestionsByTeacher(int teacherId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE created_by = ?";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setSubjectId(rs.getInt("subject_id"));
                q.setCreatedBy(teacherId);
                q.setCorrectAnswer(rs.getString("correct_option"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                list.add(q);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getQuestionCountByTeacher(int teacherId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM questions WHERE created_by = ?";
        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean addQuestion(Question q) {
        String sql = "INSERT INTO questions" +
                "(question_text, option_a, option_b, option_c, option_d, correct_option, created_by, subject_id)" +
                " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectAnswer());
            ps.setInt(7,q.getCreatedBy());
            ps.setInt(8,q.getSubjectId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error adding question : "+e.getMessage());
            return false;
        }
    }

    public boolean updateQuestion(Question q) {
        String sql = "UPDATE questions SET question_text=?, option_a=?, option_b=?, " +
                "option_c=?, option_d=?, correct_option=?, subject_id=? " +
                "WHERE question_id=?";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            SubjectDao subjectDao = new SubjectDao();
            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectAnswer());
            ps.setInt(7, q.getSubjectId());
            ps.setInt(8, q.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.out.println("Error updating question : "+e.getMessage());
            return false;
        }
    }

    public boolean deleteQuestion(int id) {
        String sql = "DELETE FROM questions" +
                " where question_id=?";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleting question : "+e.getMessage());
            return false;
        }
    }

}
