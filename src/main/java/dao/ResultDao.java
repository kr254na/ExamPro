package dao;

import util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ResultDao {

    public boolean insertResult(int studentId, int examId, int totalQuestions,
                                int correctAnswers, double percentage) {
        String sql = "INSERT INTO results (student_id, exam_id, total_questions, correct_answers, score_percentage) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, examId);
            ps.setInt(3, totalQuestions);
            ps.setInt(4, correctAnswers);
            ps.setDouble(5, percentage);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                System.out.println("Result already exists for Student ID: " + studentId + " and Exam ID: " + examId);
            } else {
                e.printStackTrace();
            }
            return false;
        }
    }

    public List<Map<String, Object>> getStudentResults(int studentId) {
        List<Map<String, Object>> resultList = new ArrayList<>();

        String sql = "SELECT r.*, e.exam_title, e.subject_name, b.batch_name " +
                "FROM results r " +
                "JOIN exams e ON r.exam_id = e.exam_id " +
                "JOIN batch_members sb ON r.student_id = sb.student_id " +
                "JOIN batches b ON sb.batch_id = b.batch_id " +
                "WHERE r.student_id = ? " +
                "ORDER BY r.submitted_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("examTitle", rs.getString("exam_title"));
                row.put("subjectName", rs.getString("subject_name"));
                row.put("total", rs.getInt("total_questions"));
                row.put("correct", rs.getInt("correct_answers"));
                row.put("percentage", rs.getDouble("score_percentage"));
                row.put("date", rs.getTimestamp("submitted_at"));
                row.put("batchName", rs.getString("batch_name"));
                resultList.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return resultList;
    }

    public List<Map<String, Object>> getResultsForTeacher(int teacherId, int filterBatchId, int filterExamId) {
        List<Map<String, Object>> results = new ArrayList<>();

        String sql = "SELECT r.*, u.username as student_name, e.exam_title, e.subject_name,b.batch_name " +
                        "FROM results r " +
                        "JOIN users u ON r.student_id = u.user_id " +
                        "JOIN exams e ON r.exam_id = e.exam_id " +
                        "JOIN batch_members sb ON u.user_id = sb.student_id " +
                        "JOIN batches b ON sb.batch_id = b.batch_id " +
                        "WHERE e.teacher_id = ? ";
        if(filterBatchId > 0){
            sql += " AND b.batch_id = ? ";
        }
        if (filterExamId > 0) {
            sql += " AND e.exam_id = ? ";
        }

        sql += "ORDER BY r.submitted_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, teacherId);
            if(filterBatchId>0)
            ps.setInt(2,filterBatchId);
            if(filterExamId>0)
            ps.setInt(3,filterExamId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentName", rs.getString("student_name"));
                map.put("examTitle", rs.getString("exam_title"));
                map.put("subjectName", rs.getString("subject_name"));
                map.put("batchName", rs.getString("batch_name"));
                map.put("correct", rs.getInt("correct_answers"));
                map.put("total", rs.getInt("total_questions"));
                map.put("percentage", rs.getDouble("score_percentage"));
                map.put("date", rs.getTimestamp("submitted_at"));
                results.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
}