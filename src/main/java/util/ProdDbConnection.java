package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ProdDbConnection {

    private static Connection connection = null;

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
           
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                } catch (ClassNotFoundException e) {
                    System.err.println("MySQL Driver not found in classpath!");
                    return null;
                }

                String url = System.getenv("DB_URL");
                String user = System.getenv("DB_USER");
                String pass = System.getenv("DB_PASSWORD");

                if (url != null && url.startsWith("mysql://")) {
                    url = "jdbc:" + url;
                }

                if (url == null || user == null || pass == null) {
                    System.err.println("Database environment variables are missing!");
                    return null;
                }

                connection = DriverManager.getConnection(url, user, pass);
                System.out.println("Connected to Aiven MySQL successfully!");
            }
        } catch (SQLException e) {
            System.err.println("Db Connection Failure: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected Error: " + e.getMessage());
        }
        return connection;
    }
}