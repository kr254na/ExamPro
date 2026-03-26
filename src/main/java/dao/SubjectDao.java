package dao;

import model.Subject;
import util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubjectDao {
    public List<Subject> getAllSubjects(){
        List<Subject> subjects = new ArrayList<>();
        String sql = "Select * from subjects";
        try(Connection connection = DbConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql)){
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                Subject subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectName(rs.getString("subject_name"));
                subjects.add(subject);
            }
        }
        catch(SQLException e){
            System.err.println("Error fetching subjects: " + e.getMessage());
        }
        return subjects;
    }

    public Subject getSubjectById(int id) {
        Subject subject = null;

        try(Connection connection = DbConnection.getConnection()) {
            String query = "SELECT * FROM subjects WHERE subject_id = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                subject = new Subject();
                subject.setSubjectId(rs.getInt("subject_id"));
                subject.setSubjectName(rs.getString("subject_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return subject;
    }
}
