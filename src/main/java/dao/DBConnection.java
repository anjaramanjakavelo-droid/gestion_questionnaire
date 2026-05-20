package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/examen?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
        try {
            // Compatible MySQL Connector/J 8+
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e1) {
            try {
                // Fallback pour anciennes versions
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException e2) {
                throw new SQLException(
                        "Driver MySQL introuvable. Ajoute mysql-connector-j dans le classpath du projet/Tomcat.",
                        e2
                );
            }
        }

        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new SQLException(
                    "Connexion MySQL impossible. Vérifie URL/user/password et que MySQL est démarré (XAMPP). URL=" + URL,
                    e
            );
        }
    }
}

