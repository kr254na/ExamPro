package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class LocalDbConnection {
    private static Connection connection = null;
    public static Connection getConnection(){
        try{
            if(connection == null || connection.isClosed()){
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/exam_system",
                        "root","Krishna");
            }
        } catch (SQLException e) {
            System.err.println("Db Connection Failure: " + e.getMessage());
        }
        return connection;
    }
}
