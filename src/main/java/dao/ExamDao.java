package dao;

import model.Exam;
import model.Question;
import util.DbConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDao {

    public boolean createExam(Exam exam) throws SQLException {
        Connection conn = null;
        PreparedStatement psExam = null;
        PreparedStatement psMapping = null;
        boolean success = false;

        String examSql = "INSERT INTO exams " +
                "(exam_title, subject_name, duration_minutes, teacher_id) VALUES (?, ?, ?, ?)";
        String mappingSql = "INSERT INTO exam_questions" +
                "(exam_id, question_id) VALUES (?, ?)";

        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            psExam = conn.prepareStatement(examSql, Statement.RETURN_GENERATED_KEYS);
            psExam.setString(1, exam.getExamTitle());
            psExam.setString(2, exam.getSubjectName());
            psExam.setInt(3, exam.getDuration());
            psExam.setInt(4, exam.getTeacherId());
            psExam.executeUpdate();

            ResultSet rs = psExam.getGeneratedKeys();
            int newExamId = 0;
            if (rs.next()) {
                newExamId = rs.getInt(1);
            }

            psMapping = conn.prepareStatement(mappingSql);
            for (Integer qId : exam.getQuestionIds()) {
                psMapping.setInt(1, newExamId);
                psMapping.setInt(2, qId);
                psMapping.addBatch();
            }
            psMapping.executeBatch();

            conn.commit();
            success = true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            conn.close();
            psExam.close();
            psMapping.close();
        }
        return success;
    }

    public List<Exam> getExamsByTeacher(int teacherId) {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT e.*, " +
                "(SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.exam_id) AS q_count " +
                "FROM exams e WHERE e.teacher_id = ? ORDER BY e.created_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamId(rs.getInt("exam_id"));
                exam.setExamTitle(rs.getString("exam_title"));
                exam.setSubjectName(rs.getString("subject_name"));
                exam.setDuration(rs.getInt("duration_minutes"));
                exam.setCreatedAt(rs.getTimestamp("created_at"));

                exam.setQuestionCount(rs.getInt("q_count"));

                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    public int getTotalExamsCountByTeacher(int teacherId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM exams WHERE teacher_id = ?";
        try (Connection conn = DbConnection.getConnection();
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

    public Exam getExamById(int examId) {
        Exam exam = null;
        String sql = "SELECT e.*, " +
                "(SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.exam_id) AS q_count " +
                "FROM exams e WHERE e.exam_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exam = new Exam();
                exam.setExamId(rs.getInt("exam_id"));
                exam.setExamTitle(rs.getString("exam_title"));
                exam.setSubjectName(rs.getString("subject_name"));
                exam.setDuration(rs.getInt("duration_minutes"));
                exam.setTeacherId(rs.getInt("teacher_id"));
                exam.setCreatedAt(rs.getTimestamp("created_at"));
                exam.setQuestionCount(rs.getInt("q_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exam;
    }
    public boolean updateExam(Exam exam) throws SQLException {
        Connection conn = null;
        PreparedStatement psUpdateExam = null;
        PreparedStatement psDeleteOld = null;
        PreparedStatement psInsertNew = null;
        boolean success = false;

        String updateExamSql = "UPDATE exams SET exam_title=?, subject_name=?, duration_minutes=? WHERE exam_id=?";
        String deleteOldSql = "DELETE FROM exam_questions WHERE exam_id=?";
        String insertNewSql = "INSERT INTO exam_questions (exam_id, question_id) VALUES (?, ?)";

        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            psUpdateExam = conn.prepareStatement(updateExamSql);
            psUpdateExam.setString(1, exam.getExamTitle());
            psUpdateExam.setString(2, exam.getSubjectName());
            psUpdateExam.setInt(3, exam.getDuration());
            psUpdateExam.setInt(4, exam.getExamId());
            psUpdateExam.executeUpdate();

            psDeleteOld = conn.prepareStatement(deleteOldSql);
            psDeleteOld.setInt(1, exam.getExamId());
            psDeleteOld.executeUpdate();

            psInsertNew = conn.prepareStatement(insertNewSql);
            for (Integer qId : exam.getQuestionIds()) {
                psInsertNew.setInt(1, exam.getExamId());
                psInsertNew.setInt(2, qId);
                psInsertNew.addBatch();
            }
            psInsertNew.executeBatch();

            conn.commit();
            success = true;

        } catch (SQLException e) {
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
        } finally {
            psUpdateExam.close();
            psDeleteOld.close();
            psInsertNew.close();
            conn.close();
        }
        return success;
    }

    public boolean deleteExam(int examId) {
        String sql = "DELETE FROM exams WHERE exam_id = ?";
        boolean success = false;
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<Question> getQuestionsByExamId(int examId) {
        List<Question> questions = new ArrayList<>();

        String sql = "SELECT q.* FROM questions q " +
                "INNER JOIN exam_questions eq ON q.question_id = eq.question_id " +
                "WHERE eq.exam_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("question_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setCorrectAnswer(rs.getString("correct_option"));
                questions.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
}