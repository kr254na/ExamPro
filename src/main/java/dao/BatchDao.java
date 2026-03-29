package dao;

import model.Batch;
import model.User;
import util.DbConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatchDao {

    public boolean createBatch(Batch batch) {
        String sql = "INSERT INTO batches (batch_name, batch_code, teacher_id) VALUES (?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();

             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, batch.getBatchName());
            ps.setString(2, batch.getBatchCode());
            ps.setInt(3, batch.getTeacherId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Batch> getBatchesByTeacher(int teacherId) {
        List<Batch> batches = new ArrayList<>();
        String sql = "SELECT b.*, (SELECT COUNT(*) FROM batch_members bm WHERE bm.batch_id = b.batch_id) as s_count " +
                "FROM batches b WHERE b.teacher_id = ? ORDER BY b.created_at DESC";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Batch b = new Batch();
                b.setBatchId(rs.getInt("batch_id"));
                b.setBatchName(rs.getString("batch_name"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setStudentCount(rs.getInt("s_count"));
                b.setTeacherId(teacherId);
                batches.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return batches;
    }

    public int getTotalBatchesCountByTeacher(int teacherId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM batches WHERE teacher_id = ?";

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

    public String joinBatch(int studentId, String batchCode) {
        String findBatchSql = "SELECT batch_id FROM batches WHERE batch_code = ?";
        String joinSql = "INSERT INTO batch_members (batch_id, student_id) VALUES (?, ?)";

        try (Connection conn = DbConnection.getConnection()) {
            int batchId = -1;
            try (PreparedStatement ps1 = conn.prepareStatement(findBatchSql)) {
                ps1.setString(1, batchCode);
                ResultSet rs = ps1.executeQuery();
                if (rs.next())
                    batchId = rs.getInt("batch_id");
            }

            if (batchId == -1)
                return "INVALID_CODE";

            try (PreparedStatement ps2 = conn.prepareStatement(joinSql)) {
                ps2.setInt(1, batchId);
                ps2.setInt(2, studentId);
                ps2.executeUpdate();
                return "SUCCESS";
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) return "ALREADY_JOINED"; // MySQL Duplicate Key error
            e.printStackTrace();
            return "ERROR";
        }
    }

    public boolean deleteBatch(int batchId) {
        String sql = "DELETE FROM batches WHERE batch_id = ?";
        boolean success = false;

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);

            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);

        } catch (SQLException e) {
            System.err.println("Error deleting batch: " + e.getMessage());
            e.printStackTrace();
        }
        return success;
    }

    public boolean updateBatch(int batchId, String newName) {
        String sql = "UPDATE batches SET batch_name = ? WHERE batch_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, batchId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Batch getBatchById(int batchId) {
        String sql = "SELECT * FROM batches WHERE batch_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, batchId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Batch b = new Batch();
                b.setBatchId(rs.getInt("batch_id"));
                b.setBatchName(rs.getString("batch_name"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setTeacherId(rs.getInt("teacher_id"));
                return b;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Batch> getBatchesByStudent(int studentId) {
        List<Batch> batches = new ArrayList<>();
        String sql = "SELECT b.*, u.username as teacher_name " +
                "FROM batches b " +
                "JOIN users u ON b.teacher_id = u.user_id " +
                "JOIN batch_members bm ON b.batch_id = bm.batch_id " +
                "WHERE bm.student_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Batch b = new Batch();
                b.setBatchId(rs.getInt("batch_id"));
                b.setBatchName(rs.getString("batch_name"));
                b.setBatchCode(rs.getString("batch_code"));
                b.setTeacherName(rs.getString("teacher_name"));
                batches.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return batches;
    }

    public List<User> getStudentsInBatch(int batchId) {
        List<User> students = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username " +
                "FROM users u " +
                "JOIN batch_members bm ON u.user_id = bm.student_id " +
                "WHERE bm.batch_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                students.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean removeStudentFromBatch(int batchId, int studentId) {
        String sql = "DELETE FROM batch_members WHERE batch_id = ? AND student_id = ?";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ps.setInt(2, studentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
