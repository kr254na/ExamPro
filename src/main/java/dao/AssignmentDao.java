package dao;

import model.Exam;
import model.ExamAssignment;
import util.ProdDbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDao {

    public boolean assignExamToBatch(int examId, int batchId) {
        String sql = "INSERT INTO batch_exams (exam_id, batch_id) VALUES (?, ?)";
        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ps.setInt(2, batchId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if(e.getErrorCode() == 1062) return true;
            e.printStackTrace();
            return false;
        }
    }

    public List<ExamAssignment> getAssignmentsByTeacher(int teacherId) {
        List<ExamAssignment> list = new ArrayList<>();
        String sql = "SELECT be.assignment_id, b.batch_name, e.exam_title, be.assigned_at " +
                "FROM batch_exams be " +
                "JOIN batches b ON be.batch_id = b.batch_id " +
                "JOIN exams e ON be.exam_id = e.exam_id " +
                "WHERE b.teacher_id = ? " +
                "ORDER BY be.assigned_at DESC";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExamAssignment examAssignment = new ExamAssignment();
                examAssignment.setAssignmentId(rs.getInt("assignment_id"));
                examAssignment.setBatchName(rs.getString("batch_name"));
                examAssignment.setExamTitle(rs.getString("exam_title"));
                examAssignment.setAssignedAt(rs.getTimestamp("assigned_at"));
                list.add(examAssignment);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Exam> getAssignmentsByBatch(int batchId, int studentId) {
        List<Exam> list = new ArrayList<>();

        String sql = "SELECT e.*, r.result_id, be.assigned_at, " +
                "(SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.exam_id) as q_count " +
                "FROM batch_exams be " +
                "JOIN exams e ON be.exam_id = e.exam_id " +
                "LEFT JOIN results r ON e.exam_id = r.exam_id AND r.student_id = ? " +
                "WHERE be.batch_id = ? " +
                "ORDER BY be.assigned_at DESC";

        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2,batchId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamId(rs.getInt("exam_id"));
                exam.setExamTitle(rs.getString("exam_title"));
                exam.setSubjectName(rs.getString("subject_name"));
                exam.setDuration(rs.getInt("duration_minutes"));
                exam.setQuestionCount(rs.getInt("q_count"));
                int resultId = rs.getInt("result_id");
                exam.setCompleted(resultId > 0);
                list.add(exam);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching batch assignments: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean withdrawAssignment(int assignmentId) {
        String sql = "DELETE FROM batch_exams WHERE assignment_id = ?";
        try (Connection conn = ProdDbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
