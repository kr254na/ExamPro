package util;

import java.io.InputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ProdDbConnection {

    private static Connection connection = null;

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
               /* Properties props = new Properties();
                InputStream input = ProdDbConnection.class
                        .getClassLoader()
                        .getResourceAsStream("db.properties");
                if (input == null) {
                    throw new RuntimeException("db.properties file not found!");
                }
                props.load(input);
                connection = DriverManager.getConnection(props.getProperty("db.url"),
                        props.getProperty("db.username"),
                        props.getProperty("db.password"));*/
                connection = DriverManager.getConnection(
                        System.getenv("DB_URL"),
                        System.getenv("DB_USER"),
                        System.getenv("DB_PASSWORD")
                );
                System.out.println("Connected to Aiven MySQL successfully!");
            }
        } catch (Exception e) {
            System.err.println("Db Connection Failure: " + e.getMessage());
        }
        return connection;
    }
}